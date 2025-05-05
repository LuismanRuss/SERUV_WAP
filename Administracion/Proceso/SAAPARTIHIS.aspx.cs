using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Administracion_Proceso_SAAPARTIHIS : System.Web.UI.Page
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
    /// Método que regresa las dependencias que estan asignadas al proceso seleccionado
    /// </summary>
    /// <param name="nIdProceso">ID del proceso que se seleccionó en la forma del histórico de procesos</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int nIdProceso)
    {
        clsProcesoER objProcER = new clsProcesoER();
        string strCadena = string.Empty;
        try
        {
            objProcER.fGetPartXProcHist(nIdProceso);
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
}