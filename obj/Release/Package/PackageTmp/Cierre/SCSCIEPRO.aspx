<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCSCIEPRO" Codebehind="SCSCIEPRO.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script src="../scripts/DataTables.js" type="text/javascript"></script> 
</head>
<body>
    <script type="text/javascript">
        var Sort_SSSMONPRO = new Array(2);
        Sort_SSSMONPRO[0] = [{ "bSortable": true }, null, null, null, null, null, null, null];
        Sort_SSSMONPRO[1] = [[2, "asc"]];
        var Procesos = null;
        var AvanceGeneral = null;
        var idProc = null;
        var cadena = null;

        //Esta función regresa los procesos en los que el usuario logueado está asignado como supervisor
        function fAjax() {
            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'nIdUsuario': '" + nIdUsuario +
                         "'}"; ;
            $.ajax({
                url: "SCSCIEPRO.aspx/pGetProceso",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Proceso(eval('(' + reponse.d + ')'));
                },
                beforeSend: loading.ini(),
                error: errorAjax
            });
        }

        function fgetAvanceProceso(nIdProceso) {//esta función regresa el avance del proceso, sus dependencias y sus respectivos avances, le paso el ID del proceso
            var actionData = "{'nIdProceso': '" + nIdProceso +
                         "'}"; ;
            $.ajax({
                url: "SCSCIEPRO.aspx/pPinta_Grid",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                },
                beforeSend: loading.ini(),
                error: errorAjax
            });
        }

        $(document).ready(function () {
            $("#lblPeriodo").text("Debe seleccionar un proceso para mostrar el avance general");
            if (NG.Nact == 0) {
                $("#lblPeriodo").hide();
                $("#lblPeriodos").hide();
                NG.setNact(1, 'Uno', null);
                fAjax();
            } else {
                fAjax();
                var idProc = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdProceso;
                var nombreProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].sDProceso;
                $("#txtProceso").val(nombreProceso);
                var selc = NG.Var[NG.Nact - 1].selc;
                NG.Var[NG.Nact].selec = selc;
                fgetAvanceProceso(idProc);
            }
        });


        function Pinta_Proceso(cadena) {
            var nombreProceso = null;
            var nIdProceso = null;

            if (cadena.length == 2) {//si el usuario está en un proceso se muestra por default en la forma
                nombreProceso = cadena[1].sDProceso;
                nIdProceso = cadena[1].nIdProceso;
                $("#ico_busqueda").hide();
                $("#txtProceso").val(nombreProceso);
                if (NG.Nact == 1) {
                    fgetAvanceProceso(nIdProceso);
                }
            } else if (cadena.length == 1) {//si el usuario no tiene procesos se muestra un msj en la forma de que no tiene procesos
                $("#txtProceso").hide();
                $("#ico_busqueda").hide();
                $("#lblProcesoER").hide();
                mensaje = { "mensaje": "Usted no cuenta con procesos a cerrar." }
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
            } else if (NG.Nact == 1) {//si el usuario tiene mas de un proceso como supervisor
                var id = 0;
                var numProceso = '0';

                //esta parte de la función me arroja el proceso mas nuevo para mostrarlo por default en la forma
                $.each(cadena, function () {
                    if (this['sProceso'] > numProceso) {
                        numProceso = this.sProceso;
                        id = this.nIdProceso;
                        nombreProceso = this.sProceso + ' ' + this.sDProceso;
                    } else {
                        numProceso = numProceso;
                        id = id;
                        nombreProceso = nombreProceso;
                    }
                });
                fgetAvanceProceso(id); //se manda a llamar la funcíón que me regresará el avance del proceso, sus dependencias y sus respectivos avances
                $('#hf_idProc').val(id); //edgar
                $("#txtProceso").val(nombreProceso);
            }
        }


        function Pinta_Grid(cadena) {//esta función pinta los el avance general del proceso y manda a llamar la función que pinta el grid
            var datosGrid = cadena.datos[1]; //datos del grid
            var periodo = cadena.datos[0]; //periodo del proceso

            fechaInicio = periodo[0].sFechaInicio; //fecha de inicio del proceso
            fechaFin = periodo[0].sFechaFinal; //fecha fin del proceso
            estadoProceso = periodo[0].sEstatus; //estado del proceso (Abierto, Cerrado)

            $("#lblPeriodo").text(fechaInicio + ' al ' + fechaFin);
            $("#lblPeriodos").show();
            $("#lblPeriodo").show();
            $("#lblEstadoProceso").text(estadoProceso == 'C' ? "CERRADO" : "ABIERTO");

            $('#grid').empty();
            mensaje = { "mensaje": "No existen periodos configurados." }
            if (datosGrid == null || datosGrid == "") {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }

            // si es que hay boton de cerrar proceso
            if (periodo[0].sEstatus == 'A') {
                $("#AccCerrarProc").show();
                $("#AccCerrarProc2").hide();
            } else {
                $("#AccCerrarProc").hide();
                $("#AccCerrarProc2").show();
            }

            $('#grid').append(pTablaI(datosGrid)); //se manda a llamar la función qur pinta el grid
            NG.tr_hover();
            tooltip.iniToolD('25%');
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({//prop
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SSSMONPRO[1],
                "aoColumns": Sort_SSSMONPRO[0]
            });
            loading.close();
        };


        function pTablaI(tab) {//función que pinta el grid
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th scope="col" style="width:45%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Avance general</th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Excluidos</th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Integrados</th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Pendientes</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Estado entrega</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Estado proceso</th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar"></th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                }
                htmlTab += '<td class="sorts"><a onclick="fDependencias(\'' + tab[a_i].nIdParticipante + '\',\'' + a_i + '\')\" style=\"cursor:pointer\">' + tab[a_i].sDDepcia + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].avanceGeneral.toFixed(2) + '%' + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].excluidos + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].integrados + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].pendientes + '</td>';

                if (tab[a_i].cIndEntrega == 'E') {
                    htmlTab += '<td class="sorts Acen">' + 'EN PROCESO' + '</td>';
                } else if (tab[a_i].cIndEntrega == 'C') {
                    htmlTab += '<td class="sorts Acen">' + 'CONCLUIDA' + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + 'OTRA' + '</td>';
                }

                if (tab[a_i].cIndCerrado == 'S') {
                    htmlTab += '<td class="sorts Acen">' + 'CERRADO' + '</td>';
                } else if (tab[a_i].cIndCerrado == 'N' || tab[a_i].cIndCerrado == '' || tab[a_i].cIndCerrado == 'N ') {
                    htmlTab += '<td class="sorts Acen">' + 'ABIERTO' + '</td>';
                }

                htmlTab += '<td class="sorts Acen"><a onclick="fSelecciona(\'' + a_i + '\')\" style=\"cursor:pointer\">' + '<img src="../images/icono-grafica.png" />' + '</td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function BuscarProceso() {//función que abre el dialog para buscar procesos
            a_tip = [
                    { tit: 'Buscar Proceso', arc: "SCCCIEPRO.aspx?cadena=" + Procesos }
                ];
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
            dTxt = '<div id="dComent2" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SCCCIEPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SCSCIEPRO').append(dTxt);
            $("#dComent2").dialog({
                autoOpen: true,
                height: 650,
                width: 970,
                modal: true,
                resizable: true
            });
        }

        function fDependencias(nIdParticipante, selc) {//esta función me manda a la forma de dependencia, le mando el ID participante y el seleccionado del grid
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            if (NG.Nact == 2) {
                NG.Var[NG.Nact - 1].selc = null;
                NG.Var[NG.Nact - 1].selc = selc;

                var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).removeClass('row_selected');
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).find('#ch_' + NG.Var[NG.Nact].selc).attr('checked', false);
                NG.Var[NG.Nact].selc = selc;
                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc]);
                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).addClass('row_selected');
            } else {
                var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).removeClass('row_selected');
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).find('#ch_' + NG.Var[NG.Nact].selc).attr('checked', false);
                NG.Var[NG.Nact].selc = selc;
                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc]);
                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).addClass('row_selected');
            }
            urls(5, "SCSCIEDEP.aspx");
        }


        function fn_cerrarPform(idproc, nomProc) {
            if (NG.Var[NG.Nact].oTable != null) {
                $('#grid').empty();
                NG.Var[NG.Nact].oTable.fnDestroy();
            }
            NG.setNact(1, 'Uno', null);
            fgetAvanceProceso(idproc);
            $('#dComent2').dialog("close");
            $("#txtProceso").val(nomProc);
            //-------------------------------------------
            //deselecciono
            $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
            NG.Var[NG.Nact].selec = 0;
            NG.Var[NG.Nact].datoSel = null;
            sel = false;
        }

        function fGrafica() {//función que me abre el dialog de las gráficas
            var pendientes = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].pendientes; //anexos pendientes de la dependencia
            var excluidos = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].excluidos; //anexos excluidos de la dependencia
            var integrados = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].integrados; //anexos integrados de la dependencia

            a_tip = [
                    { tit: 'Gráfica', arc: "../Monitoreo/SSCMONGRA.aspx?excluidos=" + excluidos + "&integrados=" + integrados + "&pendientes=" + pendientes }
                ];
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
            dTxt = '<div id="dComentGrafica" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SCSCIEPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SCSCIEPRO').append(dTxt);
            $("#dComentGrafica").dialog({
                autoOpen: true,
                height: 550,
                width: 970,
                modal: true,
                resizable: false
            });
        }

        function fSelecciona(selc) {//función que mantiene seleccionado el registro en el grid
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
            $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
            $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).find('#ch_' + NG.Var[NG.Nact].selec).attr('checked', false);

            NG.Var[NG.Nact].selec = selc;
            a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
            NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
            $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).addClass('row_selected');
            sel = true;

            fGrafica();
        }

        function CerrarVentAct() {//función que cierra el dialog de los anexos cuando el numero de anexos cambia, se pide al usuario que actualice su página
            $('#dComent').dialog("close");
            $.alerts.dialogClass = "incompletoAlert";
            jAlert("La información ha cambiado, porfavor actualice su página.", "SISTEMA DE ENTREGA - RECEPCIÓN");
        }

        function fCierreProceso() {//función que cierra el proceso
            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Está seguro que desea cerrar el proceso: " + 'taka' + "?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    var idProceso = NG.Var[NG.Nact].datos[1].nIdProceso;
                    var actionData = "{'idProceso': '" + idProceso +
                                    "','idParticipante': '" + 0 +
                                    "','strOpcion': '" + 'CPROCESO' +
                         "'}";
                    $.ajax({
                        url: "SCSCIEDEP.aspx/fCerrarProceso",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            var resp = reponse.d;

                            switch (resp) {
                                case 0:
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("No se pudo cerrar el proceso seleccionado.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                    break;
                                case 1:
                                    $("#AccCerrarProc").hide();
                                    $("#AccCerrarProc2").show();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("El proceso fué cerrado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                    break;
                                case 2:
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("El proceso no puede ser cerrado ya que aún existen dependencias abiertas.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                    break;
                            }
                        },
                        error: errorAjax
                    });
                }
            });
        }

        function fCerrarDialogG() {
            $('#dComentGrafica').dialog("close");
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
        }

        function fCerrarDialogBuscaProceso() {//función que cierra el dialog que busca procesos
            $('#dComent2').dialog("close");
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
        }

        function fReporte() {
            var idUsuario = $("#hf_idUsuario").val();
            dTxt = '<div id="dComentR" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?IdItem=' + idUsuario + '&op=SUPERVISORPROC' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SCSCIEPRO').append(dTxt);
            $("#dComentR").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //700,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true
            });
        }

    </script>
    <form id="SCSCIEPRO" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Cierre/Seguimiento</label>
            <div class="a_acciones">
                <a id="AccReporte" title="Reporte de procesos asignados al supervisor CG" href="javascript:fReporte();" class="accAct">Reporte</a>
            </div>
        </div>
        <div class="instrucciones">Seleccione un proceso para realizar las acciones correspondientes.</div>
        <div>
            <h2 id="lblProcesoER">Proceso entrega - recepción:</h2>
            <input type="text" id="txtProceso"  disabled="disabled" />
            <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:BuscarProceso();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
                <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>
            <label id="div_Mcuenta" class="requeridog">
            </label>
            <label id="lbl_id" visible="false">
            </label>
            <br />
        </div>

        <div>
          <h2>Estado del proceso:</h2>
            <label id="lblEstadoProceso"></label>
        </div>

        <div>
            <h2 id="lblPeriodos">Periodo:</h2>
            <label id="lblPeriodo">
            </label>
        </div>

        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
            </table>
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
