<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_SAAGUIAER" Codebehind="SAAGUIAER.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%--<script src="../scripts/Libreria.js" type="text/javascript"></script>--%>


</head>
<body>
    <script type="text/javascript">
        var strAccion = ""; // Variable de Acción
        var intSeleccionado; //Permitirá reasignar los datos al radio button
        var strCadena = "";

        var Sort_SAAGUIAER = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAGUIAER[0] = [{ "bSortable": false }, null, null, null, null];
        Sort_SAAGUIAER[1] = [[2, "asc"]];

        /***********     Botones de Acción     ***********/

        BotonesGuiasER = function (selec) {
            if (selec > 0) //Seleccionado 
            {
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccAsignarApartado, #AccModificarDisponibilidad, #AccModificarVigencia,#AccModificarVigenciab, #AccReportes").show();
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccAsignarApartado2, #AccModificarDisponibilidad2, #AccModificarVigencia2,#AccModificarVigencia2b, #AccReportes2").hide();
            }
            else //No Seleccionado
            {
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccAsignarApartado2, #AccModificarDisponibilidad2, #AccModificarVigencia2,#AccModificarVigencia2b, #AccReportes2").show();
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccAsignarApartado, #AccModificarDisponibilidad, #AccModificarVigencia,#AccModificarVigenciab, #AccReportes").hide();
            }
        }

        /***********     Document ready     ***********/
        $(document).ready(function () {
            NG.setNact(1, 'Uno', BotonesGuiasER);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            //console.log(NG.Var[NG.Nact].datoSel);
            if (NG.Var[NG.Nact].datoSel == null) {
                $('#grid').empty();
                fGetGuias();
            } else {
                //NG.repinta();

                if (NG.Var[NG.Nact].repinta == "N") {

                    $('#grid').empty();
                    fGetGuias();
                    NG.Var[NG.Nact].repinta = null;
                }

                if (NG.Var[NG.Nact].repinta == "S") {
                    NG.repinta();
                    NG.Var[NG.Nact].repinta = null;

                }

            }
        });

        /***********     Fin ready     ***********/

        /***********     Función Ajax Obtener Guias     ***********/

        //Función AJAX que obtiene la lista de Guías de la Base de Datos
        function fGetGuias() {
            var strDatos = "{" +
                        "\"strAccion\": \"OBTENER_GUIAS\" " +
                        "}";
            objGuias = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objGuias: objGuias });

            $.ajax(
        {
            url: "Guia/SAAGUIAER.aspx/pGetDatosGuias",
            data: actionData,
            dataType: "json",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function (reponse) {
                //console.log(eval('(' + reponse.d + ')'));
                Pinta_Grid(eval('(' + reponse.d + ')'));

                                strCadena = eval('(' + reponse.d + ')');
                                if (strCadena.laGuiasER != null && NG.Var[NG.Nact].datoSel != null) {
                                    //Con esto actualizamos el dato selccionado del GRID
                                    a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
                                    NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                                }
            },
            beforeSend: loading.ini(),
            complete: loading.close(),
            error: errorAjax
        });
        }

        /***********     Fin Función Ajax Obtener Guias    ***********/


        /***********     Función Pintar Grid Guias     ***********/

        //Función para asignar las propiedades del DataTable
        function Pinta_Grid(strCadena) {
            //console.log(strCadena);
            $('#grid').empty();

            mensaje = { "mensaje": "No existen guías configurados." }
            if (strCadena.laGuiasER == null) {
                //alert("if");
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(strCadena.laGuiasER));

            NG.tr_hover();
            tooltip.iniToolD('25%');
            NG.Var[NG.Nact].oTable = $('#grid')
            //NG.Var[NG.Nact].oTable = jQuery('#grid')
                                    .dataTable({
                                        "sPaginationType": "full_numbers",
                                        "bLengthChange": true,
                                        "aaSorting": Sort_SAAGUIAER[1],
                                        "aoColumns": Sort_SAAGUIAER[0]
                                    });
            //NG.Var[NG.Nact].oTable = lTable;
        }

        /***********     Fin Función Pintar Grid Guias    ***********/

        //Función para Pintar la Tabla de Guías
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort"  scope="col" style="width:4%;"></th>';
            htmlTab += '<th  scope="col" style="width:5%;" class="sorting" title="Ordenar">Clave</th>';
            htmlTab += '<th  scope="col" style="width:60%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th  scope="col" style="width:20%;" class="sorting" title="Ordenar">A partir de la fecha</th>';
            htmlTab += '<th  scope="col" style="width:20%;" class="sorting" title="Ordenar">Vigencia</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            //Ciclo de Control para Checkbox
            for (a_i = 2; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
                    intSeleccionado = a_i;
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                    //intSeleccionado = a_i;
                }

                //                htmlTab += '<td class="sorts Acen">' + tab[a_i].strGuiaER + '</td>';
                //                htmlTab += '<td class="sorts">' + tab[a_i].strDGuiaER + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].strGuiaER.toUpperCase() + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].strDGuiaER.toUpperCase() + '</td>';

                //htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFVigente + '</td>';

                if (tab[a_i].dteFVigente == '') {
                    tab[a_i].dteFVigente = "FECHA NO DEFINIDA";
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFVigente + '</td>';

                if (tab[a_i].chrIndVigente == 's' || tab[a_i].chrIndVigente == 'S') {
                    tab[a_i].chrIndVigente = "VIGENTE";
                }

                if (tab[a_i].chrIndVigente == 'n' || tab[a_i].chrIndVigente == 'N') {
                    tab[a_i].chrIndVigente = "NO VIGENTE";
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].chrIndVigente + '</td>';
                htmlTab += '</td>';
                htmlTab += "</tr>";
            }
            htmlTab += "</tbody>";
            return htmlTab;
        }
        
        //Función para Cambiar la Selección de un Radio Button 
        function fCambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            //console.log(NG.Var[NG.Nact].datoSel);
            //console.log(NG);
        };

        //Función Ajax para Eliminar una Guia de la Base de Datos
        function pEliminar_Guia() {
            var intValorID = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idGuiaER;
            var strValorDescripcion = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strDGuiaER;
            strAccion = "ELIMINAR";
            $.alerts.dialogClass = "infoConfirm";
            jConfirm('La guía ' + strValorDescripcion + ' será eliminada. \n\n¿Está seguro que desea eliminarla?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    var actionData = "{'IdGuia': '" + intValorID + "','strAccion': '" + strAccion + "','intUsuario': '" + $('#hf_idUsuario').val() + "'}";
                    loading.ini();
                    $.ajax(
                    {

                        url: "Guia/SAAGUIAER.aspx/fEliminar_Guia",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            switch (reponse.d) {
                                case 1:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede eliminar el registro de la guía actual, puesto que la Guía esta Vigente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        //$('#grid').empty();
                                        //NG.Var[NG.Nact].oTable.fnDestroy();
                                        //fCambia(NG.Var[NG.Nact].selec);
                                        //fGetGuias();
                                    });
                                    break;
                                case 2:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede eliminar el registro de la guía actual, puesto que esta asignado a uno o varios procesos activos.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        //$('#grid').empty();
                                        //NG.Var[NG.Nact].oTable.fnDestroy();
                                        //fCambia(NG.Var[NG.Nact].selec);
                                        //fGetGuias();
                                    });
                                    break;
                                case 3:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede eliminar el registro de la guía actual, puesto que tiene participantes asignados a un proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        //$('#grid').empty();
                                        //NG.Var[NG.Nact].oTable.fnDestroy();
                                        //fCambia(NG.Var[NG.Nact].selec);
                                        //fGetGuias();
                                    });
                                    break;
                                case 4:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede eliminar el registro de la guía actual, puesto que tiene apartados activos asignados a la guía.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {

                                        //$('#grid').empty();
                                        //NG.Var[NG.Nact].oTable.fnDestroy();
                                        //fCambia(NG.Var[NG.Nact].selec);
                                        //fGetGuias();
                                    });
                                    break;
                                case 5:
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("La guía seleccionada se ha eliminado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        $('#grid').empty();
                                        NG.Var[NG.Nact].oTable.fnDestroy();
                                        fCambia(NG.Var[NG.Nact].selec);
                                        fGetGuias();
                                    });
                                    break;
                                case 6:
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("La guía seleccionada se ha eliminado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                        $('#grid').empty();
                                        NG.Var[NG.Nact].oTable.fnDestroy();
                                        fCambia(NG.Var[NG.Nact].selec);
                                        fGetGuias();
                                    });
                                    break;
                                case 0:
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                        fGetGuias();
                                        //Regresar();
                                    });
                                    break;
                                default:
                            }

                        },
                        //beforeSend: loading.ini(),
                        //complete: loading.close(),
                        error: function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });  // FIN DEL AJAX


                }
                else {

                }
            });            // FIN DEL jConfirm           
        }

        //Función para preguntar si se desea quitar la disponilidad de la Guía [No se usa Actualmente]
        function pPreguntarEstado() {
            var estado = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].chrIndActivo;
            var bandera = false;

            if (estado == 'SI') {
                $.alerts.dialogClass = "infoConfirm";
                jConfirm('¿Desea quitar la disponibilidad de la Guía?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                    if (r) {
                        var Indicador = "N";
                        pModificar_EdoGuia(Indicador);
                    }
                });
            }
        }

        //Función Ajax para quitar la disponibilidad de la Guía [No se usa Actualmente]
        function pModificar_EdoGuia(Ind) {
            var valorId2 = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idGuiaER;
            var valorDescripcion2 = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strDGuiaER;
            strAccion = "ESTADO";

            //var actionData = "{'IdGuia': '" + valorId2 + "','chrIndicador': '" + Ind + "','strAccion': '" + strAccion + "'}";
            var actionData = "{'IdGuia': '" + valorId2 + "','chrIndicador': '" + Ind + "','strAccion': '" + strAccion + "','intUsuario': '" + $('#hf_idUsuario').val() + "'}";
            $.ajax(
                    {
                        url: "Guia/SAAGUIAER.aspx/fEstado_Guia",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            //console.log(reponse.d);
                            switch (reponse.d) {
                                case 1:
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede modificar la disponibilidad de la guía actual, puesto que la guía esta vigente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    break;
                                case 2:
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede modificar la disponibilidad de la guía actual, puesto que esta asignado a uno o varios procesos.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    break;
                                case 3:
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se puede modificar la disponibilidad de la guía actual, puesto que ya tiene anexos asignados a un proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    break;
                                case 4:
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("La disponibilidad de la guía actual se ha modificado correctamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    break;
                                case 0:
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                    break;


                                default:
                            }

                            pActualizarGrid();
                        },
                        beforeSend: loading.ini(),
                        complete: loading.close(),
                        error: function (result) {
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });   // FIN DEL AJAX

        }

        //Función para Actualizar el Grid de las Guías
        function pActualizarGrid() {
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            //Ajax();
            fGetGuias();

            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        //Función para ir a la forma de Alta Guía
        function fGuia() {
            urls(3, "Guia/SAAGUIAERH.aspx");
        }

        //Función para ir a la forma de Apartados
        function fApartados() {
            urls(3, "Guia/SAAAPARTA.aspx");
        }

        //Función para ir a la Ventana Modal para cambiar la Vigencia de la Guía
        function pVigencia() {
            //Asigno mis datos que voy a pasar a la forma hija(iFrame)
            var intIDGuia = NG.Var[NG.Nact].datoSel.idGuiaER;
            var strFechaVigente = NG.Var[NG.Nact].datoSel.dteFVigente;
            var chrIndicadorVigencia = NG.Var[NG.Nact].datoSel.chrIndVigente;
            
            //Asigno los valores a mis campos hidden de esta forma
            $("#hf_IdGuiaER").val(intIDGuia);
            $("#hf_fechaVigente").val(strFechaVigente);
            $("#hf_IndicadorVigencia").val(chrIndicadorVigencia);

            //Pasar las variables por Url
            /*
            a_tip = [
            { tit: 'INVALIDAR DASHBOARD', arc: strmod1 + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idGuiaER }
            ];
            */

            //Ventana Dialog                
            dTxt = '<div id="dComent" title="Cambiar vigencia de la Guía">';
            dTxt += '<iframe id="fr_SAAVIGGUI" src="Guia/SAAVIGGUI.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SAAGUIAER').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 300,
                width: 600,
                modal: true,
                resizable: false
                ,
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }

            });
        }

        //Función para Cerrar la Ventana Modal de Cambio de Vigencia de la guía
        function CloseNotesDialog() {
            //alert("Hola");
            return false;
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function cerrarPresp() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
            //$("input:radio").removeAttr("checked");
            //NG.Var[NG.Nact].datoSel = null;
            //$('#ch_' + NG.Var[NG.Nact].selec).attr('checked', false);
            //pActualizarGrid();
            //$('#ch_' + NG.Var[NG.Nact].selec).attr('checked', true);      
            //                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
            //                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
            //pActualizarGrid();
        }

        //Función que actualiza el grid del dato seleccionado en el radio
        function pActualizarDatos() {
            a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
            NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
            //pActualizarGrid();
        }

        //Función que reemplaza los datos de la guía, con los nuevos datos traido del ajax en el Grid
        function fActualizaGuia(strCadena) {

            //NG.repinta();

            NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].dteFVigente = strCadena.dteFVigente;
            NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].chrIndVigente = strCadena.chrIndVigente;
            NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idGuiaER = strCadena.idGuiaER;

            NG.Var[NG.Nact].datoSel.dteFVigente = strCadena.dteFVigente;
            NG.Var[NG.Nact].datoSel.chrIndVigente = strCadena.chrIndVigente;
            NG.Var[NG.Nact].datoSel.idGuiaER = strCadena.idGuiaER;

            //            if (NG.Var[NG.Nact].oSettings != null) {
            //                NG.Var[NG.Nact].oTable.fnDestroy();
            //            }
            NG.repinta();
        }

        //Función para Abrir el Reporte de las Guías
        function Reporte(op) {
            $("#hf_operacion").val(op);
            idGuia = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idGuiaER;
            //console.log(hf_operacion);
            //alert("1");
            dTxt = '<div id="dComent2" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idGuia=' + idGuia + '&op=GUIAS' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SAAGUIAER').append(dTxt);
            $("#dComent2").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //700,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true,
                close: function (event, ui) {
                    fCerrarDialog();
                }
            });
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent2').dialog("close");
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
        }

    </script>

    <form id="SAAGUIAER" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Guías</label>
                <div class="a_acciones">
                    <a id="AccAgregar" title="Agregar" href="Javascript:fGuia();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                    <a id="AccModificar" title="Modificar" href="Javascript:fGuia();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                    <a id="AccEliminar" title="Eliminar" href="javascript:pEliminar_Guia();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>
            
                    <a id="AccAsignarApartado" title="Asignar Apartado" href="javascript:fApartados();" class="accAct iOculto">Asignar apartado</a>
                    <a id="AccAsignarApartado2" title="Asignar Apartado" class="accIna">Asignar apartado</a>

                     <a id="AccModificarVigenciab" title="Modificar Vigencia" href="javascript:pVigencia();" class="accAct iOculto">Vigencia</a>
                    <a id="AccModificarVigencia2b" title="Modificar Vigencia" class="accIna">Vigencia</a>

<%--                <a id="AccModificarDisponibilidad" title="ModificarDisponibilidad" href="j avascript:pPreguntarEstado();" class="accAct iOculto">Disponibilidad</a>
                    <a id="AccModificarDisponibilidad2" title="ModificarDisponibilidad" class="accIna">Disponibilidad</a>--%>

                    <a id="AccReportes" title="Reportes de guías" href="javascript: Reporte('GUIAS');" class="accAct iOculto">Reporte</a>                                                   
                    <a id="AccReportes2" title="Reportes de guías" class="accIna">Reporte</a>

                    <asp:HiddenField ID="hf_idUsuario" runat="server" />

                    <input type="hidden" id="hf_IdGuiaER"/>
                    <input type="hidden" id="hf_fechaVigente"/>
                    <input type="hidden" id="hf_IndicadorVigencia"/>

                </div>
            </div>
            <div class="instrucciones">Seleccione una guía para realizar la acción correspondiente.</div>
        
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
            </div>
        </div>

    </form>

</body>
</html>