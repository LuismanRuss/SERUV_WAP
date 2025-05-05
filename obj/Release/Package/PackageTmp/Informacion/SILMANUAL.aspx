<%@ Page Language="C#" AutoEventWireup="true" Inherits="Informacion_SILMANUAL" Codebehind="SILMANUAL.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>
    <link href="../Styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/jquery-ui.css" rel="stylesheet" type="text/css" />

</head>
<body>      
    <script type="text/javascript">
//        var Sort_SILMANUAL = new Array(2);
//        Sort_SILMANUAL[0] = [{ "bSortable": false }];
//        Sort_SILMANUAL[1] = [[1, "asc"]];


        $(document).ready(function () {
            NG.setNact(1, 'Uno', null);
            //NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            if (NG.Var[NG.Nact].oSets == null) {
                Ajax();
            } else {
                NG.repinta();
            }

        });

        function Ajax() {
            //var actionData= "{}";
            $.ajax({
                url: "SILMANUAL.aspx/Pinta_Grid",
                // data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: errorAjax
            });
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

            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true
                //"aaSorting": Sort_SILMANUAL[1],
                //"aoColumns": Sort_SILMANUAL[0]
            });

        };

        function pTablaI(tab) {
            //console.log("tab " + tab);
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';            
            htmlTab += '<th align="center" scope="col" style="width:99%;" class="sorting" title="Ordenar">Descripción</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";


//            htmlTab += '<tr>';
//            htmlTab += '<td class="sorts"><a href="../Documento/ManualSERUVAdmon16abr2013.pdf" target="_blank"> Manual módulo de administración</a></td>';
//            htmlTab += "</tr>";
//            htmlTab += '<tr>';
//            htmlTab += '<td class="sorts"><a href="../Documento/ManualSERUVRegistro16abr2013.pdf" target="_blank"> Manual módulo de registro</a></td>';
            //            htmlTab += "</tr>";
            htmlTab += '<tr>';
            htmlTab += '<td class="sorts"><a href="../Documento/GuiaBasicaDigitalizarDocsSERUV.pdf" target="_blank"> Guía básica para digitalizar documentos para el SERUV</td>';
            htmlTab += "</tr>";
            htmlTab += '<tr>';
            htmlTab += '<td class="sorts"><a href="../Documento/ManualSERUVASO07Agt2013.pdf" target="_blank"> Manual del SERUV para el Sujeto Obligado</td>';
            htmlTab += "</tr>";
            htmlTab += '<tr>';
            htmlTab += '<td class="sorts"><a href="../Documento/ManualSERUVSupervisionSO06Agt2013.pdf" target="_blank"> Manual del SERUV para el módulo Supervisión / Monitoreo del Sujeto Obligado</td>';
            htmlTab += "</tr>";
            htmlTab += '<tr>';
            htmlTab += '<td class="sorts"><a href="../Documento/ManualSERUVSupervisionSup06Agt2013.pdf" target="_blank"> Manual del SERUV para el módulo Supervisión / Monitoreo del Supervisor</td>';
            htmlTab += "</tr>";
            htmlTab += '<tr>';
            htmlTab += '<td class="sorts"><a href="../Documento/ManualSERUVCierreS07Agt2013.pdf" target="_blank"> Manual del SERUV para el módulo Cierre / Seguimiento</td>';
            htmlTab += "</tr>";               
            htmlTab += "</tbody>";
            return htmlTab;
        }

//        function Cambia(selec) {
//            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
//            NG.cambia(selec);
//            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
//        }

//        function ActualizarGrid() {
//            $("#grid").empty();
//            NG.Var[NG.Nact].oTable.fnDestroy();
//            Ajax();
//        }
    </script>

    <form id="frm_Usuarios" runat="server">
    <div id="agp_contenido">      
            <div id="agp_navegacion"> 
                <label class="titulo">Manuales</label>
            </div>        
        <div class="instrucciones">De clic en el nombre del archivo que desee consultar.</div>

        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>

    </div>
    </form>
</body>
</html>
