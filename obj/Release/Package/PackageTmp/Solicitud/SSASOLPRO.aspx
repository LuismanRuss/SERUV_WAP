<%@ Page Language="C#" AutoEventWireup="true" Inherits="Solicitud_SSASOLPRO" Codebehind="SSASOLPRO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <%--<script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>--%>
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
</head>
<body>

    <script type="text/javascript">

        /***********     Variables     ***********/

        var strAccion = ""; // Variable de Acción
        var intSeleccionado; //Permitirá reasignar los datos al radio button
        var strCadena = "";
        var ArrayMotivos = []; // Arreglo que almacenará los motivos
        var motivo = '';
        var blnEmpleado = true;
        var blnExterno = false;
        var idTitular = 0;  //Variable que almacena el ID del Usuario Titular de la dependencia
        var idTitularPA = 0;
        
        var idUsuarioEOP=0;   //Variable que almacena el ID del Enlace Principal
        var idUsuarioSR = 0;    //Variable que almacena el ID del Sujeto Receptor
        var strFolioActual; //Variable que almacena el folio actual
        var objTitular; // Variable con los datos del titular
        var objTitularPA;
        var strOtroSO = "N"; // Variable que indica si cambio el sujeto obligado
        var strOtroSOPA = "N";
        var objSujetoObliago;  // Variable con los datos en caso de cambiar el Sujeto Obligado
        var objSujetobligadoPA;
        var objSujetoObligadoPA;
        var objEnlaceOp; // Variable con los datos del Enlace Operativo
        var strEnlanceOp = "N"; // Variable que indica si se agrego un enlace
        var strDatosUsuarioR; // Variable con los datos del sujeto receptor en caso de buscarlo en la BD de Oracle.
        var objSO;
        var objEO;
        var objSR
        var strIndSR = "E"; // Variable que indica si el sujeto receptor es empleado o externo (E - Empleado, X - Externo)
        var strBusSR = "N"; // Variable que indica si se realizó la búsqueda del Sujeto Receptor
        var intDependencia = 0 //Variable que indica la dependencia a la que pertenece el usuario logueado

        vDate = {
            //dateFormat: 'yy-mm-dd',
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

        /***********     Document ready     ***********/
        $(document).ready(function () {

            if (NG.Nact == 2) {
                //NG.setNact(3, 'Tres', null);
                fLlenaCampos();
                loading.close(); //Cerrar el Loading
            } else {
                $("#AccReporte").hide();
                getFolioSolicitud(); //Obtener el Folio de la Solicitud
                PintaFolio(); //Función para Pintar la Etiqueta del Folio
                //ObtieneDependencia();
                if (fValidaAdministrador()) {
                    $("#titAdministrador").show();
                    //                ListaPuestoPAdministrador();
                    //                traeDependenciaPAdministrador();
                    //                TitularDepciaPA();
                } else {
                    $("#titAdministrador").hide();
                    //}
                    ListaPuesto(); //Llenamos la lista de puestos, mandamos el Ajax
                    //CreasDPeriodo(); //Pintamos la Descripción del Proceso
                    //RadioSujeto();
                }
                jQuery('#txt_dFSeparacion').datepicker(vDate);
                ListTipoproc(); //Tipo de Proceso
                traeDependencia(); //Llenamos la lista de dependencias, mandamos el Ajax
                TitularDepcia();
                $('#rbt_empleado').attr('checked', true);   //Poner en Default el Check del radio empleado
                $("#txt_NombreSR").prop('disabled', true);  //Bloquear el Input de NombreSR
                $("#txt_CorreoSR").prop('disabled', true);  //Bloquear el Input de CorreoSR

                //Campos de EOP Bloqueados
                $("#txt_EnlaceEP").prop('disabled', true);
                $("#txt_CorreoEP").prop('disabled', true);

                RadioEmpleado();
                RadioExterno();

                //VALIDACIONES
                //fValidaInput_Lugar();
                fValidaInput_Lugar(); //Función para Validar que el campo de Lugar no este vacío 
                fValidaInput_Motivo(); //Función para Validar que el campo de Motivo no este vacío 
                fValidaInput_Fecha(); //Función para Validar que el campo de Fecha no este vacío 
                fValidaInput_Cuenta(); //Función para Validar que el campo de Cuenta no este vacío 
                fValidaInput_Cuenta2(); //Función para Validar que el campo de Cuenta2 no este vacío 
                fValidaInput_NombreSR(); //Función para Validar que el campo de NombreSR no este vacío 
                //fValidaInput_CorreoSR();
                EnterSO();
                EnterSOPA();
                EnterEOP(); //Capturar la tecla enter en el input de EOP
                EnterSR(); //Capturar la tecla enter en el input del SR
                loading.close(); //Cerrar el Loading
            }
        });

        // Función que llena los campos de acuerdo a la solicitud seleccionada
        function fLlenaCampos() {
            $("input").attr("disabled", true);
            $("select").attr("disabled", true);
            $("select").empty();
            $("textarea").attr("disabled", true);
            $("#btn_Enviar").hide();
            $("#btn_Regresar").css("visibility", "visible");
            $("#Img4").hide();
            $("#Img5").hide();
            $("#Img1").hide();
            $("#Img2").hide();
            $("#ico_busqueda").hide();
            $("#ico_eliminar").hide();
            $("#lbl_Folio").text(NG.Var[NG.Nact].datoSel.cveSolProc);
            $("#slc_Puesto").append('<option>' + NG.Var[NG.Nact].datoSel.sPuesto + '</option>');
            $("#slc_Puesto").css("width", "auto");
            $("#slc_Depcia").append('<option>' + NG.Var[NG.Nact].datoSel.sDependencia + '</option>');
            $("#slc_Depcia").css("width", "auto");
            $("#slc_Motivo").append('<option>' + NG.Var[NG.Nact].datoSel.sMotivo + '</option>');
            $("#slc_Motivo").css("width", "auto");
            $("#txt_Lugar").val(NG.Var[NG.Nact].datoSel.sLugar);
            $("#txt_dFSeparacion").val(NG.Var[NG.Nact].datoSel.dFSeparacion);
            $("#txt_Observaciones").val(NG.Var[NG.Nact].datoSel.sObservaciones);
            $("#txt_CuentaSO").val(NG.Var[NG.Nact].datoSel.sNombreSO);
            $("#lblCorreoSO").text(NG.Var[NG.Nact].datoSel.sCorreoSO);
            if (NG.Var[NG.Nact].datoSel.sNombreEO.length > 0) {
                var arrCorreoEP = NG.Var[NG.Nact].datoSel.sCorreoEO.split("@");
                $("#inp_cuenta2").val(arrCorreoEP[0]);
                $("#txt_EnlaceEP").val(NG.Var[NG.Nact].datoSel.sNombreEO);
                $("#txt_CorreoEP").val(NG.Var[NG.Nact].datoSel.sCorreoEO);
            }
            if (NG.Var[NG.Nact].datoSel.cIndTipo == "E") {
                $("#rbt_empleado").attr("checked", true);
                var arrCorreoSR = NG.Var[NG.Nact].datoSel.sCorreoSR.split("@");
                $("#inp_cuenta").val(arrCorreoSR[0]);
            } else {
                $("#rbt_externo").attr("checked", true);
            }
            $("#txt_NombreSR").val(NG.Var[NG.Nact].datoSel.sNombreSR);
            $("#txt_CorreoSR").val(NG.Var[NG.Nact].datoSel.sCorreoSR);
        }

        function fValidaAdministrador() {
            if ($("#hf_esAdministrador").val() == "S") {
                return true
                //$("#titAdministrador").show();
            } else {
                return false;
                //$("#titAdministrador").hide();
            }
        }

        function ObtieneDependencia() {
//            var actionData = "{'idUsuario':'" +
//                            $("#hf_idUsuario").val() +
            //                            "'}";
            var actionData = "{}";
            $.ajax({
                url: "SSASOLPRO.aspx/ObtieneDependenciaUsuario",
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
        }

        /***********     Función Ajax Lista de Puestos     ***********/
          
        //Función Ajax para traer la lista de puestos de la Base de datos        
        function ListaPuesto() {
            //var actionData = "{}";
            var actionData = "{'idUsuario':'" +
                            $("#hf_idUsuario").val() +
                            "'}";
            $.ajax({
                url: "SSASOLPRO.aspx/DibujaListPuesto",
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

        /***********     Pintar Puestos    ***********/

        //Función para pintar el combo de puestos 
        function loadListPuesto(datos) {
            //console.log(datos);
            $('#slc_Puesto').empty();
            listItem = $('<option></option>').val(0).html('[Seleccione]');
            $('#slc_Puesto').append(listItem);
            if (datos != null) {
                for (a_i = 0; a_i < datos.length; a_i++) {
                    listItem = $('<option id=' + datos[a_i].nPuesto + '></option>').val(datos[a_i].nPuesto).html(datos[a_i].sDPuesto);
                    $('#slc_Puesto').append(listItem);
                }
            }
        }

        /***********     Función Ajax Obtener Dependencias     ***********/

        //Función Ajax para traer la lista de dependencias de la Base de datos  
        function traeDependencia() {
            $('#slc_Puesto').change
                (function () {
                    ListaDependencia();
                });
            }

        function ListaDependencia() {
            $('#slc_Puesto option:selected').each(function () {
                $("#lblSujetObligado").text("");
                $("#lblCorreoSO").text("");
                $("#txt_CuentaSO").val("");
                $("#txt_CuentaSO").attr("disabled", false);

                nPuesto = $('#slc_Puesto').find(':selected').val();

                //Al seleccionar el puesto quitar la validación
                if ($('#slc_Puesto option:selected').val() != 0) {
                    $("#div_txtCargoPuesto").css("visibility", "hidden");
                }
                else {
                    $("#div_txtCargoPuesto").css("visibility", "visible");
                }

                var intidUsuario;
                if ($("#hf_esAdministrador").val() == "S") {
                    //console.log(objSujetoObligadoPA[0].idUsuario);
                    intidUsuario = objSujetoObligadoPA[0].idUsuario;
                } else {
                    intidUsuario = $("#hf_idUsuario").val();
                }

                var actionData = "{'nPuesto': '" + nPuesto +
                //"','idUsuario': '" + $("#hf_idUsuario").val() +
                                    "','idUsuario': '" + intidUsuario +
                                    "'}";
                $.ajax({
                    url: "SSASOLPRO.aspx/DibujaListDepcia",
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
        }

        /***********  Función Pintar Dependencias    ***********/
        
        //Función para pintar el combo de Dependencias
        function loadListDepcia(datos) {
            if (datos != null) {
                $('#slc_Depcia').empty();
                listItem = $('<option id =' + "seleccione" + '></option>').val(0).html('[Seleccione]');
                $('#slc_Depcia').append(listItem);
                for (a_i = 0; a_i < datos.length; a_i++) {
                    listItem = $('<option id=' + datos[a_i].nDepcia + ' ></option>').val(datos[a_i].nDepcia).html(datos[a_i].sDDepcia);
                    $('#slc_Depcia').append(listItem);
                }
                if (datos.length == 1) {
                    $("#slc_Depcia").val(datos[0].nDepcia);
                    ObtieneTitular();
                }
            }
            else {
                $('#slc_Depcia').empty();
                listItem = $('<option></option>').val(0).html('[Seleccione]');
                $('#slc_Depcia').append(listItem);
            }
        }

/*
        ////////////////////////////////////////////////////////// - Crea La Descripcion del Proceso - ////////////////////////////////////
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
        /////////////////////////////////
        function textos2(dependencia, puesto) {
            escribir = document.getElementById("lbl_dProceso")
            texto2 = dependencia;
            texto3 = ' DEL CARGO PUESTO ';
            texto4 = puesto;
            escribir.innerHTML = '<b>' + texto2 + '</b>' + texto3 + '<b>' + texto4 + '</b>';
            Descripcion = texto2 + texto3 + texto4;
        }
        /////////////////////////////////
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

*/
        //////////////////////////////////////////////////////////////////- Función Ajax Tipo Proceso -///////////////////////////////////////////////////////

        //Función Ajax para traer la lista de Tipos de Procesos de la Base de datos  
        function ListTipoproc() {
            var strACCION = "OBTENER_TIPO_PROC";

            var strACCIONMot = "OBTENER_MOT_PROC";
            var actionData = "{'strACCION': '" + strACCION +
                          "','strACCIONMot': '" + strACCIONMot +
                            "'}";
            $.ajax({
                url: "SSASOLPRO.aspx/DibujaListTipoProc",
                data: actionData,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loadListTipProc(eval('(' + reponse.d + ')'));
                    //console.log(reponse.d);
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, no se puede cargar el tipo de proceso, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        };
        
        //Función que nos pinta los combos de Motivos
        function loadListTipProc(datos) {

            var tipoproc = datos.datos[0];
            //console.log(tipoproc);
            motivo = datos.datos[1];

            // Lista de Tipo de Proceso
            listItem = $('<option></option>').val(0).html('[Seleccione]');  //MOTIVOS PARA TIPO DE PROCESO ORDINARIO            

            //Recorremos la lista y creamos el combo de Tipo de Procesos
            $('#slc_TipoProc').append(listItem);
            for (a_i = 0; a_i < tipoproc.length; a_i++) {
                listItem = $('<option></option>').val(tipoproc[a_i].idTipoProc).html(tipoproc[a_i].strDTipoProc);
                $('#slc_TipoProc').append(listItem);
            }

            //Recorremos la lista y creamos el combo de Motivos
            listItem2 = $('<option></option>').val(0).html('[Seleccione]'); //MOTIVOS PARA TIPO DE PROCESO EXTRAORDINARIO
            $('#slc_Motivo').append(listItem2);
            for (a_i = 1; a_i < motivo.length; a_i++) {
                if (motivo[a_i].cIndActivo == 'S') {
                    listItem2 = $('<option id=' + motivo[a_i].idMotiProc + ' ></option>').val(motivo[a_i].idMotiProc).html(motivo[a_i].strSDMotiProc.toUpperCase());
                    $('#slc_Motivo').append(listItem2);
                    //ArrayMotivos[a_i] = { "idMotiProc": motivo[a_i].idMotiProc, "strSDMotiProc": motivo[a_i].strSDMotiProc, "cTipoMoti": motivo[a_i].cTipoMot, "cIndActivo": motivo[a_i].cIndActivo };
                }
            }
            //console.log(listItem2);
            $('#slc_Motivo').append(listItem2);
        }

        //Función para Validar que un Motivo sea seleccionado
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

        //Función que controla la funcionalidad cuando se le da click al radio de Sujeto Repcetor
        function RadioSujeto() {

            $("input[type='radio']").click(function () {
                var previousValue = $(this).attr('previousValue');
                var name = $(this).attr('name');

                if (previousValue == 'checked') {
                    $(this).removeAttr('checked');
                    $(this).attr('previousValue', false);
                }
                else {
                    $("input[name=" + name + "]:radio").attr('previousValue', false);
                    $(this).attr('previousValue', 'checked');
                }
            });
        }

        //Función para Limitar la longitud del campo de Observaciones
        function flimita(elEvento, maximoCaracteres) {
            var elemento = document.getElementById("txt_Observaciones");

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

        //Función para Actualizar el contador del input de observaciones
        function fActualizaInfo(maximoCaracteres) {
            var elemento = document.getElementById("txt_Observaciones");
            var info = document.getElementById("info");

            if (elemento.value.length >= maximoCaracteres) {
                info.innerHTML = "Máximo de " + maximoCaracteres + " caracteres";
            }
            else {
                info.innerHTML = "Quedan " + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
            }
        }

        /***********     Función Ajax para Obtener Datos del Titular     ***********/

        //Función Ajax para traer los datos del Titular de la dependencia y puesto seleccionados
        function TitularDepcia() {
            $('#slc_Depcia').change
                (function () {
                    ObtieneTitular();
                });
            }

        function ObtieneTitular() {
            var id = $("#slc_Depcia").children(":selected").attr("id");
            var intPuesto = $("#slc_Puesto").children(":selected").attr("id");
            //console.log(intPuesto);
            //console.log(id);

            //Al seleccionar la dependencia quitar la validación
            if ($('#slc_Depcia option:selected').val() != 0) {
                $("#div_txtDepcia").css("visibility", "hidden");
            }
            else {
                $("#div_txtDepcia").css("visibility", "visible");
            }

            if (id == "seleccione") {
                $("#lblSujetObligado").text("");
                $("#lblCorreoSO").text("");
            }
            else {
                var strDatos = "{'accion': '" + "BUSCAR_TITULAR" +
                                   "','intNumDependencia': '" + id +
                                   "','intPuesto': '" + intPuesto +
                                   "'}";

                objSujetobligado = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objSujetobligado: objSujetobligado });
                //console.log(actionData);

                $.ajax({
                    url: "SSASOLPRO.aspx/pGetDatosTitular",
                    data: actionData,
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        strOtroSO = "N";
                        LimpiaCamposSO();
                        objTitular = eval('(' + reponse.d + ')');
                        PintaDatosTitular(eval('(' + reponse.d + ')'));
                    },
                    error: function (result) {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, no se pueden cargar los datos, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                });
            } //fin if seleccione
        }

        //Función que Pinta las Etiquetas de los datos del Titular en la Forma
         function PintaDatosTitular(cadena) {
             //console.log(cadena);
//             console.log(objSujetoObliago);
             if (cadena != null) {
                 if (strOtroSO == "N") {
                     $("#txt_CuentaSO").prop("disabled", false);
                     $("#lblSujetObligado").text(cadena.lstUsuarios[1].strNombre);
                     $("#lblCorreoSO").text(cadena.lstUsuarios[1].strCorreo);
                     idTitular = cadena.lstUsuarios[1].idUsuario;
                 } else {
                     $("#txt_CuentaSO").prop("disabled", true);
                     $("#lblSujetObligado").text(cadena[0].strNombre + " " + cadena[0].strApPaterno + " " + cadena[0].strApMaterno);
                     $("#lblCorreoSO").text(cadena[0].strCorreo);
                     idTitular = cadena[0].idUsuario;
                 }
             } else {
                 $("#txt_CuentaSO").prop("disabled", false);
                 $("#lblSujetObligado").text("");
                 $("#lblCorreoSO").text("");
                 idTitular = 0;
             }
        }

        //Función que controla las acciones cuando se da click al radio button del Radio de Empleado
        function RadioEmpleado() {

            $("#rbt_empleado").click(function () {
                if ($("#rbt_empleado").is(':checked')) {

                    strIndSR = "E";
                    idUsuarioSR = 0;
                    $("#inp_cuenta ").val("");
                    $("#txt_NombreSR").val("");
                    $("#txt_CorreoSR").val("");

                    blnEmpleado = true;
                    blnExterno = false;

                    $("#div_NombreSR").css("visibility", "hidden");
                    $("#div_CorreoSR").css("visibility", "hidden");

                    $("#div_BuscarCuenta").show();
                    $("#txt_NombreSR").prop('disabled', true);
                    $("#txt_CorreoSR").prop('disabled', true);
                    $("#inp_cuenta").prop('disabled', false);
                } else {
                    //alert("No está activado");
                }
            });
        }

        //Función que controla las acciones cuando se da click al radio button de empleado Externo
        function RadioExterno() {

            $("#rbt_externo").click(function () {
                if ($("#rbt_externo").is(':checked')) {

                    strIndSR = "X";
                    idUsuarioSR = 0;
                    $("#inp_cuenta ").val("");
                    $("#txt_NombreSR").val("");
                    $("#txt_CorreoSR").val("");

                    blnExterno = true;
                    blnEmpleado = false;

                    //$("#div_BuscarCuenta").hide();
                    $("#inp_cuenta").prop('disabled', false);
                    $("#txt_NombreSR").prop('disabled', false);
                    $("#txt_CorreoSR").prop('disabled', false);
                } else {
                    //alert("No está activado");
                }
            });
        }

        //Función para Validar la Búsqueda de los Datos del Sujeto Receptor
        function Buscar() {
            $("#div_Mcuenta").empty();
            $("#div_Mcuenta").css("visibility", "hidden");
            $("#div_Mcuenta2").empty();
            $("#div_Mcuenta2").css("visibility", "hidden");
            $("#inp_cuenta").val(jsTrim($("#inp_cuenta").val()));

            if ($("#inp_cuenta").val().length > 0) {

                if ($("#inp_cuenta").val() != $("#inp_cuenta2").val() || $("#txt_EnlaceEP").val() == "") {
//                    BuscaUsuarios();
                    if (strOtroSO == "S") {
                        if ($("#inp_cuenta").val() != $("#txt_CuentaSO").val()) {
                            BuscaUsuarios();
                            strBusSR = "S";
                        } else {
                            strBusSR = "N";
                            $("#div_Mcuenta").empty();
                            $("#div_Mcuenta").css("visibility", "hidden");
                            $("#div_Mcuenta2").empty().append("* La cuenta del Sujeto Receptor debe ser distinta a la cuenta del Sujeto Obligado.");
                            $("#div_Mcuenta2").css("visibility", "visible");
                        }
                    } else {

                        if (strOtroSO == "N") {
                            //console.log(objTitular);
                            var arrSplitSO = $("#lblCorreoSO").text().split("@");
                            //console.log(arrSplitSO);
                            if ($("#inp_cuenta").val() != arrSplitSO[0]) {
                                BuscaUsuarios();
                                strBusSR = "S";
                            } else {
                                strBusSR = "N";
                                $("#div_Mcuenta").empty();
                                $("#div_Mcuenta").css("visibility", "hidden");
                                $("#div_Mcuenta2").empty().append("* La cuenta del Sujeto Receptor debe ser distinta a la cuenta del Sujeto Obligado.");
                                $("#div_Mcuenta2").css("visibility", "visible");
                            }
                        } else { 
                    
                        }

                    }
                }
                else {
                    strBusSR = "N";
                    $("#div_Mcuenta").empty();
                    $("#div_Mcuenta").css("visibility", "hidden");
                    $("#div_Mcuenta2").empty().append("* La cuenta del Sujeto Receptor debe ser distinta a la cuenta del Enlace Principal.");
                    $("#div_Mcuenta2").css("visibility", "visible");
                }
                //alert("Correcto.")
            }
            else {
                //$.alerts.dialogClass = "incompletoAlert";
                //jAlert("Indique una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                strBusSR = "N";
                $("#div_Mcuenta").empty().append("* Indique una cuenta institucional.");
                $("#div_Mcuenta").css("visibility", "visible");
                $('#txt_NombreSR').val("");
                $('#txt_CorreoSR').val("");

            }
        }

        //Función para Quitar espacios en Blanco
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        //Función para Buscar Los Datos del Sujeto Receptor
        function BuscaUsuarios() {

            loading.ini();
            var strCont = $("#inp_cuenta").val().replace(/'/g, '"');

            var strParametros = "{'sCuenta': '" + strCont + 
                                "','sPerfil': 'SR'}";
                $.ajax(
                {
                    url: "SSASOLPRO.aspx/BuscaUsuario",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //loading.close();
                        if (reponse.d != null) {
                            var objRespuesta = eval('(' + reponse.d + ')');
                            var resp = objRespuesta.Respuesta;
                            var strMensaje = objRespuesta.msj;
                            console.log(resp);
                            switch (resp) {
                                case "-5":
                                    //$.alerts.dialogClass = "incompletoAlert";
                                    //jAlert("El usuario se encuentra en un proceso activo.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    //LimpiaValores();
                                    fObtieneProcesosSR();
                                    break;
                                case "-4":
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // No se logró conectar con la base de datos de Oracle.
                                    LimpiaValores();
                                    break
                                case "-3": //EL USUARIO NO ESTA EN LA BD DE ORACLE
                                    //$.alerts.dialogClass = "incompletoAlert";
                                    //jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    if (strMensaje == "") {
                                        $("#div_Mcuenta").empty().append("* La cuenta institucional no está registrada.");
                                    } else {
                                        $("#div_Mcuenta").empty().append(strMensaje);
                                    }
                                    
                                    $("#div_Mcuenta").css("visibility", "visible");

                                    $("#div_Mcuenta2").empty();
                                    $("#div_Mcuenta2").css("visibility", "hidden");

                                    LimpiaValores();
                                    $("#inp_cuenta").focus().select();
                                    break;
                                case "-2": //NO SE EJECUTO EL QUERY DE ORACLE
                                    // jAlert("No se pudo consultar el usuario.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // de oracle

                                    //$.alerts.dialogClass = "incompletoAlert";
                                    //jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    if (strMensaje = "") {
                                        $("#div_Mcuenta").empty().append("* La cuenta institucional no está registrada.");
                                    } else {
                                        $("#div_Mcuenta").empty().append(strMensaje);
                                    }
                                    
                                    $("#div_Mcuenta").css("visibility", "visible");

                                    $("#div_Mcuenta2").empty();
                                    $("#div_Mcuenta2").css("visibility", "hidden");

                                    LimpiaValores();
                                    break;
                                case "-1": //NO SE EJECUTO EL QUERY DE SQL
                                    // jAlert("No se pudo consultar el usuario.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    //$.alerts.dialogClass = "incompletoAlert";
                                    //jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    //$("#div_Mcuenta2").empty().append("* La cuenta institucional no está registrada.");
                                    //$("#div_Mcuenta2").css("visibility", "visible");

                                    $("#div_Mcuenta").empty().append("* La cuenta institucional no está registrada.");
                                    $("#div_Mcuenta").css("visibility", "visible");

                                    $("#div_Mcuenta2").empty();
                                    $("#div_Mcuenta2").css("visibility", "hidden");

                                    LimpiaValores();
                                    break;
                                case "0": // EL USUARIO YA EXISTE
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                    LimpiaValores();

                                    break;
                                default: //EN OTRO CASO TRAE EL ID DEL USUARIO Y MUESTRA LOS DATOS

                                    resp = jsTrim(resp);
                                    if (resp.indexOf("ERROR") == -1) {
                                        if (resp.length > 0) {
                                            strDatosUsuarioR = eval('(' + resp + ')');
                                            MuestraDatosUsuario(eval('(' + resp + ')'));
                                        } else {
                                            LimpiaValores();
                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                        }
                                    } else {
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("No se puede establecer conexión con el servidor, favor de comunicarse al correo dmedrano@uv.mx", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                    }
                                    
                                    break;
                            }
                        } else {
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                            LimpiaValores();
                        }
                    },
                    //beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );

        } //fin de la función


        //PERMITE LIMPIAR EL FORMULARIO DE ENLACES OPERATIVOS
        function LimpiaValores() {
            idUsuarioEOP;
            //$('#inp_cuenta').val("");
            $('#txt_NombreSR').val("");
            $('#txt_CorreoSR').val("");
            //$("#div_Mcuenta").css("visibility", "hidden");
        }

        //Muestra los datos del sujeto receptor
        function MuestraDatosUsuario(sDatos) {
            //$("#div_Mcuenta2").empty();
            $("#div_Mcuenta2").css("visibility", "hidden");
            $("#div_NombreSR").css("visibility", "hidden");
            $("#inp_cuenta").prop('disabled', true);
            $("#txt_NombreSR").prop('disabled', true);
            $("#txt_CorreoSR").prop('disabled', true);
            $("#div_Mcuenta").css("visibility", "hidden");
            $("#txt_NombreSR").val(sDatos[0].strNombre + " " + sDatos[0].strApPaterno + " " + sDatos[0].strApMaterno);
            $("#txt_CorreoSR").val(sDatos[0].strCorreo);
            idUsuarioSR = sDatos[0].idUsuario;

        }

        //Limpiar campos de búsqueda
        function Limpia() {
            //$("#div_Mcuenta").empty();
            $("#div_Mcuenta2").css("visibility", "hidden");

            strBusSR = "N";
            idUsuarioSR = 0;
            $("#inp_cuenta").prop('disabled', false);    
            $('#inp_cuenta').val("");
            $('#txt_NombreSR').val("");
            $('#txt_CorreoSR').val("");
            $("#div_Mcuenta").css("visibility", "hidden");

            var chrRadioEmpleado = $("input[name='receptor']:checked").val();
            //console.log(chrRadioEmpleado);

            if (chrRadioEmpleado == 'Empleado') {
                $("#txt_NombreSR").prop('disabled', true);
                $("#txt_CorreoSR").prop('disabled', true);
            }
            if (chrRadioEmpleado == 'Externo') {
                $("#txt_NombreSR").prop('disabled', false);
                $("#txt_CorreoSR").prop('disabled', false);
            }

        }

        function fObtieneProcesosSR() {
            //var strDatos = $("#inp_cuenta").val().replace(/'/g, '"');
            var strDatos = "{'sCuenta':'" + $("#inp_cuenta").val().replace(/'/g, '"') +
                            "'}";
            //loading.ini();
            //loading.close();

            $.ajax({
                url: "SSASOLPRO.aspx/fObtieneProcesosSR",
                data: strDatos,
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = eval('(' + reponse.d + ')');
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("El usuario se encuentra participando en el proceso: " + resp[0].strProceso + " " + resp[0].strDProceso, "SISTEMA DE ENTREGA - RECEPCIÓN");
                },
                error: function (result) {
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, no se pueden cargar los datos, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        }

        function fEnviar() {
            //urls(5, "Proceso/SAAPMOTIVH.aspx");
        }

        function fReporte() {
            //urls(5, "Proceso/SAAPMOTIVH.aspx");
        }

        //Función para Validar todos los campos de la forma (Espacios en blanco y Códigos)
        function fValida() {
            $("#div_Mcuenta2").css("visibility", "hidden")
            $("#div_McuentaEOP2").css("visibility", "hidden");

            var blnFecha = false;
            $("#div_McuentaEOP").css("visibility", "hidden");

            if ($('#slc_Puesto option:selected').val() != 0) {
                $("#div_txtCargoPuesto").css("visibility", "hidden");

                if (jsTrim($("#txt_Lugar").val()) != "") {
                    $("#div_txtLugar").css("visibility", "hidden");

                    if ($('#slc_Depcia option:selected').val() != 0) {
                        $("#div_txtDepcia").css("visibility", "hidden");

                        if ($('#slc_Motivo option:selected').val() != 0) {
                            $("#div_condicionMot").css("visibility", "hidden");

                            if (jsTrim($("#txt_dFSeparacion").val()) != "") {
                                $("#div_txtdFSeparacion").css("visibility", "hidden");

                                if (isValidDate($("#txt_dFSeparacion").val()) == true) {
                                    //$("#div_txtdFSeparacion").css("visibility", "hidden");
                                    blnFecha = true;
                                    $("#txt_CuentaSO").val(jsTrim($("#txt_CuentaSO").val()));
                                    //$("#inp_cuenta2").val(jsTrim($("#inp_cuenta2").val()));
                                    $("#inp_cuenta").val(jsTrim($("#inp_cuenta").val()));
                                    if ((jsTrim($("#txt_CuentaSO").val()).length > 0 && strOtroSO == "S") || (jsTrim($("#txt_CuentaSO").val()).length == 0 && strOtroSO == "N")) {
                                        //if ((jsTrim($("#inp_cuenta2").val()).length > 0 && strEnlanceOp == "S") || (jsTrim($("#inp_cuenta2").val()).length == 0 && strEnlanceOp == "N")) {
                                            
                                            if (blnEmpleado == true) {

                                                if (jsTrim($("#inp_cuenta").val()) != "") {
                                                    //if ($("#inp_cuenta").val() != "") {
                                                    $("#div_Mcuenta").css("visibility", "hidden");

                                                    if (jsTrim($("#txt_NombreSR").val()) != "") {
                                                        //if ($("#txt_NombreSR").val() != "" && $("#txt_CorreoSR").val() != "") {
                                                        $("#div_NombreSR").css("visibility", "hidden");
                                                        $("#div_CorreoSR").css("visibility", "hidden");
                                                        //console.log("envio empleado")
                                                        //loading.ini();
                                                        EnviarSolicitud();

                                                    }

                                                    else {
                                                        $("#div_Mcuenta").empty().append("* No se ha completado la búsqueda");
                                                        $("#div_Mcuenta").css("visibility", "visible");

                                                        $("#div_Mcuenta2").empty();
                                                        $("#div_Mcuenta2").css("visibility", "hidden");

                                                        $("#inp_cuenta").focus();

                                                    }

                                                }

                                                else {
                                                    $("#div_Mcuenta").empty().append("* Campo requerido");
                                                    $("#div_Mcuenta").css("visibility", "visible");
                                                    $("#inp_cuenta").focus();
                                                }

                                            } //if empleado

                                            if (blnExterno == true) {


                                                if ($("#txt_NombreSR").val() != "") {
                                                    $("#div_NombreSR").css("visibility", "hidden");

                                                    //                                            if ($("#txt_CorreoSR").val() != "") {
                                                    //                                                $("#div_CorreoSR").css("visibility", "hidden");
                                                    //                                                //console.log("enviar externo");
                                                    //loading.ini();
                                                    EnviarSolicitud();
                                                    //                                            }
                                                    //                                            else {
                                                    //                                                $("#div_CorreoSR").css("visibility", "visible");
                                                    //                                            }
                                                }

                                                else {
                                                    $("#div_NombreSR").css("visibility", "visible");
                                                    $("#txt_NombreSR").focus();
                                                }

                                            } //if externo
                                        //} else {
                                        //    //No se ha realizado la búsqueda del EO
                                        //    $("#div_McuentaEOP").empty().append("* No se ha completado la búsqueda");
                                        //    $("#div_McuentaEOP").css("visibility", "visible");
                                        //    $("#inp_cuenta2").focus();
                                        //}
                                    } else {
                                        // No se ha realizado la búsqueda del SO
                                        $("#div_McuentaSO").empty().append("* No se ha completado la búsqueda");
                                        $("#div_McuentaSO").css("visibility", "visible");
                                        $("#txt_CuentaSO").focus();
                                    }
                                }//if fecha
                                else {
                                    $("#div_txtdFSeparacion").empty().append("* Formato de Fecha Incorrecto");
                                    $("#div_txtdFSeparacion").css("visibility", "visible");
                                    $("#txt_dFSeparacion").focus();
                                }

                            }
                            else {
                                $("#div_txtdFSeparacion").empty().append("* Campo requerido");
                                $("#div_txtdFSeparacion").css("visibility", "visible");
                                $("#txt_dFSeparacion").focus();
                            }
                        }
                        else {
                            $("#div_condicionMot").css("visibility", "visible");
                            $("#slc_Motivo").focus();
                        }
                    }
                    else {
                        $("#div_txtDepcia").css("visibility", "visible");
                        $("#slc_Depcia").focus();
                    }
                }
                else {
                    $("#div_txtLugar").css("visibility", "visible");
                    $("#txt_Lugar").focus();
                }
            }
            else {
                $("#div_txtCargoPuesto").css("visibility", "visible");
                    $("#slc_Puesto").focus();
                    blnFecha = false;
            }


            if (jsTrim($("#txt_Lugar").val()) != "") {
                $("#div_txtLugar").css("visibility", "hidden");
            }
            else {
                $("#div_txtLugar").css("visibility", "visible");
                //$("#txt_Lugar").focus();
            }

            if ($('#slc_Depcia option:selected').val() != 0) {
                $("#div_txtDepcia").css("visibility", "hidden");
            }
            else {
                $("#div_txtDepcia").css("visibility", "visible");
                //$("#slc_Depcia").focus();
            }

            if ($('#slc_Motivo option:selected').val() != 0) {
                $("#div_condicionMot").css("visibility", "hidden");
            }
            else {
                $("#div_condicionMot").css("visibility", "visible");
                //$("#slc_Motivo").focus();
            }

            if (blnFecha == false) {

                if (jsTrim($("#txt_dFSeparacion").val()) != "") {
                    $("#div_txtdFSeparacion").css("visibility", "hidden");


                    if (isValidDate($("#txt_dFSeparacion").val()) == true) {
                        $("#div_txtdFSeparacion").css("visibility", "hidden");
                    }
                    else {
                        $("#div_txtdFSeparacion").empty().append("* Formato de Fecha Incorrecto");
                        $("#div_txtdFSeparacion").css("visibility", "visible");
                        //$("#txt_dFSeparacion").focus();        
                    }
                
                }

                else {
                    $("#div_txtdFSeparacion").empty().append("* Campo requerido");
                    $("#div_txtdFSeparacion").css("visibility", "visible");
                    //$("#txt_dFSeparacion").focus();
                }
            
            }

            if ((jsTrim($("#txt_CuentaSO").val()).length > 0 && strOtroSO == "S") || (jsTrim($("#txt_CuentaSO").val()).length == 0 && strOtroSO == "N")) {
                $("#div_McuentaSO").css("visibility", "hidden");
            }else{
                // No se ha realizado la búsqueda del SO
                $("#div_McuentaSO").empty().append("* No se ha completado la búsqueda");
                $("#div_McuentaSO").css("visibility", "visible");
//                $("#txt_CuentaSO").focus();
            }

            if ((jsTrim($("#inp_cuenta2").val()).length > 0 && strEnlanceOp == "S") || (jsTrim($("#inp_cuenta2").val()).length == 0 && strEnlanceOp == "N")) {
                $("#div_McuentaEOP").css("visibility", "hidden");
            } else { 
            //No se ha realizado la búsqueda del EO
                $("#div_McuentaEOP").empty().append("* No se ha completado la búsqueda");
                $("#div_McuentaEOP").css("visibility", "visible");
//                $("#inp_cuenta2").focus();
            }


            if (blnEmpleado == true) {

                if (jsTrim($("#inp_cuenta").val()) != "") {
                    $("#div_Mcuenta").css("visibility", "hidden");


                    if (jsTrim($("#txt_NombreSR ").val()) != "") {
                        $("#div_NombreSR").css("visibility", "hidden");
                        $("#div_CorreoSR").css("visibility", "hidden");

                    }

                    else {

                        $("#div_Mcuenta").empty().append("* No se ha completado la búsqueda");
                        $("#div_Mcuenta").css("visibility", "visible");

                        $("#div_Mcuenta2").empty();
                        $("#div_Mcuenta2").css("visibility", "hidden");
                        //$("#inp_cuenta").focus();

                    }

                }

                else {
                    $("#div_Mcuenta").empty().append("* Campo requerido");
                    $("#div_Mcuenta").css("visibility", "visible");
                    //$("#inp_cuenta").focus();
                }

            } //if empleado

            if (blnExterno == true) {


                            if (jsTrim($("#txt_NombreSR").val()) != "") {
                                $("#div_NombreSR").css("visibility", "hidden");
                            }
                            else {
                                $("#div_NombreSR").css("visibility", "visible");
                                //$("#txt_NombreSR").focus();
                            }

//                            if ($("#txt_CorreoSR").val() != "") {
//                                $("#div_CorreoSR").css("visibility", "hidden");
//                            }
//                            else {
//                                $("#div_CorreoSR").css("visibility", "visible");
//                            }

                        } //if externo

                        

        } //fin función

        //Función para Validar la Fecha
        function isValidDate(subject) {
            //if (subject.match(/^(?:(0[1-9]|1[012])[\- \/.](0[1-9]|[12][0-9]|3[01])[\- \/.](19|20)[0-9]{2})$/)) {
            if (subject.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/)) {
                return true;
            } else {
                return false;
            }
        }

        //Función para Validar que el campo de Lugar no quede vacío
        function fValidaInput_Lugar() {
            $("#txt_Lugar").change(function () {
                var intCodigo = jsTrim($("#txt_Lugar").val());

                if (intCodigo.length > 0) {
                    $("#div_txtLugar").css("visibility", "hidden");
                }
                else {
                    $("#div_txtLugar").empty().append("* Campo requerido");
                    $("#div_txtLugar").css("visibility", "visible");
                }
            });
        }


        //Función para Validar que el Combo de Motivo no quede sin seleccionar
        function fValidaInput_Motivo() {
            $('#slc_Motivo').change
                (function () {

                    if ($('#slc_Motivo option:selected').val() != 0) {
                        $("#div_condicionMot").css("visibility", "hidden");
                    }
                else {
                    $("#div_condicionMot").css("visibility", "visible");
                    }
            });
        }


        //Función para Validar que el campo de Fecha no quede vacío
        function fValidaInput_Fecha() {
            blnDatos = false;

            $("#txt_dFSeparacion").change(function () {

                if ($("#txt_dFSeparacion").val() != "") {
                    $("#div_txtdFSeparacion").css("visibility", "hidden");

                    if (isValidDate($("#txt_dFSeparacion").val()) == true) {
                        $("#div_txtdFSeparacion").css("visibility", "hidden");
                    }
                    else {
                        $("#div_txtdFSeparacion").empty().append("* Formato de Fecha Incorrecto");
                        $("#div_txtdFSeparacion").css("visibility", "visible");
                    }

                }
                else {

                    $("#div_txtdFSeparacion").empty().append("* Campo requerido");
                    $("#div_txtdFSeparacion").css("visibility", "visible");
                
                }

            });
        }

        //Función para Validar que el campo de Cuenta no quede vacío
        function fValidaInput_Cuenta() {
            $("#inp_cuenta ").change(function () {
                var intCodigo = jsTrim($("#inp_cuenta ").val());

                if (intCodigo.length > 0) {
                    $("#div_Mcuenta").css("visibility", "hidden");
                }
                else {
                    $("#div_Mcuenta2").empty();
                    $("#div_Mcuenta2").css("visibility", "hidden");

                    $("#div_Mcuenta").empty().append("* Campo requerido");
                    $("#div_Mcuenta").css("visibility", "visible");
                }
            });
        }

        //Función para Validar que el campo de Cuenta2 no quede vacío
        function fValidaInput_Cuenta2() {
            $("#inp_cuenta2").change(function () {
                var intCodigo = jsTrim($("#inp_cuenta2").val());

                if (intCodigo.length > 0) {
                    $("#div_McuentaEOP").css("visibility", "hidden");
                }
                else {
                    $("#div_McuentaEOP2").css("visibility", "hidden");
                    //$("#div_McuentaEOP").empty().append("* Campo requerido");
                    //$("#div_McuentaEOP").css("visibility", "visible");
                }
            });
        }

        //Función para Validar que el campo del Nombre del Sujeto Receptor no quede vacío
        function fValidaInput_NombreSR() {
            $("#txt_NombreSR ").change(function () {
                var intCodigo = jsTrim($("#txt_NombreSR ").val());

                if (intCodigo.length > 0) {
                    $("#div_NombreSR").css("visibility", "hidden");
                }
                else {
                    $("#div_NombreSR").empty().append("* Campo requerido");
                    $("#div_NombreSR").css("visibility", "visible");
                }
            });
        }


//        function fValidaInput_CorreoSR() {
//            $("#txt_CorreoSR ").change(function () {
//                var intCodigo = jsTrim($("#txt_CorreoSR ").val());

//                if (intCodigo.length > 0) {
//                    $("#div_CorreoSR").css("visibility", "hidden");
//                }
//                else {
//                    $("#div_CorreoSR").empty().append("* Campo requerido");
//                    $("#div_CorreoSR").css("visibility", "visible");
//                }
//            });
//        }



        //Función para Validar la Busqueda de los Datos del Enlace Principal
        function Buscar2() {
            loading.ini();
            $("#inp_cuenta").val(jsTrim($("#inp_cuenta").val()));
            $("#inp_cuenta2").val(jsTrim($("#inp_cuenta2").val()));
            var cuenta = $("#inp_cuenta2").val();
            var strCont = cuenta.replace(/'/g, '"');
            var actionData = "{'sCuenta': '" + strCont + "','sPerfil':'EO'}";
            if ($("#inp_cuenta2").val().length > 0) {

                if ($("#inp_cuenta2").val() != $("#inp_cuenta").val() || $("#txt_NombreSR").val() == "") {

                    $.ajax({
                        url: "SSASOLPRO.aspx/BuscaUsuario",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            loading.close();
                            if (reponse.d != null) {
                                var objRespuesta = eval('(' + reponse.d + ')');
                                var resp = objRespuesta.Respuesta;
                                var strMensaje = objRespuesta.msj;
                                switch (resp) {
                                    case "-4":
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // No se logró conectar con la base de datos de Oracle.
                                        Limpia2();
                                        break
                                    case "-3": //EL USUARIO NO ESTA EN LA BD DE ORACLE
                                        if (strMensaje == "") {
                                            $("#div_McuentaEOP").empty().append("* La cuenta institucional no está registrada.");
                                        } else {
                                            $("#div_McuentaEOP").empty().append(strMensaje);
                                        }
                                        
                                        $("#div_McuentaEOP").css("visibility", "visible");

                                        $("#div_McuentaEOP2").empty();
                                        $("#div_McuentaEOP2").css("visibility", "hidden");

                                        //Limpia2();
                                        $("#inp_cuenta2").focus().select();
                                        break;
                                    case "-2": //NO SE EJECUTO EL QUERY DE ORACLE
                                        if (strMensaje = "") {
                                            $("#div_McuentaEOP").empty().append("* La cuenta institucional no está registrada.");
                                        } else {
                                            $("#div_McuentaEOP").empty().append(strMensaje);
                                        }
                                        
                                        $("#div_McuentaEOP").css("visibility", "visible");

                                        $("#div_McuentaEOP2").empty();
                                        $("#div_McuentaEOP2").css("visibility", "hidden");
                                        $("#inp_cuenta2").focus().select();
                                        //Limpia2();
                                        break;
                                    case "-1": //NO SE EJECUTO EL QUERY DE SQL
                                        $("#div_McuentaEOP").empty().append("* La cuenta institucional no está registrada.");
                                        $("#div_McuentaEOP").css("visibility", "visible");

                                        $("#div_McuentaEOP2").empty();
                                        $("#div_McuentaEOP2").css("visibility", "hidden");
                                        $("#inp_cuenta2").focus().select();
                                        //Limpia2();
                                        break;
                                    case "0": // EL USUARIO YA EXISTE
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                        Limpia2();
                                        break;
                                    default: //EN OTRO CASO TRAE EL ID DEL USUARIO Y MUESTRA LOS DATOS
                                        resp = jsTrim(resp);
                                        if (resp.indexOf("ERROR") == -1) {
                                            if (resp.length > 0) {
                                                strEnlanceOp = "S";
                                                objEnlaceOp = eval('(' + resp + ')');
                                                PintaDatosEOP(eval('(' + resp + ')'));
                                            } else {
                                                Limpia2();
                                                $.alerts.dialogClass = "errorAlert";
                                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                            }
                                        } else {
                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert("No se puede establecer conexión con el servidor, favor de comunicarse al correo dmedrano@uv.mx", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                        }

                                        break;
                                }
                            } else {
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                Limpia2();
                            }
                        },
                        //beforeSend: loading.ini(),
                        //complete: loading.close(),
                        error: function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });
                    //BuscarEOP();
                }
            else {
                loading.close();
                    $("#div_McuentaEOP").empty();
                    $("#div_McuentaEOP").css("visibility", "hidden");
                    $("#div_McuentaEOP2").empty().append("* La cuenta del Enlace Principal debe ser distinta a la cuenta del Sujeto Receptor");
                    $("#div_McuentaEOP2").css("visibility", "visible");
                }
                //alert("Correcto.")
            }
            else {
                //$.alerts.dialogClass = "incompletoAlert";
                //jAlert("Indique una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                loading.close();
                $("#div_McuentaEOP").empty().append("* Indique una cuenta institucional");
                $("#div_McuentaEOP").css("visibility", "visible");
                
                $("#div_McuentaEOP2").empty();
                $("#div_McuentaEOP2").css("visibility", "hidden");

                $('#txt_NombreSR').val("");
                $('#txt_CorreoSR').val("");

            }
        }





        //Función para Buscar Los Datos del Enlace Principal
        function BuscarEOP() {

            $("#inp_cuenta2").val(jsTrim($("#inp_cuenta2").val()));
//            if ($("#inp_cuenta2").val().length > 0) {
                
                var cuenta = $("#inp_cuenta2").val();

                var strCont = cuenta.replace(/'/g, '"');
                //var strCont = cuenta.replace(/'/g, '"');
                //strCont = cuenta.replace(/"/g, '');   
                //strCont = cuenta.replace(/\\/g, '"');
                //console.log(strCont);

                var actionData = "{'cuenta': '" + strCont + "'}";
                loading.ini();
                $.ajax(
                {
                    url: "SSASOLPRO.aspx/buscaCuenta",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(reponse.d);
                        if (eval('(' + reponse.d + ')') != null) {
                            PintaDatosEOP(eval('(' + reponse.d + ')'));
                            loading.close();
                        }
                        else {
                            loading.close();
                            $("#div_McuentaEOP").empty().append("* La cuenta institucional no está registrada.");
                            $("#div_McuentaEOP").css("visibility", "visible");

                            $("#div_McuentaEOP2").empty();
                            $("#div_McuentaEOP2").css("visibility", "hidden");
                            //$.alerts.dialogClass = "incompletoAlert";
                            //jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            //Limpia2();
                            $("#inp_cuenta2").focus().select();
                        }
                    },
                    // beforeSend: alert("beforeSend"),
                    //                    complete: loading.close(),
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
//            }
//            else {
//                //jAlert("Indique una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
//                $("#div_McuentaEOP").empty().append("* Indique una cuenta institucional");
//                $("#div_McuentaEOP").css("visibility", "visible");
//                //alert("Indique una cuenta institucional."); jAlert
//            }

        }

        //Limpiar campos de búsqueda del Enlace Operativo Principal
        function Limpia2() {
            //console.log("limpia");
            strEnlanceOp = "N";
            $("#div_McuentaEOP2").css("visibility", "hidden");
            idUsuarioEOP = 0; ;
            $("#inp_cuenta2").prop('disabled', false);    
            $('#inp_cuenta2').val("");
            $('#txt_EnlaceEP').val("");
            $('#txt_CorreoEP').val("");
            $("#div_McuentaEOP").css("visibility", "hidden");
        }

        //Función para Pintar los Datos del Enlace Principal
        function PintaDatosEOP(cadena) {
            //console.log(cadena);
//            if (cadena != null) {
//                if (cadena.length > 1) {
//                    console.log("Oracle");
//                    $("#div_McuentaEOP2").css("visibility", "hidden");
//                    $("#inp_cuenta2").prop('disabled', true);
//                    $("#txt_EnlaceEP").text(cadena[0].strNombre);
//                    $("#txt_CorreoEP").text(cadena[0].strCorreo);
//                    idUsuarioEOP = cadena[0].idUsuario;
//                } else {
//                    console.log("SQL");
//                    console.log(cadena[0].strNombre);
//                    $("#div_McuentaEOP2").css("visibility", "hidden");
//                    $("#inp_cuenta2").prop('disabled', true);
//                    $("#txt_EnlaceEP").text(cadena[0].strNombre + " " + cadena[0].strApPaterno + " " + cadena[0].strApMaterno);
//                    $("#txt_CorreoEP").text(cadena[0].strCorreo);
//                    idUsuarioEOP = cadena[0].idUsuario;
//                }
//            } else {
//                console.log("nulo?");
//                $("#txt_EnlaceEP").text("");
//                $("#txt_CorreoEP").text("");
//                idUsuarioEOP = 0;
//            }
            //console.log(cadena);
            $("#div_McuentaEOP2").css("visibility", "hidden");
            $("#inp_cuenta2").prop('disabled', true);          
            $("#txt_EnlaceEP").val(cadena[0].strNombre + " " + cadena[0].strApPaterno + " " + cadena[0].strApMaterno);
            $("#txt_CorreoEP").val(cadena[0].strCorreo);
            $("#lbl_CorreoEO").text(cadena[0].strCorreo);
            idUsuarioEOP = cadena[0].idUsuario;

        }

        //Función Ajax para Enviar los datos de la solicitud
        function EnviarSolicitud() {

            if (VerificarCodigo() == true) {
                $.alerts.dialogClass = "infoConfirm";
                jConfirm('La Solicitud de Intervención con <strong>folio:</strong> ' + '<em>' + strFolioActual + '</em>' + ' será enviada a la Contraloria \n\n¿Está seguro que desea enviarla?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                    if (r) {
                        var nPuesto = $('select[name="slc_Puesto"]').val();
                        var nDepcia = $('select[name="slc_Depcia"]').val();
                        var cIndTipo = $("input[name='receptor']:checked").val();
                        cIndTipo = (cIndTipo == "Empleado" ? cIndTipo = "E" : cIndTipo = "X");
                        var idMotivo = $('select[name="slc_Motivo"]').val();

                        var strObservaciones3 = $('#txt_Observaciones').val();
                        var strObservaciones2 = strObservaciones3.replace(/\n\r?/g, ' ');
                        var strObservaciones1 = strObservaciones2.replace(/'/g, '');
                        var strObservaciones = strObservaciones1.replace(/"/g, '');

                        var strDatos =
                                "{'nFKPuesto': '" + nPuesto +
                                "','nFKDepcia': '" + nDepcia +
                                "','idFKUsuSO': '" + idTitular +
                                "','idFKUsuEOP': '" + idUsuarioEOP +
                                "','idFKMotiProc': '" + idMotivo +
                                "','idFKUsuRecep': '" + idUsuarioSR +
                                "','sLugar': '" + $("#txt_Lugar").val() +
                                "','cIndTipo': '" + cIndTipo +
                                "','dFSeparacion': '" + ($('#txt_dFSeparacion').val() != '' ? $('#txt_dFSeparacion').val() : '') +
                                "','sObservaciones': '" + strObservaciones +
                                "','nUsuario': '" + $("#hf_idUsuario").val() +
                                "','strACCION': '" + "INSERTAR" +
                                "','sCuentaSR': '" + $("#inp_cuenta").val() +
                                "','sNombreSR': '" + $("#txt_NombreSR").val() +
                                "','sCorreoSR': '" + $("#txt_CorreoSR").val() +
                                "','cveSolProc': '" + strFolioActual +
                                "'}";

                        objSolicitud = eval('(' + strDatos + ')');
                        if (strOtroSO == "N") {
                            //                            console.log(objTitular);
                            objSO = objTitular;
                        } else {
                            //                            console.log(objSujetoObliago);
                            objSO = objSujetoObliago[0];
                        }
                        //console.log("Enlace");
                        //console.log(objEnlaceOp);
                        if (strEnlanceOp == "N") {
                            objEO = null;
                            //objEnlaceOp[0] = null;
                        } else {
                            objEO = objEnlaceOp[0];
                        }

                        if (strIndSR == "X" && strBusSR == "N") {
                            objSR = null;
                            //strDatosUsuarioR[0] = null;
                        } else {
                            objSR = strDatosUsuarioR[0];
                        }

                        //console.log("llega");
                        //console.log(strDatosUsuarioR[0]);
                        //console.log(objEnlaceOp[0]);

                        //actionData = frms.jsonTOstring({ objSolicitud: objSolicitud, objUsuario: strDatosUsuarioR[0], objUsuarioSO: objSO, objUsuarioEnlace: objEnlaceOp[0], sEnlace: strEnlanceOp, sBusquedaSR: strBusSR });
                        actionData = frms.jsonTOstring({ objSolicitud: objSolicitud, objUsuario: objSR, objUsuarioSO: objSO, objUsuarioEnlace: objEO, sEnlace: strEnlanceOp, sBusquedaSR: strBusSR });
                        loading.ini();
                        $.ajax(
                        {
                            url: "SSASOLPRO.aspx/Insertar_Solicitud",
                            data: actionData,
                            dataType: "json",
                            async: false,
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {
                                switch (reponse.d) {

                                    case 1:
                                        loading.close();
                                        $.alerts.dialogClass = "correctoAlert";
                                        jAlert('Se ha enviado a la Contraloría General su Solicitud, en breve recibirá una notificación para iniciar el proceso.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                            //LimpiarCampos();
                                            Reporte(strFolioActual);

                                            // console.log(strFolioActual);
                                            //alert("2");
                                            fRegresar();
                                        });
                                        break;

                                    case 0:
                                        loading.close();
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                            //fRegresar();
                                        });
                                        break;
                                }
                            },
                            //beforeSend: alert("beforeSend"),
                            //complete: loading.close(),
                            error: errorAjax
                        }); //fin ajax


                    }
                });                           // FIN DEL jConfirm


                    }
                    else {
                        loading.close();
                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("El código de la solicitud ha sido actualizado", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {

                            //fRegresar();
                        });
                } // if verificar codigo

            } //fin función


            //Función para ir a la Forma Actual
            function fRegresar() {
                urls(1, "SSASOLPRO.aspx")
            }

            //Función que controla los bloques de la Solicitud
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


            //Función para Obtener el Folio de la Solicitud al Cargar la Forma
            function getFolioSolicitud() {

                var strDatos = "{'strACCION': '" + "GENERAR_FOLIO" +
                       "'}";
                objSolicitud = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objSolicitud: objSolicitud });

                $.ajax(
                {
                    url: "SSASOLPRO.aspx/Codigo_Solicitud",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        cadena = eval('(' + reponse.d + ')');
                        strFolioActual = cadena.cveSolProc;
                    },
                    //beforeSend: alert("beforeSend"),
                    //complete: loading.close(),
                    error: errorAjax
                });
            }

            //Función para Pintar la Etiqueta de Folio
            function PintaFolio() {
                if (strFolioActual != "") {
                    $("#lbl_Folio").text(strFolioActual);
                }
                else {
                    $("#lbl_Folio").text("Folio no encotrado");
                }
            }

            //Función para Verificar que el Código no se repita
            function VerificarCodigo() {
                var strfolio = $("#lbl_Folio").text();
                getFolioSolicitud();

                if (strFolioActual != strfolio) {
                    $("#lbl_Folio").text(strFolioActual);
                    return false;
                }
                else {
                    return true;
                }

            }

            //Función para buscar otro Sujeto Obligado
            function BuscarSO() {
                loading.ini();
                $("#div_McuentaSO").empty();
                $("#div_McuentaSO").css("visibility", "hidden");
                $("#txt_CuentaSO").val(jsTrim($("#txt_CuentaSO").val()));
                if ($("#txt_CuentaSO").val().length > 0) {
                    if ($("#inp_cuenta").val() != $("#txt_CuentaSO").val()) {
                        strOtroSO = "S";
                        var strCont = $("#txt_CuentaSO").val().replace(/'/g, '"');

                        var strParametros = "{'sCuenta': '" + strCont + 
                                               "','sPerfil': 'SO'}";
                        $.ajax({
                            url: "SSASOLPRO.aspx/BuscaUsuario",
                            data: strParametros,
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {
                                loading.close();
                                if (reponse.d != null) {
                                    var objRespuesta = eval('(' + reponse.d + ')');
                                    var resp = objRespuesta.Respuesta;
                                    var strMensaje = objRespuesta.msj;
                                    switch (resp) {
                                        case "-4":
                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // No se logró conectar con la base de datos de Oracle.
//                                            LimpiaValores();
                                            break
                                        case "-3": //EL USUARIO NO ESTA EN LA BD DE ORACLE
                                            if (strMensaje = "") {
                                                $("#div_McuentaSO").empty().append("* La cuenta institucional no está registrada.");
                                            } else {
                                                $("#div_McuentaSO").empty().append(strMensaje);
                                            }
                                            
                                            $("#div_McuentaSO").css("visibility", "visible");
//                                            LimpiaValores();
                                            $("#txt_CuentaSO").focus().select();
                                            break;
                                        case "-2": //NO SE EJECUTO EL QUERY DE ORACLE
                                            if (strMensaje = "") {
                                                $("#div_McuentaSO").empty().append("* La cuenta institucional no está registrada.");
                                            } else {
                                                $("#div_McuentaSO").empty().append(strMensaje);
                                            }

                                            
                                            $("#div_McuentaSO").css("visibility", "visible");
//                                            LimpiaValores();
                                            break;
                                        case "-1": //NO SE EJECUTO EL QUERY DE SQL
                                            $("#div_McuentaSO").empty().append("* La cuenta institucional no está registrada.");
                                            $("#div_McuentaSO").css("visibility", "visible");
//                                            LimpiaValores();
                                            break;
                                        case "0": // EL USUARIO YA EXISTE
                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                            LimpiaCamposSO();
                                            break;
                                        default: //EN OTRO CASO TRAE EL ID DEL USUARIO Y MUESTRA LOS DATOS
                                            resp = jsTrim(resp);
                                            if (resp.indexOf("ERROR") == -1) {
                                                if (resp.length > 0) {
                                                    objSujetoObliago = eval('(' + resp + ')');
                                                    //MuestraDatosUsuario(eval('(' + reponse.d + ')'));
                                                    PintaDatosTitular(eval('(' + resp + ')'))
                                                } else {
                                                    LimpiaCamposSO();
                                                    $.alerts.dialogClass = "errorAlert";
                                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                                }
                                            } else {
                                                $.alerts.dialogClass = "errorAlert";
                                                jAlert("No se puede establecer conexión con el servidor, favor de comunicarse al correo dmedrano@uv.mx", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                            }
                                            
                                            break;
                                    }
                                } else {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                    LimpiaCamposSO();
                                }
                            },
                            //beforeSend: loading.ini(),
                            //complete: loading.close(),
                            error: function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        });
                    } else {
                        loading.close();
                        $("#div_McuentaSO").empty().append("* La cuenta del Sujeto Obligado debe ser distinta a la cuenta del Sujeto Receptor.");
                        $("#div_McuentaSO").css("visibility", "visible");
                    }
                } else {
                    loading.close();
                    $("#div_McuentaSO").empty().append("* Indique una cuenta institucional");
                    $("#div_McuentaSO").css("visibility", "visible");
                }
            }

            // Función para capturar el evento de la tecla enter en el campo de búsqueda del sujeto obligado
            function EnterSO() {
                $('#txt_CuentaSO').keypress(function (event) {
                    if (event.keyCode == 13) {
                        //BuscarEOP();
                        BuscarSO();
                    }
                });
            }

            //Función para Capturar el Evento de la tecla ENTER en el campo del Enlace Principal
            function EnterEOP() {

                $('#inp_cuenta2').keypress(function (event) {
                    if (event.keyCode == 13) {
                        //BuscarEOP();
                        Buscar2();
                    }
                });

            }


            //Función para Capturar el Evento de la tecla ENTER en el campo del Sujeto Receptor
            function EnterSR() {
                $('#inp_cuenta').keypress(function (event) {
                    if (event.keyCode == 13) {
                        //$("#hrf_bus").focus().select();
                        Buscar();
                    }
                });
            }

            //Función para Abrir la Ventana Modal que contiene el Reporte
            function Reporte(strFolioActual) {
                var cveSolProc = strFolioActual;
//                console.log(cveSolProc);
//                alert("antes");
                dTxt = '<div id="dComent" title="SERUV - Reporte">';                
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?strscveSolProc=' + cveSolProc + '&op=SOLICITUD' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                dTxt += '</div>';
                $('#SSASOLPRO').append(dTxt);
                $("#dComent").dialog({
                    autoOpen: true,
                    height: $(window).height() - 60, //800, 
                    width: $("#agp_contenido").width() - 50, //1000, 
                    modal: true,
                    resizable: true
                });
            }

            /*función que se utiliza cuando se cierra el dialog*/
            function fCerrarDialog() {
                $('#dComent').dialog("close");
                $("#dComent").dialog("destroy");
                $("#dComent").remove();
            }

            function LimpiaCamposSO() {
                $("#div_McuentaSO").empty();
                $("#div_McuentaSO").css("visibility", "hidden");
                strOtroSO = "N";
                $("#txt_CuentaSO").val("");
                PintaDatosTitular(objTitular);
            }

            function LimpiaCamposEO() {

            }

            function MuestraDatosEnlace() {
                $("#div_Mcuenta2").css("visibility", "hidden");

                $("#inp_cuenta").prop('disabled', true);
                $("#txt_NombreSR").prop('disabled', true);
                $("#txt_CorreoSR").prop('disabled', true);
                $("#div_Mcuenta").css("visibility", "hidden");
                $("#txt_NombreSR").val(sDatos[0].strNombre + " " + sDatos[0].strApPaterno + " " + sDatos[0].strApMaterno);
                $("#txt_CorreoSR").val(sDatos[0].strCorreo);
                idUsuarioSR = sDatos[0].idUsuario;
            }


            function ReporteSolicitud() {
                var cveSolProc = NG.Var[NG.Nact].datoSel.cveSolProc;
                dTxt = '<div id="dComent" title="SERUV - Reporte">';
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?strscveSolProc=' + cveSolProc + '&op=SOLICITUD' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
                dTxt += '</div>';
                $('#SSASOLPRO').append(dTxt);
                $("#dComent").dialog({
                    autoOpen: true,
                    height: $(window).height() - 60, //800,
                    width: $("#agp_contenido").width() - 50, //1000,
                    modal: true,
                    resizable: true,
                    close: function (event, ui) {
                        fCerrarDialog();
                    }
                });
            }

            function fRegresarSolicitudes() {
                urls(5, "../Administracion/Proceso/SAMSOLICI.aspx");
            }


            /*********** Conjunto de funciones para el panel del administrador *********/

            //Función para buscar otro Sujeto Obligado
            function BuscarSOPA() {
                loading.ini();
                $("#div_McuentaSOPA").empty();
                $("#div_McuentaSOPA").css("visibility", "hidden");
                $("#txt_CuentaSOPA").val(jsTrim($("#txt_CuentaSOPA").val()));
                if ($("#txt_CuentaSOPA").val().length > 0) {
                    //                    if ($("#inp_cuenta").val() != $("#txt_CuentaSO").val()) {
                    strOtroSOPA = "S";
                    var strCont = $("#txt_CuentaSOPA").val().replace(/'/g, '"');

                    var strParametros = "{'sCuenta': '" + strCont + "'}";
                    $.ajax({
                        url: "SSASOLPRO.aspx/BuscaUsuarioSuperior",
                        data: strParametros,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            loading.close();
                            if (reponse.d != null) {
                                var resp = reponse.d;
                                switch (resp) {
                                    case "-4":
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // No se logró conectar con la base de datos de Oracle.
                                        //                                            LimpiaValores();
                                        break
                                    case "-3": //EL USUARIO NO ESTA EN LA BD DE ORACLE
                                        $("#div_McuentaSOPA").empty().append("* La cuenta institucional no está registrada.");
                                        $("#div_McuentaSOPA").css("visibility", "visible");
                                        //                                            LimpiaValores();
                                        $("#txt_CuentaSOPA").focus().select();
                                        break;
                                    case "-2": //NO SE EJECUTO EL QUERY DE ORACLE
                                        $("#div_McuentaSOPA").empty().append("* La cuenta institucional no está registrada.");
                                        $("#div_McuentaSOPA").css("visibility", "visible");
                                        //                                            LimpiaValores();
                                        break;
                                    case "-1": //NO SE EJECUTO EL QUERY DE SQL
                                        $("#div_McuentaSOPA").empty().append("* La cuenta institucional no está registrada.");
                                        $("#div_McuentaSOPA").css("visibility", "visible");
                                        //                                            LimpiaValores();
                                        break;
                                    case "0": // EL USUARIO YA EXISTE
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                        LimpiaCamposSOPA();
                                        break;
                                    default: //EN OTRO CASO TRAE EL ID DEL USUARIO Y MUESTRA LOS DATOS
                                        resp = jsTrim(resp);
                                        if (resp.length > 0) {
                                            objSujetoObligadoPA = eval('(' + reponse.d + ')');
                                            //MuestraDatosUsuario(eval('(' + reponse.d + ')'));
                                            PintaDatosTitularPA(eval('(' + reponse.d + ')'))
                                        } else {
                                            LimpiaCamposSOPA();
                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                        }
                                        break;
                                }
                            } else {
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                LimpiaCamposSOPA();
                            }
                        },
                        //beforeSend: loading.ini(),
                        //complete: loading.close(),
                        error: function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });
                    //                    } else {
                    //                        loading.close();
                    //                        $("#div_McuentaSOPA").empty().append("* La cuenta del Sujeto Obligado debe ser distinta a la cuenta del Sujeto Receptor.");
                    //                        $("#div_McuentaSOPA").css("visibility", "visible");
                    //                    }
                } else {
                    loading.close();
                    $("#div_McuentaSOPA").empty().append("* Indique una cuenta institucional");
                    $("#div_McuentaSOPA").css("visibility", "visible");
                }
            }

            //Función Ajax para traer la lista de puestos de la Base de datos        
            function ListaPuestoPAdministrador(cadena) {
                //console.log(cadena);
                var actionData = "{'idUsuario':'" +
                            cadena +
                            "'}";
                $.ajax({
                    url: "SSASOLPRO.aspx/DibujaListPuesto",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loadListPuesto2(eval('(' + reponse.d + ')'));
                    },
                    error: function (result) {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                });
            }

            function loadListPuesto2(datos) {
                if (datos != null) {
                    $("#slc_Puesto").empty();
                    listItem = $('<option></option>').val(0).html('[Seleccione]');
                    $('#slc_Puesto').append(listItem);
                    for (a_i = 0; a_i < datos.length; a_i++) {
                        listItem = $('<option id=' + datos[a_i].nPuesto + '></option>').val(datos[a_i].nPuesto).html(datos[a_i].sDPuesto);
                        $('#slc_Puesto').append(listItem);
                    }
                } else {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("El usuario \"" + $("#txt_CuentaSOPA").val() + "\" no es Titular de una Dependencia.", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                        if (r) {
                            $("#txt_CuentaSOPA").prop("disabled", false);
                            $("#txt_CuentaSOPA").val("");
                            $("#lbl_SujetoObligadoPA").text("");
                            $("#lblCorreoSOPA").text("");
                            $("#txt_CuentaSOPA").focus();
                        }
                    });
                }
            }

            //Función que Pinta las Etiquetas de los datos del Titular en la Forma
            function PintaDatosTitularPA(cadena) {
                if (cadena.length) {
                    if (cadena[0].lstPerfiles.length > 0) {
                        if (cadena != null) {
                            if (strOtroSOPA == "N") {
                                $("#txt_CuentaSOPA").prop("disabled", false);
                                $("#lbl_SujetoObligadoPA").text(cadena.lstUsuarios[1].strNombre + " - " + cadena.lstUsuarios[1].strCorreo);
                                //$("#lblCorreoSOPA").text(cadena.lstUsuarios[1].strCorreo);
                                idTitularPA = cadena.lstUsuarios[1].idUsuario;
                            } else {
                                $("#txt_CuentaSOPA").prop("disabled", true);
                                $("#lbl_SujetoObligadoPA").text(cadena[0].strNombre + " " + cadena[0].strApPaterno + " " + cadena[0].strApMaterno + " - " + cadena[0].strCorreo);
                                //$("#lblCorreoSOPA").text(cadena[0].strCorreo);
                                idTitularPA = cadena[0].idUsuario;
                            }
                            ListaPuestoPAdministrador(cadena[0].idUsuario);
                        } else {
                            $("#txt_CuentaSOPA").prop("disabled", false);
                            $("#lbl_SujetoObligadoPA").text("");
                            $("#lblCorreoSOPA").text("");
                            idTitularPA = 0;
                        }
                    } else {
                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("El usuario \"" + $("#txt_CuentaSOPA").val() + "\" no es Superior Jerárquico.", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                            if (r) {
                                $("#txt_CuentaSOPA").val("");
                                $("#txt_CuentaSOPA").focus();
                            }
                        });
                    }
                } else {
                    $("#div_McuentaSOPA").empty().append("* La cuenta institucional no está registrada.");
                    $("#div_McuentaSOPA").css("visibility", "visible");
                }
            }

            function LimpiaCamposSOPA() {
                $("#div_McuentaSOPA").empty();
                $("#div_McuentaSOPA").css("visibility", "hidden");
                strOtroSOPA = "N";
                $("#txt_CuentaSOPA").val("");
                $("#lbl_SujetoObligadoPA").text("");
                $("#lblCorreoSOPA").text("");
                $("#slc_Depcia").empty();
                listItem = $('<option id =' + "seleccione" + '></option>').val(0).html('[Seleccione]');
                listItem2 = $('<option id =' + "seleccione" + '></option>').val(0).html('[Seleccione]');
                $("#slc_Depcia").append(listItem);
                $("#slc_Puesto").empty();
                $("#slc_Puesto").append(listItem2);
                $("#txt_CuentaSOPA").prop("disabled", false);
                $("#slc_Motivo option[value=" + 0 + "]").attr("selected", true);
                $("#txt_Lugar").val("");
                $("#txt_dFSeparacion").val("");
                $("#txt_Observaciones").val("");
                $("#lblSujetObligado").text("");
                $("#txt_CuentaSO").val("");
                $("#txt_CuentaSO").attr("disabled", false);
                $("#lblCorreoSO").text("");
                $("#inp_cuenta2").val("");
                $("#inp_cuenta2").attr("disabled", false);
                $("#txt_EnlaceEP").val("");
                $("#txt_CorreoEP").val("");
                $("#inp_cuenta").val("");
                $("#inp_cuenta").attr("disabled", false);
                $("#txt_NombreSR").val("");
                $("#txt_CorreoSR").val("");
                $('input:radio[name=receptor]')[0].checked = true;

                //PintaDatosTitularPA(objTitularPA);
            }

            function EnterSOPA() {
                $('#txt_CuentaSOPA').keypress(function (event) {
                    if (event.keyCode == 13) {
                        //BuscarEOP();
                        BuscarSOPA();
                    }
                });
            }

            /* ---- Fin del conjunto de funciones para la sección de administrador ---- */


    </script>

    <form id="SSASOLPRO" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label id="titulo" class="titulo">Solicitud de Intervención en el Proceso de Entrega-Recepción</label>
            <div class="a_acciones">
                <a id="AccReporte" title="Reporte" href="javascript:ReporteSolicitud();" class="accAct">Reporte</a>
            </div>
        </div>
        <div id="divDatosSuperior">

        </div>

        <div id="titAdministrador" class="titSeccion" runat="server" style="display:none">
            <div id="Tit_Administrador" class="dActionA" onclick="fn_accordion('Administrador')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('Administrador')" id="d_lAdministrador" title="Expandir">Superior Jerárquico</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="Img6" onmouseover="MM_swapImage('Img6','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
        <div id="secAdministrador" class="conSeccion" style="display:none">
            <h2>Superior Jerárquico:</h2> <input id="txt_CuentaSOPA" type="text" name="cuenta" maxlength="25" size="20" runat="server"/>
            <a id="A3" class="accbuscar" title="Buscar" href="javascript:BuscarSOPA();"  onmouseover="MM_swapImage('Img7','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img7" alt="Icono de búsqueda de usuario" src="../images/buscar.png" /></a>
            <a id="A4" class="accelimpiar" title="Limpiar" href="javascript:LimpiaCamposSOPA();"  onmouseover="MM_swapImage('Img8','','../images/ico-deleteO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img8" alt="Icono para limpiar los campos" src="../images/ico-delete.png" /></a>
            <label id="lbl_SujetoObligadoPA"></label>
            <label id="lblCorreoSOPA"></label>
            <br />
            <label id="div_McuentaSOPA" class="requeridos"></label><br/>
            <%--<h2>Correo electrónico institucional:</h2> <label id="lblCorreoSOPA"></label><br/>--%>
        </div>
        <br />
                
        <div id="titDOS" class="titSeccion">
            <div id="Tit_DOS" class="dActionA" onclick="fn_accordion('DOS')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('DOS')" id="d_lDOS" title="Expandir">Proceso Datos Generales</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desB" onmouseover="MM_swapImage('im_desB','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secDOS" class="conSeccion" style="display: none">

            <h2>Folio:</h2> <label id="lbl_Folio"></label><br/>
            
            <h2>* Cargo/puesto o comisión que se entrega:</h2> 
            <select name="slc_Puesto" id="slc_Puesto" autofocus>
                <option value="0">[Seleccione] </option>
            </select>
            <div id="div_txtCargoPuesto" class="requeridos">* Campo requerido</div>


             
            <h2>* Entrega - recepción de la dependencia/entidad:</h2>
            <select name="slc_Depcia" id="slc_Depcia">
                <option value="0">[Seleccione] </option>
            </select>
            <div id="div_txtDepcia" class="requeridos">* Campo requerido</div>

            <div id="div_Motivos">
                <h2>* Motivos:</h2> <select name="slc_Motivo" id="slc_Motivo" style="width:600px"> </select>
                </div>
                <div id="div_condicionMot" class="requeridos">* Campo requerido</div>

            <h2>* Lugar:</h2>&nbsp;&nbsp;<input type="text" id ="txt_Lugar" name="codigo" maxlength="50" size="50" /> 
            <h2>* Fecha de la separación:</h2>&nbsp;&nbsp;<input type="text" id="txt_dFSeparacion" size="30"/>
            <br />
<%--            <h2>Lugar:</h2> <input type="text" id ="txt_Lugar" name="codigo" maxlength="50" size="50" />--%>
            <div id="div_txtLugar" class="requeridoA">* Campo requerido</div> 
            <div id="div_txtdFSeparacion" class="requeridoD">* Campo requerido</div> 
            <br />
<%--            <h2>Fecha de la separación:</h2> <input type="text" id="txt_dFSeparacion" size="30"/>--%>

        
            <h2>Observaciones:</h2>
            <br />
            <div class="align_TextareaS">         
                <textarea id="txt_Observaciones" onkeypress="return flimita(event, 200);" onkeyup="fActualizaInfo(200)" rows="5" cols="160"></textarea>
                <div id="info">Máximo de 200 caracteres</div>
            </div>
       </div>
       <br />

        <div id="titTRES" class="titSeccion">
            <div id="Tit_TRES" class="dActionA" onclick="fn_accordion('TRES')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('TRES')" id="d_lTRES" title="Expandir">Datos Sujeto Obligado</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desC" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secTRES" class="conSeccion" style="display: none">

            <h2>Sujeto obligado (Titular Saliente):</h2> <label id="lblSujetObligado"></label><input id="txt_CuentaSO" type="text" name="cuenta" maxlength="25" size="35"/>
            <a id="A1" class="accbuscar" title="Buscar" href="javascript:BuscarSO();"  onmouseover="MM_swapImage('Img4','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img4" alt="Icono de búsqueda de usuario" src="../images/buscar.png" /></a>
            <a id="A2" class="accelimpiar" title="Limpiar" href="javascript:LimpiaCamposSO();"  onmouseover="MM_swapImage('Img5','','../images/ico-deleteO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img5" alt="Icono para limpiar los campos" src="../images/ico-delete.png" /></a> 
            <br />
            <label id="div_McuentaSO" class="requeridos"></label><br/>
            <h2 style="color:gray">En caso de ser otra persona el sujeto obligado, indicar la cuenta institucional que es aquella que está antes del arroba @</h2><br />
            <h2>Correo electrónico institucional:</h2> <label id="lblCorreoSO"></label><br/>
            <!-- Enlace Operativo Principal --> <!-- SE OCULTA POR SOLICITUD -->
            <!--<h2>Cuenta institucional (Enlace Principal):</h2> 
            <input id="inp_cuenta2" type="text" name="cuenta" maxlength="25" size="50"/>
            <a id="hrf_bus2" class="accbuscar" title="Buscar" href="javascript:Buscar2();"  onmouseover="MM_swapImage('Img1','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img1" alt="Icono de búsqueda de usuario" src="../images/buscar.png" /></a>
            <a id="hrf_elim2" class="accelimpiar" title="Limpiar" href="javascript:Limpia2();"  onmouseover="MM_swapImage('Img2','','../images/ico-deleteO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img2" alt="Icono para limpiar los campos" src="../images/ico-delete.png" /></a>
            <br />
            <label id="div_McuentaEOP" class="requeridos"></label>
            <label id="div_McuentaEOP2" class="requeridos"></label>
            <br />
            <%--<div id="div_McuentaEOP" class="requeridos">* Campo requerido</div>
            <div id="div_McuentaEOP2" class="requeridos"></div>--%>
            <h2>Enlace Operativo Principal:</h2> <input type="text" id ="txt_EnlaceEP" name="codigo" maxlength="50" size="50" />
            <br />
            <%--<h2>Correo electrónico institucional:</h2><label id="lbl_CorreoEO"></label>--%>
            <%--<div id="div_EnlaceEP" class="requeridog">* Campo requerido</div>--%>

            <h2>Correo electrónico institucional:</h2> <input type="text" id ="txt_CorreoEP" name="codigo" maxlength="50" size="50" />
            <%--<div id="div_CorreoEP" class="requeridog">* Campo requerido</div>--%>
            -->
       
        </div>
        <br />
 
           
        <div id="titCUATRO" class="titSeccion">
            <div id="Tit_CUATRO" class="dActionA" onclick="fn_accordion('CUATRO')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('CUATRO')" id="d_lCUATRO" title="Expandir">Datos Sujeto receptor</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="Img3" onmouseover="MM_swapImage('Img3','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

         <div id="secCUATRO" class="conSeccion" style="display: none">
                <h2>Sujeto Receptor:</h2>  
                <label for = "rbt_empleado"><input type="radio" name="receptor"  id="rbt_empleado" value="Empleado"/>Empleado</label>
                <label for="rbt_externo"><input type="radio" name="receptor"  id="rbt_externo" value="Externo"/>Externo</label><br/>                   

                <div id="div_BuscarCuenta">
                    <h2>* Cuenta institucional (Sujeto Receptor):</h2> 
                    <input id="inp_cuenta" type="text" name="cuenta" maxlength="25" size="50" />
                    <%--<a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:Buscar();"  onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" /></a>--%>
                    <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:Buscar();"  onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="ico_busqueda" alt="Icono de búsqueda de usuario" src="../images/buscar.png" /></a>
                    <a id="hrf_elim" class="accelimpiar" title="Limpiar" href="javascript:Limpia();"  onmouseover="MM_swapImage('ico_eliminar','','../images/ico-deleteO.png',1)" onmouseout="MM_swapImgRestore()"><img id="ico_eliminar" alt="Icono para limpiar los campos" src="../images/ico-delete.png" /></a>
                    <h2 style="color:gray">La cuenta institucional es aquella que está antes del arroba @</h2>
                    <div id="div_Mcuenta" class="requeridos">* Campo requerido</div>
                    <div id="div_Mcuenta2" class="requeridos"></div>
               </div>

                <div id="div_BloqueNombreSR">
                <h2>* Sujeto receptor (Titular entrante):</h2>
                            <input type="text" id ="txt_NombreSR" name="codigo" maxlength="50" size="50" />
                    <div id="div_NombreSR" class="requeridos">* Campo requerido</div>
                </div>
   
        
                <div id="div_BloqueCorreoSR">
                <h2> Correo electrónico institucional:</h2>  
                        <input type="text" id ="txt_CorreoSR" name="codigo" maxlength="50" size="50" />
                        <div id="div_CorreoSR" class="requeridos">* Campo requerido</div>
                </div>
        </div>
        <br />
                <div id="div_Fundamento">
                <h2>Fundamento:</h2>
                <div>
                Con base en el artículo 21 del Reglamento y en la Guía para el Proceso
                Entrega - Recepción por cambio de Titular, ambos de la Universidad Veracruzana, en mi calidad 
                de <b>Superior Jerárquico</b> solicitó la intervención de la Contraloría General
                en el proceso de entrega - recepción de todos los recursos, información, documentos y asuntos relacionados
                con el cargo, empleo o comisión que se cita.
                </div> 

                </div>
         
        <div class="a_botones">
            <a id="btn_Regresar" title="Regresar" href="javascript:fRegresarSolicitudes();" class="btnAct" style="visibility: hidden;">Regresar</a>
            <a id="btn_Enviar" title="Botón Enviar" href="javascript:fValida();" class="btnAct">Enviar</a>
        </div>
        <div id="a_abajo"></div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_esAdministrador" runat="server" />
            <asp:HiddenField ID="hf_esSupJerarquico" runat="server" />
        </div>
    </div>
    </form>


</body>
</html>
