<%@ Control Language="C#" AutoEventWireup="true" Inherits="Encabezado" Codebehind="Encabezado.ascx.cs" %>

<div id="agp_encabezado">
    
    <%--Registro de logeo y cierre de sesión--%>
    <form id="form1" runat="server">
    <div class="h1_encabezado">Universidad Veracruzana</div>    
        <div id="logeo">            
            <img alt="" title="Usuario registrado en el SERUV" src="../images/ico-usuario.png" /> <asp:Label ID="lbl_Usuario" runat="server" CssClass="logeo-usuario" Text="Usuario"></asp:Label>        
            <a href="#" onclick="muestra_oculta('contenido_a_mostrar')" title=""><img alt="" src="../images/ico-despliegue.png" /></a>    
            <br />
            <div id="contenido_a_mostrar">
                <asp:ImageButton ID="ImageButton1" runat="server" ToolTip="Opción salir del Sistema" ImageUrl="~/images/btn_cerrarsesion.png" OnClick="imb_Salir_Click" />            
            </div> 
        </div>  
    </form>
    <br />
    
<%--    <div id="nombre-sistema">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <img alt="Sistema de Entrega - Recepción de la Universidad Veracruzana SERUV" src="../images/logo.jpg" /> Sistema de Entrega - Recepción SERUV [Desarrollo]
        <img alt="Sistema de Entrega - Recepción de la Universidad Veracruzana SERUV" src="../images/logo.jpg" /> Sistema de Entrega - Recepción SERUV [Entrenamiento]
        <img alt="Sistema de Entrega - Recepción de la Universidad Veracruzana SERUV" src="../images/logo.jpg" /> Sistema de Entrega - Recepción SERUV [Pruebas]
        <img alt="Sistema de Entrega - Recepción de la Universidad Veracruzana SERUV" src="../images/logo.jpg" /> Sistema de Entrega - Recepción SERUV
    </div>--%>

    <div id="div_NombreSistema" runat="server">
        <img alt="Sistema de Entrega - Recepción de la Universidad Veracruzana SERUV" src="../images/logo.jpg" />&nbsp;&nbsp;&nbsp;Sistema de Entrega - Recepción SERUV 
    </div>

    <div id="agp_menu">        
        <!--
            <ul>   
                <li class="op-administracion"><a href="../Administracion/SATADMINI.aspx">Administración <img id="Img1" alt="Opción Administración" src="../images/ico-administracion.png" /></a></li>
                <li class="op-registro"><a href="../Registro/SCTREGIST.aspx">Registro <img id="Img2" alt="Opción Registro" src="../images/ico-registro.png" /></a></li>
                <li class="op-avance">Seguimiento <img id="Img3" alt="Opción Avances" src="../images/ico-avances.png" /></li>
                <li class="op-reportes">Reportes <img id="Img4" alt="Opción Reportes" src="../images/ico-reportes.png" /></li>
                <li class="op-supervision">Supervisión <img id="Img5" alt="Opción Monitoreo" src="../images/ico-monitoreo.png" /></li>                
            </ul>
            -->
        <ul id="ul_Menu" runat="server">
        </ul>
    </div>
    
</div>
