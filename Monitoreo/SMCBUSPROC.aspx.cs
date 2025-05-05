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

public partial class Monitoreo_SMCBUSPROC : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #region public static string pGetProcesosH(clsProceso objProceso)
    /// <summary>
    /// Procedimiento que regresara informacion de los procesos en donde ha participado un usuario
    /// Autor: Erik Jose Enriquez Carmona
    /// Ultima Actualizacion: 23 Abril de 2013
    /// </summary>
    /// <param name="objProceso"></param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pGetProcesosH(clsProceso objProceso)
    {
        string strDatosProcesos = string.Empty;
        if (objProceso != null)
        {
            objProceso.fGetProcesosH();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosProcesos = serializer.Serialize(objProceso.lstProcesosH);
            objProceso.Dispose();
        }
        return strDatosProcesos.Normalize();
    }
    #endregion
}