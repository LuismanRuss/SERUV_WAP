<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_SAMPERFIL" Codebehind="SAMPERFIL.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>

</head>
<body>      
    <script type="text/javascript">
        //Bloque para el ordenamiento de columnas en el grid
        var Sort_SAMPERFIL = new Array(2);
        Sort_SAMPERFIL[0] = [{ "bSortable": false }, null];
        Sort_SAMPERFIL[1] = [[1, "asc"]];

        //Bloque para condicionar la visualización de los botones dependendiendo si se selecciona o no un elemento en el grid
        BotonesPerfil = function (selec) {
            if (selec > 0) { //Seleccionado
                $("#AccReportes2").hide();
                $("#AccReportes").show();
            } else { //No Seleccionado
                $("#AccReportes2").show();
                $("#AccReportes").hide();
            }
        }

        $(document).ready(function () {
            NG.setNact(1, 'Uno', BotonesPerfil);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            if (NG.Var[NG.Nact].oSets == null) {
                Ajax();
            } else {
                NG.repinta();
            }

        });

        //Función principal para desplegar los perfiles existentes
         function Ajax() {
            
            $.ajax({
                url: "Perfil/SAMPERFIL.aspx/Pinta_Grid",
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


        //Función para pintar la tabla
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
                "bLengthChange": true,
                "aaSorting": Sort_SAMPERFIL[1],
                "aoColumns": Sort_SAMPERFIL[0]
            });
            
        };


        //Definición de la tabla con los elementos a desplegar
        function pTablaI(tab) {
            
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:95%;" class="sorting" title="Ordenar">Descripción</th>';
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
                htmlTab += '<td class="sorts">' + tab[a_i].strsDCPerfil.toUpperCase() + '</td>';
            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }

        //Función que controla si se hace cambio entre los radio button seleccionados
        function Cambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        }


        //Función para vuelve a mostrar los datos de la tabla una vez realizada una acción
        function ActualizarGrid() {
            $("#grid").empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            Ajax();
        }

        //Lllamada a la página de despliegue de usuarios que cumplen con el perfil seleccionado
        function Reporte() {            
            urls(2, "Perfil/SACPERFIL.aspx");
        }

    </script>
    <form id="frm_Usuarios" runat="server">
    <div id="agp_contenido">      
            <div id="agp_navegacion"> 
                <label class="titulo">Perfiles</label>
                <div class="a_acciones">                 
                    <a id="AccReportes" title="Ver Usuarios" href="javascript:Reporte();" class="accAct iOculto">Ver Usuarios</a>
                    <a id="AccReportes2" title="Ver Usuarios" class="accIna">Ver Usuarios</a>
                </div>
            </div>        
        <div class="instrucciones">Seleccione un perfil para realizar la acción correspondiente.</div>

        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>

    </div>
    </form>
</body>
</html>
