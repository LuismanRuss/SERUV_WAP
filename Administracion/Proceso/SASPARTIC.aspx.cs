using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nsSERUV;
using System.Web.Script.Serialization;
using System.Web.Services;
using libFunciones;

public partial class Administracion_Proceso_SASPARTIC : System.Web.UI.Page
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


    # region pPinta_Grid
    /// <summary>
    /// Función que obtiene las dependencias de un determinado proceso
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="nIdProceso">Identificador de proceso</param>
    /// <returns>Dependencias de un proceso</returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int nIdProceso)
    {
        clsProcesoER objProcER = new clsProcesoER();
        string strCadena = string.Empty;
        try
        {
            objProcER.fUsuaDepcia(nIdProceso);
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