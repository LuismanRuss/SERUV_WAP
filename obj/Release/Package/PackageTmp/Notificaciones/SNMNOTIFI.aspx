<%@ Page Language="C#" AutoEventWireup="true" Inherits="Notificaciones_SNMNOTIFI" Codebehind="SNMNOTIFI.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        var sSplitComas2 = sPerfiles.split(',');
        var separarsSplitComas2 = sSplitComas2[0];

        var Sort_SNMNOTIFI = new Array(2);


        Sort_SNMNOTIFI[0] = [{ "bSortable": false }, null, null, null, null];
       // Sort_SNMNOTIFI[1] = [[3, "asc"]];


        $(document).ready(function () {
            loading.close();
            var idUsuario;
            idUsuario = $('#hf_idUsuario').val();
            NG.setNact(2, 'Dos', botonesNotifi);

            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            if (NG.Var[NG.Nact].oSets == null) {
                //loading.close();
                Ajax(idUsuario);
            } else {
                //loading.close();
                Ajax(idUsuario);
            }
        });

        //función usada para establecer el estado de los botones de acuerdo a si existe o no alguna notificación seleccionada
        function botonesNotifi(selec) {
            if (selec > 0) {
                $("#AccVer2, #AccHistoricos , #AccEnviado").hide();
                $("#AccVer, #AccHistoricos2 , #AccEnviado2").show();
            } else {
                $("#AccVer2, #AccHistoricos , #AccEnviado").show();
                $("#AccVer, #AccHistoricos2 , #AccEnviado2").hide();
            }
        }

        //Función  que se encarga de ejecutar al consulta que regresa las notificaciones sin leer correspondientes al usuario
        function Ajax(idUsuario) {
            loading.ini();
            var actionData = "{'idUsuario': '" + idUsuario +
                                "','strOPCION': '" + "DATOS_NOTIFICACION" +                              
                             "'}";            
            $.ajax({
                url: "../Notificaciones/SNMNOTIFI.aspx/Pinta_Grid",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                    loading.close();
                },

                error: 
                function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        }

        //función que se encarga de mandar los datos a la funcion pTablaI 
        function Pinta_Grid(cadena) {            
            $('#grid').empty();
            var mensaje = { "mensaje": "No cuenta con notificaciones sin leer." }
            if (cadena == null || cadena == "") {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena));

            NG.tr_hover();
            tooltip.iniToolD('25%');

            NG.Var[NG.Nact].oTable = $('#grid')
                .dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                   // "aaSorting": Sort_SNMNOTIFI[1],
                    "aoColumns": Sort_SNMNOTIFI[0]
                });
        };

        //Función que se encarga de llenar la tabla con la información de las notificaciones sin leer correspondientes al usuario que las consulta
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr><th class="no_sort" align="center" scope="col" style="width:5%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:30%;" class="sorting" title="Ordenar">ASUNTO</th>';
            htmlTab += '<th align="center" scope="col" style="width:24%;" class="sorting" title="Ordenar">PROCESO</th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">FECHA RECIBIDO</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">REMITENTE</th>';           

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

                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sAsunto.toUpperCase() + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sAsunto.toUpperCase() + '</div>';
                    htmlTab += '</td>';

                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sProceso.toUpperCase() + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sProceso.toUpperCase() + '</div>';
                    htmlTab += '</td>';

                    htmlTab += '<td class="sorts Acen">' + tab[a_i].sFEnvio + '</td>';

                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sRemitente.toUpperCase() + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sRemitente.toUpperCase() + '</div>';
                    htmlTab += '</td>';
                }
                htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        //Función que obtiene la información de la nueva notificación seleccionada
        function fCambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        }

        //Función que muestra un dialog con la información de la notificación a consultar
        function Ver() {
            var snidNotifica = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idNotifica;
            var ssAsunto = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sAsunto;
            var ssMensaje = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sMensaje;
            var ssDestinatario = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDestinatario;
            var ssProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sProceso;
            var ssidProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idProceso;
            var ssidUsuDest = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idFKUsuDest;
            var ssidUsuRemit = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuRemit;


            $("#hf_nidNotifica").val(snidNotifica);
            $("#hf_sAsunto").val(ssAsunto);
            $("#hf_sMensaje").val(ssMensaje);
            $("#hf_sDestinatario").val(ssDestinatario);
            $("#hf_sProceso").val(ssProceso);
            $("#hf_sProceso").val(ssProceso);
            $("#hf_idProceso").val(ssidProceso);
            $("#hf_ssidUsuDest").val(ssidUsuDest);
            $("#hf_ssidUsuRemit").val(ssidUsuRemit);

            idNotificacion = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idNotifica;
            SAsunto = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sAsunto;
            SMensaje = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sMensaje;

            $("#IdNotificacion").val(idNotificacion);

            dTxt = '<div id="dComent" title="Responder notificación">';
            dTxt += '<iframe id="SNARESPON" src="../Notificaciones/SNARESPON.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SNMNOTIFI').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 650,
                width: 970,
                modal: true,
                resizable: false
            });

        }

        //Función que redirecciona a una ventana donde se puede redactar un nuevo correo
        function Enviarcorreo() {
            urls(2, "../Notificaciones/SNAENVIO.aspx");
        }

        //Función que redirecciona a las notificaciones enviadas
        function Enviados() {
            urls(2, "../Notificaciones/SNMNOTENV.aspx");
        }

        //Función que redirecciona a las notificaciones ya leidas
        function Historicos() {
            loading.ini();
            urls(2, "../Notificaciones/SNMNOTIFIH.aspx");
        }

        //función que cierra la ventana modal y regresa al grid
        function cancelar() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        //Función que actualiza el grid cuando un mensaje es leido
        function fActualizaGrid(idUsuario) {
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            selec= $("#hf_nidNotifica").val();

            $('#ch_' + selec).attr('checked', false);
            $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
            NG.Var[NG.Nact].selec = 0;
            NG.Var[NG.Nact].datoSel = null;
            sel = false;
            botonesNotifi(0);

            Ajax(idUsuario);
        }


        // Función que cierra la ventana modal
        function fCerrarVentana(nMensaje) {
            cancelar();
            switch (nMensaje) {
                case 0:
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                case 1:
                    $.alerts.dialogClass = "correctoAlert";
                    jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                default:
            }
        }


        //Función que regresa a la pagina anterior 
        function fRegresar() {
            if ($.grep(separarsSplitComas2.split('|'), function (n, i) { return (n == 8 ? 1 : (n == 9 ? 1 : 0)); }).length > 0) {                
                urls(2, "../Monitoreo/SSSMONPRO.aspx");
                NG.setNact(0, 'Cero');
            }
            else {                
                if ($.grep(separarsSplitComas2.split('|'), function (n, i) { return (n == 4 ? 1 : (n == 6 ? 1 : 0)); }).length > 0) {
                    urls(1, "../Monitoreo/SMCSUPMON.aspx");
                    NG.setNact(0, 'Cero');
                }
            }
        }

    </script>
</head>
<body>
    <form id="SNMNOTIFI" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Notificaciones - Bandeja de entrada</label>
            <div class="a_acciones">
                <a id="AccVer" title="Ver correo" href="javascript:Ver();" class="accAct">Ver</a>
                <a id="AccVer2" title="Ver correo" class="accIna">Ver</a> 
                <a id="AccHistoricos" title="Ver correos ya leidos" href="javascript:Historicos();" class="accAct">Leídas</a>                 
                <a id="AccEnviado" title="Ver correos enviados" href="javascript:Enviados();" class="accAct">Enviados</a>                
                <a id="AccEnviarNvo" title="Enviar correo" href="javascript:Enviarcorreo();" class="accAct">Redactar correo</a>
            </div>
        </div>
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
        </div> 
        <div class="instrucciones">
            Seleccione la notificación que quiera consultar.</div>
        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width: 99%;" class="display">
            </table>
        </div>
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
        </div> 
    </div>
    <div id="div_ocultos">
        <asp:HiddenField ID="hf_idUsuario" runat="server" />
        <asp:HiddenField ID="hf_idProcesoAnt" runat="server" />
        
        <input type="hidden" id="hf_nidNotifica" />
        <input type="hidden" id="hf_sAsunto" />
        <input type="hidden" id="hf_sMensaje" />
        <input type="hidden" id="hf_sDestinatario" />
        <input type="hidden" id="hf_sProceso" />
        <input type="hidden" id="hf_idProceso" />
        <input type="hidden" id="hf_ssidUsuDest" />
        <input type="hidden" id="hf_ssidUsuRemit" />
    </div>
    </form>
</body>
</html>
