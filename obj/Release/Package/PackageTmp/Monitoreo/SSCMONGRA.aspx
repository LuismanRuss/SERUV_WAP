<%@ Page Language="C#" AutoEventWireup="true" Inherits="Monitoreo_SSCMONGRA" Codebehind="SSCMONGRA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../styles/General.css" rel="stylesheet" type="text/css" />
    <link href="../styles/Monitoreo.css" rel="stylesheet" type="text/css" />
    <link href="../styles/jquery-ui.css" rel="stylesheet" type="text/css" />    
    <link href="../styles/jquery.jqplot.min.css" rel="stylesheet" type="text/css" />
    <script src="../scripts/jquery-1.7.2.js" type="text/javascript"></script>
    <script src="../scripts/jquery-ui.min1.7.js" type="text/javascript"></script>  
    <script src="../scripts/excanvas.min.js" type="text/javascript"></script>
    <script src="../scripts/jquery.jqplot.min.js" type="text/javascript"></script>
    <script src="../scripts/jqplot.donutRenderer.min.js" type="text/javascript"></script>
    <script src="../scripts/jqplot.pieRenderer.min.js" type="text/javascript"></script> 
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
</head>
<body>
    <script type="text/javascript">
        $(document).ready(function () {
            var total = 0;//variable que contendrá el total de los anexos
            var totalSinExcluidos = 0;//variable que contendrá el total de los anexos sin contar a los excluidos

            var integrados = $("#hf_integrados").val();//guardo el número de anexos integrados
            var excluidos = $("#hf_excluidos").val();//guardo el número de anexos excluidos
            var pendientes = $("#hf_pendientes").val();//guardo el número de anexos pendientes
            var forma = $("#hf_forma").val();//guardo el nombre de la forma donde mando a llamar la gráfica

            var integrados2 = integrados;
            var excluidos2 = excluidos;
            var pendientes2 = pendientes;

            if (forma != "SMCSUPMON") {//si la forma es "SMCSUPMON"

                //para la gráfica que muestra todos
                total = Number(pendientes) + Number(excluidos) + Number(integrados);

                integrados = (Number(integrados) / total) * 100;//saco el porcentaje de los anexos integrados
                excluidos = (Number(excluidos) / total) * 100; //saco el porcentaje de los anexos excluidos
                pendientes = (Number(pendientes) / total) * 100; //saco el porcentaje de los anexos pendientes

                var data = [['Integrados  ' + '(' + integrados2 + '  Anexos' + ')', integrados], ['Excluidos  ' + '(' + excluidos2 + '  Anexos' + ')', excluidos], ['Pendientes  ' + '(' + pendientes2 + '  Anexos' + ')', pendientes]];
                var plot1 = jQuery.jqplot('chartdiv', [data],
            {
                title: 'ANEXOS CON EXCLUIDOS',
                seriesDefaults: {
                    renderer: jQuery.jqplot.PieRenderer,
                    rendererOptions: {
                        showDataLabels: true,
                        dataLabelFormatString: '%.2f' + '%'
                    }
                },
                legend: { show: true, location: 'e' }
            });

            //----------------------------------------------------------------------------------------------------------------------
                //para la gráfica que muestra sin excluidos 
                totalSinExcluidos = Number(pendientes) + Number(integrados);

                integrados = (Number(integrados) / totalSinExcluidos) * 100; //saco el porcentaje de los anexos integrados
                pendientes = (Number(pendientes) / totalSinExcluidos) * 100; //saco el porcentaje de los anexos pendientes

                var dataSinExcluidos = [['Integrados  ' + '(' + integrados2 + '  Anexos' + ')', integrados], ['Pendientes  ' + '(' + pendientes2 + '  Anexos' + ')', pendientes]];
                var plot2 = jQuery.jqplot('chartdivSinExcluidos', [dataSinExcluidos],
            {
                title: 'ANEXOS SIN EXCLUIDOS',
                seriesDefaults: {
                    renderer: jQuery.jqplot.PieRenderer,
                    rendererOptions: {
                        showDataLabels: true,
                        dataLabelFormatString: '%.2f' + '%'
                    }
                },
                legend: { show: true, location: 'e' }
            });

        } else {//si es otra forma
            //para la gráfica que muestra todos
                total = Number(pendientes) + Number(excluidos) + Number(integrados);

                integrados = (Number(integrados) / total) * 100; //saco el porcentaje de los anexos integrados
                excluidos = (Number(excluidos) / total) * 100; //saco el porcentaje de los anexos excluidos
                pendientes = (Number(pendientes) / total) * 100; //saco el porcentaje de los anexos pendientes

                var data = [['Integrados  ' + '(' + integrados2 + '  Anexos' + ')', integrados], ['Excluidos  ' + '(' + excluidos2 + '  Anexos' + ')', excluidos], ['Pendientes  ' + '(' + pendientes2 + '  Anexos' + ')', pendientes]];
                var plot1 = jQuery.jqplot('chartdiv', [data],
            {
                title: 'ANEXOS CON EXCLUIDOS',
                seriesDefaults: {
                    renderer: jQuery.jqplot.PieRenderer,
                    rendererOptions: {
                        showDataLabels: true,
                        dataLabelFormatString: '%.2f' + '%'
                    }
                },
                legend: { show: true, location: 'e' }
            });

            //----------------------------------------------------------------------------------------------------------------------
            //para la gráfica que muestra sin excluidos 
                totalSinExcluidos = Number(pendientes) + Number(integrados);

                integrados = (Number(integrados) / totalSinExcluidos) * 100; //saco el porcentaje de los anexos integrados
                pendientes = (Number(pendientes) / totalSinExcluidos) * 100; //saco el porcentaje de los anexos pendientes

                var dataSinExcluidos = [['Integrados  ' + '(' + integrados2 + '  Anexos' + ')', integrados], ['Pendientes  ' + '(' + pendientes2 + '  Anexos' + ')', pendientes]];
                var plot2 = jQuery.jqplot('chartdivSinExcluidos', [dataSinExcluidos],
            {
                title: 'ANEXOS SIN EXCLUIDOS',
                seriesDefaults: {
                    renderer: jQuery.jqplot.PieRenderer,
                    rendererOptions: {
                        showDataLabels: true,
                        dataLabelFormatString: '%.2f' + '%'
                    }
                },
                legend: { show: true, location: 'e' }
            });
            }
        });

        function fCerrar() {//función que cierra el dialog de las gráficas
            parent.window.fCerrarDialogG();
        }

    </script>
    <form id="SSCMONGRA" runat="server">
   
        <div class="a_botones_grupo">
            <div id="chartdiv" style="height: 99%; width: 45%; display: inline-block;">
            </div>
            <div id="chartdivSinExcluidos" style="height: 99%; width: 45%; display: inline-block;">
            </div>
        </div>
       <%--  <a id="AccAbrirProc" title="Exportar" href="javascript:fExportar();" class="accAct ">Exportar</a>--%>
     
        <div class="a_botones_modal">
            <a id="Btn_Guardar" class="btnAct" title="Botón Cerrar" href="javascript:fCerrar();">Cerrar</a>                               
        </div>
    
    <div id="div_ocultos">
        <asp:HiddenField ID="hf_idUsuario" runat="server" />
        <asp:HiddenField ID="hf_integrados" runat="server" />
        <asp:HiddenField ID="hf_excluidos" runat="server" />
        <asp:HiddenField ID="hf_pendientes" runat="server" />
        <asp:HiddenField ID="hf_forma" runat="server" />
    </div>
    </form>
</body>
</html>
