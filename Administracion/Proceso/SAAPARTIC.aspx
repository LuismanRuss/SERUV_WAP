<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPARTIC" Codebehind="SAAPARTIC.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAAPARTIC = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAPARTIC[0] = [{ "bSortable": false }, null, null, null, null];
        Sort_SAAPARTIC[1] = [[1, "asc"]];

        var idProceso;
        var cadenaJson = null;
        var arregloArchivos = new Array();

        BotonesSAAPARTIC = function (selec) {//FUNCIÓN DE BOTONES QUE HACE EL CAMBIO ENTRE EL BOTON ACTIVO E INACTIVO
            if (selec > 0) {//Seleccionado
                $("#AccAgregar, #AccExcluir2, #AccSujetoRecept2, #AccNotificaciones, #AccPeriodoExtemp2,#AccReporte").hide();
                $("#AccAgregar2,#AccExcluir,  #AccSujetoRecept, #AccNotificaciones2, #AccPeriodoExtemp,#AccReporte2").show();
            }
            else {// No Seleccionado
                $("#AccAgregar, #AccExcluir2, #AccSujetoRecept2, #AccNotificaciones2, #AccPeriodoExtemp2,#AccReporte").show();
                $("#AccAgregar2,#AccExcluir,  #AccSujetoRecept, #AccNotificaciones, #AccPeriodoExtemp,#AccReporte2").hide();
            }
        }

        function Ajax(nIdProceso) {//FUNCIÓN QUE SE VA AL SERVIDOR Y TRAE LOS DATOS PARA LLENAR EL GRID.
            var actionData = "{'nIdProceso': '" + nIdProceso +
                         "'}";
            $.ajax(
                {
                    url: "Proceso/SAAPARTIC.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        try {
                            Pinta_Grid(eval('(' + reponse.d + ')'));
                            cadenaJson = eval('(' + reponse.d + ')');
                        } catch (err) {
                            txt = "Ha sucedido un error inesperado, inténtelo más tarde.\n\n";
                            txt += "descripción del error: " + err.message + "\n\n";
                            $.alerts.dialogClass = "errorAlert";
                            jAlert(txt, 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                });
        }

        $(document).ready(function () {
            if (NG.Nact == 1) {//si vengo desde el nivel 1
                idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
                nIdProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
                $("#lblProcER").text(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sProceso + ' ' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDPeriodo);
                NG.setNact(2, 'Dos', BotonesSAAPARTIC);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                Ajax(nIdProceso);
            } else if (NG.Nact == 3) {
                $("#lblProcER").text(NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selec].sProceso + ' ' + NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selec].sDPeriodo);
                NG.setNact(2, 'Dos', BotonesSAAPARTIC);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                loading.close();
                NG.repinta();
            } else {
                $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sProceso + ' ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
                NG.setNact(2, 'Dos', BotonesSAAPARTIC);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                Ajax(nIdProceso);
            }
        });

        function Pinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen participantes configurados en este proceso." }
            if (cadena == null) {//SI LA CADENA JSON QUE TRAIGO DEL SERVIDOR ES NULA MUESTRO EL MENSAJE DE ARRIBA
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }

            $('#grid').append(pTablaI(cadena)); //se manda a llamar la función que pinta el grid
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "bDestroy": true,
                "aaSorting": Sort_SAAPARTIC[1],
                "aoColumns": Sort_SAAPARTIC[0]
            });
        };


        function pTablaI(tab) {//FUNCIÓN QUE PINTA EL GRID
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:35%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Sujeto obligado</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Puesto / cargo sujeto obligado</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Sujeto receptor</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="Cambia(\'' + a_i + '\')" /></td>';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="Cambia(\'' + a_i + '\')" /></td>';
                }

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sDDepcia + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sDDepcia + '</div>';
                htmlTab += '</td>';


                if (tab[a_i].sSujetoObligado == 'null' || tab[a_i].sSujetoObligado == null || tab[a_i].sSujetoObligado == '-  ') {
                    htmlTab += '<td class="sorts Acen">' + 'SIN SUJETO OBLIGADO' + '</td>';
                } else {
                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sSujetoObligado + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sSujetoObligado + '</div>';
                    htmlTab += '</td>';
                }

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sDPuesto + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sDPuesto + '</div>';
                htmlTab += '</td>';

                if (tab[a_i].sNombreR == '- -' || tab[a_i].sNombreR == null || tab[a_i].sNombreR == '-  ') {
                    htmlTab += '<td class="sorts Acen">' + 'SIN SUJETO RECEPTOR' + '</td>';
                } else {
                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sNombreR + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sNombreR + '</div>';
                    htmlTab += '</td>';
                }
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function Cambia(selec) {//ESTA FUNCIÓN SE MANDA A LLAMAR CUANDO SE ACTIVA O DESACTIVA UN RADIO EN EL GRID.
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        };

        function fCancelar() {//ME REGRESA A LA FORMA ANTERIOR
            loading.ini();
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }

        function fPeriodoExtemp() {//ME MANDA A LA FORMA DE CONFIGURACIÓN DE PERIODOS EXTEMPORÁNEOS
            loading.ini();
            urls(5, "Proceso/SAAPPEREX.aspx");
        }

        function fSujetoReceptor() {//ME MANDA A LA FORMA DE CONFIGURACIÓN DE SUJETO RECEPTOR
            loading.ini();
            urls(5, "Proceso/SAAPSUJRE.aspx");
        }

        function fExcluir() {//ESTA FUNCIÓN EXCLUYE UNA DEPENDENCIA DEL PROCESO ACTUAL
            dependencia = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDDepcia;
            nIdProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
            nDepcia = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nDepcia;
            npuesto = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nPuesto;
            var nIdPart = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdParticipante;
            var archivos = '\n\n';

            if (cadenaJson != null) {
                if (cadenaJson.length <= 2) {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("No se puede excluir ya que solo existe un participante.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                } else if (nDepcia == NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nDepcia && npuesto == NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nPuesto) {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("No se puede excluir ya que es la dependencia principal del proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                } else {
                    var posicion = 0;
                    do {//ciclo para obtener la posición del participante en el json
                        posicion = posicion + 1;
                    } while (cadenaJson[posicion].nIdParticipante != nIdPart)

                    if (cadenaJson[posicion].laCargaPart.length != 0) {
                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("La dependencia " + dependencia + "  ya tiene archivos cargados, por lo tanto no se puede excluir del proceso actual.");
                    } else {
                        $.alerts.dialogClass = "infoConfirm";
                        jConfirm("¿Está seguro de excluir la dependencia: " + dependencia + "?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                            if (r) {
                                fExcluirDep(nIdPart);
                            }
                        })//termina confirm
                    }
                }
            } else {
                cadenaJson = NG.Var[NG.Nact].datos;
                if (cadenaJson.length <= 2) {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("No se puede excluir ya que solo existe un participante.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                } else if (nDepcia == NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nDepcia && npuesto == NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nPuesto) {
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("No se puede excluir ya que es la dependencia principal del proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                } else {
                    var posicion = 0;
                    do {//ciclo para obtener la posición del participante en el json
                        posicion = posicion + 1;
                    } while (cadenaJson[posicion].nIdParticipante != nIdPart)

                    if (cadenaJson[posicion].laCargaPart.length != 0) {

                        $.alerts.dialogClass = "incompletoAlert";
                        jAlert("La dependencia " + dependencia + "  ya tiene archivos cargados, por lo tanto no se puede excluir del proceso actual.");
                    } else {
                        $.alerts.dialogClass = "infoConfirm";
                        jConfirm("¿Está seguro de excluir la dependencia: " + dependencia + "?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                            if (r) {
                                loading.ini();
                                fExcluirDep(nIdPart);
                            }
                        })//termina confirm
                    }
                }
            }
        }

        function containsJsonObj(objLst, name, value) {
            var nombreDependencia = '';
            $.each(objLst, function () {
                if (this[name] == value) {
                    nombreDependencia = this.strDDepcia;
                    return false;
                }
            });
            return nombreDependencia;
        };

        function fExcluirDep(nIdParticipante) {//ESTA FUNCIÓN EXCLUYE DEPENDENCIAS DEL PROCESO
            var nIdUsuario = $("#hf_idUsuario").val();
            var variables = "{'nIdParticipante': '" + nIdParticipante +
                            "','nIdUsuario': '" + nIdUsuario +
                                "'}";
            $.ajax({
                url: "Proceso/SAAPARTIC.aspx/fExcluirDep",
                data: variables,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = reponse.d;
                    switch (resp) {
                        case 0: //ERROR
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("No se pudo excluir el participante.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                        case 1: //ACCIÓN REALIZADA CORRECTAMENTE
                            NG.Var[NG.Nact].datoSel = null;
                            NG.Var[NG.Nact].datos = null;
                            NG.Var[NG.Nact].selec = 0;
                            Ajax(idProceso);
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("El participante ha sido excluido satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            BotonesSAAPARTIC(0);
                            break;
                        case 100: //SE REQUIERE ACTUALIZAR LA PÁGINA
                            loading.close();
                            $.alerts.dialogClass = "infoAlert";
                            jAlert("La información ha cambiado, porfavor actualice su página", "SISTEMA DE ENTREGA - RECEPCIÓN");
                    }
                },
                error: errorAjax
            });
        }

        function fAgregar() {//ME MANDA A LA FORMA QUE ME PERMITE AGREGAR PARTICIPANTES AL PROCESO
            loading.ini();
            urls(5, "Proceso/SAAPARTICH.aspx");
        }

        function fActualizarGrid() {//FUNCIÓN QUE ACTUALIZA EL GRID
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            Ajax(idProceso);
        }

        function fReporte(op) {
            $("#hf_operacion").val(op);
            //alert("1");
            //idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
            //alert("2");
            //nIdProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
            //console.log(idProceso);

            dTxt = '<div id="dComent" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + nIdProceso + '&op=PARTICIPANTES' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#SAAPARTIC').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //800,
                width: $("#agp_contenido").width() - 50, //1000,
                modal: true,
                resizable: true,
                close: function (event, ui) {
                    fCerrarDialog();
                }
            });
        }

        function fCerrarDialog() {//FUNCIÓN QUE CIERRA EL DIALOG
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

    </script>

    <form id="SAAPARTIC" runat="server">
     <div id="agp_contenido">
        <div id="agp_navegacion"> 
            <label class="titulo">Dependencias / entidades</label>
            <div class="a_acciones">
                <a id="AccAgregar" title="Agregar Proceso" href="javascript:fAgregar();" class="accAct">Agregar</a>
                <a id="AccAgregar2" title="Agregar Proceso" class="accIna iOculto">Agregar</a>
            
                <a id="AccExcluir" title="Excluir" href="javascript:fExcluir();" class="accAct iOculto">Excluir</a>
                <a id="AccExcluir2" title="Excluir" class="accIna">Excluir</a>

                <a id="AccSujetoRecept" title="Sujeto receptor" href="javascript:fSujetoReceptor();" class="accAct iOculto">Sujeto Receptor</a>
                <a id="AccSujetoRecept2" title="Sujeto receptor" class="accIna">Sujeto Receptor</a>           
                
                <a id="AccNotificaciones" title="Notificaciones" href="javascript:fNotificaciones();" class="accAct iOculto">Notificaciones</a>
                <a id="AccNotificaciones2" title="Notificaciones" class="accIna">Notificaciones</a>

                <a id="AccPeriodoExtemp" title="Periodos extemporáneos" href="javascript:fPeriodoExtemp();" class="accAct iOculto">Periodos Extemporáneos</a>
                <a id="AccPeriodoExtemp2" title="Periodos extemporáneos" class="accIna">Periodos Extemporáneos</a>

                <a id="AccReporte" title="Reporte" href="javascript: fReporte('PARTICIPANTES');" class="accAct iOculto">Reporte</a>
                <a id="AccReporte2" title="Reporte" class="accIna">Reporte</a>
            </div>
        </div>
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>
        <br />

        <div class="instrucciones">Seleccione un participante para realizar las acciones correspondientes:</div>
                             
        <h2>Proceso entrega - recepción: </h2> <label id="lblProcER"></label>             
                            
        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
            </table>
        </div>  
        <br />

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>    
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
    </div> 
    </form>
</body>
</html>
