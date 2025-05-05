<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SMCBUSPROC" Codebehind="SMCBUSPROC.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />    
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
</head>
<body>
    <script type="text/javascript">
        /*Configuración del grid para mostrar los procesos donde ha participado un usuario*/
        var Sort_SSCMONPRO = new Array(2);
        Sort_SSCMONPRO[0] = [{ "bSortable": false }, null, null, null, null, null, null, null];
        Sort_SSCMONPRO[1] = [[1, "desc"]];

        /*Se lanza al inicio de la carga del lado del cliente*/
        $(document).ready(function () {
            loading.ini(); // Se lanza la capa de cargando
            NG.setNact(1, 'Uno'); // se establece el nivel actual
            NG.Var[NG.Nact].datoSel = eval('(' + $("#hf_NG", parent.document).val() + ')'); //Se recuperan los datos necesarios de la forma anterior

            if (NG.Var[NG.Nact].datoSel != null) {
                $("#hf_NG", parent.document).val(""); // Se limpia el hidden de la forma anterior
                fGetProcesos(); // Se buscan los proceso menos el proceso en primer plano
            }
        });

        /*función general que pinta los procesos donde ha participado un usuario*/
        function fPinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No se encontraron registros con la opción seleccionada." }
            if (cadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }

            $('#grid').append(pTablaI(cadena));
            
            a_di = new o_dialog('Ver Participantes');
            a_di.iniDial();

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna charIndEntrega
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SSCMONPRO[1],
                "aoColumns": Sort_SSCMONPRO[0]
            });
            loading.close();
        };

        /*Función que regresa una cadena donde se listan los procesos donde ha participado un usuario*/
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            if (tab != null) {
                htmlTab = '';
                htmlTab += '<thead><tr>';
                htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
                htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Código</th>';
                htmlTab += '<th scope="col" style="width:35%;" class="sorting" title="Ordenar">Nombre</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Fecha inicial</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Fecha final</th>';
                htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Estado</th>';
                htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Perfil</th>';
                htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Participantes</th>';
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
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].strProceso + '</td>';
                    htmlTab += '<td class="sorts">' + tab[a_i].strDProceso + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFInicio + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFFin + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].strEstatus + '</td>'; //
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].strPuesto + '</td>'; //
                    if (tab[a_i].lstParticipantes.length > 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">Ver participantes</a></div>';
                        htmlTab += '<div class="dialoG oculto">';
                        htmlTab += '<ul>'
                        for (k = 0; k < tab[a_i].lstParticipantes.length; k++) {
                            htmlTab += '<li>' + tab[a_i].lstParticipantes[k].strDDepcia + '</li>';
                        }
                        htmlTab += '</ul>'
                        htmlTab += '</div>';
                        htmlTab += '</td>';
                    }
                    else {
                        htmlTab += '<td class="sorts Acen">' + tab[a_i].lstParticipantes[0].strDDepcia + '</td>';
                    }
                }
                htmlTab += "</tr>";
                htmlTab += "</tbody>";
            }

            return htmlTab;
        }

        /*función que se lanzo en la acción del "click" en el radio para seleccionar un proceso*/
        function Cambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            if (NG.Var[NG.Nact].datoSel != null) {
                $("#lnk_cerrar").empty().append("Seleccionar");
            }
            else {
                $("#lnk_cerrar").empty().append("Cerrar");
            }
        }

        /*Función que consulta al servidor los procesos donde ha participado un usuario excepto el procesos que esta en primer plano*/
        function fGetProcesos() {
            objProceso = NG.Var[NG.Nact].datoSel.lstProcesos[0]; // Proceso en primer plano
            if (objProceso != null) {
                objProceso.nUsuario = NG.Var[NG.Nact].datoSel.idUsuario; //
                objProceso.strOpcion = 'MONITOREO';
                objProceso.strAccion = 'PROCESOS';
                actionData = frms.jsonTOstring({ objProceso: objProceso });
                $.ajax(
                    {
                        url: "SMCBUSPROC.aspx/pGetProcesosH",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                                objTemp = eval('(' + reponse.d + ')');
                                if (objTemp != null && objTemp[0].lstProcesos != null) {
                                    fPinta_Grid(objTemp[0].lstProcesos);
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

        /*Función que se lanza a la hora de cerrar la forma*/
        function fCerrar() {
            parent.window.fCerrarDialogP(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
        }
    </script>
    <form id="form1" runat="server">
        <div id="fixme"></div>
        <div id="agp_contenido">
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table> 
            </div>  
            <div class="a_botones_modal">
                <a title="Botón Cerrar" id="lnk_cerrar" href="javascript:fCerrar();" class="btnAct">Cerrar</a>        
            </div>
        </div>  
    </form>
</body>
</html>
