/* LIBRERIA DE OBJETOS PRINCIALES 
 * JSieti.js 
 * Version 2.5
 *
 *
 *
 *
 */
/************************************   CARGANDO-LOADING   **********************************/
loading = {
    msj: 'Cargando datos...',
    img: '../images/loading.gif',
    ini: function() {
        alto = $(window).height();
        $('body').append('<div class="loading"><img src="' + loading.img + '" alt="Cargando" /><div>' + loading.msj + '</div></div>');
        $('.loading').css("height", alto);
        $('.loading').fadeTo(0, 0.85);
        $('.loading h5').fadeTo(0, 100);
    },
    close: function() {
        $('.loading').remove();
    },
    iniSmall: function() {
        $(".preloader").css("visibility", "visible");
    },
    closeSmall: function() {
        $(".preloader").css("visibility", "hidden");
    }
};
/*************************************   TOOLTIPS   ***********************************/
tooltip = {
    getool: function(tam, nombre, ancho) { //Pinta el campo que usará el tooltip
        nombre = String(nombre);
        tool = (nombre.length > tam) ? nombre.substring(0, tam - 3) + '...<div class="' + ancho + '">' + nombre + '</div>' : nombre;
        return tool;
    },
    iniTool: function(id) { //Inicializa los efectos a los elementos que usen tooltip
        id = (id == undefined) ? '.tooltip' : id;
        //console.log(id);
        $(id).bind("mouseover", function() {
            $(this).children("div").css({ display: "block", position: "absolute" });
        });
        $(id).bind("mouseout", function() {
            $(this).children("div").css({ display: "none" });
        });
    },
    del: function(id) { //Inicializa los efectos a los elementos que usen tooltip
        id = (id == undefined) ? '.tooltip' : id;
        //console.log(id);
        $(id).unbind("mouseover");
    },
    iniToolD: function(l_anc) { //Inicializa los efectos a los elementos que usen tooltip Dinamico
        $('.tooltipD').css({ 'width': l_anc });            
        $('td').bind("mouseover", function() {
            $(this).children('.tooltipD').css({ 'display': 'block' });
        });
        $('td').bind("mouseout", function() {
            $(this).children('.tooltipD').css({ 'display': 'none' });
        });
    }
}
/*************************   Objeto para dialogo en grids   *****************************/
o_dialog = function(tit) {
    this.ancho = '45%'; //ANCHO DEL POPUP
    this.titulo = tit; //TITULO DEL POPUP
    this.cloclick = '.ackDialog'; //ID o CLASS del OBJETO que tendra la funcion CLICK que pinta el DIALOG
    this.idobtext = 'div.dialoG'; //ID o CLASS del OBJETO que contiene el TEXTO para mostrar en el DIALOG
    this.iddialog = 'ojsdialog'; //ID o CLASS del DIALOG a crear
    //console.log('Se crea objeto nuevo ' + tit);
    this.constructor = function(titulo, ancho, ck, txt, di) {
        //console.log('Entra constructor');
        this.ancho = ancho;
        this.titulo = titulo;
        this.cloclick = ck;
        this.idobtext = txt;
        this.iddialog = di;
    };
    this.iniDial = function() {
        ldia = this.iddialog;
        ltit = this.titulo;
        ltxt = this.idobtext;
        lanc = this.ancho;
        //console.log('Entra iniDial');
        $(this.cloclick).bind("click", function() {
            $('#' + ldia).dialog("destroy");
            $('#' + ldia).remove();
            aux_d = '<div id="' + ldia + '" title="' + ltit + '">';
            aux_d += $(this).parent().parent().children(ltxt).html();
            aux_d += '</div>';
            //console.log(aux_d);
            $('body').append(aux_d);
            $('#' + ldia).dialog({
                autoOpen: true,
                modal: true,
                width: lanc
            });
        });
    };
    this.inicia = function() {
        //console.log('Entra inicia');
        $('#' + this.iddialog).dialog({
            modal: true,
            width: this.ancho
        });
    };
};
/*********************************   Objeto para mensajes    *****************************/
msjs = {
exito: 'Operaci\u00f3n realizada con \u00e9xito',
error: 'Error al realizar la operaci\u00f3n',
exitoCargaInsumo: 'La informaci\u00f3n ha sido cargada en el SIETI, ser\u00e1 revisada por el personal correspondiente y en caso de encontrar alguna observaci\u00f3n, se les avisar\u00e1 a m\u00e1s tardar en 3 d\u00edas h\u00e1biles v\u00eda correo electr\u00f3nico'
};

/****************************    Objeto para ELEMENTOS de FORMULARIO    ************************/
frms = {
    valida: function() { //Validar campos con atributo requerido [required="required"]
        bol = true;
        $('input[required="required"], select[required="required"]').each(
            function() {
                id = $(this).attr("id");
                $("#" + id + " + div.required").remove();
                if (frms.trim($("#" + id).val()) == '') {
                    $("#" + id).after('<div class="required" >&nbsp; * Campo Requerido</div>');
                    bol &= false;
                } else {
                    $("#" + id + " + div.required").remove();
                }
            }
        );
        return bol;
    }, 
    validaMar: function() { //Validar campos con atributo requerido [required="required"]
        bol = true;
        $('input[required="required"], select[required="required"]').each(
            function() {
                id = $(this).attr("id");
                if (frms.trim($("#" + id).val()) == '') {
                    $("#" + id + " + div.requerido").css("visibility", "visible");
                    bol &= false;
                } else {
                    $("#" + id + " + div.requerido").css("visibility", "hidden");
                }
            }
        );
        return bol;
    },
    urlNavegacion: function(div,urlNavegacion) {
        $.ajax(
                {
                    url: urlNavegacion,
                    cache: false,
                    success: function(message) {
                        $("#" + div).empty().append(message);

                    }
                });
    },
    validaRequeridos: function() { //Validar campos con atributo requerido [required="required"]
        bol = true;
        $('input[required="required"], select[required="required"]').each(
            function() {
                id = $(this).attr("id");
                if (frms.trim($("#" + id).val()) == '' || $("#" + id).val() == '0') {
                    $("#" + id + " + div.requerido").css("visibility", "visible");
                    bol &= false;
                } else {
                    $("#" + id + " + div.requerido").css("visibility", "hidden");
                }
            }
        );
        return bol;
    },
    validaSoloUno: function() {
        bol = false;
        $('input[required="required"], select[required="required"]').each(
             function() {
                 if (!$(this).attr("disabled")) {
                     id = $(this).attr("id");
                     if (frms.trim($("#" + id).val()) == '' || $("#" + id).val() == '0') {
                         $("#" + id + " + div.requerido").css("visibility", "visible");
                     } else {
                         $("#" + id + " + div.requerido").css("visibility", "hidden");
                         bol |= true;
                     }
                 }
             }
        );
        return bol;
    },
    trim: function(cadena) { //Limpia espacios en blanco al inicio y final de una cadena de texto
        cadena = String(cadena);
        var retorno = cadena.replace(/^\s+/g, '');
        retorno = retorno.replace(/\s+$/g, '');
        return retorno;
    },
    creaCombo: function(ID_cbo, datosJSon) { //Crea combo si establecer una opcion seleccionada
        $(ID_cbo).empty();
        datason = eval(datosJSon);
        for (j = 0; j < datason.length; j++)
            $(ID_cbo).append('<option value="' + datason[j].valor + '">' + datason[j].texto + '</option>');
    },
    jsTOs: function(obj) {
        var t = typeof (obj);
        if (t != "object" || obj === null) {
            // simple data type
            if (t == "string") obj = '"' + obj + '"';
            return String(obj);
        } else {
            // recurse array or object
            var n, v, json = [], arr = (obj && obj.constructor == Array);
            for (n in obj) {
                v = obj[n]; t = typeof (v);
                if (t == "string") v = '"' + v + '"';
                else if (t == "object" && v !== null) v = frms.jsTOs(v);
                json.push((arr ? "" : '"' + n + '":') + String(v));
            }
            return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
        }
    },
    jsonTOstring: function(obj) {
        aux_obj = frms.jsTOs(obj);
        return aux_obj.replace(new RegExp(/\\/g), '\\\\');
    }
}

/****************************     Objeto para funciones de fechas      ************************/
calen = {
    meses: ['', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo',
                    'Junio', 'Julio', 'Agosto', 'Septiembre',
                    'Octubre', 'Noviembre', 'Diciembre'],
    validaFecha: { //Validaciones de fechas
        mesAnterior: function(ID_fecha) { //ID DEL TEXTO DE LA FECHA Que la fecha ingresada sea el mes anterior
            var auxFecha = new Date();
            mes = auxFecha.getMonth() + 1;
            if (mes == 1)
                mes = 12;
            else
                mes--;

            fec = String($(ID_fecha).val());

            arr = fec.split("-");

            if (Number(arr[1]) != mes) {
                alert('El periodo a cargar corresponde a ' + calen.meses[mes]);
                return false;
            } else {
                return true;
            }
        },
        dosFechas: function(fecMen, fecMay) {//yyyy-mm-dd
            //console.log(fecMen);
            //console.log(fecMay);
//            pF1 = fecMen.split('-');
//            fec1 = new Date(pF1[0], pF1[1] - 1, pF1[2]);
//            pF2 = fecMay.split('-');
//            fec2 = new Date(pF2[0], pF2[1] - 1, pF2[2]);
            //console.log(fec1);
            //console.log(fec2);
        //return false;
            var a, b;
            pF1 = fecMen.split('-');
            a = pF1[2] + "-" + pF1[1] + "-" + pF1[0];
            //fec1 = new Date(pF1[0], pF1[1] - 1, pF1[2]);
            fec1 = new Date(Date.parse(a));


            pF2 = fecMay.split('-');
            b = pF2[2] + "-" + pF2[1] + "-" + pF2[0];
            //fec2 = new Date(pF2[0], pF2[1] - 1, pF2[2]);
            fec2 = new Date(Date.parse(b));
            if (fec1 < fec2) {
                return true;
            } else {
                return false;
            }
        },
        FechaMI: function(fecMen, fecMay) {//yyyy-mm-dd
            var a, b;
            pF1 = fecMen.split('-');
            a = pF1[2] + "-" + pF1[1] + "-" + pF1[0];
            //fec1 = new Date(pF1[0], pF1[1] - 1, pF1[2]);
            fec1 = new Date(Date.parse(a));


            pF2 = fecMay.split('-');
            b = pF2[2] + "-" + pF2[1] + "-" + pF2[0];
            //fec2 = new Date(pF2[0], pF2[1] - 1, pF2[2]);
            fec2 = new Date(Date.parse(b));

            //return false;
            if (fec1 <= fec2) {
                return true;
            } else {
                return false;
            }
        }
    },
    getMesAnt: function() {
        var auxFecha = new Date();
        mes = auxFecha.getMonth() + 1;
        year = auxFecha.getFullYear();
        dia = 1;
        if (mes == 1) {
            mes = 12;
            year--;
        } else {
            mes--;
        }

        dia = (dia < 10) ? '0' + dia : dia;
        mes = (mes < 10) ? '0' + mes : mes;

        return year + '-' + mes + '-' + dia;
    },
    convert: function(fec) {
        //console.log(fec);
        afe = new Date(fec);
        //console.log(afe);
        adi = (Number(afe.getDate()) < 10) ? '0' + afe.getDate() : afe.getDate();
        ame = (Number(afe.getMonth()) < 10) ? '0' + afe.getMonth() : afe.getMonth();
        aan = afe.getFullYear();
        return aan + '-' + ame + '-' + adi;
    }
}

/***********************************         Navegadores        ********************************/

var userAgent = navigator.userAgent.toLowerCase();
jQuery.browser = {
    version: (userAgent.match(/.+(?:rv|it|ra|ie|me)[\/: ]([\d.]+)/) || [])[1],
    chrome: /chrome/.test(userAgent),
    safari: (/webkit/.test(userAgent) && !/chrome/.test(userAgent)),
    opera: /opera/.test(userAgent),
    msie: (/msie/.test(userAgent) && !/opera/.test(userAgent)),
    mozilla: (/mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent))
};

/****************************     Navegacion en grids por niveles     ***************************/

var NG = { //Navegacion en grids, segun niveles
    Nact: 0, //Nivel actual
    colorBG: '#6FA7D1', //color de fondo
    colorBGO: '', //color de fondo original del seleccionado

    Var: [{ //Variables para pintar grid
        nombre: 'Cero',
        selec: 0, //Numero de registro Seleccionado
        oTable: null, //Objeto de la tabla
        oSets: null, //Objeto con la configuracion de la tabla
        js_data: null, //
        datos: new Array(), //Todos los elementos que se pintan en el grid
        datoSel: null //Los valores del registro seleccionado
}],
        setNact: function(actual, nombre, lbotones) {
            //console.log(NG);
            NG.Nact = actual;
            if (!(actual in NG.Var)) {//Agrega variables a nivel si no existe
                NG.Var.push({
                    nombre: nombre,
                    idGRID: '#grid',
                    selec: 0,
                    color: '',
                    oTable: null,
                    oSets: null,
                    datos: new Array(),
                    datoSel: null,
                    js_data: null,
                    botones: lbotones
                    //                    botones: function(sel) { botones(sel); },
                    //                    botones: function(sel, val) { botones(sel, val); }
                });
            }
            //console.log(NG.Var.length);
            if (NG.Var.length > actual) { //elimina variables de niveles superiores al actual
                NG.Var.splice(actual + 1, NG.Var.length - actual);
            }
        },
        reset: function() { //restablece variables
            NG.Var = [NG.Var[0]];
        },
        limpiaNivel: function(nivel) {
            //console.log(nivel);
            NG.Var[nivel].selec = 0; //Seleccionado
        },
        cambia: function(selc) { //SOLO PERMITE SELECCIONAR UN REGISTRO
            sel = false;
            if (selc == NG.Var[NG.Nact].selec) {// DESELECCIONA: SI nuevo == anterior 
                $('#ch_' + selc).attr('checked', false);
                $('#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
                NG.Var[NG.Nact].selec = 0;
                NG.Var[NG.Nact].datoSel = null;
                sel = false;
            } else {//SELECCIONA : SI nuevo != al anterior 
                //obtiene color natural del anterior
                var nodes = NG.Var[NG.Nact].oTable.fnGetNodes();
                //console.log(nodes);
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).removeClass('row_selected');
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).find('#ch_' + NG.Var[NG.Nact].selec).attr('checked', false);
                $('#ch_' + selc).attr('checked', true);
                NG.Var[NG.Nact].selec = selc;
                a_jp = frms.jsonTOstring(NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
                //NG.Var[NG.Nact].datoSel = JSON.parse(a_jp);
                NG.Var[NG.Nact].datoSel = jQuery.parseJSON(a_jp);
                //console.log(NG.Var[NG.Nact].datoSel);
                //NG.Var[NG.Nact].datoSel = $.extend([], NG.Var[NG.Nact].datos[NG.Var[NG.Nact].selec]);
                //console.log(NG.Var[NG.Nact].datoSel);
                //color
                $(nodes).filter('tr#tr_' + NG.Var[NG.Nact].selec).addClass('row_selected');
                //$('#ch_' + NG.Var[NG.Nact].selec).parent().parent().addClass('row_selected');
                sel = true;
            }
            return sel;
        },
        repinta: function() {
            //NG.Var[NG.Nact].oSets = NG.Var[NG.Nact].oTable.fnSettings();
            //NG.Var[NG.Nact].oTable.fnDestroy();
            //$('#grid').empty();
            //console.log(NG.Var[NG.Nact].oSets._iDisplayStart);
            if (NG.Var[NG.Nact].datos.length <= 1) {
                NG.Var[NG.Nact].selec = 0;
                return false;
            }
            a_tb = pTablaI(NG.Var[NG.Nact].datos);
            $('#grid').html(a_tb);

            NG.Var[NG.Nact].oTable = $('#grid').dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true,
                "iDisplayLength": NG.Var[NG.Nact].oSets._iDisplayLength,
                "iDisplayStart": NG.Var[NG.Nact].oSets._iDisplayStart,
                "iDisplayEnd": NG.Var[NG.Nact].oSets._iDisplayEnd,
                "aiDisplay": NG.Var[NG.Nact].oSets.aiDisplay,
                "aiDisplayMaster": NG.Var[NG.Nact].oSets.aiDisplayMaster,
                "aaSorting": NG.Var[NG.Nact].oSets.aaSorting,
                "asDataSearch": NG.Var[NG.Nact].oSets.asDataSearch,
                "asSorting": NG.Var[NG.Nact].oSets.asSorting,
                "oSearch": { "sSearch": NG.Var[NG.Nact].oSets.oPreviousSearch.sSearch },
                "bDestroy": true,
                "fnDrawCallback": function(oSettings) {
                    NG.tr_hover();
                }
            });
            //NG.Var[NG.Nact].oTable.fnDraw(); fnDraw //pinta grid con pagina inicial
            //                "aiDisplay": NG.Var[NG.Nact].oSets.aiDisplay,
            //                "aiDisplayMaster": NG.Var[NG.Nact].oSets.aiDisplayMaster,
            //                "aoHeader": NG.Var[NG.Nact].oSets.aoHeader,                //               
            //                "oFeatures": NG.Var[NG.Nact].oSets.oFeatures,
            //                "oInit": NG.Var[NG.Nact].oSets.oInit,
            //"aoData": NG.Var[NG.Nact].oSets.aoData,
            //                "aaSorting": NG.Var[NG.Nact].oSets.aaSorting,
            //                "aoColumns": NG.Var[NG.Nact].oSets.aoColumns,
            //"aaSortingFixed": NG.Var[NG.Nact].oSets.aaSortingFixed,
            a_di = new o_dialog('Ver Indicadores');
            a_di.iniDial();
        },
        tr_hover: function() {
            $('#grid tbody tr').each(function() {
                //                console.log($(this).attr('id')+' != tr_' + NG.Var[NG.Nact].selec);
                //                if ($(this).attr('id') != 'tr_' + NG.Var[NG.Nact].selec) {
                //                    $(this).removeClass('row_selected');
                //                    $('#ch_' + NG.Var[NG.Nact].selec).attr('checked', false);
                //                }
                $(this).hover(function() {
                    $(this).addClass('row_hover');
                }, function() {
                    $(this).removeClass('row_hover');
                });
            });
        },
        elimina: function(flPgrid) {
            NG.Var[NG.Nact].selec = 0
            //console.log(NG.Var[NG.Nact].selec);
            NG.Var[NG.Nact].datoSel = null;
            $(NG.Var[NG.Nact].idGRID).empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            flPgrid();
            NG.Var[NG.Nact].botones(NG.Var[NG.Nact].selec);
        },
        eliminaD: function(flPgrid, flBtns, pfnBtn) {
            NG.Var[NG.Nact].selec = 0
            //console.log(NG.Var[NG.Nact].selec);
            NG.Var[NG.Nact].datoSel = null;
            $(NG.Var[NG.Nact].idGRID).empty();
            NG.Var[NG.Nact].oTable.fnDestroy();
            flPgrid();
            flBtns(pfnBtn);
        }
    };
// *******************************      VARIABLES AJAX JQUERY      ******************************* //
    var errorAjax = function(result) {
        if (result.status != 0) {
            alert("ERROR " + result.status + ' ' + result.statusText);
        }
    };
    var errorAjaxLOAD = function(result) {
        loading.close();
        if (result.status != 0) {
            alert("ERROR " + result.status + ' ' + result.statusText);
        }
    }
// ******************************       FUNCION JQUERY FOCUS SIGUIENTE ELEMENTO     *********************//
    $.fn.focusNextInputField = function() {
        return this.each(function() {
            var fields = $(this).parents('form:eq(0),body').find('button:visible,input:visible,textarea:visible,select:visible');
            var index = fields.index(this);
            if (index > -1 && (index + 1) < fields.length) {
                fields.eq(index + 1).focus();
            }
            return false;
        });
    };