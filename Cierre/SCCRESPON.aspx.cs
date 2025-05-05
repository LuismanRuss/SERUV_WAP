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

public partial class Cierre_SCCRESPON : System.Web.UI.Page
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
                //  hf_idUsuario.Value = "4"; 
            }
        }
    }

    #region EnviarRespuesta
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Guarda en la bd y envia la notificación correspondiente
    /// </summary>
    /// <param name="idFKUsuDest">ID del usuario a quien se enviara la notificación</param>
    /// <param name="idFKProceso">ID del proceso al cual hace referencia la notificación</param>
    /// <param name="sAsunto">Asunto del correo que se enviara</param>
    /// <param name="sMensaje">Cuerpo del mensaje para la notificación</param>
    /// <param name="idUsuRemit">ID del usuario que envia la notificación</param>
    /// <returns></returns>
    [WebMethod]
    public static int EnviarRespuesta(int idFKUsuDest, int idFKProceso, string sAsunto, string sMensaje, int idUsuRemit)
    {
        int intRespuesta = 0;
        try
        {
            clsNotificacion objNotifica = new clsNotificacion();
            objNotifica.idFKUsuDest = idFKUsuDest;
            objNotifica.idProceso = idFKProceso;
            objNotifica.sAsunto = sAsunto;
            objNotifica.sMensaje = sMensaje;
            objNotifica.idUsuRemit = idUsuRemit;
            objNotifica.strACCION = "ENVIAR_MENSAJE";
            intRespuesta = Convert.ToInt32(objNotifica.pEnviarMensaje());
        }
        catch (Exception Ex)
        {
            String Err = Ex.Message;
        }
        return intRespuesta;
    }
    #endregion

    #region fMensajeLeido() fMensajeLeido
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Cambiar el indicador leído del registro de la notificación que se esta consultando
    /// </summary>
    /// <param name="objNotificacion">Objeto que contiene datos acerca de la notificación que se esta consultando</param>
    /// <returns>booleano que indica si el indicador leido correspondiente a esa notificación fue modificado satisfactoriamente o no</returns>
    [WebMethod]
    public static bool fMensajeLeido(clsNotificacion objNotificacion)
    {
        bool blnResultado = false;
        try
        {
            if (objNotificacion.fMensajeLeido(objNotificacion))
            {
                blnResultado = true;
            }
            else
            {
                blnResultado = false;
            }
        }
        catch (Exception)
        {
        }
        return blnResultado;
    }
    #endregion
}