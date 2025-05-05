<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAAPSUJRE" Codebehind="SAAPSUJRE.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAAPSUJRE = new Array(2);
        Sort_SAAPSUJRE[0] = [{ "bSortable": false }, null, null];
        Sort_SAAPSUJRE[1] = [[2, "asc"]];
        var idParticipante = null;
        var idProceso = null;

        BotonesSAAPSUJRE = function (selec) {
            if (selec > 0) {//pregunto si ya seleccione un registro en el grid y si ya seleccione el combo de procesos para habilitar "GUARDAR"
                $("#Btn_Guardar2,#Btn_Cancelar2").hide();
                $("#Btn_Guardar,#Btn_Cancelar").show();
            }
            else {// No Seleccionado
                $("#Btn_Guardar2, #Btn_Cancelar").show();
                $("#Btn_Guardar,#Btn_Cancelar2").hide();
            }
        }


        function fAjax(nIdParticipante) {//FUNCIÓN QUE REGRESA LOS USUARIOS QUE PODRAN SER CONFIGURADOS COMO SUJETOS RECEPTORES EN ESTA DEPENDENCIA
            var actionData = "{'nIdParticipante': '" + nIdParticipante +
                             "','idProceso': '" + idProceso +
                         "'}";
            $.ajax(
                {
                    url: "Proceso/SAAPSUJRE.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                });
        }

        $(document).ready(function () {
            $("#lblProcER").text(NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sProceso + ' ' + NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sDPeriodo);
            $("#lblDepcia").text(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDDepcia);
            var nIdParticipante = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdParticipante;
            idParticipante = nIdParticipante;
            idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso;

            NG.setNact(3, 'Tres', BotonesSAAPSUJRE);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            if (NG.Var[NG.Nact].oSets == null) {
                fAjax(nIdParticipante);
            } else {
                NG.repinta();
            }
        });

        function Pinta_Grid(cadena) {//FUNCIÓN QUE PINTA EL GRID
            $('#grid').empty();
            mensaje = { "mensaje": "No existen usuarios receptores disponibles." }
            if (cadena == null || cadena[1] == null) {
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena));//mando a llamar la función que pinta el grid

            a_di = new o_dialog('Ver Perfiles');
            a_di.iniDial();
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAAPSUJRE[1],
                "aoColumns": Sort_SAAPSUJRE[0]
            });
        };


        function pTablaI(tab) {//FUNCIÓN QUE PINTA EL GRID
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:4%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:75%;" class="sorting" title="Ordenar">Nombre usuario</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Perfil</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                }

                htmlTab += '<td class="sorts">' + tab[a_i].sNombre + '</td>';
                if (tab[a_i].laPerfiles.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN PERFIL</td>';
                } else {
                    if (tab[a_i].laPerfiles.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laPerfiles[0].sDPerfil + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laPerfiles[0].sDPerfil + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER PERFILES..</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laPerfiles.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laPerfiles[a_j].sDPerfil + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function fCambia(selec) {//FUNCIÓN QUE ACTIVA O DESACTIVA LOS BOTONES
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        };

        function pGuardar() {//FUNCIÓN QUE MUESTRA UN ALERT PARA CONFIRMAR LA ACCIÓN DE GUARDAR EL SUJETO RECEPTOR
            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Está seguro de asignar a:  " + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sNombre + " como sujeto receptor de esta dependencia?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    loading.ini();
                    fGuardar();
                }
            })
        }

        function fGuardar() {//FUNCIÓN QUE GUARDA AL SUJETO RECEPTOR
            var nIdUsuario = $("#hf_idUsuario").val();
            var variables = "{'nIdSujRecp': '" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuario +
                            "','nIdParticipante': '" + idParticipante +
                            "','nIdUsuario': '" + nIdUsuario +
                            "'}";
            $.ajax({
                url: "Proceso/SAAPSUJRE.aspx/fGuardarSujRec",
                data: variables,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    var resp = reponse.d;
                    var separar = resp.split(',');
                    var respuesta = separar[0];
                    var idPart = separar[1];

                    switch (respuesta) {
                        case '0'://ERROR
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                        case '100'://SE REQUIERE ACTUALIZAR LA PÁGINA
                            loading.close();
                            $.alerts.dialogClass = "infoAlert";
                            jAlert("La información ha cambiado, porfavor actualice su página", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;

                        case '101'://NO SE PUEDE ASIGNAR PORQUE YA SE ENCUENTRA COMO SUPERVISOR
                            loading.close();
                            $.alerts.dialogClass = "infoAlert";
                            jAlert("No se puede asignar al usaurio seleccionado ya que se encuentra como supervisor en este proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;

                        case '102'://NO SE PUEDE ASIGNAR PORQUE LA DEPENDENCIA SE ENCUENTRA CERRADA
                            loading.close();
                            $.alerts.dialogClass = "infoAlert";
                            jAlert("No se puede asignar al usuario seleccionado ya que la dependencia se encuentra cerrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;

                        case '1'://ACCIÓN REALIZADA CORRÉCTAMENTE
                            loading.close();
                            fActualizarGrid(idPart);
                            $.alerts.dialogClass = "correctoAlert";
                            jAlert("El sujeto receptor ha sido guardado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            break;
                    }
                },
                beforeSend: loading.iniSmall(),
                complete: function () {
                    loading.closeSmall();
                },
                error: errorAjax
            });
        }


        function fActualizarGrid(idPart) {//FUNCION QUE ACTUALIZA EL GRID Y EL JSON
            NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].sNombreR = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sNombre;
            NG.Var[NG.Nact - 1].datos[NG.Var[NG.Nact - 1].selec].nIdParticipante = idPart;
            urls(5, "Proceso/SAAPARTIC.aspx");
        }

        function fRegresar() {//ME REGRESA A LA FORMA DE PARTICIPANTES
            loading.ini();
            urls(5, "Proceso/SAAPARTIC.aspx");
        }
  
    </script>
    <form id="SAAPSUJRE" runat="server">
          <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Sujeto receptor</label>         
            </div>
           <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>  
                    
            <br />
            <h2>Proceso entrega - recepción:</h2> <label id="lblProcER"></label>
            <br />

            <h2>Dependencia / entidad:</h2> <label id="lblDepcia"></label>

            <div class="instrucciones">Seleccione un sujeto receptor para realizar las acciones correspondientes:</div>
             
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div> 
            <div class="a_botones">
                <a id="Btn_Guardar" class="btnAct" title="Botón Guardar" href="javascript:pGuardar();">Guardar</a>
                <a id="Btn_Guardar2" class="btnIna" title="Botón Guardar">Guardar</a>
                <a id="Btn_Cancelar" class="btnAct" title="Botón Cancelar" href="javascript:fRegresar();">Cancelar</a>
                <a id="Btn_Cancelar2" class="btnIna" title="Botón Cancelar">Cancelar</a>    
            </div>
            <br /><br />

            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>            
            </div>  

            <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
            </div>
        </div>   
    </form>
</body>
</html>
