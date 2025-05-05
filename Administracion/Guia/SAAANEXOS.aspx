<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAANEXOS" Codebehind="SAAANEXOS.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var strAccion; // Variable de strAccion
        var intIdGuia; // id de la Guia
        var intIdApartado; //id del apartado seleccionado
        var strDescApartado; //descripcion del Apartado Seleccionado

        /***********     Fin ready     ***********/

        var Sort_SAAANEXOS = new Array(2);
        Sort_SAAANEXOS[0] = [{ "bSortable": false }, null, null, null, null, null, null, null, null, null];
        Sort_SAAANEXOS[1] = [[8, "asc"]];

        /***********     Botones de Accion     ***********/

        BotonesAnexos = function (selec) {
            if (selec > 0) //Seleccionado 
            {
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccAsignarAnexos,#AccReportes").show();
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccAsignarAnexos2,#AccReportes2").hide();
            }
            else //No Seleccionado
            {
                $("#AccAgregar, #AccModificar2, #AccEliminar2, #AccAsignarAnexos2,#AccReportes2").show();
                $("#AccAgregar2, #AccModificar, #AccEliminar, #AccAsignarAnexos,#AccReportes").hide();
            }
        }

        /***********     Document ready     ***********/

        $(document).ready(function () {
            NG.setNact(3, 'Tres', BotonesAnexos);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            $("#lbl_Guia").text(NG.Var[NG.Nact - 2].datoSel.strDGuiaER.toUpperCase());
            $("#lbl_Apartado").text(NG.Var[NG.Nact - 1].datoSel.strDescApartado.toUpperCase());
            $("#lbl_Clave").text(NG.Var[NG.Nact - 1].datoSel.strApartado.toUpperCase());
            //console.log(NG.Var[NG.Nact - 1].datoSel);

            intIdGuia = NG.Var[NG.Nact - 2].datoSel.idGuiaER;
            intIdApartado = NG.Var[NG.Nact - 1].datoSel.idApartado;

            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);


            if (NG.Var[NG.Nact].datoSel == null) {

                $('#grid').empty();
                fGetAnexos(intIdApartado);

            } else {

                if (NG.Var[NG.Nact].repinta == "N") {
                    //console.log("Repinta: Ajax");
                    $('#grid').empty();
                    fGetAnexos(intIdApartado);
                    NG.Var[NG.Nact].repinta = null;
                    //$('#ch_' + NG.Var[NG.Nact].selec).attr('checked', false);
                }

                if (NG.Var[NG.Nact].repinta == "S") {
                    //NG.Var[NG.Nact].oTable.fnDestroy();
                    NG.repinta();
                    NG.Var[NG.Nact].repinta = null;
                }
                //fGetAnexos(intIdApartado);
            }
        });

        /***********     Función Ajax Obtener Anexos     ***********/

        //Función para obtener la Lista de Anexos de la Base de Datos
        function fGetAnexos(intIdApartado) {
            var strDatos = "{" +
                                "\"strAccion\": \"ANEXOS\" " + ",\"idApartado\": " + intIdApartado +
                                "}";

            objAnexos = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objAnexos: objAnexos });
            //console.log(actionData);

            $.ajax(
                {
                    url: "Guia/SAAANEXOS.aspx/pGetDatosAnexos",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        Pinta_Grid(eval('(' + reponse.d + ')'));

                        var cadena = eval('(' + reponse.d + ')');

                        if (NG.Var[NG.Nact].repinta == "N") {
                            //Con esto actualizamos el dato selccionado del GRID ;
                            a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
                            NG.Var[NG.Nact].datoSel = eval('(' + a_jp + ')')
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        /***********     Fin Función Ajax Obtener Anexos    ***********/


        /***********     Función Pintar Grid Anexos     ***********/

        //Función para asignar las propiedades del DataTable
        function Pinta_Grid(cadena) {
            //console.log(cadena);
            $('#grid').empty();
            //alert("Pinta_Grid");
            mensaje = { "mensaje": "No existen anexos configurados." }
            if (cadena.lstAnexo == null) {
                //alert("if");
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            else {
                //alert("else");
                $('#grid').append(pTablaI(cadena.lstAnexo));
            }

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAAANEXOS[1],
                "aoColumns": Sort_SAAANEXOS[0]
            });
        }

        /***********     Fin Función Pintar Grid Anexos    ***********/

        //Función para Pintar la Tabla de Anexos
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            //console.log(tab);
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Código</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Archivo</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Instructivo</th>';
            htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Url</th>';
            htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Aplicación</th>';
            htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Tipo</th>';
            htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Orden</th>';
            htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Integra Contraloría</th>';
            //htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Disponibilidad</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            //Ciclo de Control para Checkbox
            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" checked="checked" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';

                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';

                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].strCveAnexo.toUpperCase() + '</td>';
                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].strDAnexo.toUpperCase() + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].strDAnexo.toUpperCase() + '</div>';

                htmlTab += '</td>';

                if (tab[a_i].strFormato == "" || tab[a_i].strFormato == undefined) {
                    htmlTab += '<td class="sorts Acen">' + 'SIN ARCHIVO' + '</td>';
                }
                else {
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD">' + tab[a_i].strFormato.toUpperCase() + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].strFormato.toUpperCase() + '</div>';
                    htmlTab += '</td>';
                }

                if (tab[a_i].strInstructivo == "" || tab[a_i].strFormato == undefined) {
                    htmlTab += '<td class="sorts Acen">' + 'SIN INSTRUCTIVO' + '</td>';
                }
                else {
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD">' + tab[a_i].strInstructivo.toUpperCase() + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].strInstructivo.toUpperCase() + '</div>';
                    htmlTab += '</td>';
                }

                if (tab[a_i].chrFuente == 'U') {

                    var url = tab[a_i].strNOficial;

                    if (url.substring(0, 7) != 'http://') {

                        url = 'http://' + url;
                    }

//                    if (substring(url, 0, 7) != 'http://') {
//                        url = 'http://'+ url;
//                    }

                    //console.log(url);

                    //htmlTab += '<td class="sorts Acen">' + '<a target=\"_blank\" href="' + tab[a_i].strNOficial + '">' + "Ver" + '</a>' + '</td>';
                    htmlTab += '<td class="sorts Acen">' + '<a target=\"_blank\" href="' + url + '">' + "Ver" + '</a>' + '</td>';
                    //htmlTab += "<a title=\"Descarga Instructivo\" target=\"_blank\" href=\"../General/SGDDESCAR.aspx?guid=" + objAnexo.docGuia.gidFormato + "&strOpcion=FORMATO\">" + objAnexo.docGuia.strNomArchivo + "</a>"
                }
                else {
                    htmlTab += '<td class="sorts Acen">' + ' ' + '</td>';
                }

                //htmlTab += '<td class="sorts Acen">' + tab[a_i].chrAlcance.toUpperCase() + '</td>';
                if (tab[a_i].chrAlcance == 'G') {
                    htmlTab += '<td class="sorts Acen">' + 'ESPECIFICA' + '</td>';
                }
                else {
                    htmlTab += '<td class="sorts Acen">' + 'GENERAL' + '</td>';
                }

                //htmlTab += '<td class="sorts Acen">' + tab[a_i].chrTipo.toUpperCase() + '</td>';
                if (tab[a_i].chrTipo == 'P') {
                    htmlTab += '<td class="sorts Acen">' + 'PÚBLICA' + '</td>';
                }
                else {
                    if (tab[a_i].chrTipo == 'C') {
                        htmlTab += '<td class="sorts Acen">' + 'CONFIDENCIAL' + '</td>';
                    }
                    else {
                        htmlTab += '<td class="sorts Acen">' + 'RESERVADA' + '</td>';
                    }
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].intnOrden + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].cIndActa + '</td>';

                

            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }

        //Función para Cambiar la Seleccion de un Radio Button 
        function fCambia(selc) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selc);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            //console.log(NG.Var[NG.Nact].datoSel);
        };

        //Función para ir a la forma de Alta Anexos
        function fAnexos() {
            urls(3, "Guia/SAAANEXOSH.aspx");
        }

        //Función para ir a la forma de Asignacion de Anexos
        function fAsignacion() {
            urls(3, "Guia/SAAASIGNA.aspx");
        }

        //Función para ir a la forma principal de Apartados
        function fRegresar() {
            NG.Var[NG.Nact - 1].repinta = "S";
            urls(3, "Guia/SAAAPARTA.aspx");
        }

        //Función Ajax para Eliminar un Anexo de la Base de Datos
        function pEliminar_Anexo() {

            var idAnexo; //Variable utilizada para eliminar el anexo
            var strDAnexo; //Variable con la descripcion del Anexo

            idAnexo = NG.Var[NG.Nact].datoSel.idAnexo;
            strDAnexo = NG.Var[NG.Nact].datoSel.strDAnexo;

            strAccion = "ELIMINAR";
            $.alerts.dialogClass = "infoConfirm";
            jConfirm('El anexo ' + strDAnexo + ' será eliminado. \n\n¿Desea eliminar este registro?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {

                    var strDatos = "{'strAccion': '" + strAccion +
                                   "','idAnexo': '" + idAnexo +
                                   "','intNumUsuario': '" + $('#hf_idUsuario').val() +
                                   "'}";

                    objAnexos = eval('(' + strDatos + ')');
                    actionData = frms.jsonTOstring({ objAnexos: objAnexos });
                    //console.log(actionData);
                    loading.ini();
                    $.ajax(
                    {
                        url: "Guia/SAAANEXOS.aspx/fEliminar_Anexos",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {

                            switch (reponse.d) {
                                case 1:
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("El anexo se ha eliminado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                    $('#grid').empty();
                                    NG.Var[NG.Nact].oTable.fnDestroy();
                                    fCambia(NG.Var[NG.Nact].selec);
                                    fGetAnexos(intIdApartado);
                                    });
                                    break;
                                case 2:
                                    loading.close();
                                    $.alerts.dialogClass = "incompletoAlert";
                                jAlert("No se puede eliminar el registro de anexo actual, ya que se encuentra asignado a un proceso activo.", "SISTEMA DE ENTREGA - RECEPCIÓN", function () {
                                    });
                                    break;
                                case 0:
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                    fGetAnexos(intIdApartado);
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
            });     // FIN DEL jConfirm           
        }

        //Función para Actualizar el Grid de Anexos
        function fActualizarGrid() {
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            fGetAnexos(intIdApartado);
        }

        //Función para abrir el reporte de Anexos
        function Reporte(op) {
            $("#hf_operacion").val(op);
            idAnexos = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idAnexo;
            //console.log(hf_operacion);
            dTxt = '<div id="dComent2" title="Reportes - SERUV">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idAnexos=' + idAnexos + '&op=ANEXOS' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SAAANEXOS').append(dTxt);
            $("#dComent2").dialog({
                autoOpen: true,
                height: 700,
                width: 1000,
                modal: true,
                resizable: true
            });
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent2').dialog("close");
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
        }


     </script>

    <form id="SAAANEXOS" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion"> 
                <label class="titulo">Anexos</label>
                <div class="a_acciones">

                    <a id="AccAgregar" title="Agregar" href="Javascript:fAnexos();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                    <a id="AccModificar" title="Modificar" href="Javascript:fAnexos();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                    <a id="AccEliminar" title="Eliminar" href="javascript:pEliminar_Anexo();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>
            
                    <a id="AccAsignarAnexos" title="Asignar anexos" href="javascript:fAsignacion();" class="accAct iOculto">Asignación</a>
                    <a id="AccAsignarAnexos2" title="Asignar anexos" class="accIna">Asignación</a>

<%--                    <a id="AccReportes" title="Reportes de anexos" href="javascript: Reporte('ANEXOS');" class="accAct iOculto">Reportes</a>                                                   
                    <a id="AccReportes2" title="Reportes de anexos" class="accIna">Reportes</a>--%>
                 
                    <asp:HiddenField ID="hf_idUsuario" runat="server" />
                    <asp:HiddenField ID="hf_operacion" runat="server" />
                </div>
            </div>
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

            <div class="instrucciones">Seleccione un anexo para realizar la acción correspondiente.</div>

            <h2>Guía:</h2> <label id="lbl_Guia"></label>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <h2>Apartado:</h2> <label id="lbl_Clave"> </label> <label id="lbl_Apartado"></label>        

            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
            </div>
            <br />
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

        </div>
    </form>
</body>
</html>

