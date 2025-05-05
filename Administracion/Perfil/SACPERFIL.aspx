<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Perfil_SACPERFIL" Codebehind="SACPERFIL.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>     
</head>
<body>
   <script type="text/javascript">
        //Bloque para el ordenamiento de columnas en el grid
        var Sort_SACPERFIL = new Array(2);  
        Sort_SACPERFIL[0] = [{ "bSortable": false }, null, null, null, null];
        Sort_SACPERFIL[1] = [[1, "asc"]];

        //Bloque para condicionar la visualización de los botones dependendiendo si se selecciona o no un elemento en el grid
        BotonesUsuaPerfil = function (selec) {
           if (selec > 0) { //Seleccionado
               $("#AccReportes").hide();
               $("#AccReportes2").show();
           } else { //No Seleccionado
               $("#AccReportes").show();
               $("#AccReportes2").hide();
           }
        }

        $(document).ready(function () {
        //Se asignan parámetros obtenidos de la forma anterior (SAMPERFIL.aspx)
           idPerfil = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idPerfil;
           strsDCPerfil = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strsDCPerfil;

           $("#tipoPerfil").val(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strsDCPerfil);

           NG.setNact(2, 'Dos', BotonesUsuaPerfil);
           NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
           if (NG.Var[NG.Nact - 1].datoSel != null) {
               AjaxP(idPerfil);
           } else {
               NG.repinta();
           }
        });

        //Función donde se manda a traer los datos de los usuarios que cumplan con el perfil seleccionado previamente
        function AjaxP(idPerfil) {
           var actionData = "{'idPerfil': '" + idPerfil +
                         "'}";
           $.ajax(
                {
                    url: "Perfil/SACPERFIL.aspx/Pinta_GridP",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        try {                            
                            Pinta_Grid(eval('(' + reponse.d + ')'));
                            
                        } catch (err) {
                            txt = "Ha sucedido un error inesperado, inténtelo más tarde\n\n";
                            txt += "descripción del error: " + err.message + "\n\n";                            
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        //Función para pintar la tabla
        function Pinta_Grid(cadena) {
           
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
                "aaSorting": Sort_SACPERFIL[1],
                "aoColumns": Sort_SACPERFIL[0]
            });           
        };

        //Definición de la tabla con los elementos a desplegar
        function pTablaI(tab) {
           
           NG.Var[NG.Nact].datos = tab;
           htmlTab = '';
           htmlTab += '<thead><tr>';
           htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">Número de personal</th>';
           htmlTab += '<th align="center" scope="col" style="width:24%;" class="sorting" title="Ordenar">Nombre</th>';
           htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Correo electrónico</th>';
           htmlTab += '<th align="center" scope="col" style="width:25%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
           htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
           htmlTab += '</tr></thead>';
           htmlTab += "<tbody>";

           for (a_i = 1; a_i < tab.length; a_i++) {
               htmlTab += '<tr>';
               htmlTab += '<td class="sorts Acen">' + tab[a_i].intNumPersonal + '</td>';
               htmlTab += '<td class="sorts">' + tab[a_i].strNombre + '</td>';
               htmlTab += '<td class="sorts Acen">' + tab[a_i].strCorreo + '</td>';

               htmlTab += '<td class="sorts">';
               htmlTab += '<div class="textoD">' + tab[a_i].strsDCDepcia + '</div>';
               htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCDepcia + '</div>';
               htmlTab += '</td>';

               htmlTab += '<td class="sorts">';
               htmlTab += '<div class="textoD">' + tab[a_i].strsDCPuesto + '</div>';
               htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCPuesto + '</div>';
               htmlTab += '</td>';
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
        };

        //Función para vuelve a mostrar los datos de la tabla una vez realizada una acción
        function ActualizarGrid() {
           $("#grid").empty();
           NG.Var[NG.Nact].oTable.fnDestroy();
           Ajax();
        }

        //Llamada a la página de reporte de usuarios que cumplen con el perfil seleccionado
        function Reporte(op) {
           $("#hf_operacion").val(op);
           dTxt = '<div id="dComent" title="SERUV - Reporte">';
           dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?IdItem=' + idPerfil + '&op=PERFILUSUARIO' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
           dTxt += '</div>';
           $('#fr_SACPERFIL').append(dTxt);
           $("#dComent").dialog({
               autoOpen: true,
               height: $(window).height() - 60, //800,
               width: $("#agp_contenido").width() - 50, //1000,
               modal: true,
               resizable: true,
               close: function (event, ui) {
                   fCerrarDialog();
               }
           });
        }

        /*Función que se utiliza cuando se cierra la ventana que muestra el reporte de usuarios*/
        function fCerrarDialog() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }

        //Función para regresar a la página principal en donde se despliegan los perfiles existentes en el sistema
        function fRegresar() {
           urls(2, "Perfil/SAMPERFIL.aspx");
        }

    </script>
    <form id="fr_SACPERFIL" runat="server">
    <div id="agp_contenido">      
            <div id="agp_navegacion">
                <label class="titulo">Usuarios por perfil</label>
            <div class="a_acciones">
                    <a id="AccReportes" title="Reportes de usuarios por perfil" href="javascript: Reporte('PERFILUSUARIO');" class="accAct iOculto">Reporte</a>                                                   
                    <a id="AccReportes2" title="Reportes de usuarios por perfil" class="accIna">Reporte</a>
                </div>
            </div>    
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 
        <br /><br />
        <%--<div class="instrucciones">¿¿¿INSTRUCCIÓN???</div>--%>

        <h2>Perfil:</h2><label><input id="tipoPerfil" type="text" name="cuenta" readonly="readonly" size="70"/></label>
        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>
        <br />
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idPerfil" runat="server" />
            <asp:HiddenField ID="hf_operacion" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>

