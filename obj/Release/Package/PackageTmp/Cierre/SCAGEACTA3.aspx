<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCAGEACTA3" Codebehind="SCAGEACTA3.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
 
    <script type="text/javascript">
        var Sort_SCAGEACTA3 = new Array(2);  /* Indicación de la ordenación por default del grid */
        Sort_SCAGEACTA3[0] = [{ "bSortable": false }, null, null];
        Sort_SCAGEACTA3[1] = [[1, "asc"]];


//        $(document).ready(function () {
//            var idParticipante;
//            NG.setNact(1, 'Uno', null);
//            //NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
//            //var idParticipante = NG.Var[NG.Nact - 1].datoSel.nIdParticipante;
//            if (NG.Var[NG.Nact].oSets == null) {
//                console.log("Ajax");
//                Ajax();
//            } else {
//                console.log("Repinta");
//                NG.repinta();
//            }

//        });

        $(document).ready(function () {
            var idParticipante;
            NG.setNact(2, 'Dos', null);

            //console.log(NG.Var[NG.Nact].datoSel);
            if (NG.Var[NG.Nact].datoSel == null) {
                $('#grid').empty();
                fGetApartados();

            } else {
                //fGetApartados();
                NG.repinta();
            }
        });



        function fGetApartados() {
            var strDatos = "{" +
                                "\"strAccion\": \"ACTA_APARTADOS\" " + 
                                "}";

            objApartados = eval('(' + strDatos + ')');
            actionData = frms.jsonTOstring({ objApartados: objApartados });
            //console.log(actionData);

            $.ajax(
                {
                    url: "SCAGEACTA3.aspx/Acta_Apartados",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        //console.log(eval('(' + reponse.d + ')'));
                        Pinta_Grid(eval('(' + reponse.d + ')'));
                    },
                    beforeSend: loading.ini(),
                    complete: loading.close(),
                    error: errorAjax
                }
            );
        }

        /***********     Fin Funcion Ajax Obtener Guias    ***********/


        /***********     Funcion Pintar Grid Guias     ***********/

        function Pinta_Grid(strCadena) {
            //console.log(strCadena);
            $('#grid').empty();
            mensaje = { "mensaje": "No existen apartados configurados." }
            if (strCadena.liApartados == null) {
                //alert("if");
                $('#grid').append('<tr><td class="Acen">' + mensaje.mensaje + '</td></tr>');
                return false;
            }
            else {
                //alert("else");
                $('#grid').append(pTablaI(strCadena.liApartados));
            }

            NG.tr_hover();
            tooltip.iniToolD('25%');
            //Inicio Ordenamiento columna
            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "aaSorting": Sort_SCAGEACTA3[1],
                "aoColumns": Sort_SCAGEACTA3[0]
            });
        }


        /***********     Fin Funcion Pintar Grid Guias    ***********/

        function pTablaI(tab) {
            //console.log("tab " + tab);
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';
            htmlTab += '<thead><tr>';
            //htmlTab += '<th class="no_sort Acen" scope="col" style="width:4%;"></th>';
            htmlTab += '<th scope="col" style="width:5%;" class="sorting Acen" title="Ordenar">Código</th>';
            htmlTab += '<th scope="col" style="width:80%;" class="sorting Acen" title="Ordenar">Apartado</th>';
            htmlTab += '<th scope="col" style="width:10%;" class="no_sort Acen" title="Ordenar">Acción</th>';

            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            for (a_i = 1; a_i < tab.length; a_i++) {
                htmlTab += '<tr>';
//                if (NG.Var[NG.Nact].selec == a_i) {
//                    htmlTab += '<tr id="tr_' + a_i + '" class="row_selected">';
//                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" /></td>';
////                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" checked="checked" onclick="fCambia(\'' + a_i + '\')" /></td>';

//                } else {
//                    htmlTab += '<tr id="tr_' + a_i + '" >';
//                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" /></td>';
////                    htmlTab += '<td class="sorts"><input id="ch_' + a_i + '" type="radio" onclick="fCambia(\'' + a_i + '\')" /></td>';
//                }

                htmlTab += '<td class="sorts">' + tab[a_i].strApartado + '</td>';

                htmlTab += '<td class="sorts">' + tab[a_i].strDescApartado + '</td>';
                //htmlTab += '<td class="sorts Acen"> Ap01 </td>';
                //htmlTab += '<td class="sorts Acen">' + tab[a_i].strApartado.toUpperCase() + '</td>';

                //htmlTab += '<td class="sorts"> Apartado 01</td>';
                //htmlTab += '<td class="sorts">' + tab[a_i].strDescApartado.toUpperCase() + '</td>';

                htmlTab += '<td class="sorts Acen"> <a  href ="javascript:fApartados(' + tab[a_i].idApartado+',\''+ tab[a_i].strApartado+'\',\''+ tab[a_i].strDescApartado + '\');" >Editar</a> </td>';

            }
            htmlTab += "</tr>";

            htmlTab += "</tbody>";
            return htmlTab;
        }

//        function fApartados(idApartado) {
//            urls(6, "SCAGEACTA6.aspx");
//        }

        function fApartados(idApartado, cApartado, dApartado) {
            //Asigno los valores a mis campos hidden de esta forma
            $("#hf_IdApartado").val(idApartado);
            $("#hf_cApartado").val(cApartado);
            $("#hf_dApartado").val(dApartado);
           
            switch(cApartado){
                case 'I':
                    //Ventana Dialog
                    dTxt = '<div id="dComent" title="Diligencias">';
                    dTxt += '<iframe id="frm_Usuarios" src="SCAGEACTA6.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                    dTxt += '</div>';
                    $('#frm_SCAGEACTA3').append(dTxt);
                    $("#dComent").dialog({
                        autoOpen: true,
                        height: 500,
                        width: 750,
                        modal: true,
                        resizable: false
                    });
                    break;
                case 'II':
                    //Ventana Dialog
                    dTxt = '<div id="dComent" title="Diligencias">';
                    dTxt += '<iframe id="frm_Usuarios" src="SCAGEACTA6.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                    dTxt += '</div>';
                    $('#frm_SCAGEACTA3').append(dTxt);
                    $("#dComent").dialog({
                        autoOpen: true,
                        height: 500,
                        width: 750,
                        modal: true,
                        resizable: false
                    });
                    break;
                case 'III':
                    //Ventana Dialog
                    dTxt = '<div id="dComent" title="Diligencias">';
                    dTxt += '<iframe id="frm_Usuarios" src="SCAGEACTA7.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                    dTxt += '</div>';
                    $('#frm_SCAGEACTA3').append(dTxt);
                    $("#dComent").dialog({
                        autoOpen: true,
                        height: 500,
                        width: 750,
                        modal: true,
                        resizable: false
                    });
                    break;
                case 'IV':
                    //Ventana Dialog
                    dTxt = '<div id="dComent" title="Diligencias">';
                    dTxt += '<iframe id="frm_Usuarios" src="SCAGEACTA15.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
                    dTxt += '</div>';
                    $('#frm_SCAGEACTA3').append(dTxt);
                    $("#dComent").dialog({
                        autoOpen: true,
                        height: 500,
                        width: 750,
                        modal: true,
                        resizable: false
                    });
                    break;
            }

        }

        function cancelar() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();             
        }

        function Bloque1() {
            urls(6, "SCAGEACTA.aspx");
        }

        function Bloque2() {
            urls(6, "SCAGEACTA2.aspx");
        }
        function Bloque4() {
            urls(6, "SCAGEACTA4.aspx");
        }
        function Bloque5() {
            urls(6, "SCAGEACTA5.aspx");
        }
    </script>
</head>
<body>
    <form id="frm_SCAGEACTA3" runat="server">
    <div id="agp_contenido">
        <div class="a_bloques">
           <a id="DatosGenerales" title="Datos Generales" href="javascript:Bloque1();" class="accInaBloq">Datos Generales</a>
            <a id="Participantes" title="Participantes" href="javascript:Bloque2();" class="accBloq">Participantes</a>
            <a id="A1" title="Apartados" href="javascript:Bloque4();" class="accBloq">Testigos</a>
            <a id="Apartados" title="Apartados" href="javascript:Bloque3();" class="accBloq">Diligencias</a>
            <a id="A2" title="Apartados" href="javascript:Bloque5();" class="accBloq">Declaraciones</a>
        </div>
        <div id="agp_navegacion">
            <label class="titulo">ACTA ENTREGA - RECEPCIÓN - Diligencias</label>
            <div class="a_acciones">
                <a id="AccGuardar" title="Guardar" href="javascript:fGuardar();" class="accAct ">Guardar</a>
                <a id="AccImprimir" title="Imprimir" href="javascript:fImprimir();" class="accAct ">Imprimir</a>
            </div>

        </div>

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)"
                onmouseout="MM_swapImgRestore()">
                <img id="Img1" alt="regresar" src="../images/ico-regresar.png" /></a>
        </div>

        <div class="TablaGrid">
            <table cellspacing="0" rules="all" id="grid" style="width: 99%;" class="display"></table>
        </div>
        <br />

        <div class="btnRegresar">
            <a title="Regresar pantalla anterior" href="javascript:fCancelar();" onmouseover="MM_swapImage('btnregresarA','','../images/ico-regresarO.png',1)"
                onmouseout="MM_swapImgRestore()">
                <img id="btnregresarA" alt="regresar" src="../images/ico-regresar.png" /></a>
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_IdApartado" runat="server" /> 
            <asp:HiddenField ID="hf_cApartado" runat="server" />
            <asp:HiddenField ID="hf_dApartado" runat="server" />
        </div>
    </div>
    </form>
</body>
</html>