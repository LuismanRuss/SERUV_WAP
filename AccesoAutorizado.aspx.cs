using System;
using System.Collections.Generic;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using nsSERUV;


/// <summary>
///        Objetivo :  Registrar la sesión del usuario y determinar el menú de inicio que se le mostrará de acuerdo a sus permisos.
///         Versión :  1.0
///           Autor :  MTI José Aroldo Alfaro Ávila
///  Fecha Creación :  22/ABR/2013
///  
/// Fecha Ult. Rev. :  23/ABR/2013
/// </summary>
public partial class AccesoAutorizado : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pRegistrarSesion_Redirect();
        }
    }

    protected void pRegistrarSesion_Redirect()
    {
        string[] vecContext = Context.User.Identity.Name.ToString().Split('|');
        string strResolucion = Request.QueryString["sResolucion"].ToString();
        string strPagina = string.Empty;

        using (clsAcceso cAcceso = new clsAcceso(vecContext[1], clsAcceso.eGetInfo.Acceso))
        {
            using (clsCliente cCliente = new clsCliente(this))
            {
                using (clsDALSQL cDALSQL = new clsDALSQL(false))
                {
                    ArrayList lstParametros = new ArrayList();
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@sACCION", "SESION"));
                    lstParametros.Add(lSQL.CrearParametro("@nIDUSUARIO", cAcceso.IdUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@sCUENTA", cAcceso.Cuenta));
                    lstParametros.Add(lSQL.CrearParametro("@sPERMISOS", cAcceso.Permisos));
                    lstParametros.Add(lSQL.CrearParametro("@sIP", cCliente.IP));
                    lstParametros.Add(lSQL.CrearParametro("@sNAVEGADOR", cCliente.Browser));
                    lstParametros.Add(lSQL.CrearParametro("@sTIPONAV", cCliente.BrowserType));
                    lstParametros.Add(lSQL.CrearParametro("@sVERSIONNAV", cCliente.BrowserVersion));
                    lstParametros.Add(lSQL.CrearParametro("@sPLATAFORMA", cCliente.BrowserPlatform));
                    lstParametros.Add(lSQL.CrearParametro("@sRESOLUCION", strResolucion));
                    lstParametros.Add(lSQL.CrearParametro("@nIDSESION", 0, SqlDbType.Int, ParameterDirection.Output));
                    if (cDALSQL.ExecQuery_OUT("PA_ACCESO", lstParametros))
                    {
                        ArrayList arrOUT = cDALSQL.Get_aOutput();
                        Session["nSesion"] = arrOUT[0].ToString();
                    }
                }
                Session["sNombreUsr"] = cAcceso.Nombre;
                Session["sPerfiles"] = cAcceso.Perfiles;
                if (cAcceso.EsAdmin || cAcceso.EsSujObligado || cAcceso.EsSujReceptor)
                {
                    strPagina = "administracion/satadmini.aspx";
                }
                else if (cAcceso.EsSupervisor || cAcceso.EsSupCG || cAcceso.EsSupSAF)
                {
                    strPagina = "monitoreo/smtsupmon.aspx";
                }
                else if (cAcceso.EsEnlace || cAcceso.EsEnlaceR)
                {
                    strPagina = "registro/sctregist.aspx";
                }
                else if (cAcceso.EsSupJerarquico)
                {
                    strPagina = "Solicitud/SSTSOLICI.aspx";
                }
            }
        }
        Response.Redirect(strPagina, true);
    }

}