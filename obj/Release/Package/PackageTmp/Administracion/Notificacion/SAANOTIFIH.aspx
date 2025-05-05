<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Notificacion_SAANOTIFIH" Codebehind="SAANOTIFIH.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

</head>
<body>
    <script type="text/javascript">
        $(document).ready(function () {
            intUsuario = $("#hf_idUsuario").val();
            nUsuario = $("#hf_idUsuario").val();
            NG.setNact(2, 'Dos', null);
            ObtenerDias();
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                $('#titulo').text("Modificar notificación");
                idNotifica = NG.Var[NG.Nact - 1].datoSel.idNotifica;
                strAsunto = NG.Var[NG.Nact - 1].datoSel.strAsunto;

                blnConsulta = true;
                Ajax(idNotifica);               
            } else {
                blnConsulta = false;                
            }
        });

        //Función que devuelve una lista con la información necesaria para pintar los datos referentes a la notificación seleccionada
        function Ajax(idNotifica) {
          loading.ini();          
          var actionData = "{'idNotifica': '" + idNotifica +
                             "'}";
          $.ajax(
                    {
                        url: "Notificacion/SAANOTIFIH.aspx/regresaNotificacion",
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
                                txt = "Ha sucedido un error inesperado, inténtelo más tarde.\n\n";
                                txt += "descripción del error: " + err.message + "\n\n";

                            }
                        },
                        error:

                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    }
                );
           }

           // Función que obtiene los datos de la función Ajax y los usa para pintarlos en los campos correspondientes
           function LlenaDatos() {
               strJsonC = NG.Var[NG.Nact - 1].datoSel;

            if (NG.Var[NG.Nact - 1].datoSel.cLunes == 'S' && NG.Var[NG.Nact - 1].datoSel.cMartes == 'S' && NG.Var[NG.Nact - 1].datoSel.cMiercoles == 'S' && NG.Var[NG.Nact - 1].datoSel.cJueves == 'S' && NG.Var[NG.Nact - 1].datoSel.cViernes == 'S' && NG.Var[NG.Nact - 1].datoSel.cSabado == 'S' && NG.Var[NG.Nact - 1].datoSel.cDomingo == 'S') {
                $("#diario").attr("checked", true);
            } else {
                $("#semanal").attr("checked", true);

                texto3 = '<blockquote>' + "<h5>Repetir los dias: </h5>" + '<blockquote>';
                texto4 = '' + '<input id="cbx_lunes" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Lunes</label>' + '<input id="cbx_martes" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Martes</label>' + '<input id="cbx_miercoles" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Miércoles</label>'
                + '<input id="cbx_jueves" type="checkbox" value="S" />' + '<label id="d_frecuencia">Jueves</label>' + '<input id="cbx_viernes" type="checkbox" value="S" />' + '<label id="d_frecuencia">Viernes</label>' + '<input id="cbx_sabado" type="checkbox"  value="S"/>' + '<label id="d_frecuencia">Sábado</label>' +
                '<input id="cbx_domingo" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Domingo</label>';

                $('#peri_sem').html(texto3 + texto4);
                LlenaChecks();
            };

            $("#txt_asunto").val(NG.Var[NG.Nact - 1].datoSel.strAsunto);
            $("#txt_notificacion").val(NG.Var[NG.Nact - 1].datoSel.strMensaje);
        }


        // Función que muestra/oculta la sección de días en base a una condición 
        function ObtenerDias() {
            $('input[name=rbt_peri]').change(function () {
                dat = $('input[name=rbt_peri]:checked').val();

                if (dat == "diario") {
                    $('#peri_sem').html('');
                }
                else {
                    if (dat == "semanal") {
                        texto3 = '<blockquote>' + "<h5>Repetir los dias: </h5>" + '<blockquote>';
                        texto4 = '' + '<input id="cbx_lunes" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Lunes</label>' + '<input id="cbx_martes" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Martes</label>' + '<input id="cbx_miercoles" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Miércoles</label>'
                        + '<input id="cbx_jueves" type="checkbox" value="S" />' + '<label id="d_frecuencia">Jueves</label>' + '<input id="cbx_viernes" type="checkbox" value="S" />' + '<label id="d_frecuencia">Viernes</label>' + '<input id="cbx_sabado" type="checkbox"  value="S"/>' + '<label id="d_frecuencia">Sábado</label>' +
                        '<input id="cbx_domingo" type="checkbox" value="S"/>' + '<label id="d_frecuencia">Domingo</label>';

                        $('#peri_sem').html(texto3 + texto4);
                       
                    }
                }
            })
        }


        // Variables que almacenarán si la notificiación se enviará el día correspondiente
        var dLunes, dMartes, dMiercoles, dJueves, dViernes, dSabado, dDomingo;

        // Función que valida la información necesaria para crear una notificación 
        function validaDatos() {

            var mensajeNot = $('#txt_notificacion').val();
            mensajeNot = mensajeNot.replace(/\n\r?/g, ' ');
            mensajeNot = mensajeNot.replace(/"/g, '');
            mensajeNot = mensajeNot.replace(/'/g, '');
            $('#txt_notificacion').val(mensajeNot);

            var asuntoNot = $('#txt_asunto').val();
            asuntoNot = asuntoNot.replace(/\n\r?/g, ' ');
            asuntoNot = asuntoNot.replace(/'/g, '');
            asuntoNot = asuntoNot.replace(/"/g, '');
            $('#txt_asunto').val(asuntoNot);
            dat = $('input[name=rbt_peri]:checked').val();

            if ($('#txt_asunto').val() != "" && $('#txt_notificacion').val() != "") {
                if($("input[name=rbt_peri]").is(':checked')){
                    if (dat == "diario") {
                        Guardar();
                    }
                    else if (dat == "semanal") {
                        if
                    (!$('#cbx_lunes').is(':checked') && !$('#cbx_martes').is(':checked') && !$('#cbx_miercoles').is(':checked') &&
                    !$('#cbx_jueves').is(':checked') && !$('#cbx_viernes').is(':checked') && !$('#cbx_sabado').is(':checked') &&
                    !$('#cbx_domingo').is(':checked')
                    ) {
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert('* Debe seleccionar al menos un día.', 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                        else {
                            Guardar();
                        }
                    }
                } else {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert('* Debe seleccionar la periodicidad.', 'SISTEMA DE ENTREGA - RECEPCIÓN'); 
                }
            }
            else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert('* Favor de llenar todos los campos.', 'SISTEMA DE ENTREGA - RECEPCIÓN');
            }
        }

        // Función que envia a guardar o modificar una notificación
        function Guardar() {
            if (!blnConsulta) {                                
                GuardarUsuario();
                cancelar();
            }                
            else {
                fActualizaNotifica();                
                cancelar();                
            }
        }
        // Función que es usada para guardar una notificación nueva
        function GuardarUsuario() {
            loading.ini();         
            var dLunes, dMartes, dMiercoles, dJueves, dViernes, dSabado, dDomingo;            
            var cIndActivo = 'S';
            var strACCION = 'CREA_NOTIFICACION';

            if (dat == "diario") {
                dLunes = 'S'; dMartes = 'S'; dMiercoles = 'S'; dJueves = 'S'; dViernes = 'S'; dSabado = 'S'; dDomingo = 'S';                
            }
            else if (dat = "semanal") {
                if ($('#cbx_lunes').is(':checked')) { dLunes = 'S'; } else { dLunes = 'N'; }
                if ($('#cbx_martes').is(':checked')) { dMartes = 'S'; } else { dMartes = 'N'; }
                if ($('#cbx_miercoles').is(':checked')) { dMiercoles = 'S'; } else { dMiercoles = 'N'; }
                if ($('#cbx_jueves').is(':checked')) { dJueves = 'S'; } else { dJueves = 'N'; }
                if ($('#cbx_viernes').is(':checked')) { dViernes = 'S'; } else { dViernes = 'N'; }
                if ($('#cbx_sabado').is(':checked')) { dSabado = 'S'; } else { dSabado = 'N'; }
                if ($('#cbx_domingo').is(':checked')) { dDomingo = 'S'; } else { dDomingo = 'N'; }                
            }

            var strDatos = "{'strAsunto': '" + $('#txt_asunto').val() +
                             "','strMensaje': '" + $('#txt_notificacion').val() +
                             "','nUsuario': '" + nUsuario +
                             "','cIndActivo': '" + cIndActivo +
                             "','cLunes': '" + dLunes +
                             "','cMartes': '" + dMartes +
                             "','cMiercoles': '" + dMiercoles +
                             "','cJueves': '" + dJueves +
                             "','cViernes': '" + dViernes +
                             "','cSabado': '" + dSabado +
                             "','cDomingo': '" + dDomingo +
                             "','strACCION': '" + strACCION +
                            "'}";

            datosJSON = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objNotificacion: datosJSON });

            $.ajax(
                    {
                        url: "Notificacion/SAANOTIFIH.aspx/insertaNotificacion",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            loading.close();
                            if (reponse.d) {
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert('La notificación se ha agregado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                    if (r) {
                                        cancelar();
                                    }
                                });
                            }
                        },
                        
                        error: //errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    }
                );
        }

        //Función usada para la actualización de una notificación
        function fActualizaNotifica() {
            loading.ini();
            strAsunto = NG.Var[NG.Nact - 1].datoSel.strAsunto;

            var dLunes, dMartes, dMiercoles, dJueves, dViernes, dSabado, dDomingo;
            var cIndActivo = 'S';
            var strACCION = 'MODIFICA_NOTIFICACION';            

            if (dat == "diario") {
                dLunes = 'S'; dMartes = 'S'; dMiercoles = 'S'; dJueves = 'S'; dViernes = 'S'; dSabado = 'S'; dDomingo = 'S';                
            }
            else if (dat = "semanal") {
                if ($('#cbx_lunes').is(':checked')) { dLunes = 'S'; } else { dLunes = 'N'; }
                if ($('#cbx_martes').is(':checked')) { dMartes = 'S'; } else { dMartes = 'N'; }
                if ($('#cbx_miercoles').is(':checked')) { dMiercoles = 'S'; } else { dMiercoles = 'N'; }
                if ($('#cbx_jueves').is(':checked')) { dJueves = 'S'; } else { dJueves = 'N'; }
                if ($('#cbx_viernes').is(':checked')) { dViernes = 'S'; } else { dViernes = 'N'; }
                if ($('#cbx_sabado').is(':checked')) { dSabado = 'S'; } else { dSabado = 'N'; }
                if ($('#cbx_domingo').is(':checked')) { dDomingo = 'S'; } else { dDomingo = 'N'; }
                
            }

            var strDatos = "{'strAsunto': '" + $('#txt_asunto').val() +
                             "','strMensaje': '" + $('#txt_notificacion').val() +
                             "','idNotifica': '" + idNotifica + 
                             "','nUsuario': '" + nUsuario +
                             "','cIndActivo': '" + cIndActivo +
                             "','cLunes': '" + dLunes +
                             "','cMartes': '" + dMartes +
                             "','cMiercoles': '" + dMiercoles +
                             "','cJueves': '" + dJueves +
                             "','cViernes': '" + dViernes +
                             "','cSabado': '" + dSabado +
                             "','cDomingo': '" + dDomingo +
                             "','strACCION': '" + strACCION +
                            "'}";
            
            datosJSON = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objNotificacion: datosJSON });


            $.ajax(
                {
                    url: "Notificacion/SAANOTIFIH.aspx/fActualizaNotificac",
                    data: actionData,
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
                                NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strAsunto = $('#strAsunto').val();
                                NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strMensaje = $('#strMensaje').val();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Los datos se actualizaron satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                        }
                    },
                    
                    error: //errorAjax
                    function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
        }

        //  Función que sirve para llenar los check's  con los valores que obtiene del dato seleccionado
        function LlenaChecks() {            
            if (NG.Var[NG.Nact - 1].datoSel.cLunes == 'S') {
                $("#cbx_lunes").attr("checked", true);
            }

            if (NG.Var[NG.Nact - 1].datoSel.cMartes == 'S') {
                $("#cbx_martes").attr("checked", true);
            }

            if (NG.Var[NG.Nact - 1].datoSel.cMiercoles == 'S') {
                $("#cbx_miercoles").attr("checked", true);
            }

            if (NG.Var[NG.Nact - 1].datoSel.cJueves == 'S') {
                $("#cbx_jueves").attr("checked", true);
            }

            if (NG.Var[NG.Nact - 1].datoSel.cViernes == 'S') {
                $("#cbx_viernes").attr("checked", true);
            }

            if (NG.Var[NG.Nact - 1].datoSel.cSabado == 'S') {
                $("#cbx_sabado").attr("checked", true);
            }

            if (NG.Var[NG.Nact - 1].datoSel.cDomingo == 'S') {
                $("#cbx_domingo").attr("checked", true);
            }

        }

        //Función que redirecciona al grid de las notificaciones
        function cancelar() {
            urls(4, "Notificacion/SAANOTIFI.aspx");
        }

        // Función que permite la utilización de ciertos carácteres
        function limita(elEvento, maximoCaracteres) {
            var elemento = document.getElementById("txt_notificacion");

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

        // Función que indica cuantos caractéres se permite escribir en el txt_notificacion
        function actualizaInfo(maximoCaracteres) {
            var elemento = document.getElementById("txt_notificacion");
            var info = document.getElementById("info");

            if (elemento.value.length >= maximoCaracteres) {
                info.innerHTML = "Máximo de " + maximoCaracteres + " caracteres";
            }
            else {
                info.innerHTML = "Quedan " + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
            }
        }


    </script>

    <form id="fr_AltaNotificaciones" runat="server" name="altanotificaciones">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label id="titulo" class="titulo">Alta notificaciones</label>
        </div>        

        <h3>Asunto:</h3> <input id="txt_asunto" name="asunto" type="text" maxlength="500" size="103" autofocus />
        <br />

        <h3>Mensaje:</h3>
        <div class="align_Textarea">             
            <textarea id="txt_notificacion" name="observaciones" onkeypress="return limita(event, 1000);" onkeyup="actualizaInfo(1000)" rows="5" cols="100"></textarea>
            <div id="info">Máximo de 1000 caracteres</div>
        </div>
        <br />

        <h3>Periodicidad:</h3>
        <div class="align_Textarea">
        <div id="agp_MsgPeriodo">
            <div class="radio_cen">
            <input type="radio" name="rbt_peri" value="diario" id="diario" /><h5>Diaria</h5>            
            <br />

            <input type="radio" name="rbt_peri"  value="semanal" id="semanal"/><h5>Semanal</h5>
            <div id="peri_sem"></div>
            </div>
        </div>
        </div>
            
        <div class="a_botones">
            <a title="Botón Guardar" href="javascript:validaDatos();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" href="javascript:cancelar();" class="btnAct">Cancelar</a>        
        </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
