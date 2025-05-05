<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAANEXOSH" Codebehind="SAAANEXOSH.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
<%--    <link href="../styles/Guia.css" rel="stylesheet" type="text/css" />
    <%--<script src="../scripts/jquery-1.8.3.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui-1.9.2.custom.min.js" type="text/javascript"></script>--%>

    <%--<script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>    --%>

</head>
<body>

<script type="text/javascript">

    //Variables Globales para Asignar los datos que serán enviados al servidor
    var intIdGuiaER; 
    var intIdApartadoER;
    var chrAplica;
    var intIdAnexo;
    //var nOrden;
    var strAccion2;
    var chrNotificacion = "";
    var intCodigo = 0;
    var intOrden = 0;
    var chrAplicaContraloria;
    var blnOrden = false;
    //var arrAplica = new Array();

    var strAccion = "";
    $(document).ready(function () {
        NG.setNact(4, 'Cuatro', null);

        //Asigno a mi etiqueta la descripción de la Guía Actual, y la Clave del Apartado a la parte superior de la forma
        $("#lbl_Guia").text(NG.Var[NG.Nact - 3].datoSel.strDGuiaER.toUpperCase());
        $("#lbl_Apartado").text(NG.Var[NG.Nact - 2].datoSel.strDescApartado.toUpperCase());
        $("#lbl_Clave").text(NG.Var[NG.Nact - 2].datoSel.strApartado.toUpperCase());
        chrAplica = NG.Var[NG.Nact - 2].datoSel.chrAplica;

        //Asigno el id de guía para verificar los códigos de anexos por guía.
        intIdGuiaER = NG.Var[NG.Nact - 2].datoSel.idGuiaER;

        //Asigno el indicador de ese apartado para ver si aplica o no a contraloría
        chrAplicaContraloria = NG.Var[NG.Nact - 2].datoSel.chrAplica;
        pContraloria(chrAplicaContraloria);

        //$("#txt_Orden").numeric({ decimal: false, negative: false });

        //Método para Validar el Número de Orden 
        fcheckValidInput();

        //Cargo los checkbox del catálogo APEAPLICA
        fGetAplica();

        //pNavy();

        //Función que copia el contenido del campo de Código al campo de Código Formato, si el radio de formato esta checado
        //Habilita el radio de formato, si hay datos en el campo de código, de lo contrario desactiva el radio de formato 
        $("#txt_Codigo").keyup(function (event) {

            var intCodigo = jsTrim($("#txt_Codigo").val());

            if ($('#rbt_formato').is(':checked')) {
                $("#txt_CodigoFormato").val($("#txt_Codigo").val());


            }

            if (intCodigo.length > 0) {
                //$("#rbt_formato").attr('checked', false);
                //$("#rbt_formato").attr('disabled', true);
                $("#rbt_formato").attr('disabled', false);
            }
            else {
                blnBandera1 = false;
                $("#rbt_formato").attr('disabled', true);
                $("#rbt_formato").attr('checked', false);
            }

        });

        //Funciones para Validar los Input de Código, Descripción y Orden
        fValidaInput_Codigo();
        fValidaInput_Descripcion();
        fValidaInput_Orden();

        if (NG.Var[NG.Nact - 1].datoSel != null) {
            strAccion = "ACTUALIZAR";
            strAccion2 = "ACTUALIZAR";
            //Asigno el id del Anexo Actual a una Variable
            intIdAnexo = NG.Var[NG.Nact - 1].datoSel.idAnexo;
            intIdApartadoER = NG.Var[NG.Nact - 2].datoSel.idApartado;
            //nOrden = NG.Var[NG.Nact - 2].datoSel.intnOrden;

            $('#txt_Titulo').text("Modificar anexos");

            //Verifico si el Acta Entrega Recepción ya esta Checado en algún Apartado
            pVerificaActa(strAccion2);

            //fGetAplica2(intIdAnexo);
            fGetAplica2(NG.Var[NG.Nact - 1].datoSel.idAnexo);
            pAsignarValores();

            pNavy(); //Función para el radio de Sistema y Url
            pFormatoActualiza();

        }

        else {
            strAccion = "INSERTAR"
            strAccion2 = "INSERTAR";
            $("#txt_CodigoFormato").prop('disabled', true);

            $('#txt_Titulo').text("Alta anexos");
            //Obtengo el Número de Orden del Apartado seleccionado
            intIdApartadoER = NG.Var[NG.Nact - 2].datoSel.idApartado;
            //nOrden = NG.Var[NG.Nact - 2].datoSel.intnOrden;

            pNavy(); //Función para el radio de Sistema y Url
            pFormatoInsertar();
            //Link(); //Función para el radio Formato

            //Verifico si el Acta Entrega Recepción ya esta Checado en algún Apartado
            pVerificaActa(strAccion2);

        }
    });

    //Función que oculta el Div que contienen los elementos del Acta de E-R, si el Apartado es de Sujeto Obligado
    function pContraloria(aplica) {
        if (aplica == "O") {
            $("#div_Acta_ER").hide();
        }   
    }

    //Función Ajax que Inserta o Actualiza un Anexo en la Base de Datos
    function Guardar() {
        //loading.close();

        //Variable donde se almacenan los objetos
        var strDatos;

        //Obtener valores de los Radio
        pPreguntarRadio();

        //Creo mi objeto de anexo - aplica
        pValidaCheck();

        //Validar que las cadenas no tengan comillas(""), Comilla simple('), BackSlash(\), Salto de Línea (\n)
        var strObservaciones3 = $('#div_txtObservaciones').val();
        var strObservaciones2 = strObservaciones3.replace(/\n\r?/g, ' ');
        var strObservaciones1 = strObservaciones2.replace(/'/g, '');
        var strObservaciones = strObservaciones1.replace(/"/g, '');

        var strDescripcion3 = $('#txt_Descripcion').val();
        var strDescripcion2 = strDescripcion3.replace(/\n\r?/g, ' ');
        var strDescripcion1 = strDescripcion2.replace(/'/g, '');
        var strDescripcion = strDescripcion1.replace(/"/g, '');

        var strCodigo3 = $('#txt_Codigo').val();
        var strCodigo2 = strCodigo3.replace(/\n\r?/g, ' ');
        var strCodigo1 = strCodigo2.replace(/'/g, '');
        var strCodigo = strCodigo1.replace(/"/g, '');

        var strCodigoFormato3 = $('#txt_CodigoFormato').val();
        var strCodigoFormato2 = strCodigoFormato3.replace(/'/g, '');
        var strCodigoFormato1 = strCodigoFormato2.replace(/'/g, '');
        var strCodigoFormato = strCodigoFormato1.replace(/"/g, '');

        //console.log(chrNotificacion);

        if (strAccion == "INSERTAR") {
            //strDatos = "{'strCveAnexo': '" + $('#txt_Codigo').val() +
            strDatos = "{'strCveAnexo': '" + strCodigo +
                            "','strgidFKFGuia': '" + $('#hf_gidGuia').val() +
                            "','strgidFKFFormato': '" + $('#hf_gidFormato').val() +
                            //"','strNOficial': '" + $('#txt_CodigoFormato').val() +
                            "','strNOficial': '" + strCodigoFormato +
                            //"','strDAnexo': '" + $('#txt_Descripcion').val() +
                            "','strDAnexo': '" + strDescripcion +
                            //"','strDCAnexo': '" + $('#div_txtObservaciones').val() +
                             "','strDCAnexo': '" + strObservaciones +
                             "','intnOrden': '" + $('#txt_Orden').val() +
                             "','chrAlcance': '" + chrRadioAplica +
                             "','chrTipo': '" + chrRadioTipo +
                             "','chrFuente': '" + chrRadioFuente +
                             "','intNumUsuario': '" + $('#hf_idUsuario').val() +
                             "','strAccion': '" + strAccion +
                             "','idApartado': '" + intIdApartadoER +
                             "','idGuiaER': '" + intIdGuiaER +
                             "','cIndActa': '" + chrRadioActa +
                             "','laAplica': " + frms.jsTOs(jsonObj) +
                            "}"; // jsonObj

            objAnexos = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objAnexos: objAnexos });
            //console.log(actionData);
            $.ajax(
                             {
                                 url: "Guia/SAAANEXOSH.aspx/Actualizar_Anexos4",
                                 data: actionData,
                                 dataType: "json",
                                 //async: false,
                                 type: "POST",
                                 contentType: "application/json; charset=utf-8",
                                 success: function (reponse) {

                                     switch (reponse.d) {

                                         case 1:
                                             loading.close();
                                             $.alerts.dialogClass = "correctoAlert";
                                             jAlert('El anexo se ha agregado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                             fRegresar();
                                             });
                                             break;
                                         case 0:
                                             loading.close();
                                             $.alerts.dialogClass = "errorAlert";
                                             jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //Los datos no se actualizaron.
                                             fRegresar();
                                             break;
                                     
                                     
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

            if (fValidaNotificacion() == true) {
                chrNotificacion = "S";
            }
            else {
                chrNotificacion = "N";
            }

            //console.log(chrNotificacion);

//            if (chrRadioFuente = "U") {
//                $('#hf_gidGuia').val('');
//                $('#hf_gidFormato').val('');
//            }

            //strDatos = "{'strCveAnexo': '" + $('#txt_Codigo').val() +
            strDatos = "{'strCveAnexo': '" + strCodigo +
                            "','strgidFKFGuia': '" + $('#hf_gidGuia').val() +
                            "','strgidFKFFormato': '" + $('#hf_gidFormato').val() +
                            //"','strNOficial': '" + $('#txt_CodigoFormato').val() +
                            "','strNOficial': '" + strCodigoFormato +
            //"','strDAnexo': '" + $('#txt_Descripcion').val() +
                            "','strDAnexo': '" + strDescripcion +
            //"','strDCAnexo': '" + $('#div_txtObservaciones').val() +
                             "','strDCAnexo': '" + strObservaciones +
                             "','intnOrden': '" + $('#txt_Orden').val() +
                             "','chrAlcance': '" + chrRadioAplica +
                             "','chrTipo': '" + chrRadioTipo +
                             "','chrFuente': '" + chrRadioFuente +
                             "','intNumUsuario': '" + $('#hf_idUsuario').val() +
                             "','strAccion': '" + strAccion +
                             "','idApartado': '" + intIdApartadoER +
                             "','idAnexo': '" + intIdAnexo +
                             "','chrNotificacion': '" + chrNotificacion +
                             "','cIndActa': '" + chrRadioActa +
                             "','laAplica': " + frms.jsTOs(jsonObj) +
                            "}"; // jsonObj


            objAnexos = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objAnexos: objAnexos });
            //console.log(actionData);
            //alert("4");
            $.ajax(
                    {
                        url: "Guia/SAAANEXOSH.aspx/Actualizar_Anexos2",
                        data: actionData,
                        dataType: "json",
                        //async: false,
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            var cadena = eval('(' + reponse.d + ')');
                            switch (cadena.strResp) {
                                case "1":
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert('El anexo se ha actualizado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                        NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec] = eval('(' + reponse.d + ')');
                                        NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                                        NG.Var[NG.Nact - 1].repinta = "S";
                                        fRegresar();
                                    });
                                    break;
                                case "2":
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("El Anexo ya esta actualizado, ingrese de nuevo.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
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

                            //console.log(reponse);
                            //Pinta_Grid(eval('(' + reponse.d + ')'));
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


    //Función que pinta los Checkbox del arreglo que obtiene a las dependencias que aplica el anexo
    function fValidaAPlica2(arreglo) {

        //console.log(arreglo);

        var cadena = "";
        var newStr = "";
        var bandera = false;

        for (a_i = 0; a_i < arreglo.d.length; a_i++) {
            $('input[type=checkbox]').each(function () {
                if ($(this).attr("id") == arreglo.d[a_i]) {
                    this.checked = true;
                    bandera = true;

                    cadena += $(this).attr("name") + ", ";
                    //console.log(cadena);
                }

            });


        }

        if (bandera == true) {
            //var total = "Los siguientes secciones: " + cadena + " tienen asignados proceso activos, y no se pueden desactivar ";
            newStr = cadena.substring(0, cadena.length - 2);
            var total = "Los siguientes secciones: " + newStr + " tienen asignados proceso activos, y no se pueden desactivar ";
            //alert(newStr);
            //alert(total);
        }

    }

    //Función que asigna los valores a la forma, cuando se modifica un Anexo
    function pAsignarValores() {
        $('#txt_Codigo').val(NG.Var[NG.Nact - 1].datoSel.strCveAnexo);
        $('#txt_Descripcion').val(NG.Var[NG.Nact - 1].datoSel.strDAnexo);
        $('#div_txtObservaciones').val(NG.Var[NG.Nact - 1].datoSel.strDCAnexo);
        $('#txt_CodigoFormato').val(NG.Var[NG.Nact - 1].datoSel.strNOficial);
        $('#txt_Formato').val(NG.Var[NG.Nact - 1].datoSel.strFormato);
        $('#txt_Instructivo').val(NG.Var[NG.Nact - 1].datoSel.strInstructivo);
        $('#txt_Orden').val(NG.Var[NG.Nact - 1].datoSel.intnOrden);

        if ($("#txt_Formato").val() != "") {
            $("#txt_Formato").prop('disabled', true);
        }
        else {
            $("#txt_Formato").prop('disabled', true);
        }

        if ($("#txt_Instructivo").val() != "") {
            $("#txt_Instructivo").prop('disabled', true);
        }
        else {
            $("#txt_Instructivo").prop('disabled', true);
        }

        var chrRadioActa = NG.Var[NG.Nact - 1].datoSel.cIndActa;

        if (chrRadioActa == 'N') {
            $("#rbt_ActaNo").attr("checked", "checked");
        }
        if (chrRadioActa == 'S') {
            $("#rbt_ActaSi").attr("checked", "checked");
        }


        var chrRadioAplica = NG.Var[NG.Nact - 1].datoSel.chrAlcance;

        //var radioAplicacion = $("input[name='aplicacion']:checked").val();

        if (chrRadioAplica == 'E') {
            $("#rbt_general").attr("checked", "checked");
        }
        if (chrRadioAplica == 'G') {
            $("#rbt_especifica").attr("checked", "checked");
        }


        var chrRadioTipo = NG.Var[NG.Nact - 1].datoSel.chrTipo;

        if (chrRadioTipo == 'P') {
            $("#rbt_publica").attr("checked", "checked");
        }
        if (chrRadioTipo == 'C') {
            $("#rbt_confidencial").attr("checked", "checked");
        }
        if (chrRadioTipo == 'R') {
            $("#rbt_reservada").attr("checked", "checked");
        }

        var chrRadioFuente = NG.Var[NG.Nact - 1].datoSel.chrFuente;

        if (chrRadioFuente == 'F') {
            $("#rbt_formato").attr("checked", "checked");
            $("#txt_CodigoFormato").prop('disabled', true);
        }
        if (chrRadioFuente == 'S') {
            $("#rbt_sistema").attr("checked", "checked");
        }
        if (chrRadioFuente == 'U') {
            $("#rbt_url").attr("checked", "checked");
            $('#txt_CodigoFormato').attr('size', 128);
            $('#A1').hide();
            $('#A2').hide();
            $("#txt_Formato").prop('disabled', true);
            $("#txt_Instructivo").prop('disabled', true);
        }

        if (chrRadioFuente == 'N') {
            $("#txt_CodigoFormato").prop('disabled', true);
        }

    }


    /***********     Función Ajax para Obtener los APEAPLICA     ***********/

    //Función AJAX que obtiene la lista de aplica de la Base de Datos
    function fGetAplica() {
        var strDatos = "{" + "\"strAccion\": \"APEAPLICA\" " + "}";

        objAplica = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objAplica: objAplica });
        //console.log(actionData);

        $.ajax(
                {
                    url: "Guia/SAAANEXOSH.aspx/pGetDatosAplica",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        fPintaAplicaCbx(eval('(' + reponse.d + ')'));
                        pValidaCheck(eval('(' + reponse.d + ')'));
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
    }

    /***********     Fin Función Ajax Obtener Aplica    ***********/


    //Crear mi Array donde se guardarán los ID
    //var arrAplica = new Array();

    //Función que pinta los Checkbox en la forma, asigna los ID correspondientes y los nombres de acuerdo a la cadena pasada como parametro
    function fPintaAplicaCbx(cadena) {

        listItem = '';

        for (a_i = 0; a_i < cadena.laAplica.length; a_i++) {
            //listItem += "<li><input type='checkbox' value='" + cadena[a_i].idPerfil + "' /><label>" + cadena[a_i].strsDCPerfil + "</label></li>";

            //listItem += "<li><input type='checkbox' id=" + cadena.laAplica[a_i].idAplica + " value='N' name='" + cadena.laAplica[a_i].strDAplica + "'/><label>" + cadena.laAplica[a_i].strDAplica + "</label></li>";
            listItem += "<li> <label for=" + cadena.laAplica[a_i].idAplica + "> <input type='checkbox' id=" + cadena.laAplica[a_i].idAplica + " value='N' name='" + cadena.laAplica[a_i].strDAplica + "'/><label>" + cadena.laAplica[a_i].strDAplica + "</label></label></li>";
            
            //arrAplica[a_i] = cadena.laAplica[a_i].idAplica;
            //console.log(listItem);
        }
        $("#ul_Aplica").append(listItem);
        //alert("Checks listos.");
        //if (NG.Var[NG.Nact - 1].datoSel != null) {
            //fLlenaPerfiles();
            //fClicCheck();
        //}
    }

    /***********     Función Ajax Obtener el Anexo Aplica     ***********/

    //Función que obtiene la lista de Anexo Aplica de la Base de Datos
    function fGetAplica2(intIdAnexo) {
        //var strDatos = "{" + "\"strAccion\": \"APEAPLICA\" " + "}";
        var strDatos = "{" +
                         "\"strAccion\": \"ANEXAPLICA\" " + ",\"idAnexo\": " + intIdAnexo +
                                "}";

        objAplica = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objAplica: objAplica });
        //console.log(actionData);

        $.ajax(
                {
                    url: "Guia/SAAANEXOSH.aspx/pGetDatosAplica2",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {

                        var cadena = (eval('(' + reponse.d + ')'));
                        if (cadena.laAplica != null) {
                            fCheckAplica(eval('(' + reponse.d + ')'));
                            //fCheckAplica2(eval('(' + reponse.d + ')'));
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
    }

    /***********     Fin Función Ajax Obtener Anexo Aplica   ***********/

    //Función que activa los Checkbox del arreglo que obtiene a las dependencias que aplican al anexo
    function fCheckAplica(cadena) {
        for (a_i = 0; a_i < cadena.laAplica.length; a_i++) {
            $('input[type=checkbox]').each(function () {
                if ($(this).attr("id") == cadena.laAplica[a_i].idAplica) {
                    this.checked = true;
                }
            });
        }
    }

    //Función para hacer que todos los radio button se marquen y se desmarquen
    $(function () {
        var allRadios = $('input[type=radio]')
        var radioChecked;

        var setCurrent =
                    function (e) {
                        var obj = e.target;

                        radioChecked = $(obj).attr('checked');
                    }

        var setCheck =
                function (e) {

                    if (e.type == 'keypress' && e.charCode != 32) {
                        return false;
                    }

                    var obj = e.target;

                    if (radioChecked) {
                        $(obj).attr('checked', false);
                    } else {
                        $(obj).attr('checked', true);
                    }
                }

        $.each(allRadios, function (i, val) {
            var label = $('label[for=' + $(this).attr("id") + ']');

            $(this).bind('mousedown keydown', function (e) {
                setCurrent(e);
            });

            label.bind('mousedown keydown', function (e) {
                e.target = $('#' + $(this).attr("for"));
                setCurrent(e);
            });

            $(this).bind('click', function (e) {
                setCheck(e);
            });

        });
    });

    //Variables Globales de los Radio;
    var chrRadioAplica, chrRadioTipo, chrRadioFuente, chrRadioActa;


    //Función que obtiene el valor de todos los radio button
    function pPreguntarRadio() {

        if ($("input[name='aplicacion']:checked").val() !== undefined) {

            chrRadioAplica = $("input[name='aplicacion']:checked").val();
            //alert(chrRadioAplica);
        }
        else {
            chrRadioAplica = "";
            //alert(chrRadioAplica);
        }


        if ($("input[name='tipo']:checked").val() !== undefined) {
            chrRadioTipo = $("input[name='tipo']:checked").val();
            //alert(chrRadioTipo);
        }
        else {
            chrRadioTipo = "";
            //alert(chrRadioTipo);
        }

        if ($("input[name='fuente']:checked").val() !== undefined) {
            chrRadioFuente = $("input[name='fuente']:checked").val();
            //alert(chrRadioFuente);
        }
        else {
            chrRadioFuente = "N";
            //alert(chrRadioFuente);
        }

        if ($("input[name='acta']:checked").val() !== undefined) {
            chrRadioActa = $("input[name='acta']:checked").val();
            //alert(chrRadioFuente);
        }
        else {
            chrRadioActa = "N";
            //alert(chrRadioFuente);
        }
    }

    //Función que manda a traer la ventana modal, para cargar un archivo o un instructivo
    function fCargarArchivo(op) {
        $("#hf_operacion").val(op);
        dTxt = '<div id="dComent" title="Carga archivo / instructivo">';
        dTxt += '<iframe id="SAKFORINS" src="Guia/SAKFORINS.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#SAAANEXOSH').append(dTxt);
        $("#dComent").dialog({
            autoOpen: true,
            height: 300,
            width: 500,
            modal: true,
            resizable: true
        });
    }

    //Función que asigna el nombre del Formato, traido del Hidden Field
    function AsignarFormatos() {
        $("#txt_Formato").val($("#hf_nomFormato").val());
        $("#txt_Formato").prop('disabled', true);
    }

    //Función que asigna el nombre del Instructivo, traido del Hidden Field
    function AsignarGuias() {
        $("#txt_Instructivo").val($("#hf_nomGuia").val());
        $("#txt_Instructivo").prop('disabled', true);
    }

    /*Función que se utiliza cuando se cierra el dialog*/
    function fCerrarDialog() {
        $('#dComent').dialog("close");
        $("#dComent").dialog("destroy");
        $("#dComent").remove();
    }

    //Función para regresar a la forma principal de Anexos
    function fRegresar() {
        urls(3, "Guia/SAAANEXOS.aspx");
    }

    //Función para regresar a la forma principal de Anexos
    function fRegresar2() {
        NG.Var[NG.Nact - 1].repinta = "S";
        urls(3, "Guia/SAAANEXOS.aspx");
    }

    //Función que asigna a todos los checkbox checados el valor de "S", de lo contario se le asigna "N"
    function pAsignaCheck() {
        $('input[type=checkbox]').each(function () {
            if ($(this).is(":checked")) {
                $(this).val("S");
            }
            else
            { $(this).val("N"); }
        });

    }


    var jsonObj = []; //declare object

    //Creo una arreglo donde almaceno el nombre, id, y y valor de cada uno de los checkbox para enviarlo en formato json al Servidor
    function pValidaCheck() {
        //Asigno el Indicador de cada checkbox seleccionado

        pAsignaCheck(); //Método que toma el indicador de todos los checkbox

        jsonObj = [];

        $('input[type=checkbox]').each(function () {
            if (($(this).val()) != undefined) {
                jsonObj.push({ idAplica: $(this).attr("id"), strDAplica: $(this).attr("name"), chrIndActivo: $(this).attr("value") });
            }
        });

        //console.log(jsonObj);
    }

    //Función que Valida los radio button de la parte de Tipo de Fuente
    //Si el Código Formato ya tiene datos, y chequean un radio que necesite captura de datos, la función validara que el campo es requerido
    function fValidaFuente() {
        var valida = false;

        if ($("input[name='fuente']:checked").val() == undefined && $("#txt_CodigoFormato").val() == "") {
            $("#div_Formato").css("visibility", "hidden");
            valida = true;
        }
        else { valida = false }

        if ($("input[name='fuente']:checked").val() != undefined) {
            if ($("#txt_CodigoFormato").val() != "") {
                valida = true;
            }
            else {
                valida = false;
            }
        }

        return valida;
    }

    //Función para Validar todos los campos de la forma (Espacios en blanco, Código, Orden y Radios)
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

                          //if (fValidaOrden($("#txt_Orden").val(), strAccion) == false) {
                          fValidaOrdenAjax(strAccion);
                          if (intOrden == 2) {
                              blnOrden = true;
                              $("#div_txtOrden").css("visibility", "hidden");

                            if (fValidaFuente() == true) {
                                $("#div_Formato").css("visibility", "hidden");

                                if ($("input[name='aplicacion']:checked").val() !== undefined) {
                                    $("#div_Aplicacion").css("visibility", "hidden");

                                    if ($("input[name='tipo']:checked").val() !== undefined) {
                                        $("#div_Tipo").css("visibility", "hidden");
                                            loading.ini();
                                            Guardar();
                                    }

                                    else {
                                        $("#div_Tipo").css("visibility", "visible");
                                    }

                                }
                                else {
                                    $("#div_Aplicacion").css("visibility", "visible");
                                }
                            }
                            else {
                                $("#div_Formato").css("visibility", "visible");
                                $("#txt_CodigoFormato").focus();
                            }
                        }
                        else {
                            blnOrden = true;
                            //$("#div_txtOrden").empty().append("* El numero de orden ya existe, favor de ingresar uno diferente");
                            $("#div_txtOrden").empty().append("* El numero de orden ya existe, favor de ingresar uno diferente");
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
                    $("#div_txtOrden").empty().append("* El numero de orden ya existe, favor de ingresar uno diferente");
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

        if (fValidaFuente() == true) {
            $("#div_Formato").css("visibility", "hidden");
        }
        else {
            $("#div_Formato").css("visibility", "visible");
        }

        if ($("input[name='aplicacion']:checked").val() !== undefined) {
            $("#div_Aplicacion").css("visibility", "hidden");

        }
        else {
            $("#div_Aplicacion").css("visibility", "visible");
        }

        if ($("input[name='tipo']:checked").val() !== undefined) {
            $("#div_Tipo").css("visibility", "hidden");

        }
        else {
            $("#div_Tipo").css("visibility", "visible");
        }

    }

    //Función para Validar Espacios en Blanco
    function jsTrim(sString) {
        return sString.replace(/^\s+|\s+$/g, "");
    }

    //Función que Valida el funcionamiento cuando checas un radio button de la parte de Tipo de Fuente: Formato, Sistema, URL
    var blnBandera1 = false;
    function pNavy() {

        //Banderas que controlan las acciones cuando un radiobutton es checado 
        //var blnBandera1 = false;
        var blnBandera2 = false;
        var blnBandera3 = false;
        var blnDatos = false;

        //Si el Anexo se va a modifcar, verifica que radio esta checado actualmente, y la bandera se pondra en verdadero
        if (strAccion2 == "ACTUALIZAR") {
            if ($('#rbt_formato').is(':checked')) {
                blnBandera1 = true;
                strAccion2 = "FORMATO";
            }
            if ($('#rbt_sistema').is(':checked')) {
                blnBandera2 = true;
                strAccion2 = "SISTEMA";
            }
            if ($('#rbt_url').is(':checked')) {
                blnBandera3 = true;
                strAccion2 = "URL";
            }
        }

        //Evento que se ejecuta cuando se le da click al radio de fuente
        $('input[name="fuente"]').click(function () {

            if ($(this).attr("id") == "rbt_formato") {

                var intCodigo = jsTrim($("#txt_Codigo").val());

                if (intCodigo.length > 0) {

                    blnDatos = true;
                }
                else {
                    blnDatos = false;

                }

                if (blnDatos == true) {

                    if (blnBandera1 == false) {

                        $("#txt_CodigoFormato").prop('disabled', true);
                        $("#txt_CodigoFormato").val($("#txt_Codigo").val());

                        if (strAccion2 == "FORMATO") {
                            $('#txt_Formato').val(NG.Var[NG.Nact - 1].datoSel.strFormato);
                            $('#txt_Instructivo').val(NG.Var[NG.Nact - 1].datoSel.strInstructivo);
                            $("#txt_Formato").prop('disabled', true);
                            $("#txt_Instructivo").prop('disabled', true);
                        }

                        if (strAccion == "ACTUALIZAR") {
                            $('#txt_Formato').val(NG.Var[NG.Nact - 1].datoSel.strFormato);
                            $('#txt_Instructivo').val(NG.Var[NG.Nact - 1].datoSel.strInstructivo);
                        }

                        $("#div_txtCodigo").css("visibility", "hidden");
                        $(this).attr('checked', true);
                        $('#A1').show();
                        $('#A2').show();
                        $('#txt_CodigoFormato').attr('size', 60);
                        blnBandera1 = true;
                        blnBandera2 = false;
                        blnBandera3 = false;
                        chrRadioFuente = "F";

                    }
                    else {
                        if (blnBandera1 == true) {

                            $(this).attr('checked', false);
                            blnBandera1 = false;
                            blnBandera2 = false;
                            blnBandera3 = false;
                            $("#txt_CodigoFormato").val('');
                            $("#txt_CodigoFormato").prop('disabled', true);
                        }
                    }
                }
                else {

                    $(this).attr('checked', false);
                    $("#txt_CodigoFormato").val('');
                    $("#txt_CodigoFormato").prop('disabled', true);
                    $('#A1').show();
                    $('#A2').show();
                    $("#div_txtCodigo").css("visibility", "visible");
                    blnBandera2 = false;
                    blnBandera3 = false;
                }


            }

            //Evento que se ejecuta cuando se le da click al radio de Sistema
            if ($(this).attr("id") == "rbt_sistema") {

                if (blnBandera2 == false) {
                    $("#txt_CodigoFormato").prop('disabled', false);
                    $(this).attr('checked', true);
                    $("#txt_CodigoFormato").val('');
                    if (strAccion2 == "SISTEMA") {
                        $('#txt_CodigoFormato').val(NG.Var[NG.Nact - 1].datoSel.strNOficial);
                    }
                    if (strAccion == "ACTUALIZAR") {
                        if (NG.Var[NG.Nact - 1].datoSel.strFormato != "") {
                            $('#txt_Formato').val(NG.Var[NG.Nact - 1].datoSel.strFormato);
                        }
                        if (NG.Var[NG.Nact - 1].datoSel.strInstructivo != "") {
                            $('#txt_Instructivo').val(NG.Var[NG.Nact - 1].datoSel.strInstructivo);
                        }
                    }

                    $('#A1').show();
                    $('#A2').show();
                    $('#txt_CodigoFormato').attr('size', 60);
                    chrRadioFuente = "S";
                    blnBandera2 = true;
                    blnBandera1 = false;
                    blnBandera3 = false;

                }
                else {
                    if (blnBandera2 == true) {
                        $("#txt_CodigoFormato").prop('disabled', true);
                        $(this).attr('checked', false);
                        $("#txt_CodigoFormato").val('');
                        blnBandera2 = false;
                        blnBandera1 = false;
                        blnBandera3 = false;
                        //$("#txt_CodigoFormato").val('');
                        if (strAccion2 == "SISTEMA") {
                            $("#txt_CodigoFormato").val('');
                            $('#txt_Formato').val(NG.Var[NG.Nact - 1].datoSel.strFormato);
                            $('#txt_Instructivo').val(NG.Var[NG.Nact - 1].datoSel.strInstructivo);
                            $("#txt_Formato").prop('disabled', true);
                            $("#txt_Instructivo").prop('disabled', true);
                        }

                    }
                }


            }

            //Evento que se ejecuta cuando se le da click al radio de Url
            if ($(this).attr("id") == "rbt_url") {

                if (blnBandera3 == false) {
                    $("#txt_CodigoFormato").prop('disabled', false);
                    $(this).attr('checked', true);
                    $('#hf_gidFormato').val('');
                    $('#hf_gidGuia').val('');
                    if (strAccion2 == "URL") {
                        $('#txt_CodigoFormato').val(NG.Var[NG.Nact - 1].datoSel.strNOficial);
                    }
                    else {
                        $("#txt_CodigoFormato").val('');
                        $("#txt_Formato").val('');
                        $("#txt_Instructivo").val('');
                        $('#hf_gidFormato').val('');
                        $('#hf_gidGuia').val('');
                    }
                    $("#txt_Formato").prop('disabled', true);
                    $("#txt_Instructivo").prop('disabled', true);
                    $('#A1').hide();
                    $('#A2').hide();
                    $('#txt_CodigoFormato').attr('size', 128);
                    chrRadioFuente = "U";
                    blnBandera3 = true;
                    blnBandera1 = false;
                    blnBandera2 = false;
                }
                else {
                    if (blnBandera3 == true) {
                        $("#txt_CodigoFormato").prop('disabled', true);
                        $(this).attr('checked', false);
                        blnBandera3 = false;
                        blnBandera1 = false;
                        blnBandera2 = false;
                        $("#txt_CodigoFormato").val('');
                        $("#txt_Formato").prop('disabled', true);
                        $("#txt_Instructivo").prop('disabled', true);
                        $('#A1').show();
                        $('#A2').show();
                        $('#txt_CodigoFormato').attr('size', 60);
                    }
                }
            }

        });

    }


    //Función para Limitar la longitud del campo de Observaciones
    function flimita(elEvento, maximoCaracteres) {
        var elemento = document.getElementById("div_txtObservaciones");

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
    function factualizaInfo(maximoCaracteres) {
        var elemento = document.getElementById("div_txtObservaciones");
        var info = document.getElementById("info");

        if (elemento.value.length >= maximoCaracteres) {
            info.innerHTML = "Máximo de " + maximoCaracteres + " caracteres";
        }
        else {
            info.innerHTML = "Quedan " + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
        }
    }

    //Función para Limitar la longitud del campo de Descripción
    function flimita2(elEvento, maximoCaracteres) {
        var elemento = document.getElementById("txt_Descripcion");

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

    //Función para Actualizar el contador del input de Descripcion
    function factualizaInfo2(maximoCaracteres) {
        var elemento = document.getElementById("txt_Descripcion");
        var info = document.getElementById("infocorto");

        if (elemento.value.length >= maximoCaracteres) {
            info.innerHTML = "Máximo de " + maximoCaracteres + " caracteres";
        }
        else {
            info.innerHTML = "Quedan " + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
        }
    }

    //Función para Validar el Código del Anexo
    function fValidaCodigo(cadena, accion) {


        //var cadena = cadena.replace(/ /g, '');
        var cadena2 = cadena.toUpperCase();

        if (accion == "INSERTAR") {
            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena2 == NG.Var[NG.Nact - 1].datos[a_i].strCveAnexo.toUpperCase()) {
                    return true;
                    break;
                }
            }
            return false
        }

        if (accion == "ACTUALIZAR") {

            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena2 == NG.Var[NG.Nact - 1].datos[a_i].strCveAnexo.toUpperCase()) {

                    if (cadena2 == NG.Var[NG.Nact - 1].datoSel.strCveAnexo.toUpperCase()) {
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

    //Función para Validar si se va a enviar la notificación
    //La notificación se envia cuando el tipo de fuente es cambiado en el anexo
    function fValidaNotificacion() {

        var bandera = false;

        var chrRadioFuente = NG.Var[NG.Nact - 1].datoSel.chrFuente;
        var radioFuenteCombo = $("input[name='fuente']:checked").val();
        var strCodigoSistema = NG.Var[NG.Nact - 1].datoSel.strNOficial;

        if (chrRadioFuente == radioFuenteCombo) {
            chrNotificacion = "N";
            bandera = false;
        }
        else {
            chrNotificacion = "S";
            bandera = true;
        }

        if (chrRadioFuente == 'S' && radioFuenteCombo == 'S') {
            if (jsTrim(strCodigoSistema) != jsTrim($('#txt_CodigoFormato').val())) {
                chrNotificacion = "S";
                bandera = true;
            }
            else {
                chrNotificacion = "N";
                bandera = false;
            }
        }


        if (bandera == false) {

            var Formato = NG.Var[NG.Nact - 1].datoSel.strFormato;
            var FormatoCombo = $('#txt_Formato').val();

            if (Formato == $('#txt_Formato').val()) {
                chrNotificacion = "N";
                bandera = false;
            }
            else {
                chrNotificacion = "S";
                bandera = true;
            }

        }

        if (bandera == false) {

            var Guia = NG.Var[NG.Nact - 1].datoSel.strInstructivo;
            var GuiaCombo = $('#txt_Instructivo').val();

            if (Guia == $('#txt_Instructivo').val()) {
                chrNotificacion = "N";
                bandera = false;
            }
            else {
                chrNotificacion = "S";
                bandera = true;
            }
        }



        return bandera;

    }

    //Función para Validar el Orden del Anexo
    function fValidaOrden(cadena, accion) {


        var cadena2 = cadena.replace(/ /g, '');

        if (accion == "INSERTAR") {
            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena2 == NG.Var[NG.Nact - 1].datos[a_i].intnOrden) {
                    return true;
                    break;
                }
            }
            return false
        }

        if (accion == "ACTUALIZAR") {

            for (a_i = 1; a_i < NG.Var[NG.Nact - 1].datos.length; a_i++) {
                if (cadena2 == NG.Var[NG.Nact - 1].datos[a_i].intnOrden) {

                    if (cadena2 == NG.Var[NG.Nact - 1].datoSel.intnOrden) {
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


    //Función que habilita el Radio de Formato, cuando el input de código tiene datos, sino tiene datos se deshabilita
    function pFormatoInsertar() {

        var intCodigo = jsTrim($("#txt_Codigo").val());

        if (intCodigo.length > 0) {
            $("#rbt_formato").attr('disabled', false);
        }
        else {
            //$("#rbt_formato").attr('checked', false);
            $("#rbt_formato").attr('disabled', true);
            
        }

    }

    //Función que habilita el Radio de Formato, cuando el input de código tiene datos, sino tiene datos se deshabilita
    function pFormatoActualiza() {

        var intCodigo = jsTrim($("#txt_Codigo").val());
        //var intCodigo = NG.Var[NG.Nact - 1].datoSel.strCveAnexo;

        //$('#txt_Codigo').val(NG.Var[NG.Nact - 1].datoSel.strCveAnexo);

        if (intCodigo.length > 0) {
            $("#rbt_formato").attr('disabled', false);
        }
        else {
            //$("#rbt_formato").attr('checked', false);
            $("#rbt_formato").attr('disabled', true);
        }

    }

    //Función para Validar que la Orden del Apartado solo permita Números, Barra espaciadora y Tecla de Retroceso
    function fcheckValidInput() {
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

    //Función Ajax para validar que el código del Anexo no se repita en la BD
    function fValidaCodigoAjax(accion) {

        var strCodigo = $('#txt_Codigo').val()
        strCodigo = strCodigo.replace(/'/g, '');
        strCodigo = strCodigo.replace(/"/g, '');
        strCodigo = strCodigo.toUpperCase();

        var strDatos = "{'strCveAnexo': '" + strCodigo +
                       "','strAccion': '" + "VERIFICA_CODIGO" +
                       "','idGuiaER': '" + intIdGuiaER +
                       "'}";

        objAnexos = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objAnexos: objAnexos });

        $.ajax(
                {
                    url: "Guia/SAAANEXOSH.aspx/Validar_Codigo",
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

                                    if (strCodigo == NG.Var[NG.Nact - 1].datoSel.strCveAnexo.toUpperCase()) {
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

    //Función Ajax para validar que el Orden del Anexo no se repita en la BD
    function fValidaOrdenAjax(accion) {

        var orden = $('#txt_Orden').val();

        strDatos = "{'strAccion': '" + "VERIFICA_ORDEN" +
                   "','intnOrden': '" + $('#txt_Orden').val() +
                   "','idGuiaER': '" + intIdGuiaER +
                   "','idApartado': '" + intIdApartadoER +
                           "'}";

        objAnexos = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objAnexos: objAnexos });

        $.ajax(
                {
                    url: "Guia/SAAANEXOSH.aspx/Validar_Codigo",
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

            //Función Ajax para verificar si el anexo actual tiene asignado el Acta de E-R
            //Si el Anexo tiene el acta, habilitar el control de radios de acta
            function pVerificaActa(accion) {
                var strDatos;

                if (accion == "INSERTAR") {

                    strDatos = "{'strAccion': '" + "VERIFICA_ACTA_INSERTAR" +
                               "','idGuiaER': '" + intIdGuiaER +
                               "'}";
                }

                if (accion == "ACTUALIZAR") {

                    strDatos = "{'strAccion': '" + "VERIFICA_ACTA_ACTUALIZAR" +
                           "','idGuiaER': '" + intIdGuiaER +
                           "','idAnexo': '" + intIdAnexo +
                           "'}";
                }
                objAnexos = eval('(' + strDatos + ')');
                actionData = frms.jsonTOstring({ objAnexos: objAnexos });
                $.ajax(
                {
                    url: "Guia/SAAANEXOSH.aspx/Verifica_Acta",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {

                        switch (reponse.d) {
                            case 1:
                                $("#rbt_ActaNo").prop("checked", true);
                                $('input[name="acta"]').attr('disabled', 'disabled');
                                break;

                            case 2:
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

            //Función para Validar que el campo de Código no quede vacío
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

            //Función para Validar que el campo de Orden no quede vacío
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

    <form id="SAAANEXOSH" runat="server">
        <div id="agp_contenido">      
            <div id="agp_navegacion"> 
                <label class="titulo" id="txt_Titulo"></label>
            </div>        
<%--            <div class="instrucciones">Seleccione un anexo para realizar la acción correspondiente.</div>--%>

            <h3>Guía:</h3> <label id="lbl_Guia"></label>
            <br />

            <h3>Apartado:</h3> <label id="lbl_Clave"></label><label id="lbl_Apartado"></label>
            <br />

            <h3>Código:</h3> <input type="text" id ="txt_Codigo" maxlength="20" name="codigo" size="20" autofocus/>            
            <div id="div_txtCodigo" class="requeridog">* Campo requerido</div>

          <h3>Nombre:</h3>
          <div class="align_Textarea">         
          <textarea id="txt_Descripcion" onkeypress="return flimita2(event, 200);" onkeyup="factualizaInfo2(200)" rows="5" cols="100"></textarea>
          <div id="infocorto">Máximo de 200 caracteres</div>
          </div>
          <div id="div_txtDescripcion" class="requeridog">* Campo requerido</div>
          <br/> 

            <h3>Orden:</h3> <input type="text" id="txt_Orden" name="Orden" maxlength="2" size="10"/> 
            <div id="div_txtOrden" class="requeridog">* Campo requerido</div>
             
            <h3>Observaciones:</h3>
            <div class="align_Textarea">         
            <textarea id="div_txtObservaciones" onkeypress="return flimita(event, 200);" onkeyup="factualizaInfo(200)" rows="5" cols="100"></textarea>
            <div id="info">Máximo de 200 caracteres</div>
            </div>
            <br/>

            <div id="div_Acta_ER">
            <h3>Acta de Entrega Recepción:</h3>
            <label for="rbt_ActaNo"><input type="radio" name="acta"  id="rbt_ActaNo" value="N"/>No</label>
            <label for="rbt_ActaSi"><input type="radio" name="acta"  id="rbt_ActaSi" value="S"/>Sí</label><br/>  
            <br/>
            </div>
             

            <h3>Tipo de Fuente:</h3>
            <label for="rbt_formato"><input type="radio" name="fuente" id="rbt_formato" value="F"/>Formato</label>
            <label for="rbt_sistema"><input type="radio" name="fuente" id="rbt_sistema" value="S"/>Sistema</label>
            <label for="rbt_url"><input type="radio" name="fuente" id="rbt_url" value="U"/>URL</label><br/>            
            <div id="div_Fuente" class="requeridog">* Campo requerido</div>
        
            <h3>Fuente:</h3> 
            <input type="text" id ="txt_CodigoFormato" name="codigo" size="60" maxlength="100"/>
            <br />
            <div id="div_Formato" class="requeridog">* Campo requerido</div>


            <h3>Adjuntar archivo:</h3> <input type="text" id ="txt_Formato" name="codigo" size="60"/>
            <a id="A1" class="accbuscar" title="Buscar" href="javascript: fCargarArchivo('FORMATO');"  onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
            <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>

            <h3>Adjuntar Instructivo:</h3> <input type="text" id ="txt_Instructivo" name="codigo" size="60"/>
            <a id="A2" class="accbuscar" title="Buscar" href="javascript:fCargarArchivo('INSTRUCTIVO');"  onmouseover="MM_swapImage('ico_busqueda2','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
            <img id="ico_busqueda2" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>


            <h3>Aplicación:</h3>
            <label for="rbt_general"><input type="radio" name="aplicacion"  id="rbt_general" value="E"/>General</label>
            <label for="rbt_especifica"><input type="radio" name="aplicacion"  id="rbt_especifica" value="G"/>Específica</label><br/>            
            <div id="div_Aplicacion" class="requeridog">* Campo requerido</div>

            <h3>Tipo de Información:</h3>
            <label for="rbt_publica"><input type="radio" name="tipo" id="rbt_publica" value="P"/>Pública</label>
            <label for="rbt_confidencial"><input type="radio" name="tipo" id="rbt_confidencial" value="C"/>Confidencial</label>
            <label for="rbt_reservada"><input type="radio" name="tipo" id="rbt_reservada" value="R"/>Reservada</label><br/>            
            <div id="div_Tipo" class="requeridog">* Campo requerido</div>
        
            <h3>Aplica a:</h3>
            <div class="align_Textarea">
                <ul id="ul_Aplica">
                </ul>
            </div>
            <br /><br />
            <div class="a_botones">
                <a title="Botón Guardar" id="btn_GuardarActivo" href="javascript:fValida();" class="btnAct">Guardar</a> 
                <a title="Botón Cancelar" id="btn_CancelarActivo" href="javascript:fRegresar2();" class="btnAct">Cancelar</a>        
            </div>


            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
                <asp:HiddenField ID="hf_operacion" runat="server" />
                <asp:HiddenField ID="hf_nomFormato" runat="server" />
                <asp:HiddenField ID="hf_nomGuia" runat="server" />
                <asp:HiddenField ID="hf_gidFormato" runat="server" value=""/>
                <asp:HiddenField ID="hf_gidGuia" runat="server" value=""/>
            </div>
        </div>
    </form>
</body>
</html>
