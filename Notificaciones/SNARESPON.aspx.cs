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

public partial class Notificaciones_SNARESPON : System.Web.UI.Page
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

   
    /// <summary>
    /// Objetivo:   enviar una notificación a un usuario, como respuesta a un mensaje asociado a un proceso
    /// </summary>
    /// <param name="idFKUsuDest"> ID del usuario destinatario</param>
    /// <param name="idFKProceso">ID del proceso respecto al cual se refiere la notificación</param>
    /// <param name="sAsunto">Asunto del mensaje</param>
    /// <param name="sMensaje">cuerpo del mensaje</param>
    /// <param name="idUsuRemit">ID del usuario que envia el mensaje</param>
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

    /// <summary>
    /// Autor:  Edgar Morales González
    /// Objetivo:   Cambiar el estatus de un mensaje, cuando este es leido
    /// </summary>
    /// <param name="objNotificacion"> Contiene la información necesaria para poder cambiar el estatus de una notificación</param>
    /// <returns></returns>
    #region fMensajeLeido() 
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