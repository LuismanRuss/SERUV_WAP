<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA" Codebehind="SCAGEACTA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
 
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
</head>
<body>
    <script type="text/javascript">

        vDate = {
            dateFormat: 'dd-mm-yy',
            minDate: '-10Y',
            maxDate: '10Y',
            changeMonth: true,
            changeYear: true,
            numberOfMonths: 1,
            dayNamesMin: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'],
            monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo',
                    'Junio', 'Julio', 'Agosto', 'Septiembre',
                    'Octubre', 'Noviembre', 'Diciembre'],
            monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr',
                    'May', 'Jun', 'Jul', 'Ago',
                    'Sep', 'Oct', 'Nov', 'Dic']
        };

        $(document).ready(function () {
            loading.close();
            $("#txtFechaAutorizacion").mask("99-99-9999");
            $('#dFNombram').mask("99-99-9999");

            $('#txtFechaAutorizacion').datepicker(vDate);
            $('#dFNombram').datepicker(vDate);

            //var idParticipante = NG.Var[NG.Nact - 1].datoSel.nIdParticipante; 

            //fAjax(idParticipante);

        });

        function fAjax(idParticipante) {
//            var nIdUsuario = $("#hf_idUsuario").val();
            var variables = "{'nIdParticipante': '" + idParticipante +
            //                           "','nDepcia': '" + nDepcia +
//                            "','nIdUsuario': '" + nIdUsuario +
                                "'}";
            $.ajax({
                url: "SCAGEACTA.aspx/getDatosActa",
                data: variables,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    //fLlenarCampos(eval('(' + reponse.d + ')'));
                },
                beforeSend: loading.iniSmall(),
                complete: function () {
                    loading.closeSmall();
                },
                error: errorAjax
            });
        }

        function fLlenarCampos(datos) {
            console.log(datos);

            if (datos == 0) {
                var sDDepcia = NG.Var[NG.Nact - 1].datoSel.sDDepcia;
                $("#txtDependencia").val(sDDepcia);
            } else {
                $('input[name=TipoActa][value=' + datos[0].cTipoActa + ']').attr('checked', 'checked');
                $("#slctRegion option[value=" + datos[0].nFKsZona + "]").attr("selected", "selected");
                $("#txtDependencia").val(datos[0].sDDepcia);
                $("#txtCambioDe").val(datos[0].sCambioDe);

                $("#txtNumOficio").val(datos[0].sNumOficio);
                $("#txtFechaAutorizacion").val(datos[0].dFAutoriz);
                $("#txtNomEntrega").val(datos[0].uObligado);
                $("#txtNoPersEntrega").val(datos[0].nNumPerEntrega);
                $("#txtCargo").val(datos[0].sCargoEntrega);

                $("#txtNomRecibe").val(datos[0].uReceptor);
                 $("#txtNumPersonal").val(datos[0].nNumPerRecibe);
                $("#txtCargoRecibe").val(datos[0].scargoRecibe);                   
            }
        }

        function fCancelar() {
            urls(5, "SCSCIEDEP.aspx");
            NG.setNact(1, 'Uno', null);
        }

        function fn_accordion(a_num) {
            aa = '#sec' + a_num;
            bb = '#Tit_' + a_num;
            cc = "#d_l" + a_num;
            if ($(aa).is(':visible')) {
                $(aa).hide();
                $(bb).html('+').attr('title', 'Expandir');
                $(cc).attr('title', 'Expandir');
            } else {
                $(aa).show();
                $(bb).html('-').attr('title', 'Colapsar');
                $(cc).attr('title', 'Colapsar');
            }
        }

        function fGuardar() {
//            console.log(NG.Var[NG.Nact - 1].datoSel);
            var nDepcia = NG.Var[NG.Nact - 1].datoSel.nDepcia;
            var idPartcipante = NG.Var[NG.Nact - 1].datoSel.nIdParticipante;
            var idUsuario = $("#hf_idUsuario").val();
            
            $.alerts.dialogClass = "infoConfirm";
            jConfirm("¿Desea guardar los cambios?", "SISTEMA DE ENTREGA - RECEPCIÓN", function (r) {
                if (r) {
                    //                    loading.ini();
                    var strDatos = "{'nIdParticipante': '" + idPartcipante +
                                    "','nIdUsuario': '" + idUsuario +

                                    "','cTipoActa': '" + $("input[name=TipoActa]:checked").val() +
                                    "','nFKsZona': '" + $("#slctRegion option:selected").val() +
                                    "','nFKDepcia': '" + nDepcia +
                                    "','sCambioDe': '" + $("#txtCambioDe").val() +

                                    "','sNumOficio': '" + $("#txtNumOficio").val() +
                                    "','dFAutoriz': '" + $("#txtFechaAutorizacion").val() +
//                                    "','idFkUsuAuto': '" + $("#txtidFkUsuAuto").val() +
                    //                                "','idFkUsuEntre': '" + $("#txtNomEntrega").val() +
                    //                                "','nFkPuesto': '" + $("#txtnFkPuesto").val() +
                    //                                 "','sNomDepEnt': '" + $("#txtsNomDepEnt").val() +
                    //                                 "','sDomDepEnt': '" + $("#txtsDomDepEnt").val() +
                    //                                 "','dFNombram': '" + $("#txtdFNombram").val() +

                    //                                 "','sNomAutori': '" + $("#txtsNomAutori").val() +
                    //                                 "','idFKUsuRecibe': '" + $("#txtidFKUsuRecibe").val() +
                    //                                 "','iNumPerRec': '" + $("#txtiNumPerRec").val() +

                    //                                 "','idFKDomEntr': '" + $("#txtidFKDomEntr").val() +
                    //                                 "','sNomAdmon': '" + $("#txtsNomAdmon").val() +
                    //                                 "','iNumPerAdmon': '" + $("#txtiNumPerAdmon").val() +
                    //                                 "','idFKDomAdmon': '" + $("#txtidFKDomAdmon").val() +
                    //                                 "','idFKDomRecib': '" + $("#txtidFKDomRecib").val() +
                    //                                 "','sNomAudit': '" + $("#txtsNomAudit").val() +

                    //                                 "','sNomTest1': '" + $("#txtsNomTest1").val() +
                    //                                 "','iEdadTest1': '" + $("#txtiEdadTest1").val() +
                    //                                 "','sEdoCivilTest1': '" + $("#txtsEdoCivilTest1").val() +
                    //                                 "','sRFCTest1': '" + $("#txtsRFCTest1").val() +
                    //                                 "','sTrabTest1': '" + $("#txtsTrabTest1").val() +
                    //                                 "','sPuesTest1': '" + $("#txtsPuesTest1").val() +
                    //                                 "','idFKDomTest1': '" + $("#txtsPuesTest1").val() +

                    //                                 "','sNomTest2': '" + $("#txtNomTest2").val() +
                    //                                 "','iEdadTest2': '" + $("#txtiEdadTest2").val() +
                    //                                 "','sEdoCivilTest2': '" + $("#txtsEdoCivilTest2").val() +
                    //                                 "','sRFCTest2': '" + $("#txtsRFCTest2").val() +
                    //                                 "','sTrabTest2': '" + $("#txtsTrabTest2").val() +
                    //                                 "','sPuesTest2': '" + $("#txtsPuesTest2").val() +
                    //                                 "','idFKDomTest2': '" +$("#txtsPuesTest1").val()  +
                            "'}";

                    datosJSON = eval('(' + strDatos + ')');

                    actionData = frms.jsonTOstring({ objCierre: datosJSON });
                    console.log(actionData);
                    $.ajax({
                        url: "SCAGEACTA.aspx/GuardarActa",
                        data: actionData,
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (reponse) {
                            var op = reponse.d;
                            switch (op) {
                                case 1:
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert("La información fué guardada correctamente.", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                    break;

                                case 0:
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Error", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    break;

                                case 100:
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("La información ha cambiado, porfavor actualice su página", "SISTEMA DE ENTREGA - RECEPCIÓN");
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
            })
        }

        function fImprimir() {
        }

        function Bloque2() {
            urls(6, "SCAGEACTA2.aspx");
        }
        function Bloque3() {
            urls(6, "SCAGEACTA3.aspx");
        }
        function Bloque4() {
            urls(6, "SCAGEACTA4.aspx");
        }
        function Bloque5() {
            urls(6, "SCAGEACTA5.aspx");
        }

    </script>

    <form id="SCAGEACTA" runat="server">

    <div id="agp_contenido">
        <div class="a_bloques">
            <a id="DatosGenerales" title="Datos Generales" href="javascript:Bloque1();" class="accInaBloq">Datos Generales</a>
            <a id="Participantes" title="Participantes" href="javascript:Bloque2();" class="accBloq">Participantes</a>
            <a id="A1" title="Apartados" href="javascript:Bloque4();" class="accBloq">Testigos</a>
            <a id="Apartados" title="Apartados" href="javascript:Bloque3();" class="accBloq">Diligencias</a>
            <a id="A2" title="Apartados" href="javascript:Bloque5();" class="accBloq">Declaraciones</a>            
        </div>
        <div id="agp_navegacion">
            <label class="titulo">Acta entrega - recepción -> Datos Generales</label>
            <div class="a_acciones">
                <a id="AccGuardar" title="Guardar" href="javascript:fGuardar();" class="accAct ">Guardar</a>
                <%--          <a id="AccNotificaciones2" title="Notificaciones" class="accIna">Notificaciones</a>--%>
                 <a id="AccImprimir" title="Imprimir" href="javascript:fImprimir();" class="accAct ">Imprimir</a>
            </div>

        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)"
                onmouseout="MM_swapImgRestore()">
                <img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>
        </div>

        <div class="instrucciones"> ¿Instrucciones?</div>

        <%-----------------------------------------------FORMULARIO--------------------------------------------------------%>
        <div id="divDatosSuperior">
                <label>Tipo de acta:</label><input type="radio" id="rbtPrevia" name="TipoActa" value="P"/>
                <label>Previa</label><input type="radio" id="rbtDefinitiva" name="TipoActa" value="D"/>
                <label>Definitiva</label>
                <br />

                <label>Región:</label>
                <select id="slctRegion">
                    <option value="1">XALAPA</option>
                    <option value="2">VERACRUZ</option>
                    <option value="3">CORDOBA - ORIZABA</option>
                    <option value="4">POZA RICA - TUXPAN</option>
                    <option value="5">COATZACOALCOS - MINATITLÁN</option>
                </select>                
                <label>Dependencia o Entidad académica:</label><input type="text" size="105px" id="txtDependencia" />
                <br />

                <label>Acta definitiva de entrega-recepción por cambio de:</label><input type="text" id="txtCambioDe" size="150px"/>
        </div>

        <div id="titUNO" class="titSeccion" style="margin-top: 1em;">
            <div id="Tit_UNO" class="dActionA" onclick="fn_accordion('UNO')" title="Colapsar">-</div>
            <div class="dLabelA" onclick="fn_accordion('UNO')" id="d_lUNO" title="Colapsar">Información laboral</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desA" onmouseover="MM_swapImage('im_desA','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>
        
        <div id="secUNO" class="conSeccion">
            <%-- <label>Oficina:</label><input type="text" id="Text3" />
             <label>Dirección:</label><input type="text" id="Text4" />
             <label>ciudad:</label><input type="text" id="Text5" />--%>
            <label>Número de oficio:</label><input type="text" id="txtNumOficio" />
            <label>Fecha de autorización:</label><input type="text" id="txtFechaAutorizacion" />
            <label>Nombre de la persona que autorizó:</label><input type="text" id="txtPersAutorizo" size="80px"/>
            <label>Nombre de quien entrega:</label><input type="text" id="txtNomEntrega" size="150px"/>
            <label>Número de personal:</label><input type="text" id="txtNoPersEntrega" />
            <label>Puesto / cargo:</label><input type="text" id="txtCargo" size="225px"/>
            <label>Nombre de la dirección:</label><input type="text" id="txtNomDireccion" size="213px" />
            <label>Nombre de la entidad académica o dependencia:</label><input type="text" id="txtNomEntAca" size="179px" />
            <label>Domicilio de la entidad académica o dependencia:</label><input type="text" id="txtDomEntAca" size="178px"/>
            <label>Fecha del nombramiento:</label><input type="text" id="txtFecNombramiento" />
            <label>Autorizado por:</label><input type="text" id="txtAutorizadoPor" size="159px" />
            <label>Nombre de quien recibe:</label><input type="text" id="txtNomRecibe" size="153px"/>
            <label>Número de personal:</label><input type="text" id="txtNumPersonal" />
            <label>Puesto / cargo:</label><input type="text" id="txtCargoRecibe" size="225px"/>
            <label>Nombre de la dirección:</label><input type="text" id="txtNomDireccionRecibe" size="213px" />
            <label>Nombre de la entidad académica o dependencia:</label><input type="text" id="txtNomEntAcaRecibe" size="179px"/>
            <label>Domicilio de la entidad académica o dependencia:</label><input type="text" id="txtDomEntAcaRecibe" size="178px"/>                                  
        </div>
       <%-- <br />

        <div id="titDOS" class="titSeccion">
            <div id="Tit_DOS" class="dActionA" onclick="fn_accordion('DOS')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('DOS')" id="d_lDOS" title="Expandir">Diligencias</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desB" onmouseover="MM_swapImage('im_desB','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secDOS" class="conSeccion" style="display: none">
            <label>Fecha en que concluye el cargo:</label><input type="text"/>
        </div>--%>


<%--        <div id="titTRES" class="titSeccion">
            <div id="Tit_TRES" class="dActionA" onclick="fn_accordion('TRES')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('TRES')" id="d_lTRES" title="Expandir">TESTIGOS DE ASISTENCIA</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="im_desC" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secTRES" class="conSeccion" style="display: none">

        </div>

        <div id="titCUATRO" class="titSeccion">
            <div id="Tit_CUATRO" class="dActionA" onclick="fn_accordion('CUATRO')" title="Expandir">+</div>
            <div class="dLabelA" onclick="fn_accordion('CUATRO')" id="d_lCUATRO" title="Expandir">Diligencias</div>
            <div class="dIcoA"><img alt="Ir al final de la página" src="../images/sort_desc.gif" border="0" id="Img1" onmouseover="MM_swapImage('im_desC','','../images/sort_desc_disabled.gif',1)" onmouseout="MM_swapImgRestore()" /><a href="#a_abajo">Bajar</a></div>
        </div>

        <div id="secCUATRO" class="conSeccion" style="display: none">
            
        </div>--%>
            <%-----------------------------------------------------------------------------------------------------------------%>
        <br /><br />

        <div id="a_abajo"></div> <%--Capa para que vaya al final de la página--%>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresar','','../images/ico-regresarO.png',1)" onmouseout="MM_swapImgRestore()">
            <img id="btnregresar" alt="regresar" src="../images/ico-regresar.png" /></a>
        </div>

        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_NG" runat="server" />
        </div>
    </div>

    </form>
</body>
</html>
