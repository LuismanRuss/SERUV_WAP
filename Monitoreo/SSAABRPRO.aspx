<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SSAABRPRO" Codebehind="SSAABRPRO.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="UTF-8" />
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
        $(document).ready(function () {
            var nombreProc = $("#hf_nombreProc").val();
            var nombreDep = $("#hf_nombreDep").val();

            $("#lblProceso").text(nombreProc);
            $("#lblDepcia").text(nombreDep);
        });

        function fCerrar() {//función que cierra el dialog
            parent.window.fCerrarDialogAbrProc();
        }

        function fCerrarDialog() {
            window.parent.cancelar();
        }

        //       VALIDA EL TEXTAREA DE LONGITUD Y ESPACIOS EN BLANCO
        function ValidaTextArea() {
            var text = $("#just").val();
            blnCorrecto = false;
            text = text.replace(/\n\r?/g, ' ');

            //cuenta el número de caracteres del texto y lo convierte a entero  
            var cantidad = parseInt(text.length);
            if (cantidad > 0) {
                blnCorrecto = true;
                if (cantidad > 499) {
                    jAlert("No se permite más de 500 caracteres", "SISTEMA DE ENTREGA - RECEPCIÓN");
                    blnCorrecto = false;
                }
            }
            else {
                jAlert("Favor de agregar una justificación.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
            return blnCorrecto;
        }

        function Enviar() {//función que cierra el dialog y a la vez manda a ejecutar la función de abrir el proceso
            var justificacion = null;
            justificacion = $("#just").val();
            if (ValidaTextArea()) {//se manda a llamar la función que valida el textArea, si pasa la validación se manda a llamar la función que abrira el proceso
                window.parent.fAbrirProc(justificacion);
            }
        }

    </script>
    <form id="SSAABRPRO" runat="server">
    <div id="agp_contenido">
        <div id="lblinstrucciones" class="instrucciones">
        </div>
        <!-- Desplegado contenidos -->
        <h2>Proceso entrega - recepción:</h2>
        <label id="lblProceso">
        </label>
        
        <h2>Dependencia:</h2>
        <label id="lblDepcia">
        </label>
        
        <br />
        <h2>Justificación:</h2>
        <label>
        </label>
        
        <div class="cont_justificacion">
            <textarea autofocus id="just" rows="7" cols="100"></textarea>
        </div>
        <!-- fin Desplegado contenidos -->
        <div class="a_botones">
            <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">
                Enviar</a>
            <a id="CancelarActivo" href="javascript:fCerrar();" class="btnAct"  title="Botón de cancelar">Cancelar</a>
       <%--     <a id="CancelarActivo" href="javascript: Cancelar();" class="btnIna" title="Botón de cancelar">--%>
               <%-- Cancelar</a>--%>
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
             <asp:HiddenField ID="hf_nombreProc" runat="server" />
              <asp:HiddenField ID="hf_nombreDep" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
