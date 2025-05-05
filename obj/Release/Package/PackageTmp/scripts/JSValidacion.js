lib_num = {
    //Número de decimales en la caja de texto.   
    NumeroDeDecimales: "2",
    // Permite solo ingresar enteros  
    EnterosHandled: function(e) {
        if (e.which >= 48 & e.which <= 57 | e.which == 8) {
            return true;
        }
        else {
            e.preventDefault();
        }
    },
    // Permite ingresar decimales
    DecimalesHandled: function(e, text) {
        //alert(text);
        //console.log(text);
        var decimales = 0;
        if (lib_num.ContarPuntos(text) > 0) {
            decimales = lib_num.CantidadDecimales(text);
        }
        if (e.which >= 48 & e.which <= 57 & decimales < lib_num.NumeroDeDecimales | e.which == 8) {
            return true;
        } else {
            //if (text != "" & e.which == 46 & lib_num.ContarPuntos(text) == 0)
            if (e.which == 46 & lib_num.ContarPuntos(text) == 0)
                return true;
            else {
                e.preventDefault();
            }
        }
    },
    //Cuenta el número de puntos en una cadena.    
    ContarPuntos: function(input) {
        var cant = 0;
        if (input != null) {
            for (var i = 0; i < input.length; i++) {
                if (input[i] == '.') cant += 1;
            }
        }
        return cant;
    },
    //Cuenta el número de dígitos después de un punto.    
    CantidadDecimales: function(input) {
        var cant = 0;
        if (input.indexOf(".") != -1)
            cant = input.substr(input.indexOf(".") + 1).length;
        return cant;
    }
};