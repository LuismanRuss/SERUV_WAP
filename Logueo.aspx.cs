using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using nsSERUV;

public partial class Logueo : System.Web.UI.Page
{
    String lsCuenta = "Cuenta institucional";
    String lsContrasenia = "12345.....";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pAgregarAtributosToTXTs();
            if (Request.QueryString.Count > 0)
            {
                if (Request.QueryString["Params"] != null && Request.QueryString["sResolucion"] != null)
                {
                    string[] vecRequest = Encrypt.fun_Desencriptar(Request.QueryString["Params"].ToString()).Split('|');
                    string sCuenta = vecRequest[0];
                    pValidar_Acceso(sCuenta, Request.QueryString["sResolucion"]);
                }
            }
        }
        else
        {
            txt_Cuenta.CssClass = "textbox";
        }
    }

    protected void btn_Aceptar_Click(object sender, EventArgs e)
    {
        spn_Msg.InnerText = "";
        txt_Cuenta.Text = txt_Cuenta.Text.Trim();
        txt_Contrasenia.Text = txt_Contrasenia.Text.Trim();

        if (txt_Cuenta.Text != string.Empty && txt_Cuenta.Text != "Cuenta institucional")
        {
            try
            {
                SERUV_WAP.wsADPrincipal.ServADClient oServClient = new SERUV_WAP.wsADPrincipal.ServADClient();
                if (oServClient.usuarioADValido(txt_Cuenta.Text, txt_Contrasenia.Text))
                {
                    pValidar_Acceso(txt_Cuenta.Text, txt_Resolucion.Text);
                }
                else
                {
                    spn_Msg.InnerText = "Usuario o contraseña incorrecta.";
                }
            }
            catch (Exception Ex)
            {
                try
                {
                    //SERUV_WAP.wsADSecundario.ServADClient oServClientSec = new SERUV_WAP.wsADSecundario.ServADClient();
                    //if (oServClientSec.usuarioADValido(txt_Cuenta.Text, txt_Contrasenia.Text))
                    //{
                    //    pValidar_Acceso(txt_Cuenta.Text, txt_Resolucion.Text);
                    //}
                    //else
                    //{
                    //    spn_Msg.InnerText = "Usuario o contraseña incorrecta.";
                    //}
                }
                catch
                {
                    spn_Msg.InnerText = "Intente loguearse nuevamente en unos segundos.";
                }
            }
        }
        else
        {
            spn_Msg.InnerText = "Indique su cuenta institucional.";
        }
        txt_Cuenta.Focus();
    }


    protected void pValidar_Acceso(string sCuenta, string sResolucion)
    {
        using (clsAcceso cAcceso = new clsAcceso(sCuenta, clsAcceso.eGetInfo.Logueo))
        {
            if (cAcceso.IdUsuario > 0)
            {
                if (cAcceso.EsUsuarioActivo)
                {
                    if (cAcceso.EsPerfilActivo)
                    {
                        FormsAuthentication.SetAuthCookie(cAcceso.IdUsuario.ToString() + "|" + sCuenta, false);
                        Response.Redirect("AccesoAutorizado.aspx?sResolucion=" + sResolucion, false);
                    }
                    else
                    {
                        spn_Msg.InnerText = "No tiene configurado ningún Proceso de Entrega-Recepción.";
                    }
                }
                else
                {
                    spn_Msg.InnerText = "Su cuenta de usuario está inhabilitada.";
                }
            }
            else
            {
                if (cAcceso.MsgError == "")
                {
                    spn_Msg.InnerText = "No tiene permiso para acceder al Sistema.";
                }
                else
                {
                    spn_Msg.InnerText = cAcceso.MsgError;
                }
            }
        }
    }


    protected void pAgregarAtributosToTXTs()
    {
        txt_Cuenta.Attributes.Add("onfocus", "if(this.value=='" + lsCuenta + "'){this.value='';this.className='textbox';}");
        txt_Cuenta.Attributes.Add("onblur", "if(this.value==''){this.value='" + lsCuenta + "';this.className='textboxBlur';}");
        txt_Cuenta.Attributes.Add("onfocusin", "select();");
        txt_Contrasenia.Attributes.Add("onfocus", "if(this.value=='" + lsContrasenia + "')this.value='';");
        txt_Contrasenia.Attributes.Add("onblur", "if(this.value=='')this.value='" + lsContrasenia + "';");
    }

}