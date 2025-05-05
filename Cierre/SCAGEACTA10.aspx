<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA10" Codebehind="SCAGEACTA10.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title></title>
           <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Sujeto.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
     <link href="../styles/Acta.css" rel="stylesheet" type="text/css" />
 
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script> 
    <script src="../scripts/DataTables.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var Sort_SCAGEACTA7 = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SCAGEACTA7[0] = [{ "bSortable": false }, null, null, null, null];
        Sort_SCAGEACTA7[1] = [[1, "asc"]];


        $(document).ready(function () {
            $("#txtFechaAutorizacion").mask("99-99-9999");
            $('#dFNombram').mask("99-99-9999");
            var idParticipante;
            //   NG.setNact(2, 'Dos', null);

            idAnexo = $("#hf_IdApartado", parent.document).val();
            sCApartado = $("#hf_cApartado", parent.document).val();
            sDApartado = $("#hf_dApartado", parent.document).val();
            //  alert(sDApartado);
            $(".titulo2").text(sCApartado + ' ' + sDApartado);

        });


        function fn_accordion(a_num) {
            aa = '#sec' + a_num;
            bb = '#Tit_' + a_num;
            cc = "#d_l" + a_num;
            if ($(aa).is(':visible')) {
                $(aa).hide();
                $(bb).html('+').attr('title', 'Expandir');
                $(cc).attr('title', 'Expandir');
            } else {
                $(aa).show();
                $(bb).html('-').attr('title', 'Colapsar');
                $(cc).attr('title', 'Colapsar');
            }
        }


        function Bloque1() {
            urls(6, "SCAGEACTA.aspx");
        }

        function Bloque2() {
            urls(6, "SCAGEACTA2.aspx");
        }
        function Bloque4() {
            urls(6, "SCAGEACTA4.aspx");
        }
        function Bloque5() {
            urls(6, "SCAGEACTA5.aspx");
        }
        function Cancelar() {
            window.parent.cancelar();
        }
    </script>
</head>
<body>
    <form id="SCAGEACTA3" runat="server">
    <div id="agp_contenido">   
                
        <h2 class="titulo2">VI. Recursos Humanos</h2>   
            

         <div id="titUNO" class="titSeccion" style="margin-top: 1em;">
            <div id="Tit_UNO" class="dActionA" onclick="fn_accordion('UNO')" title="Colapsar">-</div>
            <div class="dLabelA" onclick="fn_accordion('UNO')" id="d_lUNO" title="Colapsar">UVCG-VI-RH-01 Plantilla de personal de la dependencia</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desA" onmouseover="MM_swapImage('im_desA','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
       <%-- <h2>UVCG-V-RF-01 Arqueo de caja del fondo rotatorio</h2>--%>
        <div id="secUNO" class="conSeccion"> 
            <label>Fojas:</label><input type="text"  />                                        
        </div>
           <div id="titDOS" class="titSeccion">
            <div id="Tit_DOS" class="dActionA" onclick="fn_accordion('DOS')" title="Expandir">-</div>
            <div class="dLabelA" onclick="fn_accordion('DOS')" id="d_lDOS" title="Expandir">UVCG-VI-RH-02 Copia del vale correspondiente a la devolución de la nómina de la última quincena pagada, sellada de recibido</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desB" onmouseover="MM_swapImage('im_desB','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
       <%-- <h2>UVCG-V-RF-02 Arqueo de caja de vales de gastos a comprobar</h2>--%>
        <div id="secDOS" class="conSeccion">           
            <label>Recibió:</label><input type="text"  />
            <label>Quincena:</label><input type="text" />
            <label>Ejercicio:</label><input type="text" />            
            <label>Fojas:</label><input type="text" />                                          
        </div>
             <div id="titTRES" class="titSeccion">
            <div id="Tit_TRES" class="dActionA" onclick="fn_accordion('TRES')" title="Expandir">-</div>
            <div class="dLabelA" onclick="fn_accordion('TRES')" id="d_lTRES" title="Expandir">UVCG-VI-RH-03 Relación de cheques de sueldos no cobrados y cancelados</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desC" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
       <%-- <h2>UVCG-IV-RF-03 Constancia de no adeudo</h2>--%>
      <div id="secTRES" class="conSeccion">           
            <label>Quincena:</label><input type="text"  />  
            <label>Fojas:</label><input type="text" />                                           
        </div>
        
        <div id="titCUATRO" class="titSeccion">
            <div id="Tit_CUATRO" class="dActionA" onclick="fn_accordion('CUATRO')" title="Expandir">-</div>
            <div class="dLabelA" onclick="fn_accordion('CUATRO')" id="d_lCUATRO" title="Expandir">UVCG-VI-RH-04 Nómina en proceso de pago</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desD" onmouseover="MM_swapImage('im_desD','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
       <%-- <h2>UVCG-IV-RF-03 Constancia de no adeudo</h2>--%>
        <div id="secCUATRO" class="conSeccion">           
            <label>Quincena:</label><input type="text" />           
            <label>Cantidad cheques pendientes:</label><input type="text" />             
            <label>Fojas:</label><input type="text" />                                        
        </div>
                     
        <div id="titCINCO" class="titSeccion">
            <div id="Tit_CINCO" class="dActionA" onclick="fn_accordion('CINCO')" title="Expandir">-</div>
            <div class="dLabelA" onclick="fn_accordion('CINCO')" id="Div1" title="Expandir">UVCG-VI-RH-05 Relación de becarios de la dependencia</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desE" onmouseover="MM_swapImage('im_desE','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
       <%-- <h2>UVCG-IV-RF-03 Constancia de no adeudo</h2>--%>
        <div id="secCINCO" class="conSeccion">           
            <label>Cantidad de becarios:</label><input type="text"  /> 
            <label>Fojas:</label><input type="text"/>                                           
        </div>        
        <div id="titSEIS" class="titSeccion">
            <div id="Tit_SEIS" class="dActionA" onclick="fn_accordion('SEIS')" title="Expandir">-</div>
            <div class="dLabelA" onclick="fn_accordion('SEIS')" id="Div2" title="Expandir">UVCG-VI-RH-06 Relación de prestadores de servicio social
</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desF" onmouseover="MM_swapImage('im_desF','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
       <%-- <h2>UVCG-IV-RF-03 Constancia de no adeudo</h2>--%>
        <div id="secSEIS" class="conSeccion">           
             <label>Cantidad:</label><input type="text"  />   
            <label>Fojas:</label><input type="text"/>                                                 
        </div>
        <br />          
         <div class="a_botones">
            <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">Enviar</a>        
            <a id="CancelarActivo" href="javascript:Cancelar();" class="btnIna"  title="Botón de cancelar">Cancelar</a>
  
        </div>      
    </div>
    </form>
</body>
</html>
