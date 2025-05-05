<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SASPARTICA" Codebehind="SASPARTICA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   <%-- <script src="../../scripts/session.js" type="text/javascript"></script>--%>
</head>
<body>
    <script type="text/javascript">
        var Sort_SASPARTICA = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SASPARTICA[0] = [{ "bSortable": true }, null, null, null, null];
        Sort_SASPARTICA[1] = [[0, "desc"]];
        var nIdProceso;
        var arrIdDepcia;
        var arrDepcia;
        var nIdUsuario = $("#hf_idUsuario").val();
        var arreglo1 = new Array();
        var arreglo2 = new Array();
        var arreglo3 = new Array();

        $(document).ready(function () {
                    
      $('.lbl_indicador').css('display', 'none');
          
             nIdProceso = NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].idProceso;           
             arrIdDepcia = NG.Var[2].arreglo[1];               
             arrDepcia = NG.Var[2].arreglo[2];           

            $("#hf_proceso").val(nIdProceso);
            $("#hf_arrDepcias").val(arrIdDepcia);

            var srespuesta = "";
      
            for (a_i = 0; a_i < arrDepcia.length; a_i++) {
                srespuesta += "<label>" + arrDepcia[a_i] + "</label><br/>";              
            }
            $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
            
            $("#divDepcias").append(srespuesta);
         
            //checkbox que indica supervisor CG
             $("#cbx_CG").click(function () {
                 if ($("#cbx_CG").is(':checked')) {
                     $("#cbx_CG").attr('checked', true);                   
                 }
                 else {
                     $("#cbx_CG").attr('checked', false);                    
                 }
             });
             //checkbox que indica supervisor SAF
             $("#cbx_SAF").click(function () {
                 if ($("#cbx_SAF").is(':checked')) {
                     $("#cbx_SAF").attr('checked', true);                    
                 }
                 else {
                     $("#cbx_SAF").attr('checked', false);                     
                 }
             });
             //checkbox que indica supervisor
             $("#cbx_SU").click(function () {
                 if ($("#cbx_SU").is(':checked')) {
                     $("#cbx_SU").attr('checked', true);
                 }
                 else {
                     $("#cbx_SUS").attr('checked', false);
                 }
             });

            Ajax(nIdProceso, arrIdDepcia, nIdUsuario);
            
        });

        //::::::::::::::::::::::::::::::::::::TABLA DE USUARIOS A CONFIGURAR COMO SUPERVISORES:::::::::::::::::::::::::::::::::::::::::::::::::::::


        function Ajax(nIdProceso, arrDepcias, nIdUsuario) {

            var actionData = "{'nIdProceso': " + nIdProceso +
                             ",'arridDepcias':' " + arrDepcias +
                             "','idUsuario':' " + nIdUsuario +
                              "'}";

            $.ajax(
                {
                    url: "Proceso/SASPARTICA.aspx/pObtieneDatos ",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        try {
                            arregloSeleccionadas = []; //vacio el arreglo
                            Pinta_Grid(eval('(' + reponse.d + ')'));                            
                            loading.close();
                            cadenaJson = eval('(' + reponse.d + ')');
                        } 
                        catch (err) {
                            txt = "Ha sucedido un error inesperado, inténtelo más tarde.\n\n";
                            txt += "descripción del error: " + err.message + "\n\n";
                            alert(txt);
                        }
                    },                  
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
        }
           
           //Pinta  grid de usuarios candidatos a configurar como supervisores
        function Pinta_Grid(scadena) {
            $('#grid').empty();
            mensaje = { "mensaje": "No existen participantes configurados en este proceso." }
            if (scadena == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }

            $('#grid').append(pTablaI(scadena));
            ClickCheck();
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            a_di = new o_dialog('DEPENDENCIAS');
            a_di.iniDial();
            NG.tr_hover();
            tooltip.iniToolD('45%');

            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "bDestroy": true,
                "aaSorting": Sort_SASPARTICA[1],
                "aoColumns": Sort_SASPARTICA[0]
            });
        };

        // selecciona una fila en el momento que es checada
        function Selecciona(actual) {
            $("tr").removeClass("row_selected");
            if ($('#' + actual + '').is(':checked')) {               
                $('#tr_' + actual).addClass('row_selected');
            }
            else {               
                $('#tr_' + actual).removeClass('row_selected');
            }

         
        }
        //Construye la tabla de usuarios a ser configurados como supervisores
        function pTablaI(tab) {            
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Usuario</th>';
            htmlTab += '<th align="center" scope="col" style="width:18%;" class="sorting" title="Ordenar">Dependencias supervisorSAF</th>';
            htmlTab += '<th align="center" scope="col" style="width:18%;" class="sorting" title="Ordenar">Dependencias supervisorCG</th>';
            htmlTab += '<th align="center" scope="col" style="width:18%;" class="sorting" title="Ordenar">Dependencias supervisor</th>';           
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
         
                //:::::::::::RECORRO ARREGLO DE SUPERVISOR SAF:::::::::::::::::::::::::::::
                var cCheck = false;
              
                    for (i = 0; i < tab[a_i].laDepSujObl.length; i++) {
                        for (j = 0; j < arrIdDepcia.length; j++) {
                            if (tab[a_i].laDepSujObl[i].nidProcPart == arrIdDepcia[j]) {
                                cCheck = true;
                            }
                        }
                    }



                    //:::::::::::RECORRO ARREGLO DE SUPERVISOR CG:::::::::::::::::::::::::::::

                for (i = 0; i < tab[a_i].laRegresaDatos2.length; i++) {
                    for (j = 0; j < arrIdDepcia.length; j++) {
                        if (tab[a_i].laRegresaDatos2[i].nidProcPart == arrIdDepcia[j]) {                           
                            cCheck = true;
                        }
                    }
                }

                //:::::::::::RECORRO ARREGLO DE SUPERVISOR:::::::::::::::::::::::::::::

                for (i = 0; i < tab[a_i].laCargaPart.length; i++) {
                    for (j = 0; j < arrIdDepcia.length; j++) {                        
                        if (tab[a_i].laCargaPart[i].nidProcPart == arrIdDepcia[j]) {
                            cCheck = true;
                        }
                    }

                }

                //******************CHECKED y UNCHECKED UN CHECKBOX EN EL CASO DE QUE CONTENGA UNA DEPENDENCIA SELECCIONADA******************************

                a_class = '';
                a_check = '';


                    if (cCheck == true) {
                        htmlTab += '<tr id="tr_' + a_i + '"' + a_class + '>';
                        htmlTab += '<td class="sorts Acen"><label class="lbl_indicador" visible="false"> </label><input id="' + a_i + '" value="' + tab[a_i].idUsuario + '" checked="checked" type="checkbox"' + a_check + 'onclick="Selecciona(\'' + a_i + '\')" /><label class="lbl_indicador" visible="false"> </label></td>';
                    }
                    else {
                        htmlTab += '<tr id="tr_' + a_i + '"' + a_class + '>';
                        htmlTab += '<td class="sorts Acen"><input id="' + a_i + '" value="' + tab[a_i].idUsuario + '" type="checkbox"' + a_check + 'onclick="Selecciona(\'' + a_i + '\')" /></td>';
                    }
                   
//                }
                //************************************************

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sNombre + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sNombre + '</div>';
                htmlTab += '</td>';


                //::::::::::::::::::::::::::::::::SUPERVISOR SAF:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                if (tab[a_i].laDepSujObl.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN DEPENDENCIAS</td>';

                } else {
                    if (tab[a_i].laDepSujObl.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laDepSujObl[0].sDDepcia.toUpperCase() + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laDepSujObl[0].sDDepcia.toUpperCase() + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER DEPENDENCIAS</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laDepSujObl.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laDepSujObl[a_j].sDDepcia.toUpperCase() + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
                //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                //:::::::::::::::::::::::::::::SUPERVISOR CG::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                if (tab[a_i].laRegresaDatos2.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN DEPENDENCIAS</td>';

                } else {
                    if (tab[a_i].laRegresaDatos2.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laRegresaDatos2[0].sDDepcia.toUpperCase() + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laRegresaDatos2[0].sDDepcia.toUpperCase() + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER DEPENDENCIAS</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laRegresaDatos2.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laRegresaDatos2[a_j].sDDepcia.toUpperCase() + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
                //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                //:::::::::::::::::::::::::::::SUPERVISOR::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                if (tab[a_i].laCargaPart.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN DEPENDENCIAS</td>';

                } else {
                    if (tab[a_i].laCargaPart.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laCargaPart[0].sDDepcia.toUpperCase() + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laCargaPart[0].sDDepcia.toUpperCase() + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER DEPENDENCIAS</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laCargaPart.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laCargaPart[a_j].sDDepcia.toUpperCase() + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
                //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

        //Configurar un supervisor en el momento que da clic en el checkbox  de un usuario
        function ClickCheck() {
            $('td >input[type=checkbox]').click(function () {
                var cIndAplica;
                var cIndCG;
                var cIndSAF;
                var cIndSU;
                var sMensaje = false;
                arreglo1 = NG.Var[NG.Nact].datos[$(this).attr("id")].laDepSujObl;
                arreglo2 = NG.Var[NG.Nact].datos[$(this).attr("id")].laRegresaDatos2;
                arreglo3 = NG.Var[NG.Nact].datos[$(this).attr("id")].laCargaPart;

                if ($(this).is(":checked")) {
                    cIndAplica = 'S';
                } 
                else {
                    cIndAplica = 'N';                  
                }

                if ($("#cbx_CG").is(":checked") || $("#cbx_SAF").is(":checked") || $("#cbx_SU").is(":checked")) {
                    if ($("#cbx_CG").is(":checked")) {
                        cIndCG = 'S';

                        for (i = 0; i < arreglo2.length; i++) {                           
                            for (j = 0; j < arrIdDepcia.length; j++) {
                                if (arreglo2[i].nidProcPart == arrIdDepcia[j]) {
                                    sMensaje = true;
                                }
                            }
                        }

                    } else {
                        cIndCG = 'N';
                    }

                    if ($("#cbx_SAF").is(":checked")) {
                        cIndSAF = 'S';

                        for (i = 0; i < arreglo1.length; i++) {                          
                            for (j = 0; j < arrIdDepcia.length; j++) {                               
                                if (arreglo1[i].nidProcPart == arrIdDepcia[j]) {
                                    sMensaje = true;
                                }
                            }
                        }
                    } else {
                        cIndSAF = 'N';
                    }

                    if ($("#cbx_SU").is(":checked")) {
                        cIndSU = 'S';

                        for (i = 0; i < arreglo3.length; i++) {                           
                            for (j = 0; j < arrIdDepcia.length; j++) {                                
                                if (arreglo3[i].nidProcPart == arrIdDepcia[j]) {
                                    sMensaje = true;
                                }
                            }
                        }
                    } else {
                        cIndSU = 'N';
                    }
                    
                    if ((cIndAplica == 'N' && sMensaje == true) || (cIndAplica == 'S' && sMensaje == false)) {
                        loading.ini();
                        var strParametros = "{'nIdProceso':'" + nIdProceso +
                                            "','sarrIdDepcia': '" + arrIdDepcia +
                                            "','sSuperSAF': '" + cIndSAF +
                                            "','sSuperCG': '" + cIndCG +
                                             "','sSuperSU': '" + cIndSU +
                                             "','cIndAplica': '" + cIndAplica +
                                            "','idUsuario': '" + $(this).attr("value") +
                                            "'}";
                        $.ajax({
                            url: "Proceso/SASPARTICA.aspx/pActualizaDepcia",
                            data: strParametros,
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {                               
                                var resp = eval('(' + reponse.d + ')');                               
                                if (resp == "1") {
                                    ActualizarGrid_Agrega(nIdProceso, arrIdDepcia, nIdUsuario);
                                }
                                else {
                                    loading.close();
                                    jAlert("La operación no pudo ser realizada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                }
                            },                         
                            error: function (result) {
                                loading.close();
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        });
                    }
                    else {
                        if ($("#cbx_CG").is(":checked")) {
                            if (arrDepcia.length > 1) {
                                jAlert("El usuario no se encuentra como Supervisor CG en estas dependencias", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                            else {
                                jAlert("El usuario no se encuentra como Supervisor CG en esta dependencia", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        }
                        else{
                            if ($("#cbx_SU").is(":checked")) {
                                if (arrDepcia.length > 1) {
                                    jAlert("El usuario no se encuentra como Supervisor en estas dependencias", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                                else {
                                    jAlert("El usuario no se encuentra como Supervisor en esta dependencia", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                            }                        
                            else {
                                if (arrDepcia.length > 1) {
                                    jAlert("El usuario no se encuentra como Supervisor SAF en estas dependencias", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                                else {
                                    jAlert("El usuario no se encuentra como Supervisor SAF en esta dependencia", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                            }
                        }
                        if ($(this).is(":checked")) {
                            $(this).attr('checked', false);                           
                        } else {
                            $(this).attr('checked', true);
                            $('#tr_' + $(this).attr("id")).addClass('row_selected');
                        }
                    }
                }
                else {
                    jAlert("Favor de seleccionar el tipo de Supervisor", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    if ($(this).is(":checked")) {
                        $(this).attr('checked', false);
                        $('#tr_' + $(this).attr("id")).removeClass('row_selected');
                    } else {
                        $(this).attr('checked', true);                        
                    }
                }
            });

        }

        //Actualiza el grid que muestra los usuarios despues de haber configurado un usuario como supervisor
        function ActualizarGrid_Agrega(nIdProceso, arrDepcias, nIdUsuario) {         
            $('#grid').empty()           
            NG.Var[NG.Nact].oTable.fnDestroy();
            NG.Var[NG.Nact].datoSel = null;
            NG.Var[NG.Nact].datos = null;
            Ajax(nIdProceso, arrDepcias, nIdUsuario);

        }

        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //Redirecciona a la página anterior
        function fCancelar() {            
            urls(5, "Proceso/SASPARTIC.aspx");
        }




    </script>
    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion"> 
            <label class="titulo"> Supervisor/ Dependencias</label>
         
        </div>
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>
        <br />

        <div class="instrucciones">Seleccione un participante para realizar las acciones correspondientes:</div>
                             
        <h2>Proceso entrega - recepción: </h2> <label id="lblProcER"></label>  <br />   
        <h2>Dependencias: </h2> 
        <div id="divDepcias" style="width:99%; max-height:90px; overflow:auto;">
            
        </div>       
         <br />   
          <h2>Tipo de Supervisor:</h2>
         <br />    
         <label>SAF</label><input  id="cbx_SAF" type="radio" value="9" name="check"/>  
         <label>CG</label><input  id="cbx_CG" type="radio" value="8" name="check"/>    
         <label>Supervisor</label><input  id="cbx_SU" type="radio" value="8" name="check"/>        
        <br />
                    
        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
            </table>
        </div>  
        <br />

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div>    
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server"/>       
            <asp:HiddenField ID="hf_proceso" runat="server"/>
            <asp:HiddenField ID="hf_arrDepcias" runat="server"/>
        </div>
    </div> 
   
    </form>
</body>
</html>

