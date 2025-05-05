using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using libFunciones;
using nsSERUV;

public partial class Notificaciones_SNMNOTIFI : System.Web.UI.Page
{
    public string lsPerfiles = "";

    #region protected void Page_Load(object sender, EventArgs e)
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            String idProc = Request.QueryString["idProceso"];
            hf_idProcesoAnt.Value = idProc;

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
    #endregion

    /// <summary>
    /// Objetivo: Traer las notificaciones no leidas qe recibe el usuario
    /// </summary>
    /// <param name="idUsuario">ID del usuario que consultara sus notificaciones</param>
    /// <param name="strOPCION">Opción que se ejecutara del procedimiento almacenado</param>
    /// <returns></returns>
    [WebMethod]
    public static string Pinta_Grid(int idUsuario, string strOPCION)
    {
        clsNotificacion objNotifica = new clsNotificacion();        
        string strCadena = string.Empty;

        try
        {
            objNotifica.fGetNotificacion(idUsuario, strOPCION);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = 500000000;
            strCadena += serializer.Serialize(objNotifica.laNotificacion).Normalize();         
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objNotifica.Dispose();
        }
        return strCadena.Normalize();
    }

}
