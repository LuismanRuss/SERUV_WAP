<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SMAAPERTU" Codebehind="SMAAPERTU.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

        <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Sujeto.css" rel="stylesheet" type="text/css" />
       
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
 
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
</head>
<body>

    <script type="text/javascript">

        var intIdUsuarioDest;
        var intIdUsuarioRemit;
        var intIdProceso;
        var intIdDependencia;
        var intProceso;
        var intParticipante;

        $(document).ready(function () {
            NG.setNact(1, 'Uno');
            intParticipante = $("#slc_depcias option:selected", parent.document).val()
            NG.Var[NG.Nact - 1].datoSel = eval('(' + $("#h_NG", parent.document).val() + ')');

            if (NG.Var[NG.Nact - 1].datoSel.lstProcesos.length == 1) {
                intProceso = 0;
            } else {
                intProceso = $("#slc_fProcesos option:selected", parent.document).val();
            }

            intIdUsuarioRemit = NG.Var[NG.Nact - 1].datoSel.idUsuario;
            intIdProceso = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].idProceso;
            intIdDependencia = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].nDepcia;

            $("#lbl_Proceso").text(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].strDProceso);
            //$("#lbl_nDependencia").text(intIdDependencia);
            $("#lbl_Dependencia").text(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strDDepcia);
        });

        // Función que envía la solicitud de apertura a los supervisores del proceso.
        function fEnviar() {
            loading.ini();
            if (fValidaTextArea()) {
                var actionData = "{'nProceso':'" + intIdProceso +
                                "','nDependencia':'" + intIdDependencia +
                                "','sAsunto':'" + "Solicitud de Apertura del Proceso de Entrega-Recepción " + NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].strDProceso +
                                "','sJustificacion':'" + $("#txt_justificacion").val().replace(/\n\r?/g, ' ') +
                                 "','nIdUsuarioRemitente':'" + intIdUsuarioRemit +
                                "'}";
                $.ajax({
                    url: "../Monitoreo/SMAAPERTU.aspx/SolicitarApertura",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loading.close();
                        fCerrarModal(reponse.d);
                    },
                    //beforeSend: loading.ini(),
                    //complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                });
            }
        }

        //Función para validar el textarea Justificación.
        function fValidaTextArea() {
            var blnCorrecto = false;
            $("#txt_justificacion").val(jsTrim($("#txt_justificacion").val()));
            if ($("#txt_justificacion").val().length > 0) {
                blnCorrecto = true;
            } else {
                loading.close();
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Indique la justificación.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                blnCorrecto = false;
            }
            return blnCorrecto;
        }

        // Función que cierra la ventana modal de solicitud de apertura.
        function fCerrarModal(nMensaje) {
            window.parent.fCerrarVentApertura(nMensaje);
        }

        // Función que hace trim sobre una cadena.
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        //Cerrar la ventana 
        function fCancelar() {
            window.parent.fCancelar();
        }

    </script>

    <form id="form6" runat="server">
    <div id="agp_contenido">
        <div id="lblinstrucciones" class="instrucciones"></div>        
            <!-- Desplegado contenidos -->
            <h2>Proceso entrega - recepción:</h2><label id="lbl_Proceso"></label>
            <br />
            <h2>Dependencia:</h2><label id="lbl_nDependencia"></label><label id="lbl_Dependencia"></label>
            <br />
            <h2>Justificación:</h2>

            <div class="cont_justificacion">
                <textarea autofocus id="txt_justificacion" rows="7" cols="134"></textarea> 
            </div>

            <!-- fin Desplegado contenidos -->
            <div class="a_botones">
                <a id="EnviarActivo" href="javascript:fEnviar();" class="btnAct" title="Botón de enviar">Enviar</a> 
                <!-- <a id="CancelarActivo" href="javascript:Cancelar();" class="btnIna"  title="Botón de cancelar">Cancelar</a>-->
                <a id="CancelarActivo" href="javascript:fCancelar();" class="btnAct"  title="Botón de cancelar">Cancelar</a>
            </div>
    </div>
    </form>
</body>
</html>
