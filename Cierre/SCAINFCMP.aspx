<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAINFCMP" Codebehind="SCAINFCMP.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../scripts/jquery.easyui.min.js" type="text/javascript"></script>
   <script src="../scripts/jquery.treetable.js" type="text/javascript"></script>
</head>
<body>
     <script type="text/javascript">
         /*Objeto para determinar el filtro de los anexos*/
         var filtro = "{\"filtro\": [ {\"ID\": \"\", \"valor\": \"\", \"etiqueta\": \"\" } ] }";
         var objFiltro;
         var strDato = " {\"ID\": \"\", \"valor\": \"\", \"etiqueta\": \"\" }";
         var selFiltro;

         /*Variables globales para seleccionar procesos, participantes, apartados y anexos del objeto NG*/
         var intProceso;
         var intParticipante;
         var intApartado;
         var intAnexo;

         /*Objeto de tipo funnción que controla el comportamiento de los botones de la forma*/
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

         /*Se lanza al inicio de la carga del lado del cliente*/
         $(document).ready(function () {
             NG.setNact(3, 'Tres', botonesER); // Se establece el nivel actual (3), porque es el 3er nivel de navegación 
             objFiltro = eval('(' + filtro + ')'); // Se inicializa el objeto Json del filtro
             fGetInformacion(null); // Se consulta la información asociada a contraloría
         });


         /*Función que se emplea para buscar un valor dentro de una objeto lista tipo JSON*/
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

         /*Función empleada para limpiar el objeto filtro*/
         function fLimpiaFiltro() {
             $.each(objFiltro.filtro, function (k, elem) {
                 objFiltro.filtro.splice(k, 1);
             });
         }
         
         /*Función para ordenar un objeto json*/
         function SortByID(x, y) {
             return x.ID - y.ID;
         }

         /*Pinta el filtro del estado de los anexos*/
         function fPintaFiltroAnexos(objProceso, nParticipante, strOpcion, strSeleccionado) {
             /*Se buscan las opciones que puede tener de filtro un participante*/ // strOpcion
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
             strOpciones = "</select>"; //strSeleccionado
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

         /*Función asincrona que consulta los datos relacionados con un anexo (Archivos)*/
         function fGetDatosAnexo(objAnexo, nAnexo, nApartado, nParticipante, nProceso, sOpcion) {
             if (objAnexo != null) {
                 actionData = JSON.stringify({ objAnexo: objAnexo });
                 $.ajax(
                    {
                        url: "../Registro/SCACARINF.aspx/pGetDatosAnexo",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo] = eval('(' + reponse.d + ')');
                                if (sOpcion == 'INICIO') {
                                    fPintaOpciones(NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo],
                                                    NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante],
                                                   nAnexo, nApartado, nParticipante, nProceso);
                                }
                                else {
                                    $('#SCCONSULT')[0].contentWindow.fRepintaGrid(NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]);
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


         /*función que se utiliza cuando se cierra el dialog*/
         function fCerrarDialog2(strOpcion, strAccion) {

             NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].strOpcion = 'CARGA';
             NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].strAccion = 'ARCHIVOS'; //
             fGetDatosAnexo(NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo]
                                , intAnexo, intApartado, intParticipante, intProceso, "Consulta");

             $('#dComentDos').dialog("close");
             $("#dComentDos").dialog("destroy");
             $("#dComentDos").remove();
         }

         /*Función que abre el Dialog para cargar una archivo*/
         function fCargarArchivo(objJSON) {
             $("#hf_NG").val(JSON.stringify(objJSON));
             dTxt = '<div id="dComentDos" title="Carga de archivos">';
             dTxt += '<iframe id="SCKCARGAR" src="../Registro/SCKCARGAR.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
             dTxt += '</div>';
             $('#SCAINFCMP').append(dTxt);
             $("#dComentDos").dialog({    
                 autoOpen: true,
                 height: 650,
                 width: 970,
                 modal: true,
                 resizable: true
             });
         }

         /*Función que abre el Dialog donde se descargan los Formatos/Guías*/
         function fFormatoGuia(nAnexo, nApartado, nParticipante, nProceso) {
             $("#hf_NG").val(JSON.stringify(NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]));
             dTxt = '<div id="dComentFG" title="Descarga de archivo e instructivo">';
             dTxt += '<iframe id="SAAGUIAER" src="../Registro/SCDARVSFG.aspx' + '" frameBorder="0" style="width:90%;border-style:none;border-width:0px;height:90%;"></iframe>';
             dTxt += '</div>';
             $('#SCAINFCMP').append(dTxt);
             $("#dComentFG").dialog({
                 autoOpen: true,
                 height: (NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo].chrFuente == 'U' ? 200 : 350),
                 width: 970,
                 modal: true,
                 resizable: false
             });
         }

         /*Función que obtiene el anexo y su listado de archivos, que seran desplegados en una ventana modal, para continuar cargando archivos o consultarlos*/
         function fConsultarArchivos(nAnexo, nApartado, nParticipante, nProceso) {
             intProceso = nProceso;
             intParticipante = nParticipante;
             intApartado = nApartado;
             intAnexo = nAnexo;
             $("#hf_NG").val(JSON.stringify(NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo]));
             dTxt = '<div id="dComent" title="Consulta de archivos">';
             dTxt += '<iframe id="SCCONSULT" src="../Registro/SCCONSULT.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
             dTxt += '</div>';
             $('#SCAINFCMP').append(dTxt);
             $("#dComent").dialog({
                 autoOpen: true,
                 height: 600,
                 width: 1000,
                 modal: true,
                 resizable: true
             });
             $(".panel-tool-close").remove();
         }

         /*Función que cierra el Dialog de formato/guía*/
         function fCerrarDialogFG() { //dComentFG
             $('#dComentFG').dialog("close");
             $("#dComentFG").dialog("destroy");
             $("#dComentFG").remove();
         }

         /*Función que pinta la columna de opciones (donde se descarga el formato/guía o se cargan los archivos de una ER)*/
         function fPintaOpciones(objAnexo, objParticipante, nAnexo, nApartado, nParticipante, nProceso) {
             var strHtmlOpciones = "";
             //alert("sigo aqui");
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
             var objAnexo = NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos[nAnexo];
             if (objAnexo.charIndEntrega != 'E') {
                 objAnexo.strAccion = "ARCHIVOS";
                 objAnexo.strOpcion = "CARGA";
                 fGetDatosAnexo(objAnexo, nAnexo, nApartado, nParticipante, nProceso, "INICIO");
             }
             else { 
                 $("#div_Opciones").empty().append("Justificación: " + objAnexo.strJustificacion);
             }
         }

         /*Función que pinta los anexos de una ER dependiendo el estado seleccionado en el filtro de estado del anexo*/
         function fPintaAnexos(nApartado, nParticipante, nProceso, nAnexo, sOpFilttro) {
             strAnexos = "";
             $('#div_Opciones').empty();
             intApartado = nApartado;
             if (NG.Var[NG.Nact].datoSel.lstProcesos[nProceso].lstParticipantes[nParticipante].lstApartados[nApartado] != null) {
                 objParticipante = NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[nParticipante];
                 strAnexos += "<ul id=\"ul_apartados\">";
                 $.each(NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados[nApartado].lstAnexos, function (f, Anexo) {
                     if (Anexo.charIndEntrega == sOpFilttro) {
                         strAnexos += "<li " + (nAnexo == f ? "class=\"active\"" : "") + ">";
                         strAnexos += "<a " + (Anexo.cIndActa == 'S' ? " style=\"color:red\""  : "" )  + "href=\"Javascript:fGetOpciones(" + f + ", " + nApartado + ", " + nParticipante + "," + nProceso + ");\">" + Anexo.strCveAnexo + " " + Anexo.strDAnexo + "</a></li>";
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
             
             if (objJson.lstProcesos[intProceso].lstParticipantes[nParticipante] != null) {
                 if (objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados != null &&
                objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados.length > 0) {
                     strApartados += "<ul>";
                     $.each(objJson.lstProcesos[intProceso].lstParticipantes[nParticipante].lstApartados, function (f, Apartado) {
                        if (sOpFiltro == 'P') {
                            strApartados += "<li " + (nApartadoSeleccionado == f ? "class=\"active\"" : "") + " >";
                            if (containsJsonObj(Apartado.lstAnexos, "charIndEntrega", sOpFiltro)) {
                                strApartados += "<a href=\"Javascript:fPintaAnexos(" + f + ", " + nParticipante + "," + intProceso + "," + (-1) + ",'" + sOpFiltro + "');\">" + Apartado.strApartado +
                                    " " + Apartado.strDescApartado + "</a></li>";
                            }
                            else {
                                strApartados += "<li><a href=\"Javascript:fPintaAnexos(" + f + ", " + nParticipante + "," + intProceso + "," + (-1) + ",'" + sOpFiltro + "');\">" + Apartado.strApartado +
                                            " " + Apartado.strDescApartado + "</a></li>";
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
                 $('#lbl_supervisor').empty().append(objJson.strNomUsuario);
                 $('#lbl_EEntrega').empty().append(objJson.lstProcesos[0].lstParticipantes[$("#slc_depcias option:selected").val()].strEstatusP);
                 intParticipante = $("#slc_depcias option:selected").val(); //<div id="div_ext"><h2>Fecha de apertura extemporanea:</h2>&nbsp;&nbsp;<label id="lbl_strCorteEx"></label></div>

                 if (objJson.lstProcesos[0].lstParticipantes[intParticipante].strEstatusP == 'EXTEMPORANEO') { //(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                     $("#div_ext").show();
                     $("#lbl_strCorteEx").empty().append(objJson.lstProcesos[0].lstParticipantes[intParticipante].dteFInicio + " al " + objJson.lstProcesos[0].lstParticipantes[intParticipante].dteFFin);
                 }
                 else {
                     $("#div_ext").hide();
                 }
                 
                 fPintaApartados(objJson, -1, $("#slc_depcias option:selected").val(), 'P');
                 
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

                     fPintaApartados(NG.Var[NG.Nact].datoSel, -1, intParticipante, 'P');

                     NG.Var[NG.Nact].botones(NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante],
                                                        null,
                                                        "ENVIO");

                     $("#lbl_strTitular").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioT); // Para mostrar el titular
                     $("#lbl_strSObligado").empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strNomUsuarioO);
                     $('#lbl_Perfil').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strPerfilUsuario);
                     $('#lbl_supervisor').empty().append(NG.Var[NG.Nact - 1].datoSel.strNomUsuario);
                     $('#lbl_EEntrega').empty().append(NG.Var[NG.Nact - 1].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].strEstatusP);

                 });

             }
             loading.close();
         }

         /*Función que pinta el detalle del proceso y determina si el usuario esta participando en 1 o más procesos*/
         function fPintaDatosProcesosER(objJson) {
             strHTMLProcesos = "";
             if (objJson != null) {
                 if (objJson.lstProcesos.length == 1) { // El usuario está presente en un sólo procesos ER
                     intProceso = 0;
                     $("#div_procesos").html("<label>" + objJson.lstProcesos[0].strProceso + ' ' + objJson.lstProcesos[0].strDProceso + "</label>");
                     $("#lbl_strCorte").html(objJson.lstProcesos[0].dteFInicio + " al " + objJson.lstProcesos[0].dteFFin);
                     $("#lbl_guia").empty().append(objJson.lstProcesos[0].sDGuiaER);
                     fPintaCombosN2(objJson);
                 }
                 else {
                     $("#div_contenido").css("display", "none");
                     $('#div_mensaje').css("display", "block");
                     loading.close();
                 }

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
                 loading.close();
                 $("#div_contenido").css("display", "none");
                 $('#div_mensaje').css("display", "block");
                 
                 $("#AccEnviarEntrega").hide();
                 $("#AccEnviarEntrega2").hide();

                 $("#AccNotificaciones").hide();
                 $("#AccNotificaciones2").hide();

                 $("#AccReporte").hide();
                 $("#AccReporte2").hide();
             }

         }

         /*Función que actualiza la lista de archivos despues de cargar o eliminar un archivo*/
         function fActualizaAnexo(objJSON) {
             for (a_i = 0; a_i < NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos.length; a_i++) {
                 if (objJSON.gidFormato == NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos[a_i].gidFormato) {
                    NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].lstArchivos.splice(a_i, 1);
                     break;
                 }
             }
             NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos--;
             if (NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos < 0)
                 NG.Var[NG.Nact].datoSel.lstProcesos[intProceso].lstParticipantes[intParticipante].lstApartados[intApartado].lstAnexos[intAnexo].intNumArchivos = 0;
         }

         /*Regresa la página al nivel anterior*/
         function fCancelar() {
             urls(1, "SCSCIEDEP.aspx");
             NG.setNact(1, 'Uno', null);
         }


         /*Función inicial (se ejecuta en el DocumentReady) que consulta el/los proceso(s) donde esta participando un usuario*/ 
         function fGetInformacion(objProceso) {
             var strDatos = "";
             if (objProceso == null) {
                 var strDatos = "{\"idUsuario\": " + $('#hf_idUsuario').val() +
                                ",\"intTieneProceso\": " + 0 +
                                ",\"idProceso\": " + NG.Var[1].datoSel.nIdProceso + //nIdProceso
                                ",\"nIdParticipante\": " + NG.Var[1].datoSel.nIdParticipante + //nIdParticipante
                                ",\"strAccion\": " + "\"PROCESOS\"" +
                                ",\"strOpcion\": " + "\"CCARGA\"" +
                            "}";
                 objProceso = eval('(' + strDatos + ')');
             }
             actionData = JSON.stringify({ objProceso: objProceso });
             $.ajax(
                {
                    url: "SCAINFCMP.aspx/pGetDatosERC",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                NG.Var[NG.Nact].datoSel = eval('(' + reponse.d + ')');
                                if (NG.Var[NG.Nact].datoSel != null) {
                                    fPintaDatos(NG.Var[NG.Nact].datoSel);
                                }
                            }
                    },
                    error: errorAjax
                }
            );
         }
     </script>

    <form id="SCAINFCMP" runat="server">
        <div id="agp_contenido">

            <div id="agp_navegacion"> 
                <label class="titulo">Información Complementaria</label>
            </div>
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>
            <div id="div_mensaje">No tiene procesos asociados.</div>
            <div id="div_contenido">
                <!-- Desplegado contenidos -->
                <h2>Proceso entrega - recepci&oacute;n:</h2>&nbsp;&nbsp;<div id="div_procesos"></div>
                <br />
                <h2>Periodo:</h2>&nbsp;&nbsp;<label id="lbl_strCorte"></label>
                <br />

                <h2>Dependencia/entidad:</h2>&nbsp;&nbsp;<div id="div_depcias"></div>
                <h2>Puesto/cargo:</h2>&nbsp;&nbsp;<div id="div_puestos"></div><br />
                <h2>Titular:</h2>&nbsp;&nbsp;<label id="lbl_strTitular"></label>
                <h2>Sujeto obligado:</h2>&nbsp;&nbsp;<label id="lbl_strSObligado"></label><br />
                <h2>Supervisor:</h2>&nbsp;&nbsp;<label id="lbl_supervisor"></label>&nbsp;&nbsp;
                <h2>Perfil:</h2>&nbsp;&nbsp;<label id="lbl_Perfil"></label>
                <br />
                <h2>Estado de la entrega:</h2>&nbsp;&nbsp;<label id="lbl_EEntrega"></label>
                <div id="div_ext"><h2>Fecha de apertura extemporánea:</h2>&nbsp;&nbsp;<label id="lbl_strCorteEx"></label></div>
                <%--<h2>Avance:</h2>&nbsp;&nbsp;<label id="lbl_avance"></label>--%>
                <br />
                <h2>Guía:</h2>&nbsp;&nbsp;<label id="lbl_guia"></label>
                <br />
                <%--<h2>Estado de los anexos:</h2>&nbsp;&nbsp;<div id="div_EAnexos"></div>
                <br />--%>

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
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="Img1" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>
        <!-- fin Desplegado contenidos -->
    </div>
    </form>
</body>
</html>
