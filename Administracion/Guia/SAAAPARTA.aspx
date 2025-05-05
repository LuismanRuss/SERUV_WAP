<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAAPARTA" Codebehind="SAAAPARTA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">

        var strAccion; // Variable de strAccion
        var intIDGuia; // id de la Guia
        var intIDApartado; //id del apartado seleccionado
        var strDescApartado; //descripcion del Apartado Seleccionado
        var strCadena = "";

        /***********     Fin ready     ***********/

        var Sort_SAAAPARTA = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAAPARTA[0] = [{ "bSortable": false }, null, null, null, null];
        Sort_SAAAPARTA[1] = [[3, "asc"]];

        /***********     Botones de Accion     ***********/

        BotonesApartados = function (selec) {
            if (selec > 0) //Seleccionado 
            {
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccAsignarAnexos, #AccReportes").show();
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccAsignarAnexos2, #AccReportes2").hide();
            }
            else //No Seleccionado
            {
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccAsignarAnexos2, #AccReportes2").show();
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccAsignarAnexos, #AccReportes").hide();
            }
        }

        /***********     Document ready     ***********/

        $(document).ready(function () {
            NG.setNact(2, 'Dos', BotonesApartados);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            //console.log(NG);
            $("#lbl_Guia").text(NG.Var[NG.Nact - 1].datoSel.strDGuiaER.toUpperCase());
            //console.log(NG.Var[NG.Nact - 1].datoSel);
            intIDGuia = NG.Var[NG.Nact - 1].datoSel.idGuiaER;
            //console.log(intIDGuia);

            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            if (NG.Var[NG.Nact].datoSel == null) {
                $('#grid').empty();
                fGetApartados();

            } else {
                
                if (NG.Var[NG.Nact].repinta == "N") {                                      
                    $('#grid').empty();
                    fGetApartados();
                    NG.Var[NG.Nact].repinta = null;
                }
                if (NG.Var[NG.Nact].repinta == "S") {
                    NG.repinta();
                    NG.Var[NG.Nact].repinta = null;
                }
            }
        });

        /***********     Función Ajax para Obtener los Apartados     ***********/

        //Función que obtiene la lista de Apartados de la Base de Datos
        function fGetApartados() {
            var strDatos = "{" +
                                "\"strAccion\": \"APARTADOS\" " + ",\"idGuiaER\": " + intIDGuia +
                                "}";

            objApartados = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objApartados: objApartados });
            //console.log(actionData);

            $.ajax(
                {
                    url: "Guia/SAAAPARTA.aspx/pGetDatosApartados",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(eval('(' + reponse.d + ')'));
                        Pinta_Grid(eval('(' + reponse.d + ')'));

                        strCadena = eval('(' + reponse.d + ')')
                        
                        if (strCadena.liApartados != null && NG.Var[NG.Nact].datoSel != null) {
                            //Con esto actualizamos el dato selccionado del GRID
                            a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
                            NG.Var[NG.Nact].datoSel = eval('(' + a_jp + ')')
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        /***********     Fin Función Ajax Obtener Apartados    ***********/


        /***********     Función Pintar Grid Apartados     ***********/

        //Función para asignar las propiedades del DataTable
        function Pinta_Grid(strCadena) {
            //console.log(strCadena);
            $('#grid').empty();            
            mensaje = { "mensaje": "No existen apartados configurados." }
            if (strCadena.liApartados == null) {
                //alert("if");
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            else {
                //alert("else");
                $('#grid').append(pTablaI(strCadena.liApartados));
            }

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAAAPARTA[1],
                "aoColumns": Sort_SAAAPARTA[0]
            });
        }


        /***********     Fin Función Pintar Grid Guias    ***********/

        //Función para Pintar la Tabla de Apartados
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            //console.log(tab);
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort Acen" scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting Acen" title="Ordenar">Código</th>';
            htmlTab += '<th scope="col" style="width:60%;" class="sorting Acen" title="Ordenar">Nombre</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting Acen" title="Ordenar">Orden</th>';
            htmlTab += '<th scope="col" style="width:20%;" class="sorting Acen" title="Ordenar">Aplica</th>';

            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            //Ciclo de Control para Checkbox
            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';

                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].strApartado.toUpperCase() + '</td>';

                htmlTab += '<td class="sorts">' + tab[a_i].strDescApartado.toUpperCase() + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].intnOrden + '</td>';

                if (tab[a_i].chrAplica == 'O') {
                    htmlTab += '<td class="sorts Acen">' + 'SUJETO OBLIGADO' + '</td>';
                }
                if (tab[a_i].chrAplica == 'C') {
                    htmlTab += '<td class="sorts Acen">' + 'CONTRALORÍA' + '</td>';
                }

            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }

        //Función Ajax para Eliminar un Apartado de la Base de Datos
        function pEliminar_Apartado() {

            //var valorId = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idApartado;
            //var valorDescripcion = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strDescApartado;
            intIDGuia = NG.Var[NG.Nact].datoSel.idGuiaER;
            intIDApartado = NG.Var[NG.Nact].datoSel.idApartado;
            strDescApartado = NG.Var[NG.Nact].datoSel.strDescApartado;

            strAccion = "ELIMINAR";
            $.alerts.dialogClass = "infoConfirm";
            jConfirm('El apartado: ' + strDescApartado + ' será eliminado \n\n¿Esta seguro que desea eliminarlo?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    
                    var strDatos = "{'strAccion': '" + strAccion +
                                   "','idGuiaER': '" + intIDGuia +
                                   "','idApartado': '" + intIDApartado +
                                   "','intNumUsuario': '" + $('#hf_idUsuario').val() +
                                   "'}";

                    objApartados = eval('(' + strDatos + ')');
                    actionData = frms.jsonTOstring({ objApartados: objApartados });
                    // console.log(actionData);
                    loading.ini();
                    $.ajax(
                    {
                        url: "Guia/SAAAPARTA.aspx/fEliminar_Apartado",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            switch (reponse.d) {
                                case 1:
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("El apartado se ha eliminado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        $('#grid').empty();
                                        NG.Var[NG.Nact].oTable.fnDestroy();
                                        fCambia(NG.Var[NG.Nact].selec);
                                        fGetApartados();
                                    });
                                    break;
                                case 2:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede eliminar el apartado actual, ya que tiene anexos asignados, elimine primero los anexos.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        //$('#grid').empty();
                                        //NG.Var[NG.Nact].oTable.fnDestroy();
                                        //fCambia(NG.Var[NG.Nact].selec);
                                        //fGetApartados();
                                    });
                                    break;
                                case 3:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede eliminar el apartado actual, ya que tiene participantes activos asignados con ese apartado.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        //$('#grid').empty();
                                        //NG.Var[NG.Nact].oTable.fnDestroy();
                                        //fCambia(NG.Var[NG.Nact].selec);
                                        //fGetApartados();
                                    });
                                    break;
                                case 0:
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                        fGetApartados();
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
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });  // FIN DEL AJAX


                }
                else {

                }
            });          // FIN DEL jConfirm           
        }

        //Función para Cambiar la Seleccion de un Radio Button 
        function fCambia(selc) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selc);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            //console.log(NG.Var[NG.Nact].datoSel);
            //console.log(NG);
        };

        //Función para Actualizar el Grid de Apartados
        function fActualizarGrid() {
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            //NG.repinta();
            fGetApartados();
        }

        //Función para ir a la forma de Alta Apartados
        function fApartado() {
            urls(3, "Guia/SAAAPARTAH.aspx");
        }

        //Función para ir a la forma Principal de Anexos
        function fAnexos() {
            urls(3, "Guia/SAAANEXOS.aspx");
        }

        //Función para regresar a la forma principal de Guías
        function fRegresar() {
            NG.Var[NG.Nact - 1].repinta = "S";
            urls(3, "Guia/SAAGUIAER.aspx");
        }

        //Función para abrir el reporte de Apartados
        function Reporte(op) {
            $("#hf_operacion").val(op);
            intIDApartado = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idApartado;
            //console.log(hf_operacion);
            //alert("1");
            dTxt = '<div id="dComent2" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idApartado=' + intIDApartado + '&op=APARTADOS' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SAAAPARTA').append(dTxt);
            $("#dComent2").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //700,
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
            $('#dComent2').dialog("close");
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
        }

    </script>

    <form id="SAAAPARTA" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Apartados</label>
                <div class="a_acciones">
                    <a id="AccAgregar" title="Agregar" href="Javascript:fApartado();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                    <a id="AccModificar" title="Modificar" href="Javascript:fApartado();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                    <a id="AccEliminar" title="Eliminar" href="javascript:pEliminar_Apartado();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>
            
                    <a id="AccAsignarAnexos" title="Asignar anexos" href="javascript:fAnexos();" class="accAct iOculto">Asignar anexos</a>
                    <a id="AccAsignarAnexos2" title="Asignar aAnexos" class="accIna">Asignar anexos</a>

                    <a id="AccReportes" title="Reportes de anexos por apartado" href="javascript: Reporte('APARTADOS');" class="accAct iOculto">Reporte</a>                                                   
                    <a id="AccReportes2" title="Reportes de anexos por apartado" class="accIna">Reporte</a>
                    
                    <asp:HiddenField ID="hf_idUsuario" runat="server" />
                    <asp:HiddenField ID="hf_operacion" runat="server" />
                </div>
            </div>
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

            <div class="instrucciones">Seleccione un apartado para realizar la acción correspondiente.</div>

            <h2>Guía:</h2> <label id="lbl_Guia"></label>
        
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
