<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SASPARTIC" Codebehind="SASPARTIC.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   <%-- <script src="../../scripts/session.js" type="text/javascript"></script> --%>   
</head>
<body>
        <script type="text/javascript">

            var Sort_SASPARTIC = new Array(2);  /* Indicación de la ordenación por default del grid */
            Sort_SASPARTIC[0] = [{ "bSortable": false }, null, null, null, null, null, null];
            Sort_SASPARTIC[1] = [[1, "asc"]];


            var arregloSeleccionadas = new Array(); //arreglo de las dependencias
            var arregloDependencias = new Array();
            var arregloDepcia = new Array();

            BotonesSASPARTIC = function (selec) {
                if (selec > 0) {//Seleccionado
                    $("#AccAsignaPerfil").show();
                    $("#AccAsignaPerfil2").hide();
                }
                else {// No Seleccionado
                    $("#AccAsignaPerfil2").show();
                    $("#AccAsignaPerfil").hide();
                }
            }

            //Muestra datos de las dependencias de un proceso
            function Ajax(nIdProceso) {
            var actionData = "{'nIdProceso': '" + nIdProceso +
                         "'}";
            $.ajax(
                {
                    url: "Proceso/SASPARTIC.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        try {
                            arregloSeleccionadas = []; //vacio el arreglo
                            Pinta_Grid(eval('(' + reponse.d + ')'));                           
                            cadenaJson = eval('(' + reponse.d + ')');                         
                        } catch (err) {
                            txt = "Ha sucedido un error inesperado, inténtelo más tarde.\n\n";
                            txt += "descripción del error: " + err.message + "\n\n";
                            alert(txt);
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
        }

        $(document).ready(function () {            
            loading.close();
            if (NG.Nact == 1) {//si vengo desde el nivel 1
                idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
                nIdProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
                $("#lblProcER").text(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDPeriodo);

                NG.setNact(2, 'Dos', BotonesSASPARTIC);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                Ajax(nIdProceso);
            } else if (NG.Nact == 3) {                      
                $("#lblProcER").text( NG.Var[NG.Nact - 2].datos[NG.Var[NG.Nact - 2].selec].sDPeriodo);

                NG.setNact(2, 'Dos', BotonesSASPARTIC);
                NG.Var[NG.Nact].selec = 0;
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
              
                Ajax(nIdProceso);
            } else {             
                $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
                NG.setNact(2, 'Dos', BotonesSASPARTIC);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                Ajax(nIdProceso);
            }
        });

        //Pinta los datos de las dependencias en el grid
        function Pinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen participantes configurados en este proceso." }
            if (cadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
                     
            $('#grid').append(pTablaI(cadena));
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna

            a_di = new o_dialog('SUPERVISORES');
            a_di.iniDial();
            NG.tr_hover();
            tooltip.iniToolD('45%');

            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "bDestroy": true,
                "aaSorting": Sort_SASPARTIC[1],
                "aoColumns": Sort_SASPARTIC[0]
            });
        };

        //función que controla el seleccionado de cada dependencia
        function Selecciona(actual) {
            BotonesSASPARTIC(1);
            if ($('#ch_' + actual).is(':checked')) {
                arregloSeleccionadas.push(NG.Var[NG.Nact].datos[actual].nidProcPart);
                arregloDependencias.push(NG.Var[NG.Nact].datos[actual].sDDepcia);
                $('#tr_' + actual).addClass('row_selected');
            } else {
                $('#tr_' + actual).removeClass('row_selected');
                //llena arreglo con el idprocPart de las dependencias que se has seleccionado para asignar un supervisor
                for (i = 0; i < arregloSeleccionadas.length; i++) {
                    if (arregloSeleccionadas[i] == NG.Var[NG.Nact].datos[actual].nidProcPart) {
                        arregloSeleccionadas.splice(i, 1);
                    }
                }
                //llena arreglo con el nombre de las dependencias que se has seleccionado para asignar un supervisor
                for (i = 0; i < arregloDependencias.length; i++) {
                    if (arregloDependencias[i] == NG.Var[NG.Nact].datos[actual].sDDepcia) {
                        arregloDependencias.splice(i, 1);
                    }
                }
            }

            if (arregloSeleccionadas.length == 0) {
                BotonesSASPARTIC(0);
            }
            if (arregloDependencias.length == 0) {
                BotonesSASPARTIC(0);
            }
        }

        //Muestra la tabla de dependencias de un determinado proceso
        function pTablaI(tab) {          
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:3%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:19%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Sujeto obligado</th>';         
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Sujeto receptor</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Supervisor SAF</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Supervisor CG</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Supervisor</th>';          
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {

                //************************************************
                a_class = '';
                a_check = '';

                htmlTab += '<tr id="tr_' + a_i + '"' + a_class + '>';
                htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="checkbox"' + a_check + 'onclick="Selecciona(\'' + a_i + '\')" /></td>';
                //************************************************


                htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].sDDepcia + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].sDDepcia + '</div>';
                htmlTab += '</td>';

                //::::::::::::::::::::::::::::SUJETO OBLIGADO:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                if (tab[a_i].sSujetoObligado == 'null' || tab[a_i].sSujetoObligado == null || tab[a_i].sSujetoObligado == '-  ') {
                    htmlTab += '<td class="sorts Acen">' + 'SIN SUJETO OBLIGADO' + '</td>';
                } else {                    
                    htmlTab += '<td class="sorts">';
                        htmlTab += '<div class="textoD">' + tab[a_i].sSujetoObligado + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].sSujetoObligado + '</div>';
                    htmlTab += '</td>';
                }

                //::::::::::::::::::::::::::::::::SUJETO RECEPTOR::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                if (tab[a_i].sNombreR == '- -' || tab[a_i].sNombreR == null || tab[a_i].sNombreR == '-  ') {
                    htmlTab += '<td class="sorts Acen">' + 'SIN SUJETO RECEPTOR' + '</td>';
                } else {                   
                    htmlTab += '<td class="sorts">';
                        htmlTab += '<div class="textoD">' + tab[a_i].sNombreR + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].sNombreR + '</div>';
                    htmlTab += '</td>';
                }

                //:::::::::::::::::::::::::::::::SUPERVISOR SAF::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                if (tab[a_i].laDependencias.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN SUPERVISOR SAF</td>';
                   
                } else {
                    if (tab[a_i].laDependencias.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laDependencias[0].sNombre.toUpperCase() + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laDependencias[0].sNombre.toUpperCase() + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER SUPERVISOR</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laDependencias.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laDependencias[a_j].sNombre.toUpperCase() + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
                //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                //::::::::::::::::::::::SUPERVISOR CG:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                if (tab[a_i].laParticipantes.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN SUPERVISOR CG</td>';

                } else {
                    if (tab[a_i].laParticipantes.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laParticipantes[0].sNombre.toUpperCase() + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laParticipantes[0].sNombre.toUpperCase() + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER SUPERVISOR</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laParticipantes.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laParticipantes[a_j].sNombre.toUpperCase() + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
                //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                //::::::::::::::::::::::::::SUPERVISOR::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                if (tab[a_i].laDepcias.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN SUPERVISOR</td>';

                } else {
                    if (tab[a_i].laDepcias.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laDepcias[0].sNombre.toUpperCase() + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laDepcias[0].sNombre.toUpperCase() + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER SUPERVISOR</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laDepcias.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laDepcias[a_j].sNombre.toUpperCase() + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
                //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        //Función para ir a la forma principal de procesos
        function fCancelar() {   
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }

        //Función que permite asignar el perfil de supervisor
        function fAsignaPerfil() {           
            arregloDepcia[1] = arregloSeleccionadas;
            arregloDepcia[2] = arregloDependencias;
            NG.Var[NG.Nact].arreglo = arregloDepcia;
            loading.ini();
            urls(5, "Proceso/SASPARTICA.aspx");          
        }
       
       //Función que permite asignar un usuario como supervisor de una o más dependencias
        function fEnviarAjax(arregloSeleccionadas) {

            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'sSeleccionadas': '" + arregloSeleccionadas +
                            "','nIdProceso': '" + nIdProceso +
                             "','nIdUsuario': '" + nIdUsuario +
                             "','sDependencias': '" + arregloDependencias +
                               "'}";

            $.ajax({
                url: "Proceso/SASPARTICA.aspx/fIncluirDep",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = reponse.d;
                    switch (resp) {
                        case 0:
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("No se pueden guardar los cambios.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                        case 1:                           
                            loading.close();
                            fActualizarGrid();
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            BotonesSAAPARTICH(0);
                            break;
                    }
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
            });
        }

      


    </script>

    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion"> 
            <label class="titulo"> Supervisor / Dependencias</label>
            <div class="a_acciones">     
                <a id="AccAsignaPerfil" title="Sujeto receptor" href="javascript:fAsignaPerfil();" class="accAct iOculto">Asignar Supervisor</a>
                <a id="AccAsignaPerfil2" title="Sujeto receptor" class="accIna">Asignar Supervisor</a>   
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
            <asp:HiddenField ID="hf_idUsuario" runat="server"/>
            <asp:HiddenField ID="hf_depcias" runat="server"/>
        </div>
    </div> 
    </form>
</body>
</html>
