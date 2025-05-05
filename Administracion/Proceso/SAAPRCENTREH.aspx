<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPRCENTREH" Codebehind="SAAPRCENTREH.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAAPRCENTREH = new Array(2);
        Sort_SAAPRCENTREH[0] = [{ "bSortable": false }, null, null, null, null, null, null];
        Sort_SAAPRCENTREH[1] = [[0, "asc"]];

        function fAjax() {//función que me arroja los procesos-ER que ya han sido cerrados
            $.ajax({
                    url: "Proceso/SAAPRCENTREH.aspx/pPinta_Grid",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    error: errorAjax
                });
        }

        $(document).ready(function () {
            loading.close();
            if (NG.Nact == 2) {
                NG.setNact(1, 'Uno', BotonesProcesoER);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                NG.repinta();
            } else {
                NG.setNact(1, 'Uno', BotonesProcesoER);
                NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
                fAjax();
            }
        });

        function Pinta_Grid(cadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen procesos cerrados." }
            if (cadena == null || cadena == "") {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                $('#divInstrucciones').hide();
                return false;
            }
            $('#grid').append(pTablaI(cadena));//se manda a llamar la función que pinta el grid

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAAPRCENTREH[1],
                "aoColumns": Sort_SAAPRCENTREH[0]
            });
            loading.close();
        };

        function pTablaI(tab) {//función que pinta el grid
            NG.Var[NG.Nact].datos = tab;//asigno los datos que me trae el JSON de la consulta al elemento datos del objeto NG
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Código</th>';
            htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
            htmlTab += '<th scope="col" style="width:8%;" class="sorting" title="Ordenar">Código guía</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Tipo</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Fecha de cierre</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                }

                htmlTab += '<td class="sorts Acen">' + tab[a_i].sProceso + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].dependencia + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].puesto + '</td>';

                htmlTab += '<td class="sorts Acen">' + tab[a_i].sGuiaER + '</td>';
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sDTipoPeri + '</td>';
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sFechaCierre + '</td>';
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function fCambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        };

        function fCancelar() {//función que me regresa a la forma principal de procesos-ER
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }

        function fParticipantes() {//función que me manda a la forma de participantes
            urls(5, "Proceso/SAAPARTIHIS.aspx");
        }
    </script>

    <form id="SAAPRCENTREH" runat="server">
         <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Histórico Procesos ER</label>
                <div class="a_acciones">
                    <a id="AccParticipante" title="Configuración de Dependencias / entidades" href="javascript:fParticipantes();" class="accAct iOculto">Dependencias / entidades</a>
                    <a id="AccParticipante2" title="Configuración de Dependencias / entidades" class="accIna">Dependencias / entidades</a>
                </div>
            </div>
             
          <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>
        <br />                        
            <div id="divInstrucciones" class="instrucciones">Seleccione un proceso para realizar las acciones correspondientes.</div>
             
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div>  
               <br />

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>  

             <div id="div_ocultos">
            </div>
        </div>   
    </form>
</body>
</html>
