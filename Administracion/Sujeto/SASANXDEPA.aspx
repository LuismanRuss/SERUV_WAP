<%@ Page Language="C#" AutoEventWireup="true" Inherits="SASANXDEPA" Codebehind="SASANXDEPA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../../styles/Sujeto.css" rel="stylesheet" type="text/css" />       
    <link href="../../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="../../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../scripts/jquery-ui-1.9.2.custom.min.js" type="text/javascript"></script>
   
    <script src="../../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../../scripts/Libreria.js" type="text/javascript"></script>
</head>
<body>
     <script type="text/javascript">
         var idAnexo;
         var anexo;
         var strDProceso;
         var idApartado;
         var accion;
         var idparticipante;
         var dependencia;
         var idusuario;
         var idusuarioLOG;
         var idproceso;
         var datosJSON;

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
         };

         //*****************************************
         $(document).ready(function () {
             navegador();

             idAnexo = $("#IdAnexo", parent.document).val();
             idApartado = $("#intApartado", parent.document).val();
             strDProceso = $("#hf_strDProceso", parent.document).val();            
             anexo = $("#Anexo", parent.document).val();
             accion = $("#Accion", parent.document).val();
             idparticipante = $("#IdParticipante", parent.document).val();
             dependencia = $("#hf_intDependencia", parent.document).val();
             //************************************************
             idusuarioLOG = $("#hf_idUsuario", parent.document).val();
             idusuario = $("#hf_idSO", parent.document).val();
             idproceso = $("#hf_intIdProceso", parent.document).val();
          
             $('#lblanexo').text(anexo);
             $('#lblProceso').text(strDProceso);

             if (accion == "EXCLUIR") {                
                 $('#lblinstrucciones').text("Ingrese la justificación del porque se excluye el anexo seleccionado de la entrega.");
             }
             if (accion == "INCLUIR") {                
                 $('#lblinstrucciones').text("Ingrese la justificación del porque se incluye el anexo seleccionado de la entrega.");
             }

             //------------------------------------------
         });
         //****************************************
       
       //FUNCIÓN UTILIZADA PARA INCLUIR Y EXCLUIR UN ANEXO
         function Enviar() {
            loading2.ini();
            var strDatos = "";
            $("#just").val(jsTrim($("#just").val()));  
            var justifica = $('#just').val();

            justifica = jsTrim(justifica);
            justifica = justifica.replace(/\n\r?/g, ' ');          
            justifica = justifica.split('"').join('\'');

            var idanexo = idAnexo;
             strDatos = "";        
            if (ValidaTextArea()) {

            if (accion == "EXCLUIR") {               
                if (datosJSON == null) {

                     strDatos = '{"idAnexo":' + idanexo +
                                ',"strJustificacion":"' + justifica + '"' +
                                 ',"idUsuario":' + idusuario +
                                 ',"idUsuarioLOG":' + idusuarioLOG +
                                 ',"idParticipante":' + idparticipante +
                                 ',"idProceso":' + idproceso +
                                  ',"idDependencia":' + dependencia +
                                 ',"idApartado":' + idApartado + 
                                ',"strAccion":"EXCLUIR"' +
                                "}";                    
                     datosJSON = eval('(' + strDatos + ')');
                 }
                 actionData = frms.jsonTOstring({ objAnexo: datosJSON });

                 $.ajax(
                    {
                        url: "SASANXDEPA.aspx/guardaJustificacion",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            loading2.close();
                            CerrarModalE(reponse.d, idApartado);

                        },                       
                        error: function (result) {
                            loading2.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            loading2.close();
                        }
                    });
             }
                if (accion == "INCLUIR") {                   
                    if (datosJSON == null) {

                         strDatos = '{"idAnexo":' + idanexo +
                                ',"strJustificacion":\"' + justifica + '\"' +
                                 ',"idUsuario":' + idusuario +
                                  ',"idUsuarioLOG":' + idusuarioLOG +
                                 ',"idParticipante":' + idparticipante +
                                 ',"idProceso":' + idproceso +
                                 ',"idDependencia":' + dependencia +
                                 ',"idApartado":' + idApartado +
                                ',"strAccion":"INCLUIR"' +
                                "}";                        
                        datosJSON = eval('(' + strDatos + ')');
                    }
                    actionData = frms.jsonTOstring({ objAnexo: datosJSON });

                    $.ajax(
                    {
                        url: "SASANXDEPA.aspx/incluirAnexo",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                           loading2.close();
                            CerrarModalI(reponse.d, idApartado);                      
                        },                        
                        error: function (result) {
                            loading2.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            loading2.close();
                        }
                    });
             }
             }
            else {
              
             }


        }

        // Función para eliminar los espacios de inicio y fin de una cadena
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }
         

//       VALIDA EL TEXTAREA DE LONGITUD Y ESPACIOS EN BLANCO
        function ValidaTextArea() {
            $("#just").val(jsTrim($("#just").val()));          
             var text = $("#just").val();
             blnCorrecto = false;
             text = jsTrim(text);
             text = text.replace(/\n\r?/g, ' ');            

             //cuenta el número de caracteres del texto y lo convierte a entero  
             var cantidad = parseInt(text.length);          
             if (cantidad > 0) {
                 blnCorrecto = true;
                 if (cantidad > 499) {
                     loading.close();
                     $.alerts.dialogClass = "incompletoAlert";
                     jAlert("No se permite más de 500 caracteres", "SISTEMA DE ENTREGA - RECEPCIÓN");
                     blnCorrecto = false;
                 }             
             }
             else {
                 loading.close();
                 $.alerts.dialogClass = "incompletoAlert";
                 jAlert("Favor de agregar una justificación.", "SISTEMA DE ENTREGA - RECEPCIÓN");
             }
             
             return blnCorrecto;
         }

         //para cerrar el modal despues de Incluir
         function CerrarModalI(mensaje, apartado) {
             window.parent.cerrarPrespI(mensaje, apartado);
         }

         //cerrar el modal despues de excluir
         function CerrarModalE(mensaje, apartado) {
             window.parent.cerrarPrespE(mensaje, apartado);
         }
         //Cerrar la ventana 
         function Cancelar() {             
             window.parent.cancelar();
         }


       </script>
    <form id="form1" runat="server">
    <div id="agp_contenido">        
        <div id="lblinstrucciones" class="instrucciones"></div>        
        <!-- Desplegado contenidos -->                
        <h2>Proceso entrega - recepción:</h2><label id="lblProceso"> Conclusión de la Administración del Rector</label>
        <br />
        <h2>Anexo:</h2><label id="lblanexo"> Conciliación bancaria</label>
        <br />      
        <h2>Justificación:</h2><label> </label>

        <div class="cont_justificacion">
            <textarea autofocus id="just" rows="7" cols="99"></textarea> 
        </div>
            
        <!-- fin Desplegado contenidos -->
        <div class="a_botones">
            <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">Enviar</a> 
          <!-- <a id="CancelarActivo" href="javascript:Cancelar();" class="btnIna"  title="Botón de cancelar">Cancelar</a>-->
            <a id="CancelarActivo" href="javascript:Cancelar();" class="btnAct"  title="Botón de cancelar">Cancelar</a>
  
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </form>

</body>
</html>
