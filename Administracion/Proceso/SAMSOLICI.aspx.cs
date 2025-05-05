using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_Proceso_SAMSOLICI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    #region Pinta_Grid
    /// <summary>
    /// Función que devuelve el listado de todas las solicitudes de intervención
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con el listado de las solicitudes.</returns>
    [WebMethod(EnableSession = true)]
    public static string Pinta_Grid() {
        string strCadena = string.Empty;
        try
        {
            clsSolicitud objSolicitud = new clsSolicitud();
            objSolicitud.strACCION = "SOLICITUDES";
            objSolicitud.fGetSolicitudes();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objSolicitud.laSolicitudProceso);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objSolicitud.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region ModificaEstado
    /// <summary>
    /// Función que modifica el estado de una Solicitud de Intervención
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="idSolicitud">id de la solicitud de intervención</param>
    /// <returns>Un entero indicando si se realizó o no la acción (0: No, 1: Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int ModificaEstado(int idSolicitud) {
        int intResp = 0;
        try {
            clsSolicitud objSoliticud = new clsSolicitud();
            objSoliticud.idSolProc = idSolicitud;
            objSoliticud.strACCION = "MODIFICA_ESTADO";
            intResp = objSoliticud.fModificaEstado();
            objSoliticud.Dispose();
        }
        catch { }
        finally {}
        return intResp;
    }
    #endregion
}