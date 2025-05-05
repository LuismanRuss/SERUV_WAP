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

public partial class Registro_SCARESPON : System.Web.UI.Page
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

    #region fMensajeLeido() Nedgar
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