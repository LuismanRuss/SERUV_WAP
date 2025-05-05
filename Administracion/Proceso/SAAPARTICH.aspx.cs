using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using nsSERUV;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Administracion_Proceso_SAAPARTICH : System.Web.UI.Page
{
    int idUsuario = 0;

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
                    idUsuario = int.Parse((objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString());
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                }
            }
        }
    }


    #region pPinta_Grid
    /// <summary>
    /// MÉTODO QUE ME REGRESA LAS DEPENDENCIAS QUE NO ESTÁN ASIGNADAS EN UN PROCESO ACTIVO Y ABIERTO
    /// </summary>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid()
    {
        clsParticipante objPart = new clsParticipante();
        string strCadena = string.Empty;
        try
        {
            objPart.getParticipantesSinProceso();
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


    #region fIncluirDep
    /// <summary>
    ///  MÉTODO QUE GUARDA LAS DEPENDENCIAS
    /// </summary>
    /// <param name="sSeleccionadas"></param>
    /// <param name="nIdProceso">ID del proceso al cual se le agregará dependencias</param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static int fIncluirDep(string sSeleccionadas, int nIdProceso, int nIdUsuario)
    {
        Administracion_Proceso_SAAPARTICH obj = new Administracion_Proceso_SAAPARTICH();
        clsParticipante objPart = new clsParticipante();
        int nRespuesta = 0;  
        try
        {
            nRespuesta = Convert.ToInt32(objPart.fIncluirDependencias(sSeleccionadas, nIdUsuario, nIdProceso));
        }
        catch
        {
            nRespuesta = 0;
        }
        finally
        {
            objPart.Dispose();
        }
        return nRespuesta;
    }
    #endregion
}