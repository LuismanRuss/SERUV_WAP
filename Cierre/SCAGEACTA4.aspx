<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA4" Codebehind="SCAGEACTA4.aspx.cs" %>

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
            <label class="titulo">ACTA ENTREGA - RECEPCIÓN - Testigos</label>
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

        <div id="titDOS" class="titSeccion">
            <div id="Tit_DOS" class="dActionA" onclick="fn_accordion('DOS')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('DOS')" id="d_lDOS" title="Expandir">Testigos del titular saliente</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desB" onmouseover="MM_swapImage('im_desB','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secDOS" class="conSeccion" style="display: none">
        <br />
        <h2>PRIMER TESTIGO</h2><br /><br />
            <label>Nombre:</label><input type="text"  size="100px"/>                        
            <label>Edad:</label><input type="text"  />
            <label>Estado civil:</label><input type="text" />
            <label>RFC:</label><input type="text"  />
            <label>Presta sus servicios en:</label><input type="text" />
            <label>Puesto / cargo:</label><input type="text"/>
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text"/>
            <label>C.P.:</label><input type="text"/>
            <label>Municipio:</label><input type="text"/>
            <label>Ciudad:</label><input type="text" />  
            <br /><br />
         <h2>SEGUNDO TESTIGO</h2><br /><br />
            <label>Nombre:</label><input type="text" size="100px"/>                        
            <label>Edad:</label><input type="text" />
            <label>Estado civil:</label><input type="text" />
            <label>RFC:</label><input type="text"  />
            <label>Presta sus servicios en:</label><input type="text" />
            <label>Puesto / cargo:</label><input type="text" />
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text"/>
            <label>C.P.:</label><input type="text"/>
            <label>Municipio:</label><input type="text"/>
            <label>Ciudad:</label><input type="text" />  

        </div>
        <br />

        <div id="titTRES" class="titSeccion">
            <div id="Tit_TRES" class="dActionA" onclick="fn_accordion('TRES')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('TRES')" id="d_lTRES" title="Expandir">Testigo del titular entrante</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desC" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secTRES" class="conSeccion" style="display: none">
            <br />
           <h2>PRIMER TESTIGO</h2><br /><br />
            <label>Nombre:</label><input type="text"  size="100px"/>                        
            <label>Edad:</label><input type="text"  />
            <label>Estado civil:</label><input type="text" />
            <label>RFC:</label><input type="text" id="Text16" />
            <label>Presta sus servicios en:</label><input type="text" />
            <label>Puesto / cargo:</label><input type="text" />
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text"/>
            <label>C.P.:</label><input type="text"/>
            <label>Municipio:</label><input type="text"/>
            <label>Ciudad:</label><input type="text" />  
            <br /><br />
         <h2>SEGUNDO TESTIGO</h2><br /><br />
            <label>Nombre:</label><input type="text" size="100px"/>                        
            <label>Edad:</label><input type="text"  />
            <label>Estado civil:</label><input type="text" />
            <label>RFC:</label><input type="text" />
            <label>Presta sus servicios en:</label><input type="text"/>
            <label>Puesto / cargo:</label><input type="text"/>
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text"/>
            <label>C.P.:</label><input type="text"/>
            <label>Municipio:</label><input type="text" />
            <label>Ciudad:</label><input type="text" />  
        </div>
       
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
