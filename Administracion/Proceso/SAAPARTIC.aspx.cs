using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Administracion_Proceso_SAAPARTIC : System.Web.UI.Page
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
                    //idUsuario = int.Parse((objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString());
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                }
            }
        }
    }

    #region pPinta_Grid
    /// <summary>
    /// ESTE MÉTODO LLENA EL GRID DE PARTICIPANTES
    /// </summary>
    /// <param name="nIdProceso">ID del proceso que se seleccionó en la forma de procesos</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int nIdProceso)
    {
        clsProcesoER objProcER = new clsProcesoER();
        string strCadena = string.Empty;
        try
        {
            objProcER.fGetPartXProc(nIdProceso);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objProcER.laRegresaDatos).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objProcER.Dispose();
        }
        return strCadena;
    }

    #endregion

    #region fExcluirDep
    /// <summary>
    /// ESTE MÉTODO EXCLUYE UN PARTICIPANTE DEL PROCESO
    /// </summary>
    /// <param name="nIdParticipante">ID del participante que se quiere excluir</param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static int fExcluirDep(int nIdParticipante, int nIdUsuario)
    {
        clsParticipante objPart = new clsParticipante();
        int blnRespuesta = 0;
        try
        {
            blnRespuesta = Convert.ToInt32(objPart.fExcluirParticipante(nIdParticipante, nIdUsuario));
        }
        catch
        {
            throw;
        }
        finally
        {
            objPart.Dispose();
        }
        return Convert.ToInt32(blnRespuesta);
    }
    #endregion
}