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

public partial class Administracion_Configuracion_SAACONFNOT : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
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


    #region ConfiguraNot
    /// <summary>
    /// Autor:  Edgar Morales González
    /// Objetivo:   Guardar el estado de la configuración elegida para ver si se activan o desactivan las notificaciones del sistema
    /// </summary>
    /// <param name="status">Indica si las notificaciones serán activadas o desactivadas</param>
    /// <param name="idUsuario">ID del usuario que activa o desactiva las notificaciones</param>
    /// <returns>Devuelve un valor que indica si se realizó o no la acción</returns>
        [WebMethod(EnableSession = true)]
    public static bool ConfiguraNot(char status, int idUsuario)
    {
        bool blnRespuesta = false;

        try
        {
            clsNotificacion objNotifica = new clsNotificacion();
            if (objNotifica.fConfigNotificaciones(status, idUsuario))
            {
                blnRespuesta = true;
            }
            else
            {
                blnRespuesta = false;
            }
            return blnRespuesta;
        }
        catch { }
        return blnRespuesta;
    }
    #endregion

        #region GetConfiguraNot
        /// <summary>
    /// Autor:  Edgar Morales González
    /// Objetivo: Obtener el estado de la configuración de las notificaciones del sistema sERUV
    /// </summary>
    /// <returns>Regresa la información de la cual se obtiene el estado de la configuración de las notificaciones del sistema SERUV</returns>
    [WebMethod(EnableSession = true)]
    public static string GetConfiguraNot()
    {
        string strCadena = string.Empty;
        var objNotificacion = new clsNotificacion();
        try
        {
            objNotificacion.fGetConfigNot();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objNotificacion.laNotificacion).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
        }
        return strCadena.Normalize();
    }
        #endregion
}