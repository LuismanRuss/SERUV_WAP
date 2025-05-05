using System;
using System.Collections.Generic;
using System.Web;
using libFunciones;
using System.Data;
using System.Data.SqlClient;
using nsSERUV;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Threading;

/// <summary>
/// Objetivo:                       Clase para el manejo de notificaciones vía correo electronico.
/// Versión:                        1.0
/// Autor:                          Erik José Enríquez Carmona
/// Fechas:                         
/// </summary>

namespace nsSERUV
{
    public class clsNotifica : IDisposable
    {
        #region Propiedades privadas
        private string _strOpcion; // Varible que definirá que opcion de mensaje se manejará.
        private string _strAccount; // Variable que obtiene la cuenta de la cual se enviaran las notificaciones
        private DataSet _ds;
        private List<System.Net.Mail.MailMessage> _correos;     //  Lista que almacenará los correos electronicos que se enviarán
        private System.Collections.ArrayList _lstParametros;
        private int _intResp;
        #endregion

        #region Contructores
        public clsNotifica(string sOpcion)
        {
            this._strOpcion = sOpcion;
            this._correos = new List<System.Net.Mail.MailMessage>();
        }

        public clsNotifica()
        {
            // TODO: Complete member initialization
        }
        #endregion

        #region Procedimientos de clase


        ////////////////////////////////////////// ----- Todos los metodos de este bloque estan en el WebService
        #region void pNotificacionGUIA()
        /// <summary>
        /// No se usa
        /// </summary>
        void pNotificacionGUIA()
        {
            try
            {
                if (this._ds != null && this._ds.Tables[0] != null)
                {
                    System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();

                    foreach (DataRow drGeneral in this._ds.Tables[0].Rows)
                    {
                        //DataRow drGeneral = this._ds.Tables[0].Rows[0];
                        //correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add((drGeneral.Table.Columns.Contains("sCorreoR") ? (drGeneral["sCorreoR"].ToString().Equals(string.Empty) ? "" : drGeneral["sCorreoR"].ToString()) : ""));
                        correo.To.Add((drGeneral.Table.Columns.Contains("sCorreoO") ? (drGeneral["sCorreoO"].ToString().Equals(string.Empty) ? "" : drGeneral["sCorreoO"].ToString()) : ""));
                        correo.Subject = "NOTIFICACION PRUEBA " + (drGeneral.Table.Columns.Contains("sAccion") ? (drGeneral["sAccion"].ToString().Equals(string.Empty) ? "" : drGeneral["sAccion"].ToString()) : "")
                                                                + (drGeneral.Table.Columns.Contains("sOpcion") ? (drGeneral["sOpcion"].ToString().Equals(string.Empty) ? "" : drGeneral["sOpcion"].ToString()) : "")
                                                                ;
                        correo.Body = "NOTIFICACION PRUEBA " + (drGeneral.Table.Columns.Contains("sAccion") ? (drGeneral["sAccion"].ToString().Equals(string.Empty) ? "" : drGeneral["sAccion"].ToString()) : "")
                                                                + (drGeneral.Table.Columns.Contains("sOpcion") ? (drGeneral["sOpcion"].ToString().Equals(string.Empty) ? "" : drGeneral["sOpcion"].ToString()) : "")
                                                                ;
                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region void pNotificacionER()
        /// <summary>
        /// Objetivo:   Llenar una lista de correos electronicos que se enviaran a los participantes cuando se termina la integración de la información
        /// Este Método ya fue trasladado al WebService, por lo tanto esta referencia no se usa
        /// </summary>
        private void pNotificacionER()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    //correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                    correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                    //if (drGeneral.Table.Columns.Contains("sCorreoR") && !drGeneral["sCorreoR"].ToString().Equals(string.Empty))
                    //    correo.To.Add(drGeneral["sCorreoR"].ToString());
                    //correo.To.Add((drGeneral.Table.Columns.Contains("sCorreoO") ? (drGeneral["sCorreoO"].ToString().Equals(string.Empty) ? "" : drGeneral["sCorreoO"].ToString()) : ""));

                    correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                    correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "CONCLUSIÓN DE INTEGRACIÓN DE INFORMACIÓN: " + (drGeneral.Table.Columns.Contains("sDDepcia") ?
                                                                                    (drGeneral["sDDepcia"].ToString().Equals(string.Empty)
                                                                                    ? "" : drGeneral["nDepcia"].ToString() + " " + drGeneral["sDDepcia"].ToString()) : "");
                    //correo.Body =

                    //    "Proceso: " + (drGeneral.Table.Columns.Contains("sDDepcia") ? drGeneral["sDProceso"].ToString() : "") +
                    //              "\n" + 
                    //              "Asunto: Integración de la información del proceso concluida" +
                    //              "\n" +
                    //              "Sujeto Obligado: " + (drGeneral.Table.Columns.Contains("sNomUsuarioO") ? drGeneral["sNomUsuarioO"].ToString() : "") +
                    //              "\n" +
                    //              "Dependencia: " + (drGeneral.Table.Columns.Contains("sDDepcia") ? drGeneral["nDepcia"].ToString() + " " + drGeneral["sDDepcia"].ToString() : "");

                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // PARA EL USO DE HTML
                    correo.SubjectEncoding = System.Text.Encoding.UTF8;
                    //
                    correo.Body =

                    "<style>" +
                 "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                 "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                 "  .s4font { font-size : 10pt; text-align:center}" +
                 "  .texto { color:#848484; font-weight: bold }" +
                 "</style>" +
                     "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                     "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                     "</br></br>"
                     + "</br>"
                    + "<div class=" + "namefont" + ">CONCLUSIÓN DE INTEGRACIÓN DE INFORMACIÓN: " + "<b>" + (drGeneral.Table.Columns.Contains("sDDepcia") ?
                                                                                    (drGeneral["sDDepcia"].ToString().Equals(string.Empty)
                                                                                    ? "" : drGeneral["nDepcia"].ToString() + " " + drGeneral["sDDepcia"].ToString()) : "") + "</b>" + "</div>"
                         + "</br>"
                         + "</br>" +
                     "<div  class=" + "bodyfont" + ">" +
                         "<font face=" + "arial" + ">"

                         + "<table>"
                         + "<tr>"
                         + "<td class=" + "texto" + ">" + "Proceso entrega-recepción: " + "</td>"
                         + "<td>" + (drGeneral.Table.Columns.Contains("sDDepcia") ? drGeneral["sDProceso"].ToString() : "") + "</td>"
                         + "</tr>"
                         + "<tr>"
                         + "<td class=" + "texto" + ">" + "Asunto: " + "</td>"
                         + "<td>" + "Integración de la información del proceso entrega-recepción concluida" + "</td>"
                         + "</tr>"
                         + "<tr>"
                         + "<td class=" + "texto" + ">" + "Sujeto Obligado: " + "</td>"
                         + "<td>" + (drGeneral.Table.Columns.Contains("sNomUsuarioO") ? drGeneral["sNomUsuarioO"].ToString() : "") + "</td>"
                         + "</tr>"
                         + "<tr>"
                         + "<td class=" + "texto" + ">" + "Dependencia/Entidad: " + "</td>"
                         + "<td>" + (drGeneral.Table.Columns.Contains("sDDepcia") ? drGeneral["nDepcia"].ToString() + " " + drGeneral["sDDepcia"].ToString() : "") + "</td>"
                         + "</tr>"
                         + "</table>"
                         + "</br>"
                         + "</font>"
                     + "</div>"
                     + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                     ;

                    // USO DE HTML
                    correo.BodyEncoding = System.Text.Encoding.UTF8;
                    correo.IsBodyHtml = true;
                    //

                    this._correos.Add(correo);
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region void pNotificacionIntegrar()
        /// <summary>
        /// Procedimiento que contruye el/los correo para notificar que se integro o no un anexo
        /// Ya no se utiliza
        /// </summary>
        private void pNotificacionIntegrar()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    //correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                    correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                    if (drGeneral.Table.Columns.Contains("sCorreoR") && !drGeneral["sCorreoR"].ToString().Equals(string.Empty))
                        //    correo.To.Add(drGeneral["sCorreoR"].ToString());
                        // correo.To.Add((drGeneral.Table.Columns.Contains("sCorreoO") ? (drGeneral["sCorreoO"].ToString().Equals(string.Empty) ? "" : drGeneral["sCorreoO"].ToString()) : ""));
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                    correo.Subject = "NOTIFICACION PRUEBA" + (drGeneral.Table.Columns.Contains("cIndEntrega") ?
                                                                (drGeneral["cIndEntrega"].ToString().Equals(string.Empty)
                                                                ? "" : (drGeneral["cIndEntrega"].ToString().Equals("P") ? " PENDIENTE" : " INTEGRADO")) : "");
                    correo.Body = "NOTIFICACION PRUEBA";
                    this._correos.Add(correo);
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pNotificacionANEXO
        /// <summary>
        /// Función que envía correos electrónicos a los participantes cuando se al anexo se encuentra cargado o integrado en un proceso activo
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        private void pNotificacionANEXO()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {

                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    //correo.From = new System.Net.Mail.MailAddress("edmorales@uv.mx");
                    //String ClaveGuia=" ";
                    //String DescGuia = " ";
                    //String ClaveApartado = " ";
                    String DescApartado = " ";
                    //String ClaveAnexo = " ";
                    //String DescAnexo = " ";
                    //String ClaveAnexoNuevo = "";
                    String DescAnexoNuevo = "";

                    if (this._ds.Tables[0] != null) // En la tabla 0, regresamos la informacion del Anexo
                    {
                        //ClaveGuia = (drGeneral.Table.Columns.Contains("ClaveGuia") ? drGeneral["ClaveGuia"].ToString() : "");
                        //DescGuia = (drGeneral.Table.Columns.Contains("DescGuia") ? drGeneral["DescGuia"].ToString() : "");
                        //ClaveApartado = (drGeneral.Table.Columns.Contains("ClaveApartado") ? drGeneral["ClaveApartado"].ToString() : "");
                        DescApartado = (drGeneral.Table.Columns.Contains("sDApartado") ? drGeneral["sDApartado"].ToString() : "");
                        //ClaveAnexo = (drGeneral.Table.Columns.Contains("ClaveAnexo") ? drGeneral["ClaveAnexo"].ToString() : "");
                        //DescAnexo = (drGeneral.Table.Columns.Contains("DescAnexo") ? drGeneral["DescAnexo"].ToString() : "");
                        //ClaveAnexoNuevo = (drGeneral.Table.Columns.Contains("ClaveAnexoNuevo") ? drGeneral["ClaveAnexoNuevo"].ToString() : "");
                        DescAnexoNuevo = (drGeneral.Table.Columns.Contains("sDAnexo") ? drGeneral["sDAnexo"].ToString() : "");
                    }

                    //foreach (DataRow row in this._ds.Tables[0].Rows)
                    //{
                    //    ClaveGuia = (drGeneral.Table.Columns.Contains("ClaveGuia") ? drGeneral["ClaveGuia"].ToString() : "");
                    //    DescGuia = (drGeneral.Table.Columns.Contains("DescGuia") ? drGeneral["DescGuia"].ToString() : "");
                    //    ClaveApartado = (drGeneral.Table.Columns.Contains("ClaveApartado") ? drGeneral["ClaveApartado"].ToString() : "");
                    //    DescApartado = (drGeneral.Table.Columns.Contains("DescApartado") ? drGeneral["DescApartado"].ToString() : "");
                    //    ClaveAnexo = (drGeneral.Table.Columns.Contains("ClaveAnexo") ? drGeneral["ClaveAnexo"].ToString() : "");
                    //    DescAnexo = (drGeneral.Table.Columns.Contains("DescAnexo") ? drGeneral["DescAnexo"].ToString() : "");
                    //    ClaveAnexoNuevo = (drGeneral.Table.Columns.Contains("ClaveAnexoNuevo") ? drGeneral["ClaveAnexoNuevo"].ToString() : "");
                    //    DescAnexoNuevo = (drGeneral.Table.Columns.Contains("DescAnexoNuevo") ? drGeneral["DescAnexoNuevo"].ToString() : ""); 
                    //}

                    if (this._ds.Tables[1] != null) // Viene la informacion del Usuario Obligado y Enlace Principal
                    {
                        //drGeneral = this._ds.Tables[1].Rows[0];

                        foreach (DataRow row in this._ds.Tables[1].Rows)
                        {
                            System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                            //   correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                            correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                            drGeneral = row;
                            //   correo.To.Add("danramirez@uv.mx");
                            correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                            //correo.To.Add((drGeneral.Table.Columns.Contains("sCorreo") ? drGeneral["sCorreo"].ToString() : ""));
                            correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "ACTUALIZACIÓN DE ANEXO";
                            correo.Body =

                          //        "<style>" +
                          //        "  .fixedfont { font-size : 11pt }"
                          //        + "</style>" +
                          //        "<div  class=" + "fixedfont" + ">" +
                          //        "<font face=" + "arial" + ">"
                          //        +

                          //"Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("SObligadoNombre") ? drGeneral["SObligadoNombre"].ToString() : "") + "</b>"
                          //    + "</br>"
                          //    + "</br>" + "Se han realizado actualizaciones al Anexo: " + "<b>" + DescAnexoNuevo + "</b>"
                          //    + "</br>" + "Correspondiente al Apartado: " + "<b>" + DescApartado + "</b>"
                          //    + "</br>"
                          //    + "</br>" + "Favor de verificar el avance de su entrega. "
                          //    + "</font>"
                          //+ "</div>"
                          //    ;
                          "<style>" +
                                "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                                "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                                "  .s4font { font-size : 10pt; text-align:center}" +
                                "  .texto { color:#848484; font-weight: bold }"
                                +
                                "</style>" +
                                    "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                                    "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                                    "</br></br>" +
                                   "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("SObligadoNombre") ? drGeneral["SObligadoNombre"].ToString() : "") + "</b>" + "</div>"
                                    + "</br>"
                                    + "</br>"
                                      + "<div  class=" + "bodyfont" + ">" +
                                    "<font face=" + "arial" + ">"

                                    + "<table>"
                                    + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Se han realizado actualizaciones al Anexo: " + "</td>"
                                    + "<td>" + DescAnexoNuevo + "</td>"
                                    + "</tr>"
                                     + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Correspondiente al Apartado: " + "</td>"
                                    + "<td>" + DescApartado + "</td>"
                                    + "</tr>"
                                    + "<tr>"
                                    + "<td colspan=" + "2" + ">" + "</br> Favor de verificar el avance de su entrega. " + "</td>"
                                    + "</tr>"
                                    + "</table>"
                                     + "</font>"
                                    + "</div>"
                                    + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                                     ;


                            // USO DE HTML
                            correo.BodyEncoding = System.Text.Encoding.UTF8;
                            correo.IsBodyHtml = true;
                            //

                            this._correos.Add(correo);

                            int EnlacePrincipal = (drGeneral.Table.Columns.Contains("EnlacePrincipal") ? int.Parse(drGeneral["EnlacePrincipal"].ToString()) : 0);

                            if (EnlacePrincipal != 0)
                            {
                                System.Net.Mail.MailMessage correo2 = new System.Net.Mail.MailMessage();
                                // correo2.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                                correo2.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                                correo2.To.Add("danramirez@uv.mx");
                                // correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                                //correo2.To.Add((drGeneral.Table.Columns.Contains("CorreoEP") ? drGeneral["CorreoEP"].ToString() : ""));
                                correo2.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "ACTUALIZACIÓN DE ANEXO";
                                correo2.Body =

                              "<style>" +
                                "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                                "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                                "  .s4font { font-size : 10pt; text-align:center}" +
                                "  .texto { color:#848484; font-weight: bold }"
                                +
                                "</style>" +
                                    "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                                    "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                                    "</br></br>" +
                                   "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("NombreEP") ? drGeneral["NombreEP"].ToString() : "") + "</b>" + "</div>"
                                    + "</br>"
                                    + "</br>"
                                      + "<div  class=" + "bodyfont" + ">" +
                                    "<font face=" + "arial" + ">"

                                    + "<table>"
                                    + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Se han realizado actualizaciones al Anexo: " + "</td>"
                                    + "<td>" + DescAnexoNuevo + "</td>"
                                    + "</tr>"
                                     + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Correspondiente al Apartado: " + "</td>"
                                    + "<td>" + DescApartado + "</td>"
                                    + "</tr>"
                                    + "<tr>"
                                    + "<td colspan=" + "2" + ">" + "</br> Favor de verificar el avance de su entrega. " + "</td>"
                                    + "</tr>"
                                    + "</table>"
                                     + "</font>"
                                    + "</div>"
                                    + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                                     ;
                                //"Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("NombreEP") ? drGeneral["NombreEP"].ToString() : "") + "</b>"
                                //    + "</br>"
                                //    + "</br>" + "Se han realizado actualizaciones al Anexo: " + "<b>" + DescAnexoNuevo + "</b>"
                                //    + "</br>" + "Correspondiente al Apartado: " + "<b>" + DescApartado + "</b>"
                                //    + "</br>"
                                //    + "</br>" + "Favor de verificar el avance de su entrega. "
                                //    + "</font>"
                                //+ "</div>"


                                // USO DE HTML
                                correo2.BodyEncoding = System.Text.Encoding.UTF8;
                                correo2.IsBodyHtml = true;
                                //


                                this._correos.Add(correo2);

                            }

                        }

                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pNotificacionNuevoProceso
        /// <summary>
        /// Función que envía correos electrónicos a los participantes cuando se crea un nuevo proceso
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>
        public void pNotificacionNuevoProceso()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    DataTable drParticipantes = this._ds.Tables[1];



                    string strFechaInicio, strFechaFinal, strFi, strFf = "";
                    strFi = drGeneral.Table.Columns.Contains("dFInicio") ? drGeneral["dFInicio"].ToString() : "";
                    strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                    strFf = drGeneral.Table.Columns.Contains("dFFinal") ? drGeneral["dFFinal"].ToString() : "";
                    strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                    foreach (DataRow row in this._ds.Tables[1].Rows)
                    {
                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        // correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                                                                                                                    //       correo.From = new System.Net.Mail.MailAddress("edmorales@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + " PROCESO ENTREGA-RECEPCIÓN: " + (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "");
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //

                        correo.Body =

                        "<style>" +
                        "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                        "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                        "  .s4font { font-size : 10pt; text-align:center}" +
                        "  .texto { color:#848484; font-weight: bold }"
                        +
                        "</style>" +
                            "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                            "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                            "</br></br>" +
                           "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                            + "</br>"
                            + "</br>"

                             + "<div  class=" + "bodyfont" + ">" +
                            "<font face=" + "arial" + ">"
                            + "Usted ha sido asignado(a) para participar en el Proceso Entrega-Recepción: "
                            + "<b>" + (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "") + "</b>"
                            + "</br>"
                            + "</br>"
                            + "<table>"
                            + "<tr>"
                            + "<td class=" + "texto" + ">" + "Naturaleza: " + "</td>"
                            + "<td>" + (drGeneral.Table.Columns.Contains("sDTipoProc") ? drGeneral["sDTipoProc"].ToString() : "") + "</td>"
                            + "<td>" + "</td>" + "<td>" + "</td>" + "<td>" + "</td>"
                            + "</tr>"
                            + "<tr>"
                            + "<td class=" + "texto" + ">" + "Motivo: " + "</td>"
                            + "<td colspan=" + "4" + ">" + (drGeneral.Table.Columns.Contains("sDMotiProc") ? drGeneral["sDMotiProc"].ToString() : "") + "</td>"
                            + "</tr>"
                            + "<tr>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura inicial: " + "</td>" + "<td>" + strFechaInicio + "</td>"
                            + "<td></td>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura final: " + "</td>" + "<td>" + strFechaFinal + "</td>"
                            + "</tr>"
                            + "</table>"

                            + "</div>"
                            + "</font>"
                            + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                            ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //

                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pNotificacionModificarFecProceso
        /// <summary>
        /// Función que envía correos electrónicos a los participantes cuando se modifica un proceso
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>

        public void pNotificacionModificarFecProceso()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    DataTable drParticipantes = this._ds.Tables[1];

                    string strFechaInicio, strFechaFinal, strFi, strFf = "";
                    //strFechaInicioExt, strFechaFinalExt, strFiExt, strFfExt, strFechaInicio, strFechaFinal, strFi, strFf = "";

                    strFi = drGeneral.Table.Columns.Contains("dFInicio") ? drGeneral["dFInicio"].ToString() : "";
                    strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                    strFf = drGeneral.Table.Columns.Contains("dFFinal") ? drGeneral["dFFinal"].ToString() : "";
                    strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                    foreach (DataRow row in this._ds.Tables[1].Rows)
                    {
                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        //correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        //     correo.From = new System.Net.Mail.MailAddress("edmorales@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "");

                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                        "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                        "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                        "  .s4font { font-size : 10pt; text-align:center}" +
                        "  .texto { color:#848484; font-weight: bold }"
                        +
                        "</style>" +
                            "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                            "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                            "</br></br>" +
                           "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                            + "</br>"
                            + "</br>"

                             + "<div  class=" + "bodyfont" + ">" +
                            "<font face=" + "arial" + ">"
                           + "Le informamos que las fechas de apertura han cambiado para el Proceso Entrega-Recepción: "
                            + "<b>" + (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "") + "</b>"
                            + "</br>"
                            + "</br>"
                            + "<table>"
                            + "<tr>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura inicial: " + "</td>" + "<td>" + strFechaInicio + "</td>"
                            + "<td></td>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura final: " + "</td>" + "<td>" + strFechaFinal + "</td>"
                            + "</tr>"
                            + "</table>"

                            + "</div>"
                            + "</font>"
                            + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                            ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //

                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }

        }
        #endregion

        #region pNotificacionModificarProcesoExt
        /// <summary>
        /// Función que envía correos electrónicos a los participantes cuando se modifica un proceso
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>

        public void pNotificacionModificarProcesoExt()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    DataTable drParticipantes = this._ds.Tables[1];

                    string strFechaInicioExt, strFechaFinalExt, strFiExt, strFfExt, strFechaInicio, strFechaFinal, strFi, strFf = "";

                    strFi = drGeneral.Table.Columns.Contains("dFInicio") ? drGeneral["dFInicio"].ToString() : "";
                    strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                    strFf = drGeneral.Table.Columns.Contains("dFFinal") ? drGeneral["dFFinal"].ToString() : "";
                    strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                    strFiExt = drGeneral.Table.Columns.Contains("dFFInicioEX") ? drGeneral["dFFInicioEX"].ToString() : "";
                    strFechaInicioExt = DateTime.Parse(strFiExt).ToString("dd-MM-yyyy");
                    strFfExt = drGeneral.Table.Columns.Contains("dFFinalEX") ? drGeneral["dFFinalEX"].ToString() : "";
                    strFechaFinalExt = DateTime.Parse(strFfExt).ToString("dd-MM-yyyy");

                    foreach (DataRow row in this._ds.Tables[1].Rows)
                    {
                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "");

                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                       "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                       "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                       "  .s4font { font-size : 10pt; text-align:center}" +
                       "  .texto { color:#848484; font-weight: bold }"
                       +
                       "</style>" +
                           "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                           "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                           "</br></br>" +
                          "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                           + "</br>"
                           + "</br>"

                            + "<div  class=" + "bodyfont" + ">" +
                           "<font face=" + "arial" + ">"
                          + "Le informamos que se ha agregado un periodo de apertura extemporánea para el Proceso Entrega-Recepción: "
                           + "<b>" + (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "") + "</b>"
                           + "</br>"
                           + "</br>"
                           + "<table>"
                           + "<tr>"
                           + "<td class=" + "texto" + ">" + "Fecha de apertura inicial: " + "</td>" + "<td>" + strFechaInicio + "</td>"
                           + "<td class=" + "texto" + ">" + "Fecha de apertura final: " + "</td>" + "<td>" + strFechaFinal + "</td>"
                           + "</tr>"
                           + "<tr>"
                           + "<td class=" + "texto" + ">" + "Fecha inicial de apertura extemporánea: " + "</td>" + "<td>" + strFechaInicioExt + "</td>"
                           + "<td class=" + "texto" + ">" + "Fecha final de apertura extemporánea: " + "</td>" + "<td>" + strFechaFinalExt + "</td>"
                           + "</tr>"

                           + "<tr>"
                           + "<td class=" + "texto" + ">" + "Justificación: " + "</td>"
                           + "</tr>"
                           + "<tr>"
                           + "<td colspan=" + "4" + ">" + (drGeneral.Table.Columns.Contains("sJustificacion") ? drGeneral["sJustificacion"].ToString() : "") + "</td>"
                           + "</tr>"

                           + "</table>"

                           + "</div>"
                           + "</font>"
                           + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                           ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //

                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }

        }
        #endregion

        #region pCambSujOb()
        /// <summary>
        /// Función que envía correos electrónicos cuando se cambia un sujeto obligado, envía al anterior y al nuevo sujeto obligado
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>
        private void pCambSujOb()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drSujObAnt = this._ds.Tables[0].Rows[0];
                    DataRow drSujObNue = this._ds.Tables[1].Rows[0];


                    //Notificación que se envia a la persona que deja de ser sujeto obligado
                    ////////////////////////////////////////////////////////////////////////////////////////////////////////
                    //foreach (DataRow row in this._ds.Tables[0].Rows)
                    //{
                    //    System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                    //    correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                    //    correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                    //    correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " +"PROCESO ENTREGA-RECEPCIÓN: " + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "");
                    //    // PARA EL USO DE HTML
                    //    correo.SubjectEncoding = System.Text.Encoding.UTF8;
                    //    //
                    //    correo.Body =
                    //    "<style>" +
                    //    "  .fixedfont { font-size : 11pt }"
                    //+ "</style>" +
                    //    "<div  class=" + "fixedfont" + ">" +
                    //        "<font face=" + "arial" + ">"
                    //        +

                    //    "Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>"
                    //        + "</br>"
                    //        + "</br>"
                    //        + "Usted ha sido desasignado(a) como sujeto obligado de la dependencia "+"<b>"+ (drSujObAnt.Table.Columns.Contains("sDDepcia") ? drSujObAnt["sDDepcia"].ToString() : "")+"</b>"
                    //         +", en el Proceso Entrega-Recepción: "
                    //        + "<b>" + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "") + "</b>"

                    //        + "</font>"
                    //    + "</div>"
                    //        ;

                    //    // USO DE HTML
                    //    correo.BodyEncoding = System.Text.Encoding.UTF8;
                    //    correo.IsBodyHtml = true;
                    //    //
                    //    this._correos.Add(correo);
                    //}
                    foreach (DataRow row in this._ds.Tables[1].Rows)
                    {
                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        //   correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "");
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                     "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                     "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                     "  .s4font { font-size : 10pt; text-align:center}" +
                     "  .texto { color:#848484; font-weight: bold }"
                     +
                     "</style>" +
                         "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                         "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                         "</br></br>" +
                        "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                         + "</br>"
                         + "</br>"
                          + "<div  class=" + "bodyfont" + ">" +
                         "<font face=" + "arial" + ">"

                         + "<table>"
                            + "<tr>"
                                + "<td class=" + "texto" + ">" + "Usted ha sido asignado(a) como sujeto obligado de la dependencia/entidad: " + "</td>"
                                + "<td>" + (drSujObAnt.Table.Columns.Contains("nFKDepcia") ? drSujObAnt["nFKDepcia"].ToString() : "") + " " + (drSujObAnt.Table.Columns.Contains("sDDepcia") ? drSujObAnt["sDDepcia"].ToString() : "") + "</td>"
                            + "</tr>"
                             + "<tr>"
                                + "<td class=" + "texto" + ">" + "En el Proceso Entrega-Recepción: " + "</td>"
                                + "<td>" + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "") + "</td>"
                            + "</tr>"
                         + "</table>"

                         //+ "</br>" 
                         //+ "<b>" + (drSujObAnt.Table.Columns.Contains("nFKDepcia") ? drSujObAnt["nFKDepcia"].ToString() : "") + " " + (drSujObAnt.Table.Columns.Contains("sDDepcia") ? drSujObAnt["sDDepcia"].ToString() : "") + "</b>"
                         //+ "</br>" 
                         //+ "En el Proceso Entrega-Recepción: "
                         //+ "</br>" 
                         //+ "<b>" + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "") + "</b>"
                         //+ "</br>"
                         + "</br>"
                         + "</div>"
                         + "</font>"
                         + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                         ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //
                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pIncPart()
        /// <summary>
        /// Función que envía correos electrónicos cuando se incluyen participantes
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>
        private void pIncPart()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataTable drSujObAnt = this._ds.Tables[0];

                    foreach (DataRow row in this._ds.Tables[0].Rows)
                    {
                        string strFechaInicio, strFechaFinal, strFi, strFf = "";
                        strFi = row["dFInicio"].ToString();
                        strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                        strFf = row["dFFinal"].ToString();
                        strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        //  correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + row["sDProceso"].ToString();
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                        "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                        "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                        "  .s4font { font-size : 10pt; text-align:center}" +
                        "  .texto { color:#848484; font-weight: bold }"
                        +
                        "</style>" +
                            "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                            "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                            "</br></br>" +
                           "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                            + "</br>"
                            + "</br>"

                             + "<div  class=" + "bodyfont" + ">" +
                            "<font face=" + "arial" + ">"
                            + "Usted ha sido asignado(a) para participar en el Proceso Entrega-Recepción: "
                            + "<b>" + row["sDProceso"].ToString() + "</b>"
                            + "</br>"
                            + "</br>"
                            + "<table>"
                           + "<tr>"
                           + "<td colspan=" + "5" + " class=" + "texto" + ">" + "Como sujeto obligado de la dependencia/entidad: " + "</td>"
                           + "</tr>"
                           + "<tr>"
                           + "<td colspan=" + "5" + ">" + row["nDepcia"].ToString() + " " + row["sDDepcia"].ToString() + "</b>" + "</td>"
                           + "</tr>"
                            + "<tr>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura inicial: " + "</td>" + "<td>" + strFechaInicio + "</td>"
                            + "<td></td>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura final: " + "</td>" + "<td>" + strFechaFinal + "</td>"
                            + "</tr>"
                            + "</table>"

                            + "</div>"
                            + "</font>"
                            + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                            ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //

                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pSujRecp ()
        /// <summary>
        /// Función que envía correos electrónicos cuando se modifica sujeto receptor
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>
        private void pSujRecp()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataTable drSujRecp = this._ds.Tables[0];

                    foreach (DataRow row in this._ds.Tables[0].Rows)
                    {
                        string strFechaInicio, strFechaFinal, strFi, strFf = "";
                        strFi = row["dFInicio"].ToString();
                        strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                        strFf = row["dFFinal"].ToString();
                        strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        //  correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + row["sDProceso"].ToString();
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                        "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                        "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                        "  .s4font { font-size : 10pt; text-align:center}" +
                        "  .texto { color:#848484; font-weight: bold }"
                        +
                        "</style>" +
                            "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                            "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                            "</br></br>" +
                           "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                            + "</br>"
                            + "</br>"

                             + "<div  class=" + "bodyfont" + ">" +
                            "<font face=" + "arial" + ">"
                            + "Usted ha sido asignado(a) para participar en el Proceso Entrega-Recepción: "
                            + "<b>" + row["sDProceso"].ToString() + "</b>"
                            + "</br>"
                            + "</br>"
                            + "<table>"
                           + "<tr>"
                           + "<td colspan=" + "5" + " class=" + "texto" + ">" + "Como sujeto receptor de la dependencia/entidad: " + "</td>"
                           + "</tr>"
                           + "<tr>"
                           + "<td colspan=" + "5" + ">" + row["nDepcia"].ToString() + " " + row["sDDepcia"].ToString() + "</b>" + "</td>"
                           + "</tr>"
                            + "<tr>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura inicial: " + "</td>" + "<td>" + strFechaInicio + "</td>"
                            + "<td></td>"
                            + "<td class=" + "texto" + ">" + "Fecha de apertura final: " + "</td>" + "<td>" + strFechaFinal + "</td>"
                            + "</tr>"
                            + "</table>"

                            + "</div>"
                            + "</font>"
                            + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                            ;
                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //
                        this._correos.Add(correo);
                    }

                    //Notificación que se envia a la persona que deja de ser sujeto receptor
                    ///////////////////////////////////////////////////////////////////////////////////
                    //if (this._ds.Tables.Count == 2)
                    //{
                    //    DataTable drSujRecp2 = this._ds.Tables[1];

                    //    foreach (DataRow row in this._ds.Tables[1].Rows)
                    //    {
                    //        string strFechaInicio, strFechaFinal, strFi, strFf = "";
                    //        strFi = row["dFInicio"].ToString();
                    //        strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                    //        strFf = row["dFFinal"].ToString();
                    //        strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                    //        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                    //        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                    //        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                    //        correo.Subject =ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + row["sDProceso"].ToString();
                    //        // PARA EL USO DE HTML
                    //        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                    //        //
                    //        correo.Body =
                    //        "<style>" +
                    //        "  .fixedfont { font-size : 11pt }"
                    //         + "</style>" +
                    //        "<div  class=" + "fixedfont" + ">" +
                    //            "<font face=" + "arial" + ">"
                    //            +
                    //        "Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>"
                    //            + "</br>"
                    //            + "</br>"
                    //            + "Usted ha sido desasignado(a) del Proceso Entrega-Recepción: "
                    //            + "<b>" + row["sDProceso"].ToString() + "</b>"
                    //            + "</br>" + "Como sujeto receptor de la dependencia: " + "<b>" + row["nDepcia"].ToString() + " " + row["sDDepcia"].ToString() + "</b>"
                    //            + "</br>" + "Fecha de Apertura del: " + strFechaInicio + "  al  " + strFechaFinal

                    //            + "</font>"
                    //        + "</div>"
                    //            ;
                    //        // USO DE HTML
                    //        correo.BodyEncoding = System.Text.Encoding.UTF8;
                    //        correo.IsBodyHtml = true;
                    //        //
                    //        this._correos.Add(correo);
                    //    }
                    //}
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pExcPart()
        /// <summary>
        /// Función que envía correos electrónicos cuando se excluyen participantes
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>
        private void pExcPart()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataTable drExcPart = this._ds.Tables[0];

                    foreach (DataRow row in this._ds.Tables[0].Rows)
                    {

                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        //  correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + row["sDProceso"].ToString();
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                       "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                       "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                       "  .s4font { font-size : 10pt; text-align:center}" +
                       "  .texto { color:#848484; font-weight: bold }"
                       +
                       "</style>" +
                           "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                           "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                           "</br></br>" +
                          "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                           + "</br>"
                           + "</br>"

                            + "<div  class=" + "bodyfont" + ">" +
                           "<font face=" + "arial" + ">"
                           + "Usted ha sido desasignado(a) para participar en el Proceso Entrega-Recepción: "
                           + "<b>" + row["sDProceso"].ToString() + "</b>"
                           + "</br>"
                           + "</br>"
                           + "<table>"
                          + "<tr>"
                          + "<td colspan=" + "5" + "class=" + "texto" + ">" + "Con la dependencia/entidad: " + "</td>"
                          + "</tr>"
                          + "<tr>"
                          + "<td colspan=" + "5" + ">" + row["nFKDepcia"].ToString() + " " + row["sDDepcia"].ToString() + "</b>" + "</td>"
                          + "</tr>"
                           + "</table>"

                           + "</div>"
                           + "</font>"
                           + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                            ;
                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //
                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pPartExt()
        /// <summary>
        /// Función que envía correos electrónicos cuando se agrega un proceso extemporaneo a un participante
        /// Autor: Edgard Morales, Emmanuel Méndez Flores
        /// </summary>
        /// 
        private void pPartExt()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drExcPart = this._ds.Tables[0].Rows[0];
                    foreach (DataRow row in this._ds.Tables[0].Rows)
                    {
                        string strFechaInicio, strFechaFinal, strFi, strFf = "";
                        strFi = row["dFInicio"].ToString();
                        strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                        strFf = row["dFFinal"].ToString();
                        strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        //     correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx"); // Correo desde el Cual se enviaran las notificaciones
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: " + row["sDProceso"].ToString();
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                    "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                    "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                    "  .s4font { font-size : 10pt; text-align:center}" +
                    "  .texto { color:#848484; font-weight: bold }"
                    +
                    "</style>"
                    +
                        "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                        "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                        "</br></br>" +
                       "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                        + "</br>"
                        + "</br>"

                         + "<div  class=" + "bodyfont" + ">" +
                        "<font face=" + "arial" + ">"
                        + "Responsable de la dependencia/entidad: " + "<b>" + row["nDepcia"].ToString() + " " + row["sDDepcia"].ToString() + "</b>"
                       + "Le informamos que se ha agregado un periodo de apertura extemporánea para el Proceso Entrega-Recepción: "
                        + "<b>" + row["sDProceso"].ToString() + "</b>"
                        + "</br>"
                        + "</br>"
                        + "<table>"
                        + "<tr>"
                        + "<td class=" + "texto" + ">" + "Fecha inicial de apertura extemporánea: " + "</td>" + "<td>" + strFechaInicio + "</td>"
                        + "<td class=" + "texto" + ">" + "Fecha final de apertura extemporánea: " + "</td>" + "<td>" + strFechaFinal + "</td>"
                        + "</tr>"
                        + "<tr>"
                        + "<td class=" + "texto" + ">" + "Justificación: " + "</td>"
                        + "</tr>"
                        + "<tr>"
                        + "<td colspan=" + "4" + ">" + row["sJustificacion"].ToString() + "</td>"
                        + "</tr>"
                        + "</table>"

                        + "</div>"
                        + "</font>"
                        + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                        ;
                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //
                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }

        }
        #endregion

        #region pCierreProc()
        /// <summary>
        /// Función que envía correos electrónicos a los sujetos obligados y sujetos receptores cuando se cierra un proceso
        /// Autor: Edgard Morales
        /// </summary>
        private void pCierreProc()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drEnlaces = this._ds.Tables[0].Rows[0];

                    foreach (DataRow row in this._ds.Tables[0].Rows)
                    {
                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]); // Cuenta a donde se enviaran las notificaciones
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "PROCESO ENTREGA-RECEPCIÓN: "; // + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "");
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //
                        correo.Body =

                        "<style>" +
                     "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                     "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                     "  .s4font { font-size : 10pt; text-align:center}" +
                     "  .texto { color:#848484; font-weight: bold }"
                     +
                     "</style>" +
                         "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                         "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                         "</br></br>" +
                        "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                         + "</br>"
                         + "</br>"
                          + "<div  class=" + "bodyfont" + ">" +
                         "<font face=" + "arial" + ">"
                              + "<div  class=" + "bodyfont" + ">" +
                                    "<font face=" + "arial" + ">"
                                    + "Se le informa que se ha cerrado el Proceso Entrega-Recepción: "
                                    + "<b>" + (drEnlaces.Table.Columns.Contains("sDProceso") ? drEnlaces["sDProceso"].ToString() : "") + "</b>"
                                    + "</br>"
                                    + "</br>"
                         //+ "<table>"
                         //   + "<tr>"
                         //       + "<td class=" + "texto" + ">" + "Usted ha sido asignado(a) como sujeto obligado de la dependencia: " + "</td>"
                         //       + "<td>" + (drSujObAnt.Table.Columns.Contains("nFKDepcia") ? drSujObAnt["nFKDepcia"].ToString() : "") + " " + (drSujObAnt.Table.Columns.Contains("sDDepcia") ? drSujObAnt["sDDepcia"].ToString() : "") + "</td>"
                         //   + "</tr>"
                         //    + "<tr>"
                         //       + "<td class=" + "texto" + ">" + "En el Proceso Entrega-Recepción: " + "</td>"
                         //       + "<td>" + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "") + "</td>"
                         //   + "</tr>"
                         //+ "</table>"
                         + "</br>"
                         + "</div>"
                         + "</font>"
                         + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                         ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //
                        this._correos.Add(correo);
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region pReapertProc()
        /// <summary>
        /// Función que envía correos electrónicos a los sujetos obligados y sujetos receptores cuando se cierra un proceso
        /// Autor: Edgard Morales
        /// </summary>
        private void pReapertProc()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataTable dtReapProc = this._ds.Tables[0];

                    string tipoPart = "";
                    string tipoProc = "";
                    string strFechaInicio, strFechaFinal, strFi, strFf = "";

                    tipoProc = tipoPart;  //Para evitar => advertencia CS0219: La variable 'tipoPart' está asignada, pero su valor nunca se utiliza
                    foreach (DataRow row in this._ds.Tables[0].Rows)
                    {
                        System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                        correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones
                        correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]); // Cuenta a donde se enviaran las notificaciones
                        correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "Reapertura del Proceso entrega-recepción: " + row["sDProceso"].ToString(); // + (drSujObAnt.Table.Columns.Contains("sDProceso") ? drSujObAnt["sDProceso"].ToString() : "");
                        // PARA EL USO DE HTML
                        correo.SubjectEncoding = System.Text.Encoding.UTF8;
                        //

                        if (row["TipoProc"].ToString() == "NRM")
                        {
                            tipoProc = "apertura";
                        }
                        else if (row["TipoProc"].ToString() == "EXT")
                        {
                            tipoProc = "apertura extemporánea";
                        }

                        strFi = row["dFInicio"].ToString();
                        strFechaInicio = DateTime.Parse(strFi).ToString("dd-MM-yyyy");
                        strFf = row["dFFinal"].ToString(); ;
                        strFechaFinal = DateTime.Parse(strFf).ToString("dd-MM-yyyy");

                        switch (row["cTipo"].ToString())
                        {
                            case "SOB":
                                tipoPart = "SUJETO OBLIGADO";
                                break;
                            case "RCP":
                                tipoPart = "SUJETO RECEPTOR";
                                break;
                            case "EOP":
                                tipoPart = "ENLACE OPERATIVO";
                                break;
                            case "EOR":
                                tipoPart = "ENLACE OPERATIVO RECEPTOR";
                                break;
                        }

                        correo.Body =

                        "<style>" +
                     "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                     "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                     "  .s4font { font-size : 10pt; text-align:center}" +
                     "  .texto { color:#848484; font-weight: bold }"
                     +
                     "</style>" +
                         "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                         "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                         "</br></br>" +
                        "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + row["sNombre"].ToString() + "</b>" + "</div>"
                         + "</br>"
                         + "</br>"
                          + "<div  class=" + "bodyfont" + ">" +
                         "<font face=" + "arial" + ">"
                              + "<div  class=" + "bodyfont" + ">" +
                                    "<font face=" + "arial" + ">"

                                //        + "Se le informa que se ha reabierto la entrega de la dependencia/entidad: " + row["nFKDepcia"].ToString()
                                //         + "</br>"
                                //        + "Que participa en el Proceso E-R : " + row["sDProceso"].ToString()
                                //// + "<b>" + (drEnlaces.Table.Columns.Contains("sDProceso") ? drEnlaces["sDProceso"].ToString() : "") + "</b>"
                                //        + "</br>"
                                //        + "Con fechas de " + tipoProc + " del : " + strFechaInicio + " al " + strFechaFinal
                                //       + "</br>"
                                ////  + "Se le ha reasignado el perfil: " + tipoPart
                                //        + "</br>"
                                //        + "Justificación: " + row["sObservaciones"].ToString()
                                //        + "</br>"

                                + "<table>"
                                    + "<tr>"
                                        + "<td class=" + "texto" + " colspan=" + "4" + ">" + "Se le informa que se ha reabierto la entrega de la dependencia/entidad: " + "</td>"
                                    + "</tr>"
                                     + "<tr>"
                                        + "<td colspan=" + "4" + ">" + row["nFKDepcia"].ToString() + "</td>"
                                    + "</tr>"
                                    + "<tr>"
                                        + "<td class=" + "texto" + " colspan=" + "4" + ">" + "Que participa en el Proceso E-R : " + "</td>"
                                    + "</tr>"
                                     + "<tr>"
                                        + "<td colspan=" + "4" + ">" + row["sDProceso"].ToString() + "</td>"
                                    + "</tr>"
                                      + "<tr>"
                                        + "<td class=" + "texto" + ">" + "Con fechas de " + tipoProc + " del : " + "</td>"
                                        + "<td>" + strFechaInicio + "</td>"
                                        + "<td class=" + "texto" + ">" + " al " + "</td>"
                                        + "<td>" + strFechaFinal + "</td>"
                                    + "</tr>"
                                     + "<tr>"
                                        + "<td class=" + "texto" + " colspan=" + "4" + ">" + "Justificación: " + "</td>"
                                    + "</tr>"
                                     + "<tr>"
                                        + "<td colspan=" + "4" + ">" + row["sObservaciones"].ToString() + "</td>"
                                    + "</tr>"
                                + "</table>"

                         + "</br>"
                         + "</div>"
                         + "</font>"
                         + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                         ;

                        // USO DE HTML
                        correo.BodyEncoding = System.Text.Encoding.UTF8;
                        correo.IsBodyHtml = true;
                        //
                        this._correos.Add(correo);
                    }
                }
            }
            catch //(Exception e)
            {
            }
        }

        #endregion

        #region pNotificacion_Inclu_exclu_Anexo
        /// <summary>
        /// Procedimiento que envía notificación al excluir e incluir un anexo
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        private void pNotificacion_Inclu_exclu_Anexo()
        {
            try
            {
                if (this._ds != null && this._ds.Tables != null)
                {
                    DataRow drGeneral = this._ds.Tables[0].Rows[0];
                    String strProceso = " ";
                    String strDepcia = "";
                    String strCAnexo = "";
                    String strAnexo = "";
                    String strCApartado = "";
                    String strApartado = "";
                    String strEx_In = "";
                    String strJustif = "";
                    bool b = false;
                    string sEI = "";

                    if (this._ds.Tables[0] != null) // En la tabla 0, regresamos la informacion del Anexo
                    {
                        strProceso = (drGeneral.Table.Columns.Contains("sDProceso") ? drGeneral["sDProceso"].ToString() : "");
                        strDepcia = (drGeneral.Table.Columns.Contains("sDDepcia") ? drGeneral["sDDepcia"].ToString() : "");
                        strCAnexo = (drGeneral.Table.Columns.Contains("sAnexo") ? drGeneral["sAnexo"].ToString() : "");
                        strAnexo = (drGeneral.Table.Columns.Contains("sDAnexo") ? drGeneral["sDAnexo"].ToString() : "");
                        strCApartado = (drGeneral.Table.Columns.Contains("sApartado") ? drGeneral["sApartado"].ToString() : "");
                        strApartado = (drGeneral.Table.Columns.Contains("sDApartado") ? drGeneral["sDApartado"].ToString() : "");
                        strEx_In = (drGeneral.Table.Columns.Contains("cIndAplica") ? drGeneral["cIndAplica"].ToString() : "");
                        strJustif = (drGeneral.Table.Columns.Contains("sJustificacion") ? drGeneral["sJustificacion"].ToString() : "");
                    }
                    if (strEx_In == "S")
                    {
                        sEI = "incluido";
                    }
                    else
                    {
                        sEI = "excluido";
                    }

                    if (this._ds.Tables[1] != null) // Viene la informacion del Usuario Obligado y Enlace Principal
                    {
                        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

                        foreach (DataRow row in this._ds.Tables[1].Rows)
                        {
                            drGeneral = row;
                            string AplicaSujeto = (drGeneral.Table.Columns.Contains("AplicaSujeto") ? drGeneral["AplicaSujeto"].ToString() : "");
                            if (b == false && AplicaSujeto == "S")
                            {
                                System.Net.Mail.MailMessage correo = new System.Net.Mail.MailMessage();
                                //  correo.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                                correo.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones

                                //correo.To.Add("guadominguez@uv.mx");
                                correo.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                                //correo.To.Add((drGeneral.Table.Columns.Contains("correo") ? drGeneral["correo"].ToString() : ""));
                                if (strEx_In == "S")
                                {
                                    correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "INCLUSIÓN DE ANEXO";
                                }
                                else
                                {
                                    correo.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "EXCLUSIÓN DE ANEXO";
                                }

                                // PARA EL USO DE HTML
                                correo.SubjectEncoding = System.Text.Encoding.UTF8;
                                //
                                correo.Body =

                            //        "<style>" +
                            //        "  .fixedfont { font-size : 11pt }"
                            //        + "</style>" +
                            //        "<div  class=" + "fixedfont" + ">" +
                            //        "<font face=" + "arial" + ">"
                            //        +

                            //"Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("sujeto") ? drGeneral["sujeto"].ToString() : "") + "</b>"
                            //    + "</br>"									    
                            //    + "</br>" + "Se ha "+sEI+" el Anexo: " + "<b>" + strCAnexo+" "+strAnexo + "</b>"									   
                            //    + "</br>" + "Correspondiente al Proceso: " + "<b>" + strProceso + "</b>"
                            //    + "</br>" + "Dependencia: " + "<b>" + strDepcia + "</b>"
                            //    + "</br>" + "Apartado: " + "<b>" + strCApartado+" "+strApartado + "</b>"
                            //    + "</br>"								
                            //    + "</br>" + "La justificacion es: " + "<b>" + strJustif + "</b>"
                            //    + "</font>"
                            //+ "</div>"
                            //    ;

                            "<style>" +
                                "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                                "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                                "  .s4font { font-size : 10pt; text-align:center}" +
                                "  .texto { color:#848484; font-weight: bold }"
                                +
                                "</style>" +
                                    "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                                    "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                                    "</br></br>" +
                                   "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("sujeto") ? drGeneral["sujeto"].ToString() : "") + "</b>" + "</div>"
                                    + "</br>"
                                    + "</br>"
                                    + "<div  class=" + "bodyfont" + ">" +
                                     "<font face=" + "arial" + ">"

                                   + "<table>"
                                   + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Se ha " + sEI + " el Anexo: " + "</td>"
                                    + "<td>" + strCAnexo + " " + strAnexo + "</td>" + "<td></td>" + "<td></td>"
                                   + "</tr>"
                                   + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Apartado: " + "</td>" + "<td>" + strCApartado + " " + strApartado + "</td>"
                                   + "</tr>"
                                   + "<tr>"
                                   + "<td class=" + "texto" + ">" + "Correspondiente al Proceso Entrega-Recepción: " + "</td>" + "<td colspan=" + "4" + ">" + strProceso + "</td>"
                                    + "<td></td>"
                                    + "</tr>"
                                    + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Dependencia/Entidad: " + "</td>" + "<td colspan=" + "4" + ">" + strDepcia + "</td>"
                                   + "</tr>"
                                   + "<tr>"
                                    + "<td class=" + "texto" + ">" + "La justificacion es: " + "</td>"
                                   + "</tr>"
                                   + "<tr>"
                                    + "<td colspan=" + "5" + ">" + strJustif + "</td>"
                                   + "</tr>"
                                    + "</table>"

                                   + "</div>"
                                   + "</font>"
                                   + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                                   ;
                                // USO DE HTML
                                correo.BodyEncoding = System.Text.Encoding.UTF8;
                                correo.IsBodyHtml = true;
                                //

                                this._correos.Add(correo);
                                b = true;
                            }
                            //*************************************************************************************************************

                            string AplicaEnlace = (drGeneral.Table.Columns.Contains("AplicaEnlace") ? drGeneral["AplicaEnlace"].ToString() : "");

                            if (AplicaEnlace == "S")
                            {
                                System.Net.Mail.MailMessage correo2 = new System.Net.Mail.MailMessage();
                                //correo2.From = new System.Net.Mail.MailAddress("erenriquez@uv.mx");
                                correo2.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["AppMail"]); // Correo desde el Cual se enviaran las notificaciones

                                //correo2.To.Add("guadominguez@uv.mx");
                                correo2.To.Add(ConfigurationManager.AppSettings["MailsTo"]);
                                //correo2.To.Add((drGeneral.Table.Columns.Contains("sCorreo") ? drGeneral["sCorreo"].ToString() : ""));
                                if (strEx_In == "S")
                                {
                                    correo2.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "INCLUSIÓN DE ANEXO";
                                }
                                else
                                {
                                    correo2.Subject = ConfigurationManager.AppSettings["Subject"] + " - " + "EXCLUSIÓN DE ANEXO";
                                }
                                correo2.Body =
                              //        "<style>" +
                              //        "  .fixedfont { font-size : 11pt }"
                              //        + "</style>" +
                              //        "<div  class=" + "fixedfont" + ">" +
                              //        "<font face=" + "arial" + ">"
                              //        +

                              //"Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("sNombre") ? drGeneral["sNombre"].ToString() : "") + "</b>"
                              //    + "</br>"
                              //    + "</br>" + "Se ha " + sEI + " el Anexo: " + "<b>" + strCAnexo + " " + strAnexo + "</b>"
                              //    + "</br>" + "Correspondiente al Proceso: " + "<b>" + strProceso + "</b>"
                              //    + "</br>" + "Dependencia: " + "<b>" + strDepcia + "</b>"
                              //    + "</br>" + "Apartado: " + "<b>" + strApartado + "</b>"
                              //    + "</br>"
                              //    + "</br>" + "La justificacion es: " + "<b>" + strJustif + "</b>"
                              //    + "</font>"
                              //+ "</div>"
                              //    ;
                              "<style>" +
                                "  .namefont { font-size : 14pt; text-align:center;  background-color: #B0C4DE }" +
                                "  .bodyfont { font-size : 12pt;  text-align:justify }" +
                                "  .s4font { font-size : 10pt; text-align:center}" +
                                "  .texto { color:#848484; font-weight: bold }"
                                +
                                "</style>" +
                                    "<div  align =" + "center" + ">" + "<b>" + " Notificación" + "</b>" + "</div>" +
                                    "<div align =" + "center" + ">Sistema de Entrega - Recepción de la Universidad Veracruzana</div>" +
                                    "</br></br>" +
                                   "<div class=" + "namefont" + ">Estimado(a)  " + "<b>" + (drGeneral.Table.Columns.Contains("sNombre") ? drGeneral["sNombre"].ToString() : "") + "</b>" + "</div>"
                                    + "</br>"
                                    + "</br>"

                                     + "<div  class=" + "bodyfont" + ">" +
                                    "<font face=" + "arial" + ">"

                                     + "<table>"
                                   + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Se ha " + sEI + " el Anexo: " + "</td>"
                                    + "<td>" + strCAnexo + " " + strAnexo + "</td>" + "<td></td>" + "<td></td>"
                                   + "</tr>"
                                   + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Apartado: " + "</td>" + "<td>" + strApartado + "</td>"
                                   + "</tr>"
                                   + "<tr>"
                                   + "<td class=" + "texto" + ">" + "Correspondiente al Proceso entrega-recepción: " + "</td>" + "<td colspan=" + "4" + ">" + strProceso + "</td>"
                                    + "<td></td>"
                                    + "</tr>"
                                    + "<tr>"
                                    + "<td class=" + "texto" + ">" + "Dependencia/Entidad: " + "</td>" + "<td colspan=" + "4" + ">" + strDepcia + "</td>"
                                   + "</tr>"
                                   + "<tr>"
                                    + "<td class=" + "texto" + ">" + "La justificacion es: " + "</td>"
                                   + "</tr>"
                                   + "<tr>"
                                    + "<td colspan=" + "5" + ">" + strJustif + "</td>"
                                   + "</tr>"
                                    + "</table>"

                                   + "</div>"
                                   + "</font>"
                                   + "<div class=" + "s4font" + "> </br></br><b> Favor de no enviar correos a esta cuenta, ya que es utilizada por un proceso automatizado y por lo tanto no se revisa</b></div>"
                                   ;

                                // USO DE HTML
                                correo2.BodyEncoding = System.Text.Encoding.UTF8;
                                correo2.IsBodyHtml = true;
                                //
                                this._correos.Add(correo2);

                            }
                        }
                        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::   
                    }
                }
            }
            catch
            {
                this._ds.Dispose();
            }
            finally
            {
                this._ds.Dispose();
            }
        }
        #endregion

        #region void SendMails()
        /// <summary>
        /// Función que envía correos electrónicos
        /// </summary>
        public void SendMails()
        {
            clsNotifica objNotifica = new clsNotifica();
            objNotifica.MailSplit();            // Obtiene la cuenta desde la cual se enviaran las notificaciones
            if (this._correos != null)
            {

                foreach (System.Net.Mail.MailMessage correo in this._correos)
                {
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("exuv01.intra.uv.mx");
                    //smtp.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["AppAccount"], DES.funDES_FromBase64(ConfigurationManager.AppSettings["AppMailPwd"]));
                    smtp.Credentials = new System.Net.NetworkCredential(objNotifica._strAccount, DES.funDES_FromBase64(ConfigurationManager.AppSettings["AppMailPwd"]));
                    smtp.Port = 25;

                    try
                    {
                        smtp.Send(correo);
                    }
                    catch
                    {
                        correo.Dispose();
                    }
                    finally
                    {
                        correo.Dispose();
                    }
                }
            }
        }
        #endregion

        #region public void SendNotificacion()
        /// <summary>
        /// Procedimiento que enviará notificaciones vía correo electrónico según la opción que se paso en el contructor.
        /// </summary>
        public void SendNotificacion(DataSet dsDatos)
        {
            _ds = (dsDatos != null ? dsDatos : null);
            switch (this._strOpcion)
            {
                case "INTEGRAR":
                    pNotificacionIntegrar();
                    break;
                case "ENVIAR_ER":
                    pNotificacionER();
                    break;
                case "GUIA":
                    break;
                case "APARTADO":
                    break;
                case "ANEXO":
                    pNotificacionANEXO();
                    break;
                case "NUEVO_PROCESO":
                    pNotificacionNuevoProceso();
                    break;
                case "MODIFICAR_FEC_PROCESO":
                    pNotificacionModificarFecProceso();
                    break;
                case "MODIFICAR_PROCESO_EXT":
                    pNotificacionModificarProcesoExt();
                    break;
                case "EXCLU_INCLU_ANEXO":
                    pNotificacion_Inclu_exclu_Anexo();
                    break;
                case "CAMB_SUJ_OB":
                    pCambSujOb();
                    break;
                case "INC_PART":
                    pIncPart();
                    break;
                case "SUJ_RECP":
                    pSujRecp();
                    break;
                case "EXC_PART":
                    pExcPart();
                    break;
                case "PART_EXT":
                    pPartExt();
                    break;
                case "CIERRE_PROC":
                    pCierreProc();
                    break;
                case "REAP_PROC":
                    pReapertProc();
                    break;
            }
            SendMails();
            dsDatos.Dispose();
        }
        #endregion


        #region public void MailSplit()
        /// <summary>
        /// Procedimiento que obtiene el nombre de la cuenta que se usara para el envío de los correos de notificaciones, mediante la función split.
        /// Autor: Edgard Morales
        /// </summary>
        /// 
        public void MailSplit()
        {
            string value = ConfigurationManager.AppSettings["AppMail"];
            string[] lines = Regex.Split(value, "@");
            _strAccount = lines[0];
        }
        #endregion



        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        #region  fEnviaCorreoUsuario
        /// <summary>
        /// Autor:              Edgar Morales González
        /// Objetivo:           Función que envía correos a usuarios, sin hacer referencia a algún proceso especifico.
        /// </summary>
        /// <param name="recomendacion">Texto del mensaje</param>
        /// <param name="idUsuario">Id del suario que envia el mensaje</param>
        /// <param name="arregloUsuarios">Id de los usuarios a quien se enviara el mensaje</param>
        /// <param name="asunto">Asunto del mensaje</param>
        /// <returns></returns>
        public int fEnviaCorreoUsuario(string recomendacion, int idUsuario, string arregloUsuarios, string asunto)
        {
            try
            {
                string strAccion = "ENVIA_CORREO";
                this._lstParametros = new System.Collections.ArrayList();
                using (clsDALSQL objDASQL = new clsDALSQL(false))
                {
                    libSQL lSQL = new libSQL();
                    _lstParametros.Add(lSQL.CrearParametro("@strRECOMENDACION", recomendacion));
                    _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                    _lstParametros.Add(lSQL.CrearParametro("@strARRAYUSUARIOS", arregloUsuarios));
                    _lstParametros.Add(lSQL.CrearParametro("@strOPCION", strAccion));
                    _lstParametros.Add(lSQL.CrearParametro("@strAsunto", asunto));

                    if (objDASQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", _lstParametros))
                    {
                        DataSet ds = objDASQL.Get_dtSet();                                              //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente

                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);                           //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML


                        clsWSNotif wsNotif = new clsWSNotif();                                          //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "ENV_CORREO"));          //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria
                        tmod.Start();

                        _intResp = 1;   //Hizo bien el Query
                    }
                    else
                    {
                        _intResp = 0; // No hizo la consulta
                    }
                }
            }
            catch
            {
                _intResp = 0;
            }
            return _intResp;
        }
        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #endregion

    }
}