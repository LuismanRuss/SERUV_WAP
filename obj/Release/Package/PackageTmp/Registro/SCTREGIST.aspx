<%@ Page Language="C#" AutoEventWireup="true" Inherits="Registro_SCTREGIST" Codebehind="SCTREGIST.aspx.cs" %>
<%--Referencias a los controles --%>
<%@ Register src="../Encabezado.ascx" tagname="Encabezado" tagprefix="uc1" %>
<%@ Register src="../Menu.ascx" tagname="Menú" tagprefix="uc2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
   <%-- <meta charset="UTF-8" />--%>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="keywords" content="universidad veracruzana, UV, entrega recepción, transparencia, contraloría, información estratégica" />
    <meta name="description" content="Sistema de Entrega - Recepción de la Universidad Veracruzana " />
    <title>SISTEMA DE ENTREGA - RECEPCIÓN DE LA UNIVERSIDAD VERACRUZANA</title>
    <link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon" />

    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />    
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    
    <script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../scripts/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
    <script src="../scripts/Muestra-Oculta.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        if (window != top) top.location.href = location.href;

        /*Arreglo de páginas que abrirá este módulo*/
        var pageUrl = new Array();
        pageUrl[1] = "SCACARINF.aspx";

        /*Función que abre una página en un div*/
        function loadTab(id) {
            if (pageUrl[id].length > 0) {
                $(".navcontainer a").css({ background: "#ffffff" }); 
                $("#tab" + id).css({ background: "#f5f5f5" }); 

                $.ajax({
                    url: pageUrl[id],
                    cache: false,
                    success: function (message) {                        
                        $("#tabcontent").empty().append(message);
                    },
                    error: errorAjax,
                    beforeSend: loading.ini()                    
                });
            }
        };

        /*Variables utilizadas para determinar el navegar del cliente*/
        var userAgent = navigator.userAgent.toLowerCase();
        var safari = /webkit/.test(userAgent) && !/chrome/.test(userAgent);
        var chrome = /chrome/.test(userAgent);
        var mozilla = /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
        function navegador() {
            if (safari)
                $('#navegador').val("safari");
            if (chrome)
                $('#navegador').val("chrome");
            if ($.browser.msie)
                $('#navegador').val("IE");
            if (mozilla)
                $('#navegador').val("mozilla");
        };

        /*Se lanza al inicio de la carga del lado del cliente*/
        $(document).ready(function () {   
            navegador();
            $("#tab1").click(function () { 
                loadTab(1);                
                NG.reset();
            });
            loadTab(1); 
            NG.reset();
        });

        /*Función utilizada por las páginas abiertas para poder actualizar el div*/
        function urls(menu, pagina) {   
            var aux = pageUrl[menu];
            pageUrl[menu] = pagina;
            loadTab(menu);
            pageUrl[menu] = aux;
        }

    </script>   
</head>

<body>
<div id="page">
   
    <div id="ContGral">
        <uc1:Encabezado ID="Encabezado1" runat="server" />
    
        <div class="navcontainer"> 
		    <ul>
			    <%--<li><a id="tab1" href="#">Integración Información</a></li>--%>
    		    <%--<li><a id="tab2" href="#">Consulta</a></li>--%>
	        </ul>
        </div>       


        <div id="tabcontent">
        </div>	    
    </div>        
   
</div>
</body>
</html>
