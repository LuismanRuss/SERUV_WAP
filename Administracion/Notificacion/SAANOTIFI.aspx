<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Proceso_SAANOTIFI" Codebehind="SAANOTIFI.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>

<script type="text/javascript">

    var nUsuario = $("#hf_idUsuario").val();

    //Bloque para el ordenamiento de columnas en el grid
    var Sort_SAANOTIFI = new Array(2);  
    Sort_SAANOTIFI[0] = [{ "bSortable": false }, null, null, null];
    Sort_SAANOTIFI[1] = [[1, "asc"]];

    // Función que cambia el estado de los botones de acuerdo al dato seleccionado
    BotonesSAANOTIFI = function (selec) {        
        if (selec > 0) {        // Seleccionado
            $("#AccAgregar, #AccModificar2, #AccEliminar2").hide();
            $("#AccAgregar2, #AccModificar, #AccEliminar").show();
        }
        else {                  // Sin seleccionar
            $("#AccAgregar, #AccModificar2, #AccEliminar2").show();
            $("#AccAgregar2, #AccModificar, #AccEliminar").hide();
        }
    }

    $(document).ready(function () {
    
        if (NG.Nact == 2) {
            NG.setNact(1, 'Uno', BotonesSAANOTIFI);
            selc = NG.Var[NG.Nact].selec;

            $('#ch_' + selc).attr('checked', false);
            $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
            NG.Var[NG.Nact].selec = 0;
            NG.Var[NG.Nact].datoSel = null;
            sel = false;
            BotonesSAANOTIFI(0);

            fAjax();
        } else if (NG.Nact == 1 || NG.Nact > 1) {
            //NG.setNact(0, 'Cero');
            sel = true;
            NG.setNact(1, 'Uno', BotonesSAANOTIFI);
            //NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            fAjax();
        }


    });
    //Función que envía una accion para obtener los datos que se pintarán en el Grid 
    function fAjax() {
        loading.ini();
        $('#grid').empty();
        var actionData = "{'strACCION': '" + "CONS_NOTIFI_TOTAL" + 
                        "'}";
        $.ajax(
                {
                    url: "Notificacion/SAANOTIFI.aspx/pPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {                         
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    error: //errorAjax
                            function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                }
            );
    }
       
    // Función que pinta la tabla
    function Pinta_Grid(cadena) {
        
        $('#grid').empty();
        mensaje = { "mensaje": "No existen datos con la opción seleccionada" }
        if (cadena == null) {
            loading.close();
            $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
            return false;
        }
        $('#grid').append(pTablaI(cadena));

        NG.tr_hover();
        tooltip.iniToolD('25%');
        
        NG.Var[NG.Nact].oTable = $('#grid').dataTable({
            "sPaginationType": "full_numbers",
            "bLengthChange": true,
            "aaSorting": Sort_SAANOTIFI[1],
            "aoColumns": Sort_SAANOTIFI[0]
        });
        
        loading.close();
    };

    //Función que se encarga de llenar la tabla con los datos que pintaran dentro del grid
    function pTablaI(tab) {
        
        NG.Var[NG.Nact].datos = tab;
        htmlTab = '';
        htmlTab += '<thead><tr>';
        htmlTab += '<th class="no_sort" scope="col" style="width:4%;"></th>';
        htmlTab += '<th scope="col" style="width:25%;" class="sorting" title="Ordenar">Asunto</th>';
        htmlTab += '<th scope="col" style="width:50%;" class="sorting" title="Ordenar">Mensaje</th>';
        htmlTab += '<th scope="col" style="width:20%;" class="sorting" title="Ordenar">Periodicidad</th>';

        htmlTab += '</tr></thead>';
        htmlTab += "<tbody>";

        for (a_i = 1; a_i < tab.length; a_i++) {
            if (NG.Var[NG.Nact].selec == a_i) {
                htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
                
            } else {
                htmlTab += '<tr id="tr_' + a_i + '" >';
                htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
            }

            htmlTab += '<td class="sorts">' + tab[a_i].strAsunto + '</td>';
            htmlTab += '<td class="sorts">' + tab[a_i].strMensaje + '</td>';

            if (tab[a_i].cLunes == 'S' && tab[a_i].cMartes == 'S' && tab[a_i].cMiercoles == 'S' && tab[a_i].cJueves == 'S'
            && tab[a_i].cViernes == 'S' && tab[a_i].cSabado == 'S' && tab[a_i].cDomingo == 'S') {
                htmlTab += '<td class="sorts Acen">' + 'DIARIO' + '</td>';
            } else { htmlTab += '<td class="sorts Acen">' + 'SEMANAL' + '</td>'; };
 
        }
        htmlTab += "</tr>";
        htmlTab += "</tbody>";
        return htmlTab;
    }
    // Función que cambia el valor del objeto NG , cuando cambiamos nuestra notificación seleccionada

    function fCambia(selec) {
        NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
        NG.cambia(selec);
        NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

    };

    // Función que manda a otra ventana para agregar una notificación
    function fAgregar() 
    {
        urls(4, "Notificacion/SAANOTIFIH.aspx");
    }

    // Función que manda un mensaje para confirmar la eliminación de una notificación, de aceptar manda el id a feliminaNotificacion
      function EliminaNotif() {
          notificacion = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].strAsunto

          $.alerts.dialogClass = "infoConfirm";
          jConfirm("¿Está seguro que desea eliminar la notificación de: " + notificacion + "?",  'SISTEMA DE ENTREGA - RECEPCIÓN',function (r) {
              if (r) {
                  feliminaNotificacion(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idNotifica);
              }
          });
          NG.repinta();
      }


      // Función que ira al servidor, y pregunta si la notificación esta asignada a un proceso,  de no estarlo la elimina, si se encuentra asignada a un proceso activo regresa un mensaje
      function feliminaNotificacion(idNotifica) {
      
          loading.ini();
          var strACCION = "CONS_NOTIPROC_ACT";
         
          var variables = "{'idNotifica': '" + idNotifica + "','strACCION': '" + strACCION +
          "','nUsuario': '" + nUsuario +    
                                    "'}";

          datosJSON = eval('(' + variables + ')');
          actionData = frms.jsonTOstring({ objNotificacion: datosJSON });

          $.ajax({
              url: "Notificacion/SAANOTIFI.aspx/fModificaNotificacion",
              data: actionData,
              dataType: "json",
              type: "POST",
              contentType: "application/json; charset=utf-8",
              success: function (reponse) {
                  var resp = reponse.d;

                  switch (resp) {
                      case false:
                          loading.close();
                          $.alerts.dialogClass = "errorAlert";
                          jAlert('No se pudo eliminar la notificación ya que se encuentra asociada a un proceso activo.', 'SISTEMA DE ENTREGA - RECEPCIÓN');
                          break;
                      case true:
                          loading.close();
                          $.alerts.dialogClass = "correctoAlert";
                          jAlert('La notificación fue eliminada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN');
                          $('#ch_' + selc).attr('checked', false);
                          $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
                          NG.Var[NG.Nact].selec = 0;
                          NG.Var[NG.Nact].datoSel = null;
                          sel = false;
                          BotonesSAANOTIFI(0);
                          fActualizarGrid();
                          break;
                  }
              },

              error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
          });
      }
        
        // Función que actualiza el Grid cuando se elimina/agrega una notificación
        function fActualizarGrid() {
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            fAjax();
        }
    
</script>

    <form id="SAANOTIFI" runat="server">
       <div id="agp_contenido">
            <div id="agp_navegacion">
                <label  id="titulo" class="titulo">Notificaciones</label>
                <div class="a_acciones">
                    <a id="AccAgregar" title="Agregar" href="javascript:fAgregar();" class="accAct">Agregar</a>
                    <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>                                 

                    <a id="AccModificar" title="Modificar" href="javascript:fAgregar();" class="accAct iOculto">Modificar</a>
                    <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>    
                                    
                    <a id="AccEliminar" title="Eliminar" href="javascript:EliminaNotif();" class="accAct iOculto">Eliminar</a>
                    <a id="AccEliminar2" title="Eliminar" class="accIna">Eliminar</a>                                                           
                </div>
            </div>

            <div class="instrucciones">Seleccione una notificación para realizar la acción correspondiente.</div>
             
            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div>  
        </div>   
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
        </div>

    </form>
</body>
</html>
