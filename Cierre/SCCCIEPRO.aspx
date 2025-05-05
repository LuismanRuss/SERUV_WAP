<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCCCIEPRO" Codebehind="SCCCIEPRO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Monitoreo.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />    
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
</head>
<body>
    <script type="text/javascript">
        var Sort_SSCMONPRO = new Array(2);
        Sort_SSCMONPRO[0] = [{ "bSortable": false }, null, null, null, null, null, null];
        Sort_SSCMONPRO[1] = [[2, "asc"]];

        function BotoneSSCMONPRO(selec) {
            if (selec > 0) {//Seleccionado
                $("#AccAceptar").show();
            } else { // No seleccionado
                $("#AccAceptar").hide();
            }
        }

        $(document).ready(function () {
            loading.ini();
            NG.setNact(1, 'Uno', BotoneSSCMONPRO);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            fAjax();
        });

        function fAjax() {//función que me regresa los procesos en los que el usuario está logueado
            var nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'nIdUsuario': '" + nIdUsuario +
                         "'}";
            $.ajax({
                url: "SCSCIEPRO.aspx/pGetProceso",
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

        function Pinta_Grid(cadena) {//Función que pinta el grid de procesos
            $('#grid').empty();
            mensaje = { "mensaje": "Usted no cuenta con procesos a supervisar." }
            if (cadena == null || cadena == "") {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena)); //mando a llamar la función que pinta el grid con los procesos
            a_di = new o_dialog('VER DEPENDENCIAS');
            a_di.iniDial();

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SSCMONPRO[1],
                "aoColumns": Sort_SSCMONPRO[0]
            });
            loading.close();
        };


        function pTablaI(tab) {//función que pinta el grid con los procesos
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Código</th>';
            htmlTab += '<th scope="col" style="width:30%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Fecha inicial</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Fecha final</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Estado</th>';
            htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Dependencias / entidades</th>';
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

                htmlTab += '<td class="sorts Acen">';
                htmlTab += '<div class="textoD">' + tab[a_i].sProceso + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sProceso + '</div>';
                htmlTab += '</td>';

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sDProceso + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sDProceso + '</div>';
                htmlTab += '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].sFechaInicio + '</td>';
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sFechaFinal + '</td>';

                if (tab[a_i].sEstatus == 'A') {
                    htmlTab += '<td class="sorts Acen">' + 'ABIERTO' + '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">' + 'CERRADO' + '</td>';
                }

                if (tab[a_i].laDepcias.length == 1) {//si el proceso solo tiene una dependencia
                    htmlTab += '<td class="sorts">';
                    htmlTab += '<div class="textoD">' + tab[a_i].laDepcias[0].sDDepcia + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].laDepcias[0].sDDepcia + '</div>';
                    htmlTab += '</td>';
                } else {//si el proceso tiene mas de una dependencia se da la opción de abrir un dialog para mostrarlas
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER DEPENDENCIAS..</a></div>';
                    htmlTab += '<div class="dialoG oculto"><ul>';
                    for (a_j = 0; a_j < tab[a_i].laDepcias.length; a_j++)
                        htmlTab += '<li>' + tab[a_i].laDepcias[a_j].sDDepcia + '</li>';
                    htmlTab += '</ul></div></td>';
                }
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function Cambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        }


        function cerrar() {//función que cierra el dialog
            parent.window.fn_cerrarPform();
        }

        function Aceptar() {//función que abre el proceso seleccionado y cierra el dialog
            var idProc = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;
            var nomProc = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sProceso + ' ' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDProceso;
            parent.window.fn_cerrarPform(idProc, nomProc);

        }

        function MostrarDep(datos) {// Función para mostrar dependencias.
            var txt = "";
            for (a_j = 0; a_j < datos.length; a_j++) {
                txt += datos[a_j].sDDepcia + ",";
            }

            $("#dialog-confirm").empty();
            $("#dialog-confirm").append(txt);

            $(function () {
                $("#dialog-confirm").dialog({
                    resizable: false,
                    height: 550,
                    width: 970,
                    modal: true,
                    buttons: {
                    //                            "Aceptar": function () {
                    //                                strEXCEPTO = '1';
                    ////                                Guardar();
                    //                                $(this).dialog("close");
                    //                            },
                    //                            "Cancelar": function () {
                    //                                $(this).dialog("close");
                    //                            }
                }
            });
        });

    }

    function fCerrar() {//Función para cerrar la ventana modal.
        parent.window.fCerrarDialogBuscaProceso();
    }
    </script>
    <form id="SCCCIEPRO" runat="server">
      <div id="fixme">
    </div>
    <div id="agp_contenido">

        <div class="instrucciones">Seleccione un proceso para realizar las acciones correspondientes.</div>
        <div class="TablaGrid">
             <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
        </div>

        <div class="a_botones_modal">
            <a id="AccAceptar"  title="Botón Abrir" href="javascript:Aceptar();" class="btnAct" style="float:inherit; ">Abrir</a> 
            <a title="Botón Cancelar" href="javascript:fCerrar();" class="btnAct" style="float:inherit; ">Cancelar</a>       
        </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>
        <div id="div2">
            <input id="hf_anexo" type="hidden" />
        </div>

     <div id="dialog-confirm" title="SISTEMA ENTREGA-RECEPCIÓN">            
        </div>
    </div>
    </form>
</body>
</html>
