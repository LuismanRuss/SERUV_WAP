<%@ Page Language="C#" AutoEventWireup="true" Inherits="Reportes_SRLPROCES" Codebehind="SRLPROCES.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <title></title>
</head>
<body>      
    <script type="text/javascript">

        $(document).ready(function () {
            $('#grid').append(pTablaI());

            NG.tr_hover();
            tooltip.iniToolD('25%');

            NG.Var[NG.Nact].oTable = $('#grid')
            .dataTable({
                "sPaginationType": "full_numbers",
                "bLengthChange": true
            });

        });


        function pTablaI(tab) {
            htmlTab = '';
            htmlTab += '<thead><tr>';
            htmlTab += '<th align="center" scope="col" style="width:99%;" class="sorting" title="Ordenar">Descripción</th>';
            htmlTab += '</tr></thead>';
            htmlTab += "<tbody>";

            htmlTab += '<tr>';
            htmlTab += '<td class="sorts"><a href="javascript:Reporte();">Procesos activos</a></td>';
            htmlTab += "</tr>";


            htmlTab += "</tbody>";
            return htmlTab;
        }

        function Reporte() {
            dTxt = '<div id="dComent" title="SERUV - Reporte">';
            
            dTxt += '<iframe id="SRLREPORT" src="SRLREPORT.aspx?op=PROCESOS' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';            
            dTxt += '</div>';
            $('#SRLPROCES').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //650,
                width: $("#agp_contenido").width() - 50, //990,
                modal: true,
                resizable: true
            });
        }
        
        function fCerrarDialog() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();
        }


    </script>

    <form id="SRLPROCES" runat="server">
        <div id="agp_contenido">      
                <div id="agp_navegacion"> 
                    <label class="titulo">REPORTES</label>
                </div>     
                <%--<div class="instrucciones">No se encuentran reportes configurados.</div>   --%>
            <div class="instrucciones">De clic en el nombre del reporte que desee consultar.</div>

            <div class="TablaGrid">
                <table cellpadding="0" rules="all" id="grid" style="width:99%;" class="display" ></table>
            </div>

        </div>

        <div id="div_ocultos">          
            <asp:HiddenField ID="hf_idProceso" runat="server" />  
            <asp:HiddenField ID="hf_operacion" runat="server" />
        </div>

    </form>
</body>
</html>
