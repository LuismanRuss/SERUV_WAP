<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SMCONSULV" Codebehind="SMCONSULV.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%--  <meta charset="UTF-8" />--%>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />    
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    
</head>
 
<body>
 <script type="text/javascript">
     var settings;

     var userAgent = navigator.userAgent.toLowerCase();
     var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
     var chrome = /chrome/.test(userAgent);
     var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
    
     function navegador() {
         if (safari)
             $('#navegador').val("safari");
         if (chrome)
             $('#navegador').val("chrome");
         if ($.browser.msie)
             $('#navegador').val("IE");
         if (mozilla)
             $('#navegador').val("mozilla");
     }

     $(document).ready(function () {      
         NG.setNact(1, 'Uno');
         $('#lblproceso').text($("#hf_proceso", parent.document).val());
         $('#lblanexo').text($("#hf_anexo", parent.document).val());
         NG.Var[NG.Nact - 1].datoSel = eval('(' + $("#hf_NG", parent.document).val() + ')');

         if (NG.Var[NG.Nact - 1].datoSel != null) {
             $("#hf_NG", parent.document).val("");
             fPinta_Grid(NG.Var[NG.Nact - 1].datoSel.lstArchivos);
         }
         else {
             fPinta_Grid(null);
         }

     });


     function fRepintaGrid(objAnexo) {
         NG.Var[NG.Nact - 1].datoSel = (objAnexo != null ? objAnexo : null);
         NG.Var[NG.Nact - 1].datoSel = objAnexo;
        
         fPinta_Grid(NG.Var[NG.Nact - 1].datoSel.lstArchivos);
     }

     //función pinta la lista de archivos para poder ser visualizados
     function fPinta_Grid(cadena) {        
         $('#ul_listaArchivo').empty();
         mensaje = { "mensaje": "No se han cargado archivos relacionados al anexo." }
         if (cadena == null) {
             $('#ul_listaArchivo').append('<li">' + mensaje.mensaje + '</li>');
             return false;
         }       
         $('#ul_listaArchivo').append(pTablaI(cadena));

     };
     //Función que elabora la lista de archivos 
     function pTablaI(tab) {
         var sFormato = null;
         var sNArchivo = null;       
         NG.Var[NG.Nact].datos = tab;
         htmlTab = '';
         var intTotalA=0;
         for (a_i = 0; a_i < tab.length; a_i++) {
             intTotalA = intTotalA + 1;
             htmlTab += '<li id="aApartado' + tab[a_i].idAp + '"><a class="archivo"  href ="javascript:fArchivos(\'' + tab[a_i].gidFormato + '\',\'' + tab[a_i].strNomArchivo + '\');" >' + intTotalA+". "+ tab[a_i].strNomArchivo + '</a></li>';
             if (a_i == 0) {
                 sFormato = tab[a_i].gidFormato;
                 sNArchivo = tab[a_i].strNomArchivo;
            }
         }
         $("#lbl_total").text(intTotalA);
         fArchivos(sFormato, sNArchivo);
         return htmlTab;
     }

     //función que se ejecuta en el momento de dar clic en un archivo
     function fArchivos(sFormato, sNArchivo) {
         if ((sFormato != null) && (sNArchivo != null)) {
             loading.ini();          
          $('#div_pdf').empty().append('<iframe id="if_pdf" scrolling="no" src="../General/SGDDESCAR.aspx?guid=' + sFormato + '&strOpcion=ARCHIVO&strVer=SI" style="width: 100%; height:430px; overflow:hidden;"></iframe>');

          if ($('#if_pdf')) {
              //Permite cerrar el loading en ie
                  if (window.ActiveXObject) {
                  //************************************
                      document.getElementById("if_pdf").onreadystatechange = function () {                         
                          if (document.getElementById("if_pdf").readyState == "complete" || document.getElementById("if_pdf").readyState == "loaded") {                            
                              loading.close();
                          }
                      };
                      //*******************************************
                  }
                //Permite cerrar el loading en los demas navegadores
                  $('#if_pdf').load(function () {                   
                      loading.close();
                  });           
              }    
         }  
             
     }
   
    
     function fCerrar() {
         $('#div_pdf').empty();         
         parent.window.fCerrarDialog2();
     }
    </script>
       
     <form id="SCCONSULV" runat="server">
        <div id="fixme"></div>
        <div id="agp_contenido">
            <%--<div class="instrucciones">¿Instrucciones?</div>--%>
            <br />          
             <h2>Proceso entrega - recepción:</h2><label id="lblproceso"></label>
             <br />
             <h2>Anexo:</h2><label id="lblanexo"></label>
             <div id="div_archivosAnexo" class="easyui-layout" style="width: 99%; height: 435px; border-style:solid; border-color:Black" >                           
                <div title="Archivos" style="border: 1px solid #d0d0d0; width: 19%; height:435px; float:left; overflow:auto; display:inline-block">      
                    <label id="Label1">Total de archivos :</label><label id="lbl_total"></label> 
                    <br />   <br />      
                    <ul id="ul_listaArchivo" style="font-size:10pt; font-family:Arial">
                    </ul>
                </div>
                <div id="div_pdf" title='div_pdf' style="width: 80%; height:435px; float:right; border: 1px solid #d0d0d0; display:inline-block; overflow:hidden;">  
                <label>Seleccione un archivo</label>     
                             
                       <%-- <iframe id="if_pdf" style="width: 100%; height:400px; overflow:hidden;"></iframe>   --%>           
                </div>
               <%-- <div id="loading"></div>
                <div id="zoliframe" style="width: 79%; height:405px; float:right; border: 1px solid #d0d0d0; display:inline-block; overflow:hidden;"></div>--%>
            </div>

            <div class="a_botones_modal">
                <a title="Botón Cerrar" id="lnk_cerrar" href="javascript:fCerrar();" class="btnAct">Cerrar</a>        
            </div>
        
    <%--            <a id="hrf_cargar" href="J avascript:fCargar();">Cargar</a>  
                <a id="hrf_cerrar" href="J avascript:fCerrar();">Cerrar</a> --%> 
        
            <div id="div_ocultos">
                <input id="hf_anexo" type="hidden" />    
            </div>
     </div>
    </form>
</body>
</html>
