<%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCCONSULT" Codebehind="SCCONSULT.aspx.cs" %>

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
    
    <%--<script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>    --%>
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    
</head>
<body>
    <script type="text/javascript">

        var settings; // Configuración del grid donde se muestran los archivos cargados a un anexo

        // Estructura que se utiliza cuando se está cargando archivos (el anexo está pendiente)
        var Sort_SCCONSULT5 = new Array(2);
        Sort_SCCONSULT5[0] = [{ "bSortable": false }, null, null, null, null, null, null, null, null, null, null, null];
        Sort_SCCONSULT5[1] = [[3, "desc"]];

        // Estructura que se utiliza cuando solo se muestran los archivos (el anexo está integrado) 
        var Sort_SCCONSULT4 = new Array(2);
        Sort_SCCONSULT4[0] = [{ "bSortable": false }, null, null, null, null, null, null, null, null, null];
        Sort_SCCONSULT4[1] = [[3, "desc"]];

        // Variables que se utilizan para determinar el navegador
        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);

        // Función que determina el navegador
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

        // Se lanza al principio de la carga de la página del lado del cliente
        $(document).ready(function () {
            NG.setNact(1, 'Uno'); // Como es una ventana modal, se declara nuevamente el primer nivel de objetos
            loading.ini();
            NG.Var[NG.Nact - 1].datoSel = eval('(' + $("#hf_NG", parent.document).val() + ')'); // Se recupera el anexo que se esta consultando, así como el listado de archivos cargados
            
            if (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'I') { // Se pregunta si el anexo esta integrado, si lo está, no se permite seguir cargando archivos, si no se permite
                $("#lnk_cangar").hide();
            }
            if (NG.Var[NG.Nact - 1].datoSel != null) {
                $("#hf_NG", parent.document).val(""); // Se limpía el hidden donde se "guardo" el objeto 
                fPinta_Grid(NG.Var[NG.Nact - 1].datoSel.lstArchivos); // Se pinta el grid donde se listan los archivos cargados al anexo
                loading.close();
            }
            else {
                fPinta_Grid(null); // Se pinta un vacio
                loading.close();
            }
        });

        /*Función que se lanza después de cargar una archivo*/
        function fRepintaGrid(objAnexo) {
            
            NG.Var[NG.Nact - 1].datoSel = (objAnexo != null ? objAnexo : null);
            NG.Var[NG.Nact - 1].datoSel = objAnexo;
            
            fPinta_Grid(NG.Var[NG.Nact - 1].datoSel.lstArchivos);
        }

        /*Función que pinta el Grid donde se listan los archivos*/
        function fPinta_Grid(cadena) {
                     
            $('#grid').empty();
            mensaje = { "mensaje": "No se han cargado archivos relacionados al anexo." }
            if (cadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                $("#div_instruccione").hide();
                return false;
            }
            
            $('#grid').append(pTablaI(cadena));
            $("#div_instruccione").show();

            a_di = new o_dialog('Ver Observaciones');
            a_di.iniDial();

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna charIndEntrega
            NG.Var[NG.Nact - 1].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "bDestroy": true,
                "aaSorting": (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'P' ? Sort_SCCONSULT5[1] : Sort_SCCONSULT4[1]), 
                "aoColumns": (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'P' ? Sort_SCCONSULT5[0] : Sort_SCCONSULT4[0])
            });
            //settings = NG.Var[NG.Nact - 1].oTable.fnSettings();
            
        };

        /*Función que elimina un objeto JSON (archivo), del listado de archivos que están cargados en una anexo*/
        function fEliminaArchivoJSON(objJSON) {
            for (a_i = 0; a_i < NG.Var[NG.Nact - 1].datoSel.lstArchivos.length; a_i++) {
                if (objJSON.gidFormato == NG.Var[NG.Nact - 1].datoSel.lstArchivos[a_i].gidFormato) {
                    //k = i;
                    NG.Var[NG.Nact - 1].datoSel.lstArchivos.splice(a_i, 1);
                    break;
                }
            }
            parent.window.fActualizaAnexo(objJSON);
        }

        /*Función que lanza la rutina para modificar el detalle de un archivo cargado a una ER*/
        function fModificarArchivo(sguid, nArchivo) {
            NG.Var[NG.Nact - 1].datoSel.strOpcion = 'MODIFICAR'
            NG.Var[NG.Nact - 1].datoSel.intnOrden = nArchivo;
            parent.window.fCargarArchivo(NG.Var[NG.Nact - 1].datoSel);
        }

        /*Función que elimina/deshabilita en la BD un archivo que estaba asociado a una ER*/
        function fEliminaArchivo(sguid, nArchivo) {
            $.alerts.dialogClass = "infoConfirm";
            jConfirm('¿Desea eliminar el archivo?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    objArchivo = NG.Var[NG.Nact - 1].datoSel.lstArchivos[nArchivo];
                    if (objArchivo != null) {
                        objArchivo.strOpcion = "DOCARCHIVO";
                        objArchivo.strAccion = "DISABLE";
                        objArchivo.idPartAplic = NG.Var[NG.Nact - 1].datoSel.idPartAplic
                        objArchivo.gidFormato = sguid;
                        actionData = frms.jsonTOstring({ objArchivo: objArchivo });
                        $.ajax(
                            {
                                url: "SCACARINF.aspx/pDisableArchivo",
                                data: actionData,
                                dataType: "json",
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                success: function (reponse) {
                                    objArchivo = eval('(' + reponse.d + ')');
                                    if (objArchivo != null) {
                                        if (Number(objArchivo.strResp) == 1) {
                                           $.alerts.dialogClass = "correctoAlert";
                                            jAlert('El archivo fué eliminado satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                                fEliminaArchivoJSON(objArchivo);
                                                NG.Var[NG.Nact - 1].datoSel.intNumArchivos--;
                                                if (NG.Var[NG.Nact - 1].oTable != null) {
                                                    NG.Var[NG.Nact - 1].oTable.fnDestroy();
                                                }
                                                fPinta_Grid((NG.Var[NG.Nact - 1].datoSel.lstArchivos.length == 0 ? null : NG.Var[NG.Nact - 1].datoSel.lstArchivos));
                                            });
                                        }
                                        else if (Number(objArchivo.strResp) == 2) {
                                           $.alerts.dialogClass = "incompletoAlert";
                                            jAlert('El anexo ya fué integrado por otro usuario, no fué posible realizar la operación.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {
                                            });
                                        }
                                        else {
                                            $.alerts.dialogClass = "errorAlert";
                                            jAlert('Ha sucedido un error inesperado, inténtelo más tarde.', 'SISTEMA DE ENTREGA - RECEPCIÓN', function () {//Error en la operación, intente más tarde
                                            });
                                        }
                                    }
                                },
                                error: errorAjax
                            }
                        );
                    }
                }
            });
        }

        /*Función que contruye la tabla cuando hay datos (archivos)*/
        function pTablaI(tab) {
            //console.log(tab);
            //NG.Var[NG.Nact].datos = tab;
            if (tab != null) {
                htmlTab = '';
                htmlTab += '<thead><tr>';
                htmlTab += '<th scope="col" style="width:16%;" class="sorting" title="Ordenar">Nombre archivo</th>';
                htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Num. Fojas</th>';
                htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Tamaño</th>';
                htmlTab += '<th scope="col" style="width:12%;" class="sorting" title="Ordenar">Fecha de corte</th>';
                htmlTab += '<th scope="col" style="width:12%;" class="sorting" title="Ordenar">Fecha de carga</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Usuario</th>';
                htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Tipo Información</th>';
                htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Fecha de Acuerdo</th>';
                htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Num. Acuerdo</th>';
                htmlTab += '<th scope="col" style="width:4%;" class="sorting" title="Ordenar"></th>';
                htmlTab += (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'P' ? '<th scope="col" style="width:5%;" class="sorting" title="Ordenar"></th>' : '');
                htmlTab += (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'P' ? '<th scope="col" style="width:5%;" class="sorting" title="Ordenar"></th>' : '');
                htmlTab += '</tr></thead>';
                htmlTab += "<tbody>";
                
                for (a_i = 0; a_i < tab.length; a_i++) {
                    htmlTab += '<tr>';
                    htmlTab += '<td class="sorts"><a title="Descarga Archivo" href="../General/SGDDESCAR.aspx?guid=' + tab[a_i].gidFormato + '&strOpcion=ARCHIVO">' + tab[a_i].strNomArchivo + '</a></td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].nFojas + '</td>';
                    htmlTab += '<td class="sorts Acen">' + (tab[a_i].nTamanio / 1024).toFixed(1) + ' KB ' + '(' + tab[a_i].nTamanio + ' bytes)' + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFCorte + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].dteFAlta + '</td>';
                    htmlTab += '<td class="sorts Acen">' + tab[a_i].strNomUsuario + '</td>'; // Nombre del usuario que lo cargo
                    htmlTab += '<td class="sorts Acen">' + (tab[a_i].chrTipoInfo == 'C' ? 'CONFIDENCIAL' : tab[a_i].chrTipoInfo == 'P' ? 'PÚBLICA' : 'RESERVADA') + '</td>';
                    htmlTab += '<td class="sorts Acen">' + ((tab[a_i].chrTipoInfo == 'C' || tab[a_i].chrTipoInfo == 'P') ? 'NO DEFINIDO' : tab[a_i].dteFAcuerdo) + '</td>'; 
                    htmlTab += '<td class="sorts Acen">' + ((tab[a_i].chrTipoInfo == 'C' || tab[a_i].chrTipoInfo == 'P') ? 'NO DEFINIDO' : tab[a_i].strAcuerdo) + '</td>'; 
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD"><a title="'+ (tab[a_i].chrTipoInfo == 'C' ? ' Fundamento Legal' : tab[a_i].chrTipoInfo == 'P' ? ' Observaciones' : ' Observaciones') +'" class="ackDialog" href="#fixme">' + (tab[a_i].chrTipoInfo == 'C' ? ' Fundamento Legal' : tab[a_i].chrTipoInfo == 'P' ? ' Observaciones' : ' Observaciones') + '</a></div>';
                    htmlTab += '<div class="dialoG oculto">' + tab[a_i].strObserva + '</div>';
                    htmlTab += '</td>'; // Observaciones del archivo strObserva
                    htmlTab += (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'P' ? '<td class="sorts Acen"><a id="hrf_' + a_i + '" href="Javascript:fEliminaArchivo(\'' + tab[a_i].gidFormato + '\',\'' + a_i + '\');"><img src="../images/ico-delete.png" /></td>' : '');
                    htmlTab += (NG.Var[NG.Nact - 1].datoSel.charIndEntrega == 'P' ? '<td class="sorts Acen"><a id="hrf_' + a_i + '" href="Javascript:fModificarArchivo(\'' + tab[a_i].gidFormato + '\',\'' + a_i + '\');"><img src="../images/consultar-archivo.png" /></td>' : '');
                }
                htmlTab += "</tr>";
                htmlTab += "</tbody>";
            }
            return htmlTab;
        }

        /*Función que lanza la rutina para cargar un archivo al anexo*/
        function fCargar() {
            NG.Var[NG.Nact - 1].datoSel.strOpcion = 'CARGA';
            parent.window.fCargarArchivo(NG.Var[NG.Nact - 1].datoSel);
        };

        /*Cierra el dialog*/
        function fCerrar() {
            parent.window.fCerrarDialog();
        }
    </script>
    <form id="SCCONSULT" runat="server">
        <div id="fixme"></div>
        <div id="agp_contenido">
            <div id="div_instruccione" class="instrucciones">De clic sobre a información que desea visualizar o eliminar:</div>
            <br />
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div> 

            <div class="a_botones_modal">
                <a title="Botón Cargar" id="lnk_cangar" href="javascript:fCargar();" class="btnAct">Cargar</a> 
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
