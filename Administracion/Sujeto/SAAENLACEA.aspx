<%@ Page Language="C#" AutoEventWireup="true" Inherits="SAAENLACEA" Codebehind="SAAENLACEA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>     
</head>
<body>
 <script type="text/javascript">
     var Accion;
     var Usuario = $('#hf_idUsuario').val();
     var intIdDependencia = $('#hf_intDependencia').val();
     var intIdProceso = $('#hf_intProceso').val();

     $(document).ready(function () {
      
         $("#hcorreo").css('visibility', 'hidden');
         $("#inp_correo").css('visibility', 'hidden');
         //checked y unchecked del checkbox que indica si es un enlace operativo principal
         $("#cbx_eop").click(function () {
             if ($("#cbx_eop").is(':checked')) {
                 $("#cbx_eop").attr('checked', true);                
             }
             else {
                 $("#cbx_eop").attr('checked', false);                
             }

         });
         //----------------------------------------
         //permite realizar una búsqueda a partir de precionar la tecla intro
         $("#inp_cuenta").keydown(function (event) {           
             if (event.keyCode == 13) {
                 if ($('#inp_cuenta').val() == '') {
                     $("#div_Mcuenta").empty().append("Indique una cuenta institucional");
                     $("#div_Mcuenta").css("visibility", "visible");                    
                 }
                 else {
                     Buscar();
                 }               

             } else {
                 
             }

             $("#inp_cuenta").change(function () {
                 if ($(this).val() != "") {
                     $("#div_Mcuenta").css("visibility", "hidden");
                 }
             });
         });


         //------------------------------------------       
         NG.setNact(2, 'Dos', null);         
         if (NG.Var[NG.Nact - 1].datoSel != null) {             
             $('#titulo').text("Modificar enlace operativo principal");
             $('#instrucciones').text("Ingrese la cuenta institucional del empleado que desee modificar.");            
             Accion = "MODIFICAR";
             AsignarValores();
         }
         else {
             Accion = "NUEVO";
             $('#titulo').text("Alta enlace operativo");
             $("#inp_cuenta").click(function () {
                 LimpiaValores();
             });
         }

     });
     

    //ASIGNA VALORES AL FORMULARIO EN EL CASO DE MODIFICAR UN ENLACE OPERATIVO
    function AsignarValores() {     
        $("#hrf_bus").css('visibility', 'hidden');
         $("#ico_busqueda").css('visibility', 'hidden');        
         $("#inp_cuenta").prop('readonly', 'readonly');
         $('#inp_npersonal').val(NG.Var[NG.Nact - 1].datoSel.intNumPersonal);
         $('#inp_cuenta').val(NG.Var[NG.Nact - 1].datoSel.strCorreo);
         $('#lbl_id').val(NG.Var[NG.Nact - 1].datoSel.idUsuario);
         $('#inp_nombre').val(NG.Var[NG.Nact - 1].datoSel.strNombre + ' ' + NG.Var[NG.Nact - 1].datoSel.strApPaterno + ' ' + NG.Var[NG.Nact - 1].datoSel.strApMaterno);
         $('#inp_correo').val(NG.Var[NG.Nact - 1].datoSel.strCorreo);
         $('#inp_dependencia').val(NG.Var[NG.Nact - 1].datoSel.strsDCDepcia);
         $('#inp_puesto').val(NG.Var[NG.Nact - 1].datoSel.strsDCPuesto);   
       
          if (NG.Var[NG.Nact - 1].datoSel.chrPrincipal == 'S') {
              $("#cbx_eop").attr('checked', true);
         }       
     }
     //PERMITE LIMPIAR EL FORMULARIO DE ENLACES OPERATIVOS
     function LimpiaValores() {
         $('#inp_npersonal').val("");
         $('#inp_cuenta').val("");
         $('#lbl_id').val("");
         $('#inp_nombre').val("");
         $('#inp_correo').val("");
         $('#inp_dependencia').val("");
         $('#inp_puesto').val("");

         if ($("#cbx_eop").is(':checked')) {
             $("#cbx_eop").attr('checked', false);                 
             }
         }

         function jsTrim(sString) {
             return sString.replace(/^\s+|\s+$/g, "");
         }
         //PERMITE BUSCAR UNA CUENTA DE LA UV EN LA TABLA DE USUARIOS
     function Buscar() {        
         $("#inp_cuenta").val(jsTrim($("#inp_cuenta").val()));
         if ($("#inp_cuenta").val().length > 0) {
             var cuenta = $("#inp_cuenta").val();
             var strCont = cuenta.replace(/'/g, '"');
             var actionData = "{'cuenta': '" + strCont + "'}";
             loading.ini();
             $.ajax(
                {
                    url: "Sujeto/SAAENLACEA.aspx/buscaCuenta",
                    data: actionData,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {                       
                        if (eval('(' + reponse.d + ')') != null) {
                            Pinta_Grid(eval('(' + reponse.d + ')'));
                        }
                        else {
                            loading.close();
                            $.alerts.dialogClass = "incompletoAlert";
                            jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                            LimpiaValores();
                            $("#inp_cuenta").focus().select();
                        }
                    },                 
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
        }
        else {            
            $("#div_Mcuenta").empty().append("* Indique una cuenta institucional");
            $("#div_Mcuenta").css("visibility", "visible");            
        }

            }

    //GUARDA UN ENLACE OPERATIVO
     function Guardar() {
         var idusuario = $('#lbl_id').val();       
         loading.ini();
         if ($("#cbx_eop").is(':checked')) {           
             var check = 'S';
         } 
         else {            
             var check = 'N';
         }
         //guardar un nuevo enlace operativo
         if (Accion == "NUEVO") {            
             var actionData = "{'idusuario': '" + idusuario + "','check': '" + check + "','Usuario': '" + Usuario + "','intIdDepcia': '" + intIdDependencia + "','intIdProceso': '" + intIdProceso + "'}";

             if (idusuario != "") {
                 if (idusuario != Usuario) {
                     $.ajax(
                        {
                            url: "Sujeto/SAAENLACEA.aspx/nuevoEnlace",
                            data: actionData,
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {                                
                                loading.close();
                                switch (reponse.d) {
                                    case 0:
                                        $.alerts.dialogClass = "incompletoAlert";
                                        jAlert("El usuario ya está registrado como Enlace Operativo.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                        break;
                                    case 1:
                                        $.alerts.dialogClass = "correctoAlert";
                                        jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                        break;
                                    case 2:
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //guardar el enlace operativo
                                        break;
                                    case 3:
                                        $.alerts.dialogClass = "incompletoAlert";
                                        jAlert("El usuario ya está registrado como Enlace Operativo Receptor.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //guardar el enlace operativo
                                        break;
                                    case 5:
                                        $.alerts.dialogClass = "incompletoAlert";
                                        jAlert("El usuario ya está registrado como Supervisor.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //guardar el enlace operativo
                                        break;                                    
                                    default:
                                }
                                LimpiaValores();                               
                                Cancelar();
                            },                          
                            error: function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        }
                        );
                 }
                    else {
                        loading.close();
                        $.alerts.dialogClass = "incompletoAlert";
                     jAlert("No puede ser Sujeto Obligado y enlace operativo de un mismo proceso.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                 }
             }
             else {
                 loading.close();
                 $.alerts.dialogClass = "incompletoAlert";
                 jAlert("Favor de buscar antes una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
             }
         }
         else {
         //Modificar un enlace operativo
             if (Accion == "MODIFICAR") {
                 var actionData = "{'idusuario': '" + idusuario + "','check': '" + check + "','Usuario': '" + Usuario + "','intIdDepcia': '" + intIdDependencia + "','intIdProceso': '" + intIdProceso + "'}";

                 $.ajax(
                        {
                            url: "Sujeto/SAAENLACEA.aspx/modificarEnlace",
                            data: actionData,
                            dataType: "json",
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            success: function (reponse) {
                                loading.close();
                                 var json = eval(reponse.d);                                
                                if (json) {
                                    $.alerts.dialogClass = "correctoAlert";
                                    jAlert('Operación realizada satisfactoriamente.', 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                                else {
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert('Ha sucedido un error inesperado, inténtelo más tarde.', 'SISTEMA DE ENTREGA - RECEPCIÓN');
                                }
                                LimpiaValores();
                               
                                Cancelar();
                            },
                                error: function (result) {
                                loading.close();
                                $.alerts.dialogClass = "errorAlert";
                                jAlert("Ha sucedido un error inesperado, por favor inténtelo más tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        }
                    );
             }
         }
     }


     //PINTA EN EL FORMULARIO LOS DATOS RESULTADO DE LA BÚSQUEDA 
     function Pinta_Grid(cadena) {        
         if (cadena == null) {           
             LimpiaValores();
             $("#inp_cuenta").focus().select();
             return false;
         }
         
         var tab = cadena;        
         for (a_i = 1; a_i < tab.length; a_i++) {
             $('#lbl_id').val(tab[a_i].idUsuario);
             $('#inp_npersonal').val(tab[a_i].intNumPersonal);
             $('#inp_nombre').val(tab[a_i].strNombre + ' ' + tab[a_i].strApPaterno + ' ' + tab[a_i].strApMaterno);
             $('#inp_correo').val(tab[a_i].strCorreo);
             $('#inp_dependencia').val(tab[a_i].strsDCDepcia);
             $('#inp_puesto').val(tab[a_i].strsDCPuesto);           
         }
         loading.close();
     }

   
   //Permite redireccionar a otra ventana
     function Cancelar() {
         urls(7,"Sujeto/SAAENLACE.ASPX");         
     }


    </script>

    <form id="form1" runat="server">
    <div id="agp_contenido">
        <div id="agp_navegacion">
            <label id='titulo' class="titulo"></label>
        </div>        

        <!-- Desplegado contenidos -->
        <h3>Cuenta institucional:</h3> 
            <input autofocus id="inp_cuenta" type="text" name="cuenta" maxlength="25" size="50"/>
            <a id="hrf_bus" class="accbuscar" title="Buscar" href="javascript:Buscar();"  onmouseover="MM_swapImage('ico_busqueda','','../images/buscarO.png',1)" onmouseout="MM_swapImgRestore()"><img id="ico_busqueda" alt="Icono de busqueda de usuario" src="../images/buscar.png" /></a>
            <label id="div_Mcuenta" class="requeridog"></label>
            <label id="lbl_id" visible ="false" ></label><br />
            
        <div id="agp_DatosEnlace">
            <h3>Número de personal:</h3> <input  id="inp_npersonal" type="text" name="npersonal" readonly="readonly" size="75" disabled="disabled"/><br />
            <h3>Nombre:</h3> <input id="inp_nombre" type="text" name="cuenta" readonly="readonly" size="75" disabled="disabled"/><br />            
            <h3>Dependencia/entidad académica a la que pertenece:</h3> <input id="inp_dependencia" type="text" readonly="readonly" name="cuenta" size="75" disabled="disabled"/><br />
            <h3>Puesto/cargo:</h3> <input id="inp_puesto" type="text" name="cuenta" readonly="readonly" size="75" disabled="disabled"/><br />
            <h3 id="hcorreo">Correo electrónico:</h3> <input id="inp_correo" type="text" name="cuenta" readonly="readonly" size="75" disabled="disabled"/><br />
        </div>
        <h3>Enlace operativo principal:</h3> <input  id="cbx_eop" type="checkbox" name="check"/><br/><br />
            
        <!-- fin Desplegado contenidos -->
        <div class="a_botones">
            <a title="Botón Guardar" id="GuardarActivo" href="javascript:Guardar();" class="btnAct">Guardar</a> 
            <a title="Botón Cancelar" id="CancelarActivo" href="javascript:Cancelar();" class="btnAct">Cancelar</a>        
        </div>
        <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" />
            <asp:HiddenField ID="hf_intDependencia" runat="server" />
            <asp:HiddenField ID="hf_intProceso" runat="server" />
          
        </div>
    </div>
    </form>

</body>
</html>
