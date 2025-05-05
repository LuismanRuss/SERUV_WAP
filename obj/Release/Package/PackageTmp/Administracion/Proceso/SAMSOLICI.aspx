<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAMSOLICI" Codebehind="SAMSOLICI.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAMSOLICI = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAMSOLICI[0] = [{ "bSortable": false }, null, null, null, null, null, null];
        //Sort_SAMSOLICI[1] = [[2, "asc"]];

        BotonesSolicitudes = function (selec) {
            if (selec > 0) { //Seleccionado
                $("#AccModificarEstado2, #AccDetalle2").hide();
                $("#AccModificarEstado, #AccDetalle").show();
            } else { //No Seleccionado
                $("#AccModificarEstado2, #AccDetalle2").show();
                $("#AccModificarEstado, #AccDetalle").hide();
            }
        }

        $(document).ready(function () {
            loading.close();
            NG.setNact(2, 'Dos', BotonesSolicitudes);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            if (NG.Var[NG.Nact].datoSel == null) {
                $('#grid').empty();
                ObtieneSolicitidudes();
            } else {
                NG.repinta();
            }
        });

        // Función para obtener el listado de las solicitudes de intervención
        function ObtieneSolicitidudes() {
            loading.ini();
            var strParametros = "{}";
            $.ajax({
                url: "Proceso/SAMSOLICI.aspx/Pinta_Grid",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                },
                error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        function Pinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen solicitudes configuradas." }
            //if (cadena.resultado == '2') {
            if (cadena == null || cadena == "") {
                loading.close();
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }

            $('#grid').append(pTablaI(cadena));

            //            a_di = new o_dialog('Ver Perfiles');
            //            a_di.iniDial(); 

            //            NG.tr_hover();
            //            tooltip.iniToolD('45%');

//            a_di = new o_dialog('VER PERFILES');
//            a_di.iniDial();
            NG.tr_hover();
            tooltip.iniToolD('45%');

            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                //"aaSorting": Sort_SAMSOLICI[1],
                "aoColumns": Sort_SAMSOLICI[0]
            });
            //NG.Var[NG.Nact].oTable = lTable;
            loading.close();
        }

        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort"  scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:6%;" class="sorting" title="Ordenar">Folio</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Puesto</th>';
            htmlTab += '<th scope="col" style="width:33%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Sujeto Obligado</th>';
            htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Sujeto Receptor</th>';
            htmlTab += '<th scope="col" style="width:4%;" class="sorting" title="Ordenar">Estatus</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="Cambia(\'' + a_i + '\')" /></td>';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="Cambia(\'' + a_i + '\')" /></td>';
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].cveSolProc + '</td>';

//                htmlTab += '<td class="sorts">' + tab[a_i].sPuesto + '</td>';
                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sPuesto + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sPuesto + '</div>';
                htmlTab += '</td>';

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sDependencia + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sDependencia + '</div>';
                htmlTab += '</td>';

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sNombreSO + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sNombreSO + '</div>';
                htmlTab += '</td>';
 
                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sNombreSR + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sNombreSR + '</div>';
                htmlTab += '</td>';

                if (tab[a_i].cIndActivo.toUpperCase() == 'S') {
                    htmlTab += '<td class="sorts Acen">' + 'ACTIVA' + '</td>';
                } else if (tab[a_i].cIndActivo.toUpperCase() == 'N') {
                    htmlTab += '<td class="sorts Acen">' + 'INACTIVA' + '</td>';
                }
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        // Función que cambia los valores del dato seleccionado en el grid.
        function Cambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        }

        // Función que realiza la pregunta si desea cambiar el estado de la solicitud
        function CambiarEstatus() {
            var strEstado1;

            if (NG.Var[NG.Nact].datoSel.cIndActivo.toUpperCase() == 'S') {
                strEstado1 = "INACTIVA";
                //strEstado2 = "INACTIVA";
            } else {
                strEstado1 = "ACTIVA";
                //strEstado2 = "ACTIVA";
            }
            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Desea cambiar el estatus de la solicitud a " + strEstado1 + "?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    fModificaEstado();
                }
            });
        }

        // Función que modifica el estado de la solicitud seleccionada
        function fModificaEstado() {
            loading.ini();
            var strParametros = "{'idSolicitud':'" + NG.Var[NG.Nact].datoSel.idSolProc + "'}";
            $.ajax({
                url: "Proceso/SAMSOLICI.aspx/ModificaEstado",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loading.close();
                    var resp = reponse.d
                    switch (resp) {
                        case 0:
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                        case 1:
                            if (NG.Var[NG.Nact].datoSel.cIndActivo == "S") {
                                NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo = "N";
                                NG.Var[NG.Nact].datoSel.cIndActivo = "N"
                            } else {
                                NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo = "S";
                                NG.Var[NG.Nact].datoSel.cIndActivo = "S"
                            }
                            NG.repinta();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("La disponibilidad de la solicitud se ha actualizado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                    }
                },
                error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        // Función que muestra toda la información de la solicitud seleccionada
        function fDetalle() {
            loading.ini();
            urls(5, "../Solicitud/SSASOLPRO.aspx");
        }

        // Función que muestra el reporte de todas la solicitudes de intervención
        function fReporte() {
            if (NG.Var[NG.Nact].datoSel == null) { // Si no existe una solicitud seleccionada, muestra el reporte con todas las solicitudes
                dTxt = '<div id="dComent" title="SERUV - Reporte">';
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?op=SOLICITUDES' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
                dTxt += '</div>';
                $('#SAMSOLICI').append(dTxt);
                $("#dComent").dialog({
                    autoOpen: true,
                    height: $(window).height() - 60, //800,
                    width: $("#agp_contenido").width() - 50, //1000,
                    modal: true,
                    resizable: true,
                    close: function (event, ui) {
                        fCerrarDialog();
                    }
                });
            } else { // Si no, muestra el reporte de la solicitud seleccionada
                dTxt = '<div id="dComent" title="SERUV - Reporte">';
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?strscveSolProc=' + NG.Var[NG.Nact].datoSel.cveSolProc +'&op=SOLICITUD' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
                dTxt += '</div>';
                $('#SAMSOLICI').append(dTxt);
                $("#dComent").dialog({
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
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        // Función que regresa al listado de procesos
        function fRegresar() {
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }

    </script>

    <form id="SAMSOLICI" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Solicitudes de Intervención</label>
            <div class="a_acciones">
                <a id="AccDetalle" title="Ver" href="javascript:fDetalle();" class="accAct iOculto">Ver</a>
                <a id="AccDetalle2" title="Ver" class="accIna">Ver</a>

                <a id="AccModificarEstado" title="Estatus" href="javascript:CambiarEstatus();" class="accAct iOculto">Estatus</a>
                <a id="AccModificarEstado2" title="Estatus" class="accIna">Estatus</a>

                <a id="AccReporte" title="Reporte" href="javascript:fReporte();" class="accAct">Reporte</a>
                <%--<a id="AccReporte2" title="Reporte" class="accIna">Reporte</a>--%>
            </div>
        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>
        <br />

        <div class="instrucciones">Seleccione una solicitud para realizar la acción correspondiente.</div>

        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarB','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarB" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>
        <br />

    </div>
    </form>
</body>
</html>
