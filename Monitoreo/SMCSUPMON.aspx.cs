using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization; 
using libFunciones;
using nsSERUV;

public partial class Monitoreo_SMCSUPMON : System.Web.UI.Page
{
    #region protected void Page_Load(object sender, EventArgs e)
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    // Variables que vendran por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                }
            }
        }
    }
    #endregion

    #region string pGetDatosAnexo(clsAnexo objAnexo)
    /// <summary>
    /// Procedimiento que regresara informacion asociada a un Anexo
    /// Autor: Erik Jose Enriquez Carmona
    /// Ultima Actualizacion: 10 de Marzo de 2013
    /// </summary>
    /// <param name="objAnexo">Objeto Anexo</param>
    /// <returns>Una cadena con las propiedades que se necesitan del anexo</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosAnexo(clsAnexo objAnexo)
    {
        string strDatosAnexo = string.Empty;
        if (objAnexo != null)
        {
            objAnexo.pGetDatosERAnexoH();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosAnexo = serializer.Serialize(objAnexo);
            objAnexo.Dispose();
        }
        return strDatosAnexo.Normalize();
    }
    #endregion

    #region string pGetDatosParticipante(clsParticipante objParticipante)
    /// <summary>
    /// Procedimiento que regresará información de un Participante
    /// </summary>
    /// <param name="objParticipante">Objeto Participante</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosParticipante(clsParticipante objParticipante)
    {
        string strDatosParticipante = string.Empty;
        if (objParticipante != null)
        {
            objParticipante.pGetDatosERH();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosParticipante = serializer.Serialize(objParticipante);
            objParticipante.Dispose();
        }
        return strDatosParticipante.Normalize();
    }
    #endregion

    #region string pGetDatosER(clsRegistro objRegistro)
    /// <summary>
    /// Procedimiento que desplegará la información de los procesos actuales e históricos
    /// Autor: Erik José Enríquez Carmona
    /// Última Actualización: 06 Marzo 2013
    /// </summary>
    /// <param name="objRegistro">Objeto que contiene la información de la ER</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosER(clsProcesoER objProceso)
    {
        string strDatosER = string.Empty;
        if (objProceso != null)
        {     
            objProceso.pGetProcesoERH();
            var serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosER = serializer.Serialize(objProceso);
            objProceso.Dispose();
        }

        return strDatosER.Normalize();
    }
    #endregion

}