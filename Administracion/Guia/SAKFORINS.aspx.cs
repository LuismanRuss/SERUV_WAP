using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nsSERUV;
using libFunciones;

public partial class Administracion_Guia_SAKFORINS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    /// <summary>
    /// Función para subir un archivo en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    protected void lkb_aceptar_Click(object sender, EventArgs e)
    {
        string Ext = "";
        using (clsArchivo objArchivo = new clsArchivo())
        {
            //Verificamos que tipo de archivo es: F = Formato, G = Guía
            if (hf_cTipo.Value == "F") { Ext = "ExtAN"; }
            if (hf_cTipo.Value == "G") { Ext = "ExtER"; }

            //Validamos las extensiones permitidas para ese tipo de archivo (.doc, docx, xls, xlsx, pdf... etc)
            //if (objArchivo.pValidaArchivo(fu_archivo, System.Configuration.ConfigurationManager.AppSettings["ExtAN"].Split((','))))
              if (objArchivo.pValidaArchivo(fu_archivo, System.Configuration.ConfigurationManager.AppSettings[Ext].Split((','))))
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                       //Creamos nuestro objeto de la clase de Anexo
                    using (clsAnexo anxo = new clsAnexo())
                    {

                        //Asignamos nuestros datos obtenidos del Cliente, a nuestro objeto de Anexo
                        anxo.docFormato = new clsArchivo();
                        anxo.docFormato.gidFormato = Guid.NewGuid().ToString();
                        objArchivo.idUsuario = (objValidacion.IsNumeric(hf_idUsuario.Value) ? int.Parse(hf_idUsuario.Value) : -1);
                        objArchivo.chrTipo = Convert.ToChar(hf_cTipo.Value);
                        //Subimos nuestro Archivo a la Base de Datos
                        //ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>SubirArchivo('" + objArchivo.pUploadFileBD(fu_archivo, "DOCFORMATO", "INSERT") + objArchivo.strNomArchivo + objArchivo.gidFormato + "');</script>");
                        ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>fSubirArchivo('" + objArchivo.pUploadFileBD(fu_archivo, "DOCFORMATO", "INSERT") + "', '" + objArchivo.strNomArchivo + "', '" + objArchivo.gidFormato + "', '" + objArchivo.chrTipo + "');</script>");
                        //ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>SubirArchivo('" + objArchivo.pUploadFileBD(fu_archivo, "DOCFORMATO", "INSERT") + "', '" + objArchivo.strNomArchivo + "', '" + objArchivo.gidFormato  + "');</script>");
                    }
                }
            }
            else
            {
                 //En caso de NO Validar las extensiones del Archivo, mandamos a llamar el mensaje para validar la accion 
                ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>fMensaje('" + objArchivo.strMensaje + "');</script>");
            }
        }

    }
}