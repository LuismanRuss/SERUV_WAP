//valida formato de correo
jQuery.fn.correo = function() {
    var valor = $(this).attr("value");
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test($(this).val()) || valor.length == "0") {
        $('#R_' + $(this).attr("id")).css({ "visibility": "hidden" });
        return true;
    }
    else {
        //alert('No es correo electronico');
        $(this).focus();
        $('#R_' + $(this).attr("id")).css({ "visibility": "visible" });
        $('#R_' + $(this).attr("id")).text("*Debe ser un formato de correo valido");
        return false;
    }
};
//creo el plugin validaVacio
jQuery.fn.validaVacio = function() {
    //para cada uno de los elementos del objeto jQuery
    this.each(function() {
        //creo una variable elem con el elemento actual
        elem = $(this);
        //creo un evento keyup para este elemento actual
        elem.keyup(function(event) {
            //creo una variable elem con el elemento actual, suponemos un textarea
            //alert(event.which);
            var elem = $(this);
            //obtengo ID y valor del elemento
            var id = elem.attr("id");
            var valor = elem.attr("value");
            if (valor.length == "0") {
                $('#R_' + id).css({ "visibility": "visible" });
            } else {                
                $('#R_' + id).css({ "visibility": "hidden" });
            }
        });
        elem.change(function() {
            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //obtengo ID y valor del elemento
            var id = elem.attr("id");
            var valor = elem.attr("value");
            if (valor.length == "0") {
                $('#R_' + id).css({ "visibility": "visible" });
            } else {
                valor = valor.toUpperCase();
                elem.val(valor);
                $('#R_' + id).css({ "visibility": "hidden" });
            }
        });
    });
    //siempre tengo que devolver this
    return this;
};
//creo el plugin cuentaCaracteres
jQuery.fn.cuentaCaracteres = function(max) {
    //para cada uno de los elementos del objeto jQuery
    this.each(function() {
        //creo una variable elem con el elemento actual, suponemos un textarea
        elem = $(this);
        //creo un elemento DIV sobre la marcha
        aux = max - (elem.attr("value").length * 1);
        var contador = $('<div style="color:#006633; font-size:.8em; padding-left:55em;padding-top:5px">Cantidad de caracteres disponibles: ' + aux + '</div>');
        //inserto el DIV después del elemento textarea
        elem.after(contador);
        //guardo una referencia al elemento DIV en los datos del objeto jQuery
        elem.data("campocontador", contador);

        //creo un evento keyup para este elemento actual
        elem.keyup(function(event) {
            
            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //recupero el objeto que tiene el elemento DIV contador asociado al textarea
            var campocontador = elem.data("campocontador");
            if (max > (elem.attr("value").length * 1)) {
                if (event.which != 37 && event.which != 38 && event.which != 39 && event.which != 40 && event.which != 27 || event.ctrlKey) {
                    campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
                }
            } else {
                if (event.which != 37 && event.which != 38 && event.which != 39 && event.which != 40 && event.which != 27 || event.ctrlKey) {
                    //modifico el texto del contador, para actualizarlo con el número de caracteres escritos
                    elem.val(elem.attr("value").substring(0, max));
                    campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
                }
            }
        });
        elem.change(function() {
            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //recupero el objeto que tiene el elemento DIV contador asociado al textarea
            var campocontador = elem.data("campocontador");
            //modifico el texto del contador, para actualizarlo con el número de caracteres escritos
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
            elem.val(elem.attr("value").substring(0, max));
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
        });
        elem.mouseleave(function() {
            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //recupero el objeto que tiene el elemento DIV contador asociado al textarea
            var campocontador = elem.data("campocontador");
            //modifico el texto del contador, para actualizarlo con el número de caracteres escritos
            var texto = elem.attr("value");
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (texto.length * 1)));
            texto = elem.attr("value").substring(0, max);
            //texto = texto.toUpperCase();
            elem.val(texto);
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (texto.length * 1)));
        });
    });
    //siempre tengo que devolver this
    return this;
};

jQuery.fn.cuentaCaracteresCh = function (max) {  /*contador para aquellos campos que estan dentro de una capa*/
    //para cada uno de los elementos del objeto jQuery
    this.each(function () {
        //creo una variable elem con el elemento actual, suponemos un textarea
        elem = $(this);
        //creo un elemento DIV sobre la marcha
        aux = max - (elem.attr("value").length * 1);
        var contador = $('<div style="color:#006633; font-size:.8em; padding-left:15em;padding-top:5px">Cantidad de caracteres disponibles: ' + aux + '</div>');
        //inserto el DIV después del elemento textarea
        elem.after(contador);
        //guardo una referencia al elemento DIV en los datos del objeto jQuery
        elem.data("campocontador", contador);

        //creo un evento keyup para este elemento actual
        elem.keyup(function (event) {

            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //recupero el objeto que tiene el elemento DIV contador asociado al textarea
            var campocontador = elem.data("campocontador");
            if (max > (elem.attr("value").length * 1)) {
                if (event.which != 37 && event.which != 38 && event.which != 39 && event.which != 40 && event.which != 27 || event.ctrlKey) {
                    campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
                }
            } else {
                if (event.which != 37 && event.which != 38 && event.which != 39 && event.which != 40 && event.which != 27 || event.ctrlKey) {
                    //modifico el texto del contador, para actualizarlo con el número de caracteres escritos
                    elem.val(elem.attr("value").substring(0, max));
                    campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
                }
            }
        });
        elem.change(function () {
            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //recupero el objeto que tiene el elemento DIV contador asociado al textarea
            var campocontador = elem.data("campocontador");
            //modifico el texto del contador, para actualizarlo con el número de caracteres escritos
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
            elem.val(elem.attr("value").substring(0, max));
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (elem.attr("value").length * 1)));
        });
        elem.mouseleave(function () {
            //creo una variable elem con el elemento actual, suponemos un textarea
            var elem = $(this);
            //recupero el objeto que tiene el elemento DIV contador asociado al textarea
            var campocontador = elem.data("campocontador");
            //modifico el texto del contador, para actualizarlo con el número de caracteres escritos
            var texto = elem.attr("value");
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (texto.length * 1)));
            texto = elem.attr("value").substring(0, max);
            //texto = texto.toUpperCase();
            elem.val(texto);
            campocontador.text('Cantidad de caracteres disponibles: ' + (max - (texto.length * 1)));
        });
    });
    //siempre tengo que devolver this
    return this;
};


(function($) {
    $.fn.bestupper = function(settings) {
    var defaults = { ln: 'en', clear: true },
        settings = $.extend({}, defaults, settings);
    this.each(function() {
        var $this = $(this);
        if ($this.is('textarea') || $this.is('input:text')) {
            $this.keypress(function(e) {
                var pressedKey = e.charCode == undefined ? e.keyCode : e.charCode;
                var str = String.fromCharCode(pressedKey);
                if (pressedKey < 97 || pressedKey > 122) { if (settings.ln == 'en' || !isTRChar(pressedKey)) return; }
                if (settings.ln == 'tr' && pressedKey == 105) str = '\u0130';
                if (this.createTextRange) {
                    window.event.keyCode = str.toUpperCase().charCodeAt(0); return;
                } else {
                    var startpos = this.selectionStart; 
                    var endpos = this.selectionEnd;
                    this.value = this.value.substr(0, startpos) + str.toUpperCase() + this.value.substr(endpos);
                    this.setSelectionRange(startpos + 1, startpos + 1); return false;
                } 
            });
            if (settings.clear) {
                $this.blur(function(e) {
                    if (settings.ln == 'tr') this.value = this.value.replace(/i/g, "\u0130");
                    this.value = this.value.replace(/^\s+|\s+$/g, "").replace(/\s{2,}/g, " ").toUpperCase();
                });
            } 
        } 
    });
};
    function isTRChar(key) {
        var trchar = [231, 246, 252, 287, 305, 351];
        for (var i = 0; i < trchar.length; i++) {
            if (trchar[i] == key) return true;
        } return false;
    } 
})(jQuery);