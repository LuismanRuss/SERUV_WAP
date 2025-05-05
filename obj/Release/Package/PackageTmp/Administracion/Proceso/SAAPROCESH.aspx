<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPROCESH" Codebehind="SAAPROCESH.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        //Pasa valores del calendario a español
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

        // ------------------------- Variables Globales
        var blnConsulta = false;
        var actualizar = 0;
        var lstNotificaciones;
        var nIdProceso = 0;
        var nUsuario = 0;
        var nUsuario = $('#hf_idUsuario').val();
        var Descripcion = '';
        var strEXCEPTO = '0';
        var strAccion = "";
        var idNotIniAct = 0;
        var idNotProcAct = 0;
        var idNotFinAct = 0;

        var idNotIni = 0;
        var nDiasAntNot1 = 0;
        var idNotProc = 0;
        var txt_fIniNot = "";
        var txt_fFinNot = "";
        var idNotFin = 0;
        var nDiasAntNot3 = 0;
        var condicion = 'N';

        var motivo = '';
        var idMotivo = 0;
        /////////////////////////////
        var fechaInicioProceso = "";
        var traeCarga = 0;
        var fechaFinProceso = "";
        var fechaIniExtem = "";
        var fechaFinExtem = "";
        var strJustExtem = "";
        var strAccionExt = 0;
        var nAccionFProc = 0;
        var fActual = "";
        var year = "";
        var ArrayMotivos = []; // Arreglo que almacenara los motivos
        // -------------------------------------
        $(document).ready(function () {
            loading.close();
            NG.setNact(2, 'Dos', null);
            ListaPuesto();
            traeDependencia();
            ListTipoproc();
            ObtieneGuiaAct();
            CreasDPeriodo();
            ListaNotInicial();
            GetTodayDate();         //Trae la fecha actual
            ////////////////

            ////////////////
            $('#txt_FInicio').datepicker(vDate);
            $('#txt_FFinal').datepicker(vDate);
            $('#txt_FExtIni').datepicker(vDate);
            $('#txt_FExtFin').datepicker(vDate);
            $('#txt_fIniNot').datepicker(vDate);
            $('#txt_fFinNot').datepicker(vDate);
            $("#txt_dAntes").numeric({ decimal: false, negative: false });
            $("#txt_fUrgente").numeric({ decimal: false, negative: false });
            $('#txt_FInicio').keypress(function (event) { event.preventDefault(); });
            $('#txt_FFinal').keypress(function (event) { event.preventDefault(); });  //? event.keyCode : event.which;
            $('#txt_fIniNot').keypress(function (event) { event.preventDefault(); });
            $('#txt_fFinNot').keypress(function (event) { event.preventDefault(); });
            $('#txt_FExtIni').keypress(function (event) { event.preventDefault(); });
            $('#txt_FExtFin').keypress(function (event) { event.preventDefault(); });
            $("#div_Motivos").css("visibility", "hidden");
            $("#txt_fNotIni").prop('disabled', true);
            $('#txt_sProc').prop('disabled', true);         //Deshabilita campo Codigo
            $('#txt_dAntes').prop('disabled', true);
            $('#txt_fIniNot').prop('disabled', true);
            $('#txt_fFinNot').prop('disabled', true);
            $('#txt_fUrgente').prop('disabled', true);

            $('textarea[maxlength]').keyup(function () {
                var limit = parseInt($(this).attr('maxlength'));
                var text = $(this).val();
                var chars = text.length;
                if (chars > limit) {
                    var new_text = text.substr(0, limit);
                    $(this).val(new_text);
                }
            });

            if (NG.Var[NG.Nact - 1].datoSel != null) {
                actualizar = 1;
                nIdProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nIdProceso;
                blnConsulta = true;
                fAjax(nIdProceso);
                strAccion = 'ACTUALIZAR_PROC';
                fValidaCarga();
            }
            else {
                strAccion = 'INSERTAR_PROCESO';
                $('#txt_FExtIni').prop('disabled', true);
                $('#txt_FExtFin').prop('disabled', true);
                $('#txt_just').prop('disabled', true);
            }
            ActualizarTitulo();
            ///////////////////////////////////////////////////////////////////////////////
            $("#txt_dAntes").keyup(function () {            //CALCULA LA FECHA PARA LA NOTIFICACION INICIAL EN BASE A LOS DIAS INDICADOS, Y LA MUESTRA EN EL TEXTBOX 
                if ($("#txt_FInicio").val() != "") {
                    if ($("#txt_dAntes").val() != 0 && $("#txt_dAntes").val() != "") {
                        if ($('#slc_MsjI option:selected').val() > 0) {
                            creaFechaNotIni();
                        }
                    }
                    else if ($("#txt_dAntes").val() == 0 || $("#txt_dAntes").val() == "") {
                        $("#txt_fNotIni").val("");
                    }
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            $("#txt_sProc").change(function () {                // VERIFICA SI EXISTE UN CÓDIGO DE PROCESO, SI ES ASÍ OCULTA LA VALIDACIÓN
                if ($(this).val() != "") {
                    $("#div_txtCodigo").css("visibility", "hidden");
                }
            });
            /////////////////////////////////////////////--- verifica que existan fechas de inicio y final, en ese caso oculta la validación
            $("#txt_FInicio").change(function () {
                if ($(this).val() != "" && $("#txt_FFinal").val() != "") {
                    $("#fProceso").css("visibility", "hidden");
                    $("#div_fExtemp").empty();
                    $("#div_fExtemp").css("visibility", "hidden");
                }
                if ($(this).val() != "") {

                    if ($("#txt_dAntes").val() != 0 && $("#txt_dAntes").val() != "") {
                        if ($('#slc_MsjI option:selected').val() > 0) {
                            creaFechaNotIni();
                        }
                    }
                    else if ($("#txt_dAntes").val() == 0 || $("#txt_dAntes").val() == "") {
                        $("#txt_fNotIni").val("");
                    }
                }
            });
            //////////////////////////////////////////---- verifica que existan fechas de inicio y final, en ese caso oculta la validación
            $("#txt_FFinal").change(function () {
                if ($(this).val() != "" && $("#txt_FInicio").val() != "") {
                    $("#fProceso").css("visibility", "hidden");
                    $("#div_fExtemp").empty();
                    $("#div_fExtemp").css("visibility", "hidden");
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            $("#slc_Puesto").change(function () {                   // SI HAY UN PUESTO SELECCIONADO, OCULTA EL MENSAJE DE VALIDACION
                if ($(this).val() != 0) {
                    $("#Puesto").css("visibility", "hidden");
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            $("#slc_Depcia").change(function () {                   //  SI HAY UNA DEPENDENCIA SELECCIONADA, OCULTA EL MENSAJE DE VALIDACIÓN
                if ($(this).val() != 0) {
                    $("#Depcia").css("visibility", "hidden");
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            $("#slc_TipoProc").change(function () {             //VALIDA CAMBIOS EN EL TIPO DE PROCESO
                if ($(this).val() != 0) {

                    $("#Nat").css("visibility", "hidden");
                    $('#slc_Motivo').empty();
                    listItem = $('<option></option>').val(0).html('Seleccione'); 
                    $('#slc_Motivo').append(listItem);

                    if ($(this).val() == 1) {                       // SI EL TIPO DE PROCESO ES 1 , DESPLIEGA DOS RADIOBUTTONS  PARA SELECCIONAR LAS CONSIDERACIONES DEL PROCESO
                        $("#div_Ordinaria").empty().append('<blockquote>' + "<h5>Consideraciones: </h5>" + '<blockquote>'
                         + "<input type=" + 'radio' + " name=" + 'rbt_cons' + " value=" + 'U' + " id=" + 'unica' + " /><h7>Única</h7>"
                        + "<input type=" + 'radio' + " name=" + 'rbt_cons' + " value=" + 'D' + " id=" + 'jerarquia' + " /><h7>Con todas sus dependencias / entidades</h7>"
                        );
                        for (a_i = 0; a_i < ArrayMotivos.length; a_i++) {   //  LLENA EL SELECT CON LOS MOTIVOS DE TIPO ORDINARIO
                            if (ArrayMotivos[a_i].cTipoMoti == "O" && ArrayMotivos[a_i].cIndActivo == 'S') {
                                listItem = $('<option></option>').val(ArrayMotivos[a_i].idMotiProc).html(ArrayMotivos[a_i].strSDMotiProc.toUpperCase());
                                $('#slc_Motivo').append(listItem);
                            }
                        }
                        $("#div_Motivos").css("visibility", "visible");
                        $("#div_condicion").css("visibility", "hidden");
                        $("#div_Ordinaria").css("visibility", "visible");
                        $("#Nat").empty();
                        $("#Nat").css("visibility", "visible");
                    }
                    else if ($(this).val() == 2) {                  //  SI EL TIPO DE PROCESO ES 2, LLENA EL SELECT CON LOS MOTIVOS DE TIPO EXTEMPORÁNEO
                        for (a_i = 0; a_i < ArrayMotivos.length; a_i++) {
                            if (ArrayMotivos[a_i].cTipoMoti == "E" && ArrayMotivos[a_i].cIndActivo == 'S') {
                                listItem = $('<option></option>').val(ArrayMotivos[a_i].idMotiProc).html(ArrayMotivos[a_i].strSDMotiProc.toUpperCase());
                                $('#slc_Motivo').append(listItem);
                            }
                        }
                        $("#div_Motivos").css("visibility", "visible");
                        $("#div_condicion").css("visibility", "hidden");
                        $("#div_Ordinaria").empty();
                        $("#div_Ordinaria").css("visibility", "hidden");
                        $("#Nat").empty();
                        $("#Nat").css("visibility", "visible");
                    }
                    else if ($(this).val() == 3) {                  //  SI EL TIPO DE PROCESO ES 3, SE OCULTAN LOS MOTIVOS
                        $("#div_Ordinaria").empty();
                        $("#div_Ordinaria").css("visibility", "hidden");
                        $("#Nat").empty();
                        $("#Nat").css("visibility", "hidden");
                        $("#div_condicion").css("visibility", "hidden");
                        $("#div_Motivos").css("visibility", "hidden");
                    }
                }
                else {
                    $("#div_Ordinaria").empty();
                    $("#div_Ordinaria").css("visibility", "hidden");
                    $("#Nat").css("visibility", "hidden");
                    $("#div_condicion").css("visibility", "hidden");
                    $("#div_Motivos").css("visibility", "hidden");
                    $("#div_condicionMot").css("visibility", "hidden");
                }
            });
            /////////////////////////////////////////////////--- verifica que exista fecha inicial extemporáea
            //            // EXTEMPORANEO
            $("#txt_FExtIni").change(function () {
                if ($(this).val() != "") {
                    $("#div_fExtemp").empty();
                    $("#div_fExtemp").css("visibility", "hidden");
                }
            });
            ///////////////////////////////////////////////////--- verifica que exista fecha final extemporánea
            $("#txt_FExtFin").change(function () {
                if ($(this).val() != "") {
                    $("#div_fExtemp").empty();
                    $("#div_fExtemp").css("visibility", "hidden");
                }
            });
            //////////////////////////////////////////////////////--- verifica que exista justificación para la apertura extemporánea
            $("#txt_just").change(function () {
                if ($(this).val() != "") {
                    $("#div_fExtemp").empty();
                    $("#div_sJustifExt").css("visibility", "hidden");
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            //      VALIDACIÓN PARA LA NOTIFICACIÓN INICIAL
            $('#slc_MsjI').change(function () {
                if ($('#slc_MsjI option:selected').val() == 0) {
                    $('#txt_dAntes').val("");
                    $("#txt_fNotIni").val("");
                    $("#div_MsgInicial").empty();
                    $("#div_MsgInicial").css("visibility", "hidden");
                    $("#txt_dAntes").prop('disabled', true); // deshabilita campo
                }
                else if ($('#slc_MsjI option:selected').val() > 0) {
                    if ($('#txt_FInicio').val() != "" && $('#txt_FFinal').val() != "") {
                        $('#txt_dAntes').prop('disabled', false);
                    }
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            //  VALIDACIÓN PARA LA NOTIFICACIÓN URGENTE
            $('#slc_MsjU').change(function () {
                if ($('#slc_MsjU option:selected').val() == 0) {
                    $('#txt_fUrgente').val("");
                    $("#div_MsgUrg").empty();
                    $("#div_MsgUrg").css("visibility", "hidden");
                    $("#txt_fUrgente").prop('disabled', true); // deshabilita campo
                }
                else if ($('#slc_MsjU option:selected').val() > 0) {
                    if ($('#txt_FInicio').val() != "" && $('#txt_FFinal').val() != "") {
                        $('#txt_fUrgente').prop('disabled', false);
                    }
                }
                if ($('#txt_fUrgente').val() != "") {
                    $("#div_MsgUrg").empty();
                    $("#div_MsgUrg").css("visibility", "hidden");
                    ValidaDias();
                }
            });
            ///////////////////////////////////////////////////////////////////////////////
            //  VALIDACIÓN PARA LA NOTIFICACIÓN DURANTE EL PROCESO
            $('#slc_MsjP').change(function () {
                if ($('#slc_MsjP option:selected').val() > 0) {
                    if ($('#txt_FInicio').val() != "" && $('#txt_FFinal').val() != "") {
                        $('#txt_fIniNot').prop('disabled', false);
                        $('#txt_fFinNot').prop('disabled', false);
                    }
                    if ($('#txt_fIniNot').val() != "" && $('#txt_fFinNot').val() != "") {
                        $("#div_MsGDurante").empty();
                        $("#div_MsGDurante").css("visibility", "hidden");
                    }
                }
                else if ($('#slc_MsjP option:selected').val() == 0) {
                    $('#txt_fIniNot').val("");
                    $('#txt_fFinNot').val("");
                    $("#div_MsGDurante").empty();
                    $("#div_MsGDurante").css("visibility", "hidden");
                    $("#txt_fIniNot").prop('disabled', true); // deshabilita campo
                    $("#txt_fFinNot").prop('disabled', true); // deshabilita campo
                }
            });
            //cierrra document ready
        });
        // Cierra Document Ready

        //FUNCIÓN ELIMINA ESPACIOS VACIOS
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        // valida si el proceso trae carga o no, de acuerdo a esto activa o desactiva campos de fecha
        function fValidaCarga() {
            if (traeCarga != 0) {
                $("#txt_FInicio").prop('disabled', true);

                if (fechaIniExtem != "" && fechaFinExtem != "") {
                    $("#txt_FFinal").prop('disabled', true);
                }
            }
            else if (traeCarga == 0) {
                $("#txt_FInicio").prop('disabled', false);
                $("#txt_FFinal").prop('disabled', false);
                $('#txt_FExtIni').prop('disabled', true);
                $('#txt_FExtFin').prop('disabled', true);
                $('#txt_just').prop('disabled', true);
            }
        }
        ///////////-- asigna una fecha al campo de fecha para la notificación inicial, siempre y cuando existan fechas para el proceso
        function creaFechaNotIni() {
            fechaInicioProceso = $("#txt_FInicio").val();
            var nDiasAntNotIni = $("#txt_dAntes").val();

            var fecha_i = fechaInicioProceso;
            var fecha = fecha_i.split("-");

            var fecha_ingreso = new Date(fecha[2], fecha[1] - 1, fecha[0]);
            var fecha2 = new Date(fecha_ingreso.getTime() - (nDiasAntNotIni * 24 * 3600 * 1000));
            var tdate = fecha2;
            var dd = tdate.getDate() < 10 ? '0' + tdate.getDate() : tdate.getDate();  //yeilds day
            var MM = tdate.getMonth() < 10 ? '0' + (tdate.getMonth() + 1) : (tdate.getMonth() + 1);
            var yyyy = tdate.getFullYear(); //yeilds year
            var xxx = dd + "-" + MM + "-" + yyyy;
            $("#txt_fNotIni").val(xxx);
        }
        /////////////////////--- valida que se llenen los campos necesarios para la notificación urgente (antes de cierre de proceso)
        function ValidaNotUrgente() {
            if ($('#slc_MsjU option:selected').val() > 0) {
                if ($('#txt_fUrgente').val() == "") {
                    $("#div_MsgUrg").empty().append("* Se requiere especificar los días para enviar el mensaje antes del cierre del proceso.");
                    $("#div_MsgUrg").css("visibility", "visible");
                }
                if ($('#txt_fUrgente').val() != "" && $('#txt_fUrgente').val() != 0) {
                    $("#div_MsgUrg").empty();
                    $("#div_MsgUrg").css("visibility", "hidden");
                    ValidaDias();
                }
                else if ($('#txt_fUrgente').val() == "") {
                    $("#div_MsgUrg").empty().append("* Se requiere especificar los días para enviar el mensaje antes del cierre del proceso.");
                    $("#div_MsgUrg").css("visibility", "visible");
                }
                else if ($('#txt_fUrgente').val() == 0) {
                    $("#div_MsgUrg").empty().append("* El número de días debe ser mayor a 0.");
                    $("#div_MsgUrg").css("visibility", "visible");
                }
            }
            else if ($('#slc_MsjU option:selected').val() == 0) {
                $('#txt_fUrgente').val("");
                $("#div_MsgUrg").empty();
                $("#div_MsgUrg").css("visibility", "hidden");
            }
        }
        ////////////////////////////////////////-- valida que exista la información necesaria para la notificación inicial (antes de proceso)
        function ValidaNotInicial() {
            if ($('#slc_MsjI option:selected').val() > 0) {
                if ($('#txt_dAntes').val() == "") {
                    $("#div_MsgInicial").empty().append("* Se requiere especificar los días para enviar el mensaje de inicio.");
                    $("#div_MsgInicial").css("visibility", "visible");
                }
                if ($('#txt_dAntes').val() != "" && $('#txt_dAntes').val() != 0) {
                    $("#div_MsgInicial").empty();
                    $("#div_MsgInicial").css("visibility", "hidden");
                }
                else if ($('#txt_dAntes').val() == "") {
                    $("#div_MsgInicial").empty().append("* Se requiere especificar los días para enviar el mensaje de inicio.");
                    $("#div_MsgInicial").css("visibility", "visible");
                }
                else if ($('#txt_dAntes').val() == 0) {
                    $("#div_MsgInicial").empty().append("* El número de días para enviar el mensaje de inicio debe ser mayor a 0.");
                    $("#div_MsgInicial").css("visibility", "visible");
                }
            }
            else if ($('#slc_MsjI option:selected').val() == 0) {
                $('#txt_dAntes').val("");
                $("#div_MsgInicial").empty();
                $("#div_MsgInicial").css("visibility", "hidden");
            }
        }
        ///////////////////////-- valida las fechas de la notificación durante el proceso
        function ValidaFechasNot() {
            if ($('#slc_MsjP option:selected').val() > 0) {
                if ($('#txt_fIniNot').val() != "" && $('#txt_fFinNot').val() != "") {
                    $("#div_MsGDurante").empty();
                    $("#div_MsGDurante").css("visibility", "hidden");
                    /////////////////////////////////////////////
                    if ($('#txt_fFinNot').val() == $('#txt_fIniNot').val()) {
                        $("#div_MsGDurante").empty();
                        $("#div_MsGDurante").css("visibility", "hidden");
                    }
                    else if (FMI($('#txt_fFinNot').val(), $('#txt_fIniNot').val())) {
                        $("#div_MsGDurante").empty().append("* La fecha inicial de la notificación durante el proceso no puede ser mayor a la fecha final de la notificación durante el proceso");
                        $("#div_MsGDurante").css("visibility", "visible");
                    }
                    //////////////////////////////////////
                    if ($('#txt_fFinNot').val() == $('#txt_FInicio').val() || $('#txt_fFinNot').val() == $('#txt_FFinal').val()) {
//                        $("#div_MsGDurante").empty();
//                        $("#div_MsGDurante").css("visibility", "hidden");
                    }
                    else if (FMI($('#txt_fFinNot').val(), $('#txt_FInicio').val())) {
                        $("#div_MsGDurante").empty().append("* La fecha final de la notificación durante el proceso no puede ser  menor a la fecha " + $('#txt_FInicio').val());
                        $("#div_MsGDurante").css("visibility", "visible");
                    }
                    else if (FMI($('#txt_FFinal').val(), $('#txt_fFinNot').val())) {
                        $("#div_MsGDurante").empty().append("* La fecha final de la notificación durante el proceso no puede ser  mayor a la fecha " + $('#txt_FFinal').val());
                        $("#div_MsGDurante").css("visibility", "visible");
                    }
                    ////////////////
                    if ($('#txt_fIniNot').val() == $('#txt_FInicio').val() || $('#txt_fIniNot').val() == $('#txt_FFinal').val()) 
                    {
//                        $("#div_MsGDurante").empty();
//                        $("#div_MsGDurante").css("visibility", "hidden");
                    }
                    else if (FMI($('#txt_fIniNot').val(), $('#txt_FInicio').val())) {
                            $("#div_MsGDurante").empty().append("* La fecha inicial de la notificación durante el proceso no puede ser  menor a la fecha " + $('#txt_FInicio').val());
                            $("#div_MsGDurante").css("visibility", "visible");
                    }
                    else if (FMI($('#txt_FFinal').val(), $('#txt_fIniNot').val())) {
                            $("#div_MsGDurante").empty().append("* La fecha inicial de la notificación durante el proceso no puede ser  mayor a la fecha " + $('#txt_FFinal').val());
                            $("#div_MsGDurante").css("visibility", "visible");
                    }
                }
                else {
                    $("#div_MsGDurante").empty().append("* Por favor indique las fechas.");
                    $("#div_MsGDurante").css("visibility", "visible");
                }
            }
        }
        ////////////--- en caso de ser ordinario el proceso muestra un div con condiciones para la creación de un proceso, asi mismo muestra los motivos
        function ValidaCondicion() {
            if ($('#slc_TipoProc option:selected').val() == 1) {
                if ($('input[name=rbt_cons]:checked').val() != undefined) {
                    dato = $('input[name=rbt_cons]:checked').val();
                    if (dato != 'N') {
                        condicion = dato;
                        $("#div_condicion").empty();
                        $("#div_condicion").css("visibility", "hidden");
                    }
                }
                else if ($('input[name=rbt_cons]:checked').val() == undefined) {
                    if ($('#slc_TipoProc option:selected').val() == 1) {
                        if (actualizar == 0) {
                            $("#div_condicion").empty().append("* Porfavor seleccione una condición.");
                            $("#div_condicion").css("visibility", "visible");
                        }
                        else if (actualizar == 1) {
                            $("#div_condicion").empty();
                            $("#div_condicion").css("visibility", "hidden");
                        }
                    }
                }
                if ($('#slc_Motivo option:selected').val() == 0) {
                    $("#div_condicionMot").empty().append("* Porfavor seleccione un motivo.");
                    $("#div_condicionMot").css("visibility", "visible");
                }
                else if ($('#slc_Motivo option:selected').val() != 0) {
                    $("#div_condicionMot").empty();
                    $("#div_condicionMot").css("visibility", "hidden");
                }
            }
            if ($('#slc_TipoProc option:selected').val() == 2) 
            {
                if ($('#slc_Motivo option:selected').val() == 0) {
                    $("#div_condicionMot").empty().append("* Porfavor seleccione un motivo.");
                    $("#div_condicionMot").css("visibility", "visible");
                }
                else if ($('#slc_Motivo option:selected').val() != 0) {
                    $("#div_condicionMot").empty();
                    $("#div_condicionMot").css("visibility", "hidden");
                }
            }
        }
        ///////////////////////--- valida que los días establecidos no sean mayores a la cantidad de días que dure el proceso.
        function ValidaDias() {
            var d1 = $("#txt_FInicio").val().split("-");
            var dat1 = new Date(d1[2], parseFloat(d1[1]) - 1, parseFloat(d1[0]));
            var d2 = $("#txt_FFinal").val().split("-");
            var dat2 = new Date(d2[2], parseFloat(d2[1]) - 1, parseFloat(d2[0]));
            var fin = dat2.getTime() - dat1.getTime();
            var dias = Math.floor(fin / (1000 * 60 * 60 * 24));
            if ($('#txt_fUrgente').val() > dias) {
                $("#div_MsgUrg").empty().append("* Los dias del mensaje antes del cierre del proceso no pueden ser mayores a: " + '<b>' + dias + '</b>' + " ya que es el periodo del proceso");
                $("#div_MsgUrg").css("visibility", "visible");
            }
            else {
                $("#div_MsgUrg").empty();
                $("#div_MsgUrg").css("visibility", "hidden");
            }
        }

        //////////////////////--- actualiza el titulo de la ventana (si es Alta de proceso o Modificación de proceso) de acuerdo si tiene información o no.
        function ActualizarTitulo() {
            if (actualizar == 1) {
                $("#titulo").empty().append("Modificar Proceso");
            }
        }
        /////////////////////////////////////////////////////////////-Lista Puestos-//////////////////////////////////////////////////           
        function ListaPuesto() {
            var actionData = "{}";
            $.ajax({
                url: "Proceso/SAAPROCESH.aspx/DibujaListPuesto",
                data: actionData,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loadListPuesto(eval('(' + reponse.d + ')'));
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        };
        //////////////////////////////////////////////////-- llena el select de puestos con la información que obtiene de ListaPuesto
        function loadListPuesto(datos) {
            listItem = $('<option></option>').val(0).html('Seleccione');
            $('#slc_Puesto').append(listItem);
            for (a_i = 0; a_i < datos.length; a_i++) {
                listItem = $('<option></option>').val(datos[a_i].nPuesto).html(datos[a_i].sDPuesto);
                $('#slc_Puesto').append(listItem);
            }
        }
        //////////////////////////////////////////////////////////////////-Dependencia-//////////////////////////////////////////////////
        function traeDependencia() {
            $('#slc_Puesto').change
                (function () {
                    $('#slc_Puesto option:selected').each(function () {
                        nPuesto = $('#slc_Puesto').find(':selected').val();
                        var actionData = "{'nPuesto': '" + nPuesto +
                        "'}";
                        $.ajax({
                            url: "Proceso/SAAPROCESH.aspx/DibujaListDepcia",
                            data: actionData,
                            async: false,
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {
                                loadListDepcia(eval('(' + reponse.d + ')'));
                            },
                            error: function (result) {
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, no se pueden cargar dependencias/entidades, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        });
                    });
                });
        }
        ///////////////////---- llena el select de dependencias con la información que obtiene traeDependencia
        function loadListDepcia(datos) {
            if (datos != null) {
                $('#slc_Depcia').empty();
                listItem = $('<option></option>').val(0).html('Seleccione');
                $('#slc_Depcia').append(listItem);
                for (a_i = 0; a_i < datos.length; a_i++) {
                    listItem = $('<option></option>').val(datos[a_i].nDepcia).html(datos[a_i].sDDepcia);
                    $('#slc_Depcia').append(listItem);
                }
            }
            else {
                $('#slc_Depcia').empty();
                listItem = $('<option></option>').val(0).html('Seleccione');
                $('#slc_Depcia').append(listItem);
            }
        }

        //////////////////////////////////////////////////////////////////- Tipo Proceso -///////////////////////////////////////////////////////
        function ListTipoproc() {
            var strACCION = "OBTENER_TIPO_PROC";

            var strACCIONMot = "OBTENER_MOT_PROC";
            var actionData = "{'strACCION': '" + strACCION +
                          "','strACCIONMot': '" + strACCIONMot +
                            "'}";
            $.ajax({
                url: "Proceso/SAAPROCESH.aspx/DibujaListTipoProc",
                data: actionData, 
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loadListTipProc(eval('(' + reponse.d + ')'));
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, no se puede cargar el tipo de proceso, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        };
        ///////////////// --Llena lista de tipos de proceso en un select // Llena un arreglo con los motivos de acuerdo al tipo, que posteriormente lo manda a un select
        function loadListTipProc(datos) {

            var tipoproc = datos.datos[0];
            motivo = datos.datos[1];

            // Lista de Tipo de Proceso
            listItem = $('<option></option>').val(0).html('Seleccione');  //MOTIVOS PARA TIPO DE PROCESO ORDINARIO            

            $('#slc_TipoProc').append(listItem);
            for (a_i = 0; a_i < tipoproc.length; a_i++) {
                listItem = $('<option></option>').val(tipoproc[a_i].idTipoProc).html(tipoproc[a_i].strDTipoProc);
                $('#slc_TipoProc').append(listItem);
            }
            listItem2 = $('<option></option>').val(0).html('Seleccione'); //MOTIVOS PARA TIPO DE PROCESO EXTRAORDINARIO
            $('#slc_Motivo').append(listItem2);
            for (a_i = 1; a_i < motivo.length; a_i++) {
                // Se empieza a llenar de la posicion a_i-1 por que la lista de motivos en la posicion 0 trae nulo
                ArrayMotivos[a_i - 1] = { "idMotiProc": motivo[a_i].idMotiProc, "strSDMotiProc": motivo[a_i].strSDMotiProc, "cTipoMoti": motivo[a_i].cTipoMot, "cIndActivo": motivo[a_i].cIndActivo };
            }
        }
        ///////////////--- Valida que si el tipo de proceso es 1 o 2 muestre el select de motivos si es 0 lo desaparece
        function ValidaMotivo() {
            if ($('#slc_TipoProc option:selected').val() == 1 || $('#slc_TipoProc option:selected').val() == 2) {
                if ($('#slc_Motivo option:selected').val() != 0) {
                    idMotivo = $('#slc_Motivo option:selected').val();
                }
                else if ($('#slc_Motivo option:selected').val() == 0) {
                    $("#div_condicionMot").empty().append("* Porfavor seleccione un motivo.");
                    $("#div_condicionMot").css("visibility", "visible");
                }
            }
        }
        /////////////////////////////////////////////////////// - ObtieneGuiaActiva - /////////////////////////////////////////////////////////
        function ObtieneGuiaAct() {
            var strACCION = 'UNICA_GUIA_VIGENTE';
            var actionData = "{'strACCION': '" + strACCION + "'}";

            $.ajax({
                url: "Proceso/SAAPROCESH.aspx/GuiaVigente",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loadGuia(eval('(' + reponse.d + ')'));
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Solo puede tener una guia vigente", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        };
        ///////////////-- Carga en una etiqueta la guía vigente, y muestra en un textbox el código del proceso
        function loadGuia(datos) {
            var liGuia = datos.datos[0];
            var liCodigo = datos.datos[1];

            if (liGuia != null) {
                for (a_i = 0; a_i < liGuia.length; a_i++) {
                    $('#lbl_guia').val(liGuia[a_i].idGuiaER).html(liGuia[a_i].strDGuiaER);
                }
            }
            else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Para poder crear un nuevo proceso debe existir una guia vigente.", 'SISTEMA DE ENTREGA - RECEPCIÓN'
                , function () { Cancelar(); });
            }
            if (actualizar == 0) {
                $("#txt_sProc").val(liCodigo[0].strProceso);
            }
        }
        ////////////////////////////////////////////////////////// - Crea La Descripción del Proceso - ////////////////////////////////////
        function textos(dependencia, puesto) {
            escribir = document.getElementById("lbl_dProceso")
            texto2 = dependencia;
            texto3 = ' DEL CARGO PUESTO ';
            texto4 = puesto;

            if ($('#slc_Depcia option:selected').val() == 0) {
                escribir.innerHTML = '';
            }
            else {
                escribir.innerHTML = '<b>' + texto2 + '</b>' + texto3 + '<b>' + texto4 + '</b>';
                Descripcion = texto2 + texto3 + texto4;
            }
            if ($('#slc_Puesto option:selected').val() == 0) {
                escribir.innerHTML = '';
            }
        }
        ////////////////////--- cuando recibe los datos de dependencia y puesto, genera un texto que manda a un div con la combinación de estos
        function textos2(dependencia, puesto) {
            escribir = document.getElementById("lbl_dProceso")
            texto2 = dependencia;
            texto3 = ' DEL CARGO PUESTO ';
            texto4 = puesto;
            escribir.innerHTML = '<b>' + texto2 + '</b>' + texto3 + '<b>' + texto4 + '</b>';
            Descripcion = texto2 + texto3 + texto4;
        }
        //////////////-- Se encarga de crear la etiqueta del Proceso, cambia acorde al select puesto y select depcia
        function CreasDPeriodo() {
            $('#slc_Puesto').change
            (function () {
                dependencia = $('#slc_Depcia option:selected').html();
                puesto = $('#slc_Puesto option:selected').html();
                textos(dependencia, puesto);
            });
            $('#slc_Depcia').change
            (function () {
                dependencia = $('#slc_Depcia option:selected').html();
                textos(dependencia, puesto);
            });
        }
        /////////////////////////-- Función que va a la BD y regresa un código para la creación del proceso
        function VerificaCodigo() {
            if (actualizar == 0) {
                var strACCION = "VALIDA_CODIGO";
                var strDatos = "{'strProceso': '" + $("#txt_sProc").val() +
                               "','strAccion': '" + strACCION +
                         "'}";

                datosJSON = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objProceso: datosJSON });

                $.ajax({
                    url: "Proceso/SAAPROCESH.aspx/VerificaCodigo",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loadCodigo(eval('(' + reponse.d + ')'));
                    },
                    error: function (result) {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                });
            }
        }
        /////////////////////////////-- verifica si el código traído por la función VerificaCodigo es igual al código de la etiqueta txt_sProc, de ser distinto manda un mensaje que el código fue actualizado
        function loadCodigo(datos) {
            var liCodigo = datos[0];

            if (actualizar == 0) {

                if (liCodigo.strProceso != $("#txt_sProc").val()) {
                    $("#txt_sProc").val(liCodigo.strProceso);
                    $.alerts.dialogClass = "infoAlert";
                    jAlert("El código del proceso ha sido actualizado", "SISTEMA DE ENTREGA-RECEPCIÓN");
                }
            }
        }

        ///////////////////////////////////////////////- Verifica que al guardar exista la guía-////////////////////////////////////////////////
        function VerificaGuiaER() {
            if (actualizar == 0) {
                var strACCION = "VALIDA_GUIA";
                var strDatos = "{'idGuiaER': '" + $('#lbl_guia').val() +
                               "','strAccion': '" + strACCION +
                         "'}";
                datosJSON = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objGuiaER: datosJSON });

                $.ajax({
                    url: "Proceso/SAAPROCESH.aspx/VerificaGuiaER",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        if (reponse.d == 1) {
                            RevisaParticipantes();
                        }
                        else {
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("La guía fue eliminada, no se puede guardar el proceso", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    },
                    error: function (result) {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                });
            }
        }
        /////////////////////////////////////////////////////////////////  -función que traerá los datos para pintar las notificaciones  - //////////////////////////////////////////   
        function ListaNotInicial() {
            var actionData = "{'strACCION': '" + "CONS_NOTIFI_TOTAL" +
            "'}";
            $.ajax({
                url: "Proceso/SAAPROCESH.aspx/DibujaNotInicial",
                data: actionData,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    lstNotificaciones = eval('(' + reponse.d + ')');
                    loadNotInicial(lstNotificaciones);
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado al cargar la notificacion, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        };
        //////////////////// recibe datos de ListaNotInicial y los utiliza para mostrar las notificaciones en los 3 select's correspondientes
        function loadNotInicial(datos) {
            var strHtml = '';
            var notInicial = 0;
            var txtNotIni = "";
            var notDurante = 0;
            var txtNotDur = "";
            var notFinal = 0;
            var txtNotFin = "";

            if (datos != null) {
                strHtml += '<option value=\"0\">Seleccione</option>';
                for (a_i = 1; a_i < datos.length; a_i++) {
                    strHtml += '<option value=\"' + datos[a_i].idNotifica + '\"> ' + datos[a_i].strAsunto + '</option>';
                }
            }
            $('#slc_MsjI').empty().append(strHtml);
            $('#slc_MsjP').empty().append(strHtml);
            $('#slc_MsjU').empty().append(strHtml);

            $('#slc_MsjI').change(function () {     //---- si cambia el dato seleccionado de este select la opción se quita de los otros select de notificaciones
                var strHtml = '';
                if ($(this).val() != 0) {

                    if (notInicial != 0) {
                    var strHtmlNot1 = '<option value=\"' + notInicial + '\"> ' + txtNotIni + '</option>';
                        $('#slc_MsjP').append(strHtmlNot1);
                        $('#slc_MsjU').append(strHtmlNot1);
                    }
                    $("#slc_MsjP").find('[value="' + $(this).val() + '"]').remove();
                    $("#slc_MsjU").find('[value="' + $(this).val() + '"]').remove();
                }
                else {
                    for (a_i = 1; a_i < lstNotificaciones.length; a_i++) {
                        if ($("#slc_MsjI").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 1) {
                            if ($("#slc_MsjP").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 0 && $("#slc_MsjU").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 0) {
                                strHtml += '<option value=\"' + datos[a_i].idNotifica + '\"> ' + datos[a_i].strAsunto + '</option>';
                            }
                        }
                    }
                    $('#slc_MsjP').append(strHtml);
                    $('#slc_MsjU').append(strHtml);
                }
                notInicial = $('#slc_MsjI option:selected').val();
                txtNotIni = $('#slc_MsjI option:selected').html();
            });

            $('#slc_MsjP').change(function () {     //---- si cambia el dato seleccionado de este select la opción se quita de los otros select de notificaciones 
                var strHtml = '';
                if ($(this).val() != 0) {

                    if (notDurante != 0) {
                        var strHtmlNot2 = '<option value=\"' + notDurante + '\"> ' + txtNotDur + '</option>';
                        $('#slc_MsjI').append(strHtmlNot2);
                        $('#slc_MsjU').append(strHtmlNot2);
                    }
                    $("#slc_MsjI").find('[value="' + $(this).val() + '"]').remove();
                    $("#slc_MsjU").find('[value="' + $(this).val() + '"]').remove();
                }
                else {
                    for (a_i = 1; a_i < lstNotificaciones.length; a_i++) {
                        if ($("#slc_MsjP").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 1) {
                            if ($("#slc_MsjI").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 0 && $("#slc_MsjU").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 0) {
                                strHtml += '<option value=\"' + datos[a_i].idNotifica + '\"> ' + datos[a_i].strAsunto + '</option>';
                            }
                        }
                    }
                    $('#slc_MsjI').append(strHtml);
                    $('#slc_MsjU').append(strHtml);
                }
                notDurante = $('#slc_MsjP option:selected').val();
                txtNotDur = $('#slc_MsjP option:selected').html();
            });

            $('#slc_MsjU').change(function () {     //---- si cambia el dato seleccionado de este select la opción se quita de los otros select de notificaciones
                var strHtml = '';
                if ($(this).val() != 0) {

                    if (notFinal != 0) {
                        var strHtmlNot3 = '<option value=\"' + notFinal + '\"> ' + txtNotFin + '</option>';
                        $('#slc_MsjI').append(strHtmlNot3);
                        $('#slc_MsjP').append(strHtmlNot3);
                    }
                    $("#slc_MsjI").find('[value="' + $(this).val() + '"]').remove();
                    $("#slc_MsjP").find('[value="' + $(this).val() + '"]').remove();
                }
                else {
                    for (a_i = 1; a_i < lstNotificaciones.length; a_i++) {
                        if ($("#slc_MsjU").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 1) {
                            if ($("#slc_MsjI").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 0 && $("#slc_MsjP").find('[value="' + lstNotificaciones[a_i].idNotifica + '"]').length == 0) {
                                strHtml += '<option value=\"' + datos[a_i].idNotifica + '\"> ' + datos[a_i].strAsunto + '</option>';
                            }
                        }
                    }
                    $('#slc_MsjI').append(strHtml);
                    $('#slc_MsjP').append(strHtml);
                }
                notFinal = $('#slc_MsjU option:selected').val();
                txtNotFin = $('#slc_MsjU option:selected').html();
            });
        }
        ////////////////////////////////////////////////////// - Consulta Datos para Actualizar la ventana con la información del proceso seleccionado - ////////////////////////////////////////////
        function fAjax(nIdProceso) {
            var actionData = "{'nIdProceso': '" + nIdProceso +
                         "'}";
            $.ajax(
                {
                    url: "Proceso/SAAPROCESH.aspx/pDatosProceso",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        PintaDatos(eval('(' + reponse.d + ')'));
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: function (result) {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("No se pudo consultar la información.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                    }
                }
            );
        }
        ///////////////////--      pinta los datos que obtiene de fAjax()        --////////////////////////////////
        function PintaDatos(datos) {
            var listaProceso = datos.datos[0];
            var listaNotificaciones = datos.datos[1];

            traeCarga = listaProceso[0].nTraeCarga;

            fechaInicioProceso = listaProceso[0].dteFInicio;
            fechaFinProceso = listaProceso[0].dteFFin;

            $('#txt_sProc').val(listaProceso[0].strProceso);
            $('#txt_sProc').prop('disabled', true);
            $('#txt_FInicio').val(listaProceso[0].dteFInicio);
            $('#txt_FFinal').val(listaProceso[0].dteFFin);

            var puesto = listaProceso[0].strPuesto;
            var idpuesto = listaProceso[0].nFKPuesto;
            $("#slc_Puesto option[value=" + idpuesto + "]").attr("selected", "selected");
            $('#slc_Puesto').prop('disabled', true);

            $('#slc_Depcia').empty();
            listDep = $('<option></option>').val(listaProceso[0].nFKDepcia).html(listaProceso[0].strDepcia);
            $('#slc_Depcia').append(listDep);
            var dependencia = listaProceso[0].strDepcia;
            $('#slc_Depcia').prop('disabled', true);

            var naturaleza = listaProceso[0].idTipoProc;
            $("#slc_TipoProc option[value=" + naturaleza + "]").attr("selected", "selected");
            $('#slc_TipoProc').prop('disabled', true);

            //Aquí viene la Consideración  y el Motivo en Caso de ser un Proceso de Tipo Ordinario o Extraordinario
           TraeConsideraciones(listaProceso);

            $('#lbl_guia').val(listaProceso[0].idFKGuiaER).html(listaProceso[0].sDGuiaER);
            $('#txt_observaciones').val(listaProceso[0].strObservaciones);
            textos2(dependencia, puesto);

            //-- EXTEMPORÁNEA       // si existe parte extemporánea la muestra
            if (listaProceso[0].dteFExtIni != null && listaProceso[0].dteFExtFin != null) {
                $('#txt_FExtIni').val(listaProceso[0].dteFExtIni);
                $('#txt_FExtFin').val(listaProceso[0].dteFExtFin);
                $('#txt_just').val(listaProceso[0].strJustExt);

                fechaIniExtem = listaProceso[0].dteFExtIni;
                fechaFinExtem = listaProceso[0].dteFExtFin;
                strJustExtem = listaProceso[0].strJustExt;
            }
            else {
                // console.log("no trae extemporaneo");
            }
            //-- AQUÍ TERMINA LA PARTE EXTEMPORÁNEA
            if (listaNotificaciones == "" || listaNotificaciones == null) {
                // $('#div_Notifi').empty(). append("* No existen Notificaciones Configuradas");
            }
            else { // si existen notificaciones , las muestra
                for (a_i = 0; a_i < listaNotificaciones.length; a_i++) {
                    if (listaNotificaciones[a_i] != undefined) {
                        if (listaNotificaciones[a_i].idNotifica != null || listaNotificaciones[a_i].idNotifica != 0) {
                            if (listaNotificaciones[a_i].cTipoNot == 'I') {
                                var notIni = listaNotificaciones[a_i].idNotifica;
                                idNotIni = listaNotificaciones[a_i].idNotifica;
                                $('#slc_MsjI option[value=' + notIni + ']').attr("selected", "selected");
                                $('#txt_dAntes').val(listaNotificaciones[a_i].nDiasAntes);
                                creaFechaNotIni();
                                $('#txt_dAntes').prop('disabled', false);
                            }
                            else if (listaNotificaciones[a_i].cTipoNot == 'D') {
                                var notProc = listaNotificaciones[a_i].idNotifica;
                                idNotProc = listaNotificaciones[a_i].idNotifica;
                                $("#slc_MsjP option[value=" + notProc + "]").attr("selected", "selected");
                                $('#txt_fIniNot').val(listaNotificaciones[a_i].strDFIniProc);
                                $('#txt_fFinNot').val(listaNotificaciones[a_i].strDFFinProc);
                                $('#txt_fIniNot').prop('disabled', false);
                                $('#txt_fFinNot').prop('disabled', false);
                            }
                            else if (listaNotificaciones[a_i].cTipoNot == 'F') {
                                var notUrg = listaNotificaciones[a_i].idNotifica;
                                idNotFin = listaNotificaciones[a_i].idNotifica;
                                $("#slc_MsjU option[value=" + notUrg + "]").attr("selected", "selected");
                                $('#txt_fUrgente').val(listaNotificaciones[a_i].nDiasAntes);
                                $('#txt_fUrgente').prop('disabled', false);
                            }
                        }
                    }
                }
            }
        }
        ////////--------------------------------****** Pinta la información del proceso respecto a si es ordinario, con una o varias dependencias.
        function TraeConsideraciones(listaProceso) {
            var valor = listaProceso[0].cCondicion;
            if (listaProceso[0].cCondicion == 'N') {
                $("#div_Ordinaria").empty();
                $("#div_Ordinaria").css("visibility", "hidden");
            }
            else if (listaProceso[0].cCondicion == 'U' || listaProceso[0].cCondicion == 'D') {  //pinta los radios en base a las condiciones establecidas
                $("#div_Ordinaria").empty().append('<blockquote>' + "<h5>Consideraciones: </h5>" + '<blockquote>'
                    + "<input type=" + 'radio' + " name=" + 'rbt_cons' + " value=" + 'U' + " id=" + 'unica' + " /><h7>Única</h7>"
                + "<input type=" + 'radio' + " name=" + 'rbt_cons' + " value=" + 'D' + " id=" + 'jerarquia' + " /><h7>Con todas sus dependencias / entidades</h7>"
                );
                $('input[name=rbt_cons][value=' + valor + ']').attr('checked', 'checked');
                $('input[name=rbt_cons]').prop('disabled', true);
            }
            if ($('#slc_TipoProc option:selected').val() == 1) { // muestra los motivos para el proceso ordinario
                 for (a_i = 0; a_i < ArrayMotivos.length; a_i++) {
                    if (ArrayMotivos[a_i].cTipoMoti == "O") {
                        listItem = $('<option></option>').val(ArrayMotivos[a_i].idMotiProc).html(ArrayMotivos[a_i].strSDMotiProc.toUpperCase());
                        $('#slc_Motivo').append(listItem);
                    }
                 }
                $('#div_Motivos').css("visibility", "visible");
                var mot = listaProceso[0].idFKMotiProc;
                $("#slc_Motivo option[value=" + mot + "]").attr("selected", "selected");
                $('#slc_Motivo').prop('disabled', true);
            }
            if ($('#slc_TipoProc option:selected').val() == 2) {    //muestra los motivos para el proceso extraordinario
                for (a_i = 0; a_i < ArrayMotivos.length; a_i++) {
                    if (ArrayMotivos[a_i].cTipoMoti == "E") {
                        listItem = $('<option></option>').val(ArrayMotivos[a_i].idMotiProc).html(ArrayMotivos[a_i].strSDMotiProc.toUpperCase());
                        $('#slc_Motivo').append(listItem);
                    }
                 }
                $('#div_Motivos').css("visibility", "visible");
                var mot = listaProceso[0].idFKMotiProc;
                $("#slc_Motivo option[value=" + mot + "]").attr("selected", "selected");
                $('#slc_Motivo').prop('disabled', true);
            }
        }

        //------------------//---------------//------------- Notificaciones Actualizar  -------------//-------------------------//_----------------//
        function FMI(fecMen, fecMay) {// dd-mm-yyyy     //valida si la fecha men es menor a la fecha may
            fi = fecMen;
            ff = fecMay;
            diaInicial = fi.substring(0, 2);
            mesInicial = fi.substring(3, 5);
            añoInicial = fi.substring(6, 10);
            diaFinal = ff.substring(0, 2);
            mesFinal = ff.substring(3, 5);
            añoFinal = ff.substring(6, 10);

            if (añoInicial > añoFinal) {
                return 0;
            }
            else if (añoFinal > añoInicial) {
                return 1;
            }
            else if (mesInicial > mesFinal && diaInicial >= diaFinal) {
                return 0;
            }
            ///
            else if (mesInicial > mesFinal) {
                return 0;
            } ////
            else if (mesInicial == mesFinal && diaInicial > diaFinal) {
                return 0;
            }
            else if (mesInicial <= mesFinal && diaInicial <= diaFinal) {
                return 1;
            }
            else if (mesFinal > mesInicial && diaInicial > diaFinal) {
                return 1;
            }
            else {
                return 1;
            }
        }
        ////////////////-- obtiene los fecha actual de diferente forma, de acuerdo al navegador
        function GetTodayDate() {
            if ($.browser.safari) {
                var fullDate = new Date();
                var twoDigitMonth = fullDate.getMonth() + 1 + ""; if (twoDigitMonth.length == 1) twoDigitMonth = "0" + twoDigitMonth;
                var twoDigitDate = fullDate.getDate() + ""; if (twoDigitDate.length == 1) twoDigitDate = "0" + twoDigitDate;
                var currentDate = twoDigitDate + "-" + twoDigitMonth + "-" + fullDate.getFullYear();
                var xxx = currentDate;

                year = fullDate.getFullYear();
            }
            if ($.browser.mozilla || $.browser.webkit) {
                var fullDate = new Date();
                var twoDigitMonth = fullDate.getMonth() + 1 + ""; if (twoDigitMonth.length == 1) twoDigitMonth = "0" + twoDigitMonth;
                var twoDigitDate = fullDate.getDate() + ""; if (twoDigitDate.length == 1) twoDigitDate = "0" + twoDigitDate;
                var currentDate = twoDigitDate + "-" + twoDigitMonth + "-" + fullDate.getFullYear();
                var xxx = currentDate;

                year = fullDate.getFullYear();
            }
            else {
                var tdate = new Date();
                var dd = tdate.getDate() < 10 ? '0' + tdate.getDate() : tdate.getDate();  //yeilds day
                var MM = tdate.getMonth() < 10 ? '0' + (tdate.getMonth() + 1) : (tdate.getMonth() + 1);
                var yyyy = tdate.getFullYear(); //yeilds year
                var xxx = dd + "-" + MM + "-" + yyyy;

                year = tdate.getFullYear();
            }
            return xxx;
        }
        ///////////////////////////////////////////////////////////////////
        function PreguntaGuardar() {                // valida que contenga los datos necesarios, para poder insertar el nuevo proceso

            var justExtemp = $('#txt_just').val();
            justExtemp = justExtemp.replace(/\n\r?/g, ' ');
            justExtemp = justExtemp.replace(/"/g, '');
            justExtemp = justExtemp.replace(/'/g, '');

            justExtemp = jsTrim(justExtemp); //QUITA CADENA VACÍA
            //text = jsTrim(text);
            $('#txt_just').val(justExtemp);

            var obsProc = $('#txt_observaciones').val();
            obsProc = obsProc.replace(/\n\r?/g, ' ');
            obsProc = obsProc.replace(/'/g, '');
            obsProc = obsProc.replace(/"/g, '');
            $('#txt_observaciones').val(obsProc);

            if (actualizar == 0) {      // si es nuevo registro ejecutara las validaciones necesarias para los campos
                if ($("#txt_sProc").val() != "") {
                    $("#div_txtCodigo").css("visibility", "hidden");
                    if ($("#txt_FInicio").val() != "" && $("#txt_FFinal").val() != "") {
                        $("#fProceso").css("visibility", "hidden");
                        var fechaInicio = $("#txt_FInicio").val();
                        var fechaFinal = $("#txt_FFinal").val();
                        fActual = GetTodayDate();
                        if (FMI(fActual, fechaInicio)) {
                            if (FMI(fActual, fechaFinal)) {
                                if (FMI(fechaInicio, fechaFinal)) {
                                    if ($('#slc_Puesto option:selected').val() != 0) {
                                        $("#Puesto").css("visibility", "hidden");
                                        if ($('#slc_Depcia option:selected').val() > 0) {
                                            $("#Depcia").css("visibility", "hidden");
                                            if ($('#slc_TipoProc option:selected').val() != 0) {
                                                $("#Nat").css("visibility", "hidden");
                                                ValidaCondicion();
                                                if ($("#Nat").css("visibility") == "hidden") {
                                                    if ($("#div_condicion").css("visibility") == "hidden") {
                                                        ValidaMotivo();
                                                        if ($('#div_condicionMot').css("visibility") == "hidden") {
                                                            ValidaNotInicial();
                                                            ValidaFechasNot();
                                                            ValidaNotUrgente();
                                                            if ($('#div_MsgInicial').css("visibility") == "hidden" && $('#div_MsgUrg').css("visibility") == "hidden"
                                                             && $('#div_MsGDurante').css("visibility") == "hidden"
                                                             ) {
                                                                VerificaCodigo();  //Función Que verifica código de proceso
                                                                if (condicion == 'N' || condicion == 'D') {
                                                                    $.alerts.dialogClass = "infoConfirm";
                                                                    jConfirm("¿Está seguro que desea guardar el proceso: " + Descripcion + "?", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                                                        if (r) {
                                                                            VerificaGuiaER();
                                                                        }
                                                                    });
                                                                }
                                                                else if (condicion == 'U') {
                                                                    $.alerts.dialogClass = "infoConfirm";
                                                                    jConfirm("¿Está seguro que desea guardar el proceso: " + Descripcion + " con una sola dependencia?", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                                                        if (r) {
                                                                            VerificaGuiaER();
                                                                        }
                                                                    });
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } else {
                                                $("#Nat").empty().append("* Campo Requerido");
                                                $("#Nat").css("visibility", "visible"); 
                                            }
                                        } else {
                                            $("#Depcia").css("visibility", "visible");

                                            if ($('#slc_TipoProc option:selected').val() == 0) {
                                                $("#Nat").css("visibility", "visible");
                                            }
                                        }
                                    } else {
                                        $("#Puesto").css("visibility", "visible");

                                        if ($('#slc_Depcia option:selected').val() == 0) {
                                            $("#Depcia").css("visibility", "visible");
                                        }
                                        if ($('#slc_TipoProc option:selected').val() == 0) {
                                            $("#Nat").css("visibility", "visible");
                                        }
                                    }
                                }
                                else { // Fecha final menor a la inicial
                                    $("#fProceso").empty().append("* La fecha de apertura inicial no puede ser mayor a la fecha de apertura final");
                                    $("#fProceso").css("visibility", "visible");
                                }
                            }
                            else {
                                $("#fProceso").empty().append("* La fecha de apertura final no puede ser menor a la fecha " + GetTodayDate());
                                $("#fProceso").css("visibility", "visible");
                            }
                            ///
                        }
                        else { // Menor a la fecha actual
                            $("#fProceso").empty().append("* La fecha de apertura inicial no puede ser menor a la fecha " + GetTodayDate());
                            $("#fProceso").css("visibility", "visible");
                        }
                    } else {
                        $("#fProceso").css("visibility", "visible");
                        if ($('#slc_Puesto option:selected').val() == 0) {
                            $("#Puesto").css("visibility", "visible");
                        }
                        if ($('#slc_Depcia option:selected').val() == 0) {
                            $("#Depcia").css("visibility", "visible");
                        }
                        if ($('#slc_TipoProc option:selected').val() == 0) {
                            $("#Nat").css("visibility", "visible");
                        }
                    }
                } else {
                    $("#div_txtCodigo").css("visibility", "visible");

                    if ($("#txt_FInicio").val() == "" && $("#txt_FFinal").val() == "") {
                        $("#fProceso").empty().append("* Campo requerido");
                        $("#fProceso").css("visibility", "visible");
                    }
                    if ($('#slc_Puesto option:selected').val() == 0) {
                        $("#Puesto").css("visibility", "visible");
                    }
                    if ($('#slc_Depcia option:selected').val() == 0) {
                        $("#Depcia").css("visibility", "visible");
                    }
                    if ($('#slc_TipoProc option:selected').val() == 0) {
                        $("#Nat").css("visibility", "visible");
                    }
                }
            }
            ////////
            else if (actualizar == 1) {         // Cuando se va a actualizar un proceso  
                if ($("#txt_FInicio").val() != "" && $("#txt_FFinal").val() != "") {
                    $("#fProceso").css("visibility", "hidden");

                    if (traeCarga == 0) {       // si el archivo no tiene carga, puede modificar las fechas de apertura y cierre
                        var fechaInicio = $("#txt_FInicio").val();
                        var fechaFinal = $("#txt_FFinal").val();
                        fActual = GetTodayDate();
                        var condicionfecha = "";

                        if (fechaInicio != fechaInicioProceso && fechaFinal == fechaFinProceso) {
                            if (FMI(fechaInicio, fActual)) {
                                if (fechaInicio != fActual) {
                                    condicionfecha = " La fecha de apertura inicial no puede ser menor a la fecha " + GetTodayDate();
                                } else {
                                    condicionfecha = "";
                                }
                            }
                            else {
                                if (FMI(fechaFinal, fechaInicio)) {

                                    if (fechaFinal == fechaInicio) {
                                        condicionfecha = "";
                                    }
                                    else {
                                        condicionfecha = " La fecha de apertura inicial no puede ser mayor a la fecha de apertura final";
                                    }
                                }
                            }
                        }
                        else if (fechaInicio == fechaInicioProceso && fechaFinal != fechaFinProceso) {
                            if (FMI(fechaFinal, fechaInicio)) {
                                if (fechaFinal == fechaInicio) {
                                    condicionfecha = "";
                                }
                                else {
                                    condicionfecha = " La fecha de apertura final no puede ser menor a la fecha de apertura inicial";
                                }
                            }
                            else {
                                if (FMI(fechaFinal, fActual)) {
                                    condicionfecha = " La fecha de apertura final no puede ser menor a la fecha " + GetTodayDate();
                                }
                            }
                        }
                        else if (fechaInicio != fechaInicioProceso && fechaFinal != fechaFinProceso) {
                            if (FMI(fechaFinal, fechaInicio)) {
                                if (fechaFinal != fechaInicio) {
                                    condicionfecha = " La fecha de apertura final no puede ser menor a la fecha de apertura inicial";
                                }
                            }
                            if (FMI(fechaFinal, fActual)) {
                                if (fechaFinal != fActual) {
                                    condicionfecha = " La fecha de apertura final no puede ser menor a la fecha " + GetTodayDate();
                                }
                            }
                            if (FMI(fechaInicio, fActual)) {
                                if (fechaInicio != fActual) {
                                    condicionfecha = " La fecha de apertura inicial no puede ser menor a la fecha " + GetTodayDate();
                                }
                            }
                        }

                        if (condicionfecha == "") {
                            ValidaNotInicial();
                            ValidaFechasNot();
                            ValidaNotUrgente();
                            if ($('#div_MsgInicial').css("visibility") == "hidden" && $('#div_MsgUrg').css("visibility") == "hidden"
                                                     && $('#div_MsGDurante').css("visibility") == "hidden"
                                                     ) {                        //                                           
                                $.alerts.dialogClass = "infoConfirm";
                                jConfirm("¿Está seguro que desea modificar el proceso: " + Descripcion + "?", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                    if (r) {
                                        Guardar();
                                    }
                                });
                            } // Valida Fechas y Campos de Notificaciones
                        }
                        else {
                            $("#fProceso").empty().append("* " + condicionfecha);
                            $("#fProceso").css("visibility", "visible");
                        }
                    }
                    ///////////////////////////////////////////////////////////
                    else if (traeCarga != 0) {          // si el archivo tiene carga, solo se puede modificar la fecha final y crear un proceso extemporáneo , si ya existe un proceso extemporáneo solo se podran modificar las fechas de este
                        var fechaInicio = $("#txt_FInicio").val();
                        var fechaFinal = $("#txt_FFinal").val();
                        fActual = GetTodayDate();
                        if (fechaFinal != fechaFinProceso) {
                            if (FMI(fActual, fechaFinal)) {
                                if (FMI(fechaInicio, fechaFinal)) {
                                    ValidaNotInicial();
                                    ValidaFechasNot();
                                    ValidaNotUrgente();
                                    if ($('#div_MsgInicial').css("visibility") == "hidden" && $('#div_MsgUrg').css("visibility") == "hidden"
                                    && $('#div_MsGDurante').css("visibility") == "hidden") {
                                        ValidaExtemporaneo();
                                        if ($('#div_sJustifExt').css("visibility") == "hidden" && $('#div_fExtemp').css("visibility") == "hidden") {
                                            $.alerts.dialogClass = "infoConfirm";
                                            jConfirm("¿Está seguro que desea modificar el proceso: " + Descripcion + "?", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                                if (r) {
                                                    Guardar();
                                                }
                                            });
                                        } // Valida Fechas y Justificación de Apertura Extemporánea
                                    } // Valida Fechas y Campos de Notificaciones
                                } // regresa condición 
                                else { // Fecha final menor a la inicial
                                    $("#fProceso").empty().append("* La fecha de apertura final no puede ser menor a la fecha de apertura inicial");
                                    $("#fProceso").css("visibility", "visible");
                                }
                            } // regresa condición
                            else {
                                $("#fProceso").empty().append("* La fecha de apertura final no puede ser menor a la fecha " + GetTodayDate());
                                $("#fProceso").css("visibility", "visible");
                            }
                        }

                        else if (fechaFinal == fechaFinProceso) {
                            ValidaNotInicial();
                            ValidaFechasNot();
                            ValidaNotUrgente();
                            if ($('#div_MsgInicial').css("visibility") == "hidden" && $('#div_MsgUrg').css("visibility") == "hidden"
                                    && $('#div_MsGDurante').css("visibility") == "hidden"
                                    ) {
                                ValidaExtemporaneo();
                                if ($('#div_sJustifExt').css("visibility") == "hidden" && $('#div_fExtemp').css("visibility") == "hidden") {
                                    $.alerts.dialogClass = "infoConfirm";
                                    jConfirm("¿Está seguro que desea modificar el proceso: " + Descripcion + "?", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                        if (r) {
                                            Guardar();
                                        }
                                    });
                                } // Valida Fechas y Justificación de Apertura Extemporánea
                            } // Valida Fechas y Campos de Notificaciones
                        }
                    }

                } else {
                    if ($("#txt_FInicio").val() == "" || $("#txt_FFinal").val() == "") {
                        $("#fProceso").empty().append("* Campo requerido");
                        $("#fProceso").css("visibility", "visible");
                    }
                }
            }
        }

        /////////////////////////////////////////////////////////////////////////////////////////////   
        function ValidaExtemporaneo() {          // valida que las fechas del extemporáneo no sean menores a las fechas del proceso, y la fecha final extemporánea sea mayor que la fecha inicial extemporánea
            if ($('#txt_FExtIni').val() != "" && $('#txt_FExtFin').val() != "") {
                if ($('#txt_just').val() != "") {
                    var fechaInicial = $("#txt_FExtIni").val();
                    var fechaFinal = $("#txt_FFinal").val();
                    var fechaFinalExt = $('#txt_FExtFin').val();

                    $("#div_fExtemp").empty();
                    $("#div_fExtemp").css("visibility", "hidden");

                    if (FMI($('#txt_FExtIni').val(), $('#txt_FFinal').val())) {
                        $("#div_fExtemp").empty().append("* La fecha inicial de apertura extemporánea no puede ser menor o igual a la fecha final de la apertura del proceso.");
                        $("#div_fExtemp").css("visibility", "visible");
                    }
                    else if (FMI(fechaFinalExt, fechaInicial)) {
                        $("#div_fExtemp").empty().append("* La fecha final de apertura extemporáneo no puede ser menor o igual a la fecha inicial del proceso extemporáneo.");
                        $("#div_fExtemp").css("visibility", "visible");
                    }
                    else
                        if (FMI(fechaFinal, fechaInicial) && FMI(fechaInicial, fechaFinalExt)) {
                            $("#div_sJustifExt").empty();
                            $("#div_sJustifExt").css("visibility", "hidden");
                        }
                }
                else if ($('#txt_just').val() == "") {
                    $("#div_sJustifExt").empty().append("* Para agregar una apertura extemporánea es necesario llenar el campo de justificación");
                    $("#div_sJustifExt").css("visibility", "visible");
                }
            }
            else {
            }
        }
        //////////////
        function RevisaParticipantes() {                  //            Consulta los participantes del proceso que se pretende crear, regresa aquellos que ya se encuentran activos en otro proceso.
            var actionData = "{'nPuesto': '" + $('#slc_Puesto option:selected').val() +
                             "','nDepcia': '" + $('#slc_Depcia option:selected').val() +
                             "','tipoProc': '" + $('#slc_TipoProc option:selected').val() +
            "'}";
            $.ajax({
                url: "Proceso/SAAPROCESH.aspx/VerificarParticipantes",
                data: actionData,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var datos = eval('(' + reponse.d + ')');
                    loadParticipantes(datos);
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("No hay información configurada.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        }
        ///////////////////////////////////////////////////////////////////////////////////////
        function loadParticipantes(datos) {         // Verifica los participantes activos en otros procesos, si la dependencia que se va a crear se encuentra activa en otro proceso, no permitirá la creación de este
                                                    // si la dependencia tiene hijas activas en otros procesos, dará la opción de crear el proceso sin esas dependencias
                                                   // si la dependencia que se usara, o las hijas de esta no se encuentran en procesos activos, guardara el proceso
            var mensaje = '';
            var dato = '';
            if (datos != null) {
                for (a_i = 1; a_i < datos.length; a_i++) {
                    if (datos[a_i].nFKDepcia == $('#slc_Depcia option:selected').val()) {
                        mensaje = 'La dependencia/entidad se encuentra configurada en el proceso ' + datos[a_i].strProceso + ' , por lo que no se puede crear en un nuevo proceso.';
                    }
                    else if (datos[a_i].nFKDepcia != $('#slc_Depcia option:selected').val()) {
                        dato += 'La dependencia/entidad: ' + '<b>' + datos[a_i].nFKDepcia + '</b>' + ' se encuentra activa en el proceso ' + '<b>' + datos[a_i].strProceso + '</b>' + "</br>";
                    }
                }
                //termina for
                if (mensaje != '') {
                    $.alerts.dialogClass = "infoAlert";
                    jAlert(mensaje, 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
                else if (dato != '') {
                    if (condicion == 'D') {
                        guardaEx(dato);
                    }
                    else if (condicion == 'U') {
                        Guardar();
                    }
                }
            }
            else {
                Guardar();
            }
        }

        //////////////////////// -- * Si la dependencia tiene hijas activas en el proceso, las mostrara en un dialog y preguntara si desea crear el proceso sin esas dependencias
        function guardaEx(dato) {
            var txt = "";
            txt = "Las siguientes dependencias/entidades no se guardarán: " + "</br></br>";
            txt += dato + "</br>";
            //            txt += "ya que se encuentrán configuradas en otro proceso activo, ¿esta seguro de continuar?";
            txt += "¿Esta seguro de continuar?";

            //            jConfirm(txt, "SISTEMA ENTREGA-RECEPCION", function (r) {
            //                if (r) {
            //                    strEXCEPTO = '1';
            //                    Guardar();
            //                } 
            //                else {
            //                }
            //            });
            $("#dialog-confirm").empty();
            $("#dialog-confirm").append(txt);

            $(function () {
                $("#dialog-confirm").dialog({
                    resizable: false,
                    height: 300,
                    width: 600,
                    modal: true,
                    buttons: {
                        "Cancelar": function () {
                            $(this).dialog("close");
                        },
                        "Aceptar": function () {
                            strEXCEPTO = '1';
                            Guardar();
                            $(this).dialog("close");
                        }
                    }
                });
            });
        }
        /////////////////////// --- * Manda a guardar el proceso 
        function Guardar() {

            loading.ini(); //////////

            var cEstatus = 'A';
            var cIndActivo = 'S';
            var cIndElim = 'N';
            var dteFExtIni = $('#txt_FExtIni').val();
            var dteFExtFin = $('#txt_FExtFin').val();

            if (actualizar == 1) {          // verifica si las fechas de inicio y final del proceso son iguales a las que devolvio la consulta que pinto los datos, si no lo son manda 1 como accion 
                if ($('#txt_FInicio').val() != "" && $('#txt_FFinal').val() != "") {
                    if ($('#txt_FInicio').val() != fechaInicioProceso || $('#txt_FFinal').val() != fechaFinProceso) {
                        nAccionFProc = 1;
                    }
                    else {
                        nAccionFProc = 0;
                    }
                }
                if ($('#txt_FExtIni').val() != "" && $('#txt_FExtFin').val() != "" && $('#txt_just').val() != "") {         // si las fechas extemporáneas son diferentes de vacías o si alguna extemporánea es diferente a las devueltas por
                                                                                                                            // la consulta, la accion de extemporaneo seara 1
                    if ($('#txt_FExtIni').val() != fechaIniExtem || $('#txt_FExtFin').val() != fechaFinExtem || $('#txt_just').val() != strJustExtem) {
                        strAccionExt = 1;
                    }
                    else {
                        strAccionExt = 0;
                    }
                }
            }
            if ($('#slc_TipoProc option:selected').val() !=1)
            {
            condicion="N";
            }
            if ($('#slc_MsjI option:selected').val() != 0) {
                idNotIni = $('#slc_MsjI option:selected').val();
            } else { idNotIni = 0; }
            if ($('#txt_dAntes').val() != 0) { nDiasAntNot1 = $('#txt_dAntes').val(); }
            else { nDiasAntNot1 = 0; }
            if ($('#slc_MsjP option:selected').val() > 0) {
                idNotProc = $('#slc_MsjP option:selected').val();
            } else { idNotProc = 0; }
            if ($('#txt_fIniNot').val() != "") { txt_fIniNot = $('#txt_fIniNot').val(); }
            else { txt_fIniNot = ""; }
            if ($('#txt_fFinNot').val() != "") { txt_fFinNot = $('#txt_fFinNot').val(); }
            else { txt_fFinNot = ""; }
            if ($('#slc_MsjU option:selected').val() > 0) { idNotFin = $('#slc_MsjU option:selected').val(); }
            else { idNotFin = 0; }
            if ($('#txt_fUrgente').val() != 0) { nDiasAntNot3 = $('#txt_fUrgente').val(); }
            else { nDiasAntNot3 = 0; }

            if ($('#slc_MsjI option:selected').val() != 0 && $('#txt_dAntes').val() != 0) { var strAccionNot1 = 1; }
            else { var strAccionNot1 = 0; }
            if ($('#slc_MsjP option:selected').val() > 0 && $('#txt_fIniNot').val() != "" && $('#txt_fFinNot').val() != "")
            { var strAccionNot2 = 1; }
            else { var strAccionNot2 = 0; }
            if ($('#slc_MsjU option:selected').val() > 0 && $('#txt_fUrgente').val() != 0)
            { var strAccionNot3 = 1; }
            else { var strAccionNot3 = 0; }

            var strDatos = "{'strProceso': '" + $('#txt_sProc').val() +
                             "','dteFInicio': '" + $('#txt_FInicio').val() +
                             "','dteFFin': '" + $('#txt_FFinal').val() +
                             "','nFKPuesto': '" + $('#slc_Puesto option:selected').val() +
                             "','nFKDepcia': '" + $('#slc_Depcia option:selected').val() +
                             "','strDProceso': '" + Descripcion +
                             "','idFKGuiaER': '" + $('#lbl_guia').val() +
                             "','idTipoProc': '" + $('#slc_TipoProc option:selected').val() +
                             "','strObservaciones': '" + $('#txt_observaciones').val() +
                             "','nUsuario': '" + nUsuario +
                             "','strEstatus': '" + cEstatus +
                             "','cIndActivo': '" + cIndActivo +
                             "','cIndElim': '" + cIndElim +
                             "','strAccion': '" + strAccion +
                             "','idProceso': '" + nIdProceso +

                             "','idNotIni': '" + (idNotIni != null ? idNotIni : 0) +
                             "','nDiasAntNot1': '" + nDiasAntNot1 +
                             "','strAccionNot1': '" + strAccionNot1 +

                             "','idNotProc': '" + (idNotProc != null ? idNotProc : 0) +
                             "','dteFIniNot': '" + txt_fIniNot +
                             "','dteFinNot': '" + txt_fFinNot +
                             "','strAccionNot2': '" + strAccionNot2 +

                             "','idNotFin': '" + (idNotFin != null ? idNotFin : 0) +
                             "','nDiasAntNot3': '" + nDiasAntNot3 +
                             "','strAccionNot3': '" + strAccionNot3 +

                             "','dteFExtIni': '" + dteFExtIni +
                             "','dteFExtFin': '" + dteFExtFin +
                             "','strAccionExt': '" + strAccionExt +
                               "','nAccionFecProc': '" + nAccionFProc +

                             "','strEXCEPTO': '" + strEXCEPTO +
                              "','cCondicion': '" + condicion + //variable para  especificar condición en la creación del proceso
                             "','strJustExt': '" + $('#txt_just').val() +
                             "','idFKMotiProc': '" + idMotivo +

                            "'}";

            datosJSON = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objProceso: datosJSON });
            //Insertara un nuevo proceso, o actualizara el existente
            $.ajax(
                    {
                        url: "Proceso/SAAPROCESH.aspx/insertaProceso",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            try {         /////////////////////////////////////////////////////////
                                loading.close();
                                if (reponse.d == 1) {
                                    if (actualizar == 0) {
                                        $.alerts.dialogClass = "correctoAlert";
                                        jAlert("El proceso entrega - recepción se ha agregado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN',
                                        function () { Cancelar(); }
                                        );
                                    }
                                    else if (actualizar == 1) {
                                        $.alerts.dialogClass = "correctoAlert";
                                        jAlert("El proceso entrega - recepción se ha modificado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN',
                                         function () { Cancelar(); }
                                        );
                                    }
                                    Cancelar();
                                }
                                else {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, no se pudo realizar la acción correspondiente, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                            }
                            catch (err) {
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, no se pudo realizar la acción correspondiente, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }               /////////////////////////////////////////////////////
                        },
                        error: function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, no se pudo realizar la acción correspondiente, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    }
                );
        }
        //////////////////////////////////////////////////////////////////////////
        // Función que nos devolvera al Grid de procesos
        function Cancelar() {
            loading.ini();
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }
        //////////////////////////////////
        //////////      * Limita el campo de observaciones a aceptar solo 'n' numero de caracteres-
        function limita(elEvento, maximoCaracteres) {
            var elemento = document.getElementById("txt_observaciones");

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
        function actualizaInfo(maximoCaracteres) {                        //           *  Actualiza la cantidad de caracteres permitidos a escribir
            var elemento = document.getElementById("txt_observaciones");
            var info = document.getElementById("info");

            if (elemento.value.length >= maximoCaracteres) {
                info.innerHTML = "Máximo de " + maximoCaracteres + " caracteres";
            }
            else {
                info.innerHTML = "Quedan " + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
            }
        }

        /////////////////////////////////////////////////////////////////////////
    </script>
    <form id="procER" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label id="titulo" class="titulo">
                Alta proceso</label>
        </div>
        <h3>
            Código:</h3>
        <input id="txt_sProc" type="text" maxlength="15" autofocus />
        <div id="div_txtCodigo" class="requeridog">
            * Campo requerido</div>
        <br />
        <h3>
            Apertura:</h3>
        <input id="txt_FInicio" type="text" size="40" />&nbsp;&nbsp;&nbsp;<label>al</label>&nbsp;&nbsp;&nbsp;<input
            id="txt_FFinal" type="text" size="40" />
        <div id="fProceso" class="requeridog">
            * Campo requerido</div>
        <br />
        <h3>
            Apertura extemporánea:</h3>
        <input id="txt_FExtIni" type="text" size="40" />&nbsp;&nbsp;&nbsp;<label>al</label>&nbsp;&nbsp;&nbsp;<input
            id="txt_FExtFin" type="text" size="40" />
        <div id="div_fExtemp" class="requeridog">
        </div>
        <br />
        <h3>
            Justificación apertura extemporánea:</h3>
        <div class="align_Textarea">
            <textarea id="txt_just" cols="112" rows="5" maxlength="250"></textarea>
        </div>
        <div id="div_sJustifExt" class="requeridog">
        </div>
        <br />
        <h3>
            Cargo/puesto o comisión que se entrega:</h3>
        <select name="slc_Puesto" id="slc_Puesto">
        </select>
        <div id="Puesto" class="requeridog">
            * Campo requerido</div>
        <br />
        <h3>
            Entrega - recepción de la dependencia/entidad :</h3>
        <select name="slc_Depcia" id="slc_Depcia">
            <option value="0">Seleccione </option>
        </select>
        <div id="Depcia" class="requeridog">
            * Campo requerido</div>
        <br />
        <label id="lbl_dProceso">
        </label>
        <br />
        <h3>
            Guía asociada:</h3>
        <br />
        <label id="lbl_guia">
        </label>
        <br />
        <h3>
            Tipo:</h3>
        <select id="slc_TipoProc">
        </select>
        <div id="Nat" class="requeridog">
            * Campo requerido</div>
        <div id="div_Ordinaria">
        </div>
        <div id="div_condicion" class="requeridog">
        </div>
        <div id="div_Motivos">
            <h3>
                Motivos:</h3>
            <select id="slc_Motivo" style="width:400px">
            </select>
        </div>
        <div id="div_condicionMot" class="requeridog">
        </div>
        <br />
        <h3>
            Observaciones:</h3>
        <%--        <div class="align_Textarea">
            <textarea id="txt_observaciones" cols="112" rows="5"></textarea>
        </div>--%>
        <div class="align_Textarea">
            <textarea id="txt_observaciones" onkeypress="return limita(event, 250);" onkeyup="actualizaInfo(250)"
                rows="5" cols="112" maxlength="250"></textarea>
            <div id="info">
                Máximo de 250 caracteres</div>
        </div>
        <br />
        <h3>
            Notificaciones:</h3>
        <div id="div_Notifi" class="agp_notificaciones">
            <h3>
                Mensaje de inicio:</h3>
            <h4>
                Asunto del mensaje:</h4>
            <select id="slc_MsjI">
            </select>
            <label class="sim_h4">
                días antes:</label>
            <input id="txt_dAntes" type="text" size="8" maxlength="3" />
            <input id="txt_fNotIni" type="text" size="12" />
            <div id="div_MsgInicial" class="requeridog">
            </div>
            <br />
            <h3>
                Mensaje durante el proceso:</h3>
            <h4>
                Asunto del mensaje:</h4>
            <select id="slc_MsjP">
            </select>
            <label class="sim_h4">
                durante:</label>
            <input id="txt_fIniNot" type="text" size="10" />
            <label class="sim_h4">
                al</label>
            <input id="txt_fFinNot" type="text" size="10" />
            <div id="div_MsGDurante" class="requeridog">
            </div>
            <br />
            <h3>
                Mensaje antes del cierre del proceso:</h3>
            <h4>
                Asunto del mensaje:</h4>
            <select id="slc_MsjU">
            </select>
            <label class="sim_h4">
                días antes:</label>
            <input id="txt_fUrgente" type="text" size="10" maxlength="2" />
            <div id="div_MsgUrg" class="requeridog">
            </div>
        </div>
        <div class="a_botones">
            <a title="Botón Guardar" id="GuardarActivo" href="javascript:PreguntaGuardar();"
                class="accAct">Guardar</a> <a title="Botón Cancelar" id="CancelarActivo" href="javascript:Cancelar();"
                    class="accAct">Cancelar</a>
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
        <div id="dialog-confirm" title="SISTEMA ENTREGA-RECEPCIÓN">
        </div>
    </div>
    </form>
</body>
</html>
