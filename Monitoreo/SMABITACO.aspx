<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SMABITACO" Codebehind="SMABITACO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
</head>
<body>
    <script type="text/javascript">
        var DatosGenerales = parent.datosGenerales;
        var Apartados = parent.apartados;

        $(document).ready(function () {
            loading.ini();
            NG.setNact(3, 'Tres');
            var intTotalAnexos = NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selc].integrados + NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selc].excluidos + NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selc].pendientes
            var dtFecha = new Date();
//            console.log(parent.datosGenerales);
            //console.log(parent.apartados);
            $("#lbl_Proceso").text(DatosGenerales[0].sDProceso);
            $("#lbl_Dependencia").text(DatosGenerales[0].sDDepcia);
            $("#lbl_Sobligado").text(DatosGenerales[0].usuarioObligado);
            $("#lbl_Fecha").text(dtFecha.getDate() + "-" + (dtFecha.getMonth() + 1) + "-" + dtFecha.getFullYear());
            $("#lbl_Integrados").text(DatosGenerales[0].anexIntegrados);
            $("#lbl_Avance").text(DatosGenerales[0].avanceGeneral.toFixed(2) + "%");
            $("#lbl_Excluidos").text(NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selc].excluidos);
            $("#lbl_Pendientes").text(NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selc].pendientes);
            $("#lbl_Total").text(intTotalAnexos);
            $("#lbl_Integrar").text(intTotalAnexos - NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selc].excluidos);
            fObtieneApartados();
            //fPintaApartados(Apartados);
            fPintaRecomendaciones();
            Obtiene();
            CambiaSelect();
//            loading.close();
        });

        // Función que obtiene los apartados con sus correspondientes anexos
        function fObtieneApartados(){
            var strParametros = "{'nIdParticipante':'" + DatosGenerales[0].nIdParticipante +
                                "'}";
            $.ajax({
                url: "SMABITACO.aspx/fObtieneApartados",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    fPintaApartados(eval('(' + reponse.d + ')'));
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error: function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        }

        // Función que pinta los apartados y anexos de la guía.
        function fPintaApartados(objJson) {
            strHTMLApAx = "";
            if (objJson != null) {
                strHTMLApAx += "<table id=\"tblObligaciones\" class=\"treetable\">";
                strHTMLApAx += "<caption>";
                strHTMLApAx += "<a href=\"#\" onclick=\"jQuery('#tblObligaciones').treetable('expandAll'); return false;\">Desplegar anexos <img src=\"../images/ico-expandir.png\" /></a>&nbsp;&nbsp;";
                strHTMLApAx += "<a href=\"#\" onclick=\"jQuery('#tblObligaciones').treetable('collapseAll'); return false;\">Agrupar anexos <img src=\"../images/ico-colapsar.png\" /></a>";
                strHTMLApAx += "</caption>";
                strHTMLApAx += "<thead>";
                strHTMLApAx += "<tr>";
                strHTMLApAx += "<th>Apartados/Anexos</th>";
                //strHTMLApAx += "<th>Estado</th>";
                strHTMLApAx += "<th>Avance</th>";
                strHTMLApAx += "<th>Recomendación</th>";
                strHTMLApAx += "<th>Detalle</th>";
                strHTMLApAx += "<th></th>";
                strHTMLApAx += "</tr>";
                strHTMLApAx += "</thead>";
                strHTMLApAx += "<tbody>";

                // AQUI SE RECORREN LOS APARTADOS Y ANEXOS
                for (i = 0; i < objJson.length; i++) {
                    strHTMLApAx += "<tr data-tt-id=\"" + objJson[i].idApartado + "\" class=\"collapsed\"><td><span style=\"padding-left: 0px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span>" +
                                (objJson[i].chrAplica == 'O' ?
                                    objJson[i].strApartado + " " + objJson[i].strDescApartado
                                    :
                                    objJson[i].strApartado + " " + objJson[i].strDescApartado + " (CONTRALORÍA)"
                                    ) +
                                    "</span></td><td></td><td></td><td></td><td></td>"; // +(fGetNumeroArchivosXapartado(Apartado) > 0 ? "<td><a href=\"../General/SGDCARZIP.aspx?strOpcion=apartado&participante=" + Apartado.nIdParticipante + "&proceso=" + Apartado.nIdProceso + "&ID=" + Apartado.nIdApartado + "\">Exportar apartado</a></td>" : "<td>Sin archivos</td>") + "</tr>";
                    Anexo = objJson[i].lstAnexos;
                    for (j = 0; j < Anexo.length; j++) {
                        strHTMLApAx += "<tr data-tt-id=\"" + objJson[i].idApartado + "-" + Anexo[j].idAnexo + "\" data-tt-parent-id=\"" + objJson[i].idApartado + "\" style=\"display: none;\" >" +
                                                "<td><span style=\"padding-left: 19px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span>" + Anexo[j].strCveAnexo + " " + Anexo[j].strDAnexo + "</span></td>" +

                                                "<td class=\"Acen\">" + (objJson[i].chrAplica == 'O' ? (Anexo[j].charIndEntrega == 'P' ? "0%" : (Anexo[j].charIndEntrega == 'I' ? "100%" : "EXCLUIDO")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (objJson[i].chrAplica == 'O' ? (Anexo[j].charIndEntrega == 'P' ? "<select id='slc_" + Anexo[j].idAnexo + "'></select>" : (Anexo[j].charIndEntrega == 'I' ? "<select id='slc_" + Anexo[j].idAnexo + "'></select>" : "")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (objJson[i].chrAplica == 'O' ? (Anexo[j].charIndEntrega == 'P' ? "<input id=" + Anexo[j].idAnexo + " disabled='true' type='text' size='95' />" : (Anexo[j].charIndEntrega == 'I' ? "<input id=" + Anexo[j].idAnexo + " disabled='true' type='text' size='95' />" : "")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (objJson[i].chrAplica == 'O' ? (Anexo[j].charIndEntrega == 'P' ? "<a id='AccGuardar' title='Guardar' href='javascript:Guardar(" + Anexo[j].idAnexo + "," + objJson[i].idApartado + ");'><img src='../images/ico-guardar.png' /></a>" : (Anexo[j].charIndEntrega == 'I' ? "<a id='AccGuardar' title='Guardar' href='javascript:Guardar(" + Anexo[j].idAnexo + "," + objJson[i].idApartado + ");'><img src='../images/ico-guardar.png' /></a>" : "")) : "") + "</td>" +
                                           "</tr>";
                    }
                }
                /*
                $.each(objJson, function (k, Apartado) {
                    strHTMLApAx += "<tr data-tt-id=\"" + Apartado.nIdApartado + "\" class=\"collapsed\"><td><span style=\"padding-left: 0px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span>" +
                                (Apartado.chrAplica == 'O' ?
                                    Apartado.sApartado + " " + Apartado.sDApartado
                                    :
                                    Apartado.sApartado + " " + Apartado.sDApartado + " (CONTRALORÍA)"

                                    ) +
                                    "</span></td><td></td><td></td><td></td><td></td>"; // +(fGetNumeroArchivosXapartado(Apartado) > 0 ? "<td><a href=\"../General/SGDCARZIP.aspx?strOpcion=apartado&participante=" + Apartado.nIdParticipante + "&proceso=" + Apartado.nIdProceso + "&ID=" + Apartado.nIdApartado + "\">Exportar apartado</a></td>" : "<td>Sin archivos</td>") + "</tr>";


                    $.each(Apartado.laAnexos, function (f, Anexo) {
                        strHTMLApAx += "<tr data-tt-id=\"" + Apartado.nIdApartado + "-" + Anexo.nIdAnexo + "\" data-tt-parent-id=\"" + Apartado.nIdApartado + "\" style=\"display: none;\" >" +
                                                "<td><span style=\"padding-left: 19px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span>" + Anexo.sAnexo + " " + Anexo.sDAnexo + "</span></td>" +

                        //ESTADO
                        //"<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "PENDIENTE" : (Anexo.cIndEntrega == 'I' ? "INTEGRADO" : "EXCLUIDO")) : "") + "</td>" +
                        //"<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.sAnexo + ' ' + Anexo.sDAnexo + "'," + k + "," + Apartado.nIdParticipante + "," + Apartado.nIdProceso + ",'ARCHIVO'" + ");\">" + Anexo.nNumArchivos + "</a>" : Anexo.nNumArchivos) + "</td>" +
                                                "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "0%" : (Anexo.cIndEntrega == 'I' ? "100%" : "EXCLUIDO")) : "") + "</td>" +
                        //"<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.sAnexo + ' ' + Anexo.sDAnexo + "'," + k + "," + Apartado.nIdParticipante + "," + Apartado.nIdProceso + ",'VISUALIZAR'" + ");\">" + Anexo.nNumArchivos + "</a>" : Anexo.nNumArchivos) + "</td>" +
                        //"<td><input id=txt_Anexo" + Anexo.nIdAnexo + " type='text' /></td>" +
                        //"<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "<input id=txt_Anexo" + Anexo.nIdAnexo + " type='text' />" : (Anexo.cIndEntrega == 'I' ? "<input id=" + Anexo.nIdAnexo + " type='text' />" : "")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "<select id='slc_" + Anexo.nIdAnexo + "'></select>" : (Anexo.cIndEntrega == 'I' ? "<select id='slc_" + Anexo.nIdAnexo + "'></select>" : "")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "<input id=" + Anexo.nIdAnexo + " disabled='true' type='text' size='95' />" : (Anexo.cIndEntrega == 'I' ? "<input id=" + Anexo.nIdAnexo + " disabled='true' type='text' size='95' />" : "")) : "") + "</td>" +
                        //"<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"../General/SGDCARZIP.aspx?strOpcion=anexo&participante=" + Apartado.nIdParticipante + "&proceso=" + Apartado.nIdProceso + "&ID=" + Anexo.nIdAnexo + "\">Exportar anexo</a>" : "Sin archivos") + "</td>" +
                                                "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "<a id='AccGuardar' title='Guardar' href='javascript:Guardar(" + Anexo.nIdAnexo + "," + Apartado.nIdApartado + ");'><img src='../images/ico-guardar.png' /></a>" : (Anexo.cIndEntrega == 'I' ? "<a id='AccGuardar' title='Guardar' href='javascript:Guardar(" + Anexo.nIdAnexo + "," + Apartado.nIdApartado + ");'><img src='../images/ico-guardar.png' /></a>" : "")) : "") + "</td>" +
                                           "</tr>";
                    });
                });

                */
                strHTMLApAx += "</tbody>";
                strHTMLApAx += "</table>";

                $("#div_datos").empty().append(strHTMLApAx);

                $("#tblObligaciones").treetable({ expandable: true });
                $("#tblObligaciones tbody tr").mousedown(function () {
                    $("tr.selected").removeClass("selected");
                    $(this).addClass("selected");
                });
            }
        }

        // Función que pinta los select con las recomendaciones. 
        function fPintaRecomendaciones() {
            var strParametros = "{}";
            $.ajax({
                url: "SMABITACO.aspx/fObtieneRecomendaciones",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    LlenaRecomendaciones(eval('(' + reponse.d + ')'));
                },
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        // Función que arma los select con las recomendaciones.
        function LlenaRecomendaciones(objJson) {
            listItem = "";
//            listItem += "<option value=" + 0 + " >" + "Seleccione" + " </option>";
            for (a_i = 0; a_i < objJson.length; a_i++) {
                listItem += "<option value=" + objJson[a_i].idRecomenda + " >" + objJson[a_i].sDRecomenda + " </option>";
            }
            //$("input[id^='slc'").append(listItem);
            $('select').each(function () {
                $(this).append(listItem);
            });
            CambiaSelect();

        }

        // Función que obtiene la bitácora de una dependencia.
        function Obtiene() {
            var strParametros = "{'nProceso':'" + DatosGenerales[0].nIdProceso +
                                "','nDepcia':'" + DatosGenerales[0].nFKDepcia +
                                "'}";
            $.ajax({
                url: "SMABITACO.aspx/fObtieneObservaciones",
                data: strParametros,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    LlenaObservaciones(eval('(' + reponse.d + ')'));
                    loading.close();
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error: function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        }

        // Función que selecciona la recomendación y llena el detalle en caso de tenerlo.
        function LlenaObservaciones(objBitacora) {
            if (objBitacora != null) {//|| objBitacora != ""){ //|| objBitacora.resultado != '2') {
                $("#AccVer").show();
                $("#AccReporte").show();
                $("#AccVer2").hide();
                $("#AccReporte2").hide();
                $.each(objBitacora, function (k, Bitacora) {
                    $("#slc_" + Bitacora.idFKAnexo + " option[value=" + Bitacora.idRecomenda + "]").attr("selected", true);
                    if (Bitacora.idRecomenda == 3) {
                        $("#" + Bitacora.idFKAnexo).val(Bitacora.sObervaciones);
                        $("#" + Bitacora.idFKAnexo).attr("disabled", false);
                    }
                });
            } else {
                $("#AccVer2").show();
                $("#AccReporte2").show();
                $("#AccVer").hide();
                $("#AccReporte").hide();
            }
        }

        // Función que guarda la recomendación del anexo y el detalle en caso de tenerlo.
        function Guardar(nAnexo, nApartado) {
            var blnGuardar = false;
            var strObservaciones = "";
            if ($("#slc_" + nAnexo).val() != 0) {
                if ($("#slc_" + nAnexo).val() == 3) {
                    if (fValidaObservaciones(nAnexo)) {
                        blnGuardar = true;
                        strObservaciones = $("#" + nAnexo).val();
                    }
                } else {
                    blnGuardar = true;
                    strObservaciones = $("#slc_" + nAnexo + " option:selected").text();
                }

                if (blnGuardar) {
                    loading.ini();
                    var strParametros = "{'nProceso':'" + DatosGenerales[0].nIdProceso +
                                "','nAnexo':'" + nAnexo +
                                "','nApartado':'" + nApartado +
                                "','nDepcia':'" + DatosGenerales[0].nFKDepcia +
                                "','nRecomenda':'" + $("#slc_" + nAnexo).val() +
                                "','sObservaciones':'" + strObservaciones +
                                "','iAvance':'" + DatosGenerales[0].avanceGeneral.toFixed(2) +
                                "','nUsuarioSup':'" + $("#hf_idUsuario").val() +
                                "'}";
                    $.ajax({
                        url: "SMABITACO.aspx/fGuardarBitacora",
                        data: strParametros,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            var resp = reponse.d;
                            switch (resp) {
                                case 0: // El query no se ejecuto correctamente.
                                    loading.close();
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La base de datos no está disponible.
                                    break;
                                case 1: // Guardo correctamente las observaciones.
                                    $("#AccVer").show();
                                    $("#AccReporte").show();
                                    $("#AccVer2").hide();
                                    $("#AccReporte2").hide();
                                    loading.close();
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("La operación fue realizada correctamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    break;
                            }
                        },
                        //                beforeSend: loading.ini(),
                        //                complete: loading.close(),
                        error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    });
                }
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Seleccione una recomendación.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
        }

        // Función que envía la bitácora al sujeto obligado.
        function Enviar() {
            loading.ini();
            var strParametros = "{'nProceso':'" + DatosGenerales[0].nIdProceso +
                                "','nParticipante':'" + DatosGenerales[0].nIdParticipante +
                                "','nDepcia':'" + DatosGenerales[0].nFKDepcia +
                                "','nSupervisor':'" + $("#hf_idUsuario").val() +
                                "'}";
            $.ajax({
                url: "SMABITACO.aspx/fEnviarBitacora",
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
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La base de datos no está disponible.
                            break;
                        case 1:
                            loading.close();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("La bitácora se ha enviado correctamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                    }
                },
                error:
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        // Función que valida el campo de detalle, en caso de seleccionar la recomendación 'OTRO'.
        function fValidaObservaciones(nAnexo) {
            $("#" + nAnexo).val(jsTrim($("#"+nAnexo).val()));
            if ($("#" + nAnexo).val().length > 0) {
                return true;
            } else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Indique la observación.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                return false;
            }
        }

        // Función que se ejecuta cuando la recomendación seleccionada cambia y habilita  el campo de detalle en que caso de seleccionar la opción 'OTRO'.
        function CambiaSelect() {
            $('select').change(function () {
                if ($(this).val() == 3) {
                    var strSplit = $(this).attr("id").split("_");
                    $("#" + strSplit[1]).attr("disabled", false);
                } else {
                    var strSplit = $(this).attr("id").split("_");
                    $("#" + strSplit[1]).attr("disabled", true);
                    $("#" + strSplit[1]).val("");
                }
            });
        }

        // Función que hace trim a una cadena.
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        // Función que regresa a la forma anterior.
        function fCancelar() {
            NG.setNact(2, 'Dos', null);
            urls(2, "SSSMONDEP.aspx");
            NG.setNact(1, 'Uno');
        }

        // Función para abrir el reporte
        function Reporte() {
            var idUsuario = $("#hf_idUsuario").val();
            var cveDepcia = DatosGenerales[0].nFKDepcia;
            var idProceso = DatosGenerales[0].nIdProceso;
            dTxt = '<div id="dComent" title="SERUV - Reporte">';
            //dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + idProceso + '&cveDepcia=' + cveDepcia + '&idSupervisor=' + idUsuario + '&op=BITACORA' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + idProceso + '&cveDepcia=' + cveDepcia + '&op=BITACORA' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#form1').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //800,
                width: $("#agp_contenido").width() - 50, //1100,
                modal: true,
                resizable: true
            });
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }
    </script>

    <form id="form1" runat="server">
    <div>
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Bitácora de seguimiento</label>
                <div class="a_acciones">
                    <a id="AccVer" title="Ver correo" href="javascript:Enviar();" class="accAct">Enviar</a>
                    <a id="AccVer2" title="Ver correo" class="accIna">Enviar</a> 
                    <a id="AccReporte" title="Reporte" href="javascript:Reporte();" class="accAct">Reporte</a> 
                    <a id="AccReporte2" title="Reporte" class="accIna">Reporte</a>
                </div>
            </div>

            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img1" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>

            <div id="div_contenido">                
                <h2>Proceso entrega - recepci&oacute;n:</h2>&nbsp;&nbsp;<label id="lbl_Proceso"></label>
                <br />
                <h2>Dependencia / entidad:</h2>&nbsp;&nbsp;<label id="lbl_Dependencia"></label>
                <br />
                <h2>Sujeto obligado:</h2>&nbsp;&nbsp;<label id="lbl_Sobligado"></label>
                <br />
                <h2>Fecha de verificaci&oacute;n:</h2>&nbsp;&nbsp;<label id="lbl_Fecha"></label>
                <br />
                <h2>Total en Gu&iacute;a:</h2>&nbsp;&nbsp;<label id="lbl_Total"></label>
                <br />
                <h2>Excluidos:</h2>&nbsp;&nbsp;<label id="lbl_Excluidos"></label>
                <h2>Pendientes:</h2>&nbsp;&nbsp;<label id="lbl_Pendientes"></label>
                <%--<a id="AccGuardar" title="Guardar" href="javascript:Guardar();" class="accAct">Guardar</a>--%>
                <%--<br />--%>
                <h2>A integrar:</h2>&nbsp;&nbsp;<label id="lbl_Integrar"></label>
                <h2>Integrados:</h2>&nbsp;&nbsp;<label id="lbl_Integrados"></label>
                <br />
                <h2>Avance:</h2>&nbsp;&nbsp;<label id="lbl_Avance"></label>
                <%--<a id="AccGuardar" title="Enviar" href="javascript:Enviar();" class="accAct">Enviar</a>--%>
                <div id="div_datos">
                </div>

                <div class="btnRegresar">
                    <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
                </div>

                <div id="div_ocultos">
                    <asp:HiddenField ID="hf_idUsuario" runat="server" />
                    <asp:HiddenField ID="hf_NG" runat="server" />
                    <asp:HiddenField ID="hf_proceso" runat="server" />
                    <asp:HiddenField ID="hf_anexo" runat="server" />
                    <asp:HiddenField ID="hf_idProceso" runat="server" />
                </div>

            </div>
        </div>
    </div>
    </form>
</body>
</html>
