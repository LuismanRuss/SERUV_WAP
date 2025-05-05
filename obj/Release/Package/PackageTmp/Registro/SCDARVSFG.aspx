<%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCDARVSFG" Codebehind="SCDARVSFG.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>    
    <script type="text/javascript">
        /*Variables para determinar el navegador que utiliza el cliente*/
        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);

        /*Se lanza al principio de la carga de la página del lado del cliente*/
        $(document).ready(function () {
            var objAnexo = eval('(' + $("#hf_NG", parent.document).val() + ')'); // Se recupera el objeto anexo
            $("#hf_NG", parent.document).val(""); // Se borra el hidden donde se recuperó el objeto anexo
            $("#div_F").css("display", "none"); // Se esconden los "divs" donde se mostrará la información
            $('#div_U').css("display", "none"); // Se esconden los "divs" donde se mostrará la información

            switch (objAnexo.chrFuente) { // Condición para verificar la fuente de los formatos/guías (F=Formato, S=Sistema, U=url)
                case 'F': // Fuente por formato
                    $("#div_F").css("display", "block"); // Se muestra el div donde se mostraran los formatos/guías
                    $('#div_U').css("display", "none"); // Se esconde el div donde se muestra la fuente por url
                    if (objAnexo.docFormato != null) { // Se pregunta si el anexo tiene configurado un formato, si lo tiene se genera el link para descargarlo
                        strHtmlformato = "";
                        strHtmlformato += "<a class=\"linked\" title=\"Descarga de formato\" href=\"../General/SGDDESCAR.aspx?guid=" + objAnexo.docFormato.gidFormato + "&strOpcion=FORMATO\">" + objAnexo.docFormato.strNomArchivo + "</a>"
                        $("#lbl_aformato").empty().append(strHtmlformato);
                        $("#lbl_fAltaF").empty().append(objAnexo.docFormato.dteFAlta);
                    }
                    else { // Si no, se muestra un leyenda diciendo que no se tiene definido un formato
                        $("#lbl_aformato").empty().append("Formato no definido.");
                    }

                    if (objAnexo.docGuia != null) { // se pregunta si el anexo tiene configurado una guía, si lo tiene se genera el link para descargarlo
                        strHtmlGuia = "";
                        strHtmlGuia += "<a class=\"linked\" title=\"Descarga Instructivo\" target=\"_blank\" href=\"../General/SGDDESCAR.aspx?guid=" + objAnexo.docGuia.gidFormato + "&strOpcion=FORMATO\">" + objAnexo.docGuia.strNomArchivo + "</a>"
                        $("#lbl_aguia").empty().append(strHtmlGuia);
                        $("#lbl_fAltaG").empty().append((objAnexo.docGuia.dteFAlta != '' ? objAnexo.docGuia.dteFAlta : 'NO DEFINIDA'));
                    }
                    else { // Si no, se muestra uan leyenda diciendo que no tiene definida una guía
                        $("#lbl_aguia").empty().append("Instructivo no definido.");
                    }
                    break;
                case 'S': // Fuente por sistema
                    $("#div_F").css("display", "block"); // Se muestra el div donde se mostraran los formatos/guías
                    $('#div_U').css("display", "none"); // Se esconde el div donde se muestra la fuente por url
                    $("#divFuente").empty().append("<h2>Fuente:</h2>&nbsp;&nbsp;" + objAnexo.strNOficial);
                    if (objAnexo.docFormato != null) {// Se pregunta si el anexo tiene configurado un formato, si lo tiene se genera el link para descargarlo
                        strHtmlformato = "";
                        strHtmlformato += "<a class=\"linked\" title=\"Descarga de formato\" href=\"../General/SGDDESCAR.aspx?guid=" + objAnexo.docFormato.gidFormato + "&strOpcion=FORMATO\">" + objAnexo.docFormato.strNomArchivo + "</a>"
                        $("#lbl_aformato").empty().append(strHtmlformato);
                        $("#lbl_fAltaF").empty().append((objAnexo.docFormato.dteFAlta != '' ? objAnexo.docFormato.dteFAlta : 'NO DEFINIDA'));
                    }
                    else { // Si no, se muestra un leyenda diciendo que no se tiene definido un formato
                        $("#lbl_aformato").empty().append("Formato no definido.");
                    }

                    if (objAnexo.docGuia != null) { // se pregunta si el anexo tiene configurado una guía, si lo tiene se genera el link para descargarlo
                        strHtmlGuia = "";
                        strHtmlGuia += "<a class=\"linked\" title=\"Descarga Instructivo\" target=\"_blank\" href=\"../General/SGDDESCAR.aspx?guid=" + objAnexo.docGuia.gidFormato + "&strOpcion=FORMATO\">" + objAnexo.docGuia.strNomArchivo + "</a>"
                        $("#lbl_aguia").empty().append(strHtmlGuia);
                        $("#lbl_fAltaG").empty().append((objAnexo.docGuia.dteFAlta != '' ? objAnexo.docGuia.dteFAlta : 'NO DEFINIDA'));
                    }
                    else { // Si no, se muestra uan leyenda diciendo que no tiene definida una guía
                        $("#lbl_aguia").empty().append("Instructivo no definido.");
                    }
                    break;
                case 'U': // Fuente por url
                    objAnexo.strNOficial = (objAnexo.strNOficial.indexOf('http') >= 0 ? objAnexo.strNOficial : 'http:///' + objAnexo.strNOficial) // Se valida que la url contenga el protocolo "http" para poder abrir la url
                    strHtmlGuia = "";
                    $("#div_F").css("display", "none"); // Se esconde el div donde se mostraran los formatos/guías
                    $('#div_U').css("display", "block"); // Se mestra el div donde se muestra la fuente por url
                    strHtmlGuia += "<br /><div style=\"text-align: center;\">Para obtener el archivo de clic <a style=\"font-weight: bold; color: orange;\" title=\"Descarga Información\" target=\"_blank\" href=\"" + objAnexo.strNOficial + "\">aquí</a>.</div>"
                    $("#div_IR").empty().append(strHtmlGuia);
                    break;
            }
            /*Validación para la descarga de archivos por parte de usuarios de safari*/
            $('.linked').click(function () {
                var url = '';
                if (safari) {
                    if (location.protocol == 'https:') {
                        url = 'http:' + location.host + location.pathname.substring(0, location.pathname.substring(1, location.pathname.length).indexOf('/') + 1) + $(this).attr("href").substring(2, $(this).attr("href").length);
                        $(this).attr("href", url);
                    }
                }
            });

        });

        /*Cierra el Dialog*/
        function fCerrar() {
            window.parent.fCerrarDialogFG();
        }
    </script>

    <form id="form1" runat="server">
        <div class="agp_contenidoModal" id="div_F">
            <div class="instrucciones">Seleccione el tipo de información que desee descargar haciendo clic sobre el nombre del archivo.</div>
            <div id="divFuente"></div>
            &nbsp;&nbsp;<h2>Formato:</h2>&nbsp;&nbsp;<label id="lbl_aformato"></label>
            <br />
            &nbsp;&nbsp;<h2>Fecha de &uacute;ltima actualizaci&oacute;n del formato:</h2><label id="lbl_fAltaF"></label>
            <br />
            &nbsp;&nbsp;<h2>Instructivo:</h2>&nbsp;&nbsp;<label id="lbl_aguia"></label>
            <br />
            &nbsp;&nbsp;<h2>Fecha de &uacute;ltima actualizaci&oacute;n del instructivo:</h2><label id="lbl_fAltaG"></label>
            <br /><br />

            <div class="a_botones">
                <a title="Botón Cerrar" id="GuardarActivo" href="javascript:fCerrar();" class="btnAct">Cerrar</a>                 
            </div>            
        </div>     
        <div class="agp_contenidoModal" id="div_U">
            <%--<div class="instrucciones">Para descargar la información de clic en IR.</div>--%>
            <div id="div_IR"></div>
            <div class="a_botones">
                <a title="Botón Cerrar" id="A1" href="javascript:fCerrar();" class="btnAct">Cerrar</a>                 
            </div>            
        </div>     
    </form>
</body>
</html>
