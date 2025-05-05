using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nsSERUV;
using libFunciones;
using System.Web.Services;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Monitoreo_SSAABRPRO : System.Web.UI.Page
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
                    hf_nombreDep.Value = Request.QueryString["nombreDependencia"];
                    hf_nombreProc.Value = Request.QueryString["nombreProceso"];
                }
            }
        }
    }
}