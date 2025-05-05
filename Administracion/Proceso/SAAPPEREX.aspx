<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPPEREX" Codebehind="SAAPPEREX.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">

        BotonesSAAPPEREX = function (selec) {//FUNCIÓN PARA LOS BOTONES DE LA FORMA
            if (selec > 0) {
                $("#Btn_Guardar2,#Btn_Cancelar2").hide();
                $("#Btn_Guardar,#Btn_Cancelar").show();
            }
            else {
                $("#Btn_Guardar2, #Btn_Cancelar").show();
                $("#Btn_Guardar,#Btn_Cancelar2").hide();
            }
        }

        vDate = {//Configuración del datepiker
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

        var fechaFinal = "";        //Variable que almacenara la fecha final del proceso
        var indicadorPagina = null;

        $(document).ready(function () {
            indicadorPagina = $("#hf_indicadorPagina").val();
            var idParticipante = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdParticipante;
            fechaFinal = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sFFinal;   //aaasdasdas

            $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sProceso + ' ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
            $("#lblDepcia").text(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDDepcia);
            $("#lblFechasPeriodo").text('Del    ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sFInicio + '    al    ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sFFinal + '.');

            //funcion para el numero de caracteres
            $("#txtJustif").keypress(function (e) {
                var lengthF = $(this).val();

                if (lengthF.length > 500) {
                    e.preventDefault();
                }
            });

            $('textarea[maxlength]').keyup(function () {
                var limit = parseInt($(this).attr('maxlength'));
                var text = $(this).val();
                var chars = text.length;
                if (chars > limit) {
                    var new_text = text.substr(0, limit);
                    $(this).val(new_text);
                }
            });

            NG.setNact(3, 'Tres');
            fAjax(idParticipante);

            $("#txtFeIn").mask("99-99-9999");
            $('#txtFeFIn').mask("99-99-9999");
            $('#txtFeIn').datepicker(vDate);
            $('#txtFeFIn').datepicker(vDate);

            BotonesSAAPPEREX(0);
        });

        function fAjax(idParticipante) {
            var parametros = "{'idParticipante': '" + idParticipante +
                                "'}";
            $.ajax(
                {
                    url: "Proceso/SAAPPEREX.aspx/fGetDatos",
                    data: parametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        datos = eval('(' + reponse.d + ')')

                        if (datos[0] != null) {
                            $('#txtFeIn').val(datos[0].sFInicio);
                            $('#txtFeFIn').val(datos[0].sFFinal);
                            $("#txtJustif").val(datos[0].sJustificacion);
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                });
        }

        ////////////////////////////////////////////////////////////////////////////////////////
        function FMI(fecMen, fecMay) {// FUNCIÓN PARA VALIFAR LAS FECHAS
            fi = fecMen;
            ff = fecMay;
            diaInicial = fi.substring(0, 2);
            mesInicial = fi.substring(3, 5);
            añoInicial = fi.substring(6, 10);
            diaFinal = ff.substring(0, 2);
            mesFinal = ff.substring(3, 5);
            añoFinal = ff.substring(6, 10);

            if (añoInicial > añoFinal) {
                return 0;
            }
            else if (añoFinal > añoInicial) {
                return 1;
            }
            else if (mesInicial > mesFinal && diaInicial >= diaFinal) {
                return 0;
            }
            else if (mesInicial > mesFinal) {
                return 0;
            }
            else if (mesInicial == mesFinal && diaInicial > diaFinal) {
                return 0;
            }
            else if (mesInicial <= mesFinal && diaInicial <= diaFinal) {
                return 1;
            }
            else if (mesFinal > mesInicial && diaInicial > diaFinal) {
                return 1;
            }
            else {
                return 1;
            }
        }



        ////////////////////////////////////////////////////////////////////////////////////////
        function pGuardar() {//FUNCIÓN QUE VALIDA ANTES DE GUARDAR LAS FECHAS EXTEMPORANEAS DE LA DEPENDENCIA
            var justExtemp = $("#txtJustif").val();
            justExtemp = justExtemp.replace(/\n\r?/g, ' ');
            justExtemp = justExtemp.replace(/'/g, '');
            $("#txtJustif").val(justExtemp);

            var fechaInicial = $("#txtFeIn").val();
            var fechaFinalExt = $("#txtFeFIn").val();

            if ($("#txtFeIn").val() != "" && $("#txtFeFIn").val() != "" && $("#txtJustif").val() != "") {
                if (FMI(fechaInicial, fechaFinal)) {
                    $.alerts.dialogClass = "infoAlert";
                    jAlert("No se puede guardar la configuración ya que la fecha inicial de apertura extemporánea no puede ser menor o igual a la fecha final de la apertura del proceso.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
                else if (FMI(fechaFinalExt, fechaInicial)) {
                    if (FMI(fechaFinal, fechaInicial) && FMI(fechaInicial, fechaFinalExt) && fechaInicial == fechaFinalExt) {
                        loading.ini();
                        fGuardar();
                    }
                    else {
                        $.alerts.dialogClass = "infoAlert";
                        jAlert("No se puede guardar la configuración ya que la fecha final de apertura extemporáneo no puede ser menor a la fecha inicial de la apertura extemporáneo.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
                else
                    if (FMI(fechaFinal, fechaInicial) && FMI(fechaInicial, fechaFinalExt)) {
                        loading.ini();
                        fGuardar();
                    }
            }
            else {
                jAlert("Debe llenar todos los campos", 'SISTEMA DE ENTREGA - RECEPCIÓN');
            }
        }


        function fGuardar() {//FUNCIÓN QUE EJECUTA LA ACCIÓN DE GUARDAR LAS FECHAS ESTEMPORANEAS
            nIdParticipante = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nIdParticipante; //id del partcipante
            idProcExtem = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].idProcExtem;
            sJustificacion = $("#txtJustif").val();
            var nIdUsuario = $("#hf_idUsuario").val();
            var variables = "{'nIdParticipante': '" + nIdParticipante +
                             "','sJustificacion': '" + sJustificacion +
                             "','idProcExtem': '" + idProcExtem +
                             "','sFeIn': '" + $('#txtFeIn').val() +
                             "','sFeFIn': '" + $('#txtFeFIn').val() +
                             "','nIdUsuario': '" + nIdUsuario +
                                "'}";
            $.ajax({
                url: "Proceso/SAAPPEREX.aspx/fGuardaPerExt",
                data: variables,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    try {
                        var resp = reponse.d;
                        var separar = resp.split(',');
                        var respuesta = separar[0];
                        var idPart = separar[1];

                        switch (respuesta) {
                            case '0': //ERROR
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN'); //No se pudo guardar la configuración
                                break;
                            case '1': //ACCIÓN REALIZADA CORRÉCTAMENTE
                                loading.close();
                                NG.repinta();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("El periodo extemporáneo ha sido guardado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN', function (r) {
                                    if (r) {
                                        fRegresar(idPart); //me regresa a la página anterior
                                    }
                                });
                                break;
                        }
                    }
                    catch (err) {
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }

                },
                beforeSend: loading.iniSmall(),
                complete: function () {
                    loading.closeSmall();
                },
                error: //errorAjax
                 function (result) {
                     loading.closeSmall();
                     $.alerts.dialogClass = "errorAlert";
                     jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                 }
            });
        }

        function fRegresar(idPart) {//ESTA FUNCIÓN REGRESA A LA FORMA ANTERIOR CUANDO SE GUARDO CORRECTAMENTE EL PERIODO EXTEMPORÁNEO
            loading.ini();
            if (indicadorPagina == 'H') {
                NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nIdParticipante = idPart;
                urls(5, "Proceso/SAAPARTIHIS.aspx");
            } else {
                NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nIdParticipante = idPart;
                urls(5, "Proceso/SAAPARTIC.aspx");
            }
        }

        function fCancelar() {//FUNCIÓN QUE ME REGRESA A LA PÁGINA ANTERIOR 
            loading.ini();
            if (indicadorPagina == 'H') {
                urls(5, "Proceso/SAAPARTIHIS.aspx");
            } else {
                urls(5, "Proceso/SAAPARTIC.aspx");
            }
        }

        function fActivarGuardar() {//ACTIVA EL BOTÓN DE GUARDAR
            if ($("#txtFeIn").val() != "" && $("#txtFeFIn").val() != "" && $("#txtJustif").val() != "") {
                $("#Btn_Guardar2,#Btn_Cancelar2").hide();
                $("#Btn_Guardar,#Btn_Cancelar").show();
            }
        }

        function limita(elEvento, maximoCaracteres) {
            var elemento = document.getElementById("txtJustif");
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

        function actualizaInfo(maximoCaracteres) {
            var elemento = document.getElementById("txtJustif");
            var info = document.getElementById("info");

            if (elemento.value.length >= maximoCaracteres) {
                info.innerHTML = "Máximo de" + maximoCaracteres + " caracteres";
            }
            else {
                info.innerHTML = "Quedan" + (maximoCaracteres - elemento.value.length) + " caracteres por escribir";
            }
        }

    </script>
    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">
                Periodos extemporáneos</label>
        </div>
        <h2>
            Proceso entrega - recepción:</h2>
        <label id="lblProcER">
        </label>
        <br />
        <h2>
            Dependencia / entidad:</h2>
        <label id="lblDepcia">
        </label>
        <h2>
            Periodo del proceso:</h2>
        <label id="lblFechasPeriodo">
        </label>
        <br />
        <div class="instrucciones">
            Ingrese los datos correspondientes para configurar el periodo extemporáneo:</div>
        <br />
        <h3>
            Fecha inicio:</h3>
        <input type="text" id="txtFeIn" required="required" onchange="fActivarGuardar()" />
        <div class="requerido">
            * Campo Requerido</div>
        <h3>
            Fecha fin:</h3>
        <input type="text" id="txtFeFIn" onchange="fActivarGuardar()" />
        <div class="requerido">
            * Campo Requerido</div>
        <h3>
            Justificación:</h3>
        <div class="align_Textarea">
            <textarea id="txtJustif" cols="100" rows="10" maxlength="500" onkeypress="fActivarGuardar()"></textarea>
            <div class="requerido">
                * Campo Requerido</div>
        </div>
        <%--       <h3>Justificación:</h3>
            <div class="align_Textarea">             
                <textarea id="txtJustif" name="observaciones" onkeypress="return limita(event, 500);" onkeyup="actualizaInfo(500)" rows="10" cols="100"></textarea>                
                <div id="info">Máximo de 500 caracteres</div>
                <div class="requerido">* Campo Requerido</div>
            </div>--%>
        <br />
        <div class="a_botones">
            <a title="Botón Guardar" id="Btn_Guardar" class="btnAct" href="javascript:pGuardar();">
                Guardar</a> <a title="Botón Cancelar" id="Btn_Cancelar" class="btnAct" href="javascript:fCancelar();">
                    Cancelar</a>
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_indicadorPagina" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
