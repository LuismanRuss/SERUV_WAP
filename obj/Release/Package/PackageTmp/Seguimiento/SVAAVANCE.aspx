<%@ Page Language="C#" AutoEventWireup="true" Inherits="Seguimiento_SVAAVANCE" Codebehind="SVAAVANCE.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>

    <script type="text/javascript">
        function fAjax() {
            var actionData = "{}";
            $.ajax(
                {
                    url: "SVAAVANCE.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        // console.log(reponse.d);
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                        //EjemploJsonPath( reponse.d );
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        $(document).ready(function () {

            sel = true;
            NG.setNact(1, 'Uno');
//            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            if (NG.Var[NG.Nact].oSets == null) {
                //                    if (NG.Var[NG.Nact].oSets == null || acc_val == 'nue') {
                fAjax();
                //                        console.log(NG);
            } else {
                NG.repinta();
            }
        });

        function Pinta_Grid(cadena) {
            // console.log(cadena.datos);
            $('#grid').empty();
            mensaje = { "mensaje": "No existen datos con la opción seleccionada" }
            if (cadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena));

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAAPRCENTREC[1],
                "aoColumns": Sort_SAAPRCENTREC[0]
            });
            //NG.Var[NG.Nact].oTable = lTable;
        };


        function pTablaI(tab) {
            // console.log("condicion" + condicion);
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">CÓDIGO</th>';
            htmlTab += '<th align="center" scope="col" style="width:30%;" class="sorting" title="Ordenar">NOMBRE</th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">CÓDIGO GUÍA</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">TIPO DE ENTREGA</th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">FECHA INICIAL</th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">FECHA FINAL</th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">DISPONIBILIDAD</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
//                if (NG.Var[NG.Nact].selec == a_i) {
//                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
//                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
//                } else {
//                    htmlTab += '<tr id="tr_' + a_i + '" >';
//                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
//                }

//                htmlTab += '<td class="sorts Acen">' + tab[a_i].nDepcia + '</td>';
//                htmlTab += '<td class="sorts">' + tab[a_i].sDPeriodo + '</td>';
//                htmlTab += '<td class="sorts Acen">' + tab[a_i].sGuiaER + '</td>';
//                htmlTab += '<td class="sorts Acen">' + tab[a_i].sDTipoPeri + '</td>';
//                htmlTab += '<td class="sorts Acen">' + tab[a_i].sFInicio + '</td>';
//                htmlTab += '<td class="sorts Acen">' + tab[a_i].sFFinal + '</td>';

            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

//        function fCambia(selec) {
//            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
//            NG.cambia(selec);
//            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
//        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
