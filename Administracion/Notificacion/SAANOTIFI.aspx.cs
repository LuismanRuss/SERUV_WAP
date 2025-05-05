using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using libFunciones;
using nsSERUV;

public partial class Administracion_Proceso_SAANOTIFI : System.Web.UI.Page
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

    #region Método para Pintar datos en el Grid
    /// <summary>
    /// Autor: Edgar Morales González
    /// Objetivo:   Devolver los datos de las notificaciones del catalogo
    /// </summary>
    /// <param name="strACCION">Indica la acción que realizara el procedimiento almacenado</param>
    /// <returns>Devuelve una lista con los datos de las notificaciones para pintar el grid</returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(string strACCION)
    {
        clsNotificacion objNotificacion = new clsNotificacion();
        string strCadena = string.Empty;
        try
        {
            objNotificacion.fObtener_Notificaciones(strACCION);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objNotificacion.laNotificacion).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objProcER.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region Método para Desactivar una Notificación ( fModificaNotificacion )

    /// <summary>
    /// Autor: Edgar Morales González
    /// </summary>
    /// <param name="objNotificacion">Contiene la información pertinente para desactivar una notificación</param>
    /// <returns>devuelve una variable cuyo valor indica si la notificación fue modificada o no</returns>
    [WebMethod(EnableSession = true)]
    public static bool fModificaNotificacion(clsNotificacion objNotificacion)
    {
        bool blnResultado = false;

        if (objNotificacion.modifNotificacion(objNotificacion)) 
        {
            blnResultado = true;
        }
        else
        {
            blnResultado = false;
        }
        return blnResultado;
    }
    #endregion

}