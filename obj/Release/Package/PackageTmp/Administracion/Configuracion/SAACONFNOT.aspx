<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Configuracion_SAACONFNOT" Codebehind="SAACONFNOT.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
<script type="text/javascript">
    var estadoNot;
    var cIndActivo;

    $(document).ready(function () {
        loading.close();

        ConsultaEstados();

        // Cambia el estado de los botones si el radio seleccionado es distinto o igual al valor de la configuración que se obtiene de la consulta
        $('input[name=rbt_estado]').change(function () {
            estadoNot = $('input[name=rbt_estado]:checked').val();

            if (estadoNot == cIndActivo) {
                $("#Btn_GuardarAct").hide();
                $("#Btn_GuardarIna").show();
            } //
            else if (estadoNot != cIndActivo) {
                $("#Btn_GuardarAct").show();
                $("#Btn_GuardarIna").hide();
            }
        });

    });

    //función que oculta/muestra el estado de un botón de acuerdo si estado seleccionado es el mismo al que ya tenia configurado
    function CambiaEstado() {

        if (cIndActivo == 'S') { cIndActivo = 'N' }
        else if (cIndActivo == 'N') { cIndActivo = 'S' }
        $("#Btn_GuardarAct").hide();
        $("#Btn_GuardarIna").show();
    }

    // Función que manda una ventana de confirmación para asegurar que se desea modificar la configuración, si se acepta envia el valor del radio a la función configuración
    function EstadoNotificaciones() {
       // cIndActivo = $('input[name=rbt_estado]:checked').val();
        if (estadoNot == "S" || estadoNot == "N") {

            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Está seguro que desea modificar la configuración de notificaciones?", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                if (r) {
                    Configuracion($('input[name=rbt_estado]:checked').val());
                }
            });
        }
        else {
            $.alerts.dialogClass = "incompletoAlert";
            jAlert("Seleccione una opcion");
        }
    }

    //Función que guardará el valor que indique la configuración de las notificaciones del sistema.
    function Configuracion(cIndActivo) {
        var idUsuario = $('#hf_idUsuario').val();

        loading.ini();
        var actionData = "{'status': '" + cIndActivo +
                             "','idUsuario': '" + idUsuario +
                             "'}";
        $.ajax(
                    {
                        url: "Configuracion/SAACONFNOT.aspx/ConfiguraNot",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            try {
                                if (reponse.d == 1) {
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("La configuración ha sido modificada satisfactoriamente", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                    CambiaEstado();
                                }
                                else if (reponse.d == 0) {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("La acción no se pudo realizar, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                                loading.close();
                            } catch (err) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        },
                        error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    }
                );
    }

    //Función que consulta el estado de la configuración de las notificaciones y manda esos datos a LLenaDatos para que los muestre.
    function ConsultaEstados() {
        var idUsuario = $('#hf_idUsuario').val();
        idConfigNot = 0;

        loading.ini();
        var actionData = "{}";
        $.ajax(
                    {
                        url: "Configuracion/SAACONFNOT.aspx/GetConfiguraNot",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            try {
                                LlenaDatos(eval('(' + reponse.d + ')'));
                                loading.close();
                            } catch (err) {
                                loading.close();
                                console.log(err.message);
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error al intentar cargar la información, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        },
                        error:
                        function (result) {
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    }
                );
    }

    //Función que llena el checkbox que indica el estado de la configuración de las notificaciones.
    function LlenaDatos(datos) {
            if (datos[0].cIndActivo == 'S') {
                $("#rbt_Activo").attr("checked", true);
                cIndActivo = 'S';
            }
            else if (datos[0].cIndActivo == 'N') {
                $("#rbt_Inactivo").attr("checked", true);
                cIndActivo = 'N';
            }
             $("#Btn_GuardarAct").hide();
    }
    </script>

    <form id="frConfiguraNot" runat="server">
    <div id="dialog-modal" title="SISTEMA DE ENTREGA -  RECEPCIÓN" >
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label id="titulo" class="titulo">
                    Configuración de envío de notificaciones</label>
            </div>
            <div class="instrucciones">
                Marque la casilla de verificación para indicar si las notificaciones permanecerán
                activas o inactivas</div>
            <br />
            <div id="div_status" class="align_Textarea">
                <input type="radio" name="rbt_estado" value="S" id="rbt_Activo"/><h7>
                    Activas</h7>
                <input type="radio" name="rbt_estado" value="N" id="rbt_Inactivo" /><h7>
                    Inactivas</h7>
            </div>
            <br />
            <div class="a_botones">
                <a title="Botón Guardar" id="Btn_GuardarAct" href="javascript:EstadoNotificaciones();"
                    class="btnAct">Guardar</a>
                <a title="Botón Guardar" id="Btn_GuardarIna"
                    class="btnIna">Guardar</a>
            </div>
            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
            </div>
        </div>
    </div>
    </form>
</body>
</html>
