<%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCARESPON" Codebehind="SCARESPON.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    
    <link href="../styles/Notificacion.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
 
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script> 

    <script type="text/javascript">
        var idNotificacion;
        var sAsunto;
        var sProceso;
        var sMensaje;
        var idusuario;
        var idProceso;
        var datosJSON;

        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
        function navegador() {
            if (safari)
                $('#navegador').val("safari");
            if (chrome)
                $('#navegador').val("chrome");
            if ($.browser.msie)
                $('#navegador').val("IE");
            if (mozilla)
                $('#navegador').val("mozilla");
        };


        $(document).ready(function () {
            //NG.setNact(2, 'Dos', BotonesResp);

            navegador();

            idNotifica = $("#hf_nidNotifica", parent.document).val();
            sAsunto = $("#hf_sAsunto", parent.document).val();
            sMensaje = $("#hf_sMensaje", parent.document).val();
            sDestinatario = $("#hf_sDestinatario", parent.document).val();
            sProceso = $("#hf_sProceso", parent.document).val();
            sRemitente = $("#hf_idUsuario").val();
            idProceso = $("#hf_idProceso", parent.document).val();
            idUsuDest = $("#hf_ssidUsuDest", parent.document).val();
            idUsuRemit = $("#hf_ssidUsuRemit", parent.document).val();

            $('#txt_Asunto').text(sAsunto);
            // $('#txt_Mensaje').text(sMensaje);

            $('#div_Mensaje').html(sMensaje); //Nedgar

            //  $('#txt_Destinatario').text(sDestinatario); //Nedgar
            $('#lblinstrucciones').text("Ingrese una respuesta a la notificación recibida.");

            if (idUsuRemit == 2) {
                $('#respontxt').css("visibility", "hidden");
                //  $('#respuesta').css("visibility", "hidden"); //Nedgar

                $('.div_respuesta').empty();  //Nedgar
                $('.div_respuesta').css("visibility", "hidden");  //Nedgar

                $('#EnviarActivo').css("visibility", "hidden");
            }

            if (idUsuRemit == idUsuDest || idUsuRemit == $("#hf_idUsuario").val()) {
                $('#respontxt').css("visibility", "hidden");
                //  $('#respuesta').css("visibility", "hidden"); //Nedgar

                $('.div_respuesta').empty();  //Nedgar
                $('.div_respuesta').css("visibility", "hidden");  //Nedgar

                $('#EnviarActivo').css("visibility", "hidden");
                $('#txt_Aviso').text("No se puede responder esta notificación ya que es enviada por Usted mismo.");
            }

            MensajeLeido(); //Nedgar 
        });

        function MensajeLeido() { //Nedgar
            var idNotifica = $("#hf_nidNotifica", parent.document).val();
            var idUsuario = $("#hf_idUsuario", parent.document).val();
            var strDatos = "{'idNotifica':'" + idNotifica +
                            "','strACCION':'" + "MENSAJE_LEIDO" +
                            "','idFKUsuDest':'" + idUsuario +
                                "'}";

            datosJSON = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objNotificacion: datosJSON });

            //console.log(actionData);
            $.ajax({
                url: "../Registro/SCARESPON.aspx/fMensajeLeido",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    // console.log("Mensaje Leido");
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Por favor ingrese nuevamente", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        function Enviar() {
            var strDatos = "";

            var idNotifica = $("#hf_nidNotifica", parent.document).val();
            var sAsunto = "RE: " + $("#hf_sAsunto", parent.document).val();
            var respuestas = $('#respuesta').val();
            var sDestinatario = $("#hf_sDestinatario", parent.document).val();
            var idProceso = $("#hf_idProceso", parent.document).val();
            var idUsuDest = $("#hf_ssidUsuRemit", parent.document).val();  //Aquí se invierten los usuarios ya que es respuesta a una notificación recibida            
            var idUsuRemit = $("#hf_idUsuario").val();

            //            console.log(sAsunto);
            //            console.log(sMensaje);
            //            console.log(sDestinatario);
            //            console.log(idProceso);
            //            //console.log(sRemitente);
            //            console.log(idUsuDest);
            //            console.log(idUsuRemit);
            //alert("2");


            if (fValidaTextArea()) {
                var actionData = "{'idFKUsuDest':'" + idUsuDest +
                                "','idFKProceso':'" + idProceso +
                                "','sAsunto':'" + sAsunto +
                                "','sMensaje':'" + respuestas +
                                 "','idUsuRemit':'" + idUsuRemit +
                                "'}";
                //console.log(actionData);
                //alert("antes ajax");
                $.ajax({
                    url: "../Registro/SCARESPON.aspx/EnviarRespuesta",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //alert("success");
                        //console.log(reponse.d);
                        fCerrarModal(reponse.d);
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                });
            }
        }

        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }


        function fValidaTextArea() {
            //alert("valida");
            var blnCorrecto = false;
            $("#respuesta").val(jsTrim($("#respuesta").val()));
            if ($("#respuesta").val().length > 0) {
                blnCorrecto = true;
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Escriba una respuesta para la notificación.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                blnCorrecto = false;
            }
            return blnCorrecto;
        }

        function Cancelar() {
            window.parent.fActualizaGrid($('#hf_idUsuario').val());
            window.parent.cancelar();
        }

        function fCerrarModal(nMensaje) {
            window.parent.fActualizaGrid($('#hf_idUsuario').val());
            window.parent.fCerrarVentana(nMensaje);
        }
       </script>
</head>

<body>
    <form id="SNARESPON" runat="server">
        <div id="agp_contenido">

            <div id="div_Mensaje"></div>
            <br />

            <%--<h2>Destinatarios:</h2> <label id="txt_Destinatario"> </label>  
            <br />--%>
                                   
            <div id="respontxt"><h2>Responder:</h2></div>
            <div class="div_respuesta">
                <textarea id="respuesta" rows="7" cols="135" autofocus></textarea> 
            </div>
            <br/><br />

            <div id="txt_Aviso">
            </div>
            
            <div class="a_botones">
                <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">Enviar respuesta</a>                          
                <a id="CancelarActivo" href="javascript:Cancelar();" class="btnAct"  title="Botón de cancelar">Cancelar</a>
            </div>

            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />                
                <asp:HiddenField ID="hf_idNotificacion" runat="server" />   
                <asp:HiddenField ID="hf_idProceso" runat="server" />   
            </div>

        </div>
    </form>
</body>
</html>
