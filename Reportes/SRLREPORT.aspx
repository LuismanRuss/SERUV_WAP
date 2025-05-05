<%@ Page Language="C#" AutoEventWireup="true" Inherits="Reportes_SRLREPORT" Codebehind="SRLREPORT.aspx.cs" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" id="html">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">   
    html#html, body#body
    { 
        height: 98%;
    }
    
    form#form1, div#content
    {
        height: 100%;    
    }
    </style>


</head>
<body id="body">
    <form id="form1" runat="server">
        <div id="content">
            <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="360">
            </asp:ScriptManager>
            
            <rsweb:ReportViewer ID="ReportViewer1" runat="server"
                Height="100%" PageCountMode="Actual" ProcessingMode="Remote" Width="100%" 
                ZoomPercent="90">
            </rsweb:ReportViewer>

            <div id="div_ocultos2" style="visibility:hidden">
                <asp:HiddenField ID="hf_idPerfil" runat="server" />            
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
                <asp:HiddenField ID="IdGuiaER" runat="server" />
            </div>
        </div>
    </form>
</body>
</html>
