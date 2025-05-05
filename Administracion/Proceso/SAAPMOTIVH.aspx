<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPMOTIVH" Codebehind="SAAPMOTIVH.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">

        var chrTipo;
        var intIdMotivo = 0;
        $(document).ready(function () {
            NG.setNact(3, 'Tres', null);


            //Funciones para Validar los Input
                fValidaInput_Descripcion();


            if (NG.Var[NG.Nact - 1].datoSel != null) {
                //NG.Var[NG.Nact - 1].datoSel.strAccion = "MODIFICAR";
                $('#titulo').text("Modificar Motivo");

                strAccion = "ACTUALIZAR"


                //Asigno valores
                pAsignarValores();

            }

            else {
                strAccion = "INSERTAR"
                $('#rbt_ordinario').attr('checked', true);
            }
        });

        //Función que asigna los valores a la forma, cuando se modifica un Motivo
        function pAsignarValores() {
            $('#txt_Descripcion').val(NG.Var[NG.Nact - 1].datoSel.strSDMotiProc);

            var cbxResultado = NG.Var[NG.Nact - 1].datoSel.cTipoMot;
            if (cbxResultado == 'EXTRAORDINARIA' || cbxResultado == 'E') { $("#rbt_extraordinario").attr("checked", "checked"); }
            if (cbxResultado == 'ORDINARIA' || cbxResultado == 'O') { $("#rbt_ordinario").attr("checked", "checked"); }
        }

        //Función para ir a la forma principal de Motivos
        function fcancelar() {
            //loading.ini();
            urls(5, "Proceso/SAAPMOTIV.aspx");
        }

        //Función para Validar todos los campos de la forma (Espacios en blanco)
        function fValida() {

            if ($("#txt_Descripcion").val() != "") {
                $("#div_txtDescripcion").css("visibility", "hidden");

                fValidaMotivoAjax(strAccion);

                        if (intCodigo == 2) {

                            loading.ini();
                            pGuardar_Motivo();
                        }

                        else {
                            $("#div_txtDescripcion").empty().append("* La Descripcion ya existe, favor de ingresar una diferente.");
                            $("#div_txtDescripcion").css("visibility", "visible");
                            $("#txt_Descripcion").focus();
                        }

                }
                else {
                    $("#div_txtDescripcion").css("visibility", "visible");
                    $("#txt_Descripcion").focus();
                  
                }



            }

            //Función para Validar Espacios en Blanco
            function jsTrim(sString) {
                return sString.replace(/^\s+|\s+$/g, "");
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

            //Función Ajax que Inserta o Actualiza un Motivo en la Base de Datos
            function pGuardar_Motivo() {

                var strDescripcion = $('#txt_Descripcion').val();
                strDescripcion = strDescripcion.replace(/\n\r?/g, ' ');
                strDescripcion = strDescripcion.replace(/'/g, '');
                strDescripcion = strDescripcion.replace(/"/g, '');


                //Comprobar si mi checkbox esta seleccionado
                if ($("#rbt_ordinario").is(":checked")) {
                    chrTipo = "O";
                }
                else {
                    chrTipo = "E";
                }

                if (strAccion == "INSERTAR") {

                    var strDatos =
                            "{'strSDMotiProc': '" + strDescripcion +
                            "','cTipoMot': '" + chrTipo +
                            "','nUsuario': '" + $('#hf_idUsuario').val() +
                            "','strACCION': '" + strAccion +
                            "'}";

                    objMotivos = eval('(' + strDatos + ')');

                    actionData = frms.jsonTOstring({ objMotivos: objMotivos });

                    $.ajax(
            {
                url: "Proceso/SAAPMOTIVH.aspx/Insertar_Motivos",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {


                    switch (reponse.d) {
                        case 1:
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert('El Motivo se ha agregado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                fRegresar();
                            });
                            break;

                        case 0:
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
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

                    var idMotivoActual = NG.Var[NG.Nact - 1].datoSel.idMotiProc;

                    var strDatos2 =
                            "{'idMotiProc': '" + idMotivoActual +
                            "','strSDMotiProc': '" + strDescripcion +
                            "','cTipoMot': '" + chrTipo +
                            "','nUsuario': '" + $('#hf_idUsuario').val() +
                            "','strACCION': '" + strAccion +
                            "'}";

                    objMotivos = eval('(' + strDatos2 + ')');
                    actionData = frms.jsonTOstring({ objMotivos: objMotivos });

                    $.ajax(
               {
                url: "Proceso/SAAPMOTIVH.aspx/Actualizar_Motivos",
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
                            jAlert("El Motivo se ha modificado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec] = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                                fRegresar();
                            });
                            break;
                        case "0":
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
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
                    jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });

                } //FIN DE ACTUALIZAR


    } // FIN FUNCION GUARDAR


    //Función para ir a la Forma Principal de Motivos
    function fRegresar() {
        urls(5, "Proceso/SAAPMOTIV.aspx");
    }

    //Función para validar que el motivo no se repita en el Grid
    function fValidaMotivoAjax(accion) {

        var strDescripcion4 = $('#txt_Descripcion').val()
        var strDescripcion3 = strDescripcion4.replace(/\n\r?/g, ' ');
        var strDescripcion2 = strDescripcion3.replace(/'/g, '');
        var strDescripcion1 = strDescripcion2.replace(/"/g, '');
        var strDescripcion = strDescripcion1.toUpperCase();

        var strDatos = "{'strSDMotiProc': '" + strDescripcion +
                       "','strACCION': '" + "VERIFICA_MOTIVO" +
                       //"','idMotiProc': '" + intIdMotivo +
                       "'}";

        objMotivos = eval('(' + strDatos + ')');
        actionData = frms.jsonTOstring({ objMotivos: objMotivos });

        $.ajax(
                {
                    url: "Proceso/SAAPMOTIVH.aspx/Valida_Motivos",
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

                                    if (strDescripcion == NG.Var[NG.Nact - 1].datoSel.strSDMotiProc.toUpperCase()) {
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



    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label id="titulo" class="titulo">Alta de Motivos</label>
        </div>        

        <h3>Descripción:</h3> <input id="txt_Descripcion" name="asunto" type="text" maxlength="200" size="103" autofocus />
        <div id="div_txtDescripcion" class="requeridog">* Campo requerido</div>

        <h3>Tipo proceso:</h3>
        <label for="rbt_ordinario"><input type="radio" name="tipoproceso"  id="rbt_ordinario" value="O"/>Ordinario</label>
        <label for="rbt_extraordinario"><input type="radio" name="tipoproceso"  id="rbt_extraordinario" value="G"/>Extraordinario</label><br/>            
        <%--<div id="div_requerido" class="requeridog">* Campo requerido</div>        --%>
            
        <div class="a_botones">
            <a title="Botón Guardar" href="javascript:fValida();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" href="javascript:fcancelar();" class="btnAct">Cancelar</a>        
        </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
