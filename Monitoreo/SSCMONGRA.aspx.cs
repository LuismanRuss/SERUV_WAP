using System;
using System.IO;
using System.Web;
using System.Web.UI;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Monitoreo_SSCMONGRA : System.Web.UI.Page
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
                    //string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    //hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                    hf_excluidos.Value = Request.QueryString["excluidos"];
                    hf_integrados.Value = Request.QueryString["integrados"];
                    hf_pendientes.Value = Request.QueryString["pendientes"];
                    hf_forma.Value = Request.QueryString["forma"];
                }
            }
        }

    }
}