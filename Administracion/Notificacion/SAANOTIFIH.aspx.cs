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

public partial class Administracion_Notificacion_SAANOTIFIH : System.Web.UI.Page
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

    #region Método para Insertar una Notificación
    /// <summary>
    ///     Autor: Edgar Morales González
    ///     Objetivo:  Inserta una nueva notificación en la base de datos
    /// </summary>
    /// <param name="objNotificacion">Objeto que contiene toda la información necesaria para dar de alta una notificación</param>
    /// <returns>Devuelve una valor que indica si la acción se realizó correctamente o nó</returns>
    [WebMethod(EnableSession = true)]
    public static bool insertaNotificacion(clsNotificacion objNotificacion)
    {
        bool blnResultado = false;

        if (objNotificacion.fCreaNotificacion(objNotificacion))
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



    #region Obtener datos de las notificaciones para modificar
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Regresar la información de la notificación que se modificara
    /// </summary>
    /// <param name="idNotifica">Id de la notificación que se va a modificar</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string regresaNotificacion(int idNotifica)
    {
        string strCadena = string.Empty;
        var objNotificacion = new clsNotificacion();
        try
        {
            objNotificacion.fGetNotificacionProc(idNotifica);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            
            strCadena += serializer.Serialize(objNotificacion.laNotificacion).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objUsuario.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion


    #region fActualizaNotificac
    /// <summary>
    /// Autor:  Edgar Morales González
 ///    Objetivo: envia los datos para que se actualice la notificación indicada
 /// </summary>
 /// <param name="objNotificacion">Contiene los datos de la notificación que se va a actualizar</param>
 /// <returns>devuelve un valor que indica si la notificación se actualizó correctamente</returns>
    [WebMethod(EnableSession = true)]
    public static bool fActualizaNotificac(clsNotificacion objNotificacion)
    {
        bool blnResultado = false;

        if (objNotificacion.fActualizaNotifica(objNotificacion))
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