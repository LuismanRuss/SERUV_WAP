<%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCKCARGAR" Codebehind="SCKCARGAR.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Registro.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery-1.8.3.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui-1.9.2.custom.js" type="text/javascript"></script>
    <%--<script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>    --%>
    <script src="../scripts/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>    
</head>
<body>
    <script type="text/javascript">
        // se declara una variable para el formato de la fecha del datepicker
        vDate = {
            dateFormat: 'dd-mm-yy',
            minDate: '-10Y',
            maxDate: '10Y',
            changeMonth: true,
            changeYear: true,
            numberOfMonths: 1,
            dayNamesMin: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'],
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo',
                    'Junio', 'Julio', 'Agosto', 'Septiembre',
                    'Octubre', 'Noviembre', 'Diciembre'],
            monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr',
                    'May', 'Jun', 'Jul', 'Ago',
                    'Sep', 'Oct', 'Nov', 'Dic']
        };

        // Se lanza al principio de la carga de la página del lado del cliente
        $(document).ready(function () {
            NG.setNact(1, 'Uno', null); // Como es una ventana modal, se declara nuevamente el primer nivel de objetos
            NG.Var[NG.Nact - 1].datoSel = eval('(' + $("#hf_NG", parent.document).val() + ')'); // Se recupera el anexo que se esta consultando
            
            $("#hf_nIdUsuario").val(NG.Var[NG.Nact - 1].datoSel.idUsuario);
            $("#hf_nIdUsuarioO").val(NG.Var[NG.Nact - 1].datoSel.idUsuarioO);
            $("#hf_nIdPartAplic").val(NG.Var[NG.Nact - 1].datoSel.idPartAplic);

            $('#txt_dFCorte').datepicker(vDate); // se aplica el formato de fecha al txt fecha corte
            $('#txt_dFacuerdo').datepicker(vDate); // se aplica el formato de fecha al txt fecha de acuerdo

            $('#txt_dFCorte').keypress(function (event) { event.preventDefault(); });
            $('#txt_dFacuerdo').keypress(function (event) { event.preventDefault(); });

            /*Se consulta el tipo de configuración del anexo (pública, privada o reservada), y se hereda al archivo que se va a cargar (se puede cambiar por el usuario)*/
            switch (NG.Var[NG.Nact - 1].datoSel.strOpcion) {
                case 'MODIFICAR':
                    $("#div_FUArchivo").hide();
                    $("#div_instrucciones").empty().append("Instrucciones: Actualiza la información correspondiente.");
                    $("#txt_dFCorte").val(NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].dteFCorte.replace('/', '-').replace('/', '-'));
                    $("#txt_nacuerdo").val(NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].strAcuerdo);
                    $("#txt_dFacuerdo").val(NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].dteFAcuerdo.replace('/', '-').replace('/', '-'));
                    $("#txt_sObservaciones").val(NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].strObserva);

                    switch (NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].chrTipoInfo) { //
                        case 'P':
                            $("#rbl_TInfo_0").prop("checked", true);
                            $("#div_confidencial").hide();
                            break;
                        case 'C':
                            $("#rbl_TInfo_1").prop("checked", true);
                            $("#div_confidencial").hide();
                            $("#div_Observaciones").empty().append("<h2>Fundamento Legal:</h2>");
                            break;
                        case 'R':
                            $("#rbl_TInfo_2").prop("checked", true);
                            $("#div_confidencial").show();
                            break;
                    }
                    break;
                default:
                    switch (NG.Var[NG.Nact - 1].datoSel.chrTipo) {
                        case 'P':
                            $("#rbl_TInfo_0").prop("checked", true);
                            $("#div_confidencial").hide();
                            break;
                        case 'C':
                            $("#rbl_TInfo_1").prop("checked", true);
                            $("#div_confidencial").hide();
                            $("#div_Observaciones").empty().append("<h2>Fundamento Legal:</h2>");
                            break;
                        case 'R':
                            $("#rbl_TInfo_2").prop("checked", true);
                            $("#div_confidencial").show();
                            break;
                    }
                    $("#div_FUArchivo").show();
                    $("#div_instrucciones").empty().append("Seleccione el archivo que desea cargar al anexo seleccionado. (Solo se pueden subir archivos en formato .PDF)");
                    break;
            }
            /***********************************************************************************************/
                        
            if ($("#div_fu").html() == "") {
                $("#div_fu").css("visibility", "hidden");
            }
            else {
                $("#div_fu").css("visibility", "visible");
            }
            $("#div_txtFCorte").css("visibility", "hidden");


            /*Rutina que se utiliza para validacion del input file*/
            $("#fu_archivo").change(function () {
                var patron = /,/;
                var extension = /\.PDF/;
                var tamanio = 0;
                if (!$.browser.msie) {
                    tamanio = this.files[0].size;
                    if (((tamanio / 1024) / 1024) > 50) {
                        $("#div_fu").css("visibility", "visible");
                        $('#div_fu').empty().append("No se permite archivos con peso mayor a 50 MBytes");
                        $(this).val("");
                        return;
                    }
                }

                if ($(this).val() != "") {
                    if (!patron.exec($(this).val())) {
                        if (extension.exec($(this).val().toUpperCase())) {
                            $("#div_fu").css("visibility", "hidden");
                        }
                        else {
                            $("#div_fu").css("visibility", "visible");
                            $('#div_fu').empty().append("Solo se permiten archivos en formato PDF.");
                            if ($.browser.msie) {
                                $('#fu_archivo').replaceWith($('#fu_archivo').clone());
                            }
                            else {
                                $(this).val("");
                            }
                        }
                    }
                    else {
                        $("#div_fu").css("visibility", "visible");
                        $('#div_fu').empty().append("El nombre del archivo no puede contener comas.");
                        if ($.browser.msie) {
                            $('#fu_archivo').replaceWith($('#fu_archivo').clone());
                        }
                        else {
                            $(this).val("");
                        }
                    }
                }
            });

            /*Rutina que se utiliza para la validación de la fecha de corte*/
            $("#txt_dFCorte").change(function () {
                if ($(this).val() != "") {
                    $("#div_txtFCorte").css("visibility", "hidden");
                }
            });
            
            /*Rutina que se utiliza para la validación del número de acuerdo*/
            $("#txt_nacuerdo").change(function () {
                if ($(this).val() != "") {
                    $("#div_txt_nacuerdo").css("visibility", "hidden");
                }
            });
            
            /*Rutina que se utiliza para la validación de la fecha de acuerdo*/
            $("#txt_dFacuerdo").change(function () {
                if ($(this).val() != "") {
                    $("#div_txt_dFacuerdo").css("visibility", "hidden");
                }
            });

            /*Rutina que se utiliza para limitar el número de caracteres de el text área de observaciones*/
            $('textarea').keyup(function () {
                var limit = 500;
                var text = $(this).val();
                var chars = text.length;
                if (chars > 0) {
                    if ($("#rbl_TInfo_1").is(':checked')) {
                        $("#div_txtObservaciones").css("visibility", "hidden");
                    }
                }
                if (chars > limit) {
                    var new_text = text.substr(0, limit);
                    $(this).val(new_text);
                }
            });

            /*Rutina que limita el número de caracteres de la fecha de acuerdo*/
            $('#txt_dFacuerdo').keyup(function () {
                var limit = 29;
                var text = $(this).val();
                var chars = text.length;
                if (chars > limit) {
                    var new_text = text.substr(0, limit);
                    $(this).val(new_text);
                }
            });

            /*Rutina que modifica el detalle que se tiene que llenar cuando la información que contiene el archivo es considerada pública*/
            $("input[id$='rbl_TInfo_0']").change(function () { // Publica
                if ($(this).is(':checked')) {
                    $("#div_txtObservaciones").css("visibility", "hidden");
                    $("#div_confidencial").hide();
                    $("#div_Observaciones").empty().append("<h2>Observaciones:</h2>");
                }
            });

            /*Rutina que modifica el detalle que se tiene que llenar cuando la información que contiene el archivo es considerada confidencial*/
            $("input[id$='rbl_TInfo_1']").change(function () { // Confidencial
                if ($(this).is(':checked')) {
                    $("#div_confidencial").hide();
                    $("#div_Observaciones").empty().append("<h2>Fundamento Legal:</h2>");
                }
            });

            /*Rutina que modifica el detalle que se tiene que llenar cuando la información que contiene el archivo es considerada reservada*/
            $("input[id$='rbl_TInfo_2']").change(function () { // Reservada
                if ($(this).is(':checked')) {
                    $("#div_txtObservaciones").css("visibility", "hidden");
                    $("#div_confidencial").show();
                    $("#div_Observaciones").empty().append("<h2>Observaciones:</h2>");
                }
            });
        });


//        function parseIframeResponse() {
//            var response = $('#fileIframe').contents().find('body').text();
//            var object = $.parseJSON(response);
//            alert(object);
//        }

        /*Función que se utiliza para la validación de la fecha de carga*/
        function FMI(fecMen, fecMay) {// dd-mm-yyyy
            fi = fecMen;
            ff = fecMay;
            
            pF1 = fecMen.split('-');
            pF2 = fecMay.split('-');

            diaInicial = pF1[0];
            mesInicial = pF1[1];
            añoInicial = pF1[2];
            diaFinal = pF2[0];
            mesFinal = pF2[1];
            añoFinal = pF2[2];

            if (Number(añoInicial) > Number(añoFinal)) {
                return false;
            }
            else if (Number(añoFinal) > Number(añoInicial)) {
                return true;
            }
            else if (Number(mesInicial) > Number(mesFinal) && Number(diaInicial) >= Number(diaFinal)) {
                return false;
            } else if (Number(mesInicial) == Number(mesFinal) && Number(diaInicial) > Number(diaFinal)) {
                return false;
            }
            else if (Number(mesInicial) <= Number(mesFinal) && Number(diaInicial) <= Number(diaFinal)) {
                return true;
            }
            else if (Number(mesFinal) > Number(mesInicial) && Number(diaInicial) > Number(diaFinal)) {
                return true;
            }
            else {
                return true;
            }

        }

        /*Función que optiene la fecha actual*/
        function GetTodayDate() {
            var tdate = new Date();
            var dd = tdate.getDate(); //yeilds day
            var MM = tdate.getMonth() < 10 ? '0' + (tdate.getMonth() + 1) : (tdate.getMonth() + 1);
            var yyyy = tdate.getFullYear(); //yeilds year
            var xxx = dd + "-" + MM  + "-" + yyyy;

            return xxx;
        }

        /*Rutina para mostrar un mensaje asociado al input file*/
        function mensaje(m) {
            $('#div_fu').empty().append(m);
        };

        /*Función que se ejecuta para cerrar el Dialog cuando se carga el archivo*/
        function fCerrar(op, ac) {
            parent.window.fCerrarDialog2(op, ac);
        };

        /*Función que se ejecuta cuando se carga un archivo, se encarga de mandar un mensaje visual dependiendo si la acción tuvo éxito o no*/
        function SubirArchivo(blnResp, sNomArchivo) {
            loading.close();
            switch (Number(blnResp)) {
                    case 0: $.alerts.dialogClass = "errorAlert";
                            jAlert('Ha sucedido un error inesperado, inténtelo más tarde.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {//Error en la operación, intente más tarde
                                fCerrar("FRACASO", "INSERT");
                            });
                        break;
                    case 1: $.alerts.dialogClass = "correctoAlert";
                            jAlert('Operación realizada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                fCerrar("EXITO", "INSERT");
                            });
                        break;
                    case 2: $.alerts.dialogClass = "incompletoAlert";
                        jAlert('El anexo ha sido integrado por algún otro usuario, no fue posible realizar la operación.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                            fCerrar("FRACASO", "INSERT");
                        });
                        break;
                    case 3: $.alerts.dialogClass = "incompletoAlert";
                            jAlert('No se ha podido completar la operación. Ya fue cargado el archivo: ' + sNomArchivo, 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                fCerrar("FRACASO", "INSERT");
                            });
                    break;
            }
        }

        /*Función que actualiza el detalle asociada a una archivo de la ER*/
        function fActualizaArchivo() {
            
            NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].dteFCorte = $("#txt_dFCorte").val();
            NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].strAcuerdo = $("#txt_nacuerdo").val();
            NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].dteFAcuerdo = $("#txt_dFacuerdo").val();
            NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].strObserva = $("#txt_sObservaciones").val();
            NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden].chrTipoInfo = $("input[name='rbl_TInfo']:checked").val();

            var objArchivo = NG.Var[NG.Nact - 1].datoSel.lstArchivos[NG.Var[NG.Nact - 1].datoSel.intnOrden];
            objArchivo.idPartAplic = NG.Var[NG.Nact - 1].datoSel.idPartAplic; 
            objArchivo.strAccion = "UPDATE";
            objArchivo.strOpcion = "DOCARCHIVO";
            actionData = JSON.stringify({ objArchivo: objArchivo });
            $.ajax(
                    {
                        url: "SCKCARGAR.aspx/pModificar",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                loading.close();
                                objArchivo = eval('(' + reponse.d + ')');
                                if (objArchivo.strResp == '1') {
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert('Operación realizada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                        fCerrar("EXITO", "UPDATE");
                                    });
                                }
                            }
                        },
                        error: errorAjax
                    }
                );
        }

        /*Funci{on general para la validaci{on de las entradas*/
        function fValida() {
            // javascript:__doPostBack('lkb_aceptar','')
            var blnDes = false;
            if ($("#txt_dFCorte").val() != "") {
                $("#div_txtFCorte").css("visibility", "hidden");
                if (($("#fu_archivo").val() != "" || NG.Var[NG.Nact - 1].datoSel.strOpcion == 'MODIFICAR')) {
                    if ($("#rbl_TInfo_2").is(':checked')) {
                        if ($("#txt_nacuerdo").val() != "") {
                            $("#div_txt_nacuerdo").css("visibility", "hidden");
                            if ($("#txt_dFacuerdo").val() != "") {
                                $("#div_txt_dFacuerdo").css("visibility", "hidden");
                                blnDes = true;
                            }
                            else {
                                $("#div_txt_dFacuerdo").css("visibility", "visible");
                            }
                        }
                        else {
                            $("#div_txt_nacuerdo").css("visibility", "visible");
                        }
                    }
                    else if ($("#rbl_TInfo_0").is(':checked')) {
                        blnDes = true;
                    }
                    else if ($("#rbl_TInfo_1").is(':checked')) {
                        if ($("#txt_sObservaciones").val() != "") {
                            blnDes = true;
                        }
                        else {
                            $("#div_txtObservaciones").css("visibility", "visible");
                        }
                    }

                    if (blnDes) {
                        $("#div_txtObservaciones").css("visibility", "hidden");
                        if (FMI($("#txt_dFCorte").val(), GetTodayDate())) {
                            $("#div_fu").css("visibility", "hidden");
                            loading.ini();
                            if (NG.Var[NG.Nact - 1].datoSel.strOpcion == 'CARGA') {
                                javascript: __doPostBack('lkb_aceptar', '');
                            }
                            else {
                                fActualizaArchivo();
                            }
                        }
                        else {
                            $("#div_txtFCorte").empty().append("La fecha no puede ser mayor al día de " + GetTodayDate());
                            $("#div_txtFCorte").css("visibility", "visible");
                        }
                    }
                }
                else {
                    $("#div_fu").css("visibility", "visible");
                    $('#div_fu').empty().append("Seleccione un archivo a cargar.");
                    if ($("#rbl_TInfo_1").is(':checked') || $("#rbl_TInfo_2").is(':checked')) {
                        if ($("#txt_nacuerdo").val() == "") {
                            $("#div_txt_nacuerdo").css("visibility", "visible");
                        }

                        if ($("#txt_dFacuerdo").val() == "") {
                            $("#div_txt_dFacuerdo").css("visibility", "visible");
                        }
                    }
                }
            }
            else {
                $("#div_txtFCorte").css("visibility", "visible");
                if ($("#fu_archivo").val() == "") {
                    $("#div_fu").css("visibility", "visible");
                    $('#div_fu').empty().append("Seleccione un archivo a cargar.");
                }

                if ($("#rbl_TInfo_2").is(':checked')) {
                    if ($("#txt_nacuerdo").val() == "") {
                        $("#div_txt_nacuerdo").css("visibility", "visible");
                    }

                    if ($("#txt_dFacuerdo").val() == "") {
                        $("#div_txt_dFacuerdo").css("visibility", "visible");
                    }
                }

                if ($("#rbl_TInfo_1").is(':checked')) {
                    $("#div_txtObservaciones").css("visibility", "visible");   
                }
            }
        };

        /*Funciones que se utilizan para mostrar un label con el número de caracteres que se ha utilizado en una input*/
        function limita(elEvento, maximoCaracteres) {
            var elemento = document.getElementById("txt_sObservaciones");

            // Obtener la tecla pulsada 
            var evento = elEvento || window.event;
            var codigoCaracter = evento.charCode || evento.keyCode;
            // Permitir utilizar las teclas con flecha horizontal
            if (codigoCaracter == 37 || codigoCaracter == 39) {
                return true;
            }

            // Permitir borrar con la tecla Backspace y con la tecla Supr.
            if (codigoCaracter == 8 || codigoCaracter == 46) {
                return true;
            }
            else if (elemento.value.length >= maximoCaracteres) {
                return false;
            }
            else {
                return true;
            }
        }

        /*Funciones que se utilizan para mostrar un label con el número de caracteres que se ha utilizado en una input*/
        function actualizaInfo(maximoCaracteres) {
            var elemento = document.getElementById("txt_sObservaciones");
            var info = document.getElementById("infoC");

            if (elemento.value.length >= maximoCaracteres) {
                info.innerHTML = "Máximo de " + maximoCaracteres + " caracteres";
            }
            else {
                info.innerHTML = "Quedan " + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
            }
        }
    </script>
    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div class="instrucciones" id="div_instrucciones">Seleccione el archivo que desea cargar al anexo seleccionado. (Solo se pueden subir archivos en formato .PDF)</div>
        <br />
        <div id="div_FUArchivo">
        <h2>Archivo:</h2>        
        <asp:FileUpload ID="fu_archivo" runat="server" /><div id="div_fu"class="requerido"></div><br />
        </div>
        <h2>Fecha Corte:</h2>&nbsp;&nbsp;<asp:TextBox ID="txt_dFCorte" runat="server" MaxLength="10"></asp:TextBox><div id="div_txtFCorte" class="requerido">* Campo requerido</div>
        <div>
            <h2>Tipo de Información:</h2>
            <asp:RadioButtonList ID="rbl_TInfo" runat="server">
                <asp:ListItem Value="P">Pública</asp:ListItem>
                <asp:ListItem Value="C">Confidencial</asp:ListItem>
                <asp:ListItem Value="R">Reservada</asp:ListItem>
            </asp:RadioButtonList>
            
        </div>
        <div id="div_confidencial">
            <div id="div_acuerdo">
                <h2>Número de Acuerdo:</h2>&nbsp;&nbsp;<asp:TextBox ID="txt_nacuerdo" runat="server" MaxLength="30"></asp:TextBox>
            </div>
            <div id="div_txt_nacuerdo" class="requerido">* Campo requerido</div>
            <div id="div_facuerdo">
                <h2>Fecha del Acuerdo:</h2>&nbsp;&nbsp;<asp:TextBox ID="txt_dFacuerdo" runat="server"></asp:TextBox>
            </div>
            <div id="div_txt_dFacuerdo" class="requerido">* Campo requerido</div>
        </div>
        <div id="div_Observaciones"><h2>Observaciones:</h2></div>
        <div id="div_txtObservaciones" class="requerido">* Campo requerido</div>
        <div class="align_ObsCarga">         
            <asp:TextBox  ID="txt_sObservaciones" runat="server" TextMode="MultiLine" Height="83px" Width="90%" MaxLength="500" onkeypress="return limita(event, 500);" onkeyup="actualizaInfo(500)"></asp:TextBox>
            <div id="infoC">Máximo de 500 caracteres</div>
        </div>
        
        <asp:LinkButton ID="lkb_aceptar" runat="server" onclick="LinkButton1_Click" ></asp:LinkButton>
        <br />

        <div class="a_botones_modal">
            <a title="Botón Guardar" href="javascript:fValida();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" href="Javascript:fCerrar('CERRAR');" class="btnAct">Cancelar</a>        
        </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_nIdUsuario" runat="server" />
            <asp:HiddenField ID="hf_nIdUsuarioO" runat="server" />
            <asp:HiddenField ID="hf_nIdPartAplic" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
