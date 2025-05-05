using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization; 
using libFunciones;
using nsSERUV;

public partial class Cierre_SCAINFCMP : System.Web.UI.Page
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

    #region public static string pGetDatosERC(clsProcesoER objProceso)
    /// <summary>
    /// Obtiene los apartados y anexos que deberá conformar la contraloría en una ER
    /// </summary>
    /// <param name="objProceso">Objeto Proceso</param>
    /// <returns>Objeto Proceso</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosERC(clsProcesoER objProceso)
    {
        string strDatosER = string.Empty;
        if (objProceso != null)
        {
            objProceso.pGetProcesosER();
            objProceso.intTieneProcesos = (objProceso.lstProcesos != null ? objProceso.lstProcesos.Count() : 0);
            var serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosER = serializer.Serialize(objProceso);
            objProceso.Dispose();
        }

        return strDatosER.Normalize();
    }
    #endregion
}