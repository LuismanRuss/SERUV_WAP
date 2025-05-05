<%@ Page Language="C#" AutoEventWireup="true" Inherits="SATADMINI" Codebehind="SATADMINI.aspx.cs" %>

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
    <link href="../styles/jquery-ui-1.9.2.custom.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../styles/demo_table.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Guia.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/SCIREGISTRO_LAYOUT.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Acta.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/Proceso.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Usuario.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/Perfil.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Sujeto.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Notificacion.css" rel="stylesheet" type="text/css" />
    <link href="../styles/pnotify.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.pnotify.default.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery.pnotify.default.icons.css" rel="stylesheet" type="text/css" />


    <link href="../styles/prettify.css" rel="stylesheet" type="text/css" />
    <link href="../styles/icons.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery-1.8.3.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui-1.9.2.custom.js" type="text/javascript"></script> <%--NO QUITAR YA QUE LA UTILIZA EL DATEPICKER--%>

    <%--<script src="../scripts/jquery-1.7.2.js" type="text/javascript" language="javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>--%>
    <%--<script src="../scripts/jquery-1.5.1.min.js" type="text/javascript"></script>--%>
    <%--<script src="../scripts/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui-1.9.2.custom.min.js" type="text/javascript"></script>--%>
    <script src="../scripts/jquery.numeric.js" type="text/javascript"></script> 
    <script src="../scripts/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
    <script src="../scripts/DataTables.js" type="text/javascript"></script>
    <script src="../scripts/jquery.alerts.js" type="text/javascript"></script>    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    <script src="../scripts/JSValida.js" type="text/javascript"></script>
    <script src="../scripts/JSValidacion.js" type="text/javascript"></script>
    <script src="../scripts/Muestra-Oculta.js" type="text/javascript"></script>
    <script src="../scripts/jquery.pnotify.js" type="text/javascript"></script>
    <script src="../scripts/prettify.js" type="text/javascript"></script>
    <!--Funcionamiento del Submenú -->
    <script type="text/javascript">
        var permanotice, tooltip2, _alert;
        if (window != top) top.location.href = location.href;

        //var sSplit = $("#txt_Perfiles").val().split("#");
        var sPerfiles = <%= lsPerfiles %>;
        var sSplit = sPerfiles.split('|');
        var sSplitComas2 = sPerfiles.split(',');
        var separarsSplitComas2 = sSplitComas2[0];
        var pageUrl = new Array();
        var bAdmin = false;
        var bSObligado = false;
        var bSReceptor = false;
        var bEOperativoP = false;
        var i;
        //var intUsuario;

        for (i=1; i <= 9; i++) {
            pageUrl[i] = "";
        }

        for (i=0; i < sSplit.length; i++) {
            switch (sSplit[i]) {
                case "2":
                    pageUrl[1] = "Usuario/SAMUSUARI.aspx";                    
                    pageUrl[2] = "Perfil/SAMPERFIL.aspx";
                    pageUrl[3] = "Guia/SAAGUIAER.aspx";
                    pageUrl[4] = "Notificacion/SAANOTIFI.aspx";
                    pageUrl[5] = "Proceso/SAAPRCENTREC.aspx";

                   pageUrl[10] = "Configuracion/SAACONFNOT.aspx";
                    bAdmin = true;
                    break;
                case "4":
                    pageUrl[6] = "Sujeto/SASANXDEP.aspx";
                    pageUrl[7] = "Sujeto/SAAENLACE.aspx";
                    pageUrl[8] = "Sujeto/SCSNOTISO.aspx";
                    bSObligado = true;
                    break;

                case "5":
                    pageUrl[9] = "Sujeto/SAAENLAOR.aspx";
                    bSReceptor = true;
                    break;

                case "6":
                    pageUrl[6] = "Sujeto/SASANXDEP.aspx";
                    pageUrl[8] = "Sujeto/SCSNOTISO.aspx";
                    bEOperativoP = true;
                    break;
            }
        }



        function loadTab(id) {
            if (pageUrl[id].length > 0) {
                $(".navcontainer a").css({ background: "#ffffff" }); /*******ESTILO FONDO DE LOS TABS SELECCIONADOS**********/
                $("#tab" + id).css({ background: "#eeefef" }); /*******ESTILO FONDO DE LOS TABS NO SELECCIONADOS**********/
                loading.iniSmall();
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

        $(document).ready(function () {   /***********DECLARACIÓN DE LOS TABULADORES QUE SE VAN A MOSTRAR ***********/
            navegador();

//            for (i=1; i <= 8; i++) {
//                $("#tab"+i).click(function () {
//                    loadTab(i);                
//                    NG.reset();
//                });
//            }

            $("#tab1").click(function () {
               loading.ini();
                loadTab(1);                
                NG.reset();
            });

            $("#tab2").click(function () {
               loading.ini();
                loadTab(2);
                NG.reset();
            });
            $("#tab3").click(function () {
               loading.ini();
                loadTab(3);
                NG.reset();
            });
            $("#tab4").click(function () {
               loading.ini();
                loadTab(4);
                NG.reset();
            });
            $("#tab5").click(function () {
                 loading.ini();
                loadTab(5);
                NG.reset();
            });
            $("#tab6").click(function () {
              loading.ini();
                loadTab(6);
                NG.reset();
            });
            $("#tab7").click(function () {
               loading.ini();
                loadTab(7);
                NG.reset();
            });
            $("#tab8").click(function () {
               loading.ini();
                loadTab(8);
                NG.reset();
            });
            $("#tab9").click(function () {
               loading.ini();
                loadTab(9);
                NG.reset();
            });
            $("#tab10").click(function () {
               //loading.ini();
               loadTab(10);
               NG.reset();
            });
            /******TABULADOR QUE QUEDARÁ POR DEFAULT CUANDO ABRA LA OPCIÓN DEL MENÚ**********/
            if (bAdmin) {
                loadTab(1);
            } 
            else {
                if (bSObligado) {
                loading.ini();
                    loadTab(6);
                } 
                else{ 
                    if (bSReceptor) {
                    loading.ini();
                        loadTab(9);
                    }
                    else 
                        if (bEOperativoP) {
                        loading.ini();
                            loadTab(6);
                        }
                }
            }            
            NG.reset();

            //if ($.grep(separarsSplitComas2.split('|'), function (n, i) { return (n == 8 ? 1 : (n == 9 ? 1 : 0)); }).length > 0) {
            //console.log(separarsSplitComas2);
            if ($.grep(separarsSplitComas2.split('|'), function (n, i) { return (n == 8 ? 1 : (n == 9 ? 1 : (n == 4 ? 1 : (n == 6 ? 1 : 0)))); }).length > 0) {
                fValidaNotificaciones();
            }

        });

        function urls(menu, pagina) {   /*********FUNCIÓN PARA IDENTIFICAR EN QUE TABULADOR SE ABRIRÁN LAS PÁGINAS**********/
            var aux = pageUrl[menu];
            pageUrl[menu] = pagina;
            loadTab(menu);
            pageUrl[menu] = aux;
        }

        
        //Función que despliega una pequeña ventana indicándole que tiene notificaciones sin leer.		
		//$(function (){
        function VerAviso(){
			// This is how to change the default settings for the entire page.
			//$.pnotify.defaults.width = "400px";
			// If you don't want new lines ("\n") automatically converted to breaks ("<br />")
			//$.pnotify.defaults.insert_brs = false;

            $.pnotify({
                //title: 'AVISO NOTIFICACIONES',
                //text: 'Cuenta con notificaciones nuevas.',
                text:$("#form_notice").html(),
                //type: 'info',
                //icon: 'ui-icon ui-icon-locked'
                width: 'auto',
                closer: true,
                closer_hover: true,
                sticker: true,
                icon: false,
                insert_brs: false
            });




			// This notice is used as a tooltip.
			function make_tooltip(){
				tooltip2 = $.pnotify({
					title: "Tooltip",
					text: "SERUV.",
					hide: false,
					closer: false,
					sticker: false,
					history: false,
					animate_speed: 100,
					opacity: .9,
					icon: "ui-icon ui-icon-comment",
					// Setting stack to false causes Pines Notify to ignore this notice when positioning.
					stack: false,
					after_init: function(pnotify){
						// Remove the notice if the user mouses over it.
						pnotify.mouseout(function(){
							pnotify.pnotify_remove();
						});
					},
					before_open: function(pnotify){
						// This prevents the notice from displaying when it's created.
						pnotify.pnotify({
							before_open: null
						});
						return false;
					}
				});
			}
			// I put it in a function so I could show the source easily.
			//make_tooltip();

			// This creates all those source buttons.
			$(".source").each(function(){
				var button = $(this);
				// Wrap the button in a container.
				var contain = $('<div class="btn-group" />');
				contain = button.wrap(contain).parent();
				// Add a source button.
				$('<button class="btn" title="Show source code.">{}</button>').click(function(){
					$(this).blur();
					var text = button.attr("onclick");
					if (!text && button.attr("onmouseover"))
						text = "// Mouse Over:\n"+button.attr("onmouseover")+"\n\n// Mouse Move:\n"+button.attr("onmousemove")+"\n\n// Mouse Out:\n"+button.attr("onmouseout");
					// IE needs this.
					if (text.toString) {
						text = text.toString();
						if (text.match(/^function (onclick|anonymous)[\n ]*\([^\)]*\)[\n ]*\{[\n\t ]*/))
							text = text.replace(/^function (onclick|anonymous)[\n ]*\([^\)]*\)[\n ]*\{[\n\t ]*/, "").replace(/[\n\t ]*}[\n\t ]*$/, "");
					}
					var dialog = $("<div title=\""+button.text()+" - Source\" class=\"source-dialog\"></div>");
					$("<pre class=\"prettyprint linenums\" />").text(js_beautify(text)).appendTo(dialog);
					if (text.match(/^\w*\([^\)]*\);$/)) {
						var f_name = text.replace(/\(.*/g, "");
						text = window[f_name].toString();
						$("<pre class=\"prettyprint\" />").text(js_beautify(text)).appendTo(dialog);
					}
					if (text.match(/tooltip2\.pnotify_display\(\);/)) {
						$("<pre class=\"prettyprint linenums\" />").text(js_beautify(make_tooltip.toString())).appendTo(dialog);
					}
					dialog.dialog({width: "auto", dialogClass: "sourcecode"});
					// Make sure the dialog isn't more than 800x600.
					// Can't just add max-height cause that means it can't be resized beyond.
					if (dialog.width() > 800)
						dialog.dialog("option", "width", 800).dialog("option", "position", "center");
					if (dialog.height() > 600)
						dialog.dialog("option", "height", 600).dialog("option", "position", "center");
					prettyPrint();
				}).appendTo(contain);
			});
			prettyPrint(); // Format source in help.

			if ($.fn.themeswitcher)
				$('#switcher-jqueryui').themeswitcher();
			else
				$('#switcher-jqueryui').html("Couldn't load theme switcher widget.");
			// Navbar scrollspy.
//			$('#navbar').scrollspy();
		//});
        }

    // Función que valida si el usuario logueado tiene o no notificaciones sin leer y en caso de tenerlas, manda a llamar
    // a la función VerAviso() para mostrar una pequeña ventana indicando que tiene notificaciones sin leer.
    function fValidaNotificaciones(){
        //console.log($('#hf_idUsuario').val());
        var actionData = "{'nUsuario':'" + $('#hf_idUsuario').val() +
                         "'}";
            $.ajax(
                {
                    url: "SATADMINI.aspx/fValidaNotificacione",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        switch (reponse.d){
                            case 0:
                                //jAlert("No tiene notificaciones.");
                                break;
                            case 1:
                                //if (sSplit.indexOf("8") != -1 || sSplit.indexOf("9") != -1 || sSplit.indexOf("4") != -1 ){                                                
                                    VerAviso();
                                //}
                                //jAlert("Tiene notificaciones.");
                                break;
                        }
                    },
//                    beforeSend: loading.ini(),
//                    complete: loading.close(),
                    error: // errorAjax
                        function (result) {
                            loading.close();
//                            $.alerts.dialogClass = "errorAlert";
//                            jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                        }
                }
            );
    }

    function fNotificaciones(){

        
        //if (sSplit.indexOf("8") != -1 || sSplit.indexOf("9") != -1 ){
        if ($.grep(separarsSplitComas2.split('|'), function (n, i) { return (n == 8 ? 1 : (n == 9 ? 1 : 0)); }).length > 0) {
            window.open("../Monitoreo/SMTSUPMON.aspx",'_parent');
            var $tabs = $("#agp_menu").tabs();
            $tabs.tabs('select', 2);
        }
        else{
            //if (sSplit.indexOf("4") != -1 ){
            if ($.grep(separarsSplitComas2.split('|'), function (n, i) { return (n == 4 ? 1 : (n == 6 ? 1 : 0)); }).length > 0) {
                window.open("../Monitoreo/SMTSUPMON.aspx",'_parent');
                var $tabs = $("#agp_menu").tabs();
                $tabs.tabs('select', 1);
            }
        }
    }

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

        <div id="form_notice" style="display: none;">
            <form class="pf-form pform_custom" action="" method="post">

                <div class="fondonoti">
                    <div class="titulo_noti">
                        <img alt="Aviso de notificaciones" src="../images/mail-message-new.png" />Aviso</div>
                    <div class="aviso_noti">Usted tiene notificaciones sin leer</div>
                    <div class="btnVer btnAct">                        
                        <a title="Regresar pantalla anterior" href="../Monitoreo/SMTSUPMON.aspx" style="color:#fff;">Ir</a>
                    </div>
                </div>

            </form>
        </div>

        <div id="div_ocultos">                        
            <input id="hf_idUsuario" type="hidden" runat="server" />
        </div>

    </div>
</body>
</html>
