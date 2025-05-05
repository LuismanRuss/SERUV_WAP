<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAMPERPROH" Codebehind="SAMPERPROH.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    
    <script type="text/javascript">

        var sujetobligado = null;  // Variable para indicar si es sujeto obligado (S - Si, N - No)
        var sujetoReceptor = null; // Variable para indicar si es sujeto receptor (S - Si, N - No)
        var intUsuario; // Id del usuario

        // Documente ready
        $(document).ready(function () {
            loading.close();
            sel = true;
            intUsuario = $("#hf_idUsuario").val()
            NG.setNact(3, 'Tres', null);
            $("#lbl_Proceso").text(NG.Var[NG.Nact - 2].datoSel.sDPeriodo);
            fConsultaPerfiles();
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                blnConsulta = true;
                LlenaDatos(); // Asigna los datos del JSON
            }
        });

        // Función que llena los campos con los datos del usuario seleccionado.
        function LlenaDatos() {
            strJsonC = NG.Var[NG.Nact - 1].datoSel;
            $("#txt_Cuenta").attr("disabled", true);
            $("#txt_Cuenta").val(NG.Var[NG.Nact - 1].datoSel.strCuenta);
            $("#txt_NumPersonal").val(NG.Var[NG.Nact - 1].datoSel.intNumPersonal);
            $("#txt_Nombre").val(NG.Var[NG.Nact - 1].datoSel.strNombre);
            $("#txt_Correo").val(NG.Var[NG.Nact - 1].datoSel.strCorreo);
            $("#txt_Dependencia").val(NG.Var[NG.Nact - 1].datoSel.strsDCDepcia);
            $("#txt_Puesto").val(NG.Var[NG.Nact - 1].datoSel.strsDCPuesto);

//            if (NG.Var[NG.Nact - 1].datoSel.chrIndEmpleado == 'N') {
//                $("#txt_Dependencia").attr("disabled", false);
//                $("#txt_Puesto").attr("disabled", false);
//                //console("No es empleado");
//            } else {
//                //console.log("es empleado");
//            }
        }

        // FUNCIÓN PARA OBTENER LOS PERFILES DEL CATÁLOGO INDICADOS COMO ACTIVOS
        function fConsultaPerfiles() {
            var actionData = "{}";
            $.ajax(
                {
                    url: "Proceso/SAMPERPROH.aspx/MuestraPerfiles",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        PintaPerfiles(eval('(' + reponse.d + ')'));
                    },
                    //                    beforeSend: loading.ini(),
                    //                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        // FUNCIÓN PARA PINTAR LOS PERFILES JUNTO CON LOS CHECKBOX
        function PintaPerfiles(cadena) {
            listItem = '';
            listItem2 = '';
            for (a_i = 1; a_i < cadena.length; a_i++) {
                if (cadena[a_i].idPerfil == 3 || cadena[a_i].idPerfil == 8 || cadena[a_i].idPerfil == 9) {
                    listItem2 += "<li><input type='checkbox' id=" + cadena[a_i].idPerfil + " name='Perfiles' value='" + cadena[a_i].strsDCPerfil + "'/><label>" + cadena[a_i].strsDCPerfil + "</label></li>";
                } else {
                    listItem += "<li><input type='checkbox' id=" + cadena[a_i].idPerfil + " name='Perfiles' value='" + cadena[a_i].strsDCPerfil + "'/><label>" + cadena[a_i].strsDCPerfil + "</label></li>";
                }
            }
            listItem += listItem2;

            $("#ul_Perfiles").append(listItem);
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                fLlenaPerfiles();
                if ($("#4").is(":checked")) {
                    sujetobligado = 'S';
                } if ($("#5").is(":checked")) {
                    sujetoReceptor = 'S';
                }
                $("#4").attr("disabled", true);
                $("#5").attr("disabled", true);
                $("#6").attr("disabled", true);
                $("#7").attr("disabled", true);

                if ($("#4").is(":checked") || $("#5").is(":checked") || $("#6").is(":checked") || $("#7").is(":checked")) {
                    $("#3").attr("disabled", true);
                    $("#8").attr("disabled", true);
                    $("#9").attr("disabled", true);
                }
                //fClicCheck();
                //ClickSujeto();
                //ClickCheck();
                DesactivaCheckSupervisores();
            }
        }

        // Función que marca los checbox de acuerdo a los perfiles asigandos del usuario y activa o desactiva los checkbox de supervisor.
        function fLlenaPerfiles() {
            for (i = 0; i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; i++) {
                $('input[type=checkbox]').each(function () {
                    if ($(this).attr("id") == NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil) {
                        this.checked = true;
                        if ($(this).attr("id") == 3) {
                            $("#8").attr("disabled", true);
                            $("#9").attr("disabled", true);
                        } else if ($(this).attr("id") == 8) {
                            $("#3").attr("disabled", true);
                            $("#9").attr("disabled", true);
                        } else if ($(this).attr("id") == 9) {
                            $("#3").attr("disabled", true);
                            $("#8").attr("disabled", true);
                        }
                    }
                });
            }
        }

        // Función que se ejecuta cuando se marca o desmarca un checkbox para agregarlo o quitarlo del objeto JSON.
        function fClicCheck() {
            $('input[type=checkbox]').click(function () {
                if ($(this).is(":checked")) {
                    if ($(this).attr("id") == 4 || $(this).attr("id") == 5){
                        ValidaSujeto();
                    }
                    //alert("ya estaba chekeado");
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
                    Guardar();
                } else {
                    //alert("no estaba chekeado");
                    var intPos = 0;
                    var intId = $(this).attr("id");
                    for (a_i = 0; a_i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; a_i++) {
                        if ($(this).attr("id") == NG.Var[NG.Nact - 1].datoSel.lstPerfiles[a_i].idPerfil) {
                            intPos = a_i;
                        }
                    }
                    //console.log("pos:" + intPos);
                    NG.Var[NG.Nact - 1].datoSel.lstPerfiles.splice(intPos, 1);
                    //                    for (i = 0; i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; i++) {
                    //                        console.log(NG.Var[NG.Nact - 1].datoSel.lstPerfiles[i].idPerfil);
                    //                    }
                    Guardar();
                }
            });

        }

        // Función que guarda la información del usuario.
        function Guardar() {
//            if (ValidaCheck()) {
                //console.log(NG.Var[NG.Nact - 2].datoSel.nIdProceso);
                fActualizaPerfil();
//                Regresar();
//            }
        }

        //Función que actualiza los perfiles de acuerdo a la perfiles seleccionados
        function fActualizaPerfil() {
            loading.ini();
            var strPerfiles = "";
            //for (a_i = 0; a_i < NG.Var[NG.Nact - 1].datoSel.lstPerfiles.length; a_i++) {
            //    if (NG.Var[NG.Nact - 1].datoSel.lstPerfiles[a_i].idPerfil != 2) {
            //        strPerfiles += NG.Var[NG.Nact - 1].datoSel.lstPerfiles[a_i].idPerfil + ",";
            //    }
            //}

            $('input[type=checkbox]').each(function () {
                if ($(this).is(":checked")) {
                    strPerfiles += $(this).attr("id") + ",";
                }
            });
            var strParametros = "{'nidUsuario':'" + NG.Var[NG.Nact - 1].datoSel.idUsuario +
                                "','nidProceso':'" + NG.Var[NG.Nact - 2].datoSel.nIdProceso +
                                "','sPerfiles':'" + strPerfiles + "'}";
            $.ajax(
                {
                    url: "Proceso/SAMPERPROH.aspx/fActualizaDatosUsuario",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //Los datos no se actualizaron.
                                break;
                            case 1:
                                loading.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Acción realizada correctamente", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                Cancelar();
                                //NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstPerfiles = $("#CH1").is(':checked');
                                //jAlert("Los datos del usuario se han actualizado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                        }
                        //MuestraDatosUsuario(eval('(' + reponse.d + ')'));
                    },
                    //beforeSend: loading.ini(),
                    //complete: loading.close(),
                    error: //errorAjax
                            function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                }
            );
        }

        //Función que valida que al menos un checkbox este marcado
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
        }

        //Función para saber si chekearon un checkbox del sujeto obligado o receptor
        function ClickSujeto() {
            var chrIndicadorSujeto;
            $('input[type=checkbox]').click(function () {
                if ($(this).attr("id") == 4) {
                    //alert(sujetobligado);
                    if (sujetobligado == 'S') {
                        sujetobligado = 'N';
                        if ($(this).is(":checked")) {
                            //alert("4");
                        } else {
                            //alert("no chekeado");
                            chrIndicadorSujeto = "O";
                            ValidaSujeto(chrIndicadorSujeto);

                        }
                    }
                }

                else if ($(this).attr("id") == 5) {
                    if (sujetoReceptor == 'S') {
                        if ($(this).is(":checked")) {
                            //alert("5");
                        } else {
                            //alert("no chekeado");
                            chrIndicadorSujeto = "R";
                            ValidaSujeto(chrIndicadorSujeto);
                        }
                    }
                }

            });
        }

        // Función que valida si el usuario se encuentra asignado a alguna dependencia como sujeto receptor o sujeto obligado.
        function ValidaSujeto(cIndSujeto) {
            var strParametros = "{'nIdUsuario':'" + NG.Var[NG.Nact - 1].datoSel.idUsuario +
                                "','sIndicador':'" + cIndSujeto + "'}";
            $.ajax({
                url: "Proceso/SAMPERPROH.aspx/fGetPartXUsu",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = eval('(' + reponse.d + ')');
                    var textoAlert = '';

                    if (resp != null) {
                        if (resp.length != 0 || resp[0] != null) {
                            textoAlert += "El usuario " + NG.Var[NG.Nact - 1].datoSel.strNombre + " ya esta asigando en las siguientes dependencias: \n\n";
                            for (k = 0; k < resp.length; k++) {
                                textoAlert += resp[k].sDDepcia + ",\n";
                            }
                            textoAlert += "\n";
                            textoAlert += "¿Aún así desea cambiar la configuración?";
                            $.alerts.dialogClass = "infoConfirm";
                            jConfirm(textoAlert, "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                                if (r) {
                                    var arrParticipantes = new Array();
                                    for (i = 0; i < resp.length; i++) {
                                        arrParticipantes.push(resp[i].idParticipante);
                                    }
                                    DeshabilitaSujeto(arrParticipantes, cIndSujeto, intUsuario);
                                } else {
                                    if (cIndSujeto == 'R') {
                                        $("#5").attr("checked", true);

                                        // Se crea un objeto Json de tipo perfil y se agrega a la lista de perfiles
                                        var filtro = "{\"filtro\": [ {\"idPerfil\": \"\", \"strDPerfil\": \"\" } ] }";
                                        var objFiltro = eval('(' + filtro + ')');
                                        var strDato = " {\"idPerfil\": \"\", \"strDPerfil\": \"\" }";
                                        objFiltro = eval('(' + strDato + ')');
                                        objFiltro.idPerfil = 5;
                                        objFiltro.strDPerfil = 'Sujeto Receptor';
                                        NG.Var[NG.Nact - 1].datoSel.lstPerfiles.push(objFiltro);

                                        fActualizaPerfil();
                                    } else if (cIndSujeto == 'O') {
                                        $("#4").attr("checked", true);

                                        // Se crea un objeto Json de tipo perfil y se agrega a la lista de perfiles
                                        var filtro = "{\"filtro\": [ {\"idPerfil\": \"\", \"strDPerfil\": \"\" } ] }";
                                        var objFiltro = eval('(' + filtro + ')');
                                        var strDato = " {\"idPerfil\": \"\", \"strDPerfil\": \"\" }";
                                        objFiltro = eval('(' + strDato + ')');
                                        objFiltro.idPerfil = 4;
                                        objFiltro.strDPerfil = 'Sujeto Obligado';
                                        NG.Var[NG.Nact - 1].datoSel.lstPerfiles.push(objFiltro);

                                        fActualizaPerfil();
                                    }
                                }
                            });
                            //if (cIndSujeto == 'R') {
                                //$("#5").attr("checked", true);
                            //} else if (cIndSujeto == 'O') {
                                //$("#4").attr("checked", true);
                            //}
                        } else {
                            //alert("no trae");
                        }
                    }
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: errorAjax
            });
        }

        // Función que deshabilita el perfil de sujeto obligado o receptor del proceso al que este asignado.
        function DeshabilitaSujeto(aParticipantes, cIndSujeto, nUsuario) {
            var strParametros = "{'sParticipantes':'" + aParticipantes +
                                "','sIndSujeto': '" + cIndSujeto + 
                                "','nUsuario':'" + nUsuario + "'}";
            $.ajax(
                {
                    url: "Proceso/SAMPERPROH.aspx/fDeshabilitaSujeto",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                            case 1:
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Acción realizada correctamente", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        }
                    },
                    //                    beforeSend: loading.ini(),
                    //                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        //Función para guardar el perfil del usuario seleccionado al momento de dar clic en el checkbox
        function ClickCheck() {
            $('input[type=checkbox]').click(function () {
                loading.ini();
                var strCheckado = '';
                if ($(this).is(":checked")) {
                    strCheckado = 'S';
                } else {
                    strCheckado = 'N';
                }
                var strParametros = "{'nidPerfil':'" + NG.Var[NG.Nact - 1].datoSel.idUsuario +
                                    "','nidProceso':'" + NG.Var[NG.Nact - 2].datoSel.nIdProceso +
                                    "','nPerfil':'" + $(this).attr("id") +
                                    "','sCheckado':'" + strCheckado +
                                    "'}";
                $.ajax({
                    url: "Proceso/SAMPERPROH.aspx/fActualizaDatosUsuario",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //Los datos no se actualizaron.
                                break;
                            case 1:
                                loading.close();
                                //NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstPerfiles = $("#CH1").is(':checked');
                                //jAlert("Los datos del usuario se han actualizado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                        }
                        //MuestraDatosUsuario(eval('(' + reponse.d + ')'));
                    },
                    //beforeSend: loading.ini(),
                    //complete: loading.close(),
                    error: //errorAjax
                            function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                });
            });
        }

        // Función que desactiva los checkbox de supervisor diferentes al supervisor que haya marcado 
        // y activa todo los checkbox de supervisor en caso de desmarcar el supervisor seleccionado.
        function DesactivaCheckSupervisores() {
            $('input[type=checkbox]').click(function () {
                var blnCheck = false;
                if ($(this).is(":checked")) {
                    blnCheck = true;
                }

                if ($(this).attr("id") == 3) {
                    if ($(this).is(":checked")) {
                        $("#8").attr("disabled", true);
                        $("#9").attr("disabled", true);
                    }
                    else {
                        $("#8").attr("disabled", false);
                        $("#9").attr("disabled", false);
                    }
                } else if ($(this).attr("id") == 8) {
                    if ($(this).is(":checked")) {
                        $("#3").attr("disabled", true);
                        $("#9").attr("disabled", true);
                    } else {
                        $("#3").attr("disabled", false);
                        $("#9").attr("disabled", false);
                    }
                } else if ($(this).attr("id") == 9) {
                    if ($(this).is(":checked")) {
                        $("#3").attr("disabled", true);
                        $("#8").attr("disabled", true);
                    }
                    else {
                        $("#3").attr("disabled", false);
                        $("#8").attr("disabled", false);
                    }
                }
            });
        }

        // Función que regresa al listado de usuarios.
        function Cancelar() {
            loading.ini();
            urls(5, "Proceso/SAMPERPRO.ASPX");
        }

        // Función que regresa al listado de usuarios.
        function Regresar() {
            urls(5, "Proceso/SAMPERPRO.ASPX");
        }

    </script>

    <form id="form1" runat="server">
    <div>
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Asignar perfil</label>
        </div>
        <div class="instrucciones">Seleccione un perfil de supervisor a configurar.</div>
        <br />
          
        <div>
            <h2>Proceso entrega - recepción:</h2><label id="lbl_Proceso"></label>
        </div>

        <br />

        <h3>Cuenta institucional:</h3>
        <label><input id="txt_Cuenta" type="text" maxlength="25" />
            <%--<a id="A1" class="accbuscar" title="Buscar" href="javascript:Buscar();"  onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
                <img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" />
            </a>--%>
        </label>

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
            <h3>Dependencia/entidad ó institución a la que pertenece:</h3>
            <label><input id="txt_Dependencia" type="text" size="70" disabled="disabled" /></label>
            <br />
            <h3>Puesto/cargo:</h3>
            <label><input id="txt_Puesto" type="text" size="70" disabled="disabled" /></label>
        </div>
            
        <h3>Perfil:</h3>
        <br />
        <div class="align_Textarea">
            <ul id="ul_Perfiles">
            </ul>
        </div>
        <br />        

        <div class="a_botones">
            <a title="Botón Guardar" href="javascript:Guardar();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" href="javascript:Cancelar();" class="btnAct">Cancelar</a>                        
        </div>
        <br />
        <div class="notapie">Para seleccionar otro perfil de supervisor deseleccione la casilla marcada.</div>
        <br />

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </div>
    </form>
</body>
</html>
