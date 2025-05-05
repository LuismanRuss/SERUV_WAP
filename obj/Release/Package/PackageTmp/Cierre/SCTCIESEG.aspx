<%@ Page Language="C#" AutoEventWireup="true" Inherits="Cierre_SCTCIESEG" Codebehind="SCTCIESEG.aspx.cs" %>
<%@ Register src="../Encabezado.ascx" tagname="Encabezado" tagprefix="uc1" %>
<%@ Register src="../Menu.ascx" tagname="Menú" tagprefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="keywords" content="universidad veracruzana, UV, entrega recepción, transparencia, contraloría, información estratégica" />
    <meta name="description" content="Sistema de Entrega - Recepción de la Universidad Veracruzana " />
    <title>SISTEMA DE ENTREGA - RECEPCIÓN DE LA UNIVERSIDAD VERACRUZANA</title>
    <link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon" />
<%--    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Acta.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/SCIREGISTRO_LAYOUT.css" rel="stylesheet" type="text/css" /> 
    <link href="../styles/jquery.treetable.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.treetable.theme.default.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Monitoreo.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Registro.css" rel="stylesheet" type="text/css" />



    <script src="../scripts/jquery-1.7.2.js" type="text/javascript" language="javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>
    <script src="../scripts/jquery.numeric.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.easyui.min.js" type="text/javascript"></script>
    
    <script src="../scripts/jquery.treetable.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
    <script src="../scripts/Muestra-Oculta.js" type="text/javascript"></script>--%>

    <link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
        <link href="../styles/Acta.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Monitoreo.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/SCIREGISTRO_LAYOUT.css" rel="stylesheet" type="text/css" /> 
    <link href="../styles/jquery.treetable.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.treetable.theme.default.css" rel="stylesheet" type="text/css" />
 

    <script src="../scripts/jquery-1.7.2.js" type="text/javascript" language="javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>
    <script src="../scripts/jquery.numeric.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/jquery.easyui.min.js" type="text/javascript"></script> <%--Este es el script que hace que varie el estilo de los dialogs--%>

    <script src="../scripts/jquery.treetable.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
    <script src="../scripts/Muestra-Oculta.js" type="text/javascript"></script>

    <script type="text/javascript">

//        if (window != top) top.location.href = location.href;

        var pageUrl = new Array();
        pageUrl[1] = "SCSCIEPRO.aspx"; /***********DECLARACIÓN DE LOS TABULADORES QUE SE VAN A MOSTRAR CON LA LIGA A LA PÁGINA CON INFORMACIÓN ***********/



        function loadTab(id) {
            if (pageUrl[id].length > 0) {
                $(".navcontainer a").css({ background: "#ffffff" }); /*******ESTILO FONDO DE LOS TABS SELECCIONADOS**********/
                $("#tab" + id).css({ background: "#eeefef" }); /*******ESTILO FONDO DE LOS TABS NO SELECCIONADOS**********/
                //loading.iniSmall();
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

        $(document).ready(function () {   /***********DECLARACIÓN DE LOS TABULADORES QUE SE VAN A MOSTRAR ***********/
            navegador();
            $("#tab1").click(function () { /*Opc. Carga información*/
                loading.ini();
                loadTab(1);
                NG.reset();
            });

            loadTab(1); /******TABULADOR QUE QUEDARÁ POR DEFAULT CUANDO ABRÁ LA OPCIÓN DEL MENÚ**********/
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
