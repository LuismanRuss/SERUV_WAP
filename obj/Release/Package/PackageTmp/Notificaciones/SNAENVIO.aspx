<%@ Page Language="C#" AutoEventWireup="true" Inherits="Notificaciones_SNAENVIO" Codebehind="SNAENVIO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />

    <script type="text/javascript">

        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
        var arregloUsuarios = null;//arreglo que contiene el id de los usuarios a los cuales se les enviara el correo

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
            NG.setNact(2, 'Dos', botonesNotifi);
            loading.close();
            var idSupervisor = $("#hf_idUsuario").val();
//            console.log(idSupervisor);
            navegador();
        });

        function Cancelar() {
            loading.ini();
            urls(2, "../Notificaciones/SNMNOTIFI.aspx");
        }

        function Buscar() {
            //loading.ini();
//            $("#txt_Cuenta").val(jsTrim($("#txt_Cuenta").val()));
//            if ($("#txt_Cuenta").val().length > 0) {
                BuscaUsuarios();
//            } else {
//                loading.close();
//                //LimpiaCamposUsuario();
//                $.alerts.dialogClass = "incompletoAlert";
//                jAlert("Indique una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
//            }
        }

        function BuscaUsuarios() {
            dTxt = '<div id="dComent" title="Seleccionar destinatario(s)">';
            dTxt += '<iframe id="SNCUSUARI" src="../Notificaciones/SNCUSUARI.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SNAENVIO').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 600,
                width: 1100,
                modal: true,
                resizable: false
            });
        }

        function LimpiaCamposUsuario() {
            $("#txt_Cuenta").val("");
//            $("#txt_Nombre").val("");
//            $("#txt_Correo").val("");
//            $("#txt_Dependencia").val("");
//            $("#txt_Puesto").val("");
        }


        function CerrarDialogoUsuario() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        function fn_cerrarPform(arregloCorreos, arregloUsu) {
            arregloUsuarios = arregloUsu;
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
            $('#txt_Cuenta').val(arregloCorreos);
        }

        function Enviar() {
            var correos = $("#txt_Cuenta").val();
            var recomendacion = $("#txt_recomendacion").val();
            var idUsuario = $("#hf_idUsuario").val();
            var arregloUsu = arregloUsuarios;
            var asunto = $("#txt_Asunto").val(); 

            if (correos == '' || recomendacion == null || recomendacion == '' || asunto == null || asunto == '') {
                $.alerts.dialogClass = "infoAlert";
                jAlert("Debe llenar todos los campos.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            } else {
                var actionData = "{'correos': '" + correos +
                                "','recomendacion': '" + recomendacion +
                                "','idUsuario': '" + idUsuario +
                                "','arregloUsuarios': '" + arregloUsu +
                                "','asunto': '" + asunto +
                                "'}";
                $.ajax({
                    url: "../Notificaciones/SNAENVIO.aspx/EnviarCorreo",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var resp = reponse.d;

                        //console.log(resp);                        
                        switch (resp) {
                            case 0:
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () { //Los datos no se actualizaron.
                                    Cancelar();
                                });
                            case 1:
                                loading.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert('Se realizó satisfactoriamente el envío de su notificación.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                    Cancelar();
                                });
                                
                                break;
                        }
                    },
                    error: errorAjax
                });
            }
        }
        
        
        
    </script>


</head>

<body>
    <form id="SNAENVIO" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Notificaciones - Redactar correo</label>
            </div>
            <div class="instrucciones">Capture los campos correspondientes.</div>

            <h3>Destinatario(s):</h3>
            <label><input id="txt_Cuenta" type="text" autofocus="focus" size="100" disabled = "disabled" />            
            <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:Buscar();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
                <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>
            </label>
            <br />
            <h3>Asunto:</h3>
            <input id="txt_Asunto" type="text" autofocus="focus" size="100" maxlength="150" />
            <br />
                                  
            <h3>Recomendación:</h3><br />
            <div class="align_Textarea">   
                <textarea id="txt_recomendacion" rows="10" cols="100" autofocus></textarea>             
            </div>
            <br/><br />
            
            <div class="a_botones">
                <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">Enviar</a>                          
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
