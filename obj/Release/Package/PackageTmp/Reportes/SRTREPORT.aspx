<%@ Page Language="C#" AutoEventWireup="true" Inherits="Reportes_SRTREPORT" Codebehind="SRTREPORT.aspx.cs" %>

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

    <script src="../scripts/jquery-1.5.1.min.js" type="text/javascript"></script>
    
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript" language="javascript" ></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
    <script src="../scripts/Muestra-Oculta.js" type="text/javascript"></script>
    
    
    <!--Funcionamiento del Submenú -->
    <script type="text/javascript">
        if (window != top) top.location.href = location.href;

        var pageUrl = new Array();
        pageUrl[1] = "SRLPROCES.aspx"; 
        


        function loadTab(id) {
            if (pageUrl[id].length > 0) {
                $(".navcontainer a").css({ background: "#ffffff" });
                $("#tab" + id).css({ background: "#f5f5f5" }); 
                loading.iniSmall();
                //alert(id);
                $.ajax({
                    url: pageUrl[id],
                    cache: false,
                    success: function (message) {
                        $("#tabcontent").empty().append(message);
                    },
                    error: errorAjax,
                    complete: loading.closeSmall
                });
            }
        };

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

        $(document).ready(function () {   
            navegador();
            $("#tab1").click(function () { 
                loadTab(1);
                NG.reset();
            });


            loadTab(1); 
            NG.reset();
        });

        function urls(menu, pagina) {   /*********FUNCIÓN PARA IDENTIFICAR EN QUE TABULADOR SE ABRIRÁN LAS PÁGINAS**********/
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
			    <%--<li><a id="tab1" href="#"></a></li>--%>
    		    
	        </ul>
        </div>       

        <div id="tabcontent">
        </div>	    
    </div>           
</div>
</body>
</html>
