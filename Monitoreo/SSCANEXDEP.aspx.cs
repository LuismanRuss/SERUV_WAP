using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nsSERUV;
using libFunciones;
using System.Web.Services;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Monitoreo_SSCANEXDEP : System.Web.UI.Page
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
                    hf_Opcion.Value = Request.QueryString["opcion"];
                    hf_idParticipante.Value = Request.QueryString["nIdParticipante"];
                    hf_dependencia.Value = Request.QueryString["dependencia"];
                    hf_proceso.Value = Request.QueryString["proceso"];
                    hf_numeroAnexos.Value = Request.QueryString["numeroAnexos"];
                }
            }
        }
    }
}