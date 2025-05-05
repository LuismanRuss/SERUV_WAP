<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPARTICH" Codebehind="SAAPARTICH.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAAPARTICH = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAPARTICH[0] = [{ "bSortable": false }, null];
        Sort_SAAPARTICH[1] = [[1, "asc"]];

        function BotonesSAAPARTICH(selec) {//FUNCIÓN DE BOTONES
            if (selec > 0) {//pregunto si ya seleccione un registro en el grid y si ya seleccione el combo de procesos para habilitar "GUARDAR"
                $("#Btn_Guardar2").hide();
                $("#Btn_Guardar,#Btn_Cancelar").show();
            }
            else {// No Seleccionado
                $("#Btn_Guardar2, #Btn_Cancelar").show();
                $("#Btn_Guardar").hide();
            }
        }

        var arregloSeleccionadas = new Array(); //arreglo de las dependencias
        var nIdProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nIdProceso; //id del proceso

        function fAjax() {//FUNCIÓN QUE SE VA AL SERVIDOR Y REGRESA LAS DEPENDENCIAS QUE NO ESTÁN CONFIGURADAS EN UN PROCESO
            $.ajax(
                {
                    url: "Proceso/SAAPARTICH.aspx/pPinta_Grid",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        arregloSeleccionadas = []; //vacio el arreglo
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                });
        }

        $(document).ready(function () {
            $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sProceso + ' ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
            NG.setNact(3, 'Tres', BotonesSAAPARTICH);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            if (NG.Var[NG.Nact].oSets == null) {
                fAjax();
            } else {
                NG.repinta();
            }
        });

        function Pinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No hay dependencias disponibles." }
            if (cadena == null || cadena[1] == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena));//mando a llamar la función que pinta el grid
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAAPARTICH[1],
                "aoColumns": Sort_SAAPARTICH[0]
            });
        };


        function pTablaI(tab) {//función que pinta el grid con las dependencias
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:95%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";
            for (a_i = 1; a_i < tab.length; a_i++) {
                a_class = '';
                a_check = '';

                htmlTab += '<tr id="tr_' + a_i + '"' + a_class + '>';
                htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="checkbox"' + a_check + 'onclick="Selecciona(\'' + a_i + '\')" /></td>';

                htmlTab += '<td class="sorts">' + tab[a_i].strDDepcia + '</td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function Selecciona(actual) {//ESTA FUNCIÓN LLENA EL ARREGLO CON LAS DEPENDENCIAS QUE SE QUIEREN AGREGAR.
            BotonesSAAPARTICH(1);
            if ($('#ch_' + actual).is(':checked')) {//METO DEPENDENCIAS AL ARREGLO
                arregloSeleccionadas.push(NG.Var[NG.Nact].datos[actual].nDepcia);
                $('#tr_' + actual).addClass('row_selected');
            } else {//SACO DEPENDENCIAS AL ARREGLO
                $('#tr_' + actual).removeClass('row_selected');
                for (i = 0; i < arregloSeleccionadas.length; i++) {
                    if (arregloSeleccionadas[i] == NG.Var[NG.Nact].datos[actual].nDepcia) {
                        arregloSeleccionadas.splice(i, 1);
                    }
                }
            }
            if (arregloSeleccionadas.length == 0) {
                BotonesSAAPARTICH(0);
            }
        }

        function fActualizarGrid() {//FUNCIÓN QUE ACTUALIZA EL GRID
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            fAjax();
        }

        function fRegresar() {//ME REGRESA A LA FORMA ANTERIOR
            loading.ini();
            NG.setNact(2, 'Dos', null);
            urls(5, "Proceso/SAAPARTIC.aspx");
        }

        function fGuardar() {//FUNCIÓN QUE ARROJA VENTANA MODAL PARA GUARDAR LAS DEPENDENCIAS
            var objLst = NG.Var[NG.Nact].datos;
            var txt = '';

            txt = "¿Está seguro de incluir las siguientes dependencias / entidades a la entrega del proceso actual?:" + "</br></br>";
            for (i = 0; i < arregloSeleccionadas.length; i++) {
                txt += containsJsonObj(objLst, "nDepcia", arregloSeleccionadas[i]);
                txt += "</br>";
            }

            $("#dialog-confirm").empty();
            $("#dialog-confirm").append(txt);

            $(function () {
                $("#dialog-confirm").dialog({
                    resizable: false,
                    height: 300,
                    width: 700,
                    modal: true,
                    buttons: {
                        "Cancelar": function () {
                            $(this).dialog("close");
                        },
                        "Aceptar": function () {
                            loading.ini();
                            fGuardarAjax(arregloSeleccionadas);
                            $(this).dialog("close");
                        }
                    }
                });
            });
        }

        function containsJsonObj(objLst, name, value) {
            var nombreDependencia = '';
            $.each(objLst, function () {
                if (this[name] == value) {
                    nombreDependencia = this.strDDepcia;
                }
            });
            return nombreDependencia;
        };

        function fGuardarAjax(arregloSeleccionadas) {//FUNCIÓN QUE GUARDA LAS DEPENDENCIAS SELECCIONADAS
            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'sSeleccionadas': '" + arregloSeleccionadas +
                            "','nIdProceso': '" + nIdProceso +
                             "','nIdUsuario': '" + nIdUsuario +
                               "'}";

            $.ajax({
                url: "Proceso/SAAPARTICH.aspx/fIncluirDep",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = reponse.d;
                    switch (resp) {
                        case 0: //ERROR
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("No se pueden guardar los cambios.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                        case 1: //ACCIÓN REALIZADA CORRECTAMENTE.
                            fActualizarGrid();
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            BotonesSAAPARTICH(0);
                            break;
                    }
                },
                error: errorAjax
            });
        }
    </script>

    <form id="SAAPARTICH" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Agregar Dependencias / entidades</label>
            </div>
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>
            <br />

            <h2>Proceso entrega - recepción:</h2> <label id="lblProcER"></label> 
            <br />
            <div class="instrucciones">Seleccione una dependencia/entidad para realizar las acciones correspondientes:</div>
             
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div> 

            <div class="a_botones">
               <a id="Btn_Guardar" class="btnAct" title="Botón Guardar" href="javascript:fGuardar();">Guardar</a>                
                <a id="Btn_Cancelar" class="btnAct" title="Botón Cancelar" href="javascript:fRegresar();">Cancelar</a>             
            </div>
            <br /><br />
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>  
            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
            </div>

            <div id="dialog-confirm" title="SISTEMA ENTREGA-RECEPCIÓN">            
            </div>

        </div>   
    </form>
</body>
</html>
