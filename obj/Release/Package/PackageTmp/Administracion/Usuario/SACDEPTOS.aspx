<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Usuario_SACDEPTOS" Codebehind="SACDEPTOS.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=8" />

        <link href="../Styles/Usuario.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script type="text/javascript">
        var objNuevoTitular = null;
        var blnConsulta = false; //Boleano para saber si la forma se llamó para consulta o no

        $(document).ready(function () {
            loading.ini();
            NG.setNact(3, "Tres", null);
            if (NG.Var[NG.Nact - 1].datoSel == null) {
                ObtieneDependencias();
                ObtienePuestos();
                ObtieneTipoPersonal();
                ObtieneCategoria();
                fConsultaPuestosEntregar();
            } else {
                $('.titulo').text("Modificar departamento");
                $("#hrf_Buscar").hide();
                blnConsulta = true;
                ObtienePuestos();
                ObtieneTipoPersonal();
                ObtieneCategoria();
                fConsultaPuestosEntregar();
                LlenaDatos();
            }
            loading.close();

            $("#txt_Cuenta").keyup(function (event) {
                if (event.keyCode == 13) {
                    Buscar();
                }
            });

        });       //Fin document.ready

        //Función que obtiene el listado de las dependencias
        function ObtieneDependencias() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fObtieneDependencias",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaDependencias(eval('(' + reponse.d + ')'));
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            })
        }

        // Función que llena el select con todas las dependencias
        function PintaDependencias(objJson) {
            listItem = '';
            for (a_i = 1; a_i < objJson.length; a_i++) {
                //listItem += "<option value=" + objJson[a_i].nDepcia + " >" + objJson[a_i].sDDepcia + " </option>";
                listItem += "<option value=" + objJson[a_i].nDepcia + " >" + objJson[a_i].sDDepcia + " </option>";
            }
            $("#slc_Dependencias").append(listItem);
        }

        //Función que obtiene el listado de puestos.
        function ObtienePuestos() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fObtienePuestos",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaPuestos(eval('(' + reponse.d + ')'));
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            })
        }

        // Función que llena el select con la lista de puestos
        function PintaPuestos(objJson) {
            listItem = '';
            for (a_i = 1; a_i < objJson.length; a_i++) {
                //listItem += "<option value=" + objJson[a_i].nPuesto + " >" + objJson[a_i].sDPuesto + " </option>";
                listItem = $('<option></option>').val(objJson[a_i].nPuesto).html(objJson[a_i].sDPuesto);
                $("#slc_Puestos").append(listItem);
            }
        }

        //Función que obtiene el listado de tipos de personal.
        function ObtieneTipoPersonal() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fObtieneTipoPersonal",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaTipoPersonal(eval('(' + reponse.d + ')'));
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            })
        }

        // Función que llena el select de tipos de personal
        function PintaTipoPersonal(objJson) {
            listItem = '';
            for (a_i = 0; a_i < objJson.length; a_i++) {
                listItem += "<option value=" + objJson[a_i].nTipoPers + " >" + objJson[a_i].sDTipoPers + " </option>";
            }
            $("#slc_TipoPersonal").append(listItem);
        }

        // Función que obtiene el listado de las categorías 
        function ObtieneCategoria() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fObtieneCategoria",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaCategoria(eval('(' + reponse.d + ')'));
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            })
        }

        // Función que llena el select de las cateogrias
        function PintaCategoria(objJson) {
            listItem = '';
            for (a_i = 0; a_i < objJson.length; a_i++) {
                listItem += "<option value=" + objJson[a_i].nCategoria + " >" + objJson[a_i].sDCategoria + " </option>";
            }
            $("#slc_Categoria").append(listItem);
        }

        // Función que devuelve los perfiles que tiene asignado un usuario.
        function fConsultaPuestosEntregar() {
            var actionData = "{}";
            $.ajax(
                {
                    url: "Usuario/SACDEPTOS.aspx/fMuestraPuestosEntregar",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        PintaPuestosEntregar(eval('(' + reponse.d + ')'));
                    },
                    //                    beforeSend: loading.ini(),
                    //                    complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                }
            );
        }

        // Función que pinta los checkbox con la descripcion de los perfiles.
        function PintaPuestosEntregar(cadena) {
            listItem = '';
            for (a_i = 0; a_i < cadena.length; a_i++) {
                //listItem += "<li><input type='checkbox' value='" + cadena[a_i].idPerfil + "' /><label>" + cadena[a_i].strsDCPerfil + "</label></li>";
                listItem += "<li><input type='radio' id=" + cadena[a_i].nPuesto + " name='Puestos' value='" + cadena[a_i].nPuesto + "'/><label>" + cadena[a_i].sDPuesto + "</label></li>";
            }
            $("#ul_Puestos").append(listItem);
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                fLlenaPuestos();
            }
        }

        function fLlenaPuestos() {
            $('input[type=radio]').each(function () {
                if ($(this).val() == NG.Var[NG.Nact - 1].datoSel.nPuesto) {
                    this.checked = true;
                    return false;
                }
            });

            $('input[type=radio]').attr("disabled", "disabled");
        }

        // Función que busca los datos del usuario, de acuerdo a la cuenta institucional ingresada
        function Buscar() {
            loading.ini();
            var strParametros = "{'sCuenta': '" + $("#txt_Cuenta").val() + "'}";
            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fBuscaUsuario",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loading.close();
                    if (reponse.d != null) {
                        var resp = reponse.d;
                        switch (resp) {
                            case "-1":
                                $.alerts.dialogClass = "incompletoAlert";
                                jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                LimpiaValores();
                                break
                            case "0":
                                $.alerts.dialogClass = "incompletoAlert";
                                jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                LimpiaValores();
                                $("#txt_Cuenta").focus().select();
                                break;
                            case "1":
                                if (resp.length > 0) {
                                    objNuevoTitular = eval('(' + reponse.d + ')');
                                    MuestraDatos(eval('(' + reponse.d + ')'));
                                } else {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                                break;
                            default:
                                if (resp.length > 0) {
                                    objNuevoTitular = eval('(' + reponse.d + ')');
                                    MuestraDatos(eval('(' + reponse.d + ')'));
                                } else {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                                break;
                        }
                    } else {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        LimpiaValores();
                    }
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            })
        }

        // Función que muestra los datos del nuevo titular.
        function MuestraDatos(datos) {
            var a_i = 0;
            $("#txt_NumPersonal").val(datos[a_i].intNumPersonal);
            $("#txt_Nombre").val(datos[a_i].strNombre + " " + datos[a_i].strApPaterno + " " + datos[a_i].strApMaterno);

            $("#slc_TipoPersonal option[value=" + datos[a_i].intTipPersonal + "]").attr('selected', true);
            $("#slc_Puestos option[value=" + datos[a_i].intPuesto + "]").attr('selected', true);
            $("#slc_Categoria option[value=" + datos[a_i].intCategoria + "]").attr('selected', true);
        }

        // Función que limpia los textbox y dropdownlist del nuevo titular
        function LimpiaValores() {
            $("#txt_NumPersonal").val("");
            $("#txt_Nombre").val("");
            $("#slc_TipoPersonal option[value= -1]").attr('selected', true);
            $("#slc_Puestos option[value= -1]").attr('selected', true);
            $("#slc_Categoria option[value= -1]").attr('selected', true);
        }

        function LlenaDatos() {
            $("#slc_Dependencias").attr("disabled", "disabled");
            $("#txt_Cuenta").attr("disabled", "disabled");
            //$("#slc_TipoPersonal").attr("disabled", "disabled");
            //$("#slc_Puestos").attr("disabled", "disabled");
            //$("#slc_Categoria").attr("disabled", "disabled");

            $('#slc_Dependencias').empty();
            var listItemDep = $('<option></option>').val(NG.Var[NG.Nact - 1].datoSel.nDepciaPadre).html(NG.Var[NG.Nact - 1].datoSel.sDDepciaPadre);
            $("#slc_Dependencias").append(listItemDep);

            $("#txt_DescripLarga").val(NG.Var[NG.Nact - 1].datoSel.sDDepcia);
            $("#txt_DescripCorta").val(NG.Var[NG.Nact - 1].datoSel.sDCDepcia);
            $("#txt_Cuenta").val(NG.Var[NG.Nact - 1].datoSel.objUsuario.strCuenta);
            $("#txt_NumPersonal").val(NG.Var[NG.Nact - 1].datoSel.objUsuario.intNumPersonal);
            $("#txt_Nombre").val(NG.Var[NG.Nact - 1].datoSel.objUsuario.strNombre);

            //$('#slc_TipoPersonal').empty();
            //$('#slc_Puestos').empty();
            //$('#slc_Categoria').empty();
            //$("#slc_TipoPersonal").append("<option value=" + NG.Var[NG.Nact - 1].datoSel.objUsuario.intTipPersonal + " >" + NG.Var[NG.Nact - 1].datoSel.objUsuario.strTipoPersonal + " </option>");
            //$("#slc_Puestos").append("<option value=" + NG.Var[NG.Nact - 1].datoSel.objUsuario.intPuesto + " >" + NG.Var[NG.Nact - 1].datoSel.objUsuario.strsDCPuesto + " </option>");
            //$("#slc_Categoria").append("<option value=" + NG.Var[NG.Nact - 1].datoSel.objUsuario.intCategoria + " >" + NG.Var[NG.Nact - 1].datoSel.objUsuario.strCategoria + " </option>");
            
            $("#slc_TipoPersonal option[value=" + NG.Var[NG.Nact - 1].datoSel.objUsuario.intTipPersonal + "]").attr('selected', true);
            $("#slc_Puestos option[value=" + NG.Var[NG.Nact - 1].datoSel.objUsuario.intPuesto + "]").attr('selected', true);
            $("#slc_Categoria option[value=" + NG.Var[NG.Nact - 1].datoSel.objUsuario.intCategoria + "]").attr('selected', true);
        }

        function Guardar() {
            if (!blnConsulta) {
                if (fValidaDatos()) {
                    GuardarDepartamento();
                }
            } else {
                if (ValidaDatosActualiza()) {
                    ActualizaDepartamento();
                }
            }
        }

        function fValidaDatos() {
            $("#txt_DescripLarga").val(jsTrim($("#txt_DescripLarga").val()));
            $("#txt_DescripCorta").val(jsTrim($("#txt_DescripCorta").val()));
            if ($("#slc_Dependencias option:selected").val() > 0) {
                if ($("#txt_DescripLarga").val().length > 0) {
                    if ($("#txt_NumPersonal").val().length > 0) {
                        if ($("#slc_TipoPersonal option:selected").val() > 0) {
                            if ($("#slc_Puestos option:selected").val() > 0) {
                                if ($("#slc_Categoria option:selected").val() > 0) {
                                    if (fValidaPuestoSeleccionado()) {
                                        return true;
                                    } else {
                                        $.alerts.dialogClass = "incompletoAlert";
                                        jAlert("Seleccione un puesto.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    }
                                } else {
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("Seleccione categoría.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                            } else {
                                $.alerts.dialogClass = "incompletoAlert";
                                jAlert("Seleccione puesto de responsable.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            }
                        } else {
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("Selecciona tipo de personal.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        }
                    } else {
                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("Favor de buscar antes una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                    }
                } else {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("Indique el departamento.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                }
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Elija una dependencia.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
        }

        function fValidaPuestoSeleccionado() {
            var blnSeleccionado = false;
            $("input:radio").each(function () {
                if ($(this).is(":checked")) {
                    blnSeleccionado = true;
                    return false;
                }
            });
            return blnSeleccionado;
        }

        function GuardarDepartamento() {
            var intPuesto;
            $('input[type=radio]').each(function () {
                if ($(this).is(":checked")) {
                    intPuesto = $(this).val();
                    return false;
                }
            });

            objNuevoTitular[0].intCategoria = $("#slc_Categoria option:selected").val();
            objNuevoTitular[0].intPuesto = $("#slc_Puestos option:selected").val();
            objNuevoTitular[0].intTipPersonal = $("#slc_TipoPersonal option:selected").val();

            var strParametros = frms.jsonTOstring({ nDepciaPadre: $("#slc_Dependencias option:selected").val(),
                                                    sDescripLarga: $("#txt_DescripLarga").val(), 
                                                    sDescripCorta: $("#txt_DescripCorta").val(),
                                                    objNuevoTitular: objNuevoTitular[0],
                                                    nPuesto: intPuesto,
                                                    nUsuario: $("#hf_idUsuario").val()
            });

//            var strDatos = "{'nDepciaPadre': '" + $("#slc_Dependencias option:selected").val() +
//                        "','sDescripLarga': '" + $("#txt_DescripLarga").val() +
//                        "','sDescripCorta': '" + $("#txt_DescripCorta").val() +
//                        "','nTitular': '" + objNuevoTitular[0].idUsuario +
//                        "','nPuesto': '" + intPuesto +
//                        "','nUsuario': '" + $("#hf_idUsuario").val() +
//                        "'}";

            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fGuardaDepartamento",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    if (reponse.d != null) {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                break
                            case 1:
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("El departamento se han guardado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                fRegresar();
                                break;
                        }
                    }
                },
                //                    beforeSend: loading.ini(),
                //                    complete: loading.close(),
                error: //errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        function ActualizaDepartamento() {

            var strDatos = "{'nDepcia':'" + NG.Var[NG.Nact - 1].datoSel.nDepcia + 
                        "','sDescripLarga': '" + $("#txt_DescripLarga").val() +
                        "','sDescripCorta': '" + $("#txt_DescripCorta").val() +
                        "','nTipPersonal': '" + $("#slc_TipoPersonal option:selected").val() +
                        "','nPuesto': '" + $("#slc_Puestos option:selected").val() +
                        "','nCategoria': '" + $("#slc_Categoria option:selected").val() +
                        "','nUsuarioResp': '" + NG.Var[NG.Nact - 1].datoSel.objUsuario.idUsuario +
                        "','nUsuario': '" + $("#hf_idUsuario").val() +
                        "'}";

            $.ajax({
                url: "Usuario/SACDEPTOS.aspx/fActualizaDepartamento",
                data: strDatos,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    if (reponse.d != null) {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                break
                            case 1:
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Los datos del departamento se han guardado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                NG.Var[NG.Nact - 1].datoSel.sDDepcia = $("#txt_DescripLarga").val();
                                NG.Var[NG.Nact - 1].datoSel.sDCDepcia = $("#txt_DescripCorta").val();
                                NG.Var[NG.Nact - 1].datoSel.objUsuario.intTipPersonal = $("#slc_TipoPersonal option:selected").val();
                                NG.Var[NG.Nact - 1].datoSel.objUsuario.intPuesto = $("#slc_Puestos option:selected").val();
                                NG.Var[NG.Nact - 1].datoSel.objUsuario.intCategoria = $("#slc_Categoria option:selected").val();
                                fRegresar();
                                break;
                        }
                    }
                },
                //                    beforeSend: loading.ini(),
                //                    complete: loading.close(),
                error: //errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        function ValidaDatosActualiza() {
            var blnRespuesta = false;
            $("#txt_DescripLarga").val(jsTrim($("#txt_DescripLarga").val()));
            $("#txt_DescripCorta").val(jsTrim($("#txt_DescripCorta").val()));
            if ($("#txt_DescripLarga").val().length > 0) {
                if ($("#slc_TipoPersonal option:selected").val() > 0) {
                    if ($("#slc_Puestos option:selected").val() > 0) {
                        if ($("#slc_Categoria option:selected").val() > 0) {
                            blnRespuesta = true;
                        } else {
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("Seleccione categoría.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        }
                    } else {
                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("Seleccione puesto del responsable.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                    }
                } else {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("Seleccione tipo de personal.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                }
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Indique la descripción larga del departamento.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
            return blnRespuesta;
        }

        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        // Función que regresa al listado de departamentos
        function fRegresar() {
            urls(1, "Usuario/SAMDEPTOS.aspx");
        }
    </script>

    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Alta de Departamentos</label>
        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 

        <br />
        <h3>Dependencia: </h3>
        <select id="slc_Dependencias">
            <option value="-1">[Elija una dependencia / entidad]</option>
        </select>
        <br />
        <h3>Departamento: </h3>
        <br />
        <h3>Descripción larga:</h3>
        <input type="text" id="txt_DescripLarga" size="100" maxlength="100" />
        <br />
        <h3>Descripción corta:</h3>
        <input type="text" id="txt_DescripCorta" size="25" maxlength="20" />
        <br />

        <h3>Cuenta institucional:</h3>
        <label><input type="text" id="txt_Cuenta" maxlength="25" size="40" />
        <a id="hrf_Buscar" class="accbuscar" title="Buscar" href="javascript:Buscar();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
            <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
        </a></label>

        <br />

        <div id="agp_DatosUsuarios">
            <h3>Número de personal:</h3>
            <label><input id="txt_NumPersonal" type="text" size="30" disabled="disabled" /></label>
            <br />
            <h3>Nombre:</h3>
            <label><input id="txt_Nombre" type="text" size="70" disabled="disabled" /></label>
            <br />

            <h3>Tipo de personal: </h3>
            <select id="slc_TipoPersonal">
                <option value="-1">[Elija un tipo de personal]</option>
            </select>
            <br />
            <h3>Puesto: </h3>
            <select id="slc_Puestos">
                <option value="-1">[Elija un puesto]</option>
            </select>
            <br />
        
            <h3>Categoría: </h3>
            <select id="slc_Categoria">
                <option value="-1">[Elija una categoría]</option>
            </select>
            <br />
        </div>

        <h3>Puestos:</h3>
        <br />
        <div class="align_Textarea">
            <ul id="ul_Puestos">
                <%--<li><input type="checkbox" /><label>admin</label></li>--%>
            </ul>
        </div>
        <br />

        <div class="a_botones">
            <a title="Botón Guardar" href="javascript:Guardar();" class="btnAct">Guardar</a> 
            <%--<a title="Botón Cancelar" href="javascript:Cancelar();" class="btnAct">Cancelar</a> --%>       
        </div>

        <br />

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('Img1','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img1" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
