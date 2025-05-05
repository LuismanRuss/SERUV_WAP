<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA12" Codebehind="SCAGEACTA12.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Sujeto.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
     <link href="../styles/Acta.css" rel="stylesheet" type="text/css" />
 
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script> 
    <script src="../scripts/DataTables.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
    <script type="text/javascript">
        var Sort_SCAGEACTA7 = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SCAGEACTA7[0] = [{ "bSortable": false }, null, null, null];
        Sort_SCAGEACTA7[1] = [[1, "asc"]];


        $(document).ready(function () {
            $("#txtFechaAutorizacion").mask("99-99-9999");
            $('#dFNombram').mask("99-99-9999");
            var idParticipante;
            //   NG.setNact(2, 'Dos', null);

            idAnexo = $("#hf_IdApartado", parent.document).val();
            sCApartado = $("#hf_cApartado", parent.document).val();
            sDApartado = $("#hf_dApartado", parent.document).val();
            //  alert(sDApartado);
            $(".titulo2").text(sCApartado + ' ' + sDApartado);
            //console.log(NG.Var[NG.Nact].datoSel);
            //            if (NG.Var[NG.Nact].datoSel == null) {
            $('#grid').empty();
            fGetApartados();

            //            } else {
            //                //fGetApartados();
            //                NG.repinta();
            //            }
        });


        function fn_accordion(a_num) {
            aa = '#sec' + a_num;
            bb = '#Tit_' + a_num;
            cc = "#d_l" + a_num;
            if ($(aa).is(':visible')) {
                $(aa).hide();
                $(bb).html('+').attr('title', 'Expandir');
                $(cc).attr('title', 'Expandir');
            } else {
                $(aa).show();
                $(bb).html('-').attr('title', 'Colapsar');
                $(cc).attr('title', 'Colapsar');
            }
        }

        function fGetApartados() {
            var strDatos = "{" +
                                "\"strAccion\": \"ACTA_APARTADOS\" " +
                                "}";

            objApartados = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objApartados: objApartados });
            //console.log(actionData);

            $.ajax(
                {
                    url: "SCAGEACTA7.aspx/Acta_Apartados",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(eval('(' + reponse.d + ')'));
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        /***********     Fin Funcion Ajax Obtener Guias    ***********/


        /***********     Funcion Pintar Grid Guias     ***********/

        function Pinta_Grid(strCadena) {
            //console.log(strCadena);
            $('#grid').empty();
            mensaje = { "mensaje": "No existen apartados configurados." }
            if (strCadena.liApartados == null) {
                //alert("if");
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            else {
                //alert("else");
                $('#grid').append(pTablaI(strCadena.liApartados));
            }

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SCAGEACTA7[1],
                "aoColumns": Sort_SCAGEACTA7[0]
            });
        }


        /***********     Fin Funcion Pintar Grid Guias    ***********/

        function pTablaI(tab) {
            //console.log("tab " + tab);
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting Acen" title="Ordenar">Clave</th>';
            htmlTab += '<th scope="col" style="width:80%;" class="sorting Acen" title="Ordenar">Nombre</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="no_sort Acen" title="Ordenar">Cantidad</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="no_sort Acen" title="Ordenar">Fojas</th>';
           

            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                htmlTab += '<tr>';

                htmlTab += '<td class="sorts">' + tab[a_i].strApartado + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].strDescApartado + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].strApartado + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].strApartado + '</td>';
               
            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }



        function Bloque1() {
            urls(6, "SCAGEACTA.aspx");
        }

        function Bloque2() {
            urls(6, "SCAGEACTA2.aspx");
        }
        function Bloque4() {
            urls(6, "SCAGEACTA4.aspx");
        }
        function Bloque5() {
            urls(6, "SCAGEACTA5.aspx");
        }
        function Cancelar() {
            window.parent.cancelar();
        }
    </script>
</head>
<body>
     <form id="SCAGEACTA3" runat="server">
    <div id="agp_contenido">               
        <h2 class="titulo2">VIII. Situación de inmuebles</h2>
 <br /> 
   
         <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
        </div>    
         <div class="a_botones">
            <a id="EnviarActivo" href="javascript:Enviar();" class="btnAct" title="Botón de enviar">Enviar</a>        
            <a id="CancelarActivo" href="javascript:Cancelar();" class="btnIna"  title="Botón de cancelar">Cancelar</a>
  
        </div>      
    </div>
    </form>
</body>
</html>
