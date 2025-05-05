<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCSCIEDEP" Codebehind="SCSCIEDEP.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var datosGenerales = null;
        var apartados = null;
        var apartados2 = null;
        var nombreDepcia = null;
        var nombreProc = null;
        var idParticipante = null;
        var nombreDependencia = null;
        var idProceso = null;
        var nFKDepcia = null;
        var nFKDepciaProc = null;


        function BotonesSSSMONDEP(selec) {
            if (selec > 0) {//Seleccionado
                $("#AccNotificaciones, #AccExportar2, #AccVisor2, #AccGenerarActa2, #AccInformacionCom2, #AccCerrarProc2").show();
                $("#AccNotificaciones2, #AccExportar, #AccVisor, #AccGenerarActa, #AccInformacionCom, #AccCerrarProc").hide();
            }
            else {// No Seleccionado
                $("#AccNotificaciones2, #AccExportar, #AccVisor, #AccGenerarActa, #AccInformacionCom, #AccCerrarProc").show();
                $("#AccNotificaciones, #AccExportar2, #AccVisor2, #AccGenerarActa2, #AccInformacionCom2, #AccCerrarProc2").hide();
            }
        }


        function fAjax(idParticipante) {//función que se va al servidor y regresa los datos de la dependencia
            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'idParticipante': '" + idParticipante +
                             "','idUsuario': '" + nIdUsuario +
                         "'}"; ;
            $.ajax({
                url: "SCSCIEDEP.aspx/pPinta_Grid",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Datos(eval('(' + reponse.d + ')'));
                },
                beforeSend: loading.ini(),
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

            NG.Var[NG.Nact - 1].datoSel.nIdParticipante = idParticipante;
            NG.Var[NG.Nact].botones(0);
            fAjax(idParticipante);
        });

        function fCancelar() {//función que me regresa a la página de avance del proceso
            loading.ini();
            urls(1, "SCSCIEPRO.aspx");
        }

        function Pinta_Datos(datos) {//función que pinta los datos generales de la dependencia, y sus apartados con los anexos
            datosGenerales = datos.datos[1];//esta variable contiene los datos generales de la dependencia
            apartados = datos.datos[0];//esta variable contiene los apartados junto con los anexos de la dependencia
            enlacesOperativos = datos.datos[2];//contiene los enlaces operativos de la dependencia
            enlacesOperativosReceptores = datos.datos[3];//contiene los enlaces operativos receptores de la de la dependencia

            $("#AccExportar").attr("href", "../General/SGDCARZIP.aspx?strOpcion=proceso&participante=" + datosGenerales[0].nIdParticipante + "&proceso=" + datosGenerales[0].nIdProceso + "&ID=" + datosGenerales[0].nIdProceso);

            idParticipante = datosGenerales[0].nIdParticipante;
            var usuarioObligado = datosGenerales[0].usuarioObligado;
            var periodo = datosGenerales[0].dFInicio + '  al  ' + datosGenerales[0].dFFinal;
            nombreProc = periodo;
            var edoEntrega = datosGenerales[0].cEstatus;
            var depcia = datosGenerales[0].sDDepcia;
            nombreDepcia = depcia;
            nombreDependencia = depcia;
            var nombreProce = datosGenerales[0].sDProceso
            $('#hf_proceso').val(nombreProce);
            var perfil = datosGenerales[0].sDPuesto
            var avanceGeneral = datosGenerales[0].avanceGeneral;
            var indEntrega = datosGenerales[0].cIndEntrega;
            var estatusProc = datosGenerales[0].cEstatusProc;
            var perfilUsuarioEntra = null;
            var cIndActivo = datosGenerales[0].cIndActivo;
            var cIndCerrado = datosGenerales[0].cIndCerrado;
            var guia = datosGenerales[0].sGuiaER;
            idProceso = datosGenerales[0].nIdProceso;
            var anexIntegrados = datosGenerales[0].anexIntegrados;
            var anexTotales = datosGenerales[0].anexTotales;
            var usuarioReceptor = datosGenerales[0].usuarioReceptor;

            if (datosGenerales[0].dextemInicio != null) {//pregunto si la dependencia tiene fecha extemporanea, si es asi la muestro si no pongo que no esta definida
                var periodoExtemporaneo = datosGenerales[0].dextemInicio + ' al ' + datosGenerales[0].dextemFinal;
            } else {
                var periodoExtemporaneo = 'NO DEFINIDO';
            }

            nFKDepcia = datosGenerales[0].nFKDepcia;
            nFKDepciaProc = datosGenerales[0].nFKDepciaProc;

            //perfiles del usuario logueado-----------------------------------
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
                a_di = new o_dialog('Ver Perfiles');
                a_di.iniDial();
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
                htmlTab += '<td style="font-size: .8em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:50%;">NOMBRE</td>';
                htmlTab += '<td style="font-size: .8em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:49%;">CORREO ELECTRÓNICO</td>';
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

                $("#divEnlaceOp").append(htmlTab);
                a_di1 = new o_dialog('Enlaces');
                a_di1.iniDial();
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

                htmlTab += '<div><a class="ackDialog" href="#fixme">VER ENLACES OPERATIVOS RECEPTORES..</a></div>';
                htmlTab += '<div class="dialoG oculto">';
                htmlTab += '<div class="a_acciones_sin"><a href="javascript: f_reporte(\'EOR\');" class="accAct">Reporte</a></div> <br/><br/>';
                htmlTab += '<table style="width:99%; border-style:solid; border-width:0;"><tr>'
                htmlTab += '<td style="font-size: .8em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:50%;">NOMBRE</td>';
                htmlTab += '<td style="font-size: .8em; text-align:center; color:#039; background-color: #f5f5f5; border: 1px solid #888; padding: .3em 1em .1em 1em; font-weight: bold; width:49%;">CORREO ELECTRÓNICO</td>';
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

                $("#divEnlaceOpReceptor").append(htmlTab);
                a_di2 = new o_dialog('Enlaces');
                a_di2.iniDial();
            }
            //--------------------------------------------
            nombreProc = nombreProce;

            if (cIndCerrado == 'S') {//indicador de cerrado
                $("#AccCerrarProc").hide();
                $("#AccCerrarProc2").show();
            } else {
                $("#AccCerrarProc2").hide();
                $("#AccCerrarProc").show();
            }

            $("#lblDepcia").text(depcia);
            $("#lblProcER").text(nombreProc);
            $("#lblSujObl").text(usuarioObligado);

            if (usuarioReceptor == "-  ") {//sujeto receptor
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

            $("#lblGuia").text(guia);//nombre de la guia

            $("#AccExportar").hide();
            $("#AccExportar2").show();

            $("#AccInformacionCom").hide();
            $("#AccInformacionCom2").show();

            //activo o desactivo el boton de exportar
            $.each(apartados, function (k, Apartado) {
                $.each(Apartado.laAnexos, function (f, Anexo) {
                    if (Anexo.nNumArchivos > 0) {
                        $("#AccExportar").show();
                        $("#AccExportar2").hide();

                    }
                });
            });

            //activo o desactivo el boton de informacion complementaria (se activa si la guia contiene un apartado de contraloria)
            $.each(apartados, function (k, Apartado) {
                if (Apartado.chrAplica == 'C') {
                    $("#AccInformacionCom").show();
                    $("#AccInformacionCom2").hide();
                }
            });
            fPintaApartadosAnexos(apartados);//mando a llamar la función que pinta el control que contiene los apartados y sus respectivos anexos
        }



        function fPintaApartadosAnexos(objJson) { //  función que pinta el control de los apartados y sus respectivos anexos
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
                strHTMLApAx += "<th>Archivos Cargados</th>";
                strHTMLApAx += "<th>Visualizar</th>";
                strHTMLApAx += "<th>Exportar</th>";
                strHTMLApAx += "</tr>";
                strHTMLApAx += "</thead>";
                strHTMLApAx += "<tbody>";
                // AQUI SE RECOREN LOS APARTADOS Y ANEXOS

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
                        //"<td>" + (Anexo.cIndEntrega == 'P' ? "PENDIENTE" : (Anexo.cIndEntrega == 'I' ? "INTEGRADO" : "EXCLUIDO")) + "</td>" +
                                                "<td class=\"Acen\">" + (Apartado.chrAplica == 'O' ? (Anexo.cIndEntrega == 'P' ? "PENDIENTE" : (Anexo.cIndEntrega == 'I' ? "INTEGRADO" : "EXCLUIDO")) : "") + "</td>" +
                                                "<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.sAnexo + ' ' + Anexo.sDAnexo + "'," + k + "," + Apartado.nIdParticipante + "," + Apartado.nIdProceso + ",'ARCHIVO'" + ");\">" + Anexo.nNumArchivos + "</a>" : Anexo.nNumArchivos) + "</td>" +
                                                "<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"Javascript:fGetDatosAnexo(" + f + ",'" + Anexo.sAnexo + ' ' + Anexo.sDAnexo + "'," + k + "," + Apartado.nIdParticipante + "," + Apartado.nIdProceso + ",'VISUALIZAR'" + ");\">" + Anexo.nNumArchivos + "</a>" : Anexo.nNumArchivos) + "</td>" +
                                                "<td class=\"Acen\">" + (Anexo.nNumArchivos > 0 ? "<a href=\"../General/SGDCARZIP.aspx?strOpcion=anexo&participante=" + Apartado.nIdParticipante + "&proceso=" + Apartado.nIdProceso + "&ID=" + Anexo.nIdAnexo + "\">Exportar anexo</a>" : "Sin archivos") + "</td>" +
                        //"<td class=\"Acen\">" + "</td>" +
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

        /*Función que regresa el numero de anexos de una ER*/
        function fGetNumeroArchivosXapartado(objApartado) {
            var intNumArchivos = 0;
            $.each(objApartado.laAnexos, function (f, Anexo) {
                intNumArchivos = intNumArchivos + Anexo.nNumArchivos;
            });
            return intNumArchivos;
        }

        function fVerGrafica() {//función que abre el dialog de las gráficas
            var pendientes = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].pendientes;//número  de anexos pendientes
            var excluidos = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].excluidos;//número de anexos excluidos
            var integrados = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].integrados;//número de anexos integrados
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
                width: 970,
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

                $.ajax({
                    url: "../Monitoreo/SSSMONDEP.aspx/pGetDatosAnexo",
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
                }
                );
            } 
        }

        function fConsultarArchivosV(nAnexo, sAnexo, nApartado, nParticipante, nProceso) {
            $("#hf_NG").val(frms.jsonTOstring(apartados2));
            $("#hf_anexo").val(sAnexo);
            dTxt = '<div id="dComentV" title="Consulta de archivos">';
            dTxt += '<iframe id="SCCONSULV" src="../Monitoreo/SMCONSULV.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#form1').append(dTxt);
            $("#dComentV").dialog({
                autoOpen: true,
                height: 650,
                width: 970,
                modal: true,
                resizable: true,
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });
            $(".panel-tool-close").remove();
        }

        function fVerGrafica() {//función que abre el dialog con las gráficas
            var pendientes = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].pendientes;//anexos pendientes
            var excluidos = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].excluidos;//anexos excluidos
            var integrados = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].integrados;//anexos integrados
            a_tip = [
                    { tit: 'Gráfica', arc: "../Monitoreo/SSCMONGRA.aspx?excluidos=" + excluidos + "&integrados=" + integrados + "&pendientes=" + pendientes }
                ];
            $("#dComentGrafica").dialog("destroy");
            $("#dComentGrafica").remove();
            dTxt = '<div id="dComentGrafica" title="' + a_tip[0].tit + '">';
            dTxt += '<iframe id="SCSCIEPRO" src="' + a_tip[0].arc + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#SCSCIEDEP').append(dTxt);
            $("#dComentGrafica").dialog({
                autoOpen: true,
                height: 550,
                width: 970,
                modal: true,
                resizable: false
            });
        }

        function fConsultarArchivosA(nAnexo, nApartado, nParticipante, nProceso) {
            $("#hf_NG").val(frms.jsonTOstring(apartados2));
            dTxt = '<div id="dComent" title="Consulta de archivos">';
            dTxt += '<iframe id="SMCONSULT" src="../Monitoreo/SMCONSULT.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#form1').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 650,
                width: 970,
                modal: true,
                resizable: true
            });
            $(".panel-tool-close").remove();
        }

        /*función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }
        function fCerrarDialog2() {
            $('#dComentV').dialog("close");
            $("#dComentV").dialog("destroy");
            $("#dComentV").remove();
        }

        function fCierreProceso() {//esta función valida con el usuario si realmente desea cerrar el proceso
            if (nFKDepcia == nFKDepciaProc) {//se le dice al usuario que cerrara el proceso de la dependencia principal
                $.alerts.dialogClass = "infoConfirm";
                jConfirm("¿Está seguro que desea cerrar el proceso de la dependencia: " + nombreDependencia + "?, tenga en cuenta que al cerrar esta dependencia el proceso ya no podra ser administrado.", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                    if (r) {
                        fCierreProceso2()
                    }
                });
            } else {
                $.alerts.dialogClass = "infoConfirm";
                jConfirm("¿Está seguro que desea cerrar el proceso de la dependencia: " + nombreDependencia + "?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                    if (r) {
                        fCierreProceso2()
                    }
                });
            }
        }

        function fCierreProceso2() {//función que cierra el proceso de la dependencia
            loading.ini();
            var idProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdProceso;
            var actionData = "{'idProceso': '" + idProceso +
                                   "','idParticipante': '" + idParticipante +
                                   "','strOpcion': '" + 'CDEPCIA' +
                         "'}";
            $.ajax({
                url: "SCSCIEDEP.aspx/fCerrarProceso",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = reponse.d;

                    switch (resp) {
                        case 0:// si es que hubo un error
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("No se pudo cerrar el proceso seleccionado.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            break;
                        case 1://acción realizada satisfactoriamente
                            loading.close();
                            $("#AccCerrarProc").hide();
                            $("#AccCerrarProc2").show();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("El proceso fué cerrado satisfactoriamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            break;
                        case 100://alguien mas ya cerro el proceso se necesita actualizar la página
                            loading.close();
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("La información ha cambiado, porfavor actualice su página", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;

                        case 101://no se puede cerrar el proceso porque falta cargar el anexo correspondiente al acta
                            loading.close();
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("No se puede cerrar el proceso ya que falta de integrar el anexo correspondiente al acta.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            break;
                        case 102://no se puede cerrar porque no se ha enviado la entrega de la dependencia
                            loading.close();
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("No se puede cerrar el proceso ya que no se ha enviado la entrega de la dependencia.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            break;

                        case 103://no se ha enviado la entrega de la dependencia y el periodo del proceso aun no termina
                            loading.close();
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("No se puede cerrar el proceso ya que no se ha enviado la entrega de la dependencia o el periodo del proceso aun no termina.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            break;
                    }
                },
                error: errorAjax
            });
        }


        function fActa() {//manda a la forma del formulario del acta
            urls(1, "SCAGEACTA.aspx");
        }

        function fInfComp() {//manda a la forma de información complementaria
            urls(1, "SCAINFCMP.aspx");
        }

        function Enviarcorreo() {
            urls(1, "../Cierre/SCCENVIO.aspx");
        }

        function f_reporte(sEnlace) {
            var nProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdProceso;
            var nDepcia = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nDepcia;
            if (sEnlace == "EO") {
                dTxt = '<div id="dComentEO" title="SERUV - Reporte">';
                //dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso + '&op=PROCESO' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + nProceso +'&cveDepcia=' + nDepcia +'&op=ENLACESOPERATIV' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
                dTxt += '</div>';
                $('#SCSCIEDEP').append(dTxt);
                $("#dComentEO").dialog({
                    autoOpen: true,
                    height: $(window).height() - 60, //700,
                    width: $("#agp_contenido").width() - 50, //1000,
                    modal: true,
                    resizable: true
                });
            } else {
                if (sEnlace == "EOR") {
                    dTxt = '<div id="dComentEOR" title="SERUV - Reporte">';
                    //dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso + '&op=PROCESO' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                    dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + nProceso + '&cveDepcia=' + nDepcia + '&op=ENLACESOPERATIV_R' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
                    dTxt += '</div>';
                    $('#SCSCIEDEP').append(dTxt);
                    $("#dComentEOR").dialog({
                        autoOpen: true,
                        height: $(window).height() - 60, //700,
                        width: $("#agp_contenido").width() - 50, //1000,
                        modal: true,
                        resizable: true
                    });
                }
            }
        }

        // Función que muestra el dialog con el listado de reportes disponibles
        function fReportes() {
            //dTxt = "<div id='dComentR' title='SERUV - Reportes' style='font-size: 1.4em'>";
            dTxt = "<div id='dComentR' title='SERUV - Reportes'>";
            dTxt += "<div class='instrucciones' style='font-size: 11px'>Seleccione un reporte.</div>";
            dTxt += "<br/>";
            dTxt += "<a id='AccExcluidos' href='javascript:fAnexExcluidos()'>1.- Anexos excluidos</a>";
            dTxt += "<br/>";
            dTxt += "<a id='AccIncluidos' href='javascript:fAnexIncluidos()'>2.- Anexos incluidos</a>";
            dTxt += "</div>";
            $('#SCSCIEDEP').append(dTxt);
            $("#dComentR").dialog({
                autoOpen: true,
                height: 160,
                width: 250,
                modal: true,
                resizable: false
            });
            //$(".panel-tool-close").remove();
        }

        // Función para mostrar el reporte de anexos excluidos
        function fAnexExcluidos() {
            dTxt = '<div id="dComent" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idParticipante=' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdParticipante + '&op=ANEXOSEXCL' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SCSCIEDEP').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //700,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true
            });
        }

        // Función para mostrar el reporte de anexos incluidos
        function fAnexIncluidos() {
            dTxt = '<div id="dComent" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idParticipante=' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selc].nIdParticipante + '&op=ANEXOSINCLU' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SCSCIEDEP').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //700,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true
            });
        }


    </script>


    <form id="SCSCIEDEP" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Cierre/Seguimiento</label>
                <div class="a_acciones">
                   <%-- <a id="AccNotificaciones" title="Notificaciones" href="javascript:fExcluir();" class="accAct ">Notificaciones</a>
                    <a id="AccNotificaciones2" title="Notificaciones" class="accIna">Notificaciones</a>--%>
                
                    <a id="AccExportar" title="Exportar" class="accAct" href="javascript:fExportar();">Exportar</a>
                    <a id="AccExportar2" title="Exportar" class="accIna">Exportar</a>
                                        
                   <%-- <a id="A1" title="Exportar"  class="accAct ">Exportar</a>--%>
                   <%-- <a id="AccExportar2" title="Exportar" class="accIna ">Exportar</a>

                  <a id="AccGenerarActa" title="Generar Acta" href="javascript:fActa();" class="accAct">Generar Acta</a>
                    <a id="AccGenerarActa2" title="Generar Acta" class="accIna">Generar Acta</a>--%>

                    <a id="AccInformacionCom" title="Información Complementaria" href="javascript:fInfComp();" class="accAct">Información Complementaria</a>
                    <a id="AccInformacionCom2" title="Información Complementaria" class="accIna">Información Complementaria</a>

                    <a id="AccCerrarProc" title="Cerrar Proceso" href="javascript:fCierreProceso();" class="accAct">Cerrar Proceso</a>
                    <a id="AccCerrarProc2" title="Cerrar Proceso" class="accIna">Cerrar Proceso</a>

                    <a id="AccEnviarNvo" title="Enviar correo" href="javascript:Enviarcorreo();" class="accAct">Redactar correo</a>

                    <a id="AccReportes" title="Reportes" href="javascript:fReportes();" class="accAct">Reportes</a>
                </div>
            </div>

                    <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>
          <%--  <div class="instrucciones">¿Instrucciones?</div>--%>
            <div id="div_contenido">    
                <h2>Proceso entrega - recepción:</h2><label id="lblProcER"></label>
                <br />
                <h2>Periodo:</h2><label id="lblPeriodo"></label>
                <h2>Periodo extemporáneo:</h2><label id="lblPeriodoExtemp"></label>
                <br />
                <h2>Dependencia / entidad:</h2><label id="lblDepcia"></label>
                <br />
                <h2>Puesto / cargo:</h2><label id="lblPuesto"></label>
                <br />
                <h2>Sujeto obligado:</h2><label id="lblSujObl"></label>
                   <h2>Enlaces operativos:</h2>
                    <label id="lblEnlaceOperativo"></label>
                    <label id="divEnlaceOp"></label>
                <br />

                        <h2>Sujeto receptor:</h2>
                        <label id="lblSujRec"></label>

                        <h2>Enlaces operativos receptores:</h2>
                        <label id="lblEnlaceOperativoReceptor"></label>
                        <label id="divEnlaceOpReceptor"></label>

                        <br />


                <h2>Perfil:</h2><label id="lblPerfil"></label>
                <label id="div"></label>
             <%--       <div id="div"></div>--%>
                <br />
                <h2>Estado de la entrega:</h2><label id="edoEntrega"></label>
                <h2>Avance:</h2><label id="lblAvance"></label>
   
                   <h2>Ver gráfica:</h2>               
                <a href="javascript:fVerGrafica();"> <img alt="Ver gráfica" src="../images/icono-grafica.png"  style="cursor:pointer"/></a>
                  <br />


                <h2>Guía:</h2>
                <label id="lblGuia"></label>

            </div>
            <br />

            <div id="div_datos">
            </div>

                    <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 
            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
                <asp:HiddenField ID="hf_NG" runat="server" />
                <asp:HiddenField ID="hf_anexo" runat="server" />
                <asp:HiddenField ID="hf_proceso" runat="server" />
            </div>
        </div>        
    </form>
</body>
</html>
