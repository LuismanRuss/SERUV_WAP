<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA2" Codebehind="SCAGEACTA2.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">

        $(document).ready(function () {
            loading.close();
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
    <form id="SCAGEACTA2" runat="server">
    <div id="agp_contenido">
        <div class="a_bloques">
           <a id="DatosGenerales" title="Datos Generales" href="javascript:Bloque1();" class="accInaBloq">Datos Generales</a>
            <a id="Participantes" title="Participantes" href="javascript:Bloque2();" class="accBloq">Participantes</a>
            <a id="A1" title="Apartados" href="javascript:Bloque4();" class="accBloq">Testigos</a>
            <a id="Apartados" title="Apartados" href="javascript:Bloque3();" class="accBloq">Diligencias</a>
            <a id="A2" title="Apartados" href="javascript:Bloque5();" class="accBloq">Declaraciones</a>
        </div>
        <div id="agp_navegacion">
            <label class="titulo">ACTA ENTREGA - RECEPCIÓN - Participantes</label>
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
            <div class="dLabelA" onclick="fn_accordion('DOS')" id="d_lDOS" title="Expandir">Datos Sujeto Obligado</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desB" onmouseover="MM_swapImage('im_desB','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secDOS" class="conSeccion" style="display: none">
            <label>Nombre:</label><input type="text" size="175px"/>
            <label>Número de personal:</label><input type="text" id="txtNoPersonal" /> <%--NUEVO--%>
            <br />
            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text" size="199px"/>
            <label>C.P.:</label><input type="text"/>             
            <label>Municipio:</label><input type="text" size="100px"/>
            <label>Ciudad:</label><input type="text" size="112px"/>

        </div>
        <br />

        <div id="titTRES" class="titSeccion">
            <div id="Tit_TRES" class="dActionA" onclick="fn_accordion('TRES')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('TRES')" id="d_lTRES" title="Expandir">Datos del Administrador de la entidad academica/dependencia</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desC" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secTRES" class="conSeccion" style="display: none">
            <label>Nombre del administrador de la entidad académica/dependencia:</label><input type="text" size="100px"/>
            <label>Número de personal:</label><input type="text" id="Text1" />
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text" size="199px"/>
            <label>C.P.:</label><input type="text"/>           
            <label>Municipio:</label><input type="text" size="100px"/>
            <label>Ciudad:</label><input type="text" size="112px"/>  
        </div>
        <br />

        <div id="titCUATRO" class="titSeccion">
            <div id="Tit_CUATRO" class="dActionA" onclick="fn_accordion('CUATRO')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('CUATRO')" id="d_lCUATRO" title="Expandir">Datos del Titular entrante (Sujeto receptor)</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="Img1" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secCUATRO" class="conSeccion" style="display: none">
            <label>Nombre:</label><input type="text" size="100px"/>
            <label>Número de personal:</label><input type="text" id="Text2" />
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text" size="199px"/>
            <label>C.P.:</label><input type="text"/>
            <label>Municipio:</label><input type="text" size="100px"/>
            <label>Ciudad:</label><input type="text" size="112px"/>  
        </div>
        <br />

        <div id="titCINCO" class="titSeccion">
            <div id="Tit_CINCO" class="dActionA" onclick="fn_accordion('CINCO')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('CINCO')" id="d_lCINCO" title="Expandir">Datos del Auditor</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="Img2" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>        

        <div id="secCINCO" class="conSeccion" style="display: none">
            <label>Nombre:</label><input type="text" size="100px"/>
            <label>Número de personal:</label><input type="text" id="Text3" />
            <br />

            <h2>Domicilio particular</h2>
            <br />
            <label>Calle:</label><input type="text" size="163px"/>
            <label>Número Ext:</label><input type="text" size="10px"/>
            <label>Número Int:</label><input type="text" size="10px"/>
            <br />

            <label>Colonia:</label><input type="text" size="199px"/>
            <label>C.P.:</label><input type="text"/>
            <label>Municipio:</label><input type="text" />
            <label>Ciudad:</label><input type="text" />  
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
