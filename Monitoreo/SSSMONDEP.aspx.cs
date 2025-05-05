using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using nsSERUV;
using  libFunciones;
using System.Web.Services;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Monitoreo_SSSMONDEP : System.Web.UI.Page
{
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

    #region pPinta_Grid
    /// <summary>
    /// Método que regresa los datos que pintarán la forma
    /// </summary>
    /// <param name="idParticipante">ID del particiapnte</param>
    /// <param name="idUsuario">ID  del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int idParticipante, int idUsuario)
    {
        clsSupervision objSupervision = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            objSupervision.GetAvanceDepcia(idParticipante, idUsuario);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += "{'datos':[" + serializer.Serialize(objSupervision.laAvanceDepcia).Normalize() + "," + serializer.Serialize(objSupervision.laRegresaDatos).Normalize() + "," + serializer.Serialize(clsSupervision.laEnlaceOperativo).Normalize() + "," + serializer.Serialize(clsSupervision.laEnlaceOperativoReceptor).Normalize() + "]}";
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objSupervision.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region fAbre_Proceso
    /// <summary>
    /// Método que reabre el proceso de la dependencia
    /// </summary>
    /// <param name="nIdUsuario">ID  del usuario logueado</param>
    /// <param name="nIdParticipante">ID del participante</param>
    /// <param name="sJustificacion">Justificación por el cual se abre el proceso</param>
    /// <param name="nidProceso">ID  del proceso</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fAbre_Proceso(int nIdUsuario, int nIdParticipante, string sJustificacion, int nidProceso)
    {
        string strRespuesta = string.Empty;
        clsSupervision objSupervicion = new clsSupervision();
        try
        {
            strRespuesta = objSupervicion.Abre_Proceso(nIdParticipante, nIdUsuario, sJustificacion, nidProceso);
        }
        catch
        {
            throw;
        }
        finally
        {
            objSupervicion.Dispose();
        }
        return strRespuesta;
    }
    #endregion

    #region pGetDatosAnexo
    /// <summary>
    /// Método que obtiene los datos del anexo
    /// </summary>
    /// <param name="objAnexo">el objeto que contiene las propiedades del anexo</param>
    /// <returns></returns>
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
}