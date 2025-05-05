<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_SACUSUARI" Codebehind="SACUSUARI.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />

    <link href="../Styles/Usuario.css" rel="stylesheet" type="text/css" />
     
</head>
<body>
    <script type="text/javascript">

        var strApMat; //Apellido materno
        var strApPat; //Apellido paterno
        var strJsonN; //Cadena con el JSON nuevo
        var strJsonC; //Candena con el JSON anterior
        var intUsuario; //ID del usuario
        var blnConsulta=false; //Boleano para saber si la forma se llamó para consulta o no 

        $(document).ready(function () {
            NG.setNact(2, 'Dos', null);
            //NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            loading.close();
            intUsuario = $("#hf_idUsuario").val()
            $(function () { $('[autofocus]').focus() });
            fConsultaPerfiles(); // Solamente a consultar los perfiles, aqui mismo los pintas como checks
            //Enter(event);
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                $('#titulo').text("Modificar usuario");
                blnConsulta = true;
                $("#A1").hide();
                //Perfiles();
                LlenaDatos(); // Asignas los datos del JSON
                //fLlenaPerfiles();
            }
            //            if (NG.Var[NG.Nact].oSets == null || acc_val == 'nue') {

            //            } else {
            //                NG.repinta();
            //            }
            
            // Función para ejecutar la busuqeda del usuario cuando se precione la tecla enter sobre el campo cuenta.
            $("#txt_Cuenta").keyup(function (event) {
                if (event.keyCode == 13) {
                    Buscar();
                }
            });

//            $("#txt_Cuenta").blur(function (event) {
//                Buscar();
//            });

        });

        // Función que llena los campos de la forma en caso que se haya seleccionado un usuario anteriormente.
        function LlenaDatos() {
            strJsonC = NG.Var[NG.Nact - 1].datoSel;
            $("#txt_Cuenta").attr("disabled", true);
            $("#txt_Cuenta").val(NG.Var[NG.Nact - 1].datoSel.strCuenta);
            $("#txt_NumPersonal").val(NG.Var[NG.Nact - 1].datoSel.intNumPersonal);
            $("#txt_Nombre").val(NG.Var[NG.Nact - 1].datoSel.strNombre);
            $("#txt_Correo").val(NG.Var[NG.Nact - 1].datoSel.strCorreo);
            $("#txt_Dependencia").val(NG.Var[NG.Nact - 1].datoSel.strsDCDepcia);
            $("#txt_Puesto").val(NG.Var[NG.Nact - 1].datoSel.strsDCPuesto);
            /*
            if (NG.Var[NG.Nact - 1].datoSel.chrIndEmpleado == 'N') {
                $("#txt_Dependencia").attr("disabled", false);
                $("#txt_Puesto").attr("disabled", false);
                //console("No es empleado");
            } else {
                //console.log("es empleado");
            }
            */
        }

        // Función que marca los checkbox de los perfiles que tenga asignados el usuario.
        function fLlenaPerfiles() {
            for(i=0; i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; i++){
                $('input[type=checkbox]').each(function () {
                    if (NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil == 2 || NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil == 10) {
                        if ($(this).attr("id") == NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil) {
                            this.checked = true;
                        }
                    }
                });
            }
        }

        // Función para agregar o quitar de la lista de perfiles el perfil que marcaron o desmarcaron.
        function fClicCheck() {
            $('input[type=checkbox]').click(function () {
                if ($(this).is(":checked")) {
                    var filtro = "{\"filtro\": [ {\"idPerfil\": \"\", \"strDPerfil\": \"\" } ] }";
                    var objFiltro = eval('(' + filtro + ')');
                    var strDato = " {\"idPerfil\": \"\", \"strDPerfil\": \"\" }";
                    objFiltro = eval('(' + strDato + ')');
                    objFiltro.idPerfil = $(this).attr("id");
                    objFiltro.strDPerfil = $(this).attr("value");
                    NG.Var[NG.Nact - 1].datoSel.lstPerfiles.push(objFiltro);
                    //                    for (i = 0; i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; i++) {
                    //                        console.log(NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil);
                    //                    }
                } else {
                    var intPos = 0;
                    var intId = $(this).attr("id");
                    for (a_i = 0; a_i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; a_i++) {
                        if ($(this).attr("id") == NG.Var[NG.Nact - 1].datoSel.lstPerfiles[a_i].idPerfil) {
                            intPos = a_i;
                        }
                    }
                    NG.Var[NG.Nact - 1].datoSel.lstPerfiles.splice(intPos, 1);
                    //for (i = 0; i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; i++) {
                        //console.log(NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil);
                    //}
                }
            });
        }

        // Función que devuelve los perfiles que tiene asignado un usuario.
        function fConsultaPerfiles() {
            var actionData = "{}";
            $.ajax(
                {
                    url: "Usuario/SACUSUARI.aspx/MuestraPerfilAdministrador",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        PintaPerfiles(eval('(' + reponse.d + ')'));
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
        function PintaPerfiles(cadena) {
            listItem = '';
            for (a_i = 1; a_i < cadena.length; a_i++) {
                //listItem += "<li><input type='checkbox' value='" + cadena[a_i].idPerfil + "' /><label>" + cadena[a_i].strsDCPerfil + "</label></li>";
                listItem += "<li><input type='checkbox' id=" + cadena[a_i].idPerfil + " name='Perfiles' value='" + cadena[a_i].strsDCPerfil + "'/><label>" + cadena[a_i].strsDCPerfil + "</label></li>";
            }
            $("#ul_Perfiles").append(listItem);
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                fLlenaPerfiles();
                fClicCheck();
            }
        }

        // Función que busca un usuario dada una cuenta. 
        function Buscar() {
            loading.ini();
            $("#txt_Cuenta").val(jsTrim($("#txt_Cuenta").val()));
            if ($("#txt_Cuenta").val().length > 0) {
                BuscaUsuarios();
            } else {
                loading.close();
                LimpiaCamposUsuario();
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Indique una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
        }

        // Función trim.
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        // Función que devuelve los datos del usuario en caso de encontrarlo.
        function BuscaUsuarios() {
            var strParametros = "{'sCuenta': '" + $("#txt_Cuenta").val() + "'}";
            $.ajax(
                {
                    url: "Usuario/SACUSUARI.aspx/BuscaUsuario",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loading.close();
                        if (reponse.d != null) {
                            var objRespuesta = eval('(' + reponse.d + ')');
                            var resp = objRespuesta.Respuesta;
                            var strMensaje = (objRespuesta.msj == null ? "": objRespuesta.msj);
                            switch (resp) {
                                case "-4":
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // No se logró conectar con la base de datos de Oracle.
                                    LimpiaCamposUsuario();
                                    break;
                                case "-3": //EL USUARIO NO ESTA EN LA BD DE ORACLE
                                    $.alerts.dialogClass = "incompletoAlert";
                                    if (strMensaje == "") {
                                        jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    } else {
                                        jAlert(strMensaje, "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    }
                                    
                                    LimpiaCamposUsuario();
                                    $("#txt_Cuenta").focus().select();
                                    break;
                                case "-2": //NO SE EJECUTO EL QUERY DE ORACLE
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("No se pudo consultar el usuario. \n" + strMensaje, "SISTEMA DE ENTREGA - RECEPCIÓN"); // de oracle
                                    LimpiaCamposUsuario();
                                    break;
                                case "-1": //NO SE EJECUTO EL QUERY DE SQL
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("No se pudo consultar el usuario.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    LimpiaCamposUsuario();
                                    break;
                                case "0": // EL USUARIO YA EXISTE
                                    $.alerts.dialogClass = "infoAlert";
                                    jAlert("El usuario ya está registrado en el sistema.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    LimpiaCamposUsuario();
                                    $("#txt_Cuenta").focus().select();
                                    break;
                                default: //EN OTRO CASO TRAE EL ID DEL USUARIO Y MUESTRA LOS DATOS 
                                    resp = jsTrim(resp);
                                    if (resp.length > 0) {
                                        MuestraDatosUsuario(eval('(' + resp + ')'));
                                        //MuestraDatosUsuario(resp);
                                    } else {
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                        LimpiaCamposUsuario();
                                    }
                                    break;
                            }
                        } else {
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                            LimpiaCamposUsuario();
                        }
                    },
                    //beforeSend: loading.ini(),
                    //complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                }
            );
        }

        // Función que muestra los datos del usuario en los campos correspondientes.
        function MuestraDatosUsuario(sDatos) {
            var a_i = 0;
            $("#txt_NumPersonal").val(sDatos[a_i].intNumPersonal);
            $("#txt_Nombre").val(sDatos[a_i].strNombre + " " + sDatos[a_i].strApPaterno + " " + sDatos[a_i].strApMaterno);
            //$("#txt_Correo").val(sDatos[a_i].strCorreo);
            $("#txt_Dependencia").val(sDatos[a_i].strsDCDepcia);
            $("#txt_Puesto").val(sDatos[a_i].strsDCPuesto);
            strJsonN = sDatos;
        }

        // Función que llama a la función de guardar o actualizar de acuerdo al valor de la variable blnConsulta.
        function Guardar() {
            if (!blnConsulta) {
                if (ValidaDatosUsuario()) {
                    //if (ValidaCheck()) {
                    GuardarUsuario();
                    //ActualizarGrid();
                    Cancelar();
                    //}
                }
            } else {
                //if (ValidaCheck()){
                    fActualizaPerfil();
                //}
            }
        }

        // Función que guarda los datos del usuario.
        function GuardarUsuario() {
            loading.ini();
            var arrPerfiles = "";
            $("[name=Perfiles]").each(function () {
                if ($(this).is(":checked")) {
                    //arrPerfiles.push($(this).attr("value"));
                    arrPerfiles += $(this).attr("id") + ",";
                }
            });
            a_i = 0;

            var scheck = null;
            if ($("#2").is(":checked")) {
                scheck = 'S';
            } 

            strParametros = "{'nDepcia': '" + strJsonN[a_i].intNumDependencia + "','nPuesto': '" + strJsonN[a_i].intPuesto +
            "','sNombre': '" + strJsonN[a_i].strNombre + "','sApPaterno': '" + strJsonN[a_i].strApPaterno + "','sApMaterno': '" + strJsonN[a_i].strApMaterno +
            "','sCuenta': '" + strJsonN[a_i].strCuenta + "','nNumPersonal': '" + strJsonN[a_i].intNumPersonal +
            "','sCorreo': '" + strJsonN[a_i].strCorreo + "','nTper': '" + strJsonN[a_i].intTipPersonal + "','nCategoria': '" + strJsonN[a_i].intCategoria +
            "','cIndEmpleado': '" + strJsonN[a_i].chrIndEmpleado + "','cIndActivo': '" + strJsonN[a_i].chrIndActivo + "','nUsuario': '" + intUsuario +
            "','sPerfiles': '" + arrPerfiles + "'}";

            $.ajax(
                {
                    url: "Usuario/SACUSUARI.aspx/fGuardarInformacion",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loading.close();
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                break;
                            case 1:
                                loading.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Los datos del usuario se han guardado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                Cancelar();
                                break;
                        }
                    },
                    //beforeSend: loading.ini(),
                    //complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                }
            );
        }

        // Función que actualiza los perfiles asignados al usuario.
        function fActualizaPerfil() {
            loading.ini();
            var scheck = null;
//            if ($("#2").is(":checked")) {
//                scheck = 'N';
//                //alert("chekado");
//            } else {
//                scheck = 'S';
//                //alert("no chekado");
//            }

            var arrPerfiles = "";
            $("[name=Perfiles]").each(function () {
                if ($(this).is(":checked")) {
                    //arrPerfiles.push($(this).attr("value"));
                    arrPerfiles += $(this).attr("id") + ",";
                }
            });

            var strParametros = "{'nUsuario':'" + NG.Var[NG.Nact - 1].datoSel.idUsuario +
                                "','sPerfiles':'" + arrPerfiles + "'}";
            $.ajax(
                {
                    url: "Usuario/SACUSUARI.aspx/fActualizaDatosUsuario",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loading.close();
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                break;
                            case 1:
                                loading.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Los datos del usuario se han actualizado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                Cancelar();
                                break;
                        }
                    },
                    //beforeSend: loading.ini(),
                    //complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                }
            );
        }

        // Función que valida que se haya buscado un usuario.
        function ValidaDatosUsuario() {
            blnCorrecto = false;
            if (jsTrim($("#txt_NumPersonal").val()).length > 0) {
                blnCorrecto = true;
            } else {
                jAlert("Favor de buscar antes una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
            return blnCorrecto;
        }

        // Función que valida que hayan marcado al menos un checkbox.
        function ValidaCheck() {
            var blnCheck = false;
            var a = 0;
            $('input[type=checkbox]').each(function () {
                if ($(this).is(":checked")) {
                    blnCheck = true;
                    return false;
                }
            });

            if (blnCheck) {
                return true;
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Debe seleccionar al menos un perfil.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
            //alert($("#Perfiles").attr("checked"));
        }

        // Función que limpia los campos.
        function LimpiaCamposUsuario() {
            $("#txt_NumPersonal").val("");
            $("#txt_Nombre").val("");
            $("#txt_Correo").val("");
            $("#txt_Dependencia").val("");
            $("#txt_Puesto").val("");
        }

        // Función que coloca el foco sobre el campo de cuenta.
        function FocoCuenta() {
            $("#txt_Cuenta").focus();
        }

        // Función que regresa a la pagina del grid de usuarios.
        function Cancelar() {
            //ActualizarGrid();
            urls(1, "Usuario/SAMUSUARI.ASPX");
        }

    </script>


   <form id="form2" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label id="titulo" class="titulo">Alta usuarios</label>
        </div>

        <!-- Desplegado contenidos -->
        <h3>Cuenta institucional:</h3>
        <label><input id="txt_Cuenta" type="text" maxlength="25" autofocus="focus" />
        <%--<a id="A1" class="accbuscar" title="Buscar" href="javascript:Buscar();" onkeypress="teclaPulsada()" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">--%>
        <a id="A1" class="accbuscar" title="Buscar" href="javascript:Buscar();" onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
            <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
        </a></label>

        <div id="agp_DatosUsuarios">
            <h3>Número de personal:</h3>
            <label><input id="txt_NumPersonal" type="text" size="40" disabled="disabled" /></label>
            <br />
            <h3>Nombre:</h3>
            <label><input id="txt_Nombre" type="text" size="70" disabled="disabled" /></label>
            <br />
<%--            <h3>Correo electrónico:</h3>
            <label><input id="txt_Correo" type="text" size="70" disabled="disabled" /></label>
            <br />--%>
            <h3>Dependencia / entidad ó institución a la que pertenece:</h3>
            <label><input id="txt_Dependencia" type="text" size="70" disabled="disabled" /></label>
            <br />
            <h3>Puesto / cargo:</h3>
            <label><input id="txt_Puesto" type="text" size="70" disabled="disabled" /></label>
        </div>
            
        <h3>Perfil:</h3>
        <br />
        <div class="align_Textarea">
            <ul id="ul_Perfiles">
                <%--<li><input type="checkbox" /><label>admin</label></li>--%>
            </ul>
        </div>
        <br />
        <!-- fin Desplegado contenidos -->


        <div class="a_botones">
            <a title="Botón Guardar" href="javascript:Guardar();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" href="javascript:Cancelar();" class="btnAct">Cancelar</a>        
        </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
