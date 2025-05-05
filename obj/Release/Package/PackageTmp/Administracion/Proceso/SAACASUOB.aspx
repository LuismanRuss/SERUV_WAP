<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Administracion_General_Procesos_ER_SAACASUOB" Codebehind="SAACASUOB.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>
</head>
<body>
    <script type="text/javascript">
        var Sort_SAACASUOB = new Array(2);
        Sort_SAACASUOB[0] = [{ "bSortable": false }, null, null, null, null, null, null];
        Sort_SAACASUOB[1] = [[2, "asc"]];

        var idParticipante = 0;
        var idDependencia = null;
        var idProceso = null;
        var nombreProceso = null;
        var DepYsujOb; //ESTA VARIABLE ALMACENA LA CADENA JSON TRAÍDA DEL SERVIDOR

        BotonesSujObli = function (selec) {//FUNCIÓN QUE ACTIVA O DESACTIVA LOS BOTONES
            comboPro = $("#lbx_procER option:selected").val();
            comboDep = $("#lbx_depcia option:selected").val();
            comboPue = $("#lbx_cp option:selected").val();
            labelSuj = $('#lblSujObl').text();

            var op = "Debe seleccionar un puesto.";

            if (selec > 0 && labelSuj != "Debe seleccionar un puesto.") {//pregunto si ya seleccione un registro en el grid  para habilitar "GUARDAR"
                $("#Btn_Guardar,#Btn_Cancelar").show();
                $("#Btn_Guardar2,#Btn_Cancelar2").hide();
            } else {
                $("#Btn_Guardar2, #Btn_Cancelar").show();
                $("#Btn_Guardar,#Btn_Cancelar2").hide();
            }
        }


        function Ajax(idproceso) {//ESTA FUNCIÓN ME REGRESA EL JSON CON LOS DATOS DEL PROCESO PASÁNDOLE SU ID
            var actionData = "{'idproceso': '" + idproceso + "'}";//PARAMETROS
            $.ajax(
                {
                    url: "Proceso/SAACASUOB.aspx/fPinta_Grid",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                        fCargarListaProcER(eval('(' + reponse.d + ')'));
                        DepYsujOb = eval('(' + reponse.d + ')');
                        loading.close();
                    },
                    error: errorAjax
                });
        }

        $(document).ready(function () {
            idProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].nIdProceso; //ESTA VARIABLE CONTIENE EL ID DEL PROCESO EL CUAL OBTENGO DESDE EL OBJETO NG.
            nombreProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sProceso + ' ' + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sDPeriodo;//ESTA VARIABLE CONTIENE EL NOMBRE DEL PROCESO EL CUAL OBTENGO DESDE EL OBJETO NG.

            $("#lblIdProceso").text(nombreProceso);

            NG.setNact(2, 'Dos', BotonesSujObli);//LE ASIGNO NIVEL 2 AL OBJETO NG Y ESPECÍFICO LA FUNCIÓN DE BOTONES
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
            if (NG.Var[NG.Nact].oSets == null) {
                loading.ini();
                Ajax(idProceso);
            } else {
                NG.repinta;
            }
        });

//        function pMostrarGridPorProceso(proceso) {
//            var datosGrid = DepYsujOb.datos[0];
//            var grid = '';

//            if (DepYsujOb.datos[0].length == 0 || DepYsujOb.datos[0].length == null) {
//                Pinta_Grid('sinDatos');
//            } else {
//                grid += '[{}';
//                $.each(datosGrid, function (i, dato) {
//                    if (dato.nIdProceso == proceso) {
//                        grid += ',{';
//                        grid += '"idUsuario":"' + dato.idUsuario + '",';
//                        grid += '"nIdParticipante":"' + dato.nIdParticipante + '",';
//                        grid += '"idProceso":"' + dato.nIdProceso + '",';
//                        grid += '"sCuenta":"' + dato.sCuenta + '",';
//                        grid += '"sNombre":"' + dato.sNombre + '",';
//                        grid += '"sCorreo":"' + dato.sCorreo + '",';
//                        grid += '"sDDepcia":"' + dato.sDDepcia + '",';
//                        grid += '"sDPuesto":"' + dato.sDPuesto + '"';
//                        grid += '}';
//                    }
//                });
//                grid += ']';

//                if (NG.Var[NG.Nact].oTable != null) {
//                    $('#grid').empty();
//                    NG.Var[NG.Nact].oTable.fnDestroy();
//                    Pinta_Grid(eval('(' + grid + ')'));
//                }
//                else if (NG.Var[NG.Nact].oTable == null) {
//                    $('#grid').empty();
//                    //                 NG.Var[NG.Nact].oTable.fnDestroy();
//                    Pinta_Grid(eval('(' + grid + ')'));
//                }
//            }
//        }

        function Pinta_Grid(cadena) {
            $('#grid').empty();
            msj = { "msj": "No existen sujetos obligados disponibles para este proceso." }
            sinSeleccion = { "mensaje": "Debe seleccionar un proceso para mostrar los datos." }
            if (cadena == 'sinDatos') {
                $('#grid').append('<tr><td class="Acen">' + msj.msj + '</td></tr>');
                return false;
            } else if (cadena == 'sinSeleccion') {
                $('#grid').append('<tr><td class="Acen">' + sinSeleccion.mensaje + '</td></tr>');
                return false;
            }
            $('#grid').append(pTablaI(cadena.datos[0]));//MANDO A LLAMAR LA FUNCIÓN QUE PINTA EL GRID

            a_di = new o_dialog('Ver Perfiles');
            a_di.iniDial();
            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid')
                .dataTable({
                    "sPaginationType": "full_numbers",
                    "bLengthChange": true,
                    "aaSorting": Sort_SAACASUOB[1],
                    "aoColumns": Sort_SAACASUOB[0]
                });
        };

        function pTablaI(tab) {//ESTA FUNCIÓN PINTA EL GRID CON LAS DATOS DE LOS USUARIOS QUE PODRÁN SER SELECCIONADOS COMO SUJETOS OBLIGADOS.
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th class="no_sort" align="center" scope="col" style="width:3%;"></th>';
            htmlTab += '<th align="center" scope="col" style="width:6%;" class="sorting" title="Ordenar">Número de personal</th>';
            htmlTab += '<th align="center" scope="col" style="width:25%;" class="sorting" title="Ordenar">Nombre</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Correo institucional</th>';
            htmlTab += '<th align="center" scope="col" style="width:20%;" class="sorting" title="Ordenar">Dependencia / entidad</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Puesto / cargo</th>';
            htmlTab += '<th align="center" scope="col" style="width:15%;" class="sorting" title="Ordenar">Perfil</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";
            for (a_i = 1; a_i < tab.length; a_i++) {//RECORRO EL JSON
                if (NG.Var[NG.Nact].selec == a_i) {
                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="Cambia(\'' + a_i + '\')" /></td>';
                } else {
                    htmlTab += '<tr id="tr_' + a_i + '" >';
                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="Cambia(\'' + a_i + '\')" /></td>';
                }
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sCuenta + '</td>';
                htmlTab += '<td class="sorts">' + tab[a_i].sNombre + '</td>';
                htmlTab += '<td class="sorts Acen">' + tab[a_i].sCorreo + '</td>';

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sDDepcia + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sDDepcia + '</div>';
                htmlTab += '</td>';

                htmlTab += '<td class="sorts">';
                htmlTab += '<div class="textoD">' + tab[a_i].sDPuesto + '</div>';
                htmlTab += '<div class="tooltipD">' + tab[a_i].sDPuesto + '</div>';
                htmlTab += '</td>';

                if (tab[a_i].laPerfUsu.length == 0) {
                    htmlTab += '<td class="sorts Acen">SIN PERFIL</td>';
                } else {
                    if (tab[a_i].laPerfUsu.length == 1) {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD">' + tab[a_i].laPerfUsu[0].sDPerfil + '</div>';
                        htmlTab += '<div class="tooltipD">' + tab[a_i].laPerfUsu[0].sDPerfil + '</div>';
                        htmlTab += '</td>';
                    } else {
                        htmlTab += '<td class="sorts Acen">';
                        htmlTab += '<div class="textoD"><a class="ackDialog" href="#fixme">VER PERFILES..</a></div>';
                        htmlTab += '<div class="dialoG oculto"><ul>';
                        for (a_j = 0; a_j < tab[a_i].laPerfUsu.length; a_j++)
                            htmlTab += '<li>' + tab[a_i].laPerfUsu[a_j].sDPerfil + '</li>';
                        htmlTab += '</ul></div></td>';
                    }
                }
            }
            htmlTab += "</tr>";
            htmlTab += "</tbody>";
            return htmlTab;
        }

        function Cambia(selec) {
            NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            NG.cambia(selec);
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

            if ($("#lblSujObl").html() == "Debe seleccionar un puesto.") {//PREGUNTO SI YA SE SELECCIONÓ EL PROCESO Y LA DEPENDENCIA PARA ASIGNAR AL SUJETO OBLIGADO
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Debe seleccionar todas las opciones.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                BotonesSujObli(0);

                //---desselecciono el registro
                $('#ch_' + selec).attr('checked', false);
                $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
                NG.Var[NG.Nact].selec = 0;
                NG.Var[NG.Nact].datoSel = null;
                sel = false;
            } else {
                pVerificaProcesosAsignados(selec);
            }
        };

        function fCargarListaProcER(cadena) {//FUNCIÓN QUE PINTA POR PRIMERA VEZ LOS COMBOS DE LA FORMA
            var datos = cadena.datos[1];

            for (a_i = 0; a_i < datos.length; a_i++) {
                if (datos[a_i].laDependencias.length < 2) {
                    $('#lbx_depcia').empty();
                    $('#lbx_cp').empty();
                    for (i = 0; i < datos[a_i].laDependencias.length; i++) {
                        dependencias = $('<option></option>').val(datos[a_i].laDependencias[i].nDepcia).html(datos[a_i].laDependencias[i].sDDepcia);
                        for (j = 0; j < datos[a_i].laDependencias[i].laPuestos.length; j++) {//for puestos
                            puestos = $('<option></option>').val(datos[a_i].laDependencias[i].laPuestos[j].nPuesto).html(datos[a_i].laDependencias[i].laPuestos[j].sDPuesto)
                            if (datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length > 0) {
                                for (k = 0; k < datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length; k++) {//for sujobl
                                    sujetoObligado = datos[a_i].laDependencias[i].laPuestos[j].laSujObl[k].sNombre;
                                    $('#lblSujObl').text(sujetoObligado);
                                }
                            } else {
                                sujetoObligado = 'No existe un sujeto obligado asignado.';
                                $('#lblSujObl').text(sujetoObligado);
                            }
                            $('#lbx_cp').append(puestos);
                        }
                        $('#lbx_depcia').append(dependencias);
                        idParticipante = datos[a_i].laDependencias[i].idParticipante;
                        idDependencia = datos[a_i].laDependencias[i].nDepcia;
                    }
                    $('#lbx_cp').attr('disabled', false);
                } else {
                    for (i = 0; i < datos[a_i].laDependencias.length; i++) {
                        dependencias = $('<option></option>').val(datos[a_i].laDependencias[i].nDepcia).html(datos[a_i].laDependencias[i].sDDepcia);
                        $('#lbx_depcia').append(dependencias);
                    }
                    $('#lblSujObl').text('Debe seleccionar un puesto.');
                }
            }
        }

        function fCambiaCombo(sel, opcion) {//ESTA FUNCIÓN SE ENCARGA DEL MANEJO DE LOS COMBOS.
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec); //MANDO A LLAMAR LA FUNCIÓN DE BOTONES
            var datos = DepYsujOb.datos[1]; //asigno la parte del json correspondiente a proceso, dep, puesto etc a una variable
            seleccionado = sel; //asigno el parámetro sel a una variable

            switch (opcion) {
                case 'ProcER':
                    //                    pMostrarGridPorProceso(sel); //mando a llamar función para pintar Grid y le paso el id del proceso
                    BotonesSujObli(0);

                    $('#lbx_procER').empty();
                    $('#lbx_depcia').empty();
                    $('#lbx_cp').empty();
                    $('#lblSujObl').text('');
                    var sujetoObligado = '';

                    $('#lbx_depcia').attr('disabled', false); //habilito combo de dependencia
                    $('#lbx_cp').attr('disabled', true); //deshabilito el combo de puestos

                    for (a_i = 0; a_i < datos.length; a_i++) {//for procesos
                        procesos = $('<option></option>').val(datos[a_i].idProceso).html(datos[a_i].sDProceso);
                        if (datos[a_i].idProceso == seleccionado) {
                            if (datos[a_i].laDependencias.length == 0) {//pregunto si trae depcias
                                $('#lbx_depcia').append('<option value="default" selected="selected">No existen dependencias / entidades</option>');
                                $('#lbx_cp').append('<option value="default" selected="selected">No se puede mostrar el puesto / cargo</option>');
                            } else {
                                for (i = 0; i < datos[a_i].laDependencias.length; i++) {//for depcias
                                    dependencias = $('<option></option>').val(datos[a_i].laDependencias[i].nDepcia).html(datos[a_i].laDependencias[i].sDDepcia)
                                    for (j = 0; j < datos[a_i].laDependencias[i].laPuestos.length; j++) {//for puestos
                                        puestos = $('<option></option>').val(datos[a_i].laDependencias[i].laPuestos[j].nPuesto).html(datos[a_i].laDependencias[i].laPuestos[j].sDPuesto)
                                        if (datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length > 0) {
                                            for (k = 0; k < datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length; k++) {//for sujobl
                                                sujetoObligado = datos[a_i].laDependencias[i].laPuestos[j].laSujObl[k].sNombre;
                                            }
                                        } else {
                                            sujetoObligado = 'No existe un sujeto obligado asignado.';
                                        }
                                        $('#lbx_cp').append(puestos);
                                    } //for puestos
                                    $('#lbx_depcia').append(dependencias);
                                    idParticipante = datos[a_i].laDependencias[i].idParticipante;
                                    idDependencia = datos[a_i].laDependencias[i].nDepcia;
                                } //for depcias
                            } //if DE PREGUNTAR SI HAY DEPENDENCIAS
                        } //termina if
                        $('#lbx_procER').append(procesos);
                        $("#lbx_procER option[value='" + seleccionado + "']").attr("selected", "selected");
                    } //for procesos

                    if ($('#lbx_depcia option').length > 1) {//si el combo tiene mas de un elemento agrego una opción default
                        if ($('#lbx_cp option').length > 1) {
                            $('#lbx_cp').append('<option value="default" selected="selected">[Seleccione un puesto / cargo]</option>');
                            $('#lblSujObl').text("Debe seleccionar un puesto.");
                        }
                        $('#lbx_depcia').append('<option value="default" selected="selected">[Seleccione una dependencia / entidad]</option>');
                    } else {//si solo hay un elemento en el combo de las dependencias entonces habilito el combo de puestos
                        $('#lbx_cp').attr('disabled', false); //habilito combo de puesto
                        if (sujetoObligado != '') {//PREGUNTO SI LA VARIABLE DE SUJETO OBLIGADO VIENE VACÍA
                            $('#lblSujObl').text(sujetoObligado); //agrego al label del sujeto obligado el valor que trae el arreglo
                        } else {
                            $('#lblSujObl').text("No existe un sujeto obligado asignado.");
                        }
                    }

                    break;

                case 'Depcia':
                    $('#lbx_depcia').empty();
                    $('#lbx_cp').empty();
                    $('#lblSujObl').text('');

                    $('#lbx_cp').attr('disabled', false); //habilito combo de puesto
                    proc = $('#lbx_procER').val(); //obtengo el id del proceso seleccionado en el combo anterior

                    for (a_i = 0; a_i < datos.length; a_i++) {//for procesos
                        for (i = 0; i < datos[a_i].laDependencias.length; i++) {//for depcias
                            dependencias = $('<option></option>').val(datos[a_i].laDependencias[i].nDepcia).html(datos[a_i].laDependencias[i].sDDepcia);
                            if (datos[a_i].laDependencias[i].nDepcia == seleccionado) {
                                for (j = 0; j < datos[a_i].laDependencias[i].laPuestos.length; j++) {//for puestos
                                    puestos = $('<option></option>').val(datos[a_i].laDependencias[i].laPuestos[j].nPuesto).html(datos[a_i].laDependencias[i].laPuestos[j].sDPuesto)
                                    if (datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length > 0) {
                                        for (k = 0; k < datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length; k++) {//for sujobl
                                            sujetoObligado = datos[a_i].laDependencias[i].laPuestos[j].laSujObl[k].sNombre;
                                        }
                                    } else {
                                        sujetoObligado = 'No existe un sujeto obligado asignado.';
                                    }
                                    $('#lbx_cp').append(puestos);
                                    idParticipante = datos[a_i].laDependencias[i].idParticipante;
                                    idDependencia = datos[a_i].laDependencias[i].nDepcia;
                                } // termina for puestos
                            }
                            $('#lbx_depcia').append(dependencias);
                            idDependencia = datos[a_i].laDependencias[i].nDepcia;
                            $("#lbx_depcia option[value='" + seleccionado + "']").attr("selected", "selected");
                        } // termina for depcias
                    } //termina for procesos

                    if ($('#lbx_cp option').length > 1) {//si el combo tiene mas de un elemento agrego una opción default
                        $('#lbx_cp').append('<option value="default" selected="selected">[Seleccione un puesto / cargo]</option>');
                        $('#lblSujObl').text("Debe seleccionar un puesto.");
                    } else {
                        $('#lbx_cp').attr('disabled', false); //habilito combo de puesto
                        if (sujetoObligado != '') {//PREGUNTO SI LA VARIABLE DE SUJETO OBLIGADO VIENE VACÍA
                            $('#lblSujObl').text(sujetoObligado); //agrego al label del sujeto obligado el valor que trae el arreglo
                        } else {
                            $('#lblSujObl').text("No existe un sujeto obligado asignado.");
                        }
                    }

                    break;

                case 'cp':
                    $('#lbx_cp').empty();
                    $('#lblSujObl').text('');

                    for (a_i = 0; a_i < datos.length; a_i++) {
                        for (i = 0; i < datos[a_i].laDependencias.length; i++) {
                            for (j = 0; j < datos[a_i].laDependencias[i].laPuestos.length; j++) {
                                //pregunto si la lista de sujetos obligados trae mas de un registro
                                if (datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length > 0) {
                                    for (k = 0; k < datos[a_i].laDependencias[i].laPuestos[j].laSujObl.length; k++) {
                                        $('#lblSujObl').text(datos[a_i].laDependencias[i].laPuestos[j].laSujObl[k].sNombre);
                                        // idParticipante = datos[a_i].laDependencias[i].laPuestos[j].laSujObl[k].idParticipante;
                                    }
                                } else {
                                    $('#lblSujObl').text("No existe un sujeto obligado asignado.");
                                    //$('#lblSujObl').text("NO EXISTE SUJETO OBLIGADO ASIGNADO");
                                }
                            } //for puestos
                            $('#lbx_cp').append(puestos);
                        } //for depcias
                    } //for procesos
                    break;
            } //fin case
        }

        function pVerificaProcesosAsignados(selec) {//FUNCIÓN QUE VERIFICA SI YA SE SELECCIONÓ A ALGUN USUARIO DEL GRID
            if ($('#ch_' + selec).is(":checked")) {//SE PREGUNTA SI YA SE SELECCIONÓ A UN USUARIO EN EL GRID
                var idSujetoNuevo = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuario;
                var nombreSujetoNuevo = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sNombre;
                var datosGrid = DepYsujOb.datos[0];
                var textoAlert = '';
                var arregloDependencias = new Array();
                var nombreProceso = "";
                var nombreDepcia = "";

                var posicion = 0;
                do {//ciclo para obtener la posicion del participante en el json
                    posicion = posicion + 1;
                } while (datosGrid[posicion].idUsuario != idSujetoNuevo)

                if (datosGrid[posicion].laProcPorSujObl != 0) {
                    nombreProceso = datosGrid[posicion].laProcPorSujObl[0].sDProceso;
                    if (datosGrid[posicion].laProcPorSujObl[0].nIdProceso == idProceso) {
                        return 0;
                    } else {
                        textoAlert += "El usuario " + nombreSujetoNuevo + " ya se encuentra asignado como sujeto obligado en el proceso \n\n ";
                        textoAlert += nombreProceso + " en la dependencia(s): \n\n ";
                        for (k = 0; k < datosGrid[posicion].laProcPorSujObl[0].laDepSujObl.length; k++) {
                            nombreDepcia = datosGrid[posicion].laProcPorSujObl[0].laDepSujObl[k].sDDepcia;
                            textoAlert += " " + nombreDepcia + " \n\n";
                        }
                        BotonesSujObli(0);
                        textoAlert += "por lo que no se puede asignar como tal en el proceso seleccionado.";
                    }
                    $.alerts.dialogClass = "infoAlert";
                    jAlert(textoAlert, "SISTEMA DE ENTREGA - RECEPCIÓN")

                    //---desselecciono el registro
                    $('#ch_' + posicion).attr('checked', false);
                    $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
                    NG.Var[NG.Nact].selec = 0;
                    NG.Var[NG.Nact].datoSel = null;
                    sel = false;
                }
            }
        }


        function fAGuardar() {//ESTA FUNCIÓN HACE LA VALIDACIÓN ANTES DE MANDAR A GUARDAR AL SUJETO OBLIGADO
            var nIdParticipante = idParticipante;//ID del participante
            var idSujetoNuevo = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuario;//ID del usuario que sera configurado como SO
            var idPuesto = $("#lbx_cp option:selected").val();//Clave del puesto
            var nombreDepcia = $('#lbx_depcia option:selected').html();//nombre de la dependencia
            var nombreCargo = $('#lbx_cp option:selected').html();//nombre del cargo
            var nombreSujetoActual = $("#lblSujObl").html();//nombre del sujeto obligado actual
            var nombreSujetoNuevo = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].sNombre;//nombre del usuario que se configurará como SO
            var textoAlert = "";

            if (nombreSujetoActual == 'No existe un sujeto obligado asignado.') {//Pregunto si la dependencia no tiene sujeto obligado asignado
                textoAlert += "¿Está seguro de asignar a " + nombreSujetoNuevo + " \n\n";
                textoAlert += "como sujeto obligado en el proceso " + nombreProceso + ", \n\n";
                textoAlert += "de la dependencia/entidad  " + nombreDepcia + ",\n\n";
                textoAlert += "con puesto/cargo  " + nombreCargo + "?";
                $.alerts.dialogClass = "infoConfirm";
                jConfirm(textoAlert, "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                    if (r) {
                        loading.ini();
                        fGuardar(idSujetoNuevo, nIdParticipante, idProceso, idDependencia, idPuesto);//Se manda a llamar la función que realizará la acción de guardar
                    }
                });
            } else {
                textoAlert += "¿Está seguro que desea cambiar el sujeto obligado " + nombreSujetoActual + " \n\n";
                textoAlert += "por " + nombreSujetoNuevo + ", \n\n";
                textoAlert += "como sujeto obligado en el proceso " + nombreProceso + ", \n\n";
                textoAlert += "en la dependencia/entidad  " + nombreDepcia + ",\n\n";
                textoAlert += "del puesto/cargo  " + nombreCargo + "?";
                $.alerts.dialogClass = "infoConfirm";
                jConfirm(textoAlert, "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                    if (r) {
                        loading.ini();
                        fGuardar(idSujetoNuevo, nIdParticipante, idProceso, idDependencia, idPuesto); //Se manda a llamar la función que realizará la acción de guardar

                    }
                });
            }
        }

        function fGuardar(idSujetoNuevo, nIdParticipante, idProceso, idDependencia, idPuesto) {//FUNCION AJAX PARA GUARDAR AL SUJETO OBLIGADO.
            nIdUsuario = $("#hf_idUsuario").val();
            var actionData = "{'nIdParticipante': '" + nIdParticipante +
                             "','idUsuarioNuevo': '" + idSujetoNuevo +
                             "','idProceso': '" + idProceso +
                             "','nIdUsuario': '" + nIdUsuario +
                             "','idDependencia': '" + idDependencia +
                             "','idPuesto': '" + idPuesto +
                         "'}";
            $.ajax({
                url: "Proceso/SAACASUOB.aspx/CambSujObl",
                data: actionData,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    try {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0://ERROR
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //No se pudieron guardar los cambios
                                break;
                            case 100://SE LE PIDE AL USUARIO QUE ACTUALICE LA PÁGINA
                                loading.close();
                                $.alerts.dialogClass = "infoAlert";
                                jAlert("La información ha cambiado, porfavor actualice su página.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;

                            case 101://NO SE PUEDE GUARDAR PORQUE YA SE ENVIÓ LA ENTREGA DE LA DEPENDENCIA
                                loading.close();
                                $.alerts.dialogClass = "infoAlert";
                                jAlert("No se puede cambiar el sujeto obligado ya que la entrega de esta dependencia ya se ha enviado.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;

                            case 102:
                                loading.close();//NO SE PUEDE ASIGNAR EL SUJETO OBLIGADO PORQUE YA SE ENCUENTRA COMO ENLACE
                                $.alerts.dialogClass = "infoAlert";
                                jAlert("No se puede asignar el sujeto obligado ya que se encuentra como enlace operativo de esta dependencia.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;

                            case 103:
                                loading.close();//NO SE PUEDE ASIGNAR PORQUE YA SE ENCUENTRA SUPERVISANDO EL PROCESO
                                $.alerts.dialogClass = "infoAlert";
                                jAlert("No se puede asignar el sujeto obligado ya que se encuentra como supervisor de este proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;

                            case 1://ACCIÓN REALIZADA CORRECTAMENTE
                                pReiniciarCombos();
                                NG.Var[NG.Nact].datoSel = null;
                                NG.Var[NG.Nact].datos = null;
                                NG.Var[NG.Nact].selec = 0;
                                BotonesSujObli(0);
                                fActualizarGrid();
                                $.alerts.dialogClass = "correctoAlert";
                                loading.close();
                                jAlert("La acción fué realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                        }
                    } catch (err) {
                        txt = "Ha sucedido un error inesperado, inténtelo más tarde.\n\n";
                        txt += "descripción del error: " + err.message + "\n\n";
                        txt += "Actualice su página y vuelvalo a intentar.\n\n";
                        $.alerts.dialogClass = "errorAlert";
                        jAlert(txt, "SISTEMA DE ENTREGA - RECEPCIÓN");
                    }
                },
                error: errorAjax
            });
        }

        function pReiniciarCombos() {//FUNCIÓN QUE REINICIA LOS COMBOS CUANDO SE ACTUALIZA LA PÁGINA.
            $('#lbx_depcia').empty();
            $('#lbx_cp').empty();
            $('#lbx_cp').append('<option value="default" selected="selected">[Seleccione un puesto / cargo]</option>');
            $('#lbx_cp').attr('disabled', true);
            $('#lbx_depcia').append('<option value="default" selected="selected">[Seleccione una dependencia / entidad]</option>');
            $('#lblSujObl').text('');
        }


        function fActualizarGrid() {//FUNCIÓN QUE ACTUALIZA EL GRID
            $('#grid').empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            Ajax(idProceso);
        }

        function Cancelar() {//ESTA FUNCIÓN ME REGRESA A LA PÁGINA ANTERIOR
            urls(5, "Proceso/SAAPRCENTREC.aspx");
        }
    </script>
    <form id="form1" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion"> 
                <label class="titulo">Cambio de sujeto obligado</label>
            </div>
            
            <div class="instrucciones">Seleccione la información requerida:</div>

         <%--   <h6>Proceso entrega - recepción:</h6> <select id="lbx_procER" onchange="fCambiaCombo(this.value, 'ProcER')"><option>[Seleccione un proceso]</option></select>
            <br />--%>

            <h6>Proceso entrega - recepción:</h6> <label id="lblIdProceso"></label>
            <br />
            <h6>Dependencia / entidad:</h6> <select id="lbx_depcia"  onchange="fCambiaCombo(this.value, 'Depcia')"><option>[Seleccione una dependencia / entidad]</option></select>
            <br />
            <h6>Cargo / puesto:</h6> <select id="lbx_cp" disabled="disabled" onchange="fCambiaCombo(this.value, 'cp')"><option>[Seleccione un puesto / cargo]</option></select>
            <br />
            <h6>Sujeto obligado:</h6> <label id="lblSujObl"></label>
            <br />

            <div class="TablaGrid">
                <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display">
                </table>
            </div>

            <div class="a_botones">
                <a id="Btn_Guardar" class="btnAct" title="Botón Guardar" href="javascript:fAGuardar();">Guardar</a>                
                <a id="Btn_Cancelar" class="btnAct" title="Botón Cancelar" href="javascript:Cancelar();">Cancelar</a>                
            </div>

               <div id="div_ocultos">
                <asp:HiddenField ID="hf_idUsuario" runat="server" />
            </div>
        </div>
    </form>
</body>
</html>
