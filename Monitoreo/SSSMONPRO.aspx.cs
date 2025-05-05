 using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using nsSERUV;
using libFunciones;
using System.Web.Services;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Monitoreo_SSSMONPROC : System.Web.UI.Page
{
  private  static int nIdUsuario = 0;

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
                    nIdUsuario = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0);
                }
            }
        }
    }

    #region
    /// <summary>
    /// Método que obtiene los procesos del usuario en los que se encuentra como supervisor
    /// </summary>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pGetProceso(int nIdUsuario)
    {
        clsSupervision objSupervision = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            objSupervision.fGetProcesos(nIdUsuario);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objSupervision.laRegresaDatos).Normalize();
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

    #region
    /// <summary>
    /// Método que pinta la forma con el avance general del proceso y el avance de las dependencias
    /// </summary>
    /// <param name="nIdProceso">ID del proceso</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int nIdProceso)
    {
        clsSupervision objSupervision = new clsSupervision();
        string strCadena = string.Empty;
        try
         {
             objSupervision.fGetAvanceProceso(nIdProceso, "SUPERVISION", nIdUsuario);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += "{'datos':[" + serializer.Serialize(objSupervision.laAvanceGeneral).Normalize() + "," + serializer.Serialize(objSupervision.laRegresaDatos).Normalize() + "]}";
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

    #region
    /// <summary>
    /// Método que obtiene los anexos excluidos de la dependencia
    /// </summary>
    /// <param name="nIdParticipante">ID del particiapnte</param>
    /// <param name="numeroAnexos">numero de anexos excluidos</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fGetAnexosExcluidos(int nIdParticipante, int numeroAnexos)
    {
        clsSupervision objSupervision = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            if (objSupervision.fGetAnexosExcluidos(nIdParticipante, numeroAnexos) == false)
            {
                strCadena = "2";
            }
            else
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                strCadena += serializer.Serialize(objSupervision.laRegresaDatos).Normalize();
            }
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

    #region
    /// <summary>
    /// Método que obtiene los anexos pendientes de la dependencia
    /// </summary>
    /// <param name="nIdParticipante">ID  del particiapnte</param>
    /// <param name="numeroAnexos">numero de anexos pendientes</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fGetAnexosPendientes(int nIdParticipante, int numeroAnexos)
    {
        clsSupervision objSupervision = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            if (objSupervision.fGetAnexosPendientes(nIdParticipante, numeroAnexos) == false)
            {
                strCadena = "2";
            }
            else
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                strCadena += serializer.Serialize(objSupervision.laRegresaDatos).Normalize();
            }
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

    #region
    /// <summary>
    /// Método que obtiene los anexos integrados de la dependencia
    /// </summary>
    /// <param name="nIdParticipante">ID del participante</param>
    /// <param name="numeroAnexos">número de anexos integrados de la dependencia</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fGetAnexosIntegrados(int nIdParticipante, int numeroAnexos)
    {
        clsSupervision objSupervision = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            if (objSupervision.fGetAnexosIntegrados(nIdParticipante, numeroAnexos) == false)
            {
                strCadena = "2";
            }
            else
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                strCadena += serializer.Serialize(objSupervision.laRegresaDatos).Normalize();
            }
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
}