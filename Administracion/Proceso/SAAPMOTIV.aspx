<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPMOTIV" Codebehind="SAAPMOTIV.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%--<script src="../scripts/Libreria.js" type="text/javascript"></script>--%>


</head>
<body>
    <script type="text/javascript">
        var strAccion = ""; // Variable de Acción
        var intSeleccionado; //Permitirá reasignar los datos al radio button
        var strCadena = "";

        var Sort_SAAPMOTIV = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAPMOTIV[0] = [{ "bSortable": false }, null, null];
        Sort_SAAPMOTIV[1] = [[2, "asc"]];

        /***********     Botones de Acción     ***********/

        BotonesMotivosER = function (selec) {
            if (selec > 0) //Seleccionado 
            {
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccReporte2").show();
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccReporte").hide();



            }
            else //No Seleccionado
            {
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccReporte").show();
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccReporte2").hide();


            }
        }

        /***********     Document ready     ***********/
        $(document).ready(function () {
            NG.setNact(2, 'Dos', BotonesMotivosER);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                       
            if (NG.Var[NG.Nact].datoSel == null) {
                $('#grid').empty();
                fGetMotivos();
            } else {
                NG.repinta();
            }
        });
        /***********     Fin ready     ***********/

        
        /***********     Función Ajax Obtener Motivos    ***********/
        //Función Ajax que obtiene la Lista de Motivos de la Base de Datos
        function fGetMotivos() {
            var strDatos = "{" +
                        "\"strACCION\": \"OBTENER_MOT_PROC2\" " +
                        "}";
            objMotivos = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objMotivos: objMotivos });

            $.ajax(
            {
            url: "Proceso/SAAPMOTIV.aspx/pGetDatosMotivos",
            data: actionData,
            dataType: "json",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function (reponse) {
                //console.log(eval('(' + reponse.d + ')'));
                Pinta_Grid(eval('(' + reponse.d + ')'));

                //strCadena = eval('(' + reponse.d + ')');

                /*
                Pendiente con Motivos!!!

                if (strCadena.laMotivoProceso != null && NG.Var[NG.Nact].datoSel != null) {
                //Con esto actualizamos el dato selccionado del GRID
                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                }
                */
            },
            beforeSend: loading.ini(),
            complete: loading.close(),
            error: errorAjax
        });
        }
        /***********     Fin Función Ajax Obtener Motivos   ***********/



        /***********     Función Pintar Grid Motivos    ***********/
        //Función para asignar las Propiedades de el DataTable de Motivos
        function Pinta_Grid(strCadena) {
            $('#grid').empty();

            mensaje = { "mensaje": "No existen Motivos configurados." }
            if (strCadena.laMotivoProceso == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(strCadena.laMotivoProceso));

            NG.tr_hover();
            tooltip.iniToolD('25%');
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                                        "sPaginationType": "full_numbers",
                                        "bLengthChange": true,
                                        "aaSorting": Sort_SAAPMOTIV[1],
                                        "aoColumns": Sort_SAAPMOTIV[0]
                                    });
        }
        /***********     Fin Función Pintar Grid Guias    ***********/


        //Función para Pintar la Tabla de Motivos
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort"  scope="col" style="width:4%;"></th>';
            htmlTab += '<th  scope="col" style="width:75%;" class="sorting" title="Ordenar">Descripción</th>';
            htmlTab += '<th  scope="col" style="width:15%;" class="sorting" title="Ordenar">Tipo de Motivo</th>';

            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            //Ciclo de Control para Checkbox
            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i && NG.Var[NG.Nact].datoSel != null) {
                    //alert("igual");
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
                    intSeleccionado = tab[a_i].idMotiProc;
                } else {
                    //alert("distinto");
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                    //intSeleccionado = a_i;
                }

                htmlTab += '<td class="sorts">' + tab[a_i].strSDMotiProc.toUpperCase() + '</td>';

                if (tab[a_i].cTipoMot == 'o' || tab[a_i].cTipoMot == 'O') {
                    tab[a_i].cTipoMot = "ORDINARIA";
                }

                if (tab[a_i].cTipoMot == 'e' || tab[a_i].cTipoMot == 'E') {
                    tab[a_i].cTipoMot = "EXTRAORDINARIA";
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].cTipoMot + '</td>';
                htmlTab += '</td>';
                htmlTab += "</tr>";
            }
            htmlTab += "</tbody>";
            return htmlTab;
        }

        //Función para Cambiar la Selección de un Radio Button 
        function fCambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            //console.log(NG.Var[NG.Nact].datoSel);
            //console.log(NG);
        };

        //Función Ajax para Eliminar un Anexo de la Base de Datos
        function pEliminar_Motivos() {
            intValorID = NG.Var[NG.Nact].datoSel.idMotiProc;
            strValorDescripcion = NG.Var[NG.Nact].datoSel.strSDMotiProc;

            strAccion = "ELIMINAR";
            $.alerts.dialogClass = "infoConfirm";
            jConfirm('El Motivo: ' + strValorDescripcion + ' será eliminado \n\n¿Está seguro que desea eliminarlo?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {

                    var strDatos = "{'strAccion': '" + strAccion +
                                   "','idMotiProc': '" + intValorID +
                                   "','nUsuario': '" + $('#hf_idUsuario').val() +
                                   "'}";

                    objMotivos = eval('(' + strDatos + ')');
                    actionData = frms.jsonTOstring({ objMotivos: objMotivos });
                    // console.log(actionData);
                    loading.ini();
                    $.ajax(
                    {
                        url: "Proceso/SAAPMOTIV.aspx/fGetMotivosElimina",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {

                            switch (reponse.d) {
                                case 1:
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("El Motivo se ha eliminado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        $('#grid').empty();
                                        NG.Var[NG.Nact].oTable.fnDestroy();
                                        fCambia(NG.Var[NG.Nact].selec);
                                        fGetMotivos();
                                    });
                                    break;

                                case 0:
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                        fGetMotivos();
                                    });
                                    break;

                                default:
                            }

                        },
                        //beforeSend: loading.ini(),
                        //complete: loading.close(),
                        error: function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });  // FIN DEL AJAX
                }
                else {

                }
            });         // FIN DEL jConfirm           
        }


        //Función para ir a la forma de Alta Motivo
        function fMotivo() {
            urls(5, "Proceso/SAAPMOTIVH.aspx");
        }

        //Función para ir a la forma Principal de Proceso
        function fRegresar() {
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }

        //Función para visualizar el reporte
        function fReporte() {
            dTxt = '<div id="dComentR" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?op=MOTIVOS' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SAAPMOTIV').append(dTxt);
            $("#dComentR").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //800,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true,
                close: function (event, ui) {
                    fCerrarDialog();
                }
            });
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComentR').dialog("close");
            $("#dComentR").dialog("destroy");
            $("#dComentR").remove();
        }


    </script>

    <form id="SAAPMOTIV" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Motivos</label>
                <div class="a_acciones">
                    <a id="AccAgregar" title="Agregar" href="Javascript:fMotivo();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                    <a id="AccModificar" title="Modificar" href="Javascript:fMotivo();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                    <a id="AccReporte" title="Reporte" href="Javascript:fReporte();" class="accAct">Reporte</a>
                    <a id="AccReporte2" title="Reporte" class="accIna iOculto">Reporte</a>

<%--                    <a id="AccEliminar" title="Eliminar" href="javascript:pEliminar_Motivos();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>--%>

                    <asp:HiddenField ID="hf_idUsuario" runat="server" />

                    <input type="hidden" id="hf_IdGuiaER"/>

                </div>
            </div>

            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

            <div class="instrucciones">Seleccione un Motivo para realizar la acción correspondiente.</div>
        
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
            </div>

            <br />
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

        </div>

    </form>

</body>
</html>
