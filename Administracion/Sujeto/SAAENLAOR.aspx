<%@ Page Language="C#" AutoEventWireup="true" Inherits="SAAENLAOR" Codebehind="SAAENLAOR.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />   
 <%--   <link href="../styles/Guia.css" rel="stylesheet" type="text/css" />--%>
   <%-- <script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>--%>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>  
</head>
<body>

<script type="text/javascript">
     var Sort_SAAENLACE = new Array(2);
     Sort_SAAENLACE[0] = [{ "bSortable": false }, null, null, null, null, null, null];
     Sort_SAAENLACE[1] = [[2, "asc"]];
     var datosJSON;
     var idusuario = $('#hf_idUsuario').val();

     BotonesEnlaces = function (selec) {
         if (selec > 0) {
             $("#AccAgregar2, #AccEliminar, #AccModificar").show();
             $("#AccAgregar, #AccEliminar2, #AccModificar2").hide();
         }
         else {
             $("#AccAgregar2, #AccEliminar, #AccModificar").hide();
             $("#AccAgregar, #AccEliminar2, #AccModificar2").show();
         }
     }

     $(document).ready(function () {      
         NG.setNact(1, 'Uno', BotonesEnlaces);        
         if (NG.Var[NG.Nact].oSets == null) {             
             ListTipoproc(idusuario);
         } else {
             NG.repinta();
         }
     });

     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

     //LISTA TODOS LOS PROCEDIMIENTOS ALMACENADOS DE ACUERDO A EL IDENTIFICADOR DEL SUJETO OBLIGADO QUE SE LOGUEA
     function ListTipoproc(nSujetoR) {
         var actionData = "{'nSujetoRecept': " + nSujetoR + "}"; ;
         $.ajax({
             url: "Sujeto/SAAENLAOR.aspx/DibujaListTipoProc",
             data: actionData,
             dataType: "json",
             type: "POST",
             contentType: "application/json; charset=utf-8",
             success: function (reponse) {               
                 if (reponse.d != "null") {
                     loadListTipProc(eval('(' + reponse.d + ')'));
                     if ($('#slc_PER option:selected').val() != null) {
                         ListDepcia($('#slc_PER option:selected').val(), $('#hf_idUsuario').val());
                     }
                 }
                 else {                   
                     $('#div_datosPyD').css('display', 'none');
                     $("#AccAgregar, #AccEliminar, #AccModificar").hide();
                     $("#AccAgregar2, #AccEliminar2, #AccModificar2").show();
                     $('.instrucciones').css('display', 'none');
                     $('.a_acciones').css('display', 'none');
                     $('#grid').append('<tr><td class="Acen">No tiene asociado un proceso y una dependencia</td></tr>');
                     loading.close();   
                 }
             },
             error: function (result) {
                 loading.close();
                 $.alerts.dialogClass = "errorAlert";
                 jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
             }
         });
     }

     //PINTA EL LISTBOX DE PROCESOS CORRESPONDIENTES A UN USUARIO 
     function loadListTipProc(strDatos) {
         if (strDatos == null) {
             loading.close();  
             return false;
         }
         else {
             for (a_i = 0; a_i < strDatos.length; a_i++) {
                 listItem = $('<option></option>').val(strDatos[a_i].idProceso).html(strDatos[a_i].strDProceso);
                 $('#slc_PER').append(listItem);                
             }
         }

     }
     //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


     //FUNCIÓN QUE REALIZA UNA CONSULTA DE LAS DEPENDENCIAS QUE PERTENECEN A UN PROCESO Y A UN SUJETO OBLIGADO
     function ListDepcia(intIdProceso, intUsuariolog) {
         var actionData = "{'nIdProceso': " + intIdProceso + ",'nUsuariolog': " + intUsuariolog + "}";
         $.ajax({
             url: "Sujeto/SAAENLAOR.aspx/DibujaListDepcia",
             data: actionData,
             dataType: "json",
             type: "POST",
             contentType: "application/json; charset=utf-8",
             success: function (reponse) {
                 loadListDepcia(eval('(' + reponse.d + ')'));
             },
             error: function (result) {
                 loading.close();
                 $.alerts.dialogClass = "errorAlert";
                 jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
             }
         });
     }

     //PINTA EL LISTBOX DE DEPENDENCIAS DE UN SUJETO DE UN PROCESO DETERMINADO
     function loadListDepcia(strDatos) {
         $('#slc_Depcia').empty()
         if (strDatos == null) {
             $('#div_datosPyD').css('display', 'none');
             $("#AccAgregar, #AccEliminar, #AccModificar").hide();
             $("#AccAgregar2, #AccEliminar2, #AccModificar2").show();
             $('.instrucciones').css('display', 'none');
             $('.a_acciones').css('display', 'none');
             $('#grid').append('<tr><td class="Acen">No tiene asociado un proceso y una dependencia</td></tr>');
             loading.close();           
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
         var intdepcia = $('#slc_Depcia option:selected').val();
         var intproceso = $('#slc_PER option:selected').val();       
         if (intdepcia != null && intproceso != null) {
             NombreSO($('#hf_idUsuario').val())
            
             Ajax(intdepcia, intproceso);
         }
     }
     //********************************************************************************************************************
     //CONSULTA EL NOMBRE DEL SUJETO OBLIGADO LOGUEADO A PARTIR DE SU IDENTIFICADOR
     function NombreSO(nidUsuariolog) {
         var actionData = "{'nidUsuariolog': " + nidUsuariolog +
                                          "}";
         $.ajax({
             url: "Sujeto/SAAENLAOR.aspx/ObtieneNombreSO",
             data: actionData,
             dataType: "json",
             type: "POST",
             contentType: "application/json; charset=utf-8",
             success: function (reponse) {                 
                 PintaNombreSO(eval('(' + reponse.d + ')'));
             },
             error: function (result) {
                 loading.close();
                 $.alerts.dialogClass = "errorAlert";
                 jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
             }
         });
     }

     //PINTA EL NOMBRE DEL SUJETO OBLIGADO EN UNA ETIQUETA
     function PintaNombreSO(strDatos) {       
         if (strDatos == null) {            
             $('#lblSujeto').text('No se pudo consultar el usuario.');            
             return false;
         }
         else {
             for (a_i = 0; a_i < strDatos.length; a_i++) {
                   $('#lblSujeto').text(strDatos[1].strNombre + ' ' + strDatos[1].strApPaterno + ' ' + strDatos[1].strApMaterno);             
             }
         }
     }

     //------------------------------------------------------------------------------------------------------------------

     //CONSULTA LOS ENLACES OPERATIVOS CORRESPONDIENTES A UN PROCESO Y UNA DETERMINADA DEPENDENCIA
     function Ajax(ndepcia, nproceso) {
         var actionData = "{'nidUsuario': " + idusuario + ",'nidProceso': " + nproceso + ",'nidDepcia': " + ndepcia + "}";

         $.ajax(
                {
                    url: "Sujeto/SAAENLAOR.aspx/ObtenerDatos",
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
     

     //Pinta el grid de enlaces operativos
     function Pinta_Grid(scadena) {         
         $('#grid').empty();
         mensaje = { "mensaje": "No existen datos con la opción seleccionada." }
         if (scadena == null) {
             $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
             loading.close();
             return false;
         }
         $('#grid').append(pTablaI(scadena));
         NG.tr_hover();
         tooltip.iniToolD('25%');         
         NG.Var[NG.Nact].oTable = $('#grid')
                .dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                    "aaSorting": Sort_SAAENLACE[1], /*Se manda a traer la configuración de selección de columna en el grid*/
                    "aoColumns": Sort_SAAENLACE[0]
                });
     }
    
    //Función que construye la tabla de enlaces operativos receptores
     function pTablaI(stab) {
         NG.Var[NG.Nact].datos = stab;       
         htmlTab = '';
         htmlTab += '<thead><tr>';
         htmlTab += '<th class="no_sort" align="center" scope="col" style="width:3%;"></th>';
         htmlTab += '<th align="center" scope="col" style="width:6%;" class="sorting" title="Ordenar">Número de personal</th>';
         htmlTab += '<th align="center" scope="col" style="width:27%;" class="sorting" title="Ordenar">Nombre</th>';
         htmlTab += '<th align="center" scope="col" style="width:8%;" class="sorting" title="Ordenar">Enlace receptor principal</th>';
         htmlTab += '<th align="center" scope="col" style="width:13%;" class="sorting" title="Ordenar">Cuenta Institucional</th>';
         htmlTab += '<th align="center" scope="col" style="width:23%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
         htmlTab += '<th align="center" scope="col" style="width:19%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
         htmlTab += '</tr></thead>';
         htmlTab += "<tbody>";


         for (a_i = 1; a_i < stab.length; a_i++) {

             if (NG.Var[NG.Nact].selec == a_i) {
                 htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                 htmlTab += '<td class="sorts Acen"><input name="check" id="ch_' + a_i + '" type="radio" checked="checked" value="' + stab[a_i].idUsuario + '" onclick="Cambia(\'' + a_i + '\')" /></td>';

             }
             else {
                 htmlTab += '<tr id="tr_' + a_i + '" >';
                 htmlTab += '<td class="sorts Acen"><input name="check" id="ch_' + a_i + '" type="radio" value="' + stab[a_i].idUsuario + '" onclick="Cambia(\'' + a_i + '\')" /></td>';
             }
                       
             htmlTab += '<td scope="col" class="sorts Acen" title="Ordenar">' + stab[a_i].intNumPersonal + '</td>';
             htmlTab += '<td scope="col" class="sorts" title="Ordenar">' + stab[a_i].strNombre + ' ' + stab[a_i].strApPaterno + ' ' + stab[a_i].strApMaterno + '</td>';

             if (stab[a_i].chrPrincipal == 'S') {
                 htmlTab += '<td scope="col" class="sorts Acen" title="Ordenar"><img id="ico_busqueda" alt="Indicador de enlace operativo principal" src="../images/enlace-receptor-1.png" /></td>';
             }
             else {               
                 htmlTab += '<td scope="col" class="sorts Acen" title="Ordenar"></td>';
             }
             htmlTab += '<td scope="col" class="sorts Acen" title="Ordenar">' + stab[a_i].strCuenta + '</td>';
            
             htmlTab += '<td class="sorts Acen" title="Ordenar">';
             htmlTab += '<div class="textoD">' + stab[a_i].strsDCDepcia + '</div>';
             htmlTab += '<div class="tooltipD">' + stab[a_i].strsDCDepcia + '</div>';
             htmlTab += '</td>';
            
             htmlTab += '<td class="sorts Acen title="Ordenar"">';
             htmlTab += '<div class="textoD">' + stab[a_i].strsDCPuesto + '</div>'; 
             htmlTab += '<div class="tooltipD">' + stab[a_i].strsDCPuesto + '</div>';
             htmlTab += '</td>';
         }

         htmlTab += "</tr>";

         htmlTab += "</tbody>";
         return htmlTab;
     }
     //**************************************************************************************************************************

     //CONTROLA LOS BOTONES A PARTIR DE SELECCIONAR UN RADIO DE LA TABLA
     function Cambia(selec) {        
         NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
         NG.cambia(selec);
         NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
     }
     //*************************************************************************************************************************

     //Agregar un nuevo enlace operativo   
     function Agregar() {           
         if (($('#slc_Depcia option:selected').val() != null) && ($('#slc_PER option:selected').val() != null)) {
             urls(9, "Sujeto/SAAENLAORA.aspx?idDepcia=" + $('#slc_Depcia option:selected').val() + "&idProceso=" + $('#slc_PER option:selected').val());           
         }
     }

     //***************************************************************************************************************************

     //Modificar un enlace operativo
     function Modificar() {     
         if (($('#slc_Depcia option:selected').val() != null) && ($('#slc_PER option:selected').val() != null)) {
             urls(9, "Sujeto/SAAENLAORA.aspx?idDepcia=" + $('#slc_Depcia option:selected').val() + "&idProceso=" + $('#slc_PER option:selected').val());             
         }       
     }
     //***********************************************************************************************************************

     //Eliminar un enlace operativo
     function Eliminar() {
         var nombre = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strNombre;
         var intIdProceso = $('#slc_PER option:selected').val();
         var intIdDepcia = $('#slc_Depcia option:selected').val();
         $.alerts.dialogClass = "infoConfirm";
         jConfirm('El enlace operativo: ' + nombre + ' será eliminado \n\n¿Está seguro que desea eliminar este registro?', "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {

             if (r) {
                 loading.ini();
                 var actionData = "{'idEnlace': " + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuario + ",'idUsuario': " + idusuario + ",'idProceso': " + intIdProceso + ",'idDepcia': " + intIdDepcia + "}";
                 
                 $.ajax(
                        {
                            url: "Sujeto/SAAENLAOR.aspx/eliminarEnlace",                           
                            data: actionData,
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {
                                loading.close();
                                switch (reponse.d) {
                                    case 0:
                                        $.alerts.dialogClass = "incompletoAlert";
                                        jAlert("No se puede eliminar el enlace operativo ya que es un enlace principal.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                        ActualizarGrid(intIdProceso, intIdDepcia); 
                                        break;
                                    case 1:
                                        $.alerts.dialogClass = "correctoAlert";
                                        jAlert("El enlace operativo se ha eliminado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                        ActualizarGridElimina(intIdProceso, intIdDepcia); 
                                        break;
                                    case 2:
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                        ActualizarGrid(intIdProceso, intIdDepcia); 
                                        break;
                                    default:
                                }
                                                            
                            },                           
                            error: function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        });
             }
             else {

             }
         });
     }

     //*************************************************************************************************
     //PERMITE ACTUALIZAR EL GRID DESPUÉS DE MODIFICAR Y AGREGAR UN NUEVO ENLACE OPERATIVO
     function ActualizarGrid(intIdProceso, intIdDepcia) {         
         $('#grid').empty()
         $("#AccAgregar2, #AccEliminar, #AccModificar").show();
         $("#AccAgregar, #AccEliminar2, #AccModificar2").hide();
         NG.Var[NG.Nact].oTable.fnDestroy();       
         Ajax(intIdDepcia, intIdProceso);
     }

     //Actualizar el grid después de eliminar un enlace operativo receptor
     function ActualizarGridElimina(intIdProceso, intIdDepcia) {       
        $('#grid').empty()

        Ajax(intIdDepcia, intIdProceso);
        NG.Var[NG.Nact].oTable.fnDestroy();
        NG.Var[NG.Nact].datoSel = null;
        NG.Var[NG.Nact].datos = null;
        NG.Var[NG.Nact].selec = 0;

         BotonesEnlaces(0); 
     }

</script>



    <form id="form1" runat="server">
   <div id="agp_contenido">
        <div id="agp_navegacion">
            <label class="titulo">Enlace operativo Receptor</label>
            <div class="a_acciones">
                <a id="AccAgregar" title="Agregar" href="javascript:Agregar();" class="accAct">Agregar</a>
                <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>   

                <a id="AccModificar" title="Modificar" href="javascript:Modificar();" class="accAct iOculto">Modificar</a>
                <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>       

                <a id="AccEliminar" title="Eliminar" href="javascript:Eliminar();" class="accAct iOculto">Eliminar</a>
                <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>
            </div>
        </div>

        <div class="instrucciones">Seleccione un usuario para realizar las acciones correspondientes:</div>
       
         <div id="div_datosPyD">   
            <h2>Proceso entrega - recepción:</h2> <label><select id="slc_PER"></select></label>  
             <br />
            <h2>Dependencia / entidad:</h2> <label><select id="slc_Depcia"></select></label>
           <%-- <br />
            <h2>Titular:</h2><label id="lblSO"> No existe Titular</label>--%>
            <br />
            <h2>Sujeto Receptor:</h2> <label id="lblSujeto"></label>
            <br />
            <br />
            </div>


        <!-- Desplegado contenidos -->
        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
        </div>           
        <!-- fin Desplegado contenidos -->
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <input type="hidden" id="hf_intDependencia"/>
            <input type="hidden" id="hf_intProceso"/>
        </div>
    </div>
    </form>
</body>
</html>
