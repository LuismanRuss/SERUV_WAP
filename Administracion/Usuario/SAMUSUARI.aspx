<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_SAMUSUARI" Codebehind="SAMUSUARI.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>     
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <link href="../Styles/Usuario.css" rel="stylesheet" type="text/css" />  
      
</head>
<body>

<script type="text/javascript">
    var Sort_SAMUSUARI = new Array(2);  /* Indicación de la ordenación por default del grid */
    Sort_SAMUSUARI[0] = [{ "bSortable": false }, null, null, null, null, null, null, null];
    Sort_SAMUSUARI[1] = [[2, "asc"]];


    BotonesUsuarios = function (selec) {
        if (selec > 0) { //Seleccionado
            $("#AccAgregar, #AccModificar2, #AccModificarEstado2, #AccReportes2, #AccConsulta, #AccTitular, #AccDepartamentos").hide();
            $("#AccAgregar2, #AccModificar, #AccModificarEstado, #AccReportes, #AccConsulta2, #AccTitular2, #AccDepartamentos2").show();
        } else { //No Seleccionado
            $("#AccAgregar, #AccModificar2, #AccModificarEstado2, #AccReportes2, #AccConsulta, #AccTitular, #AccDepartamentos").show();
            $("#AccAgregar2, #AccModificar, #AccModificarEstado, #AccReportes, #AccConsulta2, #AccTitular2, #AccDepartamentos2").hide();
        }
    }

    $(document).ready(function () {
        //            alert(NG.Nact);
        NG.setNact(1, 'Uno', BotonesUsuarios);
        NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        //ActualizarGrid();
        if (NG.Var[NG.Nact].oSets == null) {
            Ajax();
        } else {
            Ajax();
            //NG.repinta();
        }
    });

    // Función que se encarga de traer los datos de los usuarios para mostrarlos en el grid.
    function Ajax() {
        loading.ini();
        $.ajax({
            url: "Usuario/SAMUSUARI.aspx/Pinta_Grid",
            // data: actionData,
            dataType: "json",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function (reponse) {
                Pinta_Grid(eval('(' + reponse.d + ')'));
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

    // Función que pinta el grid con los datos del usuario
    function Pinta_Grid(cadena) {
        $('#grid').empty();
        //if (cadena.resultado == '2') {
        if (cadena == null || cadena == "") {
            loading.close();
            $('#grid').append('<tr><td class="Acen">' + cadena.mensaje + '</td></tr>');
            return false;
        }

        $('#grid').append(pTablaI(cadena));

        //            a_di = new o_dialog('Ver Perfiles');
        //            a_di.iniDial(); 

        //            NG.tr_hover();
        //            tooltip.iniToolD('45%');

        a_di = new o_dialog('VER PERFILES');
        a_di.iniDial();
        NG.tr_hover();
        tooltip.iniToolD('45%');

        //Inicio Ordenamiento columna
        NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SAMUSUARI[1],
                "aoColumns": Sort_SAMUSUARI[0]
            });
            //NG.Var[NG.Nact].oTable = lTable;
            loading.close();
    };

    // Función que se encarga de armar la tabla con los datos de los usuarios.
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
            if (NG.Var[NG.Nact].selec == a_i) {
                htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
                htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="Cambia(\'' + a_i + '\')" /></td>';
            } else {
                htmlTab += '<tr id="tr_' + a_i + '" >';
                htmlTab += '<td class="sorts Acen"><input id="ch_' + a_i + '" type="radio" onclick="Cambia(\'' + a_i + '\')" /></td>';
            }

            htmlTab += '<td class="sorts Acen">' + tab[a_i].intNumPersonal + '</td>';


            /*htmlTab += '<td class="sorts">' + tab[a_i].strNombre + '</td>';*/
            htmlTab += '<td class="sorts">';
            htmlTab += '<div class="textoD">' + tab[a_i].strNombre + '</div>';
            htmlTab += '<div class="tooltipD">' + tab[a_i].strNombre + '</div>';
            htmlTab += '</td>';

            htmlTab += '<td class="sorts Acen">' + tab[a_i].strCuenta + '</td>';

            //htmlTab += '<td class="sorts">' + tab[a_i].strsDCDepcia + '</td>';
            htmlTab += '<td class="sorts">';
            htmlTab += '<div class="textoD">' + tab[a_i].strsDCDepcia + '</div>';
            htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCDepcia + '</div>';
            htmlTab += '</td>';

            /*htmlTab += '<td class="sorts Acen">' + tab[a_i].strsDCPuesto + '</td>';*/
            htmlTab += '<td class="sorts">';
            htmlTab += '<div class="textoD">' + tab[a_i].strsDCPuesto + '</div>';
            htmlTab += '<div class="tooltipD">' + tab[a_i].strsDCPuesto + '</div>';
            htmlTab += '</td>';

            //htmlTab += '<td class="sorts Acen">' + tab[a_i].strsDCPerfil + '</td>';

            if (tab[a_i].lstPerfiles.length == 0) {
                htmlTab += '<td class="sorts Acen">SIN PERFIL</td>';
            } else {
                if (tab[a_i].lstPerfiles.length == 1) {
                    //htmlTab += '<td class="sorts Acen">' + tab[a_i].lstPerfiles[0].strsDCPerfil + '</td>';
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

    // Función que cambia los valores del dato seleccionado en el grid.
    function Cambia(selec) {
        NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
        NG.cambia(selec);
        NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);

    };

    // Función que llama a la forma de Agregar Usuario
    function Agregar() {
        loading.ini();
        urls(1, "Usuario/SACUSUARI.ASPX");
    }

    // Función que llama a la forma de modificar usuario
    function Modificar() {
        loading.ini();
        urls(1, "Usuario/SACUSUARI.ASPX");
    }

    function Solicitud() {
        urls(1, "../Solicitud/SSASOLPRO.aspx");
    }


    // Función que valida si un usuario se encuentra en un proceso activo y en dicho caso no permitir cambiar la disponibilidad
    function ValidaEnProceso() {
        var strMensajeProcesos = "";
        var intIdProceso;
        var intSinProcesos = 0;
        if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].chrIndActivo.toUpperCase() == "S") {
            for (a_i = 0; a_i < NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstProcesos.length; a_i++) {
                intIdProceso = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstProcesos[a_i].idProceso;
                if (intIdProceso != 0) {
                    if (fValidaProcesoActivo(intIdProceso)) {
                        //$.alerts.dialogClass = "infoAlert";
                        //jAlert("El usuario se encuentra configurado en un proceso activo " + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstProcesos[a_i].strDProceso + " no se puede cambiar la disponibilidad del mismo.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        strMensajeProcesos += "<p>" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstProcesos[a_i].strDProceso + " </p>";
                        //strMensaje += "<p>no se puede cambiar la disponibilidad del mismo.</p>"
                        intSinProcesos = intSinProcesos + 1;
                        //a_i = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].lstProcesos.length;
                    }
                }
            }
            if (intSinProcesos == 0) {
                ModfEdo();
            } else {
            var strMensaje = "";
                if (intSinProcesos == 1) {
                    strMensaje += "<p>El usuario se encuentra configurado en el proceso activo: </p> </br>";
                }else{
                    strMensaje += "<p>El usuario se encuentra configurado en los procesos activos: </p> </br>";
                }
                strMensajeProcesos += "</br> <p>por lo que no se puede cambiar la disponibilidad del mismo.</p>"
                strMensaje += strMensajeProcesos;
                $("#dialog-message").empty();
                //console.log("entra");
                $("#dialog-message").append(strMensaje);

                $("#dialog-message").dialog({
                    modal: true,
                    width: 800,
                    height: 200,
                    buttons: {
                        Aceptar: function () {
                            $(this).dialog("close");
                        }
                    }
                });


                //loading.close();
            }
        } else {
            ModfEdo();
        }
    }

    // Función que realiza la consulta si el usuario se encuentra en proceso activo.
    function fValidaProcesoActivo(nidProceso) {
        var blnRespuesta = false;
        var strParametros = "{'nidProceso':'" + nidProceso + "'}";
        $.ajax(
                {
                    url: "Usuario/SAMUSUARI.aspx/ValidaProceso",
                    data: strParametros,
                    dataType: "json",
                    async: false,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        var resp = reponse.d;
                        switch (resp) {
                            case 0:
                                blnRespuesta = false;
                                break;
                            case 1:
                                blnRespuesta = true;
                                break;
                        }
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                }
            );
                return blnRespuesta;
    }

    // Función que cambia la disponibilidad de un usuario.
    function ModfEdo() {
        var strEstado1, strEstado2;
        if (NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].chrIndActivo.toUpperCase() == "S") {
            strEstado1 = "SÍ";
            strEstado2 = "NO";
            blnEstado = false;
            //if (confirm("¿Desea dejar no disponible al usuario?")) {
            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Desea quitar la disponibilidad del usuario?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    ModificaEdo(blnEstado, strEstado2);
                }
            });
        } else {
            strEstado1 = "NO";
            strEstado2 = "SÍ";
            blnEstado = true;
            //if (confirm("¿Desea dejar disponible al usuario ?")) {
            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Desea dejar disponible al usuario ?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    ModificaEdo(blnEstado, strEstado1);
                }
            });
        }
    }

    // Función que modifica el indicador de activo del usuario en la BD.
    function ModificaEdo(bEstado, sEstado2) {
        var actionData = "{'nidUsuario': '" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuario +
                            "','strIndActivo': '" + NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].chrIndActivo +
                            "'}";
        $.ajax({
            url: "Usuario/SAMUSUARI.aspx/ModificaEdo",
            data: actionData,
            dataType: "json",
            async: false,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function (reponse) {
                var resp = reponse.d;
                switch (resp) {
                    case 0:
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no se completó.
                    case 1:
                        ActualizarGrid();
                        $.alerts.dialogClass = "correctoAlert";
                        jAlert("La disponibilidad del usuario se ha actualizado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                        //break;
                }
            },
            beforseSend: loading.iniSmall(),
            complete: function () {
                loading.closeSmall();
            },
            error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
        });
    }

    // Función que actualiza el grid
    function ActualizarGrid() {
        $("#grid").empty();
        NG.Var[NG.Nact].oTable.fnDestroy();
        Ajax();
    }

    // Función que llama a la forma de usuarios por dependencia
    function Consulta() {
        loading.ini();
        urls(1, "Usuario/SARUSRDEP.aspx");
    }

    // Función que llama a la forma del reporte
    function Reporte() {
        var idUsuario = NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec].idUsuario;
        //$("#hf_operacion").val(op);
        //console.log(idUsuario);
        //alert("1");
        dTxt = '<div id="dComent" title="SERUV - Reporte">';
        dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?IdItem=' + idUsuario + '&op=PERFILUSUARIOPROC' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
        dTxt += '</div>';
        $('#frm_Usuarios').append(dTxt);
        $("#dComent").dialog({
            autoOpen: true,
            height: $(window).height() - 60,  //800,
            width: $("#agp_contenido").width() - 50, //1100,
            modal: true,
            resizable: true,
            close: function (event, ui) {
                fCerrarDialog();
            }
        });
    }

    //Función que llama a la forma de cambio de titular
    function Titular() {
        loading.ini();
        urls(1, "Usuario/SACTITULA.aspx");
    }

    //Función que llama a la forma de alta de departamentos
    function Departamentos() {
        loading.ini();
        urls(1, "Usuario/SAMDEPTOS.aspx");
    }
    /*Función que se utiliza cuando se cierra el dialog*/
    function fCerrarDialog() {
        $('#dComent').dialog("close");
        $("#dComent").dialog("destroy");
        $("#dComent").remove();
    }

    </script>

    <form id="frm_Usuarios" runat="server">
    <div id="agp_contenido">      
        <div id="agp_navegacion">
            <label class="titulo">Usuarios</label>                
            <div class="a_acciones">
                <a id="AccAgregar" title="Agregar" href="javascript:Agregar();" class="accAct">Agregar</a>
                <a id="AccAgregar2" title="Agregar" class="accIna iOculto">Agregar</a>
            
                <a id="AccModificar" title="Modificar" href="javascript:Modificar();" class="accAct iOculto">Modificar</a>
                <a id="AccModificar2" title="Modificar" class="accIna">Modificar</a>

                <a id="AccModificarEstado" title="Disponibilidad" href="javascript:ValidaEnProceso();" class="accAct iOculto">Disponibilidad</a>
                <a id="AccModificarEstado2" title="Disponibilidad" class="accIna">Disponibilidad</a>    
                
                <a id="AccConsulta" title="Cambiar Sujeto Obligado" href="javascript:Consulta();" class="accAct iOculto">Consulta</a>
                <a id="AccConsulta2" title="Cambiar Sujeto Obligado" class="accIna">Consulta</a>

                <a id="AccTitular" title="Cambio de Titular" href="javascript:Titular();" class="accAct">Cambio de Titular</a>
                <a id="AccTitular2" title="Cambio de Titular" class="accIna iOculto">Cambio de Titular</a>

                <a id="AccDepartamentos" title="Alta de Departamentos" href="javascript:Departamentos();" class="accAct">Departamentos</a>
                <a id="AccDepartamentos2" title="Alta de Departamentos" class="accIna iOculto">Departamentos</a>

                <a id="AccReportes" title="Reporte de los perfiles de un usuario" href="javascript:Reporte();" class="accAct iOculto">Reporte</a>
                <a id="AccReportes2" title="Reporte de los perfiles de un usuario" class="accIna">Reporte</a>

                <%--<a id="A1" title="Reporte de los perfiles de un usuario" href="javascript:Solicitud();" class="accAct">Solicitud</a>--%>
            </div>
        </div>    
        <div class="instrucciones">Seleccione un usuario para realizar la acción correspondiente.</div>
    
        <div class="TablaGrid">
            <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
        </div>

    </div>
    </form>

    <div id="dialog-message" title="SISTEMA DE ENTREGA - RECEPCIÓN">
    </div>
</body>
</html>
