<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Usuario_SAMDEPTOS" Codebehind="SAMDEPTOS.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
        <link href="../Styles/Usuario.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script type="text/javascript">
        var Sort_SAAPMOTIV = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SAAPMOTIV[0] = [{ "bSortable": false }, null];
        Sort_SAAPMOTIV[1] = [[1, "asc"]];

        /***********     Botones de Acción     ***********/

        BotonesMotivosER = function (selec) {
            if (selec > 0) //Seleccionado 
            {
                $("#AccAgregar2, #AccModificar").show();
                $("#AccAgregar, #AccModificar2").hide();
            }
            else //No Seleccionado
            {
                $("#AccAgregar, #AccModificar2").show();
                $("#AccAgregar2, #AccModificar").hide();
            }
        }

        $(document).ready(function () {
            NG.setNact(2, 'Dos', BotonesMotivosER);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            if (NG.Var[NG.Nact].datoSel == null) {
                $('#grid').empty();
                fGetDepartamentos();
            } else {
                fGetDepartamentos();
                //NG.repinta();
            }
        });

        //Función Ajax que obtiene la Lista de Motivos de la Base de Datos
        function fGetDepartamentos() {
            var strDatos = "{}";

            $.ajax({
                url: "Usuario/SAMDEPTOS.aspx/fObtieneDepartamentos",
                data: strDatos,
                dataType: "json",
                //async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    //console.log(reponse.d);
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: errorAjax
            });
        }

        //Función para asignar las Propiedades de el DataTable de Motivos
        function Pinta_Grid(strCadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen departamentos configurados." }
            if (strCadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                $('.instrucciones').css('display', 'none');
                return false;
            }
            $('#grid').append(pTablaI(strCadena));

            NG.tr_hover();
            tooltip.iniToolD('25%');
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                                        "sPaginationType": "full_numbers",
                                        "bLengthChange": true,
                                        "aaSorting": Sort_SAAPMOTIV[1],
                                        "aoColumns": Sort_SAAPMOTIV[0]
                                    });
        }
        /***********     Fin Función Pintar Grid Guias    ***********/


        //Función para Pintar la Tabla de Motivos
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort"  scope="col" style="width:4%;"></th>';
            htmlTab += '<th  scope="col" style="width:75%;" class="sorting" title="Ordenar">Descripción</th>';

            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            //Ciclo de Control para Checkbox
            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i && NG.Var[NG.Nact].datoSel != null) {
                    //alert("igual");
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
                    intSeleccionado = tab[a_i].nDepcia;
                } else {
                    //alert("distinto");
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                    //intSeleccionado = a_i;
                }

                htmlTab += '<td class="sorts">' + tab[a_i].sDDepcia + '</td>';
                htmlTab += '</td>';
                htmlTab += "</tr>";
            }
            htmlTab += "</tbody>";
            return htmlTab;
        }

        // Función que cambia los valores del dato seleccionado en el grid.
        function fCambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        }   

        //Función para ir a la forma de alta de departamentos
        function fDepartamento() {
            urls(1, "Usuario/SACDEPTOS.aspx");
        }

        //Función para ir a la forma Principal de Usuarios
        function fRegresar() {
            urls(1, "Usuario/SAMUSUARI.aspx");
        }
    </script>

    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Departamentos</label>
            <div class="a_acciones">
                    <a id="AccAgregar" title="Agregar" href="Javascript:fDepartamento();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                    <a id="AccModificar" title="Modificar" href="Javascript:fDepartamento();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                    <%--<a id="AccReporte" title="Reporte" href="Javascript:fReporte();" class="accAct">Reporte</a>
                    <a id="AccReporte2" title="Reporte" class="accIna iOculto">Reporte</a>--%>

                    <%--<a id="AccEliminar" title="Eliminar" href="javascript:pEliminar_Motivos();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>--%>
            </div>
        </div>

        <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

            <div class="instrucciones">Seleccione un departamento para realizar la acción correspondiente.</div>
        
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
            </div>

            <br />
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 
    </div>
    </form>
</body>
</html>
