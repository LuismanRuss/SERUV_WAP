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

public partial class Cierre_SCCENVIO : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    // Variables que vendrán por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                }
                
            }
        }
    }
    #region EnviarCorreo
    /// <summary>
    /// 
    /// Objetivo: Enviar una notificación sin necesidad de alguna acción, a uno o varios destinatarios
    /// Autor: Bárbara Vargas vera
    /// </summary>
    [WebMethod(EnableSession = true)]
    public static int EnviarCorreo(string correos, string recomendacion, int idUsuario, string arregloUsuarios, string asunto)
    {
        int nRespuesta = 0;
        try
        {
            clsNotifica objNotifica = new clsNotifica();
            nRespuesta = objNotifica.fEnviaCorreoUsuario(recomendacion, idUsuario, arregloUsuarios, asunto);
        }
        catch (Exception)
        {
            throw;
        }
        return nRespuesta;
    }
    #endregion

}