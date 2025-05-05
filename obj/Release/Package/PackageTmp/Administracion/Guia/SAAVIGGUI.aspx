<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAVIGGUI" Codebehind="SAAVIGGUI.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">    
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>
    <link href="../../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="../../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../../scripts/jquery-ui-1.9.2.custom.min.js" type="text/javascript"></script>
    <script src="../../scripts/jquery.maskedinput.js" type="text/javascript"></script>
    <script src="../../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../../scripts/Libreria.js" type="text/javascript"></script>
</head>
<script type="text/javascript">
        //Variables globales
        var intIDGuiaSelec;
        var intIndVigencia;
        var intIndVigencia2;
        var intIDUsuario;
        var blnBandera;

        var strAccion = "";
        //Pasa valores del calendario a español
        vDate = {
            //dateFormat: 'yy-mm-dd',
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

        $(document).ready(function () {
            //Oculto la etiqueta de Fecha
            $("#div_txtdVigente2").css("visibility", "hidden");

            //llamo a mi metodo para verificar si hay alguna guia vigente

            //Asignar a mi input el componente datepicker
            $('#txt_dFVigente').datepicker(vDate);

            //Obtengo mi id de guia del Padre
            intIDGuiaSelec = $("#hf_IdGuiaER", parent.document).val();
            
            //Asigno la fecha obtenida de la forma padre a mi input text de fecha
            $("#txt_dFVigente").val($("#hf_fechaVigente", parent.document).val());

            //Asigno el valor del usuario de session de la forma padre a mi variable
            intIDUsuario = $("#hf_idUsuario", parent.document).val();

            //Obtengo mi indicador de Vigencia
            intIndVigencia = $("#hf_IndicadorVigencia", parent.document).val();
            if (intIndVigencia = "VIGENTE")
            { intIndVigencia = "S" }
            if (intIndVigencia = "NO VIGENTE")
            { intIndVigencia = "N" }

            //Obtengo mi indicador de Vigencia otra vez
            intIndVigencia2 = $("#IndicadorVigencia", parent.document).val();
            //            var valor = $("#theOptions").val();
            //            alert(intIndVigencia2)
            //            alert(valor)
            //Verifica la vigencia de la guía actual y habilita la opción del combo de acuerdo a la validación
            fVerificarVigencia();
        });

        //Función Ajax para Verificar la Vigencia de la Guía
        function fVerificarVigencia() {

            var strDatos = "{'idGuiaER': '" + intIDGuiaSelec +
                             "'}";

            objGuia = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objGuia: objGuia });

            $.ajax(
                {
                    url: "SAAVIGGUI.aspx/Guias_Vigentes",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(reponse);
                        if (reponse.d) {
                            //console.log("Guia Vigente");
                            $('#theOptions option[value=VIGENTE]').attr('selected', true);
                            blnBandera = true;
                        }
                        else {
                            //console.log("Guia No Vigente");
                            blnBandera = false;
                            $('#theOptions option[value=VIGENTE]').attr('selected', false);
                            $("#theOptions option[value='VIGENTE']").attr('disabled', 'disabled');
                        }
                        //Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    //beforeSend: alert("beforeSend"),
                    complete: loading2.close(),
                    error: errorAjax
                });
        }

        //Función para Actualizar la Vigencia de la Guía
        function fActualizarVigencia() {
            //fAccionVigencia();

            //Verifico la acción que se realizara en el procedimiento almacenado, dependiento de la guia
            var valor = $("#theOptions").val();
            //alert(valor);
            if (valor == "VIGENTE")
            { intIndVigencia = "S" }
            if (valor == "NO VIGENTE")
            { intIndVigencia = "N" }


            if (blnBandera == true) {

                strAccion = "CAMBIAR_VIGENCIA"
            }
            else {

                strAccion = "FECHA_VIGENCIA"
            }

            var strDatos = "{'idGuiaER': '" + intIDGuiaSelec +
                              "','strAccion': '" + strAccion +
                              "','intUsuario': '" + intIDUsuario +
                              "','dteFVigente': '" + ($('#txt_dFVigente').val() != '' ? $('#txt_dFVigente').val() : '') +
                             "','chrIndVigente': '" + intIndVigencia +
                             "'}";

            objGuia = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objGuia: objGuia });
            //console.log(actionData);

            $.ajax(
                {
                    url: "SAAVIGGUI.aspx/Actualizar_Vigencia",
                    data: actionData,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //fActualizaGuias();
                        //parent.window.fActualizaAnexo(objJSON);
                        //parent.window.fActualizaAnexo(objGuia);

                        var cadena = eval('(' + reponse.d + ')');
                        window.parent.fActualizaGuia(cadena);
                        //loading2.close();

                        switch (cadena.strRespuesta) {
                            case "1":
                                loading2.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("La vigencia de la guía actual se ha modificado correctamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                    fCerrarModal();
                                });
                                break;
                            case "2":
                                loading2.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("La fecha de vigencia de la guía actual se ha modificado correctamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                    fCerrarModal();
                                });
                                break;
                            case "3":
                                loading2.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("No se puede cambiar la vigencia de la guía ya que tiene procesos activos configurados, únicamente se ha actualizado la fecha.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                    fCerrarModal();
                                });
                                break;
                            case "4":
                                loading2.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("La guía se ha modificado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                    fCerrarModal();
                                });
                                break;
                            case "5":
                                loading2.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () { //Los datos no se actualizaron.
                                    fCerrarModal();
                                });
                                break;
                            case "6":
                                loading2.close();
                                $.alerts.dialogClass = "correctoAlert";
                                jAlert("La guia ya esta actualizada, ingrese de nuevo.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () { //Los datos no se actualizaron.
                                    fActualizaAjax();
                                });
                                break;
                        }
                        //console.log(reponse);
                        //Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    //beforeSend: alert("beforeSend"),
                    //complete: loading.close(),
                    error: function (result) {
                        loading2.close();
                        jAlert("Ha sucedido un error inesperado, no se pudo crear el proceso, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                });
        }

        //Función para Cerrar la Ventana Modal
        function fCerrarModal() {
            window.parent.cerrarPresp();
        }

        //Función para Actualizar los datos en la forma Padre
        function fActualizaGuias() {
            window.parent.ActualizarDatos();
        }

        //Función para Actualizar el Grid en la forma Padre
        function fActualizaAjax() {
            window.parent.ActualizarGrid();
        }

        //Función para Asignar la acción al actualizar la Vigencia  
        function fAccionVigencia() {
            //Obtengo el valor del combo seleccionado
            var valor = $("#theOptions").val();

            if (intIndVigencia2 == "VIGENTE") {

                if (intIndVigencia2 == valor)
                { strAccion = "CAMBIAR_VIGENCIA" }
                else
                { strAccion = "CAMBIAR_VIGENCIA" }
            }

            if (intIndVigencia2 == "NO VIGENTE")

               { strAccion = "FECHA_VIGENCIA" }

           }

           //Validación de Espacios en Blanco
           function fValidaDatos() {

               if (isValidDate($("#txt_dFVigente").val()) == true || $("#txt_dFVigente").val() == "") {
                   $("#div_txtdVigente2").css("visibility", "hidden");
                   loading2.ini();
                   fActualizarVigencia()
               }
               else {
                   //alert("Fecha Incorrecta");
                   $("#div_txtdVigente2").css("visibility", "visible");
               }  

           }

           //Función para Validar la Fecha
           function isValidDate(subject) {
               //if (subject.match(/^(?:(0[1-9]|1[012])[\- \/.](0[1-9]|[12][0-9]|3[01])[\- \/.](19|20)[0-9]{2})$/)) {
               if (subject.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/)) {
                   return true;
               } else {
                   return false;
               }
           }    
    </script>
<body>   
    <form id="fr_SAAVIGGUI" runat="server">
        <div id="agp_contenido"> 
             
            <h2>Vigencia:</h2>
            <select name="vigencia" id="theOptions">
                <option id="NoVigente" value="NO VIGENTE" selected="DEFAULT">NO VIGENTE</option>
                <option id="Vigente" value="VIGENTE" selected="DEFAULT">VIGENTE</option>
            </select>

            <div id="FechaVigente">
            <h2>A partir de la fecha:</h2> <input type="text" id="txt_dFVigente" size="30"/> <div id="div_txtdVigente2" class="requeridog">* Formato de Fecha Incorrecta</div>
            </div>   
            
            <br /><br />

            <div class="a_botones_modal">
                <a title="Botón Guardar" id="btnGuardar" href="Javascript:fValidaDatos();" class="btnAct">Guardar</a>
                <a title="Botón Cancelar" id="btnCerrar" href="Javascript:fCerrarModal();" class="btnAct">Cancelar</a>
            </div>
        </div>
    </form>

</body>
</html>
