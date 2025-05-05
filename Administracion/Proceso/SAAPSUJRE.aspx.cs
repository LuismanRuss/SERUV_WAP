 using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using nsSERUV;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Administracion_Proceso_SAAPSUJRE : System.Web.UI.Page
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
    /// MÉTODO QUE REGRESA LOS USUARIOS QUE PODRAN SER CONFIGURADOS COMO SUJETO RECEPTOR EN ESTA DEPENDENCIA
    /// </summary>
    /// <param name="nIdParticipante">ID del participante</param>
    /// <param name="idProceso">ID del proceso</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int nIdParticipante, int idProceso)
    {
        clsParticipante objPart = new clsParticipante();
        string strCadena = string.Empty;
        try
        {
            objPart.fGetSujetoReceptor(nIdParticipante, idProceso);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPart.laRegresaDatos).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objPart.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region fGuardarSujRec
    /// <summary>
    /// MÉTODO QUE GUARDA AL SUJETO RECEPTOR DE LA DEPENDENCIA
    /// </summary>
    /// <param name="nIdSujRecp">ID del usuario que se asignará como sujeto receptor en la dependencia</param>
    /// <param name="nIdParticipante">ID del participante</param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fGuardarSujRec(int nIdSujRecp, int nIdParticipante, int nIdUsuario)
    {
        string sResp = "";
        var objPart = new clsParticipante();
        try
        {
            sResp = objPart.fAsignarSujReceptor(nIdParticipante, nIdSujRecp, nIdUsuario);
        }
        catch
        {
            throw;
        }
        finally
        {
            objPart.Dispose();
        }

        return sResp;
    }
    #endregion
}