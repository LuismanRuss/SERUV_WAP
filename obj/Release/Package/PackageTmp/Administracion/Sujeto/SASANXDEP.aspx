<%@ Page Language="C#" AutoEventWireup="true" Inherits="SASANXDEP" Codebehind="SASANXDEP.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <script src="../scripts/Libreria.js" type="text/javascript"></script>
    
</head>
<body>
    <script type="text/javascript">


        var intApartado;
        var indSujetoOb; // VALOR S/N
        var indEnlaceOp; // VALOR S/N
        var intProceso; //id del proceso que corresponde a la persona que se loguea
        var intIdSujetoOb; //id del sujeto obligado
        var strNombreSujetoOb; //nombre del sujeto obligado independiente mente de la persona que se logue
        var strDatosUsuarioLOG = null;
        var strDatosDepcia = null;
        var strEntrega= null;
        var intIdPerfil;



        $(document).ready(function () {            
            NG.setNact(1);           
            $('#IdParticipante').val(0);
            $('#hf_intProceso').val(0);
            $('#hf_intDependencia').val(0);

            $("#ExcluirActivo").hide();
            $("#ExcluirInactivo").show();
            
            ListTipoproc($('#hf_idUsuario').val());


            if (NG.Var[NG.Nact].oSets == null) {
            } 
            else {
                NG.repinta();
            }


            $("#slc_PER").change(function () {             
                ListDepcia($('#slc_PER option:selected').val(), $('#hf_idUsuario').val());               
            });


            $("#slc_Depcia").change(function () {
               
                var intIdDepcia = $('#slc_Depcia option:selected').val();
                var intIdProceso = $('#slc_PER option:selected').val();
                FObtieneDepcia(intIdDepcia);
               
                if (intIdDepcia != null && intIdProceso != null) {                   
                    $('#lblSujeto').text(strNombreSujetoOb);

                    Ajax(intIdDepcia, intIdProceso, intIdSujetoOb);
                    Mostrar_Total_Anexos(intIdSujetoOb, intIdProceso, intIdDepcia);
                }
            });
        });

         //ASIGNA DATOS DEL SUJETO OBLIGADO
        function FObtieneSujeto(intIdProceso) {           
             for (a_i = 0; a_i < strDatosUsuarioLOG.length; a_i++) {
                 if (strDatosUsuarioLOG[a_i].idProceso == intIdProceso) {

                     indSujetoOb = strDatosUsuarioLOG[a_i].strIndSO; // VALOR S/N
                     indEnlaceOp = strDatosUsuarioLOG[a_i].strIndEOP; // VALOR S/N
                     intProceso = strDatosUsuarioLOG[a_i].idProceso; //id del proceso que corresponde a la persona que se loguea
                     intIdSujetoOb = strDatosUsuarioLOG[a_i].IDUsuarioSO; //id del sujeto obligado
                     strNombreSujetoOb = strDatosUsuarioLOG[a_i].strNomSO; //nombre del sujeto obligado independiente mente de la persona que se logue
                     intIdPerfil = strDatosUsuarioLOG[a_i].IDPerfil;
                     if (intIdPerfil == 6) {                      
                         NombreSO($('#hf_idUsuario').val());
                     }
                     else {
                         $('#hUsuario').empty();
                         $('#lblUsuario').empty();
                     }

                     $('#hf_indSO').val(strDatosUsuarioLOG[a_i].strIndSO); // VALOR S/N
                     $('#hf_indEOP').val(strDatosUsuarioLOG[a_i].strIndEOP); // VALOR S/N
                     $('#hf_intIdProceso').val(strDatosUsuarioLOG[a_i].idProceso);  //id del proceso que corresponde a la persona que se loguea
                     $('#hf_idSO').val(strDatosUsuarioLOG[a_i].IDUsuarioSO); //id del sujeto obligado
                     $('#hf_strNomSO').val(strDatosUsuarioLOG[a_i].strNomSO); //nombre del sujeto obligado independiente mente de la persona que se logue
                 }

                }
         }

         //OBTIENE EL SUJETO OBLIGADO, ENLACE OPERATIVO, APARTADOS Y ANEXOS A PARTIR DE UN IDENTIFICADOR DE LA DEPENDENCIA
         function FObtieneDepcia(intIdDepcia) {
             for (a_i = 0; a_i < strDatosDepcia.length; a_i++) {
                 if (strDatosDepcia[a_i].nDepcia == intIdDepcia) {

                     indSujetoOb = strDatosDepcia[a_i].strIndSO; // VALOR S/N
                     indEnlaceOp = strDatosDepcia[a_i].strIndEOP; // VALOR S/N
                     intProceso = strDatosDepcia[a_i].idProceso; //id del proceso que corresponde a la persona que se loguea
                     intIdSujetoOb = strDatosDepcia[a_i].IDUsuarioSO; //id del sujeto obligado
                     strNombreSujetoOb = strDatosDepcia[a_i].strNomSO; //nombre del sujeto obligado independiente mente de la persona que se logue
                     intIdPerfil = strDatosDepcia[a_i].IDPerfil;
                     intDependencia = strDatosDepcia[a_i].nDepcia; // VALOR S/N
                     strDependencia = strDatosDepcia[a_i].sDDepcia; // VALOR S/N
                     strEntrega = strDatosDepcia[a_i].sNombre; //id del proceso que corresponde a la persona que se loguea
                   
                     $('#hf_indSO').val(strDatosDepcia[a_i].strIndSO); // VALOR S/N
                     $('#hf_indEOP').val(strDatosDepcia[a_i].strIndEOP); // VALOR S/N
                     $('#hf_intIdProceso').val(strDatosDepcia[a_i].idProceso);  //id del proceso que corresponde a la persona que se loguea
                     $('#hf_idSO').val(strDatosDepcia[a_i].IDUsuarioSO); //id del sujeto obligado
                     $('#hf_strNomSO').val(strDatosDepcia[a_i].strNomSO); //nombre del sujeto obligado independiente mente de la persona que se logue

                     if (intIdPerfil == 6) {                         
                         NombreSO($('#hf_idUsuario').val());
                     }
                     else {
                         $('#hUsuario').empty();
                         $('#lblUsuario').empty();
                     }

                
                 }

             }
         }

         //LISTA LOS PROCESO EN LOS QUE PARTICIPA UN DETERMINADO SUJETO OBLIGADO
        function ListTipoproc(intIdSujetoObli) {
            var actionData = "{'intIdSujetoOb': " + intIdSujetoObli + "}"; ;
            $.ajax({
                url: "Sujeto/SASANXDEP.aspx/DibujaListTipoProc",
                data: actionData,
                dataType: "json",
                async: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {                   
                    if (reponse.d != null) {
                        strDatosUsuarioLOG = eval('(' + reponse.d + ')');
                        loadListTipProc(eval('(' + reponse.d + ')'));
                    }
                    else {
                        $('.div_ctdobligaciones').css('display', 'none');
                        $('#div_datosPyD').css('display', 'none');
                        $('#titulos').css('display', 'none');
                        $('#Anexos').css('display', 'none');
                        $('.notapie').css('display', 'none');
                        $('.instrucciones').css('display', 'none');
                        $('.a_acciones').css('display', 'none');
                        $('#div_mensaje').append('No tiene asociado un proceso y una dependencia');
                        loading.close();
                    }
                   
                    if (strDatosUsuarioLOG != null) {                     
                        ListDepcia($('#slc_PER option:selected').val(), $('#hf_idUsuario').val());
                    }
                },
                error: function (result) {
                    loading.close();                 
                }
            }); 
        } 

        //PINTA LOS PROCEDIMIENTOS ALMACENADOS DE UN DETERMINADO SUJETO OBLIGADO
        function loadListTipProc(strDatos) {

            if (strDatos == null) {
                $('.div_ctdobligaciones').css('display', 'none');
                $('#div_datosPyD').css('display', 'none');
                $('#titulos').css('display', 'none');
                $('#Anexos').css('display', 'none');
                $('.notapie').css('display', 'none');
                $('.instrucciones').css('display', 'none');
                $('.a_acciones').css('display', 'none');
                $('#div_mensaje').append('No tiene asociado un proceso y una dependencia');
                loading.close();              
                return false;
            }
            else {
                for (a_i = 0; a_i < strDatos.length; a_i++) {                  
                    listItem = $('<option></option>').val(strDatos[a_i].idProceso).html(strDatos[a_i].strDProceso);
                    $('#slc_PER').append(listItem);                   
                }
            }
           
        }

        //REALIZA UNA CONSULTA DE LAS DEPENDENCIAS CORRESPONDIENTES A UN PROCESO Y UN DETERMINADO SUJETO OBLIGADO
        function ListDepcia(intIdProceso, intUsuariolog) {
            var actionData = "{'intIdProceso': " + intIdProceso + ",'intUsuariolog': " + intUsuariolog + "}";
            $.ajax({
                url: "Sujeto/SASANXDEP.aspx/DibujaListDepcia",
                data: actionData,
                async: false,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (reponse) {
                    strDatosDepcia = eval('(' + reponse.d + ')');
                    loadListDepcia(eval('(' + reponse.d + ')'));

                    if (strDatosDepcia != null) {
                        FObtieneDepcia($('#slc_Depcia option:selected').val());
                        var intIdDepcia = $('#slc_Depcia option:selected').val();
                        var intIdProceso = $('#slc_PER option:selected').val();

                        if (intIdDepcia != null && intIdProceso != null) {                          
                            $('#lblSujeto').text(strNombreSujetoOb);
                            Ajax(intIdDepcia, intIdProceso, intIdSujetoOb);
                            Mostrar_Total_Anexos(intIdSujetoOb, intIdProceso, intIdDepcia);
                        }                     
                    }
                },
                error: function (result) {              
                }
            });
        }
        //PINTA LAS DEPENDENCIAS DE UN PROCESO Y SUJETO OBLIGADO
        function loadListDepcia(strDatos) {
            $('#slc_Depcia').empty()
            if (strDatos == null) {
                $('.div_ctdobligaciones').css('display', 'none');
                $('#div_datosPyD').css('display', 'none');
                $('#titulos').css('display', 'none');
                $('#Anexos').css('display', 'none');
                $('.notapie').css('display', 'none');
                $('.instrucciones').css('display', 'none');
                $('.a_acciones').css('display', 'none');
                $('#div_mensaje').append('No tiene asociado un proceso y una dependencia');
                loading.close();             
                return false;
            }
            else {
                for (a_i = 0; a_i < strDatos.length; a_i++) {                   
                    listItem = $('<option></option>').val(strDatos[a_i].nDepcia).html(strDatos[a_i].sDDepcia);
                    $('#slc_Depcia').append(listItem);
                }               
                $('#hf_intProceso').val($('#slc_PER option:selected').val());
                $('#hf_intDependencia').val($('#slc_Depcia option:selected').val());                
            }
          
        }

      


//CONSULTA EL NOMBRE DEL SUJETO OBLIGADO
     function NombreSO(intIdUsuariolog) {
         var actionData = "{'intUsuariolog': " + intIdUsuariolog + 
                                          "}";
         $.ajax({
             url: "Sujeto/SASANXDEP.aspx/ObtieneNombreSO",
             data: actionData,
             async: false,
             dataType: "json",
             type: "POST",
             contentType: "application/json; charset=utf-8",
             success: function (reponse) {               
                 PintaNombreSO(eval('(' + reponse.d + ')'));

             },
             error: function (result) {
                 loading.close();              
             }
         });
     }

  //PINTA EL NOMBRE DEL SUJETO OBLIGADO
     function PintaNombreSO(strDatos) {       
         if (strDatos == null) {            
             $('#lblUsuario').text('No se ha podido obtener el nombre.');            
             return false;
         }
         else {
             for (a_i = 0; a_i < strDatos.length; a_i++) {               
                 $('#hUsuario').text("Enlace operativo: ");
                 $('#lblUsuario').text(strDatos[1].strNombre + ' ' + strDatos[1].strApPaterno + ' ' + strDatos[1].strApMaterno);   
             }
         }
     }

     //CONSULTA LOS APARTADOS QUE ESTÁN ACTIVOS Y APLICAN PARA SUJETO OBLIGADO
     function Ajax(nDepcia, nProceso, nSujetoObligado) {
         $('#hf_intProceso').val($('#slc_PER option:selected').val());
         $('#hf_intDependencia').val($('#slc_Depcia option:selected').val());
            var actionData = "{'nDepcia': " + nDepcia + ",'nProceso': " + nProceso + ",'nSujetoObligado': " + nSujetoObligado + "}";           
            $.ajax(
                {                   
                    url: "Sujeto/SASANXDEP.aspx/ObtenerDatos",
                    data: actionData,
                    async: false,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {                       
                        Pinta(eval('(' + reponse.d + ')'));
                        loading.close();
                    },
                    error: function (result) {
                        loading.close();                     
                     }
                }
            );
        }
        //PINTA UNA LISTA DE APARTADOS
        function Pinta(strCadena) {           
            $("input:radio").attr("checked", false);
            $("input:radio").removeAttr("checked");           
            $("#ExcluirActivo").hide();
            $("#ExcluirInactivo").show();
            $("#AccIncluir").hide();
            $("#AccIncluir2").show(); 
            $('#listaApartados').empty();            
            if (strCadena.resultado == '2') {
                $('#listaApartados').append('<li>' + strCadena.mensaje + '</li>');
                loading.close();
                return false;
            }
            //Asigno la cadena que contien los apartados
            $('#listaApartados').empty().append(pTablaI(strCadena.datos));

            //para aplicar color en la lista que ha sido seleccionada
            $("#listaApartados li").click(function () {
                $("#listaApartados li").removeClass("active");
                $(this).addClass("active");
            });
            $('#listaAnexos').empty();
        };

        

        //Construir la lista de apartados a  partir de datos
        function pTablaI(tab) {           
            NG.Var[NG.Nact].datos = tab;
            htmlTab = '';           
            for (a_i = 1; a_i < tab.length; a_i++) {               
                htmlTab += '<li id="aApartado' + tab[a_i].idAp + '"><a  href ="javascript:fAnexos(' + tab[a_i].idAp + ');" >' + tab[a_i].sApartado.toUpperCase() + ' ' + tab[a_i].Dapartado.toUpperCase() + '</a></li>';
            }            
            return htmlTab;
        }

        //CONSULTA ANEXOS POR DEPENDENCIA, PROCESO, SUJETO OBLIGADO Y APARTADO
        function fAnexos(idapartado) {
            MostrarAnexos(idapartado);            
        }
        //para consultar los anexos a partir de un apartado
        function MostrarAnexos(idApartado) {          
            intApartado = idApartado;
            $("#intApartado").val(idApartado);
            var idusuario = $('#hf_idUsuario').val();
            var idparticipante = $('#IdParticipante').val();           
            var intIdDepcia = $('#slc_Depcia option:selected').val();
            var intIdProceso = $('#slc_PER option:selected').val();         
            var actionData = "{'idApartado': " + idApartado + ",'idusuario': " + intIdSujetoOb + ",'intIdProceso': " + intIdProceso + ",'intIdDepcia': " + intIdDepcia + "}";
         
            $.ajax(
                {
                    url: "Sujeto/SASANXDEP.aspx/ObtenerAnexos",
                    data: actionData,
                    async: false,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {                      
                        PintaAnexos(eval('(' + reponse.d + ')'));
                        loading.close();
                    },
                    error: function (result) {
                        loading.close();                     
                     }
                });

            }
            //------------------------------------------------------------------------------

            //para consultar los anexos a partir de un apartado
            function Mostrar_Total_Anexos(nidSujetoOb,nidProceso, nidDepcia) {    
                var actionData = "{'idusuario': " + nidSujetoOb + ",'intIdProceso': " + nidProceso + ",'intIdDepcia': " + nidDepcia + "}";
               
                $.ajax(
                {
                    url: "Sujeto/SASANXDEP.aspx/ObtenerTotalAnexos",
                    data: actionData,
                    async: false,
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (reponse) {                   
                        PintaTotalAnexos(eval('(' + reponse.d + ')'));
                    },
                    error: function (result) {
                        loading.close();                      
                     }
                });

            }
            //PINTA LOS TOTALES DE ANEXOS AL CARGAR POR PRIMERA VEZ LA PÁGINA "ANEXOS APLICABLES"
            function PintaTotalAnexos(strCadena) {

                if (strCadena != null) {
                    var into = parseInt(strCadena.total);
                    var inta = parseInt(strCadena.aplica);
                    var intna = parseInt(strCadena.naplica);
                    
                    if (inta < 10) {
                        $('#ap').val("0" + inta);
                    }
                    else {
                        $('#ap').val(inta);
                    }
                    if (intna < 10) {
                        $('#nap').val("0" + intna);
                    }
                    else {
                        $('#nap').val(intna);
                    }

                    if (into < 10) {
                        $('#tot').val("0" + into);
                    }
                    else {
                        $('#tot').val(into);
                    }
                                       
                }
                else {
                    
                }
            }
        //-------------------------------------------------------------------------------

        //pinta la lista de Anexos
        function PintaAnexos(strCadena) {            
            $('#listaAnexos').empty();
            if (strCadena.resultado == '2') {
                $('#listaAnexos').append('<li>' + strCadena.mensaje + '</li>');              
                $('#ob').val(0);
                $('#ap').val(0);
                $('#nap').val(0);
                $('#tot').val(0);
                return false;
            }
            //asigna la lista de anexos 
            $('#listaAnexos').empty().append(pTablaIAnexos(strCadena.datos));

           //Deseleccionar  todos los radios 
            $("input:radio").attr("checked", false);
            $("input:radio").removeAttr("checked");
            //Mostrar y ocultar botones
            $("#ExcluirActivo").hide();
            $("#ExcluirInactivo").show();
            $("#AccIncluir").hide();
            $("#AccIncluir2").show();  
            
            //::::::::::::::::::::::::::::
            var into = parseInt(strCadena.total);
            var inta = parseInt(strCadena.aplica);
            var intna = parseInt(strCadena.naplica);
            //::::::::::::::::::::::::::::::::::::::

            if (inta < 10) {
                $('#ap').val("0" + inta);
            }
            else {
                $('#ap').val(inta);
            }
            if (intna < 10) {
                $('#nap').val("0" + intna);
            }
            else {
                $('#nap').val(intna);
            }
            if (into < 10) {
                $('#tot').val("0" + into);
            }
            else {
                $('#tot').val(into);
            }         

        
        };

        //Construir el formulario de radios
        function pTablaIAnexos(strTab) {           
            NG.Var[NG.Nact].datos = strTab;

            htmlTab = '<form id="radios" action="" >';
            for (a_i = 1; a_i < strTab.length; a_i++) {

                if (NG.Var[NG.Nact].selec == a_i) {                   
                    if (strTab[a_i].chrAlcance == 'G') {
                        htmlTab += '<input name="check" id="ch_' + strTab[a_i].idAnexo + '" type="radio" checked="checked" value="' + strTab[a_i].idAnexo + '" onclick="Cambia(\'' + strTab[a_i].idAnexo + '\',\'' + strTab[a_i].excluido + '\',\'' + strTab[a_i].sAnexo + '\',\'' + strTab[a_i].Danexo + '\')" disabled />' + strTab[a_i].excluido + ' ' + strTab[a_i].sAnexo.toUpperCase() + ' ' + strTab[a_i].Danexo.toUpperCase() + '<br>';
                    }
                    else {
                        if (strTab[a_i].entrega == "[Integrado]") {
                            htmlTab += '<input name="check" id="ch_' + strTab[a_i].idAnexo + '" type="radio" checked="checked" value="' + strTab[a_i].idAnexo + '" onclick="Cambia(\'' + strTab[a_i].idAnexo + '\',\'' + strTab[a_i].excluido + '\',\'' + strTab[a_i].sAnexo + '\',\'' + strTab[a_i].Danexo + '\')" disabled />' + strTab[a_i].excluido + ' ' + strTab[a_i].sAnexo.toUpperCase() + ' ' + strTab[a_i].Danexo.toUpperCase() + '<br>';
                        }
                        else {
                            htmlTab += '<input name="check" id="ch_' + strTab[a_i].idAnexo + '" type="radio" checked="checked" value="' + strTab[a_i].idAnexo + '" onclick="Cambia(\'' + strTab[a_i].idAnexo + '\',\'' + strTab[a_i].excluido + '\',\'' + strTab[a_i].sAnexo + '\',\'' + strTab[a_i].Danexo + '\')" />' + strTab[a_i].excluido + ' ' + strTab[a_i].sAnexo.toUpperCase() + ' ' + strTab[a_i].Danexo.toUpperCase() + '<br>';
                        }
                    }
                      
                }
                else {                   
                    if (strTab[a_i].chrAlcance == 'G') {
                        htmlTab += '<input name="check" id="ch_' + strTab[a_i].idAnexo + '" type="radio" value="' + strTab[a_i].idAnexo + '" onclick="Cambia(\'' + strTab[a_i].idAnexo + '\',\'' + strTab[a_i].excluido + '\',\'' + strTab[a_i].sAnexo + '\',\'' + strTab[a_i].Danexo + '\')" disabled/>' + strTab[a_i].excluido + ' ' + strTab[a_i].sAnexo.toUpperCase() + ' ' + strTab[a_i].Danexo.toUpperCase() + '<br>';
                    }
                    else {
                        if (strTab[a_i].entrega == "[Integrado]") {
                            htmlTab += '<input name="check" id="ch_' + strTab[a_i].idAnexo + '" type="radio" checked="checked" value="' + strTab[a_i].idAnexo + '" onclick="Cambia(\'' + strTab[a_i].idAnexo + '\',\'' + strTab[a_i].excluido + '\',\'' + strTab[a_i].sAnexo + '\',\'' + strTab[a_i].Danexo + '\')" disabled />' + strTab[a_i].excluido + ' ' + strTab[a_i].sAnexo.toUpperCase() + ' ' + strTab[a_i].Danexo.toUpperCase() + '<br>';
                        }     
                        else{ 
                        htmlTab += '<input name="check" id="ch_' + strTab[a_i].idAnexo + '" type="radio" value="' + strTab[a_i].idAnexo + '" onclick="Cambia(\'' + strTab[a_i].idAnexo + '\',\'' + strTab[a_i].excluido + '\',\'' + strTab[a_i].sAnexo + '\',\'' + strTab[a_i].Danexo + '\')" />' + strTab[a_i].excluido + ' ' + strTab[a_i].sAnexo.toUpperCase() + ' ' + strTab[a_i].Danexo.toUpperCase() + '<br>';
                        }
                    }
                }
            }
            htmlTab += '</form>';

            return htmlTab;
        }

        //Oculta y muestra los botones y permite seleccionar y deseleccionar los radios
        function Cambia(idAnexoSelec, strExcluido, sCAnexo, sDAnexo) {
           
            var sanexo = sCAnexo + ' ' + sDAnexo;
           // alert(sanexo);
            $("#Anexo").val(sanexo.toUpperCase());
            //********************************************************************************************************************************************
            if (indSujetoOb == "S" || indEnlaceOp == "S") {
                if (strEntrega=="E") {
                if (idAnexoSelec == NG.Var[NG.Nact].selec) {                   
                    if ($("#ch_" + idAnexoSelec).is(':checked')) {
                        $('#ch_' + idAnexoSelec).attr('checked', false);
                        NG.Var[NG.Nact].selec = 0;
                        $("#ExcluirActivo").hide();
                        $("#ExcluirInactivo").show();
                        $("#AccIncluir").hide();
                        $("#AccIncluir2").show();
                    }

                }
                else {
                    if (NG.Var[NG.Nact].selec != null) {                        
                        NG.Var[NG.Nact].selec = idAnexoSelec;
                        $('#ch_' + idAnexoSelec).attr('checked', true);
                        $("#ExcluirActivo").show();
                        $("#ExcluirInactivo").hide();
                        $("#AccIncluir").hide();
                        $("#AccIncluir2").show();

                        if (strExcluido != "") {
                            $("#AccIncluir").show();
                            $("#AccIncluir2").hide();
                            $("#ExcluirActivo").hide();
                            $("#ExcluirInactivo").show();
                        }
                    }
                }   
              }                   

            }
            else {

            }
            //********************************************************************************************************************************************        
        }


    //PERMITE EXCLUIR UN ANEXO
        function Excluir() {

            //Asigno mis datos que voy a pasar a la forma hija(iFrame)
            var idanexo = $("input[name='check']:checked").val();       
            var strDProceso = $('#slc_PER option:selected').html();           
            var apartado = intApartado;
            var accion = "EXCLUIR";
        
            //Asigno los valores a mis campos hidden de esta forma
            $("#IdAnexo").val(idanexo);           
            $("#Accion").val(accion);
            $("#intApartado").val(apartado);
            $("#hf_strDProceso").val(strDProceso);
            //Ventana Dialog
            dTxt = '<div id="dComent" title="Excluir anexo">';
            dTxt += '<iframe id="frm_Usuarios" src="Sujeto/SASANXDEPA.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            
            dTxt += '</div>';
            $('#frm_Usuarios').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 500,
                width: 750,
                modal: true,
                resizable: false
            });

        }

        //PARA INCLUIR UN ANEXO
        function Incluir() {

            //Asigno mis datos que voy a pasar a la forma hija(iFrame)
            var idanexo = $("input[name='check']:checked").val();         
            var strDProceso = $('#slc_PER option:selected').html();
            var intIdApartado = intApartado;
            var strAccion = "INCLUIR";

            //Asigno los valores a mis campos hidden de esta forma
            $("#IdAnexo").val(idanexo);          
            $("#Accion").val(strAccion);
            $("#intApartado").val(intIdApartado);
            $("#hf_strDProceso").val(strDProceso);
            //Ventana Dialog
            dTxt = '<div id="dComent" title="Incluir anexo">';
            dTxt += '<iframe id="frm_Usuarios" src="Sujeto/SASANXDEPA.aspx' + '" frameBorder="0" style="width:99%;border-style:none;border-width:0px;height:99%;"></iframe>';
            
            dTxt += '</div>';
            $('#frm_Usuarios').append(dTxt);
            $("#dComent").dialog({
                autoOpen: true,
                height: 500,
                width: 750,
                modal: true,
                resizable: false
            });

        }

        //MENSAJES EN EL CASO DE EXCLUIR UN APARTADO
        function cerrarPrespE(intMensaje, intApartado) {
            cancelar();        
            actualizar(intApartado);
          
            switch (intMensaje) {
                case 1:
                    $.alerts.dialogClass = "correctoAlert";
                    jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                case 2:
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCION"); //guardar la jsutificación
                    break;
                case 3:
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("El anexo no puede ser excluido puesto que es un anexo de tipo general (obligatorio).", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                case 4:
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("El anexo no puede ser excluido puesto que ya se encuentra integrado.", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                default:
            }
                              
        }

        //MENSAJE EN EL CASO DE INCLUIR UN ANEXO
        function cerrarPrespI(intMensaje, intApartado) {
            cancelar();
            actualizar(intApartado);
            switch (intMensaje) {
                case 1:
                    $.alerts.dialogClass = "correctoAlert";
                    jAlert("Operación realizada satisfactoriamente.", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                case 2:
                    $.alerts.dialogClass = "errorAlert";
                    jAlert("Ha sucedido un error inesperado, inténtelo más tarde.", "SISTEMA DE ENTREGA - RECEPCION"); //incluir el anexo
                    break;
                case 3:
                    $.alerts.dialogClass = "incompletoAlert";
                    jAlert("El anexo no puede ser incluido puesto que es un anexo de tipo general (obligatorio)", "SISTEMA DE ENTREGA - RECEPCION");
                    break;
                default:
            }
            
        }

        //ACTUALIZA LA LISTA DE ANEXOS
        function actualizar(intIdApartado) {
            $('#listaAnexos').empty();          
            MostrarAnexos(intIdApartado);



        }
        /*Función que se utiliza cuando se cierra el dialog*/
        function cancelar() {
            $('#dComent').dialog("close");
            $("#dComent").dialog("destroy");
            $("#dComent").remove();                        
        }


        //Función que manda a traer la ventana modal del reporte
        function Reporte() {
            var cveDepcia = $('#slc_Depcia option:selected').val();
            var idProceso = $('#slc_PER option:selected').val();

            dTxt = '<div id="dComent2" title="SERUV - Reporte">';
            dTxt += '<iframe id="SRLREPORT" src="../Reportes/SRLREPORT.aspx?idProceso=' + idProceso + '&cveDepcia=' + cveDepcia + '&op=ANEXOSAPLICABLES' + '" frameBorder="0" style="width:100%;border-style:none;border-width:0px;height:100%;"></iframe>';
            dTxt += '</div>';
            $('#frm_Usuarios').append(dTxt);
            $("#dComent2").dialog({
                autoOpen: true,
                height: $(window).height() - 60, //800,
                width: $("#agp_contenido").width() - 50, //1100,
                modal: true,
                resizable: true,
                close: function (event, ui) {
                    fCerrarDialog();
                }
            });
        }

        /*Función que se utiliza cuando se cierra el dialog*/
        function fCerrarDialog() {
            $('#dComent2').dialog("close");
            $("#dComent2").dialog("destroy");
            $("#dComent2").remove();
        }


        //----------------------------------------------------------------------------------------


    </script>
    <form id="frm_Usuarios" runat="server">
        <%--<div class="instrucciones"></div>--%>
        <div id="agp_contenido">      
            <div id="agp_navegacion">
                <label class="titulo">Anexos por dependencia / entidad</label>
                <div class="a_acciones">                 
                    <a id="ExcluirActivo" title="Excluir un anexo" class="accAct iOculto" href="javascript:Excluir();">Excluir</a>
                    <a id="ExcluirInactivo" title="Excluir un anexo" class="accIna">Excluir</a>  

                    <a id="AccIncluir" title="Incluir un anexo" class="accAct iOculto" href="javascript:Incluir();">Incluir</a>
                    <a id="AccIncluir2" title="Incluir un anexo" class="accIna">Incluir</a>  

                    <a id="AccReporte" title="Reporte de archivos excluidos" class="accAct" href="javascript:Reporte();">Reporte</a>
                    <%--<a id="AccReporte2" title="Reporte de archivos excluidos" class="accIna">Reporte</a>  --%>
                </div>
            </div>

            <div class="instrucciones">Seleccione la información requerida:</div>
            <div id="div_datosPyD">   
                <h2>Proceso entrega - recepción:</h2> <label><select id="slc_PER"></select></label>  
                 <br />
                <h2>Dependencia / entidad:</h2> <label><select id="slc_Depcia"></select></label>
             
                <br />
                <h2>Sujeto obligado:</h2> <label id="lblSujeto"></label>            
                <br />                 
                <h2 id="hUsuario"></h2><label id="lblUsuario"> </label>
            </div>
            <div id="div_mensaje"></div>
       <%--     <div id="Anexos" class="easyui-layout" style="width: 800px; height: 250px;" data-options="fit:true">                           
                <div data-options="region:'west',split:false" title="Apartados" style="width: 580px;">                
                    <ul id="listaApartados">
                    </ul>
                </div>
                <div data-options="region:'center',iconCls:'icon-ok'" title='Anexos' style="width:580px;">
                    <ul id="listaAnexos">
                    </ul>                    
                </div>
            </div>--%>
             <div id="titulos">
                <div style="text-align:center; font-weight: bold; border: 1px solid #d0d0d0; width: 48.5%; height:20px; float:left; background-color:#F5F5F5; display:inline-block;">
                    APARTADOS
                </div>
                <div style="text-align:center; font-weight: bold; width: 49.5%; height:20px; float:right; border: 1px solid #d0d0d0; margin-right: 11px; background-color:#F5F5F5; display:inline-block;">
                   ANEXOS
                </div>                
            </div>
            <div id="Anexos" class="easyui-layout" style="width: 99%; height: 450px; border-style:solid; border-color:Black" >                           
                <div title="Apartados" style="border: 1px solid #d0d0d0; width: 49%; height:400px; float:left; display:inline-block; overflow:auto;">                
                    <ul id="listaApartados" style="font-size:10pt; font-family:Arial">
                    </ul>
                </div>
                <div title='Anexos' style="width: 50%; height:400px; float:right; border: 1px solid #d0d0d0; display:inline-block; overflow:auto;">
                    <ul id="listaAnexos" style="font-size:10pt; font-family:Arial">
                    </ul>                    
                </div>
            </div>

            
            <div class="div_ctdobligaciones">
               <%-- <label>Obligatorios:</label><input id="ob" type="text" name="inp_Obligatorios" readonly="readonly" style="text-align: center" />--%> 
                <label>Total anexos en la guia:</label><input id="tot" type="text" readonly="readonly" name="inp_Total" style="text-align: center"/>               
                <label>Anexos excluídos:</label><input id ="nap" type="text" readonly="readonly" name="inp_Noaplicables" style="text-align: center"/>                
                <label>Anexos a integrar:</label><input id="ap" type="text" readonly="readonly" name="inp_Aplicables " style="text-align: center"/>
            </div>
     
            <div class="notapie">
                <label>* Solo pueden ser excluidos / incluidos aquellos anexos de tipo específico.</label>
            </div>
            <br /><br />
            <div id="div_ocultos">
            <asp:HiddenField ID="hf_idUsuario" runat="server" /> 
            <asp:HiddenField ID="hf_indSO" runat="server" />
            <asp:HiddenField ID="hf_indEOP" runat="server" />
            <asp:HiddenField ID="hf_intIdProceso" runat="server" />
            <asp:HiddenField ID="hf_idSO" runat="server" />  
            <asp:HiddenField ID="hf_strNomSO" runat="server" />            
                <input type="hidden" id="IdAnexo"/>
                <input type="hidden" id="Anexo"/>
                <input type="hidden" id="intApartado"/>
                <input type="hidden" id="Accion"/>
                <input type="hidden" id="IdParticipante"/>
                <input type="hidden" id="hf_intDependencia"/>
                <input type="hidden" id="hf_intProceso"/>
                <input type="hidden" id="hf_strDProceso"/>
            </div>
                    

        </div>
    </form>

</body>
</html>
