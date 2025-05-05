using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using libFunciones;

public partial class Monitoreo_SMTSUPMON : System.Web.UI.Page
{
    public string lsPerfiles = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        string[] vecContext = Context.User.Identity.Name.ToString().Split('|');
        string strMenu = "";

        using (clsAcceso cAcceso = new clsAcceso(vecContext[1], clsAcceso.eGetInfo.Acceso))
        {
            if ((cAcceso.EsSujObligado || cAcceso.EsSujReceptor || cAcceso.EsEnlace || cAcceso.EsEnlaceR) && (cAcceso.EsSupervisor || cAcceso.EsSupCG || cAcceso.EsSupSAF))
            {
                strMenu += "<li><a id='tab1' href='#'>Sujeto obligado / Sujeto Receptor</a></li>";
                strMenu += "<li><a id='tab2' href='#'>Supervisores</a></li>";
            }
            else if (cAcceso.EsSupervisor || cAcceso.EsSupCG || cAcceso.EsSupSAF)
            {
                strMenu += "<li><a id='tab2' href='#'>Supervisores</a></li>";
            }
            else if (cAcceso.EsSujReceptor)
            {
                strMenu += "<li><a id='tab1' href='#'>Sujeto obligado / Sujeto Receptor</a></li>";
            }
            else if (cAcceso.EsSujObligado)
            {
                strMenu += "<li><a id='tab1' href='#'>Sujeto obligado / Sujeto Receptor</a></li>";
            }
            else if (cAcceso.EsEnlace)
            {
                strMenu += "<li><a id='tab1' href='#'>Sujeto obligado / Sujeto Receptor</a></li>";
            }
            else if (cAcceso.EsEnlaceR)
            {
                strMenu += "<li><a id='tab1' href='#'>Sujeto obligado / Sujeto Receptor</a></li>";
            }        
        
            ul_Menu.InnerHtml = strMenu;
            lsPerfiles = "'" + cAcceso.Perfiles + "'";
        }
    }

    [WebMethod]
    public static int fValidaNotificacione(int nUsuario)
    {
        int intResp = 0;
        try
        {
            clsNotificacion objNotificacion = new clsNotificacion();
            objNotificacion.idFKUsuDest = nUsuario;
            objNotificacion.strACCION = "TIENE_NOTIFICACION";
            intResp = objNotificacion.fValidaNotificaciones();
        }
        catch
        {

        }
        return intResp;
    }
}