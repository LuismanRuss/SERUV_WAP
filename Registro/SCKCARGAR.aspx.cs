using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization; 
using nsSERUV;
using libFunciones;

public partial class Registro_SCKCARGAR : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    #region protected void LinkButton1_Click(object sender, EventArgs e)
    /// <summary>
    /// Procedimiento que se lanza cuando se guara el archivo.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        using (clsArchivo objArchivo = new clsArchivo())
        {
            // Se valida que el archivo que se intenta subir, corresponde a las extensiones permitidas (PDF)
            if (objArchivo.pValidaArchivo(fu_archivo, System.Configuration.ConfigurationManager.AppSettings["ExtER"].Split((','))))
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {

                    objArchivo.idUsuario = (objValidacion.IsNumeric(hf_nIdUsuario.Value) ? int.Parse(hf_nIdUsuario.Value) : -1 );
                    objArchivo.idUsuarioO = (objValidacion.IsNumeric(hf_nIdUsuarioO.Value) ? int.Parse(hf_nIdUsuarioO.Value) : -1);
                    objArchivo.idPartAplic = (objValidacion.IsNumeric(hf_nIdPartAplic.Value) ? int.Parse(hf_nIdPartAplic.Value) : -1);
                    objArchivo.dteFCorte = (objValidacion.IsDate(objValidacion.ConvertDatePicker(txt_dFCorte.Text)) ? DateTime.Parse(objValidacion.ConvertDatePicker(txt_dFCorte.Text)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                    objArchivo.dteFAlta = DateTime.Now.ToString("yyyy/MM/dd HH:mm");
                    objArchivo.strObserva = txt_sObservaciones.Text.Trim();
                    objArchivo.chrTipoInfo = char.Parse(rbl_TInfo.SelectedValue);
                    objArchivo.strAcuerdo = txt_nacuerdo.Text.Trim();
                    objArchivo.dteFAcuerdo = (objValidacion.IsDate(objValidacion.ConvertDatePicker(txt_dFacuerdo.Text)) ? DateTime.Parse(objValidacion.ConvertDatePicker(txt_dFacuerdo.Text)).ToString("yyyyMMdd HH:mm:ss") : string.Empty);
                    
                    // Se carga el archivo a la BD
                    objArchivo.pUploadFileBD(fu_archivo, "DOCARCHIVO", "INSERT");
                                        
                    // Se envía un mensaje al cliente de éxito o informativo.
                    ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>SubirArchivo('" + objArchivo.strResp + "','" + objArchivo.strNomArchivo + "');</script>");
                    
                }
            }
            else
            {
                // Si no corresponde a la extensión correcta se genera un mensaje de error y se muestra en el cliente al usuario.
                ClientScript.RegisterStartupScript(this.GetType(), "JSScript", "<script language=JavaScript>mensaje('" + objArchivo.strMensaje + "');</script>");
            }
        }
    }
    #endregion

    #region static string pModificar(clsArchivo objArchivo)
    /// <summary>
    /// Actualiza la información asociada a un archivo de una ER
    /// </summary>
    /// <param name="objArchivo">Objeto Archivo</param>
    /// <returns>Objeto Archivo</returns>
    [WebMethod(EnableSession = true)]
    public static string pModificar(clsArchivo objArchivo)
    {
        string strArchivo = string.Empty; // variable donde se regresara un objeto json
        if (objArchivo != null)
        {
            objArchivo.pUpdateFileBD(); // actualiza el detalle del archivo 
            JavaScriptSerializer serializer = new JavaScriptSerializer(); // se crea un archivo para seliarizar un objeto a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se quitan las propiedades nulas
            strArchivo = serializer.Serialize(objArchivo); // se serializa el objeto a una cadena
            objArchivo.Dispose();   
        }

        return strArchivo; // se regresa una cadena al cliente
    }
    #endregion
}