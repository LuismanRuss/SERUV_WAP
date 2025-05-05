<%@ Page Language="C#" AutoEventWireup="true" Inherits="Administracion_Guia_SAAASIGNA" Codebehind="SAAASIGNA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>      
   <link href="../Styles/SCIREGISTRO_LAYOUT.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/Proceso.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script type="text/javascript">

        var idGuia; //ID  de la guía
        var idApartado; // ID del aparatado;
        var idAnexo; // ID del anexo;
        var intIdAplicaSeleccionado; // ID del aplica seleccionado en la tabla

        // Document ready
        $(document).ready(function () {
            NG.setNact(4, 'Cuatro', null);
            loading.ini();
            $("#lbl_Guia").text(NG.Var[NG.Nact - 3].datoSel.strDGuiaER);
            $("#lbl_ClaveGuia").text(NG.Var[NG.Nact - 3].datoSel.strApartado);
            $("#lbl_Apartado").text(NG.Var[NG.Nact - 2].datoSel.strDescApartado);
            $("#lbl_Anexo").text(NG.Var[NG.Nact - 1].datoSel.strDAnexo);
            //$("#lbl_Anexo").text(NG.Var[NG.Nact - 1].datoSel.strCveAnexo + " " + NG.Var[NG.Nact - 1].datoSel.strDAnexo);
            //strCveAnexo
            idAnexo = NG.Var[NG.Nact - 1].datoSel.idAnexo;
            idGuia = NG.Var[NG.Nact - 3].datoSel.idGuiaER;
            idApartado = NG.Var[NG.Nact - 2].datoSel.idApartado;

            fGetBloques();
            //console.log(NG.Var[NG.Nact - 1].datoSel);
        });

        // Función que obtiene los bloques asignados para el anexo seleccionado.
        function fGetBloques() {
            var strParametros = "{'nIdAnexo':'" + idAnexo + "'}";
            $.ajax({
                url: "Guia/SAAASIGNA.aspx/pGetBloques",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    //console.log(eval('(' + reponse.d + ')'));
                    var resp = reponse;
                    switch (resp) {
                        case "0": // Si no seleccionaron ningún bloque.
                            pLlenaListaBloques(0);
                            break;
                        default:
                            pLlenaListaBloques(eval('(' + reponse.d + ')'));
                    }
                },
//                beforeSend: loading.ini(),
//                complete: loading.close(),
                error: // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        // Función que arma la lista de bloques.
        function pLlenaListaBloques(sBloques) {
            if (sBloques != 0) {
                if (sBloques.laAplica != null) {
                    a_i = 0;
                    htmlTab = "";
                    for (a_j = 0; a_j < sBloques.laAplica.length; a_j++) {
                        htmlTab += "<li><a href='javascript:fDependencias(" + sBloques.laAplica[a_j].idAplica + ");'>" + sBloques.laAplica[a_j].strDAplica + "</a></li>";
                    }
                    $("#ul_ListaBloques").append(htmlTab);
                } else {
                    $("#ul_ListaBloques").empty().append("No existen grupos de destinatarios configurados.");
                }
            } else {
                $("#ul_ListaBloques").empty().append("No existen grupos de destinatarios configurados.");
            }
            loading.close();
        }

        // Función que obtiene el listado de dependencias asociadas al bloque seleccionado
        function fDependencias(nIdAplica) {
            loading.ini();
            intIdAplicaSeleccionado = nIdAplica;
            var strParametros = "{'nIdAplica':'" + nIdAplica +
                                "','nIdAnexo':'" + idAnexo +
                                "'}";
            $.ajax({
                url: "Guia/SAAASIGNA.aspx/pGetDependencias",
                data: strParametros,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    //console.log(eval('(' + reponse.d + ')'));
                    var resp = reponse;
                    switch (resp) {
                        case "-1": // NO SE PUDO EJECUTAR EL QUERY
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La base de datos no está disponible.
                            break;
                        case "0": // NO HAY DEPENDENCIAS ASOCIADAS A UN PROCESO DEL BLOQUE SELECCIONADO
                            pPintaDependencias(0);
                            break;
                        default:
                            pPintaDependencias(eval('(' + reponse.d + ')'));
                    }
                },
                //                beforeSend: loading.ini(),
                //                complete: loading.close(),
                error:
                         // errorAjax
                        function (result) {
                            loading.close();
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
            });
        }

        // Función que pinta las dependencias asociadas y marca las que esten asignadas al anexo seleccionado, por default todas estan asignadas.
        function pPintaDependencias(sDependencias) {
            if (sDependencias != 0) {
                htmlTab = "";
                strListaChecks = "";
                for (a_i = 0; a_i < sDependencias.length; a_i++) {
                    if (sDependencias[a_i].cIndAplicaAnexo == 'S') {
                        htmlTab += "<li><input type='checkbox' id=" + sDependencias[a_i].nDepcia + " checked='checked' ><label>" + sDependencias[a_i].sDDepcia + "</label></li>";
                    } else {
                        htmlTab += "<li><input type='checkbox' id=" + sDependencias[a_i].nDepcia + " ><label>" + sDependencias[a_i].sDDepcia + "</label></li>";
                    }
                }
                $("#ul_ListaDependencias").empty().append(htmlTab);
                ClickCheck();
            } else {
                $("#ul_ListaDependencias").empty().append("No existen dependencias / entidades configuradas.");
            }

            // Para aplicar color en la lista que ha sido seleccionada
            $("#ul_ListaBloques li").click(function () {
                $("#ul_ListaBloques li").removeClass("active");
                $(this).addClass("active");
            });
            loading.close();
        }

        // Función que se ejecuta cuando marcan un checkbox y realiza asignación o desasignación del anexo a esa dependencia.
        function ClickCheck() {
            $('input[type=checkbox]').click(function () {
                loading.ini();
                var cIndActivo;
                if ($(this).is(":checked")) {
                    cIndActivo = 'S';
                } else {
                    cIndActivo = 'N';
                }
                var strParametros = "{'nidAplica':'" + intIdAplicaSeleccionado +
                                    "','nIdDepcia': '" + $(this).attr("id") +
                                    "','nIdAnexo': '" + idAnexo +
                                    "','cIndActivo': '" + cIndActivo +
                                    "'}";
                $.ajax({
                    url: "Guia/SAAASIGNA.aspx/pActualizaAsignacion",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(eval('(' + reponse.d + ')'));
                        var resp = reponse.d;
                        switch (resp) {
                            case 0: // El query no se ejecuto correctamente
                                loading.close();
                                $.alerts.dialogClass = "incompletoAlert";
                                jAlert("La operación no pudo ser realizada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                            case 1: // Se realizó correctamente la asignación
                                loading.close();
                                //jAlert("Los datos del usuario se han actualizado correctamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                break;
                        }
                    },
                    error: 
                            function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                });
                //loading.close();
            });
        }

        // Función que regresa al listado de anexos.
        function fRegresar() {
            NG.Var[NG.Nact - 1].repinta = "S";
            urls(3, "Guia/SAAANEXOS.aspx");
        }
    </script>
    
    
    <form id="form1" runat="server">
        <div id="agp_contenido">
            <div id="agp_navegacion">
                <label class="titulo">Asignación</label>            
            </div>
            <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresarA" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 

            <div class="instrucciones"></div>

            <h2>Guía:</h2><label id="lbl_Guia"></label>
            <h2>Apartado:</h2> <label id="lbl_ClaveGuia"></label> <label id="lbl_Apartado"></label>
            <h2>Anexo:</h2><label id="lbl_Anexo"></label>
            <br />
        
            <%--<div id="dib_Bloques" class="easyui-layout" style="width: 800px; height: 250px;" data-options="fit:true">
                <div title="SECTORES" data-options="region:'west',split:false" style="width: 600px;">
                    <ul id="ul_ListaBloques"></ul>
                </div>
                <div title="DEPENDENCIAS" data-options="region:'center',iconCls:'icon-ok'" style="width:200px;">
                    <ul id="ul_ListaDependencias"></ul>
                </div>
            </div>--%>
            <div id="titulos">
                <div style="text-align:center; font-weight: bold; border: 1px solid #d0d0d0; width: 48.5%; height:20px; float:left; background-color:#F5F5F5; display:inline-block;">
                    SECTORES
                </div>
                <div style="text-align:center; font-weight: bold; width: 49.5%; height:20px; float:right; border: 1px solid #d0d0d0; margin-right: 11px; background-color:#F5F5F5; display:inline-block;">
                    DEPENDENCIAS / ENTIDADES
                </div>                
            </div>
            <div id="dib_Bloques" class="easyui-layout" style="width: 99%; height: 450px; border-style:solid; border-color:Black">                
                <div style="border: 1px solid #d0d0d0; width: 49%; height:400px; float:left; display:inline-block;">
                    <ul id="ul_ListaBloques" style="font-size:10pt; font-family:Arial"></ul>
                </div>
                <div style="width: 50%; height:400px; float:right; border: 1px solid #d0d0d0; display:inline-block; overflow:auto;">
                    <ul id="ul_ListaDependencias" style="font-size:10pt; font-family:Arial"></ul>
                </div>
                <div style="clear:both" ></div>
                <%--<br />--%>
            </div>

            <br /><br />

    <div class="btnRegresar">
                <a title="Regresar pantalla anterior" href="javascript:fRegresar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="btnregresar" alt="Botón regresar" src="../images/ico-regresar.png" /></a>            
            </div> 
    </div>
    </form>
</body>
</html>
