<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Usuario_SACTITULA" Codebehind="SACTITULA.aspx.cs" %>

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
        var Sort_SACTITULA = new Array(2);
        Sort_SACTITULA[0] = [{ "bSortable": false }, null, null, null, null, null, null, null];
        Sort_SACTITULA[1] = [[2, "asc"]];

        var objTitular; // Objeto que guardará los datos del titular actual
        var objNuevoTitular; // Objeto que guardará los datos del nuevo titular

        // Document Ready
        $(document).ready(function () {
            loading.ini();
            NG.setNact(1, "Uno", null);
            ObtieneDependencias();
            ObtienePuestos();
            ObtieneTipoPersonal();
            ObtieneCategoria();
            CambiaSelect();
            CambiaSelectTitular();
            EnterCuenta();
            loading.close();
        });

        function botonesPro(){}

        //Función que obtiene el listado de las dependencias
        function ObtieneDependencias() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SACTITULA.aspx/fObtieneDependencias",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaSelect(eval('(' + reponse.d + ')'));
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
        function PintaSelect(objJson) {
            listItem = '';
            for (a_i = 0; a_i < objJson.length; a_i++) {
                //listItem += "<option value=" + objJson[a_i].nDepcia + " >" + objJson[a_i].sDDepcia + " </option>";
                listItem += "<option value=" + objJson[a_i].nDepcia + " >" + objJson[a_i].sDDepcia + " </option>";
            }
            $("#slc_Dependencias").append(listItem);
        }

        //Función que obtiene el listado de puestos.
        function ObtienePuestos() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SACTITULA.aspx/fObtienePuestos",
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
                url: "Usuario/SACTITULA.aspx/fObtieneTipoPersonal",
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
                url: "Usuario/SACTITULA.aspx/fObtieneCategoria",
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

        // Funcion que se ejecuta cuando cambia la opción seleccionada del select de dependencias.
        function CambiaSelect() {
            $("#slc_Dependencias").change(function () {
                if ($("#slc_Dependencias option:selected").val() > 0) {
                    if ($("#slc_Titular option:selected").val() != -1) {
                        ObtieneTitular();
                    }
                }
            });
        }

        // Funcion que se ejecuta cuando cambia la opción seleccionada del select de cargo (Administrador/Titular).
        function CambiaSelectTitular() {
            $("#slc_Titular").change(function () {
                if ($("#slc_Titular option:selected").val() != -1) {
                    if ($("#slc_Dependencias option:selected").val() > 0) {
                        ObtieneTitular();
                    }
                }
            });
        }

        // Función que se encarga de obtener la información del titular, de acuerdo a la dependencia y cargo seleccionados
        function ObtieneTitular() {
            loading.ini();
            var intDependencia = $("#slc_Dependencias option:selected").val();
            var strTitular = $("#slc_Titular option:selected").val();

            var strParametros = "{'nDependencia':'" + intDependencia +
                                "','sIndTitular':'" + strTitular +
                                "'}";
            $.ajax({
                url: "Usuario/SACTITULA.aspx/fObtieneTitular",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    objTitular = eval('(' + reponse.d + ')');
                    MuestraTitularAdmin(objTitular);
                    loading.close();
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

        // Función que muestra la información del usuario, de acuerdo a la cuenta institucional ingresada
        function MuestraTitularAdmin(objJson) {
            if (objJson.length > 0) {
                $("#txt_Titular").val(objJson[0].strNombre);
                $("#lbl_TipoPersonal").text(objJson[0].strTipoPersonal);
                $("#lbl_Puesto").text(objJson[0].strsDCPuesto);
                $("#lbl_Categoria").text(objJson[0].strCategoria);
            } else {
                if ($("#slc_Titular option:selected").val() == "A") {
                    $("#txt_Titular").val("SIN ADMINISTRADOR");
                    $("#lbl_TipoPersonal").text("");
                    $("#lbl_Puesto").text("");
                    $("#lbl_Categoria").text("");
                } else {
                    $("#txt_Titular").val("SIN TITULAR");
                    $("#lbl_TipoPersonal").text("");
                    $("#lbl_Puesto").text("");
                    $("#lbl_Categoria").text("");
                }
            }
        }

        // Función que se encarga de hacer las validaciones, antes de guardar la información
        function Guardar() {
            if ($("#slc_Dependencias option:selected").val() > 0) {
                if ($("#slc_Titular option:selected").val() != -1) {
                    if ($("#txt_NumPersonal").val().length > 0) {
                        if ($("#slc_TipoPersonal option:selected").val() > 0) {
                            if ($("#slc_Puestos option:selected").val() > 0) {
                                if ($("#slc_Categoria option:selected").val() > 0) {
                                    GuardarTitular();
                                } else {
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("Seleccione categoría.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                            } else {
                                $.alerts.dialogClass = "incompletoAlert";
                                jAlert("Seleccione puesto.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            }
                        } else {
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("Seleccione tipo de personal.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        }
                    } else {
                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("Favor de buscar antes una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                    }
                } else {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("Seleccione el cargo.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                }
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Seleccione la dependencia.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
        }

        // Función que guarda la información del nuevo titular para la dependencia seleccionada
        function GuardarTitular() {
            loading.ini();
            var intRespDepcia = 0;
            var intDepcia = $("#slc_Dependencias option:selected").val();
            var intPuesto = 0;
            var intIdTitular = 0;
            var intIdNuevoTitular = 0;
            var intUsuario = $("#hf_idUsuario").val();
            var chrIndTitular = $("#slc_Titular option:selected").val();
            var strDatosTitular;
            //objTitular[0].intNumDependencia = $("#slc_Dependencias option:selected").val();

            if (objTitular.length > 0) {
                objTitular[0].intNumDependencia = $("#slc_Dependencias option:selected").val();
                objNuevoTitular[0].intCategoria = $("#slc_Categoria option:selected").val();
                objNuevoTitular[0].intPuesto = $("#slc_Puestos option:selected").val();
                objNuevoTitular[0].intTipPersonal = $("#slc_TipoPersonal option:selected").val();
                intRespDepcia = objTitular[0].intRespDepcia;
                intPuesto = objTitular[0].intPuesto;
                intIdTitular = objTitular[0].idUsuario;
            } else {
                strDatosTitular = "{ 'intNumDependencia':'" + intDepcia +
                                    "','intPuesto':'" + intPuesto +
                                    "','intRespDepcia':'" + intRespDepcia +
                                    "','idUsuario':'" + intIdTitular +
                                    "'}";
                objTitular[0] = eval('(' + strDatosTitular + ')');
            }

            if (objNuevoTitular.length > 0) {
                intIdNuevoTitular = objNuevoTitular[0].idUsuario;
            }

            objTitular[0].strsDCPuesto = null;
            objTitular[0].strTipoPersonal = null;
            objTitular[0].strCategoria = null;

            objNuevoTitular[0].strsDCPuesto = null;

//            var strParametros = frms.jsonTOstring({ nDepcia: intDepcia, nPuesto: intPuesto, nRespDepcia: intRespDepcia, nIdTitular: intIdTitular,
//                nIdNuevoTitular: intIdNuevoTitular, nUsuario: intUsuario, sIndTitular: chrIndTitular, objNuevoTitular: objNuevoTitular[0], objTitular: objTitular[0]
            //            });
            var strParametros = frms.jsonTOstring({ objTitular: objTitular[0], objNuevoTitular: objNuevoTitular[0], sIndTitular: chrIndTitular,
                                                    nUsuario: intUsuario
                                                });

            $.ajax({
                url: "Usuario/SACTITULA.aspx/fGuardaTitular",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    switch (reponse.d) {
                        case 1:
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert('Acción realizada correctamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                fRegresar();
                            });
                            break;
                        case 0:
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            break;
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

        // Función que busca los datos del usuario, de acuerdo a la cuenta institucional ingresada
        function Buscar() {
            loading.ini();
            var strParametros = "{'sCuenta': '" + $("#txt_Cuenta").val() + "'}";
            $.ajax({
                url: "Usuario/SACTITULA.aspx/fBuscaUsuario",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    loading.close();
                    if (reponse.d != null) {
                        var objRespuesta = eval('(' + reponse.d + ')');
                        var resp = objRespuesta.Respuesta;
                        var strMensaje = (objRespuesta.msj == null ? "" : objRespuesta.msj);
                        switch (resp) {
                            case "-3":
                                $.alerts.dialogClass = "incompletoAlert";
                                if (strMensaje == "") {
                                    jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                } else {
                                    jAlert(strMensaje, "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                                LimpiaValores();
                                break
                            case "-2":
                                $.alerts.dialogClass = "incompletoAlert";
                                jAlert("No se pudo consultar el usuario. \n" + strMensaje, "SISTEMA DE ENTREGA - RECEPCIÓN"); // de oracle
                                LimpiaValores();
                                break
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
                                    objNuevoTitular = eval('(' + resp + ')');
                                    MuestraDatos(eval('(' + resp + ')'));
                                } else {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                                break;
                            default:
                                if (resp.length > 0) {
                                    objNuevoTitular = eval('(' + resp + ')');
                                    MuestraDatos(eval('(' + resp + ')'));
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

        // Función que se ejecuta cuando se detecta que presionan la tecla Enter en el campo de cuenta
        function EnterCuenta() {
            $("#txt_Cuenta").keyup(function (event) {
                if (event.keyCode == 13) {
                    Buscar();
                }
            });
        }

        function fReporte() {
            dTxt = '<div id="dComentR" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?op=TITULARES' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SACTITULA').append(dTxt);
            $("#dComentR").dialog({
                autoOpen: true,
                height: $(window).height() - 60,
                width: $("#agp_contenido").width() - 50, // $(window).width() - 250,
                modal: true,
                resizable: true,
                close: function (event, ui) {
                    $('#dComentR').dialog("close");
                    $("#dComentR").dialog("destroy");
                    $("#dComentR").remove();
                }
            });
        }

        function fprueba() {
            $('iframe#SRLREPORT').load(function () {

                var userAgent = navigator.userAgent.toLowerCase();
                var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
                var chrome = /chrome/.test(userAgent);
                var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);

                console.log(safari, chrome, mozilla);

                var iframe = document.getElementById("SRLREPORT");
                var input = iframe.contentWindow.document.getElementById("hf_idPerfil");
                var oPerfil = $('#SRLREPORT').contents().find('#hf_idPerfil');
                //                console.log(iframe);
                //                console.log(input);
                //                oPerfil.val("12345");
                //                console.log(oPerfil.val());
                //                if (!$(this).contents().find('#ReportViewer1').isLoading()) {
                //                    console.log("ya cargo");
                //                } else {
                //                    console.log("no ha cargado");
                //                }

                var oTxtPrueba = $(this).contents().find('#txt_Prueba');
                oTxtPrueba.change(function () {
                    console.log("cambio");
                });

                var oViewer = $(this).contents().find('#ReportViewer1');
                //$(this).contents().find('#txt_Tamaño').val(610);
                //                $(this).contents().find('#txt_tamaño2').val($(window).height() - 80);
                //                console.log($(this).css("Height"));
                //                var oDivReporte = $(this).contents().find('#div_Reporte');
                //                oDivReporte.css({ "height": "1000px" });
                //                console.log(oDivReporte.css("height"));
                //                oViewer.css({ "height": oDivReporte.css("height") });
                //                console.log(oViewer.css("height"));

                //console.log(oViewer.style);
                //oViewer.style.height = "2000px";
                //                $(this).contents().find('#ReportViewer1').css({ "height": "100px" });
                //                $(this).contents().find('#ReportViewer1').css({ "height": intHeight });
                //                console.log(oDivReporte.css("Height"));
                //                $(this).contents().find('#ReportViewer1').css({ "Width": "1000px" });
                //oViewer.css({ "width": "100px" });

            });
        }

        // Función que regresa al listado de usuarios
        function fRegresar() {
            urls(1, "Usuario/SAMUSUARI.aspx");
        }

    </script>

    <form id="SACTITULA" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Cambio de Titular</label>

            <div class="a_acciones">
                <a id="AccReporte" title="Reporte" href="javascript:fReporte();" class="accAct">Reporte</a>
            </div>
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
        <h3>Cargo</h3>
        <select id="slc_Titular">
            <option value="-1">[Elija una opción]</option>
            <option value="A">ADMINISTRADOR</option>
            <option value="T">TITULAR</option>
        </select>
        <br />
        <h3>Titular actual:</h3>
        <input type="text" id="txt_Titular" size="70" disabled="disabled" />
        <br />
        <h3>Tipo de personal:</h3>
        <label id="lbl_TipoPersonal"></label>
        <br />
        <h3>Puesto:</h3>
        <label id ="lbl_Puesto"></label>
        <br />
        <h3>Categoría:</h3>
        <label id="lbl_Categoria"></label>
        <br />
        <br />

        <h3>Cuenta institucional:</h3>
        <label><input type="text" id="txt_Cuenta" maxlength="25" size="40" />
        <a id="A1" class="accbuscar" title="Buscar" href="javascript:Buscar();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
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

<%--            <h3>Correo electrónico:</h3>
            <label><input id="txt_Correo" type="text" size="70" disabled="disabled" /></label>
            <br />--%>
<%--            <h3>Dependencia / entidad ó institución a la que pertenece:</h3>
            <label><input id="txt_Dependencia" type="text" size="70" disabled="disabled" /></label>
            <br />
            <h3>Puesto / cargo:</h3>
            <label><input id="txt_Puesto" type="text" size="70" disabled="disabled" /></label>--%>
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