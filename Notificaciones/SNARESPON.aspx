<%@ Page Language="C#" AutoEventWireup="true" Inherits="Notificaciones_SNARESPON" Codebehind="SNARESPON.aspx.cs" %>

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

            $('#div_Mensaje').html(sMensaje); 

            $('#lblinstrucciones').text("Ingrese una respuesta a la notificación recibida.");

            if (idUsuRemit == 2) {
                $('#respontxt').css("visibility", "hidden");

                $('.div_respuesta').empty(); 
                $('.div_respuesta').css("visibility", "hidden");

                $('#EnviarActivo').css("visibility", "hidden");
            }

            if (idUsuRemit == idUsuDest || idUsuRemit == $("#hf_idUsuario").val()) {
                $('#respontxt').css("visibility", "hidden");

                $('.div_respuesta').empty();
                $('.div_respuesta').css("visibility", "hidden");

                $('#EnviarActivo').css("visibility", "hidden");
                $('#txt_Aviso').text("No se puede responder esta notificación ya que es enviada por Usted mismo.");
            }

            MensajeLeido();
        });

        /// función que envia información de la notificación para marcar el mensaje como leído.
        function MensajeLeido() { 
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
                url: "../Notificaciones/SNARESPON.aspx/fMensajeLeido",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
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

        //Función que obtiene la fecha y hora actual actual en que se envia una respuesta.
         function GetTodayDate() {
            if ($.browser.safari) {
                var fullDate = new Date();
                var twoDigitMonth = fullDate.getMonth() + 1 + ""; if (twoDigitMonth.length == 1) twoDigitMonth = "0" + twoDigitMonth;
                var twoDigitDate = fullDate.getDate() + ""; if (twoDigitDate.length == 1) twoDigitDate = "0" + twoDigitDate;
                var currentDate = twoDigitDate + "-" + twoDigitMonth + "-" + fullDate.getFullYear();
                var xxx = currentDate;

                year = fullDate.getFullYear();

                xxx += " - " + tdate.getHours() + ":" + tdate.getMinutes() + ":" + tdate.getSeconds();
            }
            if ($.browser.mozilla || $.browser.webkit) {
                var fullDate = new Date();
                var twoDigitMonth = fullDate.getMonth() + 1 + ""; if (twoDigitMonth.length == 1) twoDigitMonth = "0" + twoDigitMonth;
                var twoDigitDate = fullDate.getDate() + ""; if (twoDigitDate.length == 1) twoDigitDate = "0" + twoDigitDate;
                var currentDate = twoDigitDate + "-" + twoDigitMonth + "-" + fullDate.getFullYear();
                var xxx = currentDate;

                year = fullDate.getFullYear();

                xxx += " - " + tdate.getHours() + ":" + tdate.getMinutes() + ":" + tdate.getSeconds();
            }
            else {
                var tdate = new Date();
                var dd = tdate.getDate() < 10 ? '0' + tdate.getDate() : tdate.getDate();  //yeilds day
                var MM = tdate.getMonth() < 10 ? '0' + (tdate.getMonth() + 1) : (tdate.getMonth() + 1);
                var yyyy = tdate.getFullYear(); //yeilds year
                var xxx = dd + "-" + MM + "-" + yyyy;

                year = tdate.getFullYear();

                xxx += " - " + tdate.getHours() + ":" + tdate.getMinutes() + ":" + tdate.getSeconds();
            }
            return xxx;
        }

        // Función que se encarga de enviar una respuesta al mensaje desplegado
        function Enviar() {
            var strDatos = "";

            var sFechaActual = GetTodayDate();

            var idNotifica = $("#hf_nidNotifica", parent.document).val();
            var sAsunto = "RE: " + $("#hf_sAsunto", parent.document).val();
            var respuestas = "RE: " +$('#respuesta').val()
                                + "<br>"
                               + "Fecha: " +sFechaActual+"hrs."
                                +"<br>"
                                    + "_______________________________________________________________________________________________________________"
                                    +"<br>"
                                + sMensaje;
            var sDestinatario = $("#hf_sDestinatario", parent.document).val();
            var idProceso = $("#hf_idProceso", parent.document).val();
            var idUsuDest = $("#hf_ssidUsuRemit", parent.document).val();  //Aquí se invierten los usuarios ya que es respuesta a una notificación recibida            
            var idUsuRemit = $("#hf_idUsuario").val();

            if (fValidaTextArea()) {
                var actionData = "{'idFKUsuDest':'" + idUsuDest +
                                "','idFKProceso':'" + idProceso +
                                "','sAsunto':'" + sAsunto +
                                "','sMensaje':'" + respuestas +
                                 "','idUsuRemit':'" + idUsuRemit +
                                "'}";
                $.ajax({
                    url: "../Notificaciones/SNARESPON.aspx/EnviarRespuesta",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
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

        //Función que reemplaza los caracteres invalidos.
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        //Función que valida el campo #respuesta para verificar que no este vacio
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

        //función que cancela las acciones y cierra la ventana modal
        function Cancelar() {
            window.parent.fActualizaGrid($('#hf_idUsuario').val());
            window.parent.cancelar();
        }

        //Función que cierra la ventana modal
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
                <a id="CancelarActivo" href="javascript:Cancelar();" class="btnAct"  title="Botón de cancelar">Cerrar</a>
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
