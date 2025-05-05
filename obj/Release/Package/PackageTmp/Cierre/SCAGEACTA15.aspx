<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SAGEACTA15" Codebehind="SCAGEACTA15.aspx.cs" %>

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
        Sort_SCAGEACTA7[0] = [{ "bSortable": false }, null, null, null];
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
        <h2 class="titulo2">XI. Documentación diversa</h2>    
        <br />
        <h2>UVCG-XI-DD-01 Relación de expediente de personal</h2>
        <div id="secCUATRO" class="conSeccion">   
            <label>Cantidad de expedientes:</label><input type="text" /> 
            <label>Fojas:</label><input type="text" />                                      
        </div>
        <br />
          <h2>UVCG-XI-DD-02 Relación de archivo común</h2>
        <div id="Div1" class="conSeccion">                          
            <label>Fojas:</label><input type="text" />                                       
        </div>   
         <br />
        <h2>UVCG-XI-DD-03 Relación de matrícula de alumnos del último período escolar</h2>
        <div id="Div2" class="conSeccion">   
            <label>Cantidad de alumnos:</label><input type="text" /> 
            <label>Entidad académica:</label><input type="text" /> 
            <label>Fojas:</label><input type="text" />                                      
        </div>     
         <br />
         <h2>UVCG-XI-DD-04 Relación de expedientes de alumnos activos y egresados</h2>
        <div id="Div3" class="conSeccion">   
            <label>Alumnos activos:</label><input type="text" /> 
            <label>Alumnos egresados:</label><input type="text" /> 
            <label>Fojas:</label><input type="text" />                                      
        </div>
         <br />
          <h2>UVCG-XI-DD-05 Relación de cartas de pasantes </h2>
        <div id="Div4" class="conSeccion">                          
            <label>Cantidad de cartas de pasantes:</label><input type="text" />  
            <label>Fojas:</label><input type="text" />                                     
        </div>   
         <br />
        <h2>UVCG-XI-DD-06 Relación de certificados de estudios profesionales y de posgrado</h2>
        <div id="Div5" class="conSeccion">   
            <label>Cantidad de certificados:</label><input type="text" />             
            <label>Fojas:</label><input type="text" />                                      
        </div>     
         <br />
           <h2>UVCG-XI-DD-07 Relación de autorizaciones de examen profesional o de grado académico</h2>
        <div id="Div6" class="conSeccion">   
            <label>Candidato de autorizaciones de examen:</label><input type="text" />           
            <label>Fojas:</label><input type="text" />                                      
        </div>
         <br />
          <h2>UVCG-XI-DD-08 Relación de actas de examen profesional o de grado académico </h2>
        <div id="Div7" class="conSeccion">                          
            <label>Cantidad de actas:</label><input type="text" />  
            <label>Fojas:</label><input type="text" />                                     
        </div>   
         <br />
        <h2>UVCG-XI-DD-09 Relación de títulos profesionales o de grado académico</h2>
        <div id="Div8" class="conSeccion">   
            <label>Cantidad de títulos profesionales:</label><input type="text" />             
            <label>Fojas:</label><input type="text" />                                      
        </div>    
         <div class="a_botones">
            <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">Enviar</a>        
            <a id="CancelarActivo" href="javascript:Cancelar();" class="btnIna"  title="Botón de cancelar">Cancelar</a>
  
        </div>      
    </div>
    </form>
</body>
</html>
