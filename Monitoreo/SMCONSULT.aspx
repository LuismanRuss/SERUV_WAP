<%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCCONSULT" Codebehind="SMCONSULT.aspx.cs" %>

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
        var settings;

        /*Estructura para listar los archivos en el Grid*/
        var Sort_SCCONSULT4 = new Array(2);
        Sort_SCCONSULT4[0] = [{ "bSortable": false }, null, null, null, null, null, null, null, null, null];
        Sort_SCCONSULT4[1] = [[1, "asc"]];

        /*Variables para determinar el navegador que utiliza el cliente*/
        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
        function navegador() {
            if (safari)
                $('#navegador').val("safari");
            if (chrome)
                $('#navegador').val("chrome");
            if ($.browser.msie)
                $('#navegador').val("IE");
            if (mozilla)
                $('#navegador').val("mozilla");
        };

        /*Rutina que se lanza cuando se lanza al cargar la página del lado del cliente*/
        $(document).ready(function () {

            NG.setNact(1, 'Uno'); // Se declara el nivel actual
            NG.Var[NG.Nact - 1].datoSel = eval('(' + $("#hf_NG", parent.document).val() + ')'); // Se recupera los datos del anexo, así como el listado de archivos cargados en el
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                $("#hf_NG", parent.document).val(""); // Se borra el hidden del nivel anterior
                fPinta_Grid(NG.Var[NG.Nact - 1].datoSel.lstArchivos); // Se listan los archivos cargados en el anexo
            }
            else {
                fPinta_Grid(null);
            }
        });

        /*Función que se lanza desde la página padre que repinta el grid*/
        function fRepintaGrid(objAnexo) {
            NG.Var[NG.Nact - 1].datoSel = (objAnexo != null ? objAnexo : null);
            NG.Var[NG.Nact - 1].datoSel = objAnexo;
            
            fPinta_Grid(NG.Var[NG.Nact - 1].datoSel.lstArchivos);
        }

        /*Función general que pinta el Grid*/
        function fPinta_Grid(cadena) {
                        
            $('#grid').empty();
            mensaje = { "mensaje": "No se han cargado archivos relacionados al anexo." }
            if (cadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            
            $('#grid').append(pTablaI(cadena));
       

            a_di = new o_dialog('Ver Observaciones');
            a_di.iniDial();

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna charIndEntrega
            NG.Var[NG.Nact - 1].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "bDestroy": true,
                "aaSorting": Sort_SCCONSULT4[1],
                "aoColumns": Sort_SCCONSULT4[0]
            });
        
            settings = NG.Var[NG.Nact - 1].oTable.fnSettings();
        };

        /*Función que regresa una cadena donde esta pintado el grid*/
        function pTablaI(tab) {
            if (tab != null) {
                htmlTab = '';
                htmlTab += '<thead><tr>';
                htmlTab += '<th scope="col" style="width:39%;" class="sorting" title="Ordenar">Nombre archivo</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Tamaño</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Fojas</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Fecha de corte</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Fecha de carga</th>';
                htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Usuario</th>';
                htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Tipo Información</th>';
                htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Fecha de Acuerdo</th>';
                htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Num. Acuerdo</th>';
                htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Observaciones</th>';
                htmlTab += "<tbody>";
                
                for (a_i = 0; a_i < tab.length; a_i++) {
                    htmlTab += '<tr>';
                    htmlTab += '<td class="sorts"><a title="Descarga Archivo" href="../General/SGDDESCAR.aspx?guid=' + tab[a_i].gidFormato + '&strOpcion=ARCHIVO">' + tab[a_i].strNomArchivo + '</a></td>';
                    htmlTab += '<td class="sorts Acen">' + (tab[a_i].nTamanio / 1024).toFixed(1) + ' KB ' + '(' + tab[a_i].nTamanio + ' bytes)' + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].nFojas + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFCorte + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFAlta + '</td>';
                    htmlTab += '</td>'; // Observaciones del archivo strObserva
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].strNomUsuario + '</td>'; // Nombre del usuario que lo cargo
                    htmlTab += '<td class="sorts Acen">' + (tab[a_i].chrTipoInfo == 'C' ? 'CONFIDENCIAL' : tab[a_i].chrTipoInfo == 'P' ? 'PÚBLICA' : 'RESERVADA') + '</td>';
                    htmlTab += '<td class="sorts Acen">' + (tab[a_i].dteFAcuerdo == '' ? 'NO DEFINIDO' : tab[a_i].dteFAcuerdo) + '</td>';
                    htmlTab += '<td class="sorts Acen">' + (tab[a_i].strAcuerdo == '' ? 'NO DEFINIDO' : tab[a_i].strAcuerdo) + '</td>';
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">Ver' + (tab[a_i].chrTipoInfo == 'C' ? ' Fundamento Legal' : tab[a_i].chrTipoInfo == 'P' ? ' Observaciones' : 'Observaciones') + '</a></div>';
                    htmlTab += '<div class="dialoG oculto">' + tab[a_i].strObserva + '</div>';
                }
                htmlTab += "</tr>";
                htmlTab += "</tbody>";
            }

            return htmlTab;
        }

        /*Función que cierra la ventana modal*/
        function fCerrar() {
            parent.window.fCerrarDialog();
        }
    </script>
    <form id="SCCONSULT" runat="server">
        <div id="fixme"></div>
        <div id="agp_contenido">
            <%--<div class="instrucciones">¿Instrucciones?</div>--%>
            <br />
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div> 

            <div class="a_botones_modal">
                <a title="Botón Cerrar" id="lnk_cerrar" href="javascript:fCerrar();" class="btnAct">Cerrar</a>        
            </div>
        
    <%--            <a id="hrf_cargar" href="J avascript:fCargar();">Cargar</a>  
                <a id="hrf_cerrar" href="J avascript:fCerrar();">Cerrar</a> --%> 
        
            <div id="div_ocultos">
                <input id="hf_anexo" type="hidden" />    
            </div>
        </div>
    </form>
</body>
</html>
