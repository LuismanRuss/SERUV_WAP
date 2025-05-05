<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Sujeto_SCSNOTISO" Codebehind="SCSNOTISO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
     <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />  
    <script src="../scripts/DataTables.js" type="text/javascript"></script>        
    <script src="../scripts/Libreria.js" type="text/javascript"></script> 
</head>
<body>
     <script type="text/javascript">
         var Sort_SCSNOTISO = new Array(2);
         Sort_SCSNOTISO[0] = [null, null, { "bSortable": false }];
         Sort_SCSNOTISO[1] = [[1, "asc"]];

         var intApartado;
      
         var indSujetoOb; // VALOR S/N
         var indEnlaceOp; // VALOR S/N
         var intProceso; //id del proceso que corresponde a la persona que se loguea
         var intIdSujetoOb; //id del sujeto obligado
         var strNombreSujetoOb; //nombre del sujeto obligado independiente mente de la persona que se logue
         var strDatosUsuarioLOG = null;
         var intIdPerfil;
         var strDatosDepcia = null;



         $(document).ready(function () {          
             NG.setNact(1);            
             $('#IdParticipante').val(0);
             $('#hf_intProceso').val(0);
             $('#hf_intDependencia').val(0);
             $("#ExcluirActivo").hide();
             $("#ExcluirInactivo").show();
           
             ListTipoproc($('#hf_idUsuario').val());

             if (NG.Var[NG.Nact].oSets == null) {
             } 
             else {
                 NG.repinta();
             }


             $("#slc_PER").change(function () {
                 NG.Var[NG.Nact].oTable.fnDestroy();
                 NG.Var[NG.Nact].datoSel = null;
                 NG.Var[NG.Nact].datos = null;
                 NG.Var[NG.Nact].selec = 0;                
                 ListDepcia($('#slc_PER option:selected').val(), $('#hf_idUsuario').val());  
             });


             $("#slc_Depcia").change(function () {
                 var intIdDepcia = $('#slc_Depcia option:selected').val();
                 var intIdProceso = $('#slc_PER option:selected').val();
                 FObtieneDepcia(intIdDepcia);

                 if (intIdDepcia != null && intIdProceso != null) {                  
                     $('#lblSujeto').text(strNombreSujetoOb);                 
                     ActualizarGrid_Elimina(intIdDepcia, intIdProceso, intIdSujetoOb)                   
                 }
             });
         });

         //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
         //ASIGNA VALORES DEL SUJETO OBLIGADO
         function FObtieneSujeto(intIdProceso) {
             for (a_i = 0; a_i < strDatosUsuarioLOG.length; a_i++) {
                 if (strDatosUsuarioLOG[a_i].idProceso == intIdProceso) {
                     indSujetoOb = strDatosUsuarioLOG[a_i].strIndSO; // VALOR S/N
                     indEnlaceOp = strDatosUsuarioLOG[a_i].strIndEOP; // VALOR S/N
                     intProceso = strDatosUsuarioLOG[a_i].idProceso; //id del proceso que corresponde a la persona que se loguea
                     intIdSujetoOb = strDatosUsuarioLOG[a_i].IDUsuarioSO; //id del sujeto obligado
                     strNombreSujetoOb = strDatosUsuarioLOG[a_i].strNomSO; //nombre del sujeto obligado independiente mente de la persona que se logue
                     intIdPerfil = strDatosUsuarioLOG[a_i].IDPerfil;
                     if (intIdPerfil == 6) {                      
                     }

                     $('#hf_indSO').val(strDatosUsuarioLOG[a_i].strIndSO); // VALOR S/N
                     $('#hf_indEOP').val(strDatosUsuarioLOG[a_i].strIndEOP); // VALOR S/N
                     $('#hf_intIdProceso').val(strDatosUsuarioLOG[a_i].idProceso);  //id del proceso que corresponde a la persona que se loguea
                     $('#hf_idSO').val(strDatosUsuarioLOG[a_i].IDUsuarioSO); //id del sujeto obligado
                     $('#hf_strNomSO').val(strDatosUsuarioLOG[a_i].strNomSO); //nombre del sujeto obligado independiente mente de la persona que se logue
                 }

             }
         }
         
         //asigna valores del sujeto obligado a partir del proceso y de la dependencia 
         function FObtieneDepcia(intIdDepcia) {
             for (a_i = 0; a_i < strDatosDepcia.length; a_i++) {
                 if (strDatosDepcia[a_i].nDepcia == intIdDepcia) {

                     indSujetoOb = strDatosDepcia[a_i].strIndSO; // VALOR S/N
                     indEnlaceOp = strDatosDepcia[a_i].strIndEOP; // VALOR S/N
                     intProceso = strDatosDepcia[a_i].idProceso; //id del proceso que corresponde a la persona que se loguea
                     intIdSujetoOb = strDatosDepcia[a_i].IDUsuarioSO; //id del sujeto obligado
                     strNombreSujetoOb = strDatosDepcia[a_i].strNomSO; //nombre del sujeto obligado independiente mente de la persona que se logue
                     intIdPerfil = strDatosDepcia[a_i].IDPerfil;
                     intDependencia = strDatosDepcia[a_i].nDepcia; // VALOR S/N
                     strDependencia = strDatosDepcia[a_i].sDDepcia; // VALOR S/N
                     strEntrega = strDatosDepcia[a_i].sNombre; //id del proceso que corresponde a la persona que se loguea
                    
                     if (intIdPerfil == 6 && indEnlaceOp=='N') {                        
                         $('input[type=checkbox]').attr("disabled", true); 
                     }
                     else {
                         $('#hUsuario').empty();
                         $('#lblUsuario').empty();
                     }

                     $('#hf_indSO').val(strDatosDepcia[a_i].strIndSO); // VALOR S/N
                     $('#hf_indEOP').val(strDatosDepcia[a_i].strIndEOP); // VALOR S/N
                     $('#hf_intIdProceso').val(strDatosDepcia[a_i].idProceso);  //id del proceso que corresponde a la persona que se loguea
                     $('#hf_idSO').val(strDatosDepcia[a_i].IDUsuarioSO); //id del sujeto obligado
                     $('#hf_strNomSO').val(strDatosDepcia[a_i].strNomSO); //nombre del sujeto obligado independiente mente de la persona que se logue
                 }

             }
         }

         //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
         //LISTA LOS PROCESO EN LOS QUE PARTICIPA UN DETERMINADO SUJETO OBLIGADO
         function ListTipoproc(intIdSujetoObli) {
             var actionData = "{'intIdSujetoOb': " + intIdSujetoObli + "}"; ;
             $.ajax({
                 url: "Sujeto/SCSNOTISO.aspx/DibujaListTipoProc",
                 data: actionData,
                 dataType: "json",
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 success: function (reponse) {                     
                     if (reponse.d != null) {
                         strDatosUsuarioLOG = eval('(' + reponse.d + ')');
                         loadListTipProc(eval('(' + reponse.d + ')'));
                     }
                     else {
                         loading.close();
                         $('.div_ctdobligaciones').css('display', 'none');
                         $('#div_datosPyD').css('display', 'none');
                         $('#Anexos').css('display', 'none');
                         $('.notapie').css('display', 'none');
                         $('.instrucciones').css('display', 'none');
                         $('.a_acciones').css('display', 'none');
                         $('#div_mensaje').append('No tiene asociado un proceso y una dependencia');
                     }
                    
                     if (strDatosUsuarioLOG != null) {                      
                         ListDepcia($('#slc_PER option:selected').val(), $('#hf_idUsuario').val());
                     }
                 },
                 error: function (result) {
                     loading.close();
                     $.alerts.dialogClass = "errorAlert";
                     jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                 }
             });
         }


         //PINTA LOS PROCESOS DE UN DETERMINADO SUJETO OBLIGADO
         function loadListTipProc(strDatos) {

             if (strDatos == null) {
                 loading.close();
                 $('.div_ctdobligaciones').css('display', 'none');
                 $('#div_datosPyD').css('display', 'none');
                 $('#Anexos').css('display', 'none');
                 $('.notapie').css('display', 'none');
                 $('.instrucciones').css('display', 'none');
                 $('.a_acciones').css('display', 'none');
                 $('#div_mensaje').append('No tiene asociado un proceso y una dependencia');               
                 return false;
             }
             else {
                 for (a_i = 0; a_i < strDatos.length; a_i++) {                   
                     listItem = $('<option></option>').val(strDatos[a_i].idProceso).html(strDatos[a_i].strDProceso);
                     $('#slc_PER').append(listItem);                   
                 }
             }

         }
         //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

         //REALIZA UNA CONSULTA DE LAS DEPENDENCIAS CORRESPONDIENTES A UN PROCESO Y UN DETERMINADO SUJETO OBLIGADO
         function ListDepcia(intIdProceso, intUsuariolog) {
             var actionData = "{'intIdProceso': " + intIdProceso + ",'intUsuariolog': " + intUsuariolog + "}";
             $.ajax({
                 url: "Sujeto/SCSNOTISO.aspx/DibujaListDepcia",
                 data: actionData,
                 dataType: "json",
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 success: function (reponse) {
                     strDatosDepcia = eval('(' + reponse.d + ')');
                     loadListDepcia(eval('(' + reponse.d + ')'));

                     if (strDatosDepcia != null) {
                         FObtieneDepcia($('#slc_Depcia option:selected').val());
                         var intIdDepcia = $('#slc_Depcia option:selected').val();
                         var intIdProceso = $('#slc_PER option:selected').val();

                         if (intIdDepcia != null && intIdProceso != null) {
                             $('#lblSujeto').text(strNombreSujetoOb);
                             Ajax(intIdDepcia, intIdProceso, intIdSujetoOb);

                         }
                     }

                 },
                 error: function (result) {
                     loading.close();
                     $.alerts.dialogClass = "errorAlert";
                     jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                 }
             });
         }
         //PINTA LAS DEPENDENCIAS DE UN PROCESO Y SUJETO OBLIGADO
         function loadListDepcia(strDatos) {
             $('#slc_Depcia').empty()
             if (strDatos == null) {
                 loading.close();
                 $('.div_ctdobligaciones').css('display', 'none');
                 $('#div_datosPyD').css('display', 'none');
                 $('#Anexos').css('display', 'none');
                 $('.notapie').css('display', 'none');
                 $('.instrucciones').css('display', 'none');
                 $('.a_acciones').css('display', 'none');
                 $('#div_mensaje').append('No tiene asociado un proceso y una dependencia');                
                 return false;
             }
             else {
                 for (a_i = 0; a_i < strDatos.length; a_i++) {                    
                     listItem = $('<option></option>').val(strDatos[a_i].nDepcia).html(strDatos[a_i].sDDepcia);
                     $('#slc_Depcia').append(listItem);
                 }
              
                 $('#hf_intProceso').val($('#slc_PER option:selected').val());
                 $('#hf_intDependencia').val($('#slc_Depcia option:selected').val());
                
             }
            
         }
         //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

         //CONSULTA LOS ENLACES OPERATIVOS CORRESPONDIENTES A UN PROCESO Y UNA DETERMINADA DEPENDENCIA
         function Ajax(nIdDepcia, nIdProceso, nIdSujetoOb) {           
             var actionData = "{'nidSujeto': " + nIdSujetoOb + ",'nidProceso': " + nIdProceso + ",'nidDepcia': " + nIdDepcia + ",'nidUsuario': " + $('#hf_idUsuario').val() + "}";
             $.ajax(
                {
                    url: "Sujeto/SCSNOTISO.aspx/ObtenerDatos",                    
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        if (frms.trim(reponse.d) != '') { // si es diferente de cadena vacia, si trajo datos
                            datosJSON = null;
                            datosJSON = eval('(' + reponse.d + ')');                                                
                            Pinta_Grid(datosJSON);
                            loading.close();                                                 
                        }
                    },                  
                    complete: loading.close(),
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
         }

         //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
          
         //Función que lleva el control de configuración de notificaciones
         function ClickCheck() {
             $('input[type=checkbox]').click(function () {
                 var cIndAplica;
                 var cIndPerfil;
                 if ($(this).is(":checked")) {
                     cIndAplica = 'S';
                 } else {
                     cIndAplica = 'N';
                 }

                 if ($(this).attr("id") == intIdSujetoOb) {
                     cIndPerfil = 4;
                 }
                 else {
                     cIndPerfil = 6;
                 }

                 var strParametros = "{'nIdProceso':'" + $('#slc_PER option:selected').val() +
                                    "','nIdDepcia': '" + $('#slc_Depcia option:selected').val() +
                                    "','nIdUsuario': '" + $(this).attr("id") +
                                    "','nIdPerfil': '" + cIndPerfil +
                                    "','cIdAplica': '" + cIndAplica +
                                    "','nIdUsuModif': '" + $('#hf_idUsuario').val() +
                                    "'}";
                 $.ajax({
                     url: "Sujeto/SCSNOTISO.aspx/pActualizaAplica",
                     data: strParametros,
                     dataType: "json",
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     success: function (reponse) {                        
                         var resp = reponse.d;
                         switch (resp) {
                             case 0:
                                 $.alerts.dialogClass = "incompletoAlert";
                                 jAlert("La operación no pudo ser realizada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                 break;
                             case 1:                                 
                         }
                     },
                     beforeSend: loading.ini(),
                     complete: loading.close(),
                     error: function (result) {
                         loading.close();
                         $.alerts.dialogClass = "errorAlert";
                         jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                     }
                 });
             });
         }
         //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
         //Pinta el grid de enlaces operativos
         function Pinta_Grid(scadena) {             
             $('#grid').empty();
             mensaje = { "mensaje": "No existen datos con la opción seleccionada." }
             if (scadena == null) {
                 $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                 return false;
             }
             $('#grid').append(pTablaI(scadena));
             ClickCheck();
             NG.tr_hover();
             tooltip.iniToolD('25%');             
             NG.Var[NG.Nact].oTable = $('#grid')
                .dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                    "aaSorting": Sort_SCSNOTISO[1], /*Se manda a traer la configuración de selección de columna en el grid*/
                    "aoColumns": Sort_SCSNOTISO[0]
                });
         }
         
         //Permite actualizar el grid despues de haber seleccionado un usuario
         function ActualizarGrid_Elimina(intIdDepcia, intIdProceso, intIdSujetoOb) {             
             $('#grid').empty()
            
             Ajax(intIdDepcia, intIdProceso, intIdSujetoOb);
             NG.Var[NG.Nact].oTable.fnDestroy();
             NG.Var[NG.Nact].datoSel = null;
             NG.Var[NG.Nact].datos = null;
             NG.Var[NG.Nact].selec = 0;         

         }



         //Construir la tabla y llenar la tabla de enlaces operativos
         function pTablaI(stab) {
             NG.Var[NG.Nact].datos = stab;
             htmlTab = '';
             htmlTab += '<thead><tr>';             
             htmlTab += '<th  scope="col" style="width:75%;" class="sorting" title="Ordenar">Nombre</th>';
             htmlTab += '<th  scope="col" style="width:20%;" class="sorting" title="Ordenar">Perfil</th>';
             htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
             htmlTab += '</tr></thead>';
             htmlTab += "<tbody>";

             if (stab[1].chrIndAplicaS == 'S') {
                 htmlTab += '<tr id="tr_' + stab[1].idUsuario + '" class="row_selected">';
             }
             else {
                 htmlTab += '<tr id="tr_' + stab[1].idUsuario + '">';
             }           
             htmlTab += '<td scope="col" class="sorts Acen">' + strNombreSujetoOb + '</td>';
             htmlTab += '<td scope="col" class="sorts Acen">' + 'SUJETO OBLIGADO' + '</td>';
             if (stab[1].chrIndAplicaS == 'S') {
                 htmlTab += '<td class="sorts Acen"><input name="check" id="' + stab[1].idUsuario + '" type="checkbox" checked="checked" value="' + stab[1].idUsuario + '" onclick="Cambia(\'' + stab[1].idUsuario + '\')" /></td>';
             }
             else {
                 htmlTab += '<td class="sorts Acen"><input name="check" id="' + stab[1].idUsuario + '" type="checkbox" value="' + stab[1].idUsuario + '" onclick="Cambia(\'' + stab[1].idUsuario + '\')" /></td>';
             }
             htmlTab += "</tr>";

             if (stab[1].idUsuarioEnlace != "0" && stab[1].idUsuarioEnlace != " ") {
                 for (a_i = 1; a_i < stab.length; a_i++) {
                     
                     var a_i2 = a_i + 1;
                     if (stab[a_i].chrIndAplicaE == 'S') {
                         htmlTab += '<tr id="tr_' + stab[a_i].idUsuarioEnlace + '" class="row_selected">';
                     }
                     else {
                         htmlTab += '<tr id="tr_' + stab[a_i].idUsuarioEnlace + '">';
                     }                        
                
                     htmlTab += '<td scope="col" class="sorts Acen">' + stab[a_i].strNombre + '</td>';                

                     if (stab[a_i].chrPrincipal == 'S') {
                         htmlTab += '<td scope="col" class="sorts Acen" title="Ordenar">'+ 'ENLACE OPERATIVO PRINCIPAL'+ '</td>';
                     }
                     else {
                         htmlTab += '<td scope="col" class="sorts Acen" title="Ordenar">' + 'ENLACE OPERATIVO' + '</td>';
                     }
                     if (stab[a_i].chrIndAplicaE == 'S') {
                         htmlTab += '<td class="sorts Acen"><input name="check" id="' + stab[a_i].idUsuarioEnlace + '" type="checkbox"  checked="checked" value="' + stab[a_i].idUsuarioEnlace + '" onclick="Cambia(\'' + stab[a_i].idUsuarioEnlace + '\')" /></td>';
                     }
                     else {
                         htmlTab += '<td class="sorts Acen"><input name="check" id="' + stab[a_i].idUsuarioEnlace + '" type="checkbox" value="' + stab[a_i].idUsuarioEnlace + '" onclick="Cambia(\'' + stab[a_i].idUsuarioEnlace + '\')" /></td>';
                     }
                 }

                 htmlTab += "</tr>";
             }

             htmlTab += "</tbody>";
             return htmlTab;
         }
        //Función que controla el seleccionado de las filas de grid de Configuración de notificaciones
         function Cambia(selec) {           

             if ($("#" + selec).is(":checked")) {
                 $("#tr_" + selec).addClass("row_selected");               
             } else {
                 $("#tr_" + selec).removeClass("row_selected");
                 
             }
              
                      
         }
     </script>
    <form id="form1" runat="server">
     <div id="agp_contenido">      
            <div id="agp_navegacion">
                <label class="titulo">Notificaciones Sujeto Obligado</label>
                <div class="a_acciones">                 
                   
                </div>
            </div>

            <div class="instrucciones">Seleccione la información requerida:</div>
            <div id="div_datosPyD">   
                <h2>Proceso entrega - recepción:</h2> <label><select id="slc_PER"></select></label>  
                 <br />
                <h2>Dependencia / entidad:</h2> <label><select id="slc_Depcia"></select></label>             
                <br />
                <h2>Sujeto obligado:</h2> <label id="lblSujeto"></label>            
                              
               
            </div>
            <div id="div_mensaje"></div>
            <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
            </div>     
           
            <br /><br />
            <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_indSO" runat="server" />
            <asp:HiddenField ID="hf_indEOP" runat="server" />
            <asp:HiddenField ID="hf_intIdProceso" runat="server" />
            <asp:HiddenField ID="hf_idSO" runat="server" />  
            <asp:HiddenField ID="hf_strNomSO" runat="server" /> 
            <input type="hidden" id="hf_intDependencia"/>
            <input type="hidden" id="hf_strDProceso"/>
            </div>
                    

        </div>
    </form>
</body>
</html>
