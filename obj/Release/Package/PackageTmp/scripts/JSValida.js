function MM_preloadImages() { //v3.0
    var d = document; if (d.images) {
        if (!d.MM_p) d.MM_p = new Array();
        var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
            if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
    }
};

function MM_swapImgRestore() { //v3.0
    var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
};

function MM_findObj(n, d) { //v4.01
    var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
        d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
    }
    if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
    for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
    if (!x && d.getElementById) x = d.getElementById(n); return x;
};

function MM_swapImage() { //v3.0
    var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2); i += 3)
        if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
    };

function MM_showHideLayers() { //v9.0
    var i, p, v, obj, args = MM_showHideLayers.arguments;
    for (i = 0; i < (args.length - 2); i += 3)
    with (document) if (getElementById && ((obj = getElementById(args[i])) != null)) {
        v = args[i + 2];
        if (obj.style) { obj = obj.style; v = (v == 'show') ? 'visible' : (v == 'hide') ? 'hidden' : v; }
        obj.visibility = v;
    }
};
var aux_requeridos;//Texto de campos requeridos
var aval_nom; //Auxiliar para nombre en alta indicador
var aval_c; //Boolean solo la primera vez en ciclo
function valida(tipo, inputs) {
    res = false;
    aux_requeridos = "<ul>";
    switch (tipo) {
        case "text":
            var elementos = inputs.split("=");
            for (i = 0; i < elementos.length; i++) {
                if (val_elemento(elementos[i])) {
                    res = true;
                }
            } 
            aux_requeridos += '</ul>'
            return res;
            break;
        case "box":
            var elementos = inputs.split("=");
            for (i = 0; i < elementos.length; i++) {
                aux = elementos[i];
                var flag = 0;
                if ($("[name=" + aux + "]").is(":checked")) {
                    flag++;
                }
                if (flag == 0) {
                    res = true;
                    $('#R_' + aux).css({ "visibility": "visible" });
                    $('#R_' + aux).css("color", "red");
                    $('#R_' + aux).css("font-size", "9px");
                } else {
                    $('#R_' + aux).css({ "visibility": "hidden" });
                }
            }
            aux_requeridos += '</ul>'
            return res;
            break;
    }
};
function val_elemento(objeto) {
    var aux = "";
    if ($(objeto).val() == "" || $(objeto).val() == null || $(objeto).val() == '0') {
        aux = $(objeto).attr("id");
        $('#R_' + aux).css({ "visibility": "visible" });
        $('#R_' + aux).css("color", "red");
        $('#R_' + aux).css("font-size", "9px");
        if ($(objeto).attr('Title')) {
            aux_requeridos += '<li>' + $(objeto).attr('Title') + '</li>';
        }
        return true;
    } else {
        aux = $(objeto).attr("id");
        $('#R_' + aux).css({ "visibility": "hidden" });
        return false;
    }
};