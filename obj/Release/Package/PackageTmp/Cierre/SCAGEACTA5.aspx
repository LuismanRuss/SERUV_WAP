<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA5" Codebehind="SCAGEACTA5.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <script type="text/javascript">
         $(document).ready(function () {
             $("#txtFechaAutorizacion").mask("99-99-9999");
             $('#dFNombram').mask("99-99-9999");

             $('#txtFechaAutorizacion').datepicker(vDate);
             $('#dFNombram').datepicker(vDate);

             var idParticipante; // = NG.Var[NG.Nact - 1].datoSel.nIdParticipante;
         });

         function Bloque1() {
             urls(6, "SCAGEACTA.aspx");
         }

         function Bloque3() {
             urls(6, "SCAGEACTA3.aspx");
         }
         function Bloque4() {
             urls(6, "SCAGEACTA4.aspx");
         }
         function Bloque5() {
             urls(6, "SCAGEACTA5.aspx");
         }
    </script>
</head>
<body>
     <form id="SCAGEACTA4" runat="server">
    <div id="agp_contenido">
        <div class="a_bloques">
            <a id="DatosGenerales" title="Datos Generales" href="javascript:Bloque1();" class="accInaBloq">Datos Generales</a>
            <a id="Participantes" title="Participantes" href="javascript:Bloque2();" class="accBloq">Participantes</a>
            <a id="A1" title="Apartados" href="javascript:Bloque4();" class="accBloq">Testigos</a>
            <a id="Apartados" title="Apartados" href="javascript:Bloque3();" class="accBloq">Diligencias</a>
            <a id="A2" title="Apartados" href="javascript:Bloque5();" class="accBloq">Declaraciones</a>
        </div>
        <div id="agp_navegacion">
            <label class="titulo">ACTA ENTREGA - RECEPCIÓN - Declaraciones</label>
            <div class="a_acciones">
                <a id="AccGuardar" title="Guardar" href="javascript:fGuardar();" class="accAct ">Guardar</a>
                <a id="AccImprimir" title="Imprimir" href="javascript:fImprimir();" class="accAct ">Imprimir</a>
            </div>
        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)"
                onmouseout="MM_swapImgRestore()">
                <img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>
        </div>

       <div class="instrucciones"> ¿Instrucciones?</div>

        <%-----------------------------------------------FORMULARIO--------------------------------------------------------%>
        <div id="divDatosSuperior">

        </div>

  <%--      <div id="titDOS" class="titSeccion">
            <div id="Tit_DOS" class="dActionA" onclick="fn_accordion('DOS')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('DOS')" id="d_lDOS" title="Expandir">Declaraciones</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desB" onmouseover="MM_swapImage('im_desB','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secDOS" class="conSeccion" style="display: none">
        <br />
        <h2>UVCG-XIV-OP-02 Relación de compromisos pendientes derivados de procesos de entrega-recepción</h2><br /><br />
            <label>Núm. de compromisos:</label><input type="text" id="Text4" size="50px"/>                        
            <label>Fojas:</label><input type="text" id="Text5" />           
            <br /><br />
        <h2>UVCG-XIV-OP-03 Relación de observaciones y/o sugerencias de los auditores externos </h2><br /><br />
            <label>Núm. de observaciones:</label><input type="text" id="Text1" size="50px"/>                        
            <label>Fojas:</label><input type="text" id="Text2" />           
            <br /><br />
        <h2>UVCG-XIV-OP-04 Relación de observaciones y/o recomendaciones de los órganos superiores de fiscalización </h2><br /><br />
            <label>Núm. de observaciones:</label><input type="text" id="Text3" size="50px"/>                        
            <label>Fojas:</label><input type="text" id="Text6" />           
            <br /><br />
         <h2>UVCG-XV-AD-01 Combinación de caja fuerte en sobre cerrado </h2><br /><br />
            <label>Núm. de observaciones:</label><input type="text" id="Text7" size="50px"/>                        
            <label>Fojas:</label><input type="text" id="Text8" />           
            <br /><br />
         <h2>UVCG-XV-AD-02 Relación de llaves de mobiliario, equipo y oficinas</h2><br /><br />
            <label>Cantidad de llaves:</label><input type="text" id="Text9" size="50px"/>                        
            <label>Fojas:</label><input type="text" id="Text10" />           
            <br /><br />
         <h2>UVCG-XV-AD-03 Relación de sellos oficiales</h2><br /><br />
            <label>Cantidad de sellos:</label><input type="text" id="Text11" size="50px"/>                        
            <label>Fojas:</label><input type="text" id="Text12" /> 
           <br /><br />     --%>   
       <h2>Texto Libre</h2> <br />
          <textarea autofocus id="Textarea1" rows="7" cols="99"></textarea>  
          <br /><br />      
          <label>Hora de cierre del acta:</label><input type="text" id="Text13" />   

        </div>
        <br />
       
            <%-----------------------------------------------------------------------------------------------------------------%>
        <br /><br />

        <div id="a_abajo"></div> <%--Capa para que vaya al final de la página--%>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()">
            <img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>
        </div>
        

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_NG" runat="server" />
        </div>
    </div>

    </form>
</body>
</html>
