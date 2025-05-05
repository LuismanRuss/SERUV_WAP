<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SSSMONPROC" Codebehind="SSSMONPRO.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>    
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
</head>
<body>
    <script type="text/javascript">

        var Sort_SSSMONPRO = new Array(2);
        Sort_SSSMONPRO[0] = [{ "bSortable": true }, null, null, null, null, null, null, null];
        Sort_SSSMONPRO[1] = [[0, "asc"]];
        var Procesos = null;
        var AvanceGeneral = null;
        var idProc = null;
        var cadena = null;

        function BotonesMONPRO(selec) {//función que activa o desactiva los botones.
            if (selec > 0) { //Seleccionado
                $("#AccReportes").hide();
                $("#AccReportes2").show();
            } else { //No Seleccionado
                $("#AccReportes").show();
                $("#AccReportes2").hide();
            }
        }


        function fAjax() {//función que se va al servidor y me trae los procesos en los que esta como supervisor el usuario logueado
            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'nIdUsuario': '" + nIdUsuario +
                         "'}"; ;
            $.ajax(
                {
                    url: "SSSMONPRO.aspx/pGetProceso",
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

        function fgetAvanceProceso(nIdProceso) {//función que se va al servidor y me regresa los datos del proceso seleccionado
            var actionData = "{'nIdProceso': '" + nIdProceso +
                         "'}"; ;
            $.ajax(
                {
                    url: "SSSMONPRO.aspx/pPinta_Grid",
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
            $("#lblAvance").text("Debe seleccionar un proceso para mostrar el avance general");
            if (NG.Nact == 0) {//cuando se inicia la página
                $("#lblAvance").hide();
                $("#lblAvances").hide();

                NG.setNact(1, 'Uno', null);
                fAjax();
            } else {//cuando viene de la forma de dependencia
                fAjax();
                var idProc = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdProceso;
                var nombreProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].sDProceso;
                $("#txtProceso").val(nombreProceso);
                var selc = NG.Var[NG.Nact - 1].selc;
                NG.Var[NG.Nact].selec = selc;
                fgetAvanceProceso(idProc);
            }
        });

        
        function Pinta_Proceso(cadena) { //Función que llena los datos de la forma de acuerdo al proceso
            var nombreProceso = null;
            var nIdProceso = null;

            if (cadena.length == 2) {//pregunto si la cadena json contiene dos registros
                nombreProceso = cadena[1].sProceso + ' ' + cadena[1].sDProceso;
                nIdProceso = cadena[1].nIdProceso;
                $("#ico_busqueda").hide();
                $("#txtProceso").val(nombreProceso);
                if (NG.Nact == 1) {
                    fgetAvanceProceso(nIdProceso);
                    $('#hf_idProc').val(nIdProceso); //Nedgar
                }
            } else if (cadena.length == 1) {//pregunto si la cadena json de procesos contiene solo un registro 
                $("#txtProceso").hide();
                $("#ico_busqueda").hide();
                $("#lblProcesoER").hide();
                $("#divInstrucciones").hide();
                mensaje = { "mensaje": "Usted no cuenta con procesos a supervisar." }
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
            } else if (NG.Nact == 1) {//si la cadena json contiene mas de dos registros 
                var id = 0;
                var numProceso = '0';

                $.each(cadena, function () {//esta parte me da el proceso mas reciente para mostrarlo por default
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

                fgetAvanceProceso(id);
                $('#hf_idProc').val(id); //Nedgar
                $("#txtProceso").val(nombreProceso);
            }
        }


        function Pinta_Grid(cadena) { //función que asigna las propiedades del DataTable
            var datosGrid = cadena.datos[1]; //datos del grid
            var avance = cadena.datos[0]; //avance general
            AvanceGeneral = avance[0].avanceGeneralProceso;
            estadoProceso = avance[0].sEstatus;

            $("#lblAvance").text(AvanceGeneral.toFixed(2) + ' %');
            $("#lblEstadoProceso").text(estadoProceso == 'C' ? "CERRADO" : "ABIERTO");

            $("#lblAvances").show();
            $("#lblAvance").show();

            $('#grid').empty();
            mensaje = { "mensaje": "No existen periodos configurados." }
            if (datosGrid == null || datosGrid == "") {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(datosGrid));

            NG.tr_hover();
            tooltip.iniToolD('25%');

            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SSSMONPRO[1],
                "aoColumns": Sort_SSSMONPRO[0]
            });
            loading.close();
        };


        function pTablaI(tab) {//función que pinta el grid con las dependencias que pertenecen al proceso
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th scope="col" style="width:54%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Avance</th>';
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

                if (tab[a_i].excluidos != 0) {
                    htmlTab += '<td class="sorts Acen"><a onclick="MostrarAnexos(\'' + tab[a_i].nIdParticipante + '\',\'' + 'excluidos' + '\',\'' + tab[a_i].sDDepcia + '\',\'' + a_i + '\',\'' + tab[a_i].excluidos + '\')\" style=\"cursor:pointer\">' + tab[a_i].excluidos + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].excluidos + '</td>';
                }


                if (tab[a_i].integrados != 0) {
                    htmlTab += '<td class="sorts Acen"><a onclick="MostrarAnexos(\'' + tab[a_i].nIdParticipante + '\',\'' + 'integrados' + '\',\'' + tab[a_i].sDDepcia + '\',\'' + a_i + '\',\'' + tab[a_i].integrados + '\')\" style=\"cursor:pointer\">' + tab[a_i].integrados + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].integrados + '</td>';
                }


                if (tab[a_i].pendientes != 0) {
                    htmlTab += '<td class="sorts Acen"><a onclick="MostrarAnexos(\'' + tab[a_i].nIdParticipante + '\',\'' + 'pendientes' + '\',\'' + tab[a_i].sDDepcia + '\',\'' + a_i + '\',\'' + tab[a_i].pendientes + '\')\" style=\"cursor:pointer\">' + tab[a_i].pendientes + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].pendientes + '</td>';
                }

                if (tab[a_i].cIndEntrega == 'E') {
                    htmlTab += '<td class="sorts Acen">' + 'EN PROCESO' + '</td>';
                } else if (tab[a_i].cIndEntrega == 'C') {
                    htmlTab += '<td class="sorts Acen">' + 'CONCLUIDA' + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + 'OTRA' + '</td>';
                }


                if (tab[a_i].cIndCerrado == 'S') {
                    htmlTab += '<td class="sorts Acen">' + 'CERRADO' + '</td>';
                } else if (tab[a_i].cIndCerrado == 'N' || tab[a_i].cIndCerrado == 'n' || tab[a_i].cIndCerrado == '' || tab[a_i].cIndCerrado == 'N ') {
                    htmlTab += '<td class="sorts Acen">' + 'ABIERTO' + '</td>';
                }

                htmlTab += '<td class="sorts Acen"><a onclick="fSelecciona(\'' + a_i + '\')\" style=\"cursor:pointer\">' + '<img src="../images/icono-grafica.png" />' + '</td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }


        function MostrarAnexos(nIdParticipante, opcion, dependencia, selc, numeroAnexos) {//función que muestra el dialog de los anexos
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
            $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
            $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).find('#ch_' + NG.Var[NG.Nact].selec).attr('checked', false);

            NG.Var[NG.Nact].selec = selc;
            a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
            NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
            $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).addClass('row_selected');
            sel = true;

            //----------------------------------------
            var proceso = $("#txtProceso").val();
            if (opcion == 'excluidos') {//si la opción es anexos excluidos
                a_tip = [
                    { tit: 'Anexos excluidos', arc: "SSCANEXDEP.aspx?nIdParticipante=" + nIdParticipante + "&opcion=" + opcion + "&proceso=" + proceso + "&dependencia=" + dependencia + "&numeroAnexos=" + numeroAnexos }
                     ];
            } else if (opcion == 'integrados') {//si la opción es anexos integrados
                a_tip = [
                      { tit: 'Anexos integrados', arc: "SSCANEXDEP.aspx?nIdParticipante=" + nIdParticipante + "&opcion=" + opcion + "&proceso=" + proceso + "&dependencia=" + dependencia + "&numeroAnexos=" + numeroAnexos }
                     ];
            } else if (opcion == 'pendientes') {//si la opción es anexos pendientes
                a_tip = [
                      { tit: 'Anexos pendientes', arc: "SSCANEXDEP.aspx?nIdParticipante=" + nIdParticipante + "&opcion=" + opcion + "&proceso=" + proceso + "&dependencia=" + dependencia + "&numeroAnexos=" + numeroAnexos }
                     ];
            }

            $("#dComent").dialog("destroy");
            $("#dComent").remove();
            dTxt = '<div id="dComent" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SSCANEXDEP" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SSSMONPRO').append(dTxt);
            $("#dComent").dialog({//propiedades del dialog
                autoOpen: true,
                height: 700,
                width: 970,
                modal: true,
                resizable: true
            });
        }

        function BuscarProceso() {//función que muestra el dialog para mostrar procesos
            a_tip = [
                    { tit: 'Buscar proceso', arc: "SSCMONPRO.aspx?cadena=" + Procesos }
                ];
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
            dTxt = '<div id="dComent2" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SSCMONPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SSSMONPRO').append(dTxt);
            $("#dComent2").dialog({
                autoOpen: true,
                height: 700,
                width: 970,
                modal: true,
                resizable: true
            });
        }

        function fDependencias(nIdParticipante, selc) {//función que me manda a la forma del avance de dependencia
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();

            if (NG.Nact == 2) {
                NG.Var[NG.Nact - 1].selc = null;
                NG.Var[NG.Nact - 1].selc = selc;

                //esta parte sirve para mantener seleccionada la dependencia en el grid
                var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).removeClass('row_selected');
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).find('#ch_' + NG.Var[NG.Nact].selc).attr('checked', false);
                NG.Var[NG.Nact].selc = selc;
                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc]);
                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).addClass('row_selected');
            } else {
                //esta parte sirve para mantener seleccionada la dependencia en el grid
                var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).removeClass('row_selected');
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).find('#ch_' + NG.Var[NG.Nact].selc).attr('checked', false);
                NG.Var[NG.Nact].selc = selc;
                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc]);
                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selc).addClass('row_selected');
            }
            urls(2, "SSSMONDEP.aspx");
        }


        function fn_cerrarPform(idproc, nomProc) { //Función para cerrar la ventana modal de Buscar Procesos con Parámetros
            $('#hf_idProc').val(idproc); //Nedgar
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

        function fGrafica() {//esta función abre el dialog de las gráficas
            var pendientes = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].pendientes; //número de anexos pendientes
            var excluidos = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].excluidos; //número de anexos excluidos
            var integrados = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].integrados; //número de anexos integrados

            a_tip = [
                    { tit: 'Gráfica', arc: "SSCMONGRA.aspx?excluidos=" + excluidos + "&integrados=" + integrados + "&pendientes=" + pendientes }
                ];
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
            dTxt = '<div id="dComentGrafica" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SSCMONPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SSSMONPRO').append(dTxt);
            $("#dComentGrafica").dialog({
                autoOpen: true,
                height: 550,
                width: 970,
                modal: true,
                resizable: false
            });
        }

        function fSelecciona(selc) {//función que mantiene seleccionada la dependencia en el grid
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

        function CerrarVentAct() {
            $('#dComent').dialog("close");
            jAlert("La información ha cambiado, porfavor actualice su página", "SISTEMA DE ENTREGA - RECEPCIÓN");
        }

        function fNotificaciones() {
            urls(2, "../Notificaciones/SNMNOTIFI.aspx");
        }

        function fCerrarDialogG() {
            $('#dComentGrafica').dialog("close");
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
        }

        function fCerrarDialogBuscaProceso() {
            $('#dComent2').dialog("close");
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
        }

        function fCerrarDialogAnexos() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        function fReporte() {
            var idUsuario = $("#hf_idUsuario").val();
            dTxt = '<div id="dComentR" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?IdItem=' + idUsuario + '&op=SUPERVISORDEPEND' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SSSMONPRO').append(dTxt);
            $("#dComentR").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //800,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true
            });
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComentR').dialog("close");
            $("#dComentR").dialog("destroy");
            $("#dComentR").remove();
        }
    </script>
    <form id="SSSMONPRO" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Supervisión</label>
            <div class="a_acciones">
                <a id="AccReporte" title="Reporte de dependencias configuradas para supervisar" href="javascript:fReporte();" class="accAct">Reporte</a>                

                <a id="AccNotificacion" title="Notificaciones" href="javascript:fNotificaciones();" class="accAct">Notificaciones</a>
                
            </div>
        </div>
        <div id="divInstrucciones" class="instrucciones">Seleccione un proceso para realizar las acciones correspondientes.</div>
         <div id="div_contenido">
            <h2 id="lblProcesoER">Proceso entrega - recepción:</h2>
            <input type="text" id="txtProceso" disabled="disabled" />
            <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:BuscarProceso();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
                <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>
            <label id="div_Mcuenta" class="requeridog">
            </label>
            <label id="lbl_id" visible="false">
            </label>
            <br />

            <h2>Estado del proceso:</h2>
            <label id="lblEstadoProceso"></label>
            <br />

            <h2 id="lblAvances">Avance general:</h2>
            <label id="lblAvance">
            </label>
        </div>
        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
            </table>
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_idProc" runat="server" /> <%--NEdgar--%>
        </div>
    </div>
    </form>
</body>
</html>
