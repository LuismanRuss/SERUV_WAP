<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SMCSUPMON" Codebehind="SMCSUPMON.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   <%-- <link href="../styles/jquery.treetable.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.treetable.theme.default.css" rel="stylesheet" type="text/css" />--%>
   <%-- <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>--%>
  <%--  <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>--%>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
 <%--   <script src="../scripts/jquery.treetable.js" type="text/javascript"></script>--%>
</head>
<body>
<script type="text/javascript">
    /*Variables globales para poder "seleccionar" un objeto del objeto general NG*/
    var intProceso;
    var intParticipante;
    var intApartado;
    var intAnexo;

    /*Variable de tipo función que se utiliza para controlar los botones de la forma*/
    var botonesMT = function (objParticipante) {
        if (objParticipante != null) {
//            console.log(objParticipante);
            if (objParticipante.strEstatusP == 'CONCLUIDA') {
                $("#AccSolApartura1").show();
                $("#AccSolApartura2").hide();

                if (objParticipante.strPerfilUsuario == 'SUJETO OBLIGADO' || objParticipante.strPerfilUsuario == 'SUJETO RECEPTOR') {
                    if (fGetNumeroAnexos(objParticipante) > 1) {
                        $("#AccExportar1").show();
                        $("#AccExportar2").hide();
                    }
                }
                else {
                    $("#AccExportar1").hide();
                    $("#AccExportar2").show();
                }
            }
            else {

                if (objParticipante.strPerfilUsuario == 'SUJETO OBLIGADO' || objParticipante.strPerfilUsuario == 'SUJETO RECEPTOR') {
                    if (fGetNumeroAnexos(objParticipante) > 1) {
                        $("#AccExportar1").show();
                        $("#AccExportar2").hide();
                    }
                }
                else {
                    $("#AccExportar1").hide();
                    $("#AccExportar2").show();
                }

                $("#AccSolApartura1").hide();
                $("#AccSolApartura2").show();

            }

            /*
            if (objParticipante.strOPNotif == 'SI') {
                $("#AccNotificaciones1").show();
                $("#AccNotificaciones2").hide();
            }
            else {
                $("#AccNotificaciones1").hide();
                $("#AccNotificaciones2").show();
            }
            */
        }
        else {

            $("#AccSolApartura1").hide();
            $("#AccSolApartura2").show();

//            $("#AccNotificaciones1").hide();
//            $("#AccNotificaciones2").show();

            $("#AccExportar2").hide();
            $("#AccExportar1").show();
        }
    };

    /*Se lanza al inicio de la carga del lado del cliente*/
    $(document).ready(function () {
        NG.setNact(1, 'Uno', botonesMT);
        NG.Var[NG.Nact].botones(null);
        
        $("#div_contenido").css("display", "none");
        $('#div_mensaje').css("display", "none");
        if (NG.Var[NG.Nact - 1].datoSel == null) {
            fGetInformacion(null);
        }
    });

    /*Función general que se utiliza para pintar los datos de los procesos donde ha participado un usuario*/
    function fPintaDatos(objJson) {
        if (objJson != null) {
            if (Number(objJson.intTieneProcesos) > 0) {
                $("#div_mensaje").css("display", "none");
                $('#div_contenido').css("display", "block");
                fPintaDatosProcesosER(objJson);
            }
            else {
                $("#div_contenido").css("display", "none");
                $('#div_mensaje').css("display", "none");
            }
        }
        else {
            $("#div_contenido").css("display", "none");
            $('#div_mensaje').css("display", "block");
        }
    }

    /*función que se utiliza cuando se cierra el dialog*/
    function fCerrarDialog() {
        $('#dComentA').dialog("close");
        $("#dComentA").dialog("destroy");
        $("#dComentA").remove();

    }

    /*Función utilizada para abrir el Dialog donde se muestra el listado de archivos cargados a un anexo*/
    function fConsultarArchivosA(nAnexo, nApartado, nParticipante, nProceso) { 
        intProceso = nProceso;
        intParticipante = nParticipante;
        intApartado = nApartado;
        intAnexo = nAnexo;
        $("#hf_NG").val(frms.jsonTOstring(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]));
        dTxt = '<div id="dComentA" title="Consulta de archivos">';
        dTxt += '<iframe id="SCCONSULT" src="SMCONSULT.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form1').append(dTxt);
        $("#dComentA").dialog({
            autoOpen: true,
            height: 650,
            width: 970,
            modal: true,
            resizable: true
        });
    }

    /*Función utilizada para abrir el Dialog donde se muestra el listado de archivos cargados a un anexo, así como el visualizador para poderlos consultar en línea*/
    function fConsultarArchivosV(nAnexo, sAnexo, nApartado, nParticipante, nProceso) {
        intProceso = nProceso;
        intParticipante = nParticipante;
        intApartado = nApartado;
        intAnexo = nAnexo;
        $("#hf_anexo").val(sAnexo);
        $("#hf_NG").val(frms.jsonTOstring(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]));
        dTxt = '<div id="dComentV" title="Consulta de archivos">';
        dTxt += '<iframe id="SCCONSULV" src="SMCONSULV.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form1').append(dTxt);
        $("#dComentV").dialog({
            autoOpen: true,
            height: 650,
            width: 1000,
            modal: true,
            resizable: true,
            closeOnEscape: false,
            open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
        });
    }

    /*Función utilizada para abrir el Dialog donde se listan los procesos donde ha participado un usuario*/
    function BuscarProceso() {
        $("#hf_NG").val(frms.jsonTOstring(NG.Var[NG.Nact - 1].datoSel));
        dTxt = '<div id="dComent2" title="Buscar proceso">';
        dTxt += '<iframe id="SMCBUSPROC" src="SMCBUSPROC.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form1').append(dTxt);
        $("#dComent2").dialog({
            autoOpen: true,
            height: 500,
            width: 970,
            modal: true,
            resizable: true
        });
    }

    /*Función que cierra el dialog donde se listan los procesos donde ha participado un usuario*/
    function fCerrarDialogP(objJson) { //dComentFG
        $('#dComent2').dialog("close");
        $("#dComent2").dialog("destroy");
        $("#dComent2").remove();

        if (objJson != null) {
            NG.Var[NG.Nact - 1].datoSel.lstProcesos[0] = objJson;
            $('#hf_idProceso').val(NG.Var[NG.Nact - 1].datoSel.lstProcesos[0].idProceso);
            fPintaDatos(NG.Var[NG.Nact - 1].datoSel);
        }
    }

    /*Función que consulta al servidor los datos (archivos) asociados a una anexo de una ER*/
    function fGetDatosAnexo(nAnexo, sAnexo, nApartado, nParticipante, nProceso, sOpcion) {
        objAnexo = NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo];
        if (objAnexo != null) {
            objAnexo.strAccion = 'ARCHIVOS';
            objAnexo.strOpcion = 'MONITOREO';
            actionData = frms.jsonTOstring({ objAnexo: objAnexo });
            $.ajax(
                    {
                        url: "SMCSUPMON.aspx/pGetDatosAnexo",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo] = eval('(' + reponse.d + ')');
                                switch (sOpcion) {
                                    case 'VISUALIZAR':
                                        fConsultarArchivosV(nAnexo, sAnexo, nApartado, nParticipante, nProceso);
                                        break;
                                    case 'ARCHIVO':
                                        fConsultarArchivosA(nAnexo, nApartado, nParticipante, nProceso);
                                        break;
                                }

                            }
                        },
                        beforeSend: loading.iniSmall(),
                        complete: loading.closeSmall(),
                        error: errorAjax
                    });
        }
    }

    /*Función que se utiliza para pintar el control donde se listan los apartados y anexos de una ER*/
    function fPintaApartadosAnexos(objJson) { // Objeto participante
        strHTMLApAx = "";
        if (objJson != null && objJson.lstApartados != null) {
            strHTMLApAx += "<table id=\"tblObligaciones\" class=\"treetable\">";
            strHTMLApAx += "<caption>";
            strHTMLApAx += "<a href=\"#\" onclick=\"jQuery('#tblObligaciones').treetable('expandAll'); return false;\">Desplegar anexos <img src=\"../images/ico-expandir.png\" /></a>&nbsp;&nbsp; - &nbsp;&nbsp;";
            strHTMLApAx += "<a href=\"#\" onclick=\"jQuery('#tblObligaciones').treetable('collapseAll'); return false;\">Agrupar anexos <img src=\"../images/ico-colapsar.png\" /></a>";
            strHTMLApAx += "</caption>";
            strHTMLApAx += "<thead>";
            strHTMLApAx += "<tr>";
            strHTMLApAx += "<th>Apartados/Anexos</th>";
            strHTMLApAx += "<th>Estado</th>";
            strHTMLApAx += "<th>Archivos cargados</th>";
            strHTMLApAx += "<th>Visualizar</th>";
            strHTMLApAx += "<th>Exportar</th>";
            strHTMLApAx += "</tr>";
            strHTMLApAx += "</thead>";
            strHTMLApAx += "<tbody>";
            // AQUÍ SE RECORREN LOS APARTADOS Y ANEXOS
            $.each(objJson.lstApartados, function (k, Apartado) {
                strHTMLApAx += "<tr data-tt-id=\"" + Apartado.idApartado + "\" class=\"collapsed\"><td><span style=\"padding-left: 0px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span>" +
                                (Apartado.chrAplica == 'O' ?
                                    Apartado.strApartado + " " + Apartado.strDescApartado
                                    :
                                    Apartado.strApartado + " " + Apartado.strDescApartado + " (CONTRALORÍA)"
                                    ) +
                                "</span></td><td></td><td></td><td></td>" + (fGetNumeroArchivosXapartado(Apartado) > 0 ? "<td><a href=\"../General/SGDCARZIP.aspx?strOpcion=apartado&participante=" + objJson.idParticipante + "&proceso=" + NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].idProceso + "&ID=" + Apartado.idApartado + "\">Exportar apartado</a></td>" : "<td>Sin archivos</td>") + "</tr>";
                $.each(Apartado.lstAnexos, function (f, Anexo) {
                    strHTMLApAx += "<tr data-tt-id=\"" + Apartado.idApartado + "-" + Anexo.idAnexo + "\" data-tt-parent-id=\"" + Apartado.idApartado + "\" style=\"display: none;\" >" +
                                        "<td><span style=\"padding-left: 19px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span " + (Anexo.cIndActa == 'S' ? " style=\"color:red\"" : "") + ">" + Anexo.strCveAnexo + " " + Anexo.strDAnexo + "</span></td>" +
                                        "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.charIndEntrega == 'P' ? "PENDIENTE" : (Anexo.charIndEntrega == 'I' ? "INTEGRADO" : "EXCLUIDO")) : "") + "</td>" +
                                        "<td class=\"Acen\">" + (Anexo.intNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.strCveAnexo + Anexo.strDAnexo + "'," + k + "," + intParticipante + "," + intProceso + ",'ARCHIVO'" + ");\">" + Anexo.intNumArchivos + "</a>" : Anexo.intNumArchivos) + "</td>" +
                                        "<td class=\"Acen\">" + (Anexo.intNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.strCveAnexo + ' ' + Anexo.strDAnexo + "'," + k + "," + intParticipante + "," + intProceso + ",'VISUALIZAR'" + ");\">" + Anexo.intNumArchivos + "</a>" : Anexo.intNumArchivos) + "</td>" +
                                        "<td class=\"Acen\">" + (Anexo.intNumArchivos > 0 ? "<a href=\"../General/SGDCARZIP.aspx?strOpcion=anexo&participante=" + objJson.idParticipante + "&proceso=" + NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].idProceso + "&ID=" + Anexo.idAnexo + "\">Exportar anexo</a>" : "Sin archivos") + "</td>"  +
                                   "</tr>";
                }); //intProceso
            });
            strHTMLApAx += "</tbody>";
            strHTMLApAx += "</table>";

            $("#div_datos").empty().append(strHTMLApAx);

            $("#tblObligaciones").treetable({ expandable: true });
            $("#tblObligaciones tbody tr").mousedown(function () {
                $("tr.selected").removeClass("selected");
                $(this).addClass("selected");
            });

            NG.Var[NG.Nact].botones(objJson);
            loading.close();
        }


        //---activo o desactivo el boton de exportar------
        $("#AccExportar1").hide();
        $("#AccExportar2").show();


        $.each(objJson.lstApartados, function (k, Apartado) {
            $.each(Apartado.lstAnexos, function (f, Anexo) {
                if (Anexo.intNumArchivos > 0) {
                    $("#AccExportar1").show();
                    $("#AccExportar2").hide();
                }
            });
        });
        //----------------------------------------------

    }

    /*Función que regresa el número de archivos por apartado, utlizada para pintar el exportar por apartado*/
    function fGetNumeroArchivosXapartado(objApartado) {
        var intNumArchivos = 0;
        $.each(objApartado.lstAnexos, function (f, Anexo) {
            intNumArchivos = intNumArchivos + Anexo.intNumArchivos;
        });
        return intNumArchivos;
    }

    /*Función que regresa el número de anexos en una ER*/
    function fGetNumeroAnexos(objJson) {
        var nNumAnexos = 0;
        for (i = 0; i < objJson.lstApartados.length; i++) {
            if (objJson.lstApartados[i].chrAplica == 'O') {
                nNumAnexos = nNumAnexos + objJson.lstApartados[i].lstAnexos.length;
            }
        }
        return nNumAnexos;
    }

    /*Función que consulta al servidor los datos de una participante (dependencia) de una procesos ER*/
    function fGetDatosParticipante(objParticipante) { // objeto Participante
        if (objParticipante != null) {
            //objParticipante.strAccion = 'ARCHIVOS';
            objParticipante.strAccion = 'PARTICIPANTE';
            objParticipante.strOpcion = 'MONITOREO';
            objParticipante.lstApartados = null;
            actionData = frms.jsonTOstring({ objParticipante: objParticipante });
            $.ajax(
                    {
                        url: "SMCSUPMON.aspx/pGetDatosParticipante",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante] = eval('(' + reponse.d + ')');
                                fPintaApartadosAnexos(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante]);
                                
                            }
                            
                        },
                        beforeSend: loading.iniSmall(),
                        complete: loading.closeSmall(),
                        error: errorAjax
                    }
                );
        }
    }

    /*Función utilizada para pintar los datos de una participante (dependencia) que participa en un proceso ER*/
    function fPintaParticipantes(objJson) { // objeto proceso
        strHtmlDepcias = "";
        strHtmlPuestos = "";
        
        if (objJson != null) {
            strHtmlDepcias += "<select id=\"slc_depcias\">";
            for (k = 0; k < objJson.lstParticipantes.length; k++) {
                strHtmlDepcias += "<option value=\"" + k + "\">" + objJson.lstParticipantes[k].strDDepcia + "</option>";
            }
            
            strHtmlDepcias += "</select>";
            $("#div_depcias").html(strHtmlDepcias);
            $("#div_puestos").html(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strDPuesto);

            $('#lbl_strTitular').empty().append(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioT);
            $('#lbl_strSObligado').empty().append(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioO);
            
            if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado != null) {
                if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado.length == 1) { //
                    $("#div_EOSO").empty().append(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado[0].strNombre);
                }
                else if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado.length > 1) { //
                    htmlTab = '';

                    htmlTab += '<div><a class="ackDialog" href="#fixme">VER ENLACES OPERATIVOS..</a></div>';
                    htmlTab += '<div class="dialoG oculto"><ul>';
                    htmlTab += '<div class="a_acciones_sin"><a href="f_reporte(\'EO\');" class="accAct">Reporte</a></div> <br/><br/>';                    
                    for (i = 0; i < objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado.length; i++) {
                        if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado[i].chrPrincipal == 'S') {
                            htmlTab += '<li>' + objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado[i].strNombre + ' (Principal)' + '</li>';
                        } else {
                            htmlTab += '<li>' + objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOObligado[i].strNombre + '</li>';
                        }

                    }
                    htmlTab += '</ul></div></td>';

                    

                    $("#div_EOSO").empty().append(htmlTab);

                    a_di1 = new o_dialog('Ver Enlaces Operativos');
                    a_di1.iniDial();
                }
                else {
                    $("#div_EOSO").empty().append("NO HAY ENLACES OPERATIVOS CONFIGURADOS");
                }
            }
                        
            $('#lbl_strSReceptor').empty().append((objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioR != "" ? objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioR : "NO DEFINIDO"));
            if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor != null) {
                if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor.length == 1) { //
                    $("#div_EOSR").empty().append(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor[0].strNombre);
                }
                else if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor.length > 1) { //
                    htmlTab = '';

                    htmlTab += '<div><a class="ackDialog" href="#fixme">VER ENLACES OPERATIVOS..</a></div>';
                    htmlTab += '<div class="dialoG oculto"><ul>';
                    htmlTab += '<div class="a_acciones_sin"><a href="f_reporte();" class="accAct">Reporte</a></div> <br/><br/>';
                    for (i = 0; i < objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor.length; i++) {
                        if (objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor[i].chrPrincipal == 'S') {
                            htmlTab += '<li>' + objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor[i].strNombre + ' (Principal)' + '</li>';
                        } else {
                            htmlTab += '<li>' + objJson.lstParticipantes[$("#slc_depcias option:selected").val()].lstEOReceptor[i].strNombre + '</li>';
                        }

                    }
                    htmlTab += '</ul></div></td>';
                    $("#div_EOSR").empty().append(htmlTab);

                    a_di1 = new o_dialog('Ver Enlaces Operativos');
                    a_di1.iniDial();
                }
                else {
                    $("#div_EOSR").empty().append("NO HAY ENLACES OPERATIVOS CONFIGURADOS");
                }
            }
            
            if (objJson.strPerfilUsuario != 'CONTROL OBLIGADO' && objJson.strPerfilUsuario != 'CONTROL RECEPTOR') {
                $('#div_perfil').show();
                $('#lbl_Perfil').empty().append(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strPerfilUsuario);
            }
            else {
                $('#div_perfil').hide();
            }

            intParticipante = $("#slc_depcias option:selected").val();
            $('#lbl_EEntrega').empty().append(objJson.lstParticipantes[$("#slc_depcias option:selected").val()].strEstatusP);

            if (fGetNumeroAnexos(objJson.lstParticipantes[intParticipante]) > 1) {
                $("#AccExportar1").show();
                $("#AccExportar2").hide();
                $("#AccExportar1").attr("href", "../General/SGDCARZIP.aspx?strOpcion=proceso&participante=" + objJson.lstParticipantes[intParticipante].idParticipante + "&proceso=" + objJson.idProceso + "&ID=" + objJson.idProceso);
            }
            else {
                $("#AccExportar1").hide();
                $("#AccExportar2").show();
            }

            fPintaApartadosAnexos(objJson.lstParticipantes[intParticipante]);
            if (objJson.lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORÁNEO') { //(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                $("#div_ext").show();
                $("#lbl_strCorteEx").empty().append(objJson.lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[intProceso].lstParticipantes[intParticipante].dteFFin);
            }
            else {
                $("#div_ext").hide();
            }

            fCambiaAvance();
            $('#slc_depcias').change(function () {
                intParticipante = $(this).val();

                if (fGetNumeroAnexos(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante]) > 1) {
                    $("#AccExportar1").show();
                    $("#AccExportar2").hide();
                    $("#AccExportar1").attr("href", "../General/SGDCARZIP.aspx?strOpcion=proceso&participante=" + NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].idParticipante + "&proceso=" + NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].idProceso + "&ID=" + NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].idProceso);
                }
                else {
                    $("#AccExportar1").hide();
                    $("#AccExportar2").show();
                }



                if (objJson.lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORÁNEO') { //(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                    $("#div_ext").show();
                    $("#lbl_strCorteEx").empty().append(objJson.lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[intProceso].lstParticipantes[intParticipante].dteFFin);
                }
                else {
                    $("#div_ext").hide();
                }
                $("#slc_puestos").val($(this).val());

                $("#lbl_strTitular").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioT);
                $("#lbl_strSObligado").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioO);
                $('#lbl_strSReceptor').empty().append((NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioR != "" ? NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioR : "NO DEFINIDO"));

                if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strPerfilUsuario != 'CONTROL OBLIGADO' && NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strPerfilUsuario != 'CONTROL RECEPTOR') {
                    $('#div_perfil').show();
                    $('#lbl_Perfil').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strPerfilUsuario);
                }
                else {
                    $('#div_perfil').hide();
                }

                $('#lbl_EEntrega').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strEstatusP);
                fCambiaAvance();
                fGetDatosParticipante(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante]);

            });
        }
    }

    /*Función utilizada para cambiar/pintar el avance de un proceso ER*/
    function fCambiaAvance() {
        var blnBand = false;
        var nAnxTotales = 0;
        var nAnxIntegrados = 0;
        var nAnxExcluidos = 0;
        var nAnxPendientes = 0;
        var fAvance = 0.0;
        $.each(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados, function (f, Apartado) {
            if (Apartado.chrAplica == 'O') {
                blnBand = true;
                $.each(Apartado.lstAnexos, function (k, Anexo) {
                    switch (Anexo.charIndEntrega) {
                        case 'P': nAnxPendientes++;
                            break;
                        case 'I': nAnxIntegrados++;
                            break;
                        case 'E': nAnxExcluidos++;
                            break;
                    }
                });
            }
        });
        if (blnBand) {
            nAnxTotales = nAnxIntegrados + nAnxPendientes;
            fAvance = (((nAnxExcluidos + nAnxIntegrados) / nAnxTotales) * 100);
        }
        else {
            nAnxTotales = 0;
            fAvance = 0;
        }
        NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].fltAvance = fAvance.toFixed(2);
        $('#lbl_avance').empty().append(nAnxIntegrados + " anexos integrados de " + nAnxTotales + " = " + fAvance.toFixed(2) + " %");
    }

    /*Función general que se utiliza para pintar un proceso ER*/
    function fPintaProcesos(objJson) {
        strHtmlProcesos = "";

        if (objJson != null) {
            if (objJson.lstProcesos != null && objJson.lstProcesos.length > 0) {
                strHtmlProcesos += "<select id=\"slc_procesos\">";
                for (k = 0; k < objJson.lstProcesos.length; k++) {
                    if (objJson.lstProcesos[k].strEstatus == "EN PROCESO") //
                        strHtmlProcesos += "<option value=\"" + k + "\">" + objJson.lstProcesos[k].strProceso + ' ' + objJson.lstProcesos[k].strDProceso + "</option>";
                }
                strHtmlProcesos += "</select>";

                intProceso = $("#slc_procesos option:selected").val();
                $("#div_procesos").empty().append(strHtmlProcesos);
                $("#lbl_strCorte").html(objJson.lstProcesos[$("#slc_procesos option:selected").val()].dteFInicio + " al " + objJson.lstProcesos[$("#slc_procesos option:selected").val()].dteFFin);
                $("#lbl_guia").empty().append(objJson.lstProcesos[$("#slc_procesos option:selected").val()].sDGuiaER);
                fPintaParticipantes(objJson.lstProcesos[$("#slc_procesos option:selected").val()]);

                $('#slc_procesos').change(function () {
                    fPintaParticipantes(objJson.lstProcesos[$(this).val()]);
                });
            }
        }

    };

    /*Función general para pintar los proceso(s) donde ha participado un usuario*/
    function fPintaDatosProcesosER(objJson) {
        
        if (objJson != null) {
            if (objJson.lstProcesos.length > 1) { // El usuario está presente en varios procesos ER
                fPintaProcesos(objJson);
            }
            else if (objJson.lstProcesos.length == 1) { // El usuario está presente en un sólo procesos ER
                intProceso = 0;
                $("#div_procesos").html("<label>" + objJson.lstProcesos[0].strProceso + ' ' + objJson.lstProcesos[0].strDProceso + "</label>");
                $('#hf_proceso').val(objJson.lstProcesos[0].strDProceso);
                $("#lbl_strCorte").html(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                $("#lbl_guia").empty().append(objJson.lstProcesos[0].sDGuiaER);
                if (NG.Var[NG.Nact - 1].datoSel.intTieneProcesos > 1) {
                    $("#hrf_bus").show();
                }
                else {
                    $("#hrf_bus").hide();
                }
                fPintaParticipantes(objJson.lstProcesos[0]);
                
            }
        }
    }

    /*Función utilizada para abrir el Dialog donde se muestran las gráficas del Proceso ER*/
    function fVerGrafica() {
        
        var pendientes = 0;
        var excluidos = 0;
        var integrados = 0;
        var forma = "SMCSUPMON";



        $.each(NG.Var[NG.Nact - 1].datoSel.lstProcesos[0].lstParticipantes[intParticipante].lstApartados, function (k, Apartado) {
            if (Apartado.chrAplica == 'O') {
                $.each(Apartado.lstAnexos, function (f, Anexo) {
                    if (Anexo.charIndEntrega == 'P')
                        pendientes++;
                    if (Anexo.charIndEntrega == 'I')
                        integrados++;
                });
            }
        });
        excluidos = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].nAExluidos;

        a_tip = [
                    { tit: 'Gráfica', arc: "SSCMONGRA.aspx?excluidos=" + excluidos + "&integrados=" + integrados + "&pendientes=" + pendientes + "&forma=" + forma }
                ];
        $("#dComent3").dialog("destroy");
        $("#dComent3").remove();
        dTxt = '<div id="dComent3" title="' + a_tip[0].tit + '">';
        dTxt += '<iframe id="SSCMONPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form1').append(dTxt);
        $("#dComent3").dialog({
            autoOpen: true,
            height: 550,
            width: 950,
            modal: true,
            resizable: true
        });
    }

    /*Función principal que consulta el/los proceso(s) donde ha participado un usuario*/
    function fGetInformacion(objProceso) {
        var strDatos = "";

        if (objProceso == null) {
            var strDatos = "{\"idUsuario\": " + $('#hf_idUsuario').val() +
                                ",\"intTieneProceso\": " + 0 +
                                ",\"strAccion\": " + "\"PROCESO\"" +
                                ",\"strOpcion\": " + "\"MONITOREO\"" +
                            "}";
            objProceso = eval('(' + strDatos + ')');
        }
        actionData = frms.jsonTOstring({ objProceso: objProceso });
        $.ajax(
                {
                    url: "SMCSUPMON.aspx/pGetDatosER",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        
                        if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                            NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');
                            $('#hf_idProceso').val(NG.Var[NG.Nact - 1].datoSel.lstProcesos[0].idProceso);
                            fPintaDatos(NG.Var[NG.Nact - 1].datoSel);
                            $('#hf_idUsuario').val('');
                        }
                    },
                    beforeSend: loading.iniSmall(),
                    complete: loading.closeSmall(),
                    error: errorAjax
                }
        );
    };

    /*Función que abre el Dialog para solicitar la apertura de una proceso ER desde el módulo de Supervisión*/
    function fSolicitaApertura() {
        $("#h_NG").val(frms.jsonTOstring(NG.Var[NG.Nact - 1].datoSel));
        dTxt = '<div id="dComent" title="Solicitar apertura">';
        dTxt += '<iframe id="frm_Apertura" src="../Monitoreo/SMAAPERTU.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form1').append(dTxt);
        $("#dComent").dialog({
            autoOpen: true,
            height: 550,
            width: 970,
            modal: true,
            resizable: false
        });
    }

    /*Función que cierra el Dialog donde se solicita la apertura de un proceso ER*/
    function fCerrarVentApertura(nMensaje) {
        fCancelar();
        switch (nMensaje) {
            case 0:
                $.alerts.dialogClass = "errorAlert";
                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCION");
                break;
            case 1:
                $.alerts.dialogClass = "correctoAlert";
                jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCION");
                break;
            default:
        }
    }

    function fCancelar() {
        $('#dComent').dialog("close");
        $("#dComent").dialog("destroy");
        $("#dComent").remove();
    }

    /*Función que cierra el Dialog que muestra las gráficas del proceso ER*/
    function fCerrarDialogG() {
        $('#dComent3').dialog("close");
        $("#dComent3").dialog("destroy");
        $("#dComent3").remove();
    }

    /*Función que cierra el Dialog que visor de archivos*/
    function fCerrarDialog2() {
        $('#dComentV').dialog("close");
        $("#dComentV").dialog("destroy");
        $("#dComentV").remove();
    }

    /*Función que cambia de página en el DIV donde se muestran los datos*/
    function fNotificaciones() {
        urls(1, "../Notificaciones/SNMNOTIFI.aspx");
    }

</script>
    <form id="form1" runat="server">
        <div id="div_mensaje">No tiene procesos asociados.</div>
        <div id="agp_contenido">
            <div id="agp_navegacion"> 
                <label class="titulo">Consulta procesos ER</label>
                <div class="a_acciones">
                    
                    <a id="AccSolApartura1" title="Aperatura ER" href="javascript: fSolicitaApertura();" class="accAct">Apertura</a>
                    <a id="AccSolApartura2" title="Aperatura ER" class="accIna iOculto">Apertura</a>
                                       
                    <a id="AccExportar1" title="Exportar ER" target="_blank" href="../General/SGDCARZIP.aspx" class="accAct">Exportar entrega</a>
                    <a id="AccExportar2" title="Exportar ER" class="accIna">Exportar entrega</a>

                    <a id="AccNotificaciones1" title="Notificaciones" href="javascript: fNotificaciones();" class="accAct">Notificaciones</a>
                    <%--<a id="AccNotificaciones1" title="Notificaciones" href="javascript: fNotificaciones();" class="accAct iOculto">Notificaciones</a>--%>
                    <%--<a id="AccNotificaciones2" title="Notificaciones" class="accIna">Notificaciones</a>--%>                    
                </div>
            </div>
            <%--<div class="instrucciones">¿¿Instrucciones??</div>--%>
            <div id="div_contenido">
                <!-- Desplegado contenidos -->
                <h2>Proceso entrega - recepci&oacute;n:</h2>&nbsp;&nbsp;<div id="div_procesos"></div>&nbsp;&nbsp;
                <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:BuscarProceso();"  onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()">
                <img id="ico_busqueda" alt="Icono de búsqueda de usuario" src="../images/buscar.png" />
                 </a><label id="div_Mcuenta" class="requeridog"></label>
                <br />
                <h2>Periodo:</h2>&nbsp;&nbsp;<label id="lbl_strCorte"></label>
                <br />
                <h2>Dependencia / entidad:</h2>&nbsp;&nbsp;<div id="div_depcias"></div>
                <br />
                <h2>Puesto / cargo:</h2>&nbsp;&nbsp;<div id="div_puestos"></div>
                <h2>Titular:</h2>&nbsp;&nbsp;<label id="lbl_strTitular"></label><br />

                <h2>Sujeto obligado:</h2>&nbsp;&nbsp;<label id="lbl_strSObligado"></label>&nbsp;&nbsp;
                <%--<h2>Enlaces sujeto obligado:</h2><div id="div_EOSO"></div><br />--%>

                <h2>Sujeto receptor:</h2>&nbsp;&nbsp;<label id="lbl_strSReceptor"></label>&nbsp;&nbsp;
                <%--<h2>Enlaces sujeto receptor:</h2><div id="div_EOSR"></div><br />--%>

                <div id="div_perfil"><h2>Perfil:</h2>&nbsp;&nbsp;<label id="lbl_Perfil"></label></div>
                <h2>Estado de la entrega:</h2>&nbsp;&nbsp;<label id="lbl_EEntrega"></label>
                <div id="div_ext"><h2>Fecha de apertura extemporánea:</h2>&nbsp;&nbsp;<label id="lbl_strCorteEx"></label></div>
                <h2>Avance:</h2>&nbsp;&nbsp;<label id="lbl_avance"></label>
                <h2>Ver gráfica:</h2>
                <a href="javascript:fVerGrafica();"> <img alt="Ver gráfica" src="../images/icono-grafica.png"  style="cursor:pointer"/></a>
                <br />

                <h2>Guía:</h2>&nbsp;&nbsp;<label id="lbl_guia"></label>
                <br />
                <div id="div_datos">
                </div>
                <div id="div_ocultos">
                    <asp:HiddenField ID="hf_idUsuario" runat="server" />
                    <asp:HiddenField ID="hf_NG" runat="server" />
                    <asp:HiddenField ID="hf_proceso" runat="server" />
                    <asp:HiddenField ID="hf_anexo" runat="server" />
                     <asp:HiddenField ID="hf_idProceso" runat="server" />

                    <input type="hidden" id="h_NG"/>
                    <input type="hidden" id="h_idProceso"/>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
