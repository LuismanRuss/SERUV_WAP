<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_SARUSRDEP" Codebehind="SARUSRDEP.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

   <%-- <script src="../scripts/DataTables.js" type="text/javascript"></script>--%>
</head>
<body>
    <script type="text/javascript">
        var Sort_SARUSRDEP = new Array(2); 
        Sort_SARUSRDEP[0] = [{ "bSortable": false }, null, null, null, null, null];
        Sort_SARUSRDEP[1] = [[1, "asc"]];

//        BotonesUsrdep = function (selec) {
//            if (selec > 0) { //Seleccionado
//                $("#AccReportes").hide();
//                $("#AccReportes2").show();
//            } else { //No Seleccionado
//                $("#AccReportes").show();
//                $("#AccReportes2").hide();
//            }
//        }

        $(document).ready(function () {
            //            NG.setNact(1, "Uno", BotonesUsrdep);
            NG.setNact(2, "Dos", null);
//            NG.Var[NG.Nact].botones(NG.Var[NG.Nact - 1].selec);
//            if (NG.Var[NG.Nact].oSets == null || acc_Val == 'nuev') {
              if (NG.Var[NG.Nact].oSets == null) {
                Ajax();
                SeleccionaDependencia();
            } else {
                NG.repinta();
            }
        });

        // Función que llena el Select de las dependencias.
        function Ajax() {
            var strParametros = "{}";
            $.ajax({
                url: "Usuario/SARUSRDEP.aspx/pLlenaSelect",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaSelect(eval('(' + reponse.d + ')'));
                    //console.log(reponse);
                },
                beforeSend: loading.ini(),
                complete: loading.close(),
                error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            })
        }

        // Función que arma el select con la lista de las dependencias.
        function PintaSelect(cadena) {
            listItem = '';
            for (a_i = 1; a_i < cadena.length; a_i++) {
                listItem += "<option value=" + cadena[a_i].nDepcia + " >" + cadena[a_i].sDDepcia + " </option>"; 
            }
            $("#slc_Usuarios").append(listItem);
        }

        // Función que sirve para el evento cuando cambia la opción seleccionada del select
        function SeleccionaDependencia() {
            $("#slc_Usuarios").change(function () {
                if (NG.Var[NG.Nact].oTable != null) {
                    NG.Var[NG.Nact].oTable.fnDestroy();
//                    NG.reset();
//                    NG.setNact(2, 'Dos', null);                    
                    Ajax2();
                } else {
                    Ajax2();
                }
            });
        }

        // Función que obtiene los usuarios asociados a la dependencia seleccionada.
        function Ajax2() {
            loading.ini();
            var strActionData = "{'nIdDepcia': '" + $("#slc_Usuarios option:selected").val() + "'}";
            //console.log($("#slc_Usuarios option:selected").val());
            $.ajax({
                url: "Usuario/SARUSRDEP.aspx/pPintaGrid",
                data: strActionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    PintaGrid_UsrDep(eval('(' + reponse.d + ')'));
                },
//                beforeSend: loading.ini(),
//                complete: loading.close(),
                error: function (result) {
                    loading.close();
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde", "SISTEMA DE ENTREGA - RECEPCIÓN");
                }
            });
        }

        // Función que pinta el grid de usuarios por dependencia.
        function PintaGrid_UsrDep(cadena) {
            $('#grid').empty();
            if (cadena.resultado == '2') {
                $('#grid').append('<tr><td class="Acen">' + cadena.mensaje + '</td></tr>');
                loading.close();
                return false;
            }
            $('#grid').append(pTablaI(cadena));
            a_di = new o_dialog('VER PERFILES');
            a_di.iniDial(); 
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SARUSRDEP[1],
                "aoColumns": Sort_SARUSRDEP[0]
            });
            loading.close();
            //NG.Var[NG.Nact].oTable = lTable;
        }

        // Función que arma la tabla de usuarios por dependencia.
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            //            htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:10%;" class="sorting" title="Ordenar">Número de personal</th>';
            htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting" title="Ordenar">Cuenta institucional</th>';
            htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
            htmlTab += '<th scope="col" style="width:15%;" class="sorting" title="Ordenar">Perfil</th>';
//            htmlTab += '<th scope="col" style="width:9%;" class="sorting" title="Ordenar">Disponibilidad</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                //                if (NG.Var[NG.Nact].selec == a_i) {
                //                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                //                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="Cambia(\'' + a_i + '\')" /></td>';
                //                } else {
                //                    htmlTab += '<tr id="tr_' + a_i + '" >';
                //                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="Cambia(\'' + a_i + '\')" /></td>';
                //                }
                htmlTab += '<tr id="tr_' + a_i + '" >';
                htmlTab += '<td class="sorts Acen">' + tab[a_i].intNumPersonal + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].strNombre + '</td>';
                htmlTab += '<td class="sorts Acen">' + tab[a_i].strCuenta + '</td>';
//                htmlTab += '<td class="sorts Acen">' + tab[a_i].strCorreo + '</td>';

                //htmlTab += '<td class="sorts Acen">' + tab[a_i].strsDCDepcia + '</td>';
                htmlTab += '<td class="sorts Acen">';
                htmlTab += '<div class="textoD">' + tab[a_i].strsDCDepcia + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCDepcia + '</div>';
                htmlTab += '</td>';
                
                //htmlTab += '<td class="sorts Acen">' + tab[a_i].strsDCPuesto + '</td>';
                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].strsDCPuesto + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCPuesto + '</div>';
                htmlTab += '</td>';
                
                //htmlTab += '<td class="sorts Acen">' + tab[a_i].strPerfil + '</td>';                
                if (tab[a_i].lstPerfiles.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN PERFIL</td>';
                    //                        htmlTab += '<td class="sorts">';
                    //                        htmlTab += '<div class="textoD">Sin perfil</div>';
                    //                        htmlTab += '<div class="tooltipD">Sin perfil</div>';
                    //                        htmlTab += '</td>';
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
//                if (tab[a_i].chrIndActivo == 's' || tab[a_i].chrIndActivo == 'S') {
//                    htmlTab += '<td class="sorts Acen">' + 'Si' + '</td>';
//                } else if (tab[a_i].chrIndActivo == 'n' || tab[a_i].chrIndActivo == 'N') {
//                    htmlTab += '<td class="sorts Acen">' + 'No' + '</td>';
//                }
            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }

        // Función que actualiza el grid de usuarios por dependencia.
        function ActualizarGrid() {
            //fn_cerrarPform();
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            Ajax2();
        }

        //Función que regresa al listado de usuarios.
        function fRegresar() {
            urls(1, "Usuario/SAMUSUARI.aspx");
        }
    </script>

    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion"> 
            <label class="titulo">Consulta de usuarios</label>
<%--            <div class="a_acciones"> /*MOSTRAR CUANDO YA SE TENGA EL REPORTE*/
                <a id="AccReportes" title="Reportes" href="j avascript:Reporte();" class="accAct">Reportes</a>
                <a id="AccReportes2" title="Reportes" class="accIna iOculto">Reportes</a>
            </div>--%>
        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 

        <div class="instrucciones">Seleccione la dependencia/entidad de la cual quiera ver los usuarios registrados en el sistema.</div>
        
        <div class="ui-widget">
            <select id="slc_Usuarios">
                <option value="0">[Elija una dependencia / entidad]</option>
            </select>            
        </div>

        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>
        
        <br />
        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
        </div> 

    </div>
    </form>
</body>
</html>
