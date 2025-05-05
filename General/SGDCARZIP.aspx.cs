using System;
using System.Linq;
using System.IO;
using System.Web;
using nsSERUV;
using System.Data;
using libFunciones;
using Ionic.Zip;

public partial class General_SGDCARZIP : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Función que se ejecuta al cargar la página y genera el zip con los archivos cargados por el usuario, de acuerdo a la opción seleccionada.
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>AbrirLoading();</script>");
            //Response.Write("<script> loading.ini(); </script>");
            if (Request.QueryString["strOpcion"] != null
                && !Request.QueryString["strOpcion"].Equals(string.Empty)
                && Request.QueryString["proceso"] != null
                && !Request.QueryString["proceso"].Equals(string.Empty)
                && Request.QueryString["participante"] != null
                && !Request.QueryString["participante"].Equals(string.Empty)
                && Request.QueryString["ID"] != null
                && !Request.QueryString["ID"].Equals(string.Empty)
                )
            {
                DataSet dtsArchivos = new DataSet();
                string strOpcion = Request.QueryString["strOpcion"];
                
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    string[] strSesion = Context.User.Identity.Name.Split(('|')); // ID del usuario de la sesion
                    int idUsuario = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0);

                    if (strOpcion == "proceso") // Si se descargarán todos los archivos del proceso
                    {
                        // Se crea un objeto de la clase proceso y se llama al método fGetCargaProceso para obtener los archivos
                        clsProceso objProceso = new clsProceso();
                        objProceso.idProceso = Convert.ToInt32(Request.QueryString["proceso"]);
                        objProceso.strOpcion = Request.QueryString["strOpcion"];
                        objProceso.intParticipante = Convert.ToInt32(Request.QueryString["participante"]);

                        dtsArchivos = objProceso.fGetCargaProceso(idUsuario);

                    }
                    else if (strOpcion == "apartado") // Si se descargarán todos los archivos del apartado
                    {
                        // Se crea un objeto de la clase apartado y se llama al método fGetCargaApartado para obtener los archivos
                        clsApartado objApartado = new clsApartado();
                        objApartado.idApartado = Convert.ToInt32(Request.QueryString["ID"].ToString());
                        objApartado.idParticipante = Convert.ToInt32(Request.QueryString["participante"].ToString());
                        objApartado.strOpcion = Request.QueryString["strOpcion"];
                        dtsArchivos = objApartado.fGetCargaApartado(Convert.ToInt32(Request.QueryString["proceso"].ToString()), idUsuario);

                    }
                    else if (strOpcion == "anexo") // Si se descargarán todos los archivos del anexo
                    {
                        // Se crea un objeto de la clase anexo y se llama al método fGetCargaAnexo para obtener los archivos
                        clsAnexo objAnexo = new clsAnexo();
                        objAnexo.idAnexo = Convert.ToInt32(Request.QueryString["ID"]);
                        objAnexo.idProceso = Convert.ToInt32(Request.QueryString["proceso"].ToString());
                        objAnexo.idParticipante = Convert.ToInt32(Request.QueryString["participante"].ToString());
                        objAnexo.strOpcion = Request.QueryString["strOpcion"];
                        dtsArchivos = objAnexo.fGetCargaAnexo(idUsuario);
                    }

                    if (dtsArchivos != null && dtsArchivos.Tables[0].Rows.Count > 0)
                    {
                        if (dtsArchivos.Tables[1].Rows.Count > 0)
                        {
                            // Se guarda en una variable el nombre del zip, el cual será el código del proceso
                            string strNombreZip = string.Empty;
                            DataRow drProceso = dtsArchivos.Tables[0].Rows[0];
                            strNombreZip = drProceso.Table.Columns.Contains("sProceso") ? drProceso["sProceso"].ToString() : "";
                            strNombreZip += "-";
                            strNombreZip += drProceso.Table.Columns.Contains("nDepcia") ? drProceso["nDepcia"].ToString() : "";
                            strNombreZip += ".zip";
                            using (StringWriter sw = new StringWriter())
                            {
                                using (MemoryStream ms = new MemoryStream())
                                {
                                    Response.Clear();
                                    Response.Buffer = true;
                                    Response.ContentType = "aplication/zip";
                                    Response.AddHeader("Content-Disposition", "attachment;filename=" + strNombreZip);
                                    this.EnableViewState = false;
                                    // Se utiliza la librería ZipFile para crear los archivos zip con los archivos
                                    using (ZipFile zip = new ZipFile())
                                    {
                                        // Se recorre el dataset (Tabla 2 - Información de apartados)
                                        foreach (DataRow drApartados in dtsArchivos.Tables[1].Rows)
                                        {
                                            // (Tabla 3 - Información de anexos)
                                            foreach (DataRow drAnexos in dtsArchivos.Tables[2].Rows)
                                            {
                                                if (int.Parse(drApartados["nIdApartado"].ToString()) == int.Parse(drAnexos["nIdApartado"].ToString()))
                                                {
                                                    // (Tabla 3 - Información de los archivos)
                                                    foreach (DataRow drArchivos in dtsArchivos.Tables[3].Rows)
                                                    {
                                                        if (int.Parse(drAnexos["nIdAnexo"].ToString()) == int.Parse(drArchivos["nIdAnexo"].ToString()))
                                                        {
                                                            //string str = "Apartado/Anexo/Archivo.pdf";
                                                            string strApartado = drApartados["sApartado"].ToString();// +"-" + drApartados["sDApartado"].ToString();
                                                            strApartado = fReemplazaCaracteres(strApartado);
                                                            if (strApartado.Length > 150)
                                                            {
                                                                strApartado = strApartado.Substring(0, 150);
                                                                strApartado += "_";
                                                            }

                                                            string strAnexo = drAnexos["sAnexo"].ToString();// +"-" + drAnexos["sDAnexo"].ToString();
                                                            strAnexo = fReemplazaCaracteres(strAnexo);
                                                            if (strAnexo.Length > 150)
                                                            {
                                                                strAnexo = strAnexo.Substring(0, 150);
                                                                strAnexo += "_";
                                                            }

                                                            // llama la marca de agua
                                                         //   clsWaterMark2 wm = new clsWaterMark2((byte[])drArchivos["bDatos"], drArchivos["sNomUsuario"].ToString());
                                                            //

                                                            // Se agrega el archivo al zip con la dirección en que se ubicará dentro del mismo y la cadena de bytes que forman el archivo
                                                            zip.AddEntry(strApartado + "/" +
                                                            strAnexo + "/" +
                                                                //drArchivos["nIdEntrega"].ToString() + "-" + drArchivos["sNomArchivo"].ToString(), (byte[])drArchivos["bDatos"]);
                                                           drArchivos["sNomArchivo"].ToString(), (byte[])drArchivos["bDatos"]);

                                                            // trae el archivo con marca de agua
                                                           // drArchivos["sNomArchivo"].ToString(), wm.PDFBytes.ToArray());
                                                            //} ?????
                                                            //
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        zip.Save(ms);
                                        ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>CerrarLoading();</script>");
                                        //Response.Write("<script> loading.close(); </script>");
                                    }
                                    HttpContext.Current.Response.BinaryWrite(ms.ToArray());
                                    HttpContext.Current.Response.End();
                                }
                            }
                        }
                    }

                }
            }
        }
        catch (Exception ex) {
            Response.Write(ex.Message);
        }
        Response.Write("<script> window.close(); </script>");
        //ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>CerrarLoading();</script>");
        //ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>CerrarVentana();</script>");
    }
    #endregion

    #region fReemplazaCaracteres
    /// <summary>
    /// Función que se encarga de reemplazar caracteres inválidos para nombres de carpetas en Windows
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="sCadena">Cadena a reemplazar</param>
    /// <returns>Cadena sin los caracteres inválidos reemplazados por vacío</returns>
    public string fReemplazaCaracteres(string sCadena) {
        //< > \ / : | * ? .
        string strCadenan1 = sCadena.Replace("<", "");
        string strCadenan2 = strCadenan1.Replace(">", "");
        string strCadenan3 = strCadenan2.Replace(@"\", "");
        string strCadenan4 = strCadenan3.Replace("/", "");
        string strCadenan5 = strCadenan4.Replace(":", "");
        string strCadenan6 = strCadenan5.Replace("|", "");
        string strCadenan7 = strCadenan6.Replace("*", "");
        string strCadenan8 = strCadenan7.Replace("?", "");
        string strCadenan9 = strCadenan8.Replace(".", "");
        return strCadenan9.Trim();
    }
    #endregion
}