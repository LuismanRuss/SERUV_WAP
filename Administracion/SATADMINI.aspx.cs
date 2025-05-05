using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using libFunciones;

public partial class SATADMINI : System.Web.UI.Page
{
    public string lsPerfiles = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        pCrear_Submenu();

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
            }
        }
    }


    protected void pCrear_Submenu()
    {
        string[] vecContext = Context.User.Identity.Name.ToString().Split('|');
        string strMenu = "";
        using (clsAcceso cAcceso = new clsAcceso(vecContext[1], clsAcceso.eGetInfo.Acceso))
        {
            if (cAcceso.EsAdmin)
            {
                strMenu += "<li><a id='tab1' href='#'>Usuarios</a></li>";
                strMenu += "<li><a id='tab3' href='#'>Guías</a></li>";
                strMenu += "<li><a id='tab4' href='#'>Notificaciones</a></li>";
                strMenu += "<li><a id='tab5' href='#'>Procesos</a></li>";
                strMenu += "<li><a id='tab2' href='#'>Perfiles</a></li>";
                strMenu += "<li><a id='tab10' href='#'>Configuración</a></li>";  
            }
            if (cAcceso.EsSujObligado)
            {
                strMenu += "<li><a id='tab6' href='#'>Anexos aplicables</a></li>";
                strMenu += "<li><a id='tab7' href='#'>Enlaces operativos</a></li>";
                strMenu += "<li><a id='tab8' href='#'>Configuración Notificaciones</a></li>";
            }
            if (cAcceso.EsSujReceptor)
            {
                strMenu += "<li><a id='tab9' href='#'>Enlaces operativos receptores</a></li>";
            }
            if (!cAcceso.EsSujObligado && cAcceso.EsEnlace)
            {
                strMenu += "<li><a id='tab6' href='#'>Anexos aplicables</a></li>";
            }
            ul_Menu.InnerHtml = strMenu;
            lsPerfiles = "'" + cAcceso.Perfiles + "'";
        }
    }

    /// <summary>
    /// Función que valida si el usuario logueado tiene notificaciones sin leer.
    /// Autor: Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nUsuario">Id del usuario logueado</param>
    /// <returns>Un entero indicando si tiene notificaciones sin leer o no (0 - No tiene, 1 - Si tiene)</returns>
    [WebMethod(EnableSession = true)]
    public static int fValidaNotificacione(int nUsuario) {
        int intResp = 0;
        try
        {
            clsNotificacion objNotificacion = new clsNotificacion();
            objNotificacion.idFKUsuDest = nUsuario;
            objNotificacion.strACCION = "TIENE_NOTIFICACION";
            intResp = objNotificacion.fValidaNotificaciones();
        }
        catch { 
        
        }
        return intResp;
    }
}