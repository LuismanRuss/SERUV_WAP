<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SSSMONDEP" Codebehind="SSSMONDEP.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../styles/jquery.treetable.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.treetable.theme.default.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery.treetable.js" type="text/javascript"></script>
</head>
<body>
    <script type="text/javascript">
        var datosGenerales = null;
        var apartados = null;
        var apartados2 = null;
        var nombreDepcia = null;
        var nombreProc = null;
        var idProceso = null;
        var idParticipante = null;
        var nDepcia = null;

        function BotonesSSSMONDEP(selec) {
            if (selec > 0) {//Seleccionado
                $("#AccExportar, #AccAbrirProc, #AccNotificaciones").show();
                $("#AccExportar2, #AccAbrirProc2").hide();
            }
            else {// No Seleccionado
                $("#AccAbrirProc").hide();
                $("#AccNotificaciones").show();
                $("#AccExportar2").hide();
                $("#AccExportar").show();
            }
        }


        function fAjax(idParticipante) {//FUNCIÓN QUE SE VA AL SERVIDOR Y REGRESA LOS DATOS GENERALES DE LA DEPENDENCIA, SUS ANEXOS Y APARTADOS
            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'idParticipante': '" + idParticipante +
                             "','idUsuario': '" + nIdUsuario +
                         "'}"; ;
            $.ajax(
                {
                    url: "SSSMONDEP.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        Pinta_Datos(eval('(' + reponse.d + ')'));
                    },
                    error: errorAjax
                });
        }

        $(document).ready(function () {
            $("#aPerfiles").hide();
            if (NG.Nact == 1) {
                var idParticipante = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc].nIdParticipante;
            } else {
                if (NG.Var[NG.Nact - 1].selec == 0) {
                    var idParticipante = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc].nIdParticipante;
                } else {
                    var idParticipante = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdParticipante;
                }
            }

            NG.setNact(2, 'Dos', BotonesSSSMONDEP);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            fAjax(idParticipante);
        });

        function fCancelar() {//FUNCIÓN QUE ME REGRESA A LA PÁGINA ANTERIOR
            loading.ini();
            urls(2, "SSSMONPRO.aspx");
        }

        function Pinta_Datos(datos) {//FUNCIÓN QUE PINTA LOS DATOS GENERALES DE LA DEPENDENCIA Y MANDA A LLAMAR LA FUNCIÓN QUE PINTA EL CONTROL DE LOS APARTADOS Y ANEXOS
            datosGenerales = datos.datos[1];
            apartados = datos.datos[0];
            enlacesOperativos = datos.datos[2];
            enlacesOperativosReceptores = datos.datos[3];

            if (fTieneArchivosProceso(apartados)) {
                $("#AccExportar").attr("href", "../General/SGDCARZIP.aspx?strOpcion=proceso&participante=" + datosGenerales[0].nIdParticipante + "&proceso=" + datosGenerales[0].nIdProceso + "&ID=" + datosGenerales[0].nIdProceso);
            } else {
                $("#AccExportar2").show();
                $("#AccExportar").hide();
            }

            idParticipante = datosGenerales[0].nIdParticipante;
            var cveDepcia = datosGenerales[0].nDepcia;
            var usuarioObligado = datosGenerales[0].usuarioObligado;
            var periodo = datosGenerales[0].dFInicio + '  al  ' + datosGenerales[0].dFFinal;
            nombreProc = periodo;
            var edoEntrega = datosGenerales[0].cEstatus;
            var depcia = datosGenerales[0].sDDepcia
            nombreDepcia = depcia;
            var nombreProce = datosGenerales[0].sDProceso
            $('#hf_proceso').val(nombreProce);
            var perfil = datosGenerales[0].sDPuesto
            var avanceGeneral = datosGenerales[0].avanceGeneral;
            var indEntrega = datosGenerales[0].cIndEntrega;
            var estatusProc = datosGenerales[0].cEstatusProc;
            var perfilUsuarioEntra = null;
            var cIndActivo = datosGenerales[0].cIndActivo;
            var cIndEntregaDep = datosGenerales[0].cIndEntregaDepcia;
            var cEstatusDep = datosGenerales[0].cEstatusDepcia;
            var anexIntegrados = datosGenerales[0].anexIntegrados;
            var anexTotales = datosGenerales[0].anexTotales;
            var guia = datosGenerales[0].sGuiaER;
            var usuarioReceptor = datosGenerales[0].usuarioReceptor;

            if (datosGenerales[0].dextemInicio != null) {
                var periodoExtemporaneo = datosGenerales[0].dextemInicio + ' al ' + datosGenerales[0].dextemFinal;
            } else {
                var periodoExtemporaneo = 'NO DEFINIDO';
            }

            var cIndCerrado = datosGenerales[0].cIndCerrado;
            idProceso = datosGenerales[0].nIdProceso;

            //dialog para perfiles-----------------------------
            if (datosGenerales[0].laPerfiles.length == 1) {
                perfilUsuarioEntra = datosGenerales[0].laPerfiles[0].sPerfil;
                $("#lblPerfil").text(perfilUsuarioEntra);
            } else {
                htmlTab = '';
                var d = datosGenerales;

                $("#lblPerfil").hide();

                htmlTab += '<div><a class="ackDialog" href="#fixme">VER PERFILES..</a></div>';
                htmlTab += '<div class="dialoG oculto"><ul>';
                for (i = 0; i < d[0].laPerfiles.length; i++) {
                    htmlTab += '<li>' + d[0].laPerfiles[i].sPerfil + '</li>';
                }
                htmlTab += '</ul></div></td>';
                $("#div").append(htmlTab);
            }


            //----dialog para los enlaces operativos------
            if (enlacesOperativos == null) {
                $("#lblEnlaceOperativo").text("NO HAY ENLACES OPERATIVOS CONFIGURADOS ");
            }
            else if (enlacesOperativos.length == 1) {
                var enlaceOperativo = enlacesOperativos[0].enlaceOperativo;
                if (enlacesOperativos[0].cIndPrincipal == 'S') {
                    $("#lblEnlaceOperativo").text(enlaceOperativo + ' (Principal) ');
                } else {
                    $("#lblEnlaceOperativo").text(enlaceOperativo);
                }
            } else {
                htmlTab = '';
                $("#lblEnlaceOperativo").hide();

                htmlTab += '<div><a class="ackDialog" href="#fixme">VER ENLACES OPERATIVOS..</a></div>';
                htmlTab += '<div class="dialoG oculto">';
                htmlTab += '<div class="a_acciones_sin"><a href="javascript: f_reporte(\'EO\');" class="accAct">Reporte</a></div> <br/><br/>';
                htmlTab += '<table style="width:99%; border-style:solid; border-width:0;"><tr>'
                htmlTab += '<td style="font-size: .7em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:50%;">NOMBRE</td>';
                htmlTab += '<td style="font-size: .7em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:49%;">CORREO ELECTRÓNICO</td>';
                htmlTab += '</tr>';

                for (i = 0; i < enlacesOperativos.length; i++) {
                    htmlTab += '<tr>'
                    if (enlacesOperativos[i].cIndPrincipal == 'S') {
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativos[i].enlaceOperativo + ' (Principal)' + '</td>';
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativos[i].sCorreo + '</td>';
                    } else {
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativos[i].enlaceOperativo + '</td>';
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativos[i].sCorreo + '</td>';
                    }
                }
                htmlTab += '</tr>';
                htmlTab += '</table>';
                htmlTab += '</div>';
                //                if (!$('.ackDialog').length) {
                $("#divEnlaceOp").append(htmlTab);
                a_di1 = new o_dialog('Enlaces');
                a_di1.iniDial();
                //                }
            }


            //----dialog para los enlaces operativos Receptores------
            if (enlacesOperativosReceptores == null) {
                $("#lblEnlaceOperativoReceptor").text("NO HAY ENLACES OPERATIVOS RECEPTORES CONFIGURADOS");
            }
            else if (enlacesOperativosReceptores.length == 1) {
                var enlaceOperativoReceptor = enlacesOperativosReceptores[0].enlaceOperativoReceptor;
                if (enlacesOperativosReceptores[0].cIndPrincipalR == 'S') {
                    $("#lblEnlaceOperativoReceptor").text(enlaceOperativoReceptor + ' (Principal) ');
                } else {
                    $("#lblEnlaceOperativoReceptor").text(enlaceOperativoReceptor);
                }
            } else {

                htmlTab = '';
                $("#lblEnlaceOperativoReceptor").hide();

                htmlTab += '<div ><a class="ackDialog" href="#fixme">VER ENLACES OPERATIVOS RECEPTORES..</a></div>';
                htmlTab += '<div class="dialoG oculto">';
                htmlTab += '<div class="a_acciones_sin"><a href="javascript: f_reporte(\'EOR\');" class="accAct">Reporte</a></div> <br/><br/>';
                htmlTab += '<table style="width:99%; border-style:solid; border-width:0;"><tr>'
                htmlTab += '<td style="font-size: .7em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:50%;">NOMBRE</td>';
                htmlTab += '<td style="font-size: .7em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:49%;">CORREO ELECTRÓNICO</td>';
                htmlTab += '</tr>';

                for (i = 0; i < enlacesOperativosReceptores.length; i++) {

                    htmlTab += '<tr>'
                    if (enlacesOperativosReceptores[i].cIndPrincipalR == 'S') {
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativosReceptores[i].enlaceOperativoReceptor + '(Principal)' + '</td>';
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativosReceptores[i].sCorreo + '</td>';
                    } else {
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativosReceptores[i].enlaceOperativoReceptor + '</td>';
                        htmlTab += '<td style="text-align:center;">' + enlacesOperativosReceptores[i].sCorreo + '</td>';
                    }
                }
                htmlTab += '</tr>'
                htmlTab += '</table></div>';

                //                if (!$('.ackDialog').length) {
                $("#divEnlaceOpReceptor").append(htmlTab);
                a_di2 = new o_dialog('Enlaces');
                a_di2.iniDial();
                //                }
            }

            //--------------------------------------------
            nombreProc = nombreProce;

            if (cIndEntregaDep == 'C' && cEstatusDep == 'P') {
                BotonesSSSMONDEP(1);
            } else if (cIndEntregaDep == 'C' && cEstatusDep == 'E') {
                BotonesSSSMONDEP(1);
            } else if (cIndEntregaDep == 'E' && cIndCerrado == 'S') {
                BotonesSSSMONDEP(1);
            } else {
                BotonesSSSMONDEP(0);
            }

            $("#lblDepcia").text(depcia);
            $("#lblProcER").text(nombreProc);
            $("#lblSujObl").text(usuarioObligado);

            if (usuarioReceptor == "-  ") {
                $("#lblSujRec").text('NO DEFINIDO');
            } else {
                $("#lblSujRec").text(usuarioReceptor);
            }

            $("#lblPeriodo").text(periodo);
            $("#lblPeriodoExtemp").text(periodoExtemporaneo);
            $("#lblPuesto").text(perfil);
            $("#lblAvance").text(anexIntegrados + " anexos integrados de " + anexTotales + " = " + avanceGeneral.toFixed(2) + '%');

            if (indEntrega == 'C') {
                $("#edoEntrega").text("CONCLUIDA");
            } else if (indEntrega = 'E') {
                $("#edoEntrega").text("EN PROCESO");
            }

            $("#lblGuia").text(guia);

            $("#AccExportar").hide();
            $("#AccExportar2").show();

            //---activo o desactivo el boton de exportar
            $.each(apartados, function (k, Apartado) {
                $.each(Apartado.laAnexos, function (f, Anexo) {
                    if (Anexo.nNumArchivos > 0) {
                        $("#AccExportar").show();
                        $("#AccExportar2").hide();

                    }
                });
            });
            fPintaApartadosAnexos(apartados);
        }


        function fPintaApartadosAnexos(objJson) { //  FUNCIÓN QUE PINTA EL CONTRO, DE APARTADOS Y ANEXOS
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
                strHTMLApAx += "<th>Estado</th>";
                strHTMLApAx += "<th>Archivos cargados</th>";
                strHTMLApAx += "<th>Visualizar</th>";
                strHTMLApAx += "<th>Exportar</th>";
                strHTMLApAx += "</tr>";
                strHTMLApAx += "</thead>";
                strHTMLApAx += "<tbody>";
                // aQUI SE RECOREN LOS APARTADOS Y ANEXOS
                $.each(objJson, function (k, Apartado) {
                    strHTMLApAx += "<tr data-tt-id=\"" + Apartado.nIdApartado + "\" class=\"collapsed\"><td><span style=\"padding-left: 0px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span>" +
                                (Apartado.chrAplica == 'O' ?
                                    Apartado.sApartado + " " + Apartado.sDApartado
                                    :
                                    Apartado.sApartado + " " + Apartado.sDApartado + " (CONTRALORÍA)"

                                    ) +
                                    "</span></td><td></td><td></td><td></td>" + (fGetNumeroArchivosXapartado(Apartado) > 0 ? "<td><a href=\"../General/SGDCARZIP.aspx?strOpcion=apartado&participante=" + Apartado.nIdParticipante + "&proceso=" + Apartado.nIdProceso + "&ID=" + Apartado.nIdApartado + "\">Exportar apartado</a></td>" : "<td>Sin archivos</td>") + "</tr>";


                    $.each(Apartado.laAnexos, function (f, Anexo) {
                        strHTMLApAx += "<tr data-tt-id=\"" + Apartado.nIdApartado + "-" + Anexo.nIdAnexo + "\" data-tt-parent-id=\"" + Apartado.nIdApartado + "\" style=\"display: none;\" >" +
                                                "<td><span style=\"padding-left: 19px;\"><a href=\"#\" title=\"Expand\">&nbsp;</a></span><span " + (Anexo.cIndActa == 'S' ? " style=\"color:red\"" : "") + ">" + Anexo.sAnexo + " " + Anexo.sDAnexo + "</span></td>" +

                                                "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "PENDIENTE" : (Anexo.cIndEntrega == 'I' ? "INTEGRADO" : "EXCLUIDO")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.sAnexo + ' ' + Anexo.sDAnexo + "'," + k + "," + Apartado.nIdParticipante + "," + Apartado.nIdProceso + ",'ARCHIVO'" + ");\">" + Anexo.nNumArchivos + "</a>" : Anexo.nNumArchivos) + "</td>" +
                                                "<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.sAnexo + ' ' + Anexo.sDAnexo + "'," + k + "," + Apartado.nIdParticipante + "," + Apartado.nIdProceso + ",'VISUALIZAR'" + ");\">" + Anexo.nNumArchivos + "</a>" : Anexo.nNumArchivos) + "</td>" +
                                                "<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"../General/SGDCARZIP.aspx?strOpcion=anexo&participante=" + Apartado.nIdParticipante + "&proceso=" + Apartado.nIdProceso + "&ID=" + Anexo.nIdAnexo + "\">Exportar anexo</a>" : "Sin archivos") + "</td>" +

                                           "</tr>";
                    });
                });

                strHTMLApAx += "</tbody>";
                strHTMLApAx += "</table>";

                $("#div_datos").empty().append(strHTMLApAx);

                $("#tblObligaciones").treetable({ expandable: true });
                $("#tblObligaciones tbody tr").mousedown(function () {
                    $("tr.selected").removeClass("selected");
                    $(this).addClass("selected");
                });
                loading.close();
            }
        }

        function fGetNumeroArchivosXapartado(objApartado) {
            var intNumArchivos = 0;
            $.each(objApartado.laAnexos, function (f, Anexo) {
                intNumArchivos = intNumArchivos + Anexo.nNumArchivos;
            });
            return intNumArchivos;
        }

        function fAbrirProceso() {//FUNCIÓN QUE ABRE EL DIALOG PARA ABRIR EL PROCESO
            var nombreProceso = nombreProc;
            var nombreDependencia = nombreDepcia;

            a_tip = [
                    { tit: 'Abrir Proceso', arc: "SSAABRPRO.aspx?nombreProceso=" + nombreProc + "&nombreDependencia=" + nombreDependencia }
                ];
            $("#dComentAbrirProc").dialog("destroy");
            $("#dComentAbrirProc").remove();
            dTxt = '<div id="dComentAbrirProc" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SSSABRPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SSSMONDEP').append(dTxt);
            $("#dComentAbrirProc").dialog({
                autoOpen: true,
                height: 500,
                width: 700,
                modal: true,
                resizable: false
            });

        }


        function fAbrirProc(justificacion) {//FUNCIÓN QUE SE VA AL SERVIDOR Y ABRE EL PROCESO
            $('#dComentAbrirProc').dialog("close");
            $("#dComentAbrirProc").dialog("destroy");
            $("#dComentAbrirProc").remove();
            loading.ini();
            var nIdUsuario = $("#hf_idUsuario").val();
            var idParticipante = null;
            var idProceso = null;

            if (NG.Nact == 1) {
                var idParticipante = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc].nIdParticipante;
                idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selc].nIdProceso
            } else {
                var idParticipante = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdParticipante;
                idProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdProceso
            }

            var actionData = "{'nIdParticipante': '" + idParticipante +
                               "','nIdUsuario': '" + nIdUsuario +
                                "','sJustificacion': '" + justificacion +
                                "','nidProceso': '" + idProceso +
                                "'}";
            $.ajax(
                {
                    url: "SSSMONDEP.aspx/fAbre_Proceso",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loading.close();
                        var resp = reponse.d;
                        var separar = resp.split(',');
                        var respuesta = separar[0];
                        var idPart = separar[1];

                        switch (respuesta) {
                            case '0': //ERROR
                                jAlert("No se pudo abrir el proceso, inténtelo mas tarde.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                break;
                            case '1': //ACCIÓN REALIZADA SATISFACTORIAMENTE
                                fAjax(idPart);
                                BotonesSSSMONDEP(0);
                                loading.close();
                                jAlert("El proceso fué abierto satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                break;
                            case '100': //SE REQUIERE ACTUALIZAR LA PÁGINA
                                jAlert("La información ha cambiado, porfavor actualice su página.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                            case '101': //NO SE PUEDE ABRIR PORQUE EL PERIODO DEL PROCESO NO ESTA VIGENTE
                                jAlert("No se puede abrir el proceso ya que el periodo no está vigente, se requiere configurar una fecha de apertura extemporanea.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                        }
                    },
                    error: errorAjax
                });
        }

        function fVerGrafica() {//FUNCIÓN QUE ABRE EL DIALOG DE LA GRÁFICA
            var pendientes = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].pendientes; //ANEXOS PENDIENTES
            var excluidos = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].excluidos; //ANEXOS EXCLUIDOS
            var integrados = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].integrados; //ANEXOS INTEGRADOS
            a_tip = [
                    { tit: 'Gráfica', arc: "SSCMONGRA.aspx?excluidos=" + excluidos + "&integrados=" + integrados + "&pendientes=" + pendientes }
                ];
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
            dTxt = '<div id="dComentGrafica" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SSCMONPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SSSMONDEP').append(dTxt);
            $("#dComentGrafica").dialog({
                autoOpen: true,
                height: 550,
                width: 1100,
                modal: true,
                resizable: false
            });
        }

        /*Función asincrona que consulta los datos relacionados con una anexo (Archivos)*/
        function fGetDatosAnexo(nAnexo, sAnexo, nApartado, nParticipante, nProceso, sOpcion) { 
            objAnexo = apartados[nApartado].laAnexos[nAnexo];
            if (objAnexo != null) {
                objAnexo.strAccion = 'ARCHIVOS';
                objAnexo.strOpcion = 'MONITOREO';
                objAnexo.idAnexo = apartados[nApartado].laAnexos[nAnexo].nIdAnexo;
                objAnexo.IdPartAplic = apartados[nApartado].laAnexos[nAnexo].nIdPartAplic;

                actionData = frms.jsonTOstring({ objAnexo: objAnexo });

                $.ajax(
                    {
                        url: "SSSMONDEP.aspx/pGetDatosAnexo",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                apartados2 = eval('(' + reponse.d + ')');
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
            } else {
                console.log("nulo");
            }
        }

        function f_reporte(op) {
            $("#hf_operacion").val(op);
            idProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdProceso
            cveDepcia = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nDepcia
            dTxt = '<div id="dComent" title="SERUV - Reporte">';
            if (op == "EO") {
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + idProceso + '&cveDepcia=' + cveDepcia + '&op=ENLACESOPERATIV' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            }
            else {
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + idProceso + '&cveDepcia=' + cveDepcia + '&op=ENLACESOPERATIV_R' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            }

            dTxt += '</div>';
            $('#SSSMONDEP').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //800,
                width: $("#agp_contenido").width() - 50, //750,
                modal: true,
                resizable: true
            });
        }

        function fConsultarArchivosA(nAnexo, nApartado, nParticipante, nProceso) {
            $("#hf_NG").val(frms.jsonTOstring(apartados2));
            dTxt = '<div id="dComent" title="Consulta de archivos">';
            dTxt += '<iframe id="SMCONSULT" src="SMCONSULT.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#form1').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 650,
                width: 970,
                modal: true,
                resizable: true
            });
        }

        function fConsultarArchivosV(nAnexo, sAnexo, nApartado, nParticipante, nProceso) {
            $("#hf_NG").val(frms.jsonTOstring(apartados2));
            $("#hf_anexo").val(sAnexo);
            dTxt = '<div id="dComent" title="Consulta de archivos">';
            dTxt += '<iframe id="SMCONSULT" src="SMCONSULV.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#form1').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 650,
                width: 970,
                modal: true,
                resizable: true,
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });
        }

        //            function fGetNumeroArchivosXapartado(objApartado) {
        //                var intNumArchivos = 0;
        //                //console.log(objApartado);
        //                $.each(objApartado.lstAnexos, function (f, Anexo) {
        //                    intNumArchivos = intNumArchivos + Anexo.intNumArchivos;
        //                });
        //                return intNumArchivos;
        //            }

        /*Función que regresa el numero de anexos de una ER*/
        function fGetNumeroAnexos(objJson) {
            var nNumAnexos = 0;
            for (i = 0; i < objJson.lstApartados.length; i++) {
                if (objJson.lstApartados[i].chrAplica == 'O') {
                    nNumAnexos = nNumAnexos + objJson.lstApartados[i].lstAnexos.length;
                }
            }
            return nNumAnexos;
        }

        function fTieneArchivosProceso(objProceso) {
            var blnArchivos = false;
            $.each(objProceso, function (k, Apartado) {
                $.each(Apartado.laAnexos, function (f, Anexo) {
                    if (Anexo.nNumArchivos > 0) {
                        blnArchivos = true;
                    }
                });
            });
            return blnArchivos;
        }

        function fTieneArchivosApartado(objApartado) {
            var blnArchivos = false;
            $.each(objApartado.laAnexos, function (f, Anexo) {
                if (Anexo.nNumArchivos > 0) {
                    blnArchivos = true;
                    return blnArchivos;
                }
            });
            return blnArchivos;
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        function fCerrarDialogG() {
            $('#dComentGrafica').dialog("close");
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
        }

        function fCerrarDialog2() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        function fCerrarDialogAbrProc() {
            $('#dComentAbrirProc').dialog("close");
            $("#dComentAbrirProc").dialog("destroy");
            $("#dComentAbrirProc").remove();
        }

        function fBitacora() {
            urls(2, "SMABITACO.aspx");
        } 
    </script>
    <form id="SSSMONDEP" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Supervisión</label>
            <div class="a_acciones">
                <a id="AccExportar" title="Exportar" class="accAct ">Exportar</a>
                <a id="AccExportar2" title="Exportar" class="accIna ">Exportar</a>

                <a id="AccAbrirProc" title="Abrir Proceso" href="javascript:fAbrirProceso();" class="accAct ">Abrir Proceso</a>
                <a id="AccAbrirProc2" title="Abrir Proceso" class="accIna ">Abrir Proceso</a>

                <a id="AccBitacora" title="Bitácora" href="javascript:fBitacora();" class="accAct ">Bitácora</a>
            </div>
        </div>
        <div id="div_contenido">
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>
        <%--<div class="instrucciones">¿Instrucciones?</div>--%>
            <br />
            <h2>Proceso entrega - recepción:</h2>
            <label id="lblProcER"></label>
            <br />
            <h2>Periodo:</h2>
            <label id="lblPeriodo"></label>
            <h2>Periodo extemporaneo:</h2><label id="lblPeriodoExtemp"></label>
            <br />
            <h2>Dependencia / entidad:</h2>
            <label id="lblDepcia"></label>
            <br />
            <h2>Puesto / cargo:</h2>
            <label id="lblPuesto"></label>            
            <br />                             
            
            <h2>Sujeto Obligado:</h2>
            <label id="lblSujObl"></label>

            <h2>Enlaces operativos:</h2>
            <label id="lblEnlaceOperativo"></label>
            <label id="divEnlaceOp"></label>
            <br />

            <h2>Sujeto Receptor:</h2>
            <label id="lblSujRec"></label>

            <h2>Enlaces operativos receptores:</h2>
            <label id="lblEnlaceOperativoReceptor"></label>
            <label id="divEnlaceOpReceptor"></label>

            <br />
            <h2>Perfil:</h2>
            <label id="lblPerfil"></label>
            <label id="div"></label>
         <%--       <div id="div"></div>--%>
            <br />
            
            <h2>Estado de la entrega:</h2>
            <label id="edoEntrega"></label>
            
            <h2>Avance:</h2>
            <label id="lblAvance"></label>

            <h2>Ver gráfica:</h2>               
                <a href="javascript:fVerGrafica();"> <img alt="Ver gráfica" src="../images/icono-grafica.png"  style="cursor:pointer"/></a>
            <br />

            <h2>Guía:</h2>
            <label id="lblGuia"></label>

            <div id="div_datos">
            </div>

            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div> 
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_NG" runat="server" />
            <asp:HiddenField ID="hf_anexo" runat="server" />
            <asp:HiddenField ID="hf_proceso" runat="server" />
            <asp:HiddenField ID="hf_operacion" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>
