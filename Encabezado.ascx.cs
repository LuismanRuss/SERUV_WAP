using System;
using System.Collections.Generic;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using nsSERUV;


public partial class Encabezado : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pCrear_Menu();
        }
    }


    protected void pCrear_Menu()
    {
        if (Session["sNombreUsr"] == null)
        {
            pCerrarSesion();
        }
        else
        {            
            string[] vecContext = Context.User.Identity.Name.ToString().Split('|');
            string strWebApp = ConfigurationManager.AppSettings.Get("WebApp");
            string strDSistema = "";
            string strMenu = "";

            switch (strWebApp)
            {
                case "ADWEB":
                    strDSistema += " [Pruebas]";
                    break;
                case "DVLP":
                    strDSistema += " [Desarrollo]";
                    break;
                case "TRNG":
                    strDSistema += " [Entrenamiento]";
                    break;
                case "PROV":
                    strDSistema += " [Entrega del Rector__]";
                    break;
                case "PROD":
                case "PROD2012":
                    break;
            }
            div_NombreSistema.InnerHtml += strDSistema;
            div_NombreSistema.Attributes["class"] = "nombre_sistema";

            using (clsAcceso cAcceso = new clsAcceso(vecContext[1], clsAcceso.eGetInfo.Acceso))
            {
                lbl_Usuario.Text = cAcceso.Nombre;
                if (cAcceso.EsAdmin || cAcceso.EsSujObligado || cAcceso.EsSujReceptor || cAcceso.EsEnlace)
                {
                    strMenu += "<li class='op-administracion'><a href='../Administracion/SATADMINI.aspx'>Administración <img id='ico_opcs' alt='Opción Administración' src='../images/ico-administracion.png' /></a></li>";
                }
                if (cAcceso.EsSujObligado || cAcceso.EsEnlace)
                {
                    strMenu += "<li class='op-registro'><a href='../Registro/SCTREGIST.aspx'>Registro <img id='ico_opcs' alt='Opción Registro' src='../images/ico-registro.png' /></a></li>";
                }
                if (cAcceso.EsSupervisor || cAcceso.EsSupCG || cAcceso.EsSupSAF || cAcceso.EsSujObligado || cAcceso.EsSujReceptor || cAcceso.EsEnlace || cAcceso.EsEnlaceR)
                {
                    strMenu += "<li class='op-supervision'><a href='../Monitoreo/SMTSUPMON.aspx'>Supervisión/Monitoreo <img id='ico_opcs' alt='Opción Monitoreo' src='../images/ico-supervision.png' /></a></li>";
                }
                //if (cAcceso.EsSujReceptor || cAcceso.EsEnlaceR) 
                //{
                //    strMenu += "<li class='op-avance'>Seguimiento <img id='ico_opcs' alt='Opción Avances' src='../images/ico-avances.png' /></li>";
                //}
                //if (cAcceso.EsSupervisor || cAcceso.EsSupCG || cAcceso.EsSupSAF)
                //{
                //    strMenu += "<li class='op-cierre'>Cierre proceso <img id='ico_opcs' alt='Opción Cierre Proceso' src='../images/ico-cierre-proceso.png' /></li>";
                //}           
                if(cAcceso.EsAdmin){
                    strMenu += "<li class='op-reportes'><a href='../Reportes/SRTREPORT.aspx'>Reportes <img id='ico_opcs' alt='Opción Reportes' src='../images/ico-reportes.png' /></a></li>";
                }
                
                strMenu += "<li class='op-informacion'><a href='../Informacion/SILINFORM.aspx'>Información <img id='ico_opcs' alt='Opción Informes' src='../images/ico-informacion.png' /></a></li>";
                
                if (cAcceso.EsSupCG)
                {
                    strMenu += "<li class='op-cierre'><a href='../Cierre/SCTCIESEG.aspx'>Cierre/Seguimiento<img id='ico_opcs' alt='Opción Cierre Proceso' src='../images/ico-cierre-proceso.png' /></a></li>";
                }
                if (cAcceso.EsSupJerarquico)
                {
                    strMenu += "<li class='op-solicitud'><a href='../Solicitud/SSTSOLICI.aspx'>Solicitud <img id='ico_opcs' alt='Opción solicitud de procesos entrega-recepción' src='../images/ico-solicitud.png' /></a></li>";
                }

                //strMenu += "<li class='op-solicitud'><a href='../Solicitud/SSTSOLICI.aspx'>Solicitud <img id='ico_opcs' alt='Opción solicitud de procesos entrega-recepción' src='../images/ico-solicitud.png' /></a></li>";
                ul_Menu.InnerHtml = strMenu;
            }           
        }
    }
    

    protected void imb_Salir_Click(object sender, ImageClickEventArgs e)
    {
        pCerrarSesion();
    }


    protected void pCerrarSesion()
    {
        if (Context.User.Identity.Name != null)
        {
            string[] vecContext = Context.User.Identity.Name.ToString().Split('|');

            using (clsDALSQL cDALSQL = new clsDALSQL(false))
            {
                ArrayList lstParametros = new ArrayList();
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@sACCION", "SESION_OUT"));
                lstParametros.Add(lSQL.CrearParametro("@nIDUSUARIO", vecContext[0]));
                lstParametros.Add(lSQL.CrearParametro("@nIDSESION", Convert.ToInt32(Session["nSesion"]), SqlDbType.Int, ParameterDirection.InputOutput));
                cDALSQL.ExecQuery("PA_ACCESO", lstParametros);
            }
        }
        Session.Clear();
        Session.Abandon();
        FormsAuthentication.SignOut();
        Response.Redirect("http://www.uv.mx/entrega-recepcion");
    }
}
