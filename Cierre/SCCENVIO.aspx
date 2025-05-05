<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCCENVIO" Codebehind="SCCENVIO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/SCIREGISTRO_LAYOUT.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Registro.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery.easyui.min.js" type="text/javascript"></script>

    <script type="text/javascript">
        // Función para que pueda ser visualizado en todos los navegadores lo relacionado a HTML5
        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
        var arregloUsuarios = null; //arreglo que contiene el id de los usuarios a los cuales se les enviara el correo

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
            NG.setNact(1, 'Uno', botonesNotifi);
            loading.close();
            var idSupervisor = $("#hf_idUsuario").val();
            
            navegador();
        });

        function botonesNotifi()
        { }


        // Función que regresa a la pantalla de llamada
        function Cancelar() {
            loading.ini();
            urls(1, "../Cierre/SCSCIEDEP.aspx");            
        }


        //Función para mandar a los usuarios a quienes se les mandará la notificación
        function Buscar() {

            BuscaUsuarios();
        }

        function BuscaUsuarios() {
            dTxt = '<div id="dComent" title="Seleccionar destinatario(s)">';
            dTxt += '<iframe id="SCCUSUARI" src="../Cierre/SCCUSUARIO.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SCCENVIO').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 600,
                width: 1100,
                modal: true,
                resizable: false
            });
        }

        //Función para limpiar campos si cuentan con datos capturados
        function LimpiaCamposUsuario() {
            $("#txt_Cuenta").val("");
        }

        // Función que cierra la ventana donde se muestra el listado de destinatarios
        function CerrarDialogoUsuario() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        // Función en donde recibe a un arreglo los id's de los destinatarios
        function fn_cerrarPform(arregloCorreos, arregloUsu) {
            arregloUsuarios = arregloUsu;
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
            $('#txt_Cuenta').val(arregloCorreos);
        }

        // Función que envía el correo electrónico
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
                    url: "../Cierre/SCCENVIO.aspx/EnviarCorreo",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var resp = reponse.d;

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
    <form id="SCCENVIO" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Redactar correo</label>
            </div>
            <div class="instrucciones">Capture los campos correspondientes.</div>

            <h3>Destinatario(s):</h3>
            <label><input id="txt_Cuenta" type="text" autofocus="focus" size="95" disabled = "disabled" />            
            <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:Buscar();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
                <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>
            </label>
            <br />
            <h3>Asunto:</h3>
            <input id="txt_Asunto" type="text" autofocus="focus" size="95" maxlength="150" />
            <br />
                                  
            <h3>Recomendación:</h3><br />
            <div class="align_Textarea">   
                <textarea id="txt_recomendacion" rows="10" cols="95" autofocus></textarea>             
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
