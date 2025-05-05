<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCCUSUARIO" Codebehind="SCCUSUARIO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>     
    <meta http-equiv="X-UA-Compatible" content="IE=8" />    
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />    
    <link href="../styles/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />        
    <link href="../styles/Usuario.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Notificacion.css" rel="stylesheet" type="text/css" />
    <link href="../styles/icons.css" rel="stylesheet" type="text/css" />

    <script src="../scripts/jquery-1.8.3.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui-1.9.2.custom.js" type="text/javascript"></script>
    <script src="../scripts/jquery.numeric.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
</head>
<body>

<script type="text/javascript">
    //Bloque para el ordenamiento de columnas en el grid
    var Sort_SNCUSUARI = new Array(2);  /* Indicación de la ordenación por default del grid */
    Sort_SNCUSUARI[0] = [{ "bSortable": false }, null, null, null, null, null, null, null];
    Sort_SNCUSUARI[1] = [[2, "asc"]];

    var arregloSeleccionadas = new Array();
    var arregloCorreos = new Array(); //arreglo que almacena los correos de los usuarios que se mandarán al textBox de la página anteriror

    BotonesUsuarios = function (selec) {

    }

    $(document).ready(function () {
        loading.ini();
        
        NG.setNact(1, 'Uno', BotonesUsuarios);
        NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

        if (NG.Var[NG.Nact].oSets == null) {
            Ajax();
        } else {
            Ajax();
        }
    });

    //Función principal para desplegar los usuarios existentes
    function Ajax() {

        $.ajax({
            url: "../Cierre/SCCUSUARIO.aspx/Pinta_Grid",
            // data: actionData,
            dataType: "json",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function (reponse) {
                arregloSeleccionadas = [];
                Pinta_Grid(eval('(' + reponse.d + ')'));
                //loading.close();
                //console.log(reponse.d);
            },
            //beforeSend: loading.ini(),
            //complete: loading.close(),
            error: // errorAjax
                function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                }
        });
    }

    //Función para pintar la tabla
    function Pinta_Grid(cadena) {
        $('#grid').empty();
        if (cadena == null || cadena == "") {
            loading.close();

            $('#grid').append('<tr><td class="Acen">' + cadena.mensaje + '</td></tr>');
            return false;
        }

        $('#grid').append(pTablaI(cadena));

        a_di = new o_dialog('VER PERFILES');
        a_di.iniDial();
        NG.tr_hover();
        tooltip.iniToolD('45%');

        NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SNCUSUARI[1],
                "aoColumns": Sort_SNCUSUARI[0]
            });
        loading.close();
    };


    //Definición de la tabla con los elementos a desplegar
    function pTablaI(tab) {
        NG.Var[NG.Nact].datos = tab;
        htmlTab = '';
        htmlTab += '<thead><tr>';
        htmlTab += '<th class="no_sort"  scope="col" style="width:4%;"></th>';
        htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Número de personal</th>';
        htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Nombre</th>';
        htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Cuenta institucional</th>';
        htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
        htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
        htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Perfil</th>';
        htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Disponibilidad</th>';
        htmlTab += '</tr></thead>';
        htmlTab += "<tbody>";

        for (a_i = 1; a_i < tab.length; a_i++) {

            a_class = '';
            a_check = '';


            htmlTab += '<tr id="tr_' + a_i + '"' + a_class + '>';
            htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" value="' + tab[a_i].idUsuario + '" type="checkbox"' + a_check + 'onclick="Selecciona(\'' + a_i + '\')" /></td>';


            htmlTab += '<td class="sorts Acen">' + tab[a_i].intNumPersonal + '</td>';

            htmlTab += '<td class="sorts">';
            htmlTab += '<div class="textoD">' + tab[a_i].strNombre + '</div>';
            htmlTab += '<div class="tooltipD">' + tab[a_i].strNombre + '</div>';
            htmlTab += '</td>';

            htmlTab += '<td class="sorts Acen">' + tab[a_i].strCuenta + '</td>';

            htmlTab += '<td class="sorts">';
            htmlTab += '<div class="textoD">' + tab[a_i].strsDCDepcia + '</div>';
            htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCDepcia + '</div>';
            htmlTab += '</td>';

            htmlTab += '<td class="sorts">';
            htmlTab += '<div class="textoD">' + tab[a_i].strsDCPuesto + '</div>';
            htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCPuesto + '</div>';
            htmlTab += '</td>';

            if (tab[a_i].lstPerfiles.length == 0) {
                htmlTab += '<td class="sorts Acen">SIN PERFIL</td>';
            } else {
                if (tab[a_i].lstPerfiles.length == 1) {
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD">' + tab[a_i].lstPerfiles[0].strsDCPerfil.toUpperCase() + '</div>';
                    htmlTab += '<div class="tooltipD">' + tab[a_i].lstPerfiles[0].strsDCPerfil.toUpperCase() + '</div>';
                    htmlTab += '</td>';
                } else {
                    htmlTab += '<td class="sorts Acen">';
                    htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER PERFILES..</a></div>';
                    htmlTab += '<div class="dialoG oculto"><ul>';
                    for (a_j = 0; a_j < tab[a_i].lstPerfiles.length; a_j++)
                        htmlTab += '<li>' + tab[a_i].lstPerfiles[a_j].strsDCPerfil.toUpperCase() + '</li>';
                    htmlTab += '</ul></div></td>';
                }
            }

            if (tab[a_i].chrIndActivo == 's' || tab[a_i].chrIndActivo == 'S') {
                htmlTab += '<td class="sorts Acen">' + 'SÍ' + '</td>';
            } else if (tab[a_i].chrIndActivo == 'n' || tab[a_i].chrIndActivo == 'N') {
                htmlTab += '<td class="sorts Acen">' + 'NO' + '</td>';
            }
        }
        htmlTab += "</tr>";
        htmlTab += "</tbody>";

        return htmlTab;
    }


    // Función en donde se almacena en un arreglo los distintos id's de usuarios seleccionados
    function Selecciona(actual) {

        if ($('#ch_' + actual).is(':checked')) {
            arregloSeleccionadas.push(NG.Var[NG.Nact].datos[actual].idUsuario);
            arregloCorreos.push(NG.Var[NG.Nact].datos[actual].strCorreo); //inserto el correo del usuario al arreglo
            $('#tr_' + actual).addClass('row_selected');
        } else {
            $('#tr_' + actual).removeClass('row_selected');


            for (i = 0; i < arregloSeleccionadas.length; i++) {
                if (arregloSeleccionadas[i] == NG.Var[NG.Nact].datos[actual].idUsuario) {
                    arregloSeleccionadas.splice(i, 1);
                }
            }

            //este ciclo es para quitar el correo que deseleccionó para el arreglo de correos
            for (i = 0; i < arregloCorreos.length; i++) {
                if (arregloCorreos[i] == NG.Var[NG.Nact].datos[actual].strCorreo) {
                    arregloCorreos.splice(i, 1);
                }
            }


        }

    }

    //Esta función manda a llamar una funcion de la página anterior que cierra el dialog y pinta los correos en el textBox
    function fRegresarDatos2() {
        if (arregloCorreos != '') {
            parent.window.fn_cerrarPform(arregloCorreos, arregloSeleccionadas);
        } else {
            $.alerts.dialogClass = "infoAlert";
            jAlert("Debe seleccionar al menos un usuario para completar la acción.", "SISTEMA DE ENTREGA - RECEPCIÓN");
        }
    }

    // Función que cierra la ventana abierta y regresa a la página donde se redacta la notificación
    function Cancelar() {
        parent.window.CerrarDialogoUsuario();
    }


</script>

<form id="frm_Usuarios" runat="server">
    <div id="agp_contenido">      
        <div class="instrucciones">Seleccione el o los usuarios para enviar la notificación.</div>
    
        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>
        <br />        

        <div class="a_botones_modal">
            
              <a title="Botón Guardar" href="javascript:fRegresarDatos2();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" href="javascript:Cancelar();" class="btnAct">Cancelar</a>        
        </div>
        <br />
    </div>
</form>

</body>
</html>
