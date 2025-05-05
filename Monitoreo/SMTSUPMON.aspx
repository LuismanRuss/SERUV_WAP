<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SMTSUPMON" Codebehind="SMTSUPMON.aspx.cs" %>

<%--Referencias a los controles --%>
<%@ Register Src="../Encabezado.ascx" TagName="Encabezado" TagPrefix="uc1" %>
<%@ Register Src="../Menu.ascx" TagName="Menú" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="keywords" content="universidad veracruzana, UV, entrega recepción, transparencia, contraloría, información estratégica" />
    <meta name="description" content="Sistema de Entrega - Recepción de la Universidad Veracruzana " />
    <title>SISTEMA DE ENTREGA - RECEPCIÓN DE LA UNIVERSIDAD VERACRUZANA</title>
    <link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon" />
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
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

    <script src="../scripts/jquery.treetable.js" type="text/javascript"></script>
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
    <script src="../scripts/Muestra-Oculta.js" type="text/javascript"></script>
      <!--Funcionamiento del Submenú -->
    <script type="text/javascript">
        var permanotice, tooltip2, _alert;
        if (window != top) top.location.href = location.href;
        var sPerfiles = <%= lsPerfiles %>;
        var sSplit = sPerfiles.split('|');

    
       var sSplitComas = sPerfiles.split(',');
        var separarsSplitComas = sSplitComas[0];

        var bAdmin = false;
        var i;
        var nIndex = 1;
        var pageUrl = new Array();
           for (i=1; i <= 9; i++) {
            pageUrl[i] = "";
        }

        for (i = 0; i < sSplit.length; i++) {
            switch (sSplit[i]) {/***********DECLARACIÓN DE LOS TABULADORES QUE SE VAN A MOSTRAR CON LA LIGA A LA PÁGINA CON INFORMACIÓN ***********/
                case "2":
                    pageUrl[1] = "SMCSUPMON.aspx"; 
                    pageUrl[2] = "SSSMONPRO.aspx";
                    break;
                case "4":
                    pageUrl[1] = "SMCSUPMON.aspx";    
                    pageUrl[2] = "SSSMONPRO.aspx";                 
                    break;
                /* agregado 2013-11-22 */
                case "5":
                    pageUrl[1] = "SMCSUPMON.aspx"; 
                    break;
                /* agregado 2013-11-22 */
                case "6":
                    pageUrl[1] = "SMCSUPMON.aspx"; 
                    break;
                case "7":
                    pageUrl[1] = "SMCSUPMON.aspx"; 
                    break;
                case "8":
                   pageUrl[1] = "SMCSUPMON.aspx"; 
                    pageUrl[2] = "SSSMONPRO.aspx";
                    break;
                case "9":
                    pageUrl[1] = "SMCSUPMON.aspx"; 
                    pageUrl[2] = "SSSMONPRO.aspx";
            }
        }

        function loadTab(id) {
            if (pageUrl[id].length > 0) {
                $(".navcontainer a").css({ background: "#ffffff" }); /*******ESTILO FONDO DE LOS TABS SELECCIONADOS**********/
                $("#tab" + id).css({ background: "#eeefef" }); /*******ESTILO FONDO DE LOS TABS NO SELECCIONADOS**********/
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
            $("#tab1").click(function () {
                loading.ini();
                loadTab(1);                
                NG.reset();
           
            });

            $("#tab2").click(function () {
                loading.ini();
                loadTab(2);
                NG.reset();
                NG.setNact(0, 'Cero',null);
            });
                

       //-----------Esta parte me permite saber que pestaña poner por default dependiendo de los perfiles------
       var bandera = false;
             if(sSplit.length > 0){
                for ( i = 0; i < sSplit.length; i++) {
                   if(sSplit[i] == 4 || sSplit[i] == 5 || sSplit[i] == 6 || sSplit[i] == 7){
                         loadTab(1); 
                         NG.reset(); 
                         bandera = true;
                         break;
                   }
                }

                if (bandera == false){
                loadTab(2); 
                }
             }
        });

        function urls(menu, pagina) {   /*********FUNCIÓN PARA IDENTIFICAR EN QUE TABULADOR SE ABRIRÁN LAS PÁGINAS**********/
            var aux = pageUrl[menu];
            pageUrl[menu] = pagina;
            loadTab(menu);
            pageUrl[menu] = aux;
        }

//        function VerAviso(){
//			// This is how to change the default settings for the entire page.
//			//$.pnotify.defaults.width = "400px";
//			// If you don't want new lines ("\n") automatically converted to breaks ("<br />")
//			//$.pnotify.defaults.insert_brs = false;

//            $.pnotify({
//                //title: 'AVISO NOTIFICACIONES',
//                //text: 'Cuenta con notificaciones nuevas.',
//                text:$("#form_notice").html(),
//                //type: 'info',
//                //icon: 'ui-icon ui-icon-locked'
//                width: 'auto',
//                closer: true,
//                closer_hover: true,
//                sticker: true,
//                icon: false,
//                insert_brs: false
//            });




//			// This notice is used as a tooltip.
//			function make_tooltip(){
//				tooltip2 = $.pnotify({
//					title: "Tooltip",
//					text: "SERUV.",
//					hide: false,
//					closer: false,
//					sticker: false,
//					history: false,
//					animate_speed: 100,
//					opacity: .9,
//					icon: "ui-icon ui-icon-comment",
//					// Setting stack to false causes Pines Notify to ignore this notice when positioning.
//					stack: false,
//					after_init: function(pnotify){
//						// Remove the notice if the user mouses over it.
//						pnotify.mouseout(function(){
//							pnotify.pnotify_remove();
//						});
//					},
//					before_open: function(pnotify){
//						// This prevents the notice from displaying when it's created.
//						pnotify.pnotify({
//							before_open: null
//						});
//						return false;
//					}
//				});
//			}
//			// I put it in a function so I could show the source easily.
//			//make_tooltip();

//			// This creates all those source buttons.
//			$(".source").each(function(){
//				var button = $(this);
//				// Wrap the button in a container.
//				var contain = $('<div class="btn-group" />');
//				contain = button.wrap(contain).parent();
//				// Add a source button.
//				$('<button class="btn" title="Show source code.">{}</button>').click(function(){
//					$(this).blur();
//					var text = button.attr("onclick");
//					if (!text && button.attr("onmouseover"))
//						text = "// Mouse Over:\n"+button.attr("onmouseover")+"\n\n// Mouse Move:\n"+button.attr("onmousemove")+"\n\n// Mouse Out:\n"+button.attr("onmouseout");
//					// IE needs this.
//					if (text.toString) {
//						text = text.toString();
//						if (text.match(/^function (onclick|anonymous)[\n ]*\([^\)]*\)[\n ]*\{[\n\t ]*/))
//							text = text.replace(/^function (onclick|anonymous)[\n ]*\([^\)]*\)[\n ]*\{[\n\t ]*/, "").replace(/[\n\t ]*}[\n\t ]*$/, "");
//					}
//					var dialog = $("<div title=\""+button.text()+" - Source\" class=\"source-dialog\"></div>");
//					$("<pre class=\"prettyprint linenums\" />").text(js_beautify(text)).appendTo(dialog);
//					if (text.match(/^\w*\([^\)]*\);$/)) {
//						var f_name = text.replace(/\(.*/g, "");
//						text = window[f_name].toString();
//						$("<pre class=\"prettyprint\" />").text(js_beautify(text)).appendTo(dialog);
//					}
//					if (text.match(/tooltip2\.pnotify_display\(\);/)) {
//						$("<pre class=\"prettyprint linenums\" />").text(js_beautify(make_tooltip.toString())).appendTo(dialog);
//					}
//					dialog.dialog({width: "auto", dialogClass: "sourcecode"});
//					// Make sure the dialog isn't more than 800x600.
//					// Can't just add max-height cause that means it can't be resized beyond.
//					if (dialog.width() > 800)
//						dialog.dialog("option", "width", 800).dialog("option", "position", "center");
//					if (dialog.height() > 600)
//						dialog.dialog("option", "height", 600).dialog("option", "position", "center");
//					prettyPrint();
//				}).appendTo(contain);
//			});
//			prettyPrint(); // Format source in help.

//			if ($.fn.themeswitcher)
//				$('#switcher-jqueryui').themeswitcher();
//			else
//				$('#switcher-jqueryui').html("Couldn't load theme switcher widget.");
//			// Navbar scrollspy.
////			$('#navbar').scrollspy();
//		//});
//        }

//    
//    function fValidaNotificaciones(){
//        //console.log($('#hf_idUsuario').val());
//        var actionData = "{'nUsuario':'" + $('#hf_idUsuario').val() +
//                         "'}";
//            $.ajax(
//                {
//                    url: "SMTSUPMON.aspx/fValidaNotificacione",
//                    data: actionData,
//                    dataType: "json",
//                    type: "POST",
//                    contentType: "application/json; charset=utf-8",
//                    success: function (reponse) {
//                        switch (reponse.d){
//                            case 0:
//                                //jAlert("No tiene notificaciones.");
//                                break;
//                            case 1:
//                                if (sSplit.indexOf("8") != -1 || sSplit.indexOf("9") != -1 || sSplit.indexOf("4") != -1 ){                                                
//                                    VerAviso();
//                                }
//                                //jAlert("Tiene notificaciones.");
//                                break;
//                        }
//                    },
////                    beforeSend: loading.ini(),
////                    complete: loading.close(),
//                    error: // errorAjax
//                        function (result) {
//                            loading.close();
//                            $.alerts.dialogClass = "errorAlert";
//                            jAlert("Ha sucedido un error inesperado, por favor inténtelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
//                        }
//                }
//            );
//    }

//    function fNotificaciones(){
//        //urls(3, "Notificacion/SAANOTIFI.aspx");
//        if (sSplit.indexOf("8") != -1 || sSplit.indexOf("9") != -1 ){
//            window.open("../Monitoreo/SMTSUPMON.aspx",'_parent');
//            //urls(2, "../../../Monitoreo/SMTSUPMON.aspx");
//            //urls(2, "../Notificaciones/SNMNOTIFI.aspx");
//            //urls(2, "../Administracion/Perfil/SAMPERFIL.aspx");
//            //urls(3, "../Monitoreo/SMTSUPMON.aspx");
//            var $tabs = $("#agp_menu").tabs();
//            $tabs.tabs('select', 2);
//        }
//        else{
//            if (sSplit.indexOf("4") != -1 ){
//                window.open("../Monitoreo/SMTSUPMON.aspx",'_parent');
//            //urls(2, "../../../Monitoreo/SMTSUPMON.aspx");
//            //urls(2, "../Notificaciones/SNMNOTIFI.aspx");
//            //urls(2, "../Administracion/Perfil/SAMPERFIL.aspx");
//            //urls(3, "../Monitoreo/SMTSUPMON.aspx");
//                var $tabs = $("#agp_menu").tabs();
//                $tabs.tabs('select', 1);
////            if (sSplit.indexOf("2") != -1){
////                window.open("../Monitoreo/SMTSUPMON.aspx",'_parent');
////                //urls(3, "../SERUV/Administracion/Notificacion/SAANOTIFI.aspx");
////            }
//            }
//        }

    </script>
</head>
<body>
    <div id="page">
        <uc1:Encabezado ID="Encabezado1" runat="server" />
                       
        <div class="navcontainer">       
            <ul id="ul_Menu" runat="server">
            </ul>
        </div>
        <div id="tabcontent"> <div id="fixme"></div>            
        </div>
    </div>
</body>
</html>
