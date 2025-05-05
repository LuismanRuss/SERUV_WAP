  <%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCACARINF" Codebehind="SCACARINF.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../styles/SCIREGISTRO_LAYOUT.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Registro.css" rel="stylesheet" type="text/css" />

<%--    <script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>--%>
    <script src="../scripts/jquery.easyui.min.js" type="text/javascript"></script>

    
</head>
<body>
<script type="text/javascript">
    var filtro = "{\"filtro\": [ {\"ID\": \"\", \"valor\": \"\", \"etiqueta\": \"\" } ] }"; // variable ausiliar utilizada para filtrar que opción se tiene seleccionada en la lista de estados de los anexos
    var objFiltro;
    var strDato = " {\"ID\": \"\", \"valor\": \"\", \"etiqueta\": \"\" }"; // variable utilizada para desplegar los estados de los anexos en la ER
    var selFiltro;
    
    /*Variables globales que sirven para situarse en el objeto actual*/
    var intProceso; 
    var intParticipante;
    var intApartado;
    var intAnexo;

    // Objeto de tipo función que sirve para controlar el comportamiento de los botones de la forma
    var botonesER = function (objParticipante, objAnexo, sAccion) {
        switch (sAccion) {
            case "INICIO":
                if (objParticipante != null) {
                    if (objParticipante.strOPEnviar == 'SI') {
                        var nAnxPendientes = 0;
                        $.each(objParticipante.lstApartados, function (f, Apartado) {
                            $.each(Apartado.lstAnexos, function (k, Anexo) {
                                switch (Anexo.charIndEntrega) {
                                    case 'P': nAnxPendientes++;
                                        break;
                                }
                            });
                        });
                        if (nAnxPendientes == 0) {
                            $("#AccEnviarEntrega").show();
                            $("#AccEnviarEntrega2").hide();
                        }
                        else {
                            $("#AccEnviarEntrega").hide();
                            $("#AccEnviarEntrega2").show();
                        }
                    }
                    else {
                        $("#AccEnviarEntrega").hide();
                        $("#AccEnviarEntrega2").show();

                        $("#AccSolicitarApertura").hide();
                        $("#AccSolicitarApertura2").show();
                    }
                }
                else {
                    $("#AccEnviarEntrega").hide();
                    $("#AccEnviarEntrega2").show();
                }
                break;
            case "ENVIO":
                if (objParticipante != null) {

                    if (objParticipante.strOPEnviar == 'SI') {
                        var nAnxPendientes = 0;
                        $.each(objParticipante.lstApartados, function (f, Apartado) {
                            $.each(Apartado.lstAnexos, function (k, Anexo) {
                                switch (Anexo.charIndEntrega) {
                                    case 'P': nAnxPendientes++;
                                        break;
                                }
                            });
                        });
                        if (nAnxPendientes == 0) {
                            $("#AccEnviarEntrega").show();
                            $("#AccEnviarEntrega2").hide();
                        }
                        else {
                            $("#AccEnviarEntrega").hide();
                            $("#AccEnviarEntrega2").show();
                        }
                    }
                    else {
                        $("#AccEnviarEntrega").hide();
                        $("#AccEnviarEntrega2").show();

                        $("#AccSolicitarApertura").hide();
                        $("#AccSolicitarApertura2").show();
                    }
                }
                else {
                    $("#AccEnviarEntrega").hide();
                    $("#AccEnviarEntrega2").show();
                }
                break;
            case "ANEXO":
                $("#hrf_descargarC").hide();
                $("#hrf_descargarS").hide();
                switch (objAnexo.chrFuente) {
                    case 'F':
                        if (objAnexo.docFormato != null || objAnexo.docGuia != null) {
                            $("#hrf_descargarC").show();
                            $("#hrf_descargarS").hide();
                        }
                        else {
                            $("#hrf_descargarC").hide();
                            $("#hrf_descargarS").show();
                        }
                        break;
                    case 'S':
                        if (objAnexo.docFormato != null || objAnexo.docGuia != null) {
                            $("#hrf_descargarC").show();
                            $("#hrf_descargarS").hide();
                        }
                        else {
                            $("#hrf_descargarC").hide();
                            $("#hrf_descargarS").show();
                        }
                        break;
                    case 'U':
                        if (objAnexo.chrFuente != "" && objAnexo.strNOficial != "") {
                            $("#hrf_descargarC").show();
                            $("#hrf_descargarS").hide();
                        }
                        else {
                            $("#hrf_descargarC").hide();
                            $("#hrf_descargarS").show();
                        }
                        break;
                    default:
                        $("#hrf_descargarC").hide();
                        $("#hrf_descargarS").show();
                        break;
                }
                break;
        }
    };

    $(document).ready(function () {
        loading.close();
        // El objeto NG sirve para guardar los objetos (json) que van a ser necesarios para el funcionamiento de la forma
        NG.setNact(1, 'Uno', botonesER); // Se establece el nivel actual y la función que controlará los botones en la forma
        NG.Var[NG.Nact].botones(null,
                                null,
                                "INICIO");
        objFiltro = eval('(' + filtro + ')'); // se inicializa el filtro del estado de los anexos
        $("#div_contenido").css("display", "none");
        $('#div_mensaje').css("display", "none");
        
        fGetInformacion(null); // Se consultan los procesos ER en donde esta participando el usuario logueado
       
    });

    /*Función asincrona que consulta los datos relacionados con una anexo (Archivos)*/
    function fGetDatosAnexo(objAnexo, nAnexo, nApartado, nParticipante, nProceso, sOpcion) {
        if (objAnexo != null) {
            actionData = JSON.stringify({ objAnexo: objAnexo });
            $.ajax(
                    {
                        url: "SCACARINF.aspx/pGetDatosAnexo",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                                if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                    NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo] = eval('(' + reponse.d + ')');
                                    if (sOpcion == 'INICIO') {
                                        fPintaOpciones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo],
                                                    NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante],
                                                   nAnexo, nApartado, nParticipante, nProceso);
                                    }
                                    else {
                                        $('#SCCONSULT')[0].contentWindow.fRepintaGrid(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]);
                                    }
                                }

                        },
                        beforeSend: loading.iniSmall(),
                        complete: loading.closeSmall(),
                        error: errorAjax
                    }
                );
            }       
    }

    /*Función que cambia el avance de una ER*/
    function fCambiaAvance() {
        var nAnxTotales = 0;
        var nAnxIntegrados = 0;
        var nAnxExcluidos = 0;
        var nAnxPendientes = 0;
        var fAvance = 0.0;
        $.each(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados, function (f, Apartado) {
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
        });
        
        nAnxTotales = nAnxIntegrados + nAnxPendientes;
        fAvance = (((nAnxExcluidos + nAnxIntegrados) / nAnxTotales) * 100);
        NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].fltAvance = fAvance.toFixed(2);
        $('#lbl_avance').empty().append(nAnxIntegrados + " anexos integrados de " + nAnxTotales + " = " + fAvance.toFixed(2) + " %");
        loading.close();
    }

    /*Función que cambia el estado de un anexo de pendiente a integrado y viceversa*/
    function fCambia(nAnexo, nApartado, nParticipante, nProceso) {
        objAnexo = NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo];
        objApartados = NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados;
        if (objAnexo != null) {
            jConfirm('¿Desea cambiar el estado del anexo '
                        +
                        objAnexo.strCveAnexo + ' ' + objAnexo.strDAnexo
                        + ' de ' + (objAnexo.charIndEntrega == 'P' ? ' Pendiente ' : ' Integrado ')
	                    +
                            ' a ' + (objAnexo.charIndEntrega == 'P' ? ' Integrado ' : ' Pendiente ') + ' ? \n Esta acción '
	                    +
                            (objAnexo.charIndEntrega == 'P' ? ' bloqueará el anexo, no se podrá modificar la información existente y estará listo para ser enviado.' : ' permitirá sustituir el archivo o incorporar otro.')
	                    , "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
	                        if (r) {
	                            objAnexo.charIndEntrega = (objAnexo.charIndEntrega == 'P' ? 'I' : 'P');
	                            objAnexo.strAccion = "INTEGRAR";
	                            objAnexo.idParticipante = NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].idParticipante;
	                            actionData = JSON.stringify({ objAnexo: objAnexo });
	                            loading.ini();
	                            $.ajax(
                                {
                                    url: "SCACARINF.aspx/pConfigAnexo",
                                    data: actionData,
                                    dataType: "json",
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (reponse) {
                                        try {

                                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                                objAnexo = eval('(' + reponse.d + ')');
                                                if (objAnexo != null && objAnexo.strResp == '1') {
                                                    loading.close();
                                                    jAlert('Operación realizada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                                        NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados = objApartados;
                                                        NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo] = objAnexo;

                                                        selFiltro = $("#slc_fAnexos").val();
                                                        fPintaFiltroAnexos(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso], nParticipante, "INTEGRAR", selFiltro);
                                                        $('#div_Opciones').empty();

                                                        fCambiaAvance();
                                                        fPintaApartados(NG.Var[NG.Nact - 1].datoSel, nApartado, nParticipante, selFiltro);
                                                        fPintaAnexos(nApartado, nParticipante, nProceso, nAnexo, selFiltro);

                                                        NG.Var[NG.Nact].botones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante],
                                                                    null,
                                                                    "ENVIO");

                                                    });
                                                }
                                                else if (objAnexo != null && objAnexo.strResp == '0') {
                                                    loading.close();
                                                    jAlert('Error en la operación inténtelo más tarde.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                                    });
                                                }
                                                if (objAnexo != null && objAnexo.strResp == '3') {
                                                    loading.close();
                                                    jAlert('La configuración del anexo ha cambiado, se recargarán los anexos que debe entregar.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                                        loading.ini();
                                                        fGetInformacion(NG.Var[NG.Nact - 1].datoSel);
                                                    });
                                                }
                                            }
                                        }
                                        catch (e) {
                                            $("#div_contenido").css("display", "none");
                                            $('#div_mensaje').css("display", "block");
                                        }
                                    },
                                    beforeSend: loading.iniSmall(),
                                    complete: loading.closeSmall(),
                                    error: errorAjax
                                }
                                );
	                        }
	        });
        }
    }
    
    /*Función que pinta la columna de opciones (donde se descarga el formato/guía o se cargan los archivos de una ER)*/
    function fPintaOpciones(objAnexo, objParticipante, nAnexo, nApartado, nParticipante, nProceso) {
        var strHtmlOpciones = "";
        if (objAnexo != null && objParticipante != null) {
            strHtmlOpciones = "<div id=\"div_Opciones\">"
                              + "<table style=\"width: 100%;\">"
                              + "<thead>"
                              + "<th style=\"background-color:#ccc;\" align=\"center\">Descargar</th>"
                              + "<th style=\"background-color:#ccc;\" align=\"center\">Cargar</th>"
                              + "<tr style=\"background-color:#ccc;\">"
                              + "<th align=\"center\">Formato / instructivo / URL</th>"
                              + "<th align=\"center\">Archivos</th>"
                              + "</tr>"
                              + "</thead>"
                              + "<tr>" // 
                              + "<td class=\"Acen\"><a id=\"hrf_descargarC\" href=\"Javascript:fFormatoGuia(" + nAnexo + "," + nApartado + "," + nParticipante + "," + nProceso + ");\"><img title=\"Descargar archivo/instructivo\" src=\"../images/descargar-archivo.png\" /></a><a id=\"hrf_descargarS\"><img title=\"Descargar archivo/instructivo\" src=\"../images/descargar-archivoO.png\" /></a></td>"
                              + "<td class=\"Acen\"><a id=\"hrf_consultar\" href=\"Javascript:fConsultarArchivos(" + nAnexo + "," + nApartado + "," + nParticipante + "," + nProceso + ");\"><img title=\"Consultar archivos cargados\" src=\"../images/consultar-archivo.png\" /></a></td>"
                              + "</tr>"
                              + "</table>"
                              + "</div>";
            $('#div_Opciones').empty().append(strHtmlOpciones);
            NG.Var[NG.Nact].botones(objParticipante, objAnexo, "ANEXO");
        }
    }

    /*Función que consulta la información actual en el objeto JSON para preguntarle al servidor la información actual (archivos)*/
    function fGetOpciones(nAnexo, nApartado, nParticipante, nProceso) {
        var objAnexo = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo];
        if (objAnexo.charIndEntrega != 'E') {
            objAnexo.strAccion = "ARCHIVOS";
            objAnexo.strOpcion = "CARGA";
            fGetDatosAnexo(objAnexo, nAnexo, nApartado, nParticipante, nProceso, "INICIO");
        }
        else { //strJustificacion
            $("#div_Opciones").empty().append("Justificación: " + objAnexo.strJustificacion);
        }
    }

    /*Función asíncrona que obtiene del servidor el número de archivos por anexo que pertenecen a un apartado de la ER*/
    function fGetNumArchivosXAnexo(nApartado, nParticipante, nProceso, sOpFilttro) {
        $('#div_Opciones').empty();
        intApartado = nParticipante;
        if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado] != null) {
            objApartado = NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado];
            objApartado.strOpcion = "CARGA";
            objApartado.strAccion = "ANEXOS";
            actionData = JSON.stringify({ objApartado: objApartado });
            $.ajax(
                    {
                        url: "SCACARINF.aspx/pGetNumArchivosXAnexo",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            try {
                                objApartado = eval('(' + reponse.d + ')');
                                NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado] = objApartado;
                                fPintaAnexos(nApartado, nParticipante, nProceso, -1, sOpFilttro);
                            }
                            catch (e) {
                                $("#div_contenido").css("display", "none");
                                $('#div_mensaje').css("display", "block");
                            }
                        },
                        beforeSend: loading.iniSmall(),
                        complete: loading.closeSmall(),
                        error: errorAjax
                    }
                );
        }
    }
    
    /*Función que pinta los anexos de una ER dependiendo el estado seleccionado en el filtro de estado del anexo*/
    function fPintaAnexos(nApartado, nParticipante, nProceso, nAnexo, sOpFilttro) {
        strAnexos = "";
        $('#div_Opciones').empty();
        intApartado = nApartado;
        if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado] != null) {
            objParticipante = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[nParticipante];
            strAnexos += "<ul id=\"ul_apartados\">";
            $.each(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos, function (f, Anexo) {
                if (Anexo.charIndEntrega == sOpFilttro) {
                    strAnexos += "<li " + (nAnexo == f ? "class=\"active\"" : "") + ">";
                    if (objParticipante.strOPCerrar == 'SI') {
                        if (Anexo.charIndEntrega == "I") {
                            strAnexos += "<a href=\"Javascript:fCambia(" + f + "," + nApartado + "," + nParticipante + "," + nProceso + ");\"><img src=\"../images/ico-integrado.png\" title=\"Anexo integrado\" /></a>"
                        }
                        else {
                            if (Anexo.charIndEntrega == "P") {
                                if (Anexo.intNumArchivos == 0) {
                                    strAnexos += "<img src=\"../images/ico-integradoNoO.png\" title=\"El anexo no está cargado ni integrado.\" />"
                                }
                                else {
                                    strAnexos += "<a href=\"Javascript:fCambia(" + f + "," + nApartado + "," + nParticipante + "," + nProceso + ");\"><img src=\"../images/ico-integradoNo.png\" title=\"Anexo cargado pero no integrado.\"/></a>";
                                }
                            }
                        }
                    }

                    strAnexos += "<a href=\"Javascript:fGetOpciones(" + f + ", " + nApartado + ", " + nParticipante + "," + nProceso + ");\">" + Anexo.strCveAnexo + " " + Anexo.strDAnexo + "</a></li>";
                }
            });
            strAnexos += "</ul>";
            $('#div_Anexos').empty().append(strAnexos);

            $("#div_Anexos ul > li").click(function () {
                $("#div_Anexos ul > li").removeClass("active");
                $(this).addClass("active");
            });
        }
    }

    /*Función que pinta los apartados de una ER, según el filtro de estado del anexo*/
    function fPintaApartados(objJson, nApartadoSeleccionado, nParticipante, sOpFiltro) {
        strApartados = "";
        $('#div_Anexos').empty();
        $('#div_Opciones').empty();
        fCambiaAvance();
        if (objJson.lstProcesos[intProceso].lstParticipantes[nParticipante] != null) {
            if (objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados != null &&
                objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados.length > 0) {
                strApartados += "<ul>";
                $.each(objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados, function (f, Apartado) {
                    if (Number(objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].fltAvance) == 100) {
                        if (sOpFiltro == 'I') {
                            if (containsJsonObj(Apartado.lstAnexos, "charIndEntrega", sOpFiltro)) {
                                strApartados += "<li><a href=\"Javascript:fPintaAnexos(" + f + ", " + nParticipante + "," + intProceso + "," + (-1) + ",'" + "I" + "');\">" + Apartado.strApartado +
                                                    " " + Apartado.strDescApartado + "</a></li>";
                            }
                        }
                        else if (sOpFiltro == 'P') {
                            strApartados += "<li " + (nApartadoSeleccionado == f ? "class=\"active\"" : "") + " >";
                            if (containsJsonObj(Apartado.lstAnexos, "charIndEntrega", sOpFiltro)) {
                                strApartados += "<a href=\"Javascript:fGetNumArchivosXAnexo(" + f + ", " + nParticipante + "," + intProceso + ",'" + sOpFiltro + "');\">" + Apartado.strApartado +
                                            " " + Apartado.strDescApartado + "</a></li>";
                            }
                            else {
                                strApartados += "<li><a href=\"Javascript:fPintaAnexos(" + f + ", " + nParticipante + "," + intProceso + "," + (-1) + ",'" + "I" + "');\">" + Apartado.strApartado +
                                                    " " + Apartado.strDescApartado + "</a></li>";
                            }
                        }
                    }
                    else if (Number(objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].fltAvance) == 0) {
                        if (sOpFiltro != 'E') {
                            strApartados += "<li><a href=\"Javascript:fGetNumArchivosXAnexo(" + f + ", " + nParticipante + "," + intProceso + ",'" + "P" + "');\">" + Apartado.strApartado +
                                    " " + Apartado.strDescApartado + "</a></li>";
                        }
                    }
                    else if (Number(objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].fltAvance) > 0 && Number(objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].fltAvance) < 100) {
                        if (containsJsonObj(Apartado.lstAnexos, "charIndEntrega", sOpFiltro)) {
                            strApartados += "<li " + (nApartadoSeleccionado == f ? "class=\"active\"" : "") + " >";
                            if (sOpFiltro == 'P') {
                                strApartados += "<a href=\"Javascript:fGetNumArchivosXAnexo(" + f + ", " + nParticipante + "," + intProceso + ",'" + sOpFiltro + "');\">" + Apartado.strApartado +
                                                " " + Apartado.strDescApartado + "</a></li>";
                            }
                            else if (sOpFiltro == 'I') {
                                strApartados += "<a href=\"Javascript:fPintaAnexos(" + f + ", " + nParticipante + "," + intProceso + "," + (-1) + ",'" + sOpFiltro + "');\">" + Apartado.strApartado +
                                                " " + Apartado.strDescApartado + "</a></li>";
                            }
                            else if (sOpFiltro == 'E') {
                                strApartados += "<a href=\"Javascript:fPintaAnexos(" + f + ", " + nParticipante + "," + intProceso + "," + (-1) + ",'" + sOpFiltro + "');\">" + Apartado.strApartado +
                                                " " + Apartado.strDescApartado + "</a></li>";
                            }
                        }
                        else {
                            if (sOpFiltro == 'I') {
                                if (!containsJsonObj(Apartado.lstAnexos, "charIndEntrega", "E") && !containsJsonObj(Apartado.lstAnexos, "charIndEntrega", "P")) {
                                    strApartados += "<li><a href=\"Javascript:fGetNumArchivosXAnexo(" + f + ", " + nParticipante + "," + intProceso + ",'" + "P" + "');\">" + Apartado.strApartado +
                                    " " + Apartado.strDescApartado + "</a></li>";
                                }
                            }
                        }
                    }
                });
                strApartados += "</ul>";
                $('#div_Apardados').empty().append(strApartados);

                $("#div_Apardados ul > li").click(function () {
                    $("#div_Apardados ul > li").removeClass("active");
                    $(this).addClass("active");
                });
            }
        }
    }

    /*Función que regresa el numero de anexos de una ER*/
    function fGetNumeroAnexos(objJson) {
        var nNumAnexos = 0;
        for (i = 0; i < objJson.lstApartados.length; i++) {
            nNumAnexos = nNumAnexos + objJson.lstApartados[i].lstAnexos.length;
        }
        return nNumAnexos;
    }

    /*Función que pinta los procesos (combo) en donde esta participando un usuario*/
    function fPintaCombosN2Procesos(objJson) {
        strHtmlDepcias = "";
        strHtmlPuestos = "";
        if (objJson != null) {
            strHtmlDepcias += "<select id=\"slc_depcias\">";
            for (k = 0; k < objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes.length; k++) {
                strHtmlDepcias += "<option value=\"" + k + "\">" + objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[k].strDDepcia + "</option>";
            }
            strHtmlDepcias += "</select>";
            $("#div_depcias").html(strHtmlDepcias);
            $("#div_puestos").html(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[$("#slc_depcias option:selected").val()].strDPuesto);


            $('#lbl_strTitular').empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioT);
            $('#lbl_strSObligado').empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioO);
            $('#lbl_Perfil').empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[$("#slc_depcias option:selected").val()].strPerfilUsuario);
            $('#lbl_EEntrega').empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[$("#slc_depcias option:selected").val()].strEstatusP);
            
            intParticipante = $("#slc_depcias option:selected").val(); 
            intProceso = $("#slc_fProcesos option:selected").val();

            if (objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORANEO') { 
                $("#div_ext").show();
                $("#lbl_strCorteEx").empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[intParticipante].dteFFin);
            }
            else {
                $("#div_ext").hide();
            }
            fPintaFiltroAnexos(objJson, $("#slc_depcias option:selected").val(), "INICIO", "");
            fPintaApartados(objJson, -1, $("#slc_depcias option:selected").val(), $("#slc_fAnexos option:selected").val());
            fCambiaAvance();

            $('#slc_depcias').change(function () {
                NG.Var[NG.Nact].botones(null, null, "INICIO");

                $("#div_Anexos").empty();
                $("#div_Opciones").empty();
                intParticipante = $(this).val();
                if (objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORANEO') { //(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                    $("#div_ext").show();
                    $("#lbl_strCorteEx").empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].lstParticipantes[intParticipante].dteFFin);
                }
                else {
                    $("#div_ext").hide();
                }
                $("#slc_puestos").val($(this).val());

                fPintaFiltroAnexos(NG.Var[NG.Nact - 1].datoSel, intParticipante, "INICIO", "");
                fPintaApartados(NG.Var[NG.Nact - 1].datoSel, -1, intParticipante, $("#slc_fAnexos option:selected").val());

                NG.Var[NG.Nact].botones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante],
                                                        null,
                                                        "ENVIO");

                $("#lbl_strTitular").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioT); // Para mostrar el titular
                $("#lbl_strSObligado").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioO);
                $('#lbl_Perfil').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strPerfilUsuario);
                $('#lbl_EEntrega').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strEstatusP);
                                
                fCambiaAvance();
            });
        }
    }

    /* Función que pinta el proceso y los participantes(dependencias) donde participa un usuario (un solo proceso) */
    function fPintaCombosN2(objJson) {
        strHtmlDepcias = "";
        strHtmlPuestos = "";
        if (objJson != null) {
            strHtmlDepcias += "<select id=\"slc_depcias\">";
            for (k = 0; k < objJson.lstProcesos[0].lstParticipantes.length; k++) {
                strHtmlDepcias += "<option value=\"" + k + "\">" + objJson.lstProcesos[0].lstParticipantes[k].strDDepcia + "</option>";
            }
            strHtmlDepcias += "</select>";
            
            $("#div_depcias").html(strHtmlDepcias);
            $("#div_puestos").html(objJson.lstProcesos[0].lstParticipantes[$("#slc_depcias option:selected").val()].strDPuesto);


            $('#lbl_strTitular').empty().append(objJson.lstProcesos[0].lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioT);
            
            $('#lbl_strSObligado').empty().append(objJson.lstProcesos[0].lstParticipantes[$("#slc_depcias option:selected").val()].strNomUsuarioO);
            $('#lbl_Perfil').empty().append(objJson.lstProcesos[0].lstParticipantes[$("#slc_depcias option:selected").val()].strPerfilUsuario);
            $('#lbl_EEntrega').empty().append(objJson.lstProcesos[0].lstParticipantes[$("#slc_depcias option:selected").val()].strEstatusP);

            intParticipante = $("#slc_depcias option:selected").val(); 
            
            if (objJson.lstProcesos[0].lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORANEO') { 
                $("#div_ext").show();
                $("#lbl_strCorteEx").empty().append(objJson.lstProcesos[0].lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[0].lstParticipantes[intParticipante].dteFFin);
            }
            else {
                $("#div_ext").hide();
            }
            fPintaFiltroAnexos(objJson, $("#slc_depcias option:selected").val(), "INICIO", "");
            fPintaApartados(objJson, -1, $("#slc_depcias option:selected").val(), $("#slc_fAnexos option:selected").val());
            fCambiaAvance();

            $('#slc_depcias').change(function () {
                NG.Var[NG.Nact].botones(null, null, "INICIO");
                
                $("#div_Anexos").empty();
                $("#div_Opciones").empty();
                intParticipante = $(this).val();
                if (objJson.lstProcesos[0].lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORANEO') { //(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                    $("#div_ext").show();
                    $("#lbl_strCorteEx").empty().append(objJson.lstProcesos[0].lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[0].lstParticipantes[intParticipante].dteFFin);
                }
                else {
                    $("#div_ext").hide();
                }
                $("#slc_puestos").val($(this).val());
                
                fPintaFiltroAnexos(NG.Var[NG.Nact - 1].datoSel, intParticipante, "INICIO", "");
                fPintaApartados(NG.Var[NG.Nact - 1].datoSel, -1, intParticipante, $("#slc_fAnexos option:selected").val());

                NG.Var[NG.Nact].botones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante],
                                                        null,
                                                        "ENVIO");

                $("#lbl_strTitular").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioT); // Para mostrar el titular
                
                $("#lbl_strSObligado").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioO);
                $('#lbl_Perfil').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strPerfilUsuario);
                $('#lbl_EEntrega').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strEstatusP);
                                
                fCambiaAvance();
            });
        }

    }

    /*Función que determina si una lista de objeto contiene un objeto buscando por alguna propiedad de cada objeto*/
    function containsJsonObj(objLst, name, value) {
        var isExists = false;
        $.each(objLst, function () {
            if (this[name] == value) {
                isExists = true;
                return false;
            } 
        });
        return isExists;
    };

    /*Función que limpia el objeto filtro*/
    function fLimpiaFiltro() {
        $.each(objFiltro.filtro, function (k, elem) {
            objFiltro.filtro.splice(k, 1);
        });
    }

    /*Pinta el filtro del estado de los anexos*/
    function fPintaFiltroAnexos(objProceso, nParticipante, strOpcion, strSeleccionado) {
        var objDato;
        var nPosAnexo = -1;
        fLimpiaFiltro();
        if (strOpcion == 'INICIO') {
            $.each(objProceso.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados, function (k, Apartado) {
                $.each(Apartado.lstAnexos, function (f, Anexo) {
                    if (f == 0 && k == 0) {
                        
                        objDato = eval('(' + strDato + ')');
                        objDato.valor = Anexo.charIndEntrega;
                        objDato.etiqueta = (Anexo.charIndEntrega == 'E' ? 'Excluido' : (Anexo.charIndEntrega == 'P' ? 'Pendiente' : 'Integrado'));
                        objDato.ID = (Anexo.charIndEntrega == 'E' ? 3 : (Anexo.charIndEntrega == 'P' ? 1 : 3));
                        objFiltro.filtro[f] = objDato;
                    }
                    else {
                        if (!containsJsonObj(objFiltro.filtro, "valor", Anexo.charIndEntrega)) {
                            objDato = eval('(' + strDato + ')');
                            objDato.valor = Anexo.charIndEntrega;
                            objDato.etiqueta = (Anexo.charIndEntrega == 'E' ? 'Excluido' : (Anexo.charIndEntrega == 'P' ? 'Pendiente' : 'Integrado'));
                            objDato.ID = (Anexo.charIndEntrega == 'E' ? 3 : (Anexo.charIndEntrega == 'P' ? 1 : 3));
                            objFiltro.filtro[objFiltro.filtro.length] = objDato;
                        }
                    }
                });
            });
            
        }
        else if (strOpcion == 'INTEGRAR') {
            if (objFiltro.filtro != null) {
                var i = 0;

                $.each(objProceso.lstParticipantes[nParticipante].lstApartados, function (k, Apartado) {
                    $.each(Apartado.lstAnexos, function (f, Anexo) {
                        if (f == 0 && k == 0) {
                            objDato = eval('(' + strDato + ')');
                            objDato.valor = Anexo.charIndEntrega;
                            objDato.etiqueta = (Anexo.charIndEntrega == 'E' ? 'Excluido' : (Anexo.charIndEntrega == 'P' ? 'Pendiente' : 'Integrado'));
                            objDato.ID = (Anexo.charIndEntrega == 'E' ? 3 : (Anexo.charIndEntrega == 'P' ? 1 : 3));
                            objFiltro.filtro[i] = objDato;
                            i++;
                        }
                        else {
                            if (!containsJsonObj(objFiltro.filtro, "valor", Anexo.charIndEntrega)) {
                                objDato = eval('(' + strDato + ')');
                                objDato.valor = Anexo.charIndEntrega;
                                objDato.etiqueta = (Anexo.charIndEntrega == 'E' ? 'Excluido' : (Anexo.charIndEntrega == 'P' ? 'Pendiente' : 'Integrado'));
                                objDato.ID = (Anexo.charIndEntrega == 'E' ? 3 : (Anexo.charIndEntrega == 'P' ? 1 : 3));
                                objFiltro.filtro[i] = objDato;
                                i++;
                            }
                        }
                    });
                });
            }
        }
                
        objFiltro.filtro.sort(SortByID);
        strHtmlOpciones = "<select id=\"slc_fAnexos\">";
        for (i = 0; i < objFiltro.filtro.length; i++) {
            strHtmlOpciones += "<option value=\"" + objFiltro.filtro[i].valor + "\">" + objFiltro.filtro[i].etiqueta + "</option>";
        }
        strOpciones = "</select>"; 
        $("#div_EAnexos").empty().append(strHtmlOpciones);

        if (strSeleccionado != "") {
            if (containsJsonObj(objFiltro.filtro, "valor", strSeleccionado)) {
                $("#slc_fAnexos").val(strSeleccionado);
            }
            else {
                $("#slc_fAnexos").val($("#slc_fAnexos option:first").val());
            }
        }

        $('#slc_fAnexos').change(function () {
            $("#div_Anexos").empty();
            $("#div_Opciones").empty();
            if (strOpcion == 'Inicio') {
                fPintaApartados(objProceso, -1, nParticipante, $(this).val());
            }
            else {
                fPintaApartados(NG.Var[NG.Nact - 1].datoSel, -1, nParticipante, $(this).val());
            }
        });
    }

    /*Función de ordenamiento para el filtro de estado de los anexos*/
    function SortByID(x, y) {
        return x.ID - y.ID;
    }

    /*Función que pinta el detalle del proceso y determina si el usuario esta participando en 1 o más procesos*/
    function fPintaDatosProcesosER(objJson) {
        strHTMLProcesos = "";
        try {
            if (objJson != null) {
               if (objJson.lstProcesos.length == 1) { 
                    intProceso = 0;
                    $("#div_procesos").html("<label>" + objJson.lstProcesos[0].strProceso + ' ' + objJson.lstProcesos[0].strDProceso + "</label>");
                    $("#lbl_strCorte").html(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                    $("#lbl_guia").empty().append(objJson.lstProcesos[0].sDGuiaER);
                    fPintaCombosN2(objJson);
                }
                else if (objJson.lstProcesos.length > 1) {
                    strHTMLProcesos = "<select id=\"slc_fProcesos\">";
                    $.each(objJson.lstProcesos, function (k, Proceso) {
                        strHTMLProcesos += "<option value=\"" + k + "\">" + Proceso.strProceso + ' ' +Proceso.strDProceso + "</option>";
                    });
                    strHTMLProcesos += "</select>"; 
                    $("#div_procesos").empty().append(strHTMLProcesos); // 
                    $("#lbl_strCorte").html(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].dteFInicio + " al " + objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].dteFFin);
                    $("#lbl_guia").empty().append(objJson.lstProcesos[$("#slc_fProcesos option:selected").val()].sDGuiaER);

                    fPintaCombosN2Procesos(objJson);
                    $('#slc_fProcesos').change(function () {
                        
                        /*PARA CAMBIAR PARTICIPANTE*/
                        NG.Var[NG.Nact].botones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[$(this).val()].lstParticipantes[$("#slc_depcias option:selected").val()], null, "INICIO");

                        $("#div_Anexos").empty(); 
                        $("#div_Opciones").empty();

                        intProceso = $(this).val();

                        $("#lbl_strCorte").html(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].dteFInicio + " al " + objJson.lstProcesos[intProceso].dteFFin);
                        $("#lbl_guia").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].sDGuiaER);
                        fPintaCombosN2Procesos(objJson);


                    });
                }
            }
        }
        catch (e) {
            $("#div_contenido").css("display", "none");
            $('#div_mensaje').css("display", "block");
        }

    }
    /*Función que determina si un usuario participa o no en algún proceso ER*/
    function fPintaDatos(objJson) {
        
        if (Number(objJson.intTieneProcesos) == 1) {
            $("#div_mensaje").css("display", "none");
            $('#div_contenido').css("display", "block");
            fPintaDatosProcesosER(objJson);
        }
        else if (Number(objJson.intTieneProcesos) == 0) {
            
            $("#div_contenido").css("display", "none");
            $('#div_mensaje').css("display", "block");

            $("#AccEnviarEntrega").hide();
            $("#AccEnviarEntrega2").hide();

            $("#AccNotificaciones").hide();
            $("#AccNotificaciones2").hide();

            $("#AccReporte").hide();
            $("#AccReporte2").hide();
            loading.close();
        }

    }

    /*Función que obtiene el anexo y su listado de archivos, que seran desplegados en una ventana modal, para continuar cargando archivos o consultarlos*/
    function fConsultarArchivos(nAnexo, nApartado, nParticipante, nProceso) {
        intProceso = nProceso;
        intParticipante = nParticipante;
        intApartado = nApartado;
        intAnexo = nAnexo;

        $("#hf_NG").val(JSON.stringify(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]));
        dTxt = '<div id="dComent" title="Consulta de archivos">';
        dTxt += '<iframe id="SCCONSULT" src="SCCONSULT.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form2').append(dTxt);
        $("#dComent").dialog({
            autoOpen: true,
            height: 600,
            width: 1000,
            modal: true,
            resizable: true
        });
        $(".panel-tool-close").remove();
    }

    /*Función que abre la venta donde se cargan los archivos*/
    function fCargarArchivo(objJSON) {
        $("#hf_NG").val(JSON.stringify(objJSON));
        dTxt = '<div id="dComent2" title="Carga de archivos">';
        dTxt += '<iframe id="SCKCARGAR" src="SCKCARGAR.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        dTxt += '</div>';
        $('#form2').append(dTxt);
        $("#dComent2").dialog({
            autoOpen: true,
            height: 650,
            width: 680,
            modal: true,
            resizable: true
        });
    }

    /*Función que abre el Dialog donde se descargan los Formatos/Guías*/
    function fFormatoGuia(nAnexo, nApartado, nParticipante, nProceso) {
        $("#hf_NG").val(JSON.stringify(NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]));
        dTxt = '<div id="dComentFG" title="Descarga de archivo e instructivo">';
        dTxt += '<iframe id="SAAGUIAER" src="SCDARVSFG.aspx' + '" frameBorder="0" style="width:90%;border-style:none;border-width:0px;height:90%;"></iframe>';
        dTxt += '</div>';
        $('#form2').append(dTxt);
        $("#dComentFG").dialog({
            autoOpen: true,
            height: (NG.Var[NG.Nact - 1].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo].chrFuente == 'U' ? 200 : 350),
            width: 770,
            modal: true,
            resizable: false
        });
    }

    /*Función que actualiza la lista de archivos despues de cargar o eliminar un archivo*/
    function fActualizaAnexo(objJSON) {
        for (a_i = 0; a_i < NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos.length; a_i++) {
            if (objJSON.gidFormato == NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos[a_i].gidFormato) {
                NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos.splice(a_i, 1);
                break;
            }
        }
        NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos--;
        if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos < 0)
            NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos = 0;
    }

    /*función que se utiliza cuando se cierra el dialog que carga archivos al anexo */
    function fCerrarDialog2(strOpcion, strAccion) {
        if (strOpcion == 'EXITO') {
            if (strAccion == 'INSERT') {
                NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos++;
            }
            NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].strOpcion = 'CARGA';
            NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].strAccion = 'ARCHIVOS'; //
            fGetDatosAnexo(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo]
            , intAnexo, intApartado, intParticipante, intProceso,"Consulta");
        }
      
        $('#dComent2').dialog("close");
        $("#dComent2").dialog("destroy");
        $("#dComent2").remove();
    }
    
    /*función que se utiliza cuando se cierra el dialog donde se listan los archivos cargados de una anexo*/
    function fCerrarDialog() {
        if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos != null) {
            if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos.length == 0) {
                NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos = 0;
                NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos = null;
            }
            else {
                NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos.length;
            }
        }
        else {
            NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos = 0;
            NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos = null;
        }
        fPintaAnexos(intApartado, intParticipante, intProceso, intAnexo, $("#slc_fAnexos option:selected").val());
        fPintaOpciones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo]
                       , NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante]
                       , intAnexo
                       , intApartado
                       , intParticipante
                       , intProceso);
        $('#dComent').dialog("close");
        $("#dComent").dialog("destroy");
        $("#dComent").remove();

    }

    /*Función que cierra el Dialog de formato/guía*/
    function fCerrarDialogFG() { 
        $('#dComentFG').dialog("close");
        $("#dComentFG").dialog("destroy");
        $("#dComentFG").remove();
    }
    
    /*Función inicial (se ejecuta en el DocumentReady) que consulta el/los proceso(s) donde esta participando un usuario*/ 
    function fGetInformacion(objProceso) {
        var strDatos = "";
        
        if (objProceso == null) {
            var strDatos = "{\"idUsuario\": " + $('#hf_idUsuario').val() +
                                ",\"intTieneProceso\": " + 0 +
                                ",\"strAccion\": " + "\"PROCESOS\"" +
                                ",\"strOpcion\": " + "\"CARGA\"" +
                            "}";
            objProceso = eval('(' + strDatos + ')');
        }
        actionData = JSON.stringify({ objProceso: objProceso });
        $.ajax(
                {
                    url: "SCACARINF.aspx/pGetDatosER",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        try {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                NG.Var[NG.Nact - 1].datoSel = eval('(' + reponse.d + ')');

                                if (NG.Var[NG.Nact - 1].datoSel != null) {
                                    fPintaDatos(NG.Var[NG.Nact - 1].datoSel);
                                    NG.Var[NG.Nact].botones(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante],
                                                        null,
                                                        "ENVIO");
                                    $('#hf_idUsuario').val('');
                                    
                                }
                            }
                        }
                        catch (e) {
                            $("#div_contenido").css("display", "none");
                            $('#div_mensaje').css("display", "block");
                        }
                    },
                    error: errorAjax
                }
        );
    };

    /*Función que se ejecuta cuando se envía una ER*/
    function Entregar() {
        jConfirm('Al enviar la información conformada en este proceso de entrega - recepción deshabilitará la opción de carga de información \n\n  ¿Desea continuar?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
            if (r) {
                loading.ini();
                objParticipante = NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante];
                objParticipante.idUsuario = NG.Var[NG.Nact - 1].datoSel.idUsuario;
                objParticipante.strAccion = "ENVIAR_ER";
                actionData = JSON.stringify({ objParticipante: objParticipante });
                $.ajax(
                {
                    url: "SCACARINF.aspx/pEntrega",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        try {
                            if (frms.trim(reponse.d) != '') { 
                                objParticipante = eval('(' + reponse.d + ')');
                                if (objParticipante != null) {
                                    loading.close();
                                    if (objParticipante.strResp == '1') {
                                        
                                        jAlert('Operación realizada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                            NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes.splice(intParticipante, 1);
                                            if (NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes.length == 0) {
                                                if (NG.Var[NG.Nact - 1].datoSel.lstProcesos.length == 1) {
                                                    NG.Var[NG.Nact - 1].datoSel.lstProcesos.splice(intProceso, 1);

                                                    NG.Var[NG.Nact].botones(null,
                                                                        null,
                                                                        "ENVIO");
                                                    $("#div_mensaje").empty().append("Se ha concluido su proceso entrega - recepción.");
                                                    $("#div_contenido").css("display", "none");
                                                    $('#div_mensaje').css("display", "block");

                                                    $("#AccEnviarEntrega").hide();
                                                    $("#AccEnviarEntrega2").hide();

                                                    $("#AccNotificaciones").hide();
                                                    $("#AccNotificaciones2").hide();

                                                    $("#AccReporte").hide();
                                                    $("#AccReporte2").hide();
                                                }
                                                else {
                                                    NG.Var[NG.Nact - 1].datoSel.lstProcesos.splice(intProceso, 1);
                                                    fGetInformacion(NG.Var[NG.Nact - 1].datoSel);
                                                }
                                            }
                                            else {
                                                fGetInformacion(NG.Var[NG.Nact - 1].datoSel);
                                            }
                                        });
                                    }
                                    else if (objParticipante.strResp == '-1') {
                                        jAlert('La configuración de anexos a entregar ha cambiado, se cargarán nuevamente los anexos que debe entregar', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                            fGetInformacion(NG.Var[NG.Nact - 1].datoSel);
                                        });
                                    }
                                }
                            }
                        }
                        catch (e) {
                            $("#div_contenido").css("display", "none");
                            $('#div_mensaje').css("display", "block");

                            $("#AccEnviarEntrega").hide();
                            $("#AccEnviarEntrega2").hide();

                            $("#AccNotificaciones").hide();
                            $("#AccNotificaciones2").hide();

                            $("#AccReporte").hide();
                            $("#AccReporte2").hide();
                        }
                    },
                    beforeSend: loading.iniSmall(),
                    complete: loading.closeSmall(),
                    error: errorAjax
                }
        );
            }
        });
    }

    /* Función que abre un Dialog para solicitar la apertura de una proceso*/
    function fSolicitaApertura() {
        dTxt = '<div id="dComent" title="Incluir anexo">';
        dTxt += '<iframe id="frm_Usuarios" src="Registro/SCAAPERTU.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
        
        dTxt += '</div>';
        $('#form2').append(dTxt);
        $("#dComent").dialog({
            autoOpen: true,
            height: 500,
            width: 750,
            modal: true,
            resizable: false
        });
    }

    /* Función que cierra el Dialod de la apertura de un proceso*/
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

    /* Función que se lanza al precionar el boton de cancelar en el Dialog donde se listan los archivos cargados*/
    function fCancelar() {
        $('#dComent').dialog("close");
        $("#dComent").dialog("destroy");
        $("#dComent").remove();              
    }
    
    /* Función que actualiza el área de información con una página para poder escribir una notificación*/
    function Enviarcorreo() {
        urls(1, "../Registro/SCAENVIO.aspx");
    }

</script>
    <form id="form2" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion"> 
            <label class="titulo">Integración de información</label>
            <div class="a_acciones">
                <a id="AccEnviarEntrega" title="Enviar entrega" href="javascript:Entregar();" class="accAct">Enviar entrega</a>
                <a id="AccEnviarEntrega2" title="Enviar entrega" class="accIna iOculto">Enviar entrega</a>
            
                <%--<a id="AccSolicitarApertura" title="Solicitar apertura" href="javascript:fSolicitaApertura();" class="accAct iOculto">Solicitar apertura</a>
                <a id="AccSolicitarApertura2" title="Solicitar apertura" class="accIna">Solicitar apertura</a>--%>

                <%--<a id="AccNotificaciones" title="Notificaciones" href="#" class="accAct iOculto">Notificaciones</a>
                <a id="AccNotificaciones2" title="Notificaciones" class="accIna">Notificaciones</a>--%>

                <a id="AccEnviarNvo" title="Enviar correo" href="javascript:Enviarcorreo();" class="accAct">Redactar correo</a>
            </div>
        </div>

        <div class="instrucciones">Seleccione la información requerida:</div>

        <div id="div_mensaje">No tiene procesos asociados.</div>

        <div id="div_contenido">
            <!-- Desplegado contenidos -->
            <h2>Proceso entrega - recepci&oacute;n:</h2>&nbsp;&nbsp;<div id="div_procesos"></div>
            <br />
            <h2>Periodo:</h2>&nbsp;&nbsp;<label id="lbl_strCorte"></label>
            <br />

            <h2>Dependencia/entidad:</h2>&nbsp;&nbsp;<div id="div_depcias"></div>
            <br />
            <h2>Puesto/cargo:</h2>&nbsp;&nbsp;<div id="div_puestos"></div><br />
            <h2>Titular:</h2>&nbsp;&nbsp;<label id="lbl_strTitular"></label>
            <h2>Sujeto obligado:</h2>&nbsp;&nbsp;<label id="lbl_strSObligado"></label>
            <h2>Perfil:</h2>&nbsp;&nbsp;<label id="lbl_Perfil"></label>
            <br />
            <h2>Estado de la entrega:</h2>&nbsp;&nbsp;<label id="lbl_EEntrega"></label>
            <div id="div_ext"><h2>Fecha de apertura extemporánea:</h2>&nbsp;&nbsp;<label id="lbl_strCorteEx"></label></div>
            <h2>Avance:</h2>&nbsp;&nbsp;<label id="lbl_avance"></label>
            <br />
            <h2>Guía:</h2>&nbsp;&nbsp;<label id="lbl_guia"></label>
            <br />
<%--            <div id="div_guia">
                
            </div>--%>            

            <h2>Estado de los anexos:</h2>&nbsp;&nbsp;<div id="div_EAnexos"></div>
            <br />

            <div class="easyui-layout" style="width: 90%; height: 100px;" data-options="fit:true">
                <div data-options="region:'west',split:true " title="Apartados" style="width: 300px;">
                    <div id="div_Apardados"></div>
                </div>
                <div data-options="region:'center',split:true,title:'Anexos',iconCls:'icon-ok'" style="width: 100px;">
                    <div id="div_Anexos"></div>
                </div>
                <div data-options="region:'east',split:true" title=" " style="width: 300px;">
                    <div id="div_Opciones"></div>
                </div>
            </div>
            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
                <asp:HiddenField ID="hf_NG" runat="server" />

            </div>
        </div>
        <!-- fin Desplegado contenidos -->
    </div>
    
    </form>
</body>
</html>
