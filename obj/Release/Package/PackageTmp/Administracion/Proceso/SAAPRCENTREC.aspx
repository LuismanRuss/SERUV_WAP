<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Administracion_General_Procesos_ER_SAAPRCENTREC" Codebehind="SAAPRCENTREC.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>
   <%-- <script src="../scripts/DataTables.js" type="text/javascript"></script>--%> 
</head>

<body>
       <script type="text/javascript">
           var Sort_SAAPRCENTREC = new Array(2);  
           Sort_SAAPRCENTREC[0] = [{ "bSortable": false }, null, null, null, null, null, null, null,null];
           Sort_SAAPRCENTREC[1] = [[2, "asc"]];

           BotonesProcesoER = function (selec, indicador) {//FUNCIÓN PARA LOS BOTONES DE LA FORMA
               if (selec > 0) {//Seleccionado   
                   $("#AccAgregar2, #AccModificar, #AccEliminar, #AccCambiarSujObligado, #AccModificarEstado, #AccParticipante ,#AccUsuarios, #AccSupervisor, #AccMotivos, #AccHistorico2, #AccReporte, #AccSolicitudes2").show();
                   $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccCambiarSujObligado2, #AccModificarEstado2, #AccParticipante2, #AccUsuarios2, #AccSupervisor2, #AccMotivos2, #AccHistorico, #AccReporte2, #AccSolicitudes").hide();
                   if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nEliminar != '') {
                       $("#AccEliminar2").show();
                       $("#AccEliminar").hide();
                       $("#AccMotivos2").hide();
                   } else {
                       $("#AccEliminar").show();
                       $("#AccEliminar2").hide();
                       $("#AccMotivos2").hide();
                   }
                   if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo == 'N') {
                       $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccCambiarSujObligado2, #AccModificarEstado, #AccParticipante2, #AccUsuarios2, #AccSupervisor2, #AccMotivos, #AccHistorico2, #AccReporte2, #AccSolicitudes").show();
                       $("#AccAgregar2,#AccModificar,  #AccEliminar, #AccCambiarSujObligado, #AccModificarEstado2, #AccParticipante,#AccUsuarios, #AccSupervisor, #AccMotivos2, #AccHistorico, #AccReporte, #AccSolicitudes2").hide();

                   }
               }
               else {// No Seleccionado
                   $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccCambiarSujObligado2, #AccModificarEstado2, #AccParticipante2, #AccUsuarios2, #AccSupervisor2,#AccMotivos,#AccHistorico, #AccReporte2, #AccSolicitudes").show();
                   $("#AccAgregar2,#AccModificar,  #AccEliminar, #AccCambiarSujObligado, #AccModificarEstado, #AccParticipante,#AccUsuarios, #AccSupervisor,#AccMotivos2, #AccHistorico2, #AccReporte, #AccSolicitudes2").hide();

                   if (indicador == 0) {
                       $("#AccAgregar2, #AccModificar2, #AccEliminar2, #AccCambiarSujObligado2, #AccModificarEstado, #AccParticipante2, #AccUsuarios2, #AccSupervisor2,#AccMotivos,#AccHistorico2, #AccReporte2, #AccSolicitudes2").show();
                       $("#AccAgregar,#AccModificar,  #AccEliminar, #AccCambiarSujObligado, #AccModificarEstado2, #AccParticipante,#AccUsuarios, #AccSupervisor,#AccMotivos2, #AccHistorico, #AccReporte, #AccSolicitudes").hide();
                   }
               }
           }

           function fAjax() {//FUNCIÓN QUE SE VA AL SERVIDOR Y ME REGRESA LOS PROCESOS DE ENTREGA RECEPCIÓN
               loading.ini();
               var actionData = "{}";
               $.ajax(
                {
                    url: "Proceso/SAAPRCENTREC.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        Pinta_Grid(eval('(' + reponse.d + ')'));

                        if (NG.Var[NG.Nact].selec > 0) {
                            if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo == 'S') {
                                BotonesProcesoER(1);
                            } else {
                                BotonesProcesoER(0, 0);
                            }
                        }
                    },
                    error: errorAjax
                });
           }

           $(document).ready(function () {
               if (NG.Nact == 2) {//SI ES NIVEL 2
                   NG.setNact(1, 'Uno', BotonesProcesoER);
                   NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                   fAjax();
               } else if (NG.Nact == 1) {//SI ES NIVEL 1
                   NG.reset();
                   NG.setNact(1, 'Uno', BotonesProcesoER);
                   NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                   fAjax();
               } else {
                   NG.setNact(1, 'Uno', BotonesProcesoER);
                   NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                   fAjax();
               }
           });

           function Pinta_Grid(cadena) {
               $('#grid').empty();
               mensaje = { "mensaje": "No existen procesos configurados." }
               if (cadena == null || cadena == "") {
                   loading.close();
                   $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                   $('#divInstrucciones').hide();
                   return false;
               }
               $('#grid').append(pTablaI(cadena));

               NG.tr_hover();
               tooltip.iniToolD('25%');
               //Inicio Ordenamiento columna
               NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                   "sPaginationType": "full_numbers",
                   "bLengthChange": true,
                   "aaSorting": Sort_SAAPRCENTREC[1],
                   "aoColumns": Sort_SAAPRCENTREC[0]
               });
               //NG.Var[NG.Nact].oTable = lTable;
               loading.close();
           };


           function pTablaI(tab) {//PINTA EL GRID DE PROCESOS
               NG.Var[NG.Nact].datos = tab;
               htmlTab = '';
               htmlTab += '<thead><tr>';
               htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
               htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Código</th>';
               htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
               htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
               htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Código guía</th>';
               htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Tipo</th>';
               htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Fecha inicial</th>';
               htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Fecha final</th>';
               htmlTab += '<th scope="col" style="width:2%;" class="sorting" title="Ordenar">Disponibilidad</th>';
               htmlTab += '</tr></thead>';
               htmlTab += "<tbody>";

               for (a_i = 1; a_i < tab.length; a_i++) {
                   if (NG.Var[NG.Nact].selec == a_i) {
                       htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                       htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
                   } else {
                       htmlTab += '<tr id="tr_' + a_i + '" >';
                       htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                   }

                   htmlTab += '<td class="sorts Acen">' + tab[a_i].sProceso + '</td>';
                   htmlTab += '<td class="sorts">' + tab[a_i].dependencia + '</td>';
                   htmlTab += '<td class="sorts">' + tab[a_i].puesto + '</td>';

                   htmlTab += '<td class="sorts Acen">' + tab[a_i].sGuiaER + '</td>';
                   htmlTab += '<td class="sorts Acen">' + tab[a_i].sDTipoPeri + '</td>';
                   htmlTab += '<td class="sorts Acen">' + tab[a_i].sFInicio + '</td>';
                   htmlTab += '<td class="sorts Acen">' + tab[a_i].sFFinal + '</td>';

                   if (tab[a_i].cIndActivo == 's' || tab[a_i].cIndActivo == 'S') {
                       htmlTab += '<td class="sorts Acen">' + 'SÍ' + '</td>';
                   } else if (tab[a_i].cIndActivo == 'n' || tab[a_i].cIndActivo == 'N') {
                       htmlTab += '<td class="sorts Acen">' + 'NO' + '</td>';
                   }
               }
               htmlTab += "</tr>";
               htmlTab += "</tbody>";
               return htmlTab;
           }

           function fCambia(selec) {//FUNCIÓN QUE SE MANDA A LLAMAR CUANDO SE ACTIVA O DESACTIVA UN RADIO.
               NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
               NG.cambia(selec);
               NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
           };

           function ModfEdo() {//FUNCIÓN QUE MUESTRA EL CUADRO DE DIALOGO PARA CONFIRMAR EL CAMBIO DE ESTADO DEL PROCESO
               var aedo1, aedo2;
               if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo == 's' || NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo == 'S') {//PREGUNTO SI EL PROCESO ESTÁ ACTIVO
                   aedo1 = "ACTIVO";
                   aedo2 = "INACTIVO";
                   edo = false;

                   $.alerts.dialogClass = "infoConfirm";
                   jConfirm("¿Desea quitar la disponibilidad del proceso?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                       if (r) {
                           fModificaEdo();//se manda a llamar la función que cambia el estado del proceso
                       }
                   });
               } else {
                   aedo2 = "ACTIVO";
                   aedo1 = "INACTIVO";
                   edo = true;
                   jConfirm("¿Desea dejar disponible el proceso?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                       if (r) {
                           loading.ini();
                           fModificaEdo(); //se manda a llamar la función que cambia el estado del proceso
                       }
                   });
               }
           }


           function fModificaEdo() {//FUNCIÓN QUE MODIFICA EL ESTADO AL PROCESO: DE ACTIVO A INACTIVO
               var nIdUsuario = $("#hf_idUsuario").val();
               var actionData = "{'nIdProceso': '" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso +
                                 "','strIndActivo': '" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].cIndActivo +
                                 "','nIdUsuario': '" + nIdUsuario +
                         "'}";
               $.ajax({
                   url: "Proceso/SAAPRCENTREC.aspx/fModificaEdo",
                   data: actionData,
                   dataType: "json",
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   success: function (reponse) {
                       var resp = reponse.d;
                       switch (resp) {
                           case 0://error
                               $.alerts.dialogClass = "incompletoAlert";
                               jAlert("No se puede modificar la disponibilidad del proceso.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                               break;
                           case 1://acción realizada correctamente
                               NG.repinta();
                               fActualizarGrid();
                               $.alerts.dialogClass = "correctoAlert";
                               jAlert("La disponibilidad del proceso se ha modificado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                               break;
                       }
                   },
                   error: errorAjax
               });
           }

           function fActualizarGrid() {//FUNCIÓN QUE ACTUALIZA EL GRID DESPUES DE ALGUNA ACCIÓN COMO ELIMINAR PROCESO O MODIFICAR SU ESTADO
               $('#grid').empty();
               NG.Var[NG.Nact].oTable.fnDestroy();
               fAjax();
           }

           function Eliminar() {//FUNCIÓN QUE MUESTRA EL ALERT PARA CONFIRMAR LA ELIMINADA DE UN PROCESO ENTREGA RECEPCIÓN
               proceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDPeriodo
               $.alerts.dialogClass = "infoConfirm";
               jConfirm("¿Está seguro que desea eliminar el proceso: " + proceso + "?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                   if (r) {
                       loading.ini();
                       fEliminarProceso(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso);
                   }
               });
           }


           function fEliminarProceso(nIdProceso) {//FUNCIÓN QUE ELIMINA EL PROCESO ENTREGA RECEPCIÓN
               var nIdUsuario = $("#hf_idUsuario").val();
               var variables = "{'nIdProceso': '" + nIdProceso +
                                "','nIdUsuario': '" + nIdUsuario +
                                "'}";
               $.ajax({
                   url: "Proceso/SAAPRCENTREC.aspx/fEliminaProc",
                   data: variables,
                   dataType: "json",
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   success: function (reponse) {
                       var resp = reponse.d;
                       switch (resp) {
                           case 0://error
                               $.alerts.dialogClass = "errorAlert";
                               jAlert("No se pudo eliminar el proceso seleccionado.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                               break;
                           case 1://acción realizada correctamente
                               NG.setNact(1, 'Uno', BotonesProcesoER);
                               BotonesProcesoER(0);
                               NG.Var[NG.Nact].datoSel = null;
                               NG.Var[NG.Nact].datos = null;
                               NG.Var[NG.Nact].selec = 0;
                               fActualizarGrid();
                               loading.close();
                               $.alerts.dialogClass = "correctoAlert";
                               jAlert("El proceso fué eliminado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                               break;
                       }
                   },
                   beforeSend: loading.iniSmall(),
                   complete: function () {
                       loading.closeSmall();
                   },
                   error: errorAjax
               });
           }

           function fModificar() {//ENVÍA A LA FORMA DE MODIFICAR PROCESO
               loading.ini();
               urls(5, "Proceso/SAAPROCESH.aspx");
           }

           function fAgregar() {//ENVÍA A LA FORMA DE AGREGAR PROCESO
               loading.ini();
               urls(5, "Proceso/SAAPROCESH.aspx");
           }

           function fCambSujObl() {//ENVÍA A LA FORMA DE CAMBIO DE SUJETO OBLIGADO
               loading.ini();
               urls(5, "Proceso/SAACASUOB.aspx");
           }

           function fParticipantes() {//ENVÍA A LA FORMA DE PARTICIPANTES
               loading.ini();
               urls(5, "Proceso/SAAPARTIC.aspx");
           }

           function fUsuarios() {//ENVÍA A LA FORMA DE USUARIOS
               loading.ini();
               urls(5, "Proceso/SAMPERPRO.aspx");
           }

           function fSupervisor() {//ENVÍA A LA FORMA DE SUPERVISOR
               loading.ini();
               urls(5, "Proceso/SASPARTIC.aspx");
           }

           function fMotivos() {//ENVÍA A LA FORMA DE MOTIVOS
               urls(5, "Proceso/SAAPMOTIV.aspx");
           }

           function fHistorico() {// ENVÍA A LA FORMA DEL HISTORICO DE PROCESOS
               loading.ini();
               urls(5, "Proceso/SAAPRCENTREH.aspx")
           }

           function fListResportes() {
               var strOpcion = "CED_PROCESO";

               dTxt = "<div id='dComent' title='SERUV - Reportes' class='dialogo' style='clear:both'>";
               dTxt += "<div class='instrucciones' style='font-size: 12px'> Seleccione un reporte. </div>";
               dTxt += "<br/>"
               dTxt += "<a id='AccCedula' href='javascript:fReporte();'>1. Cédula del proceso</a>";
               dTxt += "<br/>";
               dTxt += "<a id='AccSolicitudes' href='javascript:fSolicitudes();'>2. Solicitudes de intervención</a>";
               dTxt += "</div>";
               $("#SAAPRCENTREC").append(dTxt);
               $("#dComent").dialog({
                   autoOpen: true,
                   height: 160,
                   width: 250,
                   modal: true,
                   resizable: false
               });
               $("#AccCedula").blur();

           }

           function fReporte() {//MUESTRA EL REPORTE
               //urls(5, "../Reportes/REPORTES.aspx?idProceso=" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso + "&opcion=PROCESO");
               //alert("1");
               //$("#hf_operacion").val(op);
               if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec] != null) {
                   idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;

                   dTxt = '<div id="dComent" title="SERUV - Reporte">';
                   //dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso + '&op=PROCESO' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                   dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + idProceso + '&op=CED_PROCESO' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
                   dTxt += '</div>';
                   $('#SAAPRCENTREC').append(dTxt);
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
               } else {
                   $.alerts.dialogClass = "incompletoAlert";
                   jAlert("Debe seleccionar un proceso.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
               }
           }

           function fCerrarDialog() {
               $('#dComent').dialog("close");
               $("#dComent").dialog("destroy");
               $("#dComent").remove();
           }

           function fSolicitudes() {
               //$("#hf_operacion").val(op);
               //idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;

               dTxt = '<div id="dComent" title="Reportes - SERUV">';
               //dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso + '&op=PROCESO' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
               dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?op=SOLICITUDES' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
               dTxt += '</div>';
               $('#SAAPRCENTREC').append(dTxt);
               $("#dComent").dialog({
                   autoOpen: true,
                   height: 800,
                   width: 1000,
                   modal: true,
                   resizable: true
               });
           }

           function fLSolicitudes() {
               loading.ini();
               urls(5, "Proceso/SAMSOLICI.aspx");
           }

       </script>
    <form id="SAAPRCENTREC" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Procesos ER</label>
                <div class="a_acciones">
                    <a id="AccSolicitudes" title="Solicitudes" href="javascript:fLSolicitudes();" class="accAct">Solicitudes</a>
                    <a id="AccSolicitudes2" title="Solicitudes" class="accIna iOculto">Solicitudes</a>

                    <a id="AccAgregar" title="Agregar" href="javascript:fAgregar();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                    <a id="AccModificar" title="Modificar" href="javascript:fModificar();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                    <a id="AccEliminar" title="Eliminar" href="javascript:Eliminar();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="No se puede eliminar el proceso ya que se han cargado archivos" class="accIna">Eliminar</a>           

                    <a id="AccModificarEstado" title="Modificar disponibilidad" href="javascript:ModfEdo();" class="accAct iOculto">Disponibilidad</a>
                    <a id="AccModificarEstado2" title="Modificar disponibilidad" class="accIna">Disponibilidad</a>

                    <a id="AccParticipante" title="Configuración de Dependencias / entidades" href="javascript:fParticipantes();" class="accAct iOculto">Dependencias / entidades</a>
                    <a id="AccParticipante2" title="Configuración de Dependencias / entidades" class="accIna">Dependencias / entidades</a>
                
                    <a id="AccCambiarSujObligado" title="Cambiar Sujeto Obligado" href="javascript:fCambSujObl();" class="accAct iOculto">Cambiar Sujeto Obligado</a>
                    <a id="AccCambiarSujObligado2" title="Cambiar Sujeto Obligado" class="accIna">Cambiar Sujeto Obligado</a>
                    
                    <a id="AccUsuarios" title="Configuración de supervisores por proceso" href="javascript:fUsuarios();" class="accAct iOculto">Usuarios</a>
                    <a id="AccUsuarios2" title="Configuración de supervisores por proceso" class="accIna">Usuarios</a>

                    <a id="AccReporte" title="Reporte" href="javascript: fReporte('CED_PROCESO');" class="accAct iOculto">Reporte</a>
                    <a id="AccReporte2" title="Reporte" class="accIna">Reporte</a>

                    <a id="AccSupervisor" title="Supervisor por dependencia" href="javascript:fSupervisor();" class="accAct iOculto">Supervisor</a>
                    <a id="AccSupervisor2" title="Supervisor por dependencia" class="accIna">Supervisor</a>

                    <a id="AccMotivos" title="Motivos" href="javascript:fMotivos();" class="accAct iOculto">Motivos</a>
                    <a id="AccMotivos2" title="Motivos" class="accIna">Motivos</a>

                    <a id="AccHistorico" title="Histórico" href="javascript:fHistorico();" class="accAct">Histórico</a>
                    <a id="AccHistorico2" title="Histórico" class="accIna">Histórico</a>

                    <%--<a id="AccSolicitudes" title="Solicitudes" href="javascript:fSolicitudes();" class="accAct">Solicitudes</a>
                    <a id="AccSolicitudes2" title="Solicitudes" class="accIna">Solicitudes</a>--%>
                </div>
            </div>
                       
                   <div class="preloader">
		            <img alt="imagen alusiva a cargar la pagina" src="../images/loading.gif" style="width: 20px; vertical-align: middle;" /> Cargando...				                    
                </div>
             
            <div id="divInstrucciones" class="instrucciones">Seleccione un proceso para realizar las acciones correspondientes.</div>
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div>  

             <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
                <asp:HiddenField ID="hf_operacion" runat="server" />
            </div>
        </div>   
    </form>
</body>
</html>
