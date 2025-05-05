<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SSCANEXDEP" Codebehind="SSCANEXDEP.aspx.cs" %>

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
        var Sort_SSCANEXDEP = new Array(2);
        Sort_SSCANEXDEP[0] = [{ "bSortable": true }, null, null];
        Sort_SSCANEXDEP[1] = [[2, "asc"]];

        var Sort_SSCANEXDEP2 = new Array(2);
        Sort_SSCANEXDEP2[0] = [{ "bSortable": true }, null];
        Sort_SSCANEXDEP2[1] = [[2, "asc"]];

        $(document).ready(function () {
            loading.ini();
            var opcion = $("#hf_Opcion").val(); //variable que contiene la opción de anexos que quiero consultar
            var nIdParticipante = $("#hf_idParticipante").val(); //variable que contiene el ID del particiapnte
            var proceso = $("#hf_proceso").val(); //variable que contiene el nombre del proceso-ER
            var dependencia = $("#hf_dependencia").val(); //variable que contiene el nombre de la dependencia
            var numeroAnexos = $("#hf_numeroAnexos").val(); //variable que contiene el numero de anexos

            $("#lblProcesoER").text(proceso);
            $("#lblDepcia").text(dependencia);

            switch (opcion) {//dependiendo del tipo de anexo que haya seleccionado sera la consulta que hará
                case "excluidos": //si quiero consultar los anexos excluidos
                    fGetExcluidos(nIdParticipante, opcion, numeroAnexos);
                    break;

                case "integrados": //si quiero consultar los anexos integrados
                    fGetIntegrados(nIdParticipante, opcion, numeroAnexos);
                    break;

                case "pendientes": //si quiero consultar los anexos pendientes
                    fGetPendientes(nIdParticipante, opcion, numeroAnexos);
                    break;
            }
        });

        function cerrar() {//función que cierra el dialog
            parent.window.fn_cerrarPform();
        }


        function fGetExcluidos(nIdParticipante, opcion, numeroAnexos) {//función que obtiene los anexos excluidos del participante
            var actionData = "{'nIdParticipante': '" + nIdParticipante +
                            "','numeroAnexos': '" + numeroAnexos +
                                "'}";
            $.ajax(
                {
                    url: "SSSMONPRO.aspx/fGetAnexosExcluidos",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        if (eval('(' + reponse.d + ')') == '2') {//si traigo un 2 de respuesta significa que la información cambió y se debe actualizar la página
                            parent.window.CerrarVentAct(); //se cierra el dialog automáticamente
                        } else {//si no cambió la información se muestra el grid
                            Pinta_Grid(eval('(' + reponse.d + ')'), opcion);
                        }
                    },
                    error: errorAjax
                });
        }

        function fGetIntegrados(nIdParticipante, opcion, numeroAnexos) {//función que obtiene los anexos integrados del participante
            var actionData = "{'nIdParticipante': '" + nIdParticipante +
              "','numeroAnexos': '" + numeroAnexos +
                                "'}";
            $.ajax(
                {
                    url: "SSSMONPRO.aspx/fGetAnexosIntegrados",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var integrados = 'integrados';
                        if (eval('(' + reponse.d + ')') == '2') {//si traigo un 2 de respuesta significa que la información cambió y se debe actualizar la página
                            parent.window.CerrarVentAct();//se cierra el dialog automáticamente
                        } else {//si no cambió la información se muestra el grid
                            Pinta_Grid(eval('(' + reponse.d + ')'), opcion);
                        }
                    },
                    error: errorAjax
                });
        }

        function fGetPendientes(nIdParticipante, opcion, numeroAnexos) {//función que obtiene los anexos pendientes del participante
            var actionData = "{'nIdParticipante': '" + nIdParticipante +
                            "','numeroAnexos': '" + numeroAnexos +
                                "'}";
            $.ajax(
                {
                    url: "SSSMONPRO.aspx/fGetAnexosPendientes",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var pendientes = 'pendientes';
                        if (eval('(' + reponse.d + ')') == '2') {//si traigo un 2 de respuesta significa que la información cambió y se debe actualizar la página
                            parent.window.CerrarVentAct(); //se cierra el dialog automáticamente
                        } else {//si no cambió la información se muestra el grid
                            Pinta_Grid(eval('(' + reponse.d + ')'), opcion);
                        }
                    },
                    error: errorAjax
                });
        }

        function Pinta_Grid(cadena, opcion) {
            $('#grid').empty();
            mensaje = { "mensaje": "Sin información." }
            if (cadena == null || cadena == "") {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }

            if (opcion == "excluidos") {//para consultar los anexos excluidos
                $('#grid').append(pTablaExcluidos(cadena));
                NG.tr_hover();
                a_di = new o_dialog('Justificación');
                a_di.iniDial();
                tooltip.iniToolD('25%');
                NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                    "aaSorting": Sort_SSCANEXDEP[1],
                    "aoColumns": Sort_SSCANEXDEP[0]
                });
            } else if (opcion == "integrados") {//para consultar a los anexos integrados
                $('#grid').append(pTablaIntegrados(cadena));
                a_di = new o_dialog('Ver Perfiles');
                a_di.iniDial();
                NG.tr_hover();
                tooltip.iniToolD('25%');
                NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                    "aaSorting": Sort_SSCANEXDEP2[1],
                    "aoColumns": Sort_SSCANEXDEP2[0]
                });
            } else if (opcion == "pendientes") {//para consultar a los anexos pendientes
                $('#grid').append(pTablaPendientes(cadena));
                a_di = new o_dialog('Ver Perfiles');
                a_di.iniDial();
                NG.tr_hover();
                tooltip.iniToolD('25%');
                NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                    "aaSorting": Sort_SSCANEXDEP2[1],
                    "aoColumns": Sort_SSCANEXDEP2[0]
                });
            }
            loading.close();
        };


        function pTablaExcluidos(tab) {//función qu pinta el grid de los anexos excluidos
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Codigo</th>';
            htmlTab += '<th scope="col" style="width:54%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th scope="col" style="width:30%;" class="sorting" title="Ordenar">Motivo</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                }
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sAnexo + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].sDAnexo + '</td>';
                htmlTab += '<td class="sorts Acen">';
                htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">Ver justificación..</a></div>';
                htmlTab += '<div class="dialoG oculto"><ul>';
                htmlTab += '<li>' + tab[a_i].sJustificacion + '</li>';
                htmlTab += '</ul></div></td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function pTablaIntegrados(tab) {//función que pinta el grid de los anexos integrados
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Código</th>';
            htmlTab += '<th scope="col" style="width:84%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                }
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sAnexo + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].sDAnexo + '</td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function pTablaPendientes(tab) {//función que pinta el grid de los anexos pendientes
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Codigo</th>';
            htmlTab += '<th scope="col" style="width:84%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                }
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sAnexo + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].sDAnexo + '</td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function fCerrar() {//función que cierra la ventana modal 
            parent.window.fCerrarDialogAnexos();
        }
    </script>

    <form id="SSCANEXDEP" runat="server">            
        <h2>Proceso entrega - recepción:</h2>   
        <label id="lblProcesoER"></label>            
        <br />
        
        <h2>Dependencia / entidad:</h2>
        <label id="lblDepcia"></label>
        <br />
           
        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
            </table>
        </div>  

            <div class="a_botones_modal">
                <a id="Btn_Guardar" class="btnAct" style="float:inherit; " title="Botón Cerrar" href="javascript:fCerrar();">Cerrar</a>                               
            </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_Opcion" runat="server" />
            <asp:HiddenField ID="hf_idParticipante" runat="server" />
            <asp:HiddenField ID="hf_proceso" runat="server" />
            <asp:HiddenField ID="hf_dependencia" runat="server" />
            <asp:HiddenField ID="hf_numeroAnexos" runat="server" />
        </div>
    </form>
</body>
</html>
