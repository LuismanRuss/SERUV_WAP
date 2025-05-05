<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAKFORINS" Codebehind="SAKFORINS.aspx.cs" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%--<meta charset="UTF-8" />--%>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="../../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>    
    <script src="../../scripts/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="../../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../../scripts/Libreria.js" type="text/javascript"></script>   
</head>
<body>
    <script type="text/javascript">

        var intIDUsuario; // variable que tendrá el id de usuario de session que agregará anexos
        var chrOperacion; // variable que nos indicará a donde asignaremos: Formato / Guia

        $(document).ready(function () {
            NG.setNact(1, 'Uno', null);

            //Asigno el valor de operacion: Formato o Instructivo/Guia
            chrOperacion = $("#hf_operacion", parent.document).val();

            //Asigno el valor del usuario de session de la forma padre a mi hidden
            $("#hf_idUsuario").val($("#hf_idUsuario", parent.document).val());

            //Checamos si el Indicador es FORMATO
            if (chrOperacion == 'FORMATO') {
                chrOperacion = 'F';
                $('#txt_instruccion').text("Seleccione el archivo que desea adjuntar; los archivos que se pueden cargar deben tener extensión .doc, .docx, .xls, .xlsx ó .xlsm");
                $("#hf_cTipo").val(chrOperacion);
            }

            //Checamos si el Indicador es INSTRUCTIVO
            if (chrOperacion == 'INSTRUCTIVO') {
                chrOperacion = 'G';
                $('#txt_instruccion').text("Seleccione el archivo que desea adjuntar; los archivos que se pueden cargar deben tener extensión .pdf");
                $("#hf_cTipo").val(chrOperacion);
            }

            //console.log(chrOperacion);

            if ($("#div_fu").html() == "") {
                $("#div_fu").css("visibility", "hidden");
            }
            else {
                $("#div_fu").css("visibility", "visible");
            }


            $("#fu_archivo").change(function () {
                if ($(this).val() != "") {
                    $("#div_fu").css("visibility", "hidden");
                }
            });

        });

        //Función para ejecutar el Div con el Texto 
        function fMensaje(m) {
            $('#div_fu').empty().append(m);
        };

        //Función para cerrar la ventana modal
        function fCerrar() {
            //parent.window.fCerrarDialog2(op);
            parent.window.fCerrarDialog();
            //$("#dialog").dialog(close);
        };

        //Función que nos regresa los datos de salida del archivo que se subio
        function fSubirArchivo(blnResp, nomarchivo, gidformato, tipo) {
            loading.close();
            if (blnResp == 'True') {

                //alert(tipo);
                if (tipo == 'F') {
                    $("#hf_nomFormato", parent.document).val(nomarchivo);
                    $("#hf_gidFormato", parent.document).val(gidformato);
                    parent.window.AsignarFormatos();

                }
                if (tipo == 'G') {
                    $("#hf_nomGuia", parent.document).val(nomarchivo);
                    $("#hf_gidGuia", parent.document).val(gidformato);
                    parent.window.AsignarGuias();

                }

                jAlert('Operación realizada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                    fCerrar();
                });
            }
            else {
                jAlert('Ha sucedido un error inesperado, inténtelo más tarde.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                    fCerrar();
                });
            }
        }

        //Función que Valida que se haya seleccionado un archivo
        function fValida() {
            // j avascript:__doPostBack('lkb_aceptar','')
            if ($("#fu_archivo").val() != "") {
                $("#div_fu").css("visibility", "hidden");
                loading.ini();
                javascript: __doPostBack('lkb_aceptar', '');
            }
            else {
                $("#div_txtCodigo").css("visibility", "visible");
                $('#div_fu').empty().append("Seleccione un archivo");
            }
        }
    </script>
    <form id="form1" runat="server">
        <div id="agp_contenido"> 
            <div id="txt_instruccion" class="instrucciones">Seleccione el archivo que desea adjuntar; los archivos que se pueden cargar deben tener extensión .doc, .docx, .xls, .xlsx ó .xlsm</div>
            <br />
            <h2>Archivo:</h2><asp:FileUpload ID="fu_archivo" runat="server" Width="350px" /><div id="div_fu"class="requerido"></div><br />      
            <asp:LinkButton ID="lkb_aceptar" runat="server" onclick="lkb_aceptar_Click"></asp:LinkButton>

            <div class="a_botones_modal">
                <a title="Botón Guardar" id="btnGuardar" href="Javascript:fValida();" class="btnAct">Guardar</a>
                <a title="Botón Cancelar" id="btnCancelar" href="Javascript:fCerrar();" class="btnAct">Cancelar</a>
            </div>
            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
                <asp:HiddenField ID="hf_archivo" runat="server" />
                <asp:HiddenField ID="hf_cTipo" runat="server" />
            </div>
        </div>
    </form>       
</body>
</html>
