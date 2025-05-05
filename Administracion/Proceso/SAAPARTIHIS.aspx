<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPARTIHIS" Codebehind="SAAPARTIHIS.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAAPARTIHIS = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAPARTIHIS[0] = [{ "bSortable": false }, null, null, null, null];
        Sort_SAAPARTIHIS[1] = [[1, "asc"]];

        BotonesSAAPARTIH = function (selec) {
            if (selec > 0) {//Seleccionado
                $("#AccPeriodoExtemp2").hide();
                $("#AccPeriodoExtemp").show();
            }
            else {// No Seleccionado
                $(" #AccPeriodoExtemp2").show();
                $(" #AccPeriodoExtemp").hide();
            }
        }

        $(document).ready(function () {
            if (NG.Nact == 3) {//si vengo desde el nivel 1
                $("#lblProcER").text(NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selec].sProceso + ' ' + NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selec].sDPeriodo);
                NG.setNact(2, 'Dos', BotonesSAAPARTIH);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                loading.close();
                NG.repinta();
            } else {
                var nIdProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idProceso;
                NG.setNact(2, 'Dos', BotonesSAAPARTIH);
                $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sProceso + ' ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
                Ajax(nIdProceso);
            }
        });

        function Ajax(nIdProceso) {//esta función regresa las dependencias de un proceso
            var actionData = "{'nIdProceso': '" + nIdProceso +
                         "'}";
            $.ajax({
                url: "Proceso/SAAPARTIHIS.aspx/pPinta_Grid",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                },
                error: errorAjax
            });
        }

        function Pinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen participantes configurados en este proceso." }
            if (cadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena));//se manda a llamar la función que pinta el grid
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "bDestroy": true,
                "aaSorting": Sort_SAAPARTIHIS[1],
                "aoColumns": Sort_SAAPARTIHIS[0]
            });
        };

        function pTablaI(tab) {//función que pinta el grid de participantes
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:35%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Sujeto obligado</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Sujeto receptor</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Estado</th>';
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

                if (tab[a_i].sNombreR == '- -' || tab[a_i].sNombreR == null || tab[a_i].sNombreR == '-  ') {
                    htmlTab += '<td class="sorts Acen">' + 'SIN SUJETO RECEPTOR' + '</td>';
                } else {
                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sNombreR + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sNombreR + '</div>';
                    htmlTab += '</td>';
                }

                if (tab[a_i].cIndCerrado == 'N' || tab[a_i].cIndCerrado == null) {
                    htmlTab += '<td class="sorts Acen">' + 'ABIERTO' + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + 'CERRADO' + '</td>';
                }
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function Cambia(selec) {//función que activa o desactiva los botones dependiendo si se selecciona o no un registro en el grid
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        };

        function fCancelar() {//función que regresa a la forma de histórico de procesos
            loading.ini();
            urls(5, "Proceso/SAAPRCENTREH.aspx");
        }

        function fPeriodoExtemp() {//función que manda a la forma de periodos extemporaneos
            loading.ini();
            urls(5, "Proceso/SAAPPEREX.aspx?pagina=" + "H");
        }
    </script>


    <form id="SAAPARTIHIS" runat="server">
       <div id="agp_contenido">
        <div id="agp_navegacion"> 
            <label class="titulo">Dependencias / entidades</label>
            <div class="a_acciones">
                <a id="AccPeriodoExtemp" title="Periodos extemporáneos" href="javascript:fPeriodoExtemp();" class="accAct iOculto">Periodos Extemporáneos</a>
                <a id="AccPeriodoExtemp2" title="Periodos extemporáneos" class="accIna">Periodos Extemporáneos</a>
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
