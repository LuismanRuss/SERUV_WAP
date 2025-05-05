<%@ Page Language="C#" AutoEventWireup="true" Inherits="Logueo" Codebehind="Logueo.aspx.cs" %>

<%--<%@ Register src="EncabezadoLogueo.ascx" tagname="EncabezadoLogueo" tagprefix="uc1" %>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%--<meta charset="UTF-8" />--%>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="keywords" content="universidad veracruzana, UV, entrega recepción, transparencia, contraloría, información estratégica" />
    <meta name="description" content="Sistema de Entrega - Recepción de la Universidad Veracruzana " />
    <title>SISTEMA DE ENTREGA-RECEPCIÓN DE LA UNIVERSIDAD VERACRUZANA</title>
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
    <link href="styles/Logueo.css" rel="stylesheet" type="text/css" />
    <script src="scripts/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="scripts/jsScreenResolution.js" type="text/javascript"></script>
    <script language="JavaScript" type="text/javascript">
        var __dcid;

        $(document).ready(function () {
            $("#txt_Resolucion").val(jsGet_ScreenResolution());

            __dcid = __dcid || [];
            __dcid.push({ "cid": "DigiCertClickID_ysICnnSX", "tag": "ysICnnSX" });
            (function(){var cid=document.createElement("script");cid.async=true;cid.src="//seal.digicert.com/seals/cascade/seal.min.js";var s = document.getElementsByTagName("script");var ls = s[(s.length - 1)];ls.parentNode.insertBefore(cid, ls.nextSibling);}());

        })

        //var __dcid;

        //$(document).ready(function () {
        //    $("#txt_Resolucion").val(jsGet_ScreenResolution());

        //    __dcid = __dcid || [];
        //    __dcid.push({ "cid": "DigiCertClickID_7xmQw7Rh", "tag": "7xmQw7Rh" });
        //    (function () { var cid = document.createElement("script"); cid.async = true; cid.src = "//seal.digicert.com/seals/cascade/seal.min.js"; var s = document.getElementsByTagName("script"); var ls = s[(s.length - 1)]; ls.parentNode.insertBefore(cid, ls.nextSibling); }());

        //})
    </script>
</head>
<body>
    <div id="page">
        <%--VERSIÓN DE LOGUEO PARA EL PORTAL--%>
        <form id="form1" runat="server">
        <div class="div_Table">
            <div class="div_TableRow">
                <div class="div_TableCell">
                    <span class="span">Usuario:</span>
                </div>
                <div class="div_TableCell">
                    <asp:TextBox ID="txt_Cuenta" runat="server" CssClass="textboxBlur" MaxLength="25"
                        Width="130px" TabIndex="1" AccessKey="U" Value="Cuenta institucional" />
                </div>
            </div>
            <div class="div_TableRow">
                <div class="div_TableCell">
                    <span class="span">Contraseña:</span>
                </div>
                <div class="div_TableCell">
                    <asp:TextBox ID="txt_Contrasenia" runat="server" CssClass="textbox" MaxLength="35"
                        Width="130px" TextMode="Password" TabIndex="2" AccessKey="C" Value="12345....." />
                </div>
            </div>
        </div>
        <div class="div_Table">
            <div class="div_TableRow_ToRight">
                <div class="div_TableCell">
                    <div style="visibility: hidden">
                        <asp:TextBox ID="txt_Resolucion" runat="server" Width="65px"></asp:TextBox>
                    </div>
                </div>
                <div class="div_TableCell">
                    <asp:Button ID="btn_Aceptar" runat="server" Text="Entrar" OnClick="btn_Aceptar_Click"
                        CssClass="button" />
                </div>
            </div>
        </div>
        <div class="div_Message">
            <span id="spn_Msg" runat="server"></span>
        </div>

        <!-- DigiCert Seal HTML -->
        <!-- Place HTML on your site where the seal should appear -->
        <%--<div id="DigiCertClickID_ysICnnSX"></div>--%>
            <div id="DigiCertClickID_7xmQw7Rh" style="width:150px; height:71px;"></div>

        </form>
    </div>
</body>
</html>
