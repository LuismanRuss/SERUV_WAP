<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAGUIAERH" Codebehind="SAAGUIAERH.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
<script type="text/javascript">

    //Variables globales
    var intIDGuia;
    var chrIndVigencia;
    var bln_Bandera;
    var intCodigo = 0;

    var strAccion = "";
    //Pasa valores del calendario a español
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

    $(document).ready(function () {
        NG.setNact(2, 'Dos', null);

        //Asignar a mi input el componente datepicker jQuery
        //$('#txt_dFVigente').datepicker(vDate);
        jQuery('#txt_dFVigente').datepicker(vDate);

        //        $('textarea').keypress(function (event) {
        //            if (event.keyCode == 13) {
        //                event.preventDefault();
        //            }
        //        });

        //Funciones para Validar los Input
        fValidaInput_Codigo();
        fValidaInput_Descripcion();


        if (NG.Var[NG.Nact - 1].datoSel != null) {
            //NG.Var[NG.Nact - 1].datoSel.strAccion = "MODIFICAR";
            $('#txt_Titulo').text("Modificar guía");

            strAccion = "ACTUALIZAR"

            chrIndVigencia = NG.Var[NG.Nact - 1].datoSel.chrIndVigente;
            intIDGuia = NG.Var[NG.Nact - 1].datoSel.idGuiaER;

            //Asigno valores
            pAsignarValores();

            //Verifico la vigencia de la Guía seleccionada
            fVerificarVigencia();
        }

        else {
            strAccion = "INSERTAR"
            fVerificarEstados();
            //alert($("#hf_idUsuario").val());
        }
    });

    //Función que asigna los valores a la forma, cuando se modifica una guía
    function pAsignarValores() {

        $('#txt_Codigo').val(NG.Var[NG.Nact - 1].datoSel.strGuiaER);
        $('#txt_Descripcion').val(NG.Var[NG.Nact - 1].datoSel.strDGuiaER);
        $('#txt_Observaciones').val(NG.Var[NG.Nact - 1].datoSel.strDCGuiaER);
        if (NG.Var[NG.Nact - 1].datoSel.dteFVigente == "FECHA NO DEFINIDA") {
            $('#txt_dFVigente').val("");
        }
        else {
            $('#txt_dFVigente').val(NG.Var[NG.Nact - 1].datoSel.dteFVigente);
        }
    }

    //Función Ajax que Verifica la Vigencia de la Guía en la Base de Datos
    function fVerificarVigencia() {

        var strDatos = "{'idGuiaER': '" + intIDGuia +
                             "'}";

        objGuia = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objGuia: objGuia });
        //console.log(actionData);

        $.ajax(
                {
                    url: "Guia/SAAGUIAERH.aspx/Guias_Vigentes",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(reponse);
                        if (reponse.d) {

                            $('#slcComboVigencia option[value=V]').attr('selected', true);
                            //                            $('#theOptions option[value=VIGENTE]').attr('selected', true);
                            bln_Bandera = true;


                        }
                        else {
                            bln_Bandera = false;
                            //$('#slcComboVigencia option[value=V]').attr('selected', false);
                            $("#slcComboVigencia option[value='V']").attr('disabled', 'disabled');

                            //$('#theOptions option[value=VIGENTE]').attr('selected', false);
                            //$("#theOptions option[value='VIGENTE']").attr('disabled', 'disabled');
                        }
                        //Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    //beforeSend: alert("beforeSend"),
                    complete: loading.close(),
                    error: errorAjax
                });
    }

    //Función Ajax que Verifica el Estado de la Guía en la Base de Datos
    function fVerificarEstados() {
        var actionData = "{}";
        $.ajax(
            {
                url: "Guia/SAAGUIAERH.aspx/Guias_Activas",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    //console.log(reponse);
                    if (reponse.d) {
                        $("#slcComboVigencia option[value='V']").attr('disabled', 'disabled')
                    }
                    else {

                    }
                    //Pinta_Grid(eval('(' + reponse.d + ')'));
                },
                //beforeSend: alert("beforeSend"),
                complete: loading.close(),
                error: errorAjax
            });
    }

    //Función Ajax que Inserta o Actualiza una Guía en la Base de Datos
    function pGuardar_Guia() {
        
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

        //alert(text);

        var chrComboVigencia = $("#slcComboVigencia").val();
        var charIndVigencia;
        //alert(chrComboVigencia);
        if (chrComboVigencia == "V")
        { charIndVigencia = "S" }
        if (chrComboVigencia == "NV")
        { charIndVigencia = "N" }

        if (strAccion == "INSERTAR") {

            //var IndVigente = 'N';
            /*
            var valordeCombo = $('#theOptions>option:selected').text();  //Obtener el valor del combo
            if (valordeCombo == "Activo") 
            {
            valordeCombo = "S";
            }
            else { valordeCombo = "N"; }
            */

            var strDatos = "{'strGuiaER': '" + strCodigo +
            //var strDatos = "{'strGuiaER': '" + $('#txt_Codigo').val() +
                            "','intUsuario': '" + $('#hf_idUsuario').val() +
                            "','strDGuiaER': '" + strDescripcion +
//                            "','strDGuiaER': '" + $('#txt_Descripcion').val() +
                            "','strAccion': '" + strAccion +
                            "','chrIndVigente': '" + charIndVigencia +
            //"','strDCGuiaER': '" + $('#txt_Observaciones').val() +
                            "','strDCGuiaER': '" + strObservaciones +
                            "','dteFVigente': '" + ($('#txt_dFVigente').val() != '' ? $('#txt_dFVigente').val() : '') +
                            "'}";

            objGuia = eval('(' + strDatos + ')');
            //console.log(objGuia);

            actionData = frms.jsonTOstring({ objGuia: objGuia });

            $.ajax(
            {
                url: "Guia/SAAGUIAERH.aspx/Actualizar_Guia",
                //url: "AltaGuiasER.aspx/Actualizar_Guia",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {


                    switch (reponse.d) {
                        case 1:
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert('La guía se ha agregado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                fRegresar();
                            });
                            break;
                        case 2:
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ya existe una guía vigente, ingrese de nuevo.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                fRegresar();
                            });
                            break;
                        case 0:
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
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
        } //FIN DE INSERTAR


        if (strAccion == "ACTUALIZAR") {


            if (bln_Bandera == true) {
                strAccion = "CAMBIAR_VIGENCIA2"
            }
            else {
                strAccion = "FECHA_VIGENCIA2"
            }


            var idGuiaActual = NG.Var[NG.Nact - 1].datoSel.idGuiaER;
            //console.log(idGuiaActual);

            var strDatos = "{'strGuiaER': '" + $('#txt_Codigo').val() +
                        "','idGuiaER': '" + idGuiaActual +
                        "','intUsuario': '" + $('#hf_idUsuario').val() +
                        "','strDGuiaER': '" + $('#txt_Descripcion').val() +
                        "','strAccion': '" + strAccion +
            //"','strDCGuiaER': '" + $('#txt_Observaciones').val() +
                        "','strDCGuiaER': '" + strObservaciones +
                        "','chrIndVigente': '" + charIndVigencia +
                        "','dteFVigente': '" + ($('#txt_dFVigente').val() != '' ? $('#txt_dFVigente').val() : '') +

                        "'}";

            objGuia = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objGuia: objGuia });

            $.ajax(
            {
                url: "Guia/SAAGUIAERH.aspx/Actualizar_Vigencia",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var cadena = eval('(' + reponse.d + ')');

                    switch (cadena.strRespuesta) {

                        case "1":
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("La guía se ha modificado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec] = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].repinta = "S";
                                fRegresar();
                            });
                            break;
                        case "2":
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("La guía ya esta actualizada, ingrese de nuevo.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                NG.Var[NG.Nact - 1].repinta = "N";
                                fRegresar();
                            });
                            break;
                        case "3":
                            loading.close();
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("No se puede cambiar la vigencia de la guía ya que tiene procesos activos configurados, únicamente se han actualizado los demás campos.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec] = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].repinta = "S";
                                fRegresar();
                                //fRegresar();
                            });
                            break;
                        case "4":
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("La guía se ha modificado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec] = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].repinta = "S";
                                fRegresar();
                                //fRegresar();
                            });
                            break;
                        case "5":
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                fRegresar();
                                //fRegresar();
                            });
                            break;
                    }

                },
                //beforeSend: alert("beforeSend"),
                //complete: loading.close(),
                error: function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });

        } //FIN DE ACTUALIZAR


    } // FIN FUNCION GUARDAR


    //Función para ir a la Forma Principal de Guía
    function fRegresar() {
        urls(3, "Guia/SAAGUIAER.aspx");
    }

    //Función para ir a la Forma Principal de Guía
    function fRegresar2() {
        NG.Var[NG.Nact - 1].repinta = "S";
        urls(3, "Guia/SAAGUIAER.aspx");
    }


    //Función para Validar todos los campos de la forma (Espacios en blanco y Codigos)
    function fValida() {

              
        if (jsTrim($("#txt_Codigo").val()) != "") {
            $("#div_txtCodigo").css("visibility", "hidden");
            fValidaCodigoAjax(strAccion);

            if (intCodigo == 2) {
                    $("#div_txtCodigo").css("visibility", "hidden");
                    if (jsTrim($("#txt_Descripcion").val()) != "") {
                        $("#div_txtDescripcion").css("visibility", "hidden");

                        if (isValidDate($("#txt_dFVigente").val()) == true || $("#txt_dFVigente").val() == "") {
                            $("#div_txtdVigente2").css("visibility", "hidden");
                            loading.ini();
                            pGuardar_Guia();

                        }
                        else {
                            //alert("Fecha Incorrecta");
                            $("#div_txtdVigente2").css("visibility", "visible");
                        }
                    }
                    else {
                        $("#div_txtDescripcion").css("visibility", "visible");
                        $("#txt_Descripcion").focus();

                    }
                }
                else {

                    $("#div_txtCodigo").empty().append("* La clave ya existe, favor de ingresar una diferente.");
                    $("#div_txtCodigo").css("visibility", "visible");
                    $("#txt_Codigo").focus();

                }
        }
        else {
            $("#div_txtCodigo").empty().append("* Campo requerido");
            $("#div_txtCodigo").css("visibility", "visible");
            $("#txt_Codigo").focus();
        }

        if (jsTrim($("#txt_Descripcion").val()) == "") {
            $("#div_txtDescripcion").css("visibility", "visible");

        }
        else {
            $("#div_txtDescripcion").css("visibility", "hidden");
        }

        if (isValidDate($("#txt_dFVigente").val()) == true || $("#txt_dFVigente").val() == "") {
            $("#div_txtdVigente2").css("visibility", "hidden");
        }
        else {
            $("#div_txtdVigente2").css("visibility", "visible");
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

    //Función para Validar el Campo de Fecha
    function isValidDate(subject) {
        //if (subject.match(/^(?:(0[1-9]|1[012])[\- \/.](0[1-9]|[12][0-9]|3[01])[\- \/.](19|20)[0-9]{2})$/)) {
        if (subject.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/)) {
            return true;
        } else {
            return false;
        }
    }

    //Función para Validar el Codigo de la Guía
    function fValidaCodigo(cadena, accion) {


        //var cadena = cadena.replace(/ /g, '');
        var cadena = cadena.toUpperCase();
        //console.log(cadena);
        //console.log(accion);

        if (accion == "INSERTAR") {
            for (a_i = 2; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena == NG.Var[NG.Nact - 1].datos[a_i].strGuiaER.toUpperCase()) {
                    return true;
                    break;
                }
            }
            return false
        }

        if (accion == "ACTUALIZAR") {

            for (a_i = 2; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena == NG.Var[NG.Nact - 1].datos[a_i].strGuiaER.toUpperCase()) {

                    if (cadena == NG.Var[NG.Nact - 1].datoSel.strGuiaER.toUpperCase()) {
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

    //Función Ajax para validar que el codigo de la guía no se repita en la BD
    function fValidaCodigoAjax(accion) {

        //Validacion para que los Input no acepten comillas, ni comillas dobles
        var strCodigo = $('#txt_Codigo').val();
        strCodigo = strCodigo.replace(/'/g, '');
        strCodigo = strCodigo.replace(/"/g, '');
        strCodigo = strCodigo.toUpperCase();

        var strDatos = "{'strGuiaER': '" + strCodigo + "'}";
        objGuia = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objGuia: objGuia });

        $.ajax(
                {
                    url: "Guia/SAAGUIAERH.aspx/Validar_Codigo",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {

                        switch (reponse.d) {
                            case 1:
                                if (accion == "INSERTAR") {
                                    intCodigo = 1;
                                }
                                if (accion == "ACTUALIZAR") {

                                    if (strCodigo == NG.Var[NG.Nact - 1].datoSel.strGuiaER.toUpperCase()) {
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
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                });
                                break;
                        }

                    },
                    //beforeSend: alert("beforeSend"),
                    complete: loading.close(),
                    error: errorAjax
                });
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

            //Función para Validar que el campo de Descripción no quede vacío
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


</script>

<form id="fr_altaGuiasER" runat="server">
    <div id="agp_contenido">      
        <div id="agp_navegacion">
            <label class="titulo" id="txt_Titulo">Alta guía </label>
        </div>        
     <h3>Clave:</h3> <input type="text" id ="txt_Codigo" name="codigo" maxlength="20" size="20" autofocus/>
        <div id="div_txtCodigo" class="requeridog">* Campo requerido</div>
        
        <h3>Nombre:</h3> <input type="text" id="txt_Descripcion" name="LastName" maxlength="50" size="60"/> <div id="div_txtDescripcion" class="requeridog">* Campo requerido</div>
                
<%--        <h3>Vigencia:</h3>
        <select name="vigencia" id="theOptions">
        <option id="NoVigente" value="NO VIGENTE" selected="DEFAULT">No vigente</option>
        <option id="Vigente" value="VIGENTE" selected="DEFAULT">Vigente</option>
        </select>

        <br />--%>

        <h3>Vigencia:</h3>
        <select id="slcComboVigencia">
        <option value="NV">No vigente</option>
        <option value="V">Vigente</option>
        </select><br/>
        

        <br/><div id="div_FechaVigente" >
        <h3>A partir de la fecha:</h3> <input type="text" id="txt_dFVigente" size="30"/> <div id="div_txtdVigente2" class="requeridog">* Formato de Fecha Incorrecto</div>
        </div>
   

        <h3>Observaciones:</h3>
        <div class="align_Textarea">         
            <textarea id="txt_Observaciones" onkeypress="return flimita(event, 200);" onkeyup="fActualizaInfo(200)" rows="5" cols="122"></textarea>
            <div id="info">Máximo de 200 caracteres</div>
        </div>
        <br/>

        <div class="a_botones">
            <a title="Botón Guardar" id="btnGuardar_Guia" href="javascript:fValida();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" id="btnCancelar_Guia" href="javascript:fRegresar2();" class="btnAct">Cancelar</a>        
        </div>

           <div id="div_ocultos">
              <asp:HiddenField ID="hf_idUsuario" runat="server" />
          </div>
    </div>
</form>
</body>
</html>
