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

public partial class Notificaciones_SNMNOTIFIH : System.Web.UI.Page
{
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


    /// <summary>
    ///     Objetivo:   Metodo que regresa la información de las notificaciones ya leidas
    /// </summary>
    /// <param name="idUsuario">ID del usuario que consultara las notificaciones</param>
    /// <param name="strOPCION">Indica que opcion ejecutara el procedimiento almacenado</param>
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