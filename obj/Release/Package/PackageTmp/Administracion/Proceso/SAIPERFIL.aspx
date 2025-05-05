<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAIPERFIL" Codebehind="SAIPERFIL.aspx.cs" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
 
        var idProceso;

        $(document).ready(function () {
            //            alert(NG.Nact);
            //            $("#lbl_Proceso").text(NG.Var[NG.Nact].datoSel.sDPeriodo);
            //            console.log("NACT: " + NG.Nact);
            NG.setNact(2, 'Dos', null);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            //ActualizarGrid();
            $("#lbl_Proceso").text(NG.Var[NG.Nact - 1].datoSel.sDPeriodo);
            idProceso = NG.Var[NG.Nact - 1].datoSel.nIdProceso;
            //console.log(idProceso);

            if (NG.Var[NG.Nact].oSets == null) {
                Ajax();

            } else {
                NG.repinta();
            }
        });

        function Ajax() {
            //alert("entra");
            var actionData = "{'nIdProceso':'" + idProceso + "'}";
            //console.log(actionData);
            $.ajax({
                url: "Proceso/SAIPERFIL.aspx/Pinta_Grid",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    //console.log(reponse);
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                    //console.log(reponse.d);
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: errorAjax
            }
                );
        }


        function Pinta_Grid(cadena) {
            //console.log(cadena.datos);
            $('#grid').empty();
            if (cadena.resultado == '2') {
                $('#grid').append('<tr><td class="Acen">' + cadena.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena));

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true
            });
            //NG.Var[NG.Nact].oTable = lTable;
        };

        function pTablaI(tab) {
            //            console.log("tab " + tab);
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th align="center" scope="col" style="width:99%;" class="sorting" title="Ordenar"></th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                htmlTab += '<tr class="row_selected">';
                    if (tab[a_i].lstPerfiles.length == 1) {
                        htmlTab += '<td class="sorts">';
                            htmlTab += '<ul>';
                            for (a_j = 0; a_j < tab[a_i].lstPerfiles.length; a_j++)
                                htmlTab += '<li>' + tab[a_i].lstPerfiles[a_j].strsDCPerfil + '</li>';
                        htmlTab += '</ul></td>';                                                
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

        };

        function ActualizarGrid() {
            $("#grid").empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            Ajax();
        }

    </script>

    <form id="form1" runat="server">
    <div id="agp_contenido">    
        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>
    </div>
    </form>
</body>
</html>
