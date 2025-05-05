using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using libFunciones;
using nsSERUV;

public partial class General_SGDDESCAR : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {       
        try
        {
            if (Request.QueryString["guid"] != null
                && !Request.QueryString["guid"].Equals(string.Empty)
                && Request.QueryString["strOpcion"] != null
                && !Request.QueryString["strOpcion"].Equals(string.Empty)
                )
            { // Se pregunta si se enviar el guid del archivo y la opción a ejecutar
                if (!Session.IsNewSession) // No es una sesion nueva, ya se tiene una
                {
                    using (clsArchivo objArchivo = new clsArchivo())
                    {
                        using (clsValidacion objValidacion = new clsValidacion())
                        {
                            string[] strSesion = Context.User.Identity.Name.Split(('|'));
                            
                            objArchivo.gidFormato = Request.QueryString["guid"].ToString();
                            objArchivo.strOpcion = Request.QueryString["strOpcion"].ToString();
                            objArchivo.idUsuario = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0);

                            objArchivo.pGetArchivoBDDWU(); // Se consulta el archivo a descargar (puede ser un formato/guía o un archivo de ER)

                            switch (objArchivo.strMimeType)
                            {
                                // Opciones fijas por problemas con formatos en .doc
                                case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
                                    Response.Clear();
                                    Response.ContentType = "Application/msword"; //application/vnd.ms-excel
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + objArchivo.strNomArchivo);
                                    Response.BinaryWrite(objArchivo.bytDatos1.ToArray());
                                    Response.Flush();
                                    Response.Close();
                                    
                                    break;
                                // Opciones fijas por problemas con formatos en .xls
                                case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
                                    Response.Clear();
                                    Response.ContentType = "application/vnd.ms-excel";
                                    Response.AddHeader("Content-Disposition", "attachment; filename=" + objArchivo.strNomArchivo);
                                    Response.BinaryWrite(objArchivo.bytDatos1.ToArray());
                                    Response.Flush();
                                    Response.Close();
                                    
                                    break;
                                default:

                                    if (Request.QueryString["strVer"] == "SI") // Opción para el visualizador de PDF
                                    {
                                        // No se elimina este código puesto que es para poder implementar una marca de agua en un pdf
                                        //using (clsWaterMark2 wm = new clsWaterMark2(objArchivo.bytDatos1, objArchivo.strNomUsuario))
                                        //{
                                            Response.Clear();
                                            Response.ClearContent();                                          
                                            Response.ContentType = objArchivo.strMimeType;                                           
                                            Response.BinaryWrite(objArchivo.bytDatos1.ToArray());    
                                            Response.Flush();                                           
                                            Response.End();
                                        //}
                                    }
                                    else // Se ejecuta cuando se quiere descargar un archivo
                                    {

                                        Response.ClearContent();
                                        Response.ContentType = objArchivo.strMimeType;
                                        Response.AddHeader("Content-Disposition",
                                                            "attachment; filename=" + objArchivo.strNomArchivo);
                                        Response.BinaryWrite(objArchivo.bytDatos1.ToArray());
                                        Response.Flush();
                                        Response.End();
                                        //Response.Close();

                                    }
                                    break;
                            }

                        }
                    }
                }
            }
        }
        catch //(System.Threading. ThreadAbortException)//(Exception ex)
        {
        }
    }
       
}