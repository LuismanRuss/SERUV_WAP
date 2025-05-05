<%@ Page Language="C#" AutoEventWireup="true" Inherits="SAAENLAORA" Codebehind="SAAENLAORA.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   
    <%--<link href="../styles/Guia.css" rel="stylesheet" type="text/css" /> --%>
   <%-- <script src="../scripts/DataTables.js" type="text/javascript"></script>--%>
   <%-- <script src="../scripts/Libreria.js" type="text/javascript"></script>  --%>
   <%--<link href="../styles/Guia.css" rel="stylesheet" type="text/css" />--%>
    
   
</head>
<body>
<script type="text/javascript">
     var Accion;
     var strUsuario = $('#hf_idUsuario').val();
     var strJsonN;
     var strJsonC;
     var strDatosUsuarioR;
     var intIdDependencia = $('#hf_intDependencia').val(); 
     var intIdProceso = $('#hf_intProceso').val();

     $(document).ready(function () {   
        //verifica si el check de enlace operativo principal está checkeado      
         $("#cbx_eop").click(function () {
             if ($("#cbx_eop").is(':checked')) {
                 $("#cbx_eop").attr('checked', true);
             }
             else {
                 $("#cbx_eop").attr('checked', false);
             }

         });
         //----------------------------------------

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
                 //return false
             }

             $("#inp_cuenta").change(function () {
                 if ($(this).val() != "") {
                     $("#div_Mcuenta").css("visibility", "hidden");
                 }
             });
         });

         NG.setNact(2, 'Dos', null);
         //identifica si la forma va a ser utilizada para modificar ó agregar uno nuevo
         if (NG.Var[NG.Nact - 1].datoSel != null) {
             $('#titulo').text("Modificar enlace operativo receptor");
             $('#instrucciones').text("Ingrese la cuenta institucional del empleado que desee modificar.");
             Accion = "MODIFICAR";
             AsignarValores();
         }
         else {
             Accion = "NUEVO";
             LimpiaValores();
             $('#titulo').text("Alta enlace operativo receptor");
             $("#inp_cuenta").click(function () {
                 LimpiaValores();
             });
             fCambia();
         }

     });

    //***********************************************************************************************************************************
     //ASIGNA VALORES AL FORMULARIO EN EL CASO DE MODIFICAR UN ENLACE OPERATIVO
     function AsignarValores() {
         strJsonC = NG.Var[NG.Nact - 1].datoSel;        
         $("#hrf_bus").css('visibility', 'hidden');
         $("#ico_busqueda").css('visibility', 'hidden');         

         if (NG.Var[NG.Nact - 1].datoSel.intNumDependencia != "0") {

             $('#inp_npersonal').val(NG.Var[NG.Nact - 1].datoSel.intNumPersonal);
             $('#inp_cuenta').val(NG.Var[NG.Nact - 1].datoSel.strCuenta);
             $('#lbl_id').val(NG.Var[NG.Nact - 1].datoSel.idUsuario);
             $('#inp_nombre').val(NG.Var[NG.Nact - 1].datoSel.strNombre + ' ' + NG.Var[NG.Nact - 1].datoSel.strApPaterno + ' ' + NG.Var[NG.Nact - 1].datoSel.strApMaterno);
             $('#inp_correo').val(NG.Var[NG.Nact - 1].datoSel.strCorreo);
             $('#inp_dependencia').val(NG.Var[NG.Nact - 1].datoSel.strsDCDepcia);
             $('#inp_puesto').val(NG.Var[NG.Nact - 1].datoSel.strsDCPuesto);

             $("#inp_npersonal").prop('readonly', 'readonly');
             $("#inp_cuenta").prop('readonly', 'readonly');
             $("#inp_nombre").prop('readonly', 'readonly');
             $("#inp_correo").prop('readonly', 'readonly');
             $("#inp_dependencia").prop('readonly', 'readonly');
             $("#inp_puesto").prop('readonly', 'readonly');
         }
         else {
             $('#hinst').text("Institución:");
             $('#hcargo').text("Cargo:");

             $('#inp_npersonal').val(NG.Var[NG.Nact - 1].datoSel.intNumPersonal);
             $('#inp_cuenta').val(NG.Var[NG.Nact - 1].datoSel.strCuenta);
             $('#lbl_id').val(NG.Var[NG.Nact - 1].datoSel.idUsuario);
             $('#inp_nombre').val(NG.Var[NG.Nact - 1].datoSel.strNombre + ' ' + NG.Var[NG.Nact - 1].datoSel.strApPaterno + ' ' + NG.Var[NG.Nact - 1].datoSel.strApMaterno);
             $('#inp_correo').val(NG.Var[NG.Nact - 1].datoSel.strCorreo);
             $('#inp_dependencia').val(NG.Var[NG.Nact - 1].datoSel.strInstitucion);
             $('#inp_puesto').val(NG.Var[NG.Nact - 1].datoSel.strCargo);

             $("#inp_cuenta").prop('readonly', 'readonly');
            
         }

         if (NG.Var[NG.Nact - 1].datoSel.chrPrincipal == 'S') {
             $("#cbx_eop").attr('checked', true);
         }
     }

     //Cambia la propiedad a los input a readonly
     function fCambia() {
         $("#inp_npersonal").prop('readonly', 'readonly');     
         $("#inp_nombre").prop('readonly', 'readonly');
         $("#inp_correo").prop('readonly', 'readonly');
         $("#inp_dependencia").prop('readonly', 'readonly');
         $("#inp_puesto").prop('readonly', 'readonly');
     }

   
     
     //***************************************************************************************************************
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

     //***************************************************************************
     //Valida que exista una cuenta para buscar un usuario a paratir de la cuenta institucional
     function Buscar() {
            $("#inp_cuenta").val(jsTrim($("#inp_cuenta").val()));
            if ($("#inp_cuenta").val().length > 0) {
                BuscaUsuarios();              
            }
            else {
                $.alerts.dialogClass = "incompletoAlert";
                jAlert("Indique una cuenta institucional.", "SISTEMA DE ENTREGA - RECEPCIÓN");
            }
        }
        //Sustituye los saltos de linea por espacios en blanco
        function jsTrim(sString) {
            return sString.replace(/^\s+|\s+$/g, "");
        }

        //Busca un usuario a partir de la cuenta institucional
        function BuscaUsuarios() {
            loading.ini();
            var strCont = $("#inp_cuenta").val().replace(/'/g, '"');
            var strParametros = "{'sCuenta': '" + strCont + "'}";
         $.ajax(
                {
                    url: "Sujeto/SAAENLAORA.aspx/BuscaUsuario",
                    data: strParametros,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {
                        loading.close();
                        if (reponse.d != null) {
                            var objRespuesta = eval('(' + reponse.d + ')');
                            var resp = objRespuesta.Respuesta;
                            var strMensaje = (objRespuesta.msj == null ? "" : objRespuesta.msj);
                            switch (resp) {
                                case "-4":
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); // No se logró conectar con la base de datos de Oracle.
                                    LimpiaValores();
                                    break
                                case "-3": //EL USUARIO NO ESTA EN LA BD DE ORACLE
                                    $.alerts.dialogClass = "incompletoAlert";
                                    if (strMensaje == "") {
                                        jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    } else {
                                        jAlert(strMensaje, "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    }

                                    LimpiaValores();
                                    $("#inp_cuenta").focus().select();
                                    break;
                                case "-2": //NO SE EJECUTO EL QUERY DE ORACLE                                    
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("No se pudo consultar el usuario. \n" + strMensaje, "SISTEMA DE ENTREGA - RECEPCIÓN"); // de oracle
                                    LimpiaValores();
                                    break;
                                case "-1": //NO SE EJECUTO EL QUERY DE SQL                                    
                                    $.alerts.dialogClass = "incompletoAlert";
                                    jAlert("La cuenta institucional no está registrada.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                    LimpiaValores();
                                    break;
                                case "0": // EL USUARIO YA EXISTE
                                    $.alerts.dialogClass = "errorAlert";
                                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                    LimpiaValores();

                                    break;
                                default: //EN OTRO CASO TRAE EL ID DEL USUARIO Y MUESTRA LOS DATOS 
                                    resp = jsTrim(resp);
                                    if (resp.length > 0) {
                                        strDatosUsuarioR = eval('(' + resp + ')');
                                        MuestraDatosUsuario(eval('(' + resp + ')'));
                                    } else {
                                        LimpiaValores();
                                        $.alerts.dialogClass = "errorAlert";
                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                    }
                                    break;
                            }
                        } else {
                            $.alerts.dialogClass = "errorAlert";
                            jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                            LimpiaValores();
                        }
                    },              
                    error: function (result) {
                        loading.close();
                        $.alerts.dialogClass = "errorAlert";
                        jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                    }
                }
            );
     }
     //*******************************************************************************************************************
     //Muestra los datos del usuario seleccionado
     function MuestraDatosUsuario(sDatos) {
         var a_i = 0;
        
         $("#inp_npersonal").val(sDatos[a_i].intNumPersonal);
         $("#inp_nombre").val(sDatos[a_i].strNombre + " " + sDatos[a_i].strApPaterno + " " + sDatos[a_i].strApMaterno);
         $("#inp_correo").val(sDatos[a_i].strCorreo);
         $('#lbl_id').val(sDatos[a_i].idUsuario);
         $("#inp_dependencia").val(sDatos[a_i].strsDCDepcia);
         $("#inp_puesto").val(sDatos[a_i].strsDCPuesto);
         strJsonN = sDatos;    
         if (sDatos[a_i].intNumDependencia != 0) {          

             $("#inp_npersonal").prop('readonly', 'readonly');           
             $("#inp_nombre").prop('readonly', 'readonly');
             $("#inp_correo").prop('readonly', 'readonly');
             $("#inp_dependencia").prop('readonly', 'readonly');
             $("#inp_puesto").prop('readonly', 'readonly');
         }
         
     }
     //************************************************************************************************************************
    

     //GUARDA UN ENLACE OPERATIVO
     function Guardar() {
         var check;
         var idusuario = $('#lbl_id').val();         
         
         if ($("#cbx_eop").is(':checked')) {
              check = 'S';
         }
         else {
              check = 'N';
         }
       //crear un enlace operativo
         if (Accion == "NUEVO") {
             if (ValidaDatosUsuario()) {               
                 if ($.isNumeric($("#inp_npersonal").val())) {
                        $("#div_txtPerson2").css("visibility", "hidden");
                        GuardarUsuario();                        
                    }
                    else {
                        $("#div_txtPerson2").css("visibility", "visible");
                    }  
             }
         }
            else {
         //modifica un enlace operativo
             if (Accion == "MODIFICAR") {
                 loading.ini();
                 a_i = 0;
                 var strNombre = "";
                 var strPaterno = "";
                 var strMaterno = "";
                
                 if (NG.Var[NG.Nact - 1].datoSel.intNumDependencia != "0") {
                      strNombre = NG.Var[NG.Nact - 1].datoSel.strNombre;
                      strPaterno = NG.Var[NG.Nact - 1].datoSel.strApPaterno;
                      strMaterno = NG.Var[NG.Nact - 1].datoSel.strApMaterno;
                    strParametros = "{'nDepcia': '" + intIdDependencia +                   
                                "','sNombre': '" + strNombre +
                                "','sApPaterno': '" + strPaterno +
                                "','sApMaterno': '" + strMaterno +                    
                                "','sCorreo': '" + $('#inp_correo').val() +                    
                                "','idSujetObligado': '" + strUsuario +
                                "','idusuario': '" + idusuario +
                                "','intIdProceso': '" + intIdProceso +
                                "','check': '" + check +
                                 "','sInstitucion': '" + null +
                                 "','sCargo': '" + null +
                                "'}";
                }
                else {

                    //****************************************
                    
                    var snombre = $("#inp_nombre").val().split(' ');  
                    for (a_i = 0; a_i < snombre.length - 2; a_i++) {
                       if (a_i == 0) {
                            strNombre += snombre[a_i];
                        }
                        else {                           
                            strNombre += " " + snombre[a_i];                         
                        }
                    }
                    
                     strPaterno = snombre[snombre.length - 2];                    
                     strMaterno = snombre[snombre.length - 1];


                     //***************************************
                     var strCorreo = $('#inp_correo').val().replace(/'/g, '"');
                     var strInstitucion = $('#inp_dependencia').val().val().replace(/'/g, '"');
                     var strCargo = $('#inp_puesto').val().replace(/'/g, '"');

                    //********************************************
                    strParametros = "{'nDepcia': '" + intIdDependencia +                    
                                "','sNombre': '" + strNombre +
                                "','sApPaterno': '" + strPaterno +
                                "','sApMaterno': '" + strMaterno +                    
                                "','sCorreo': '" + strCorreo +                   
                                "','idSujetObligado': '" + strUsuario +
                                "','idusuario': '" + idusuario +
                                "','intIdProceso': '" + intIdProceso +
                                "','check': '" + check +
                                 "','sInstitucion': '" + strInstitucion +
                                 "','sCargo': '" + strCargo +
                                "'}";
                }
                $.ajax(
                        {
                            url: "Sujeto/SAAENLAORA.aspx/modificarUsuario_EnlaceReceptor",
                            data: strParametros,
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
                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
                            }
                        }
                    );
             }
         }
     }


            //*************************************************************************************************************
            //REGISTRA UN USUARIO COMO ENLACE OPERATIVO RECEPTOR
     function GuardarUsuario() {
                var check;
                var idusuario = $('#lbl_id').val();
                loading.ini();
                if ($("#cbx_eop").is(':checked')) {
                     check = 'S';
                }
                else {
                     check = 'N';
                }
                var a_i = 0;
                        if (strDatosUsuarioR != null) {
                           if (strDatosUsuarioR[a_i].intNumDependencia != "0") {
                                strParametros = "{'nDepcia': '" + intIdDependencia +
                                    "','nidDependencia': '" + strDatosUsuarioR[a_i].intNumDependencia +
                                     "','nPuesto': '" + strDatosUsuarioR[a_i].intPuesto +
                                     "','sNombre': '" + strDatosUsuarioR[a_i].strNombre +
                                     "','sApPaterno': '" + strDatosUsuarioR[a_i].strApPaterno +
                                     "','sApMaterno': '" + strDatosUsuarioR[a_i].strApMaterno +
                                     "','sCuenta': '" + strDatosUsuarioR[a_i].strCuenta +
                                     "','nNumPersonal': '" + strDatosUsuarioR[a_i].intNumPersonal +
                                     "','sCorreo': '" + strDatosUsuarioR[a_i].strCorreo +
                                     "','nTper': '" + strDatosUsuarioR[a_i].intTipPersonal +
                                     "','nCategoria': '" + strDatosUsuarioR[a_i].intCategoria +
                                     "','cIndEmpleado': '" + strDatosUsuarioR[a_i].chrIndEmpleado +
                                     "','cIndActivo': '" + strDatosUsuarioR[a_i].chrIndActivo +
                                     "','idSujetObligado': '" + strUsuario +
                                      "','intIdProceso': '" + intIdProceso +
                                      "','check': '" + check +
                                      "','nUsuario': '" + strUsuario +
                                      "','sInstitucion': '" + null +
                                      "','sCargo': '" + null +
                                      "'}";
                            }
                            else {
                                strParametros = "{'nDepcia': '" + intIdDependencia +
                                    "','nidDependencia': '" + 0 +
                                     "','nPuesto': '" + strDatosUsuarioR[a_i].intPuesto +
                                     "','sNombre': '" + strDatosUsuarioR[a_i].strNombre +
                                     "','sApPaterno': '" + strDatosUsuarioR[a_i].strApPaterno +
                                     "','sApMaterno': '" + strDatosUsuarioR[a_i].strApMaterno +
                                     "','sCuenta': '" + strDatosUsuarioR[a_i].strCuenta +
                                     "','nNumPersonal': '" + strDatosUsuarioR[a_i].intNumPersonal +
                                     "','sCorreo': '" + strDatosUsuarioR[a_i].strCorreo +
                                     "','nTper': '" + strDatosUsuarioR[a_i].intTipPersonal +
                                     "','nCategoria': '" + strDatosUsuarioR[a_i].intCategoria +
                                     "','cIndEmpleado': '" + strDatosUsuarioR[a_i].chrIndEmpleado +
                                     "','cIndActivo': '" + strDatosUsuarioR[a_i].chrIndActivo +
                                     "','idSujetObligado': '" + strUsuario +
                                      "','intIdProceso': '" + intIdProceso +
                                      "','check': '" + check +
                                      "','nUsuario': '" + strUsuario +
                                      "','sInstitucion': '" + strDatosUsuarioR[a_i].strInstitucion +
                                      "','sCargo': '" + strDatosUsuarioR[a_i].strCargo +
                                      "'}";
                            }
               
                                if (idusuario != strUsuario) {

                                            $.ajax(
                                        {
                                            url: "Sujeto/SAAENLAORA.aspx/fGuardarInformacion",
                                            data: strParametros,
                                            dataType: "json",
                                            type: "POST",
                                            contentType: "application/json; charset=utf-8",
                                            success: function (reponse) {
                                                loading.close();
                                                var resp = reponse.d;
                                                switch (resp) {
                                                    case 0:
                                                        $.alerts.dialogClass = "errorAlert";
                                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                                        break;
                                                    case 1:
                                                        $.alerts.dialogClass = "correctoAlert";
                                                        jAlert("Los datos del usuario se han guardado satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                                        break;
                                                    case 2:
                                                        $.alerts.dialogClass = "errorAlert";
                                                        jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                                        break;
                                                    case 3:
                                                        $.alerts.dialogClass = "incompletoAlert";
                                                        jAlert("El usuario ya existe como Enlace Operativo Receptor.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                                                        break;
                                                    case 4:
                                                        $.alerts.dialogClass = "incompletoAlert";
                                                        jAlert("El usuario ya existe como Enlace Operativo.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                                        break;
                                                    case 6:
                                                        $.alerts.dialogClass = "incompletoAlert";
                                                        jAlert("El usuario ya está registrado como Supervisor.", "SISTEMA DE ENTREGA - RECEPCIÓN");
                                                        break;

                                                }
                                                
                                                Cancelar();
                                            },                                          
                                            error: function (result) {
                                                loading.close();
                                                $.alerts.dialogClass = "errorAlert";
                                                jAlert("Ha sucedido un error inesperado, por favor intentelo mas tarde", 'SISTEMA DE ENTREGA - RECEPCIÓN');
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
                                    LimpiaValores();
                                    $.alerts.dialogClass = "incompletoAlert";
                            jAlert("Favor de buscar su cuenta.", "SISTEMA DE ENTREGA - RECEPCIÓN"); //La operación no pudo ser realizada.
                }
            }
                              

     //***********************************************************************************************************************
     //valida que el número de personal este escrito
     function ValidaDatosUsuario() {
         blnCorrecto = false;
         var npersonal = frms.trim($("#inp_npersonal").val());
         if (npersonal.length > 0) {
             blnCorrecto = true;
         } else {
             loading.close();
             $.alerts.dialogClass = "incompletoAlert";
             jAlert("Indique un número de personal.", "SISTEMA DE ENTREGA - RECEPCIÓN");
         }
         return blnCorrecto;
     }
     //*********************************************************************************************************************
    
     //PINTA EN EL FORMULARIO LOS DATOS RESULTADO DE LA BUSQUEDA 
     function Pinta_Grid(sCadena) {
         if (sCadena == null) {
             loading.close();
             $.alerts.dialogClass = "incompletoAlert";
             jAlert('La cuenta no existe', 'SISTEMA DE ENTREGA - RECEPCIÓN');
             return false;
         }
         var tab = sCadena;       
         for (a_i = 1; a_i < tab.length; a_i++) {
             $('#lbl_id').val(tab[a_i].idUsuario);
             $('#inp_npersonal').val(tab[a_i].intNumPersonal);
             $('#inp_nombre').val(tab[a_i].strNombre + ' ' + tab[a_i].strApPaterno + ' ' + tab[a_i].strApMaterno);
             $('#inp_correo').val(tab[a_i].strCorreo);
             $('#inp_dependencia').val(tab[a_i].strsDCDepcia);
             $('#inp_puesto').val(tab[a_i].strsDCPuesto);
         }
     }



     function Cancelar() {        
         urls(9, "Sujeto/SAAENLAOR.ASPX");
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
            <h3>Número de personal:</h3> <input  id="inp_npersonal" type="text" name="npersonal" size="75" maxlength="4"/><br />
            <%--<div id="div_txtPerson" class="requeridog">* Campo requerido</div>--%>
            <div id="div_txtPerson2" class="requeridog">* Campo numerico</div>

            <h3>Nombre:</h3> <input id="inp_nombre" type="text" name="cuenta"  size="75" maxlength="62" /><br />            
            <h3 id="hinst">Dependencia/entidad o institución a la que pertenece:</h3> <input id="inp_dependencia" type="text" name="cuenta" size="75" maxlength="50"/><br />
            <h3 id="hcargo" >Puesto/cargo:</h3> <input id="inp_puesto" type="text" name="cuenta"  size="75" maxlength="40" /><br />
            <h3 id="hcorreo">Correo electrónico:</h3> <input id="inp_correo" type="text" name="cuenta"  size="75" maxlength="40"/><br />
        </div>
        <h3>Enlace operativo receptor principal:</h3> <input  id="cbx_eop" type="checkbox" name="check"/><br/><br />
            
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
