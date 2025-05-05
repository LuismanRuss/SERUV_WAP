<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAMPERPRO" Codebehind="SAMPERPRO.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAMUSUARI = new Array(2);
        Sort_SAMUSUARI[0] = [{ "bSortable": false }, null, null, null, null, null, null];
        Sort_SAMUSUARI[1] = [[2, "asc"]];
        var idProceso;

        // Función de botones, para activar o desactivar los botones correspondientes a la selección o viceversa
        BotonesUsuario = function (selec) {
            if (selec > 0) {
                $("#accPerfil2").hide();
                $("#accPerfil").show();
            } else {
                $("#accPerfil2").show();
                $("#accPerfil").hide();
            }
        }

        // Document ready
        $(document).ready(function () {
            loading.ini();
            NG.setNact(2, 'Dos', BotonesUsuario);
            NG.Var[NG.Nact].selec = 0;
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            $("#lbl_Proceso").text(NG.Var[NG.Nact - 1].datoSel.sDPeriodo);
            idProceso = NG.Var[NG.Nact - 1].datoSel.nIdProceso;

            if (NG.Var[NG.Nact].oSets == null) {
                Ajax();
            } else {
                Ajax();
                //NG.repinta();
            }
        });

        // Función que regresa el listado de usuarios con sus perfiles asignados al proceso dado.
        function Ajax() {
            var actionData = "{'nIdProceso':'" + idProceso + "'}";
            $.ajax({
                url: "Proceso/SAMPERPRO.aspx/Pinta_Grid",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    Pinta_Grid(eval('(' + reponse.d + ')'));
                },
//                beforeSend: loading.ini(),
//                complete: loading.close(),
                error: errorAjax
            });
        }

        // Función que pinta grid de usuarios.
        function Pinta_Grid(cadena) {
            //console.log(cadena.datos);
            $('#grid').empty();
            //if (cadena.resultado == '2') {
            if (cadena == null || cadena == "") {
                $('#grid').append('<tr><td class="Acen">' + cadena.mensaje + '</td></tr>');
                loading.close();
                return false;
            }
            $('#grid').append(pTablaI(cadena));

            a_di = new o_dialog('Ver Perfiles');
            a_di.iniDial(); 

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAMUSUARI[1],
                "aoColumns": Sort_SAMUSUARI[0]
            });
            loading.close();
            //NG.Var[NG.Nact].oTable = lTable;
        };

        // Función que arma la tabla de usuarios.
        function pTablaI(tab) {
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:10%;" class="sorting" title="Ordenar">Número de Personal</th>';
            htmlTab += '<th align="center" scope="col" style="width:25%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th align="center" scope="col" style="width:5%;" class="sorting" title="Ordenar">Cuenta institucional</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Perfil</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="Cambia(\'' + a_i + '\')" /></td>';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="Cambia(\'' + a_i + '\')" /></td>';
                }

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

            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }

        // Función que abre la ventana para mostrar los perfiles que tiene asociado el usuario, en caso de tener más de un perfil.
        function fVtanaPerfiles() {
            dTxt = '<div id="dComent" title="Perfiles">';
            dTxt += '<iframe id="fr_SAIPERFIL" src="Proceso/SAIPERFIL.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            dTxt += '</div>';
            $('#form1').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 150,
                width: 200,
                modal: true,
                resizable: true
            });
        }

        // Función que cambia los valores del dato seleccionado.
        function Cambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

        };

        // Función que actualiza el grid de usuarios.
        function ActualizarGrid() {
            $("#grid").empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            Ajax();
        }

        // Función que manda a llamar la forma de asignación de perfiles.
        function Perfil() {
            loading.ini();
            urls(5, "Proceso/SAMPERPROH.ASPX");
        }

        // Función que regresa al listado de procesos.
        function fRegresar() {
            loading.ini();
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }

    </script>

    <form id="form1" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo" >Usuarios por Proceso</label>
                <div class="a_acciones">
                    <a id="accPerfil" title="Agregar" href="javascript:Perfil();" class="accAct">Asignar perfil</a>
                    <a id="accPerfil2" title="Agregar" class="accIna iOculto">Asignar perfil</a>
                </div>
            </div>

            <div class="btnRegresar">
                    <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

            <div class="instrucciones">Seleccione un usuario para realizar la acción correspondiente.</div>

            <h2>Proceso entrega - recepción:</h2><label id="lbl_Proceso"></label>
    
            <div class="TablaGrid">
                <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
            </div>
            <br /><br />
            <div class="btnRegresar">
                    <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div> 
        </div>
    </form>
</body>
</html>
