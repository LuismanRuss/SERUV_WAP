<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAAPARTAH" Codebehind="SAAAPARTAH.aspx.cs" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
<script type="text/javascript">
    var intIdGuiaER;
    var intIdApartadoER;
    var chrAplica;
    var intCodigo = 0;
    var intOrden = 0;
    var strClaveAnexo;
    var strNomAnexo;
    var blnOrden = false;

    var strAccion = "";
    $(document).ready(function () {
        NG.setNact(3, 'Tres', null);
        //console.log(NG);
        //console.log(NG.Var[NG.Nact - 2].datoSel);
        //Asigno a mi etiqueta la descripcion de la Guía Actual
        $("#lbl_Guia").text(NG.Var[NG.Nact - 2].datoSel.strDGuiaER.toUpperCase());
        //Asigno el id de la Guía Actual a una variable
        //$("#txt_Orden").mask("99");
        //$("#txt_Orden").numeric({ decimal: false, negative: false });
        fValidaInputOrden();

        //Funciones para Validar los Input
        fValidaInput_Codigo();
        fValidaInput_Descripcion();
        fValidaInput_Orden();


        if (NG.Var[NG.Nact - 1].datoSel != null) {
            $('#txt_Titulo').text("Modificar apartado");

            strAccion = "ACTUALIZAR"
            fAsignarValores();
            intIdGuiaER = NG.Var[NG.Nact - 2].datoSel.idGuiaER;
            //intIdGuiaER = NG.Var[NG.Nact - 2].datoSel.idGuiaER;
            intIdApartadoER = NG.Var[NG.Nact - 1].datoSel.idApartado;
            //intIdApartadoER = NG.Var[NG.Nact - 1].datoSel.idApartado;

            //fVerificaActa();
        }

        else {
            $('#txt_Titulo').text("Alta apartado");
            strAccion = "INSERTAR"
            intIdGuiaER = NG.Var[NG.Nact - 2].datoSel.idGuiaER;
            $('#rbt_noaplica').attr('checked', true);
        }
    });

    //Función que asigna los valores a la forma, cuando se modifica un Apartado
    function fAsignarValores() {

        $('#txt_Codigo').val(NG.Var[NG.Nact - 1].datoSel.strApartado);
        $('#txt_Descripcion').val(NG.Var[NG.Nact - 1].datoSel.strDescApartado);
        $('#txt_Orden').val(NG.Var[NG.Nact - 1].datoSel.intnOrden);
        var cbxResultado = NG.Var[NG.Nact - 1].datoSel.chrAplica;
        //if (cbxResultado == 'O') { $("#cbxAplica").removeAttr("checked"); }
        if (cbxResultado == 'O') { $("#rbt_noaplica").attr("checked", "checked"); }
        if (cbxResultado == 'C') { $("#rbt_aplica").attr("checked", "checked"); }
        $('#txt_Observaciones').val(NG.Var[NG.Nact - 1].datoSel.strDescCortApartado);
    }

    //Función Ajax que Inserta o Actualiza un Apartado en la Base de Datos
    function pGuardar() {

        //Validacion para que los Input no acepten comillas, ni comillas dobles
        var strCodigo3 = $('#txt_Codigo').val();
        var strCodigo2 = strCodigo3.replace(/\n\r?/g, ' ');
        var strCodigo1 = strCodigo2.replace(/'/g, '');
        var strCodigo = strCodigo1.replace(/"/g, '');

        var strDescripcion3 = $('#txt_Descripcion').val();
        var strDescripcion2 = strDescripcion3.replace(/\n\r?/g, ' ');
        var strDescripcion1 = strDescripcion2.replace(/'/g, '');
        var strDescripcion = strDescripcion1.replace(/"/g, '');

        var strObservaciones3 = $('#txt_Observaciones').val();
        var strObservaciones2 = strObservaciones3.replace(/\n\r?/g, ' ');
        var strObservaciones1 = strObservaciones2.replace(/'/g, '');
        var strObservaciones = strObservaciones1.replace(/"/g, '');

        //Comprobar si mi checkbox esta seleccionado
        if ($("#rbt_aplica").is(":checked")) {
            chrAplica = "C";
        }
        else {
            chrAplica = "O";
        }


        //alert("guarda");
        var strDatos;
        if (strAccion == "INSERTAR") {


                            strDatos = "{'strApartado': '" + strCodigo +
                            //strDatos = "{'strApartado': '" + $('#txt_Codigo').val() +
                            "','idGuiaER': '" + intIdGuiaER +
                             "','strDescApartado': '" + strDescripcion +
                             //"','strDescApartado': '" + $('#txt_Descripcion').val() +
                             "','strAccion': '" + strAccion +
                             "','chrAplica': '" + chrAplica +
                             //"','strDescCortApartado': '" + $('#txt_Observaciones').val() +
                             "','strDescCortApartado': '" + strObservaciones +
                             "','intnOrden': '" + $('#txt_Orden').val() +
                             "','intNumUsuario': '" + $('#hf_idUsuario').val() +

                             "'}";

            objApartados = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objApartados: objApartados });
            //console.log(actionData);
            $.ajax(
                             {
                                 url: "Guia/SAAAPARTAH.aspx/Actualizar_Apartados",
                                 data: actionData,
                                 dataType: "json",
                                 type: "POST",
                                 contentType: "application/json; charset=utf-8",
                                 success: function (reponse) {

                                     if (reponse.d) {
                                         loading.close();
                                         $.alerts.dialogClass = "correctoAlert";
                                         jAlert('El apartado se ha agregado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                             fRegresar();
                                         });
                                     }
                                     else {
                                         loading.close();
                                         $.alerts.dialogClass = "errorAlert";
                                         jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () { //Los datos no se actualizaron.
                                             fRegresar();
                                         });
                                     }
                                     //console.log(reponse);
                                 },
                                 //beforeSend: alert("beforeSend"),
                                 //complete: loading.close(),
                                 error: function (result) {
                                     loading.close();
                                     $.alerts.dialogClass = "errorAlert";
                                     jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                 }
                             });

        } //FIN DE INSERTAR


        if (strAccion == "ACTUALIZAR") {

            strDatos = "{'strApartado': '" + $('#txt_Codigo').val() +
                            "','idGuiaER': '" + intIdGuiaER +
                            "','idApartado': '" + intIdApartadoER +
                             "','strDescApartado': '" + $('#txt_Descripcion').val() +
                             "','strAccion': '" + strAccion +
                             "','chrAplica': '" + chrAplica +
                             //"','strDescCortApartado': '" + $('#txt_Observaciones').val() +
                             "','strDescCortApartado': '" + strObservaciones +
                             "','intnOrden': '" + $('#txt_Orden').val() +
                             "','intNumUsuario': '" + $('#hf_idUsuario').val() +
                             "'}";

            objApartados = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objApartados: objApartados });
            //console.log(actionData);

            $.ajax(
                    {
                        url: "Guia/SAAAPARTAH.aspx/Actualizar_Apartados",
                        //url: "AltaGuiasER.aspx/Actualizar_Guia",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            var cadena = eval('(' + reponse.d + ')');

                            switch (cadena.strResp) {
                                case "1":
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert('El apartado se ha actualizado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                    NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec] = eval('(' + reponse.d + ')');
                                    NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                                    NG.Var[NG.Nact - 1].repinta = "S";
                                    fRegresar();
                                    });
                                    break;
                                case "2":
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("El Apartado ya esta actualizado, ingrese de nuevo.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        NG.Var[NG.Nact - 1].repinta = "N";
                                        fRegresar();
                                    });
                                    break;
                                case "0":
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        fRegresar();
                                    });

                                    break;
                            }

                        },
                        //beforeSend: alert("beforeSend"),
                        //complete: loading.close(),
                        error: function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });

        } //FIN DE ACTUALIZAR


    } // FIN FUNCION GUARDAR

    //Función para ir a la Forma Principal de Apartado
    function fRegresar() {
        urls(3, "Guia/SAAAPARTA.aspx");
    }

    //Función para ir a la Forma Principal de Apartado
    function fRegresar2() {
        NG.Var[NG.Nact - 1].repinta = "S";
        urls(3, "Guia/SAAAPARTA.aspx");
    }


    //Función para Validar todos los campos de la forma (Espacios en blanco y Codigos)
    function fValida() {

    if (jsTrim($("#txt_Codigo").val()) != "") {
        $("#div_txtCodigo").css("visibility", "hidden");

        //if (fValidaCodigo($("#txt_Codigo").val(), strAccion) == false) {
        fValidaCodigoAjax(strAccion);
        if (intCodigo == 2) {
                $("#div_txtCodigo").css("visibility", "hidden");

                    if (jsTrim($("#txt_Descripcion").val()) != "") {
                        $("#div_txtDescripcion").css("visibility", "hidden");

                        if (jsTrim($("#txt_Orden").val()) != "") {

                                $("#div_txtOrden").css("visibility", "hidden");

                                fValidaOrdenAjax(strAccion);
                                //if (fValidaOrden($("#txt_Orden").val(), strAccion) == false) {
                                if (intOrden == 2) {
                                    blnOrden = true;
                                        $("#div_txtOrden").css("visibility", "hidden");

                                        if (fActaApartados() == false) {

                                            loading.ini();
                                            //$("#div_txtOrden").css("visibility", "hidden");
                                            pGuardar();
                                        }
                                        else {

                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert("No se puede quitar la Integracion de Contraloria de este Apartado, \nel Anexo con <strong>Clave:</strong> " + "<em>" + strClaveAnexo + "</em>" + " y <strong>Nombre:</strong> " + "<em>" + strNomAnexo + "</em>" + " \ntiene configurado el Acta de Entrega-Recepción, Modifiquelo a NO, para poder quitarle la Integracion de Contraloria a este Apartado.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                            });
                                        }
                                    }
                                    else {
                                        //alert("* El numero de orden ya existe, favor de ingresar uno diferente");
                                        blnOrden = true;
                                        $("#div_txtOrden").empty().append("* El número de orden ya existe, favor de ingresar uno diferente");
                                        $("#div_txtOrden").css("visibility", "visible");
                                        $("#txt_Orden").focus();
                                    }
                            }
                                else {
                                    blnOrden = true;
                                    $("#div_txtOrden").empty().append("* Campo requerido");
                                    $("#div_txtOrden").css("visibility", "visible");
                                    $("#txt_Orden").focus();
                            }
                    }
                    else {
                        $("#div_txtDescripcion").css("visibility", "visible");
                        blnOrden = false;
                        $("#txt_Descripcion").focus();
                    }
            }
            else {
                $("#div_txtCodigo").empty().append("* La clave ya existe, favor de ingresar una diferente.");
                $("#div_txtCodigo").css("visibility", "visible");
                blnOrden = false;
                $("#txt_Codigo").focus();
            }
    }
    else {
        //$("#div_txtCodigo").css("visibility", "visible");
        $("#div_txtCodigo").empty().append("* Campo requerido");
        $("#div_txtCodigo").css("visibility", "visible");
        blnOrden = false;
        $("#txt_Codigo").focus();
    }

        if (jsTrim($("#txt_Descripcion").val()) != "") {
            $("#div_txtDescripcion").css("visibility", "hidden");
        }
        else {
            $("#div_txtDescripcion").css("visibility", "visible");
            //$("#txt_Descripcion").focus();
        }

        if (blnOrden == false) {

            if (jsTrim($("#txt_Orden").val()) != "") {
                $("#div_txtOrden").css("visibility", "hidden");

                //if (fValidaOrden($("#txt_Orden").val(), strAccion) == false) {
                fValidaOrdenAjax(strAccion);
                if (intOrden == 2) {
                    $("#div_txtOrden").css("visibility", "hidden");
                }
                else {
                    $("#div_txtOrden").empty().append("* El número de orden ya existe, favor de ingresar uno diferente");
                    $("#div_txtOrden").css("visibility", "visible");
                    //$("#txt_Orden").focus();
                }

            }
            else {
                $("#div_txtOrden").empty().append("* Campo requerido");
                $("#div_txtOrden").css("visibility", "visible");
                //$("#txt_Orden").focus();
            }
        }
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

    //Función para Validar el Codigo del Apartado
    function fValidaCodigo(cadena, accion) {


        //var cadena = cadena.replace(/ /g, '');
        var cadena = cadena.toUpperCase();
        //console.log(cadena);
        //console.log(accion);

        if (accion == "INSERTAR") {
            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena == NG.Var[NG.Nact - 1].datos[a_i].strApartado.toUpperCase()) {
                    return true;
                    break;
                }
            }
            return false
        }

        if (accion == "ACTUALIZAR") {

            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena == NG.Var[NG.Nact - 1].datos[a_i].strApartado.toUpperCase()) {

                    if (cadena == NG.Var[NG.Nact - 1].datoSel.strApartado.toUpperCase()) {
                        return false;
                        break;
                    }
                    else {
                        return true;

                        break;
                    }

                }
            }
            return false

        }

    }

    //Función para Validar el Orden de la Guía
    function fValidaOrden(cadena, accion) {


        var cadena = cadena.replace(/ /g, '');
        //cadena = cadena.toUpperCase();
        //console.log(cadena);
        //console.log(accion);

        if (accion == "INSERTAR") {
            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena == NG.Var[NG.Nact - 1].datos[a_i].intnOrden) {
                    return true;
                    break;
                }
            }
            return false
        }

        if (accion == "ACTUALIZAR") {

            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena == NG.Var[NG.Nact - 1].datos[a_i].intnOrden) {

                    if (cadena == NG.Var[NG.Nact - 1].datoSel.intnOrden) {
                        return false;
                        break;
                    }
                    else {
                        return true;

                        break;
                    }

                }
            }
            return false

        }

    }

    //Función para Validar que la Orden del Apartado solo permita Numeros, Barra espaciodora y Tecla de Retroceso
    function fValidaInputOrden() {
        $("#txt_Orden").keydown(function (event) {
            // Allow only delete, backspace,left arrow,right arrow, Tab and numbers
            if (!((event.keyCode == 46 ||
            event.keyCode == 8 ||
            event.keyCode == 37 ||
            event.keyCode == 39 ||
            event.keyCode == 9) ||
            $(this).val().length < 2 &&
            ((event.keyCode >= 48 && event.keyCode <= 57) ||
            (event.keyCode >= 96 && event.keyCode <= 105)))) {
                // Stop the event
                event.preventDefault();
                return false;
            }
        });
    }

    //Función Ajax para validar que el codigo del Apartado no se repita en la BD
    function fValidaCodigoAjax(accion) {

        var strCodigo = $('#txt_Codigo').val()
        strCodigo = strCodigo.replace(/'/g, '');
        strCodigo = strCodigo.replace(/"/g, '');
        strCodigo = strCodigo.toUpperCase();

        var strDatos = "{'strApartado': '" + strCodigo +
                       "','strAccion': '" + "VERIFICA_CODIGO" +
                       "','idGuiaER': '" + intIdGuiaER +
                       "'}";

        objApartados = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objApartados: objApartados });

        $.ajax(
                {
                    url: "Guia/SAAAPARTAH.aspx/Validar_Codigo",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {

                        switch (reponse.d) {
                            case 1:
                                if (accion == "INSERTAR") { intCodigo = 1; }

                                if (accion == "ACTUALIZAR") {

                                    if (strCodigo == NG.Var[NG.Nact - 1].datoSel.strApartado.toUpperCase()) {
                                        intCodigo = 2;
                                    }
                                    else {
                                        intCodigo = 1;
                                    }
                                }

                                break;

                            case 2:
                                intCodigo = 2;
                                break;

                            case 0:
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                });
                                break;
                        }

                    },
                    //beforeSend: alert("beforeSend"),
                    complete: loading.close(),
                    error: errorAjax
                });
            }

            //Función Ajax para validar que el codigo del Orden no se repita en la BD
            function fValidaOrdenAjax(accion) {

                var orden = $('#txt_Orden').val();

                strDatos = "{'strAccion': '" + "VERIFICA_ORDEN" +
                           "','intnOrden': '" + $('#txt_Orden').val() +
                           "','idGuiaER': '" + intIdGuiaER +
                           "'}";

                objApartados = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objApartados: objApartados });

                $.ajax(
                {
                    url: "Guia/SAAAPARTAH.aspx/Validar_Codigo",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {

                        switch (reponse.d) {
                            case 1:

                                if (accion == "INSERTAR") { intOrden = 1; }
                                
                                if (accion == "ACTUALIZAR") {

                                    if (orden == NG.Var[NG.Nact - 1].datoSel.intnOrden) {
                                        intOrden = 2;
                                    }
                                    else {
                                        intOrden = 1;
                                    }
                                }

                                break;

                            case 2:
                                intOrden = 2;
                                break;

                            case 0:
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                });
                                break;
                        }

                    },
                    //beforeSend: alert("beforeSend"),
                    complete: loading.close(),
                    error: errorAjax
                });
            }

            //Función Para Validar si el Apartado a actualizar tiene configurado el Acta de E-R
            function fActaApartados() {

                if (strAccion == "ACTUALIZAR") {

                    var chrAplica = NG.Var[NG.Nact - 1].datoSel.chrAplica;

                    if (chrAplica == "C" && $("#rbt_noaplica").is(":checked")) {

                        var intValor = fVerificaActa();
                        //console.log(intValor);

                        if (intValor == 1) {
                            return true
                        }
                        else if (intValor == 2) {
                            return false;
                        }

                    }
                    else {
                        return false
                    }
                } //Si la Accion no es ACTUALIZAr, se va a insertar mando la bandera a falso

                else {
                    return false;
                }

            }

            //Función Ajax para Verificar si el Apartado Actual tiene configurado el Acta
            function fVerificaActa() {
                
                var intResultado;

                strDatos = "{'strAccion': '" + "VERIFICA_ACTA" +
                           "','idApartado': '" + intIdApartadoER +
                           "'}";

                objApartados = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objApartados: objApartados });

                $.ajax(
                {
                    url: "Guia/SAAAPARTAH.aspx/Validar_Acta",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var cadena = eval('(' + reponse.d + ')');

                        //console.log(cadena);

                        switch (cadena.strResp) {

                            case "1":
                                //alert("Tiene el Acta");
                                intResultado = 1
                                strClaveAnexo =cadena.strCveAnexo;
                                strNomAnexo = cadena.strDAnexo;
                                break;

                            case "2":
                                //alert("No Tiene el Acta");
                                intResultado = 2
                                break;

                            case "0":
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                });
                                break;
                        }
                    },
                    //beforeSend: alert("beforeSend"),
                    complete: loading.close(),
                    error: errorAjax
                });

                return intResultado;
            }

            //Función para Validar Espacios en Blanco
            function jsTrim(sString) {
                return sString.replace(/^\s+|\s+$/g, "");
            }

            //Función para Validar que el campo de Codigo no quede vacio
            function fValidaInput_Codigo() {
                blnDatos = false;

                $("#txt_Codigo").keyup(function (event) {

                    var intCodigo = jsTrim($("#txt_Codigo").val());

                    if (intCodigo.length > 0) {
                        blnDatos = true;
                    }

                });


                $("#txt_Codigo").blur(function () {

                    if (blnDatos == true) {

                        var intCodigo = jsTrim($("#txt_Codigo").val());
                        if (intCodigo.length > 0) {
                            $("#div_txtCodigo").css("visibility", "hidden");
                        }
                        else {
                            $("#div_txtCodigo").empty().append("* Campo requerido");
                            $("#div_txtCodigo").css("visibility", "visible");
                        }
                    }
                });

            }

            //Función para Validar que el campo de Descripcion no quede vacio
            function fValidaInput_Descripcion() {
                blnDatos = false;

                $("#txt_Descripcion").keyup(function (event) {

                    var intDescripcion = jsTrim($("#txt_Descripcion").val());

                    if (intDescripcion.length > 0) {
                        blnDatos = true;
                    }
                });


                $("#txt_Descripcion").blur(function () {

                    if (blnDatos == true) {

                        var intDescripcion = jsTrim($("#txt_Descripcion").val());
                        if (intDescripcion.length > 0) {
                            $("#div_txtDescripcion").css("visibility", "hidden");
                        }
                        else {
                            $("#div_txtDescripcion").empty().append("* Campo requerido");
                            $("#div_txtDescripcion").css("visibility", "visible");
                        }
                    }
                });

            }

            //Función para Validar que el campo de Orden no quede vacio
            function fValidaInput_Orden() {
                blnDatos = false;

                $("#txt_Orden").keyup(function (event) {

                    var intOrden = jsTrim($("#txt_Orden").val());

                    if (intOrden.length > 0) {
                        blnDatos = true;
                    }
                });

                $("#txt_Orden").blur(function () {

                    if (blnDatos == true) {

                        var intOrden = jsTrim($("#txt_Orden").val());
                        if (intOrden.length > 0) {
                            $("#div_txtOrden").css("visibility", "hidden");
                        }
                        else {
                            $("#div_txtOrden").empty().append("* Campo requerido");
                            $("#div_txtOrden").css("visibility", "visible");
                        }
                    }
                });

            }

               
</script>

    <form id="frm_Usuarios" runat="server">
        <div id="agp_contenido">      
            <div id="agp_navegacion">
                <label id="txt_Titulo" class="titulo"></label>
            </div>
            
            <h3>Guía:</h3> <label id="lbl_Guia"></label>
            <br />        
    
            <h3>Código:</h3> <input type="text" id ="txt_Codigo" maxlength="20" name="codigo" size="20" autofocus /><br/>
            <div id="div_txtCodigo" class="requeridog">* Campo requerido</div>
        
            <h3>Nombre:</h3> <input type="text" id="txt_Descripcion" name="Descripcion" size="120" maxlength="200"/> 
            <div id="div_txtDescripcion" class="requeridog">* Campo requerido</div>

            <h3>Orden:</h3> <input type="text" id="txt_Orden" name="Orden" maxlength="2" size="10"/> 
            <div id="div_txtOrden" class="requeridog"></div>
<%--            <div id="div_txtOrden2" class="requeridog"></div>--%>

            <h3>Integración exclusiva de la Contraloría:</h3> 
            <%--<input type="checkbox" id="cbxAplica" name="contraloria" value="S"/>Si<br/>--%>
            <label><input type="radio" name="contraloria"  id="rbt_aplica" value="S"/>Si</label>
            <label><input type="radio" name="contraloria"  id="rbt_noaplica" value="N"/>No</label><br/>   
            
            <h3>Observaciones:</h3>
            <div class="align_Textarea">             
                <textarea id="txt_Observaciones" name="observaciones" onkeypress="return flimita(event, 100);" onkeyup="fActualizaInfo(100)" rows="5" cols="100"></textarea>
                <div id="info">Máximo de 100 caracteres</div>
            </div>
            <br/>
            <br />

            <div class="a_botones">
                <a title="Botón Guardar" id="btn_GuardarApartado" href="javascript:fValida();" class="btnAct">Guardar</a> 
                <a title="Botón Cancelar" id="btn_CancelarApartado" href="javascript:fRegresar2();" class="btnAct">Cancelar</a>        
            </div>

            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />                
            </div>

        </div>
    </form>

</body>
</html>
