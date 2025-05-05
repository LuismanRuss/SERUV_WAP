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


public partial class Monitoreo_SMAAPERTU : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page_Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    #endregion

    #region SolicitarApertura
    /// <summary>
    /// Función que envia la solicitud de apertura.
    /// L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nProceso">Id del proceso</param>
    /// <param name="nDependencia">Número de la dependencia</param>
    /// <param name="sAsunto">Asunto del mensaje</param>
    /// <param name="sJustificacion">Justificación de la solicitud de apertura</param>
    /// <param name="nIdUsuarioRemitente">Id del usuario remitente</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int SolicitarApertura(int nProceso, int nDependencia, string sAsunto, string sJustificacion, int nIdUsuarioRemitente)
    {
        int intRespuesta = 0;
        try
        {
            clsNotificacion objNotifica = new clsNotificacion();
            //objNotifica.idFKUsuDest = nIdUsuarioDestinatario;
            objNotifica.nDependencia = nDependencia;
            objNotifica.idUsuRemit = nIdUsuarioRemitente;
            objNotifica.idProceso = nProceso;
            objNotifica.sAsunto = sAsunto;
            objNotifica.sMensaje = sJustificacion;
            objNotifica.strACCION = "SOLICITUD_APERTURA";
            intRespuesta = Convert.ToInt32(objNotifica.fGuardaMensaje());
        }
        catch (Exception Ex)
        {
            String Err = Ex.Message;
        }
        return intRespuesta;
    }
    #endregion
}