using nsSERUV;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Microsoft.Reporting.WebForms;

public partial class Reportes_SRLREPORT : System.Web.UI.Page
{
         protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                if (!Session.IsNewSession)
                {
                    string strWebApp = ConfigurationManager.AppSettings.Get("WebApp");
                    string[] strDBServer = ConfigurationManager.AppSettings.Get("DBServer").Split('|');
                    string strReportServer = "http://" + strDBServer[0] + "/ReportServer";
                    string strReportPath = "/SERUV";
                    string strViewerUser = ConfigurationManager.AppSettings.Get("ViewerUser");
                    string strViewerUserPwd = DES.funDES_FromBase64(ConfigurationManager.AppSettings.Get("ViewerUserPwd"));
                    string strRequest1 = "";
                    string strRequest2 = "";

                    switch (strWebApp)
                    {
                        case "ADWEB":
                            strReportServer = "http://SRVXADSQLD/ReportServer";
                            strReportPath += "/SERUV_DVLP/";                            
                            break;
                        case "DVLP":
                        case "TRNG":
                        case "PPROD":
                        case "PROV":
                            strReportPath += "_" + strWebApp + "/";
                            break;
                        case "PROD":
                        case "PROD2012":
                            strReportPath += "/";
                            //strReportPath += "_" + strWebApp + "/";
                            break;
                    }
                    ReportViewer1.ServerReport.ReportServerUrl = new Uri(strReportServer);
                    ReportViewer1.ServerReport.ReportServerCredentials = new Credencialesx2(strViewerUser, strViewerUserPwd, "");
                    //ReportViewer1.ProcessingMode = ProcessingMode.Remote;
                    ReportViewer1.ServerReport.Timeout = -1;
                    ReportViewer1.ShowParameterPrompts = false;
                    
                    string strReporte = Request.QueryString["op"];
                    switch (strReporte)
                    {
                        case "PERFILUSUARIO": //LISTA LOS USUARIOS POR PERFIL SELECCIONADO - SE MANDA A TRAER DESDE 'PERFILES -> VER USUARIOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAUSUPERFILSP";
                            hf_idPerfil.Value = Request.QueryString["IdItem"].ToString();
                            ReportParameter rpParam1 = new ReportParameter("idPerfil", hf_idPerfil.Value);
                            ReportViewer1.ServerReport.SetParameters(rpParam1);
                            break;

                        case "CED_PROCESO":  //CÉDULA DEL PROCESO, ESTE QUEDARÁ PARA AQUEL REPORTE SELECCIONADO - SE MANDA A TRAER DESDE 'PROCESOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RACEDPROCESO";
                            strRequest1 = Request.QueryString["idProceso"];
                            ReportParameter rpParam2 = new ReportParameter("idProceso", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam2);
                            break;

                        case "GUIAS": //DESPLIEGA LA CONFIGURACIÓN DE UNA GUÍA CON SUS APARTADOS Y ANEXOS EN ESTADO ACTIVO, SELECCIONADA - SE MANDA A TRAER DESDE 'GUIAS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAGUIASP";
                            strRequest1 = Request.QueryString["idGuia"];
                            ReportParameter rpParam3 = new ReportParameter("idGuiaER", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam3);
                            break;

                        case "ANEXOS": //DESPLIEGA LA CONFIGURACIÓN DE UN ANEXO EN ESTADO ACTIVO, SELECCIONADA - SE MANDA A TRAER DESDE 'ANEXOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAANEXOSP";
                            strRequest1 = Request.QueryString["idAnexos"];
                            ReportParameter rpParam4 = new ReportParameter("idAnexo", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam4);
                            break;

                        case "APARTADOS": //DESPLIEGA LOS ANEXOS QUE COMPONEN UN APARTADO EN ESTADO ACTIVO, SELECCIONADA - SE MANDA A TRAER DESDE 'APARTADOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAAPARTADOSP";
                            strRequest1 = Request.QueryString["idApartado"];
                            ReportParameter rpParam5 = new ReportParameter("idApatado", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam5);
                            break;

                        case "PROCESOS": //LISTA TODOS LOS PROCESOS ACTIVOS QUE SE ENCUENTREN EN EL SISTEMA - SE MANDA A TRAER DESDE 'REPORTES'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAPROCESOSP";
                            ReportViewer1.ShowParameterPrompts = true;
                            break;

                        case "PARTICIPANTES": //DESPLIEGA LOS PARTICIPANTES DE UN PROCESO SELECCIONADO - SE MANDA A TRAER DESDE 'PROCESOS -> DEPENDENCIAS/ENTIDADES'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAPARTICIPANTESP";
                            strRequest1 = Request.QueryString["idProceso"];
                            ReportParameter rpParam6 = new ReportParameter("idProceso", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam6);
                            break;

                        case "ANEXOSAPLICABLES": //DESPLIEGA RELACIÓN DE ANEXOS Y SUS JUSTIFICACIONES EN CASO DE SER EXCLUIDOS - SE MANDA A TRAER DESDE 'ADMINISTRACIÓN SUJETO OBLIGADO -> ANEXOS APLICABLES'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAANEXCLSP";
                            strRequest1 = Request.QueryString["idProceso"];
                            strRequest2 = Request.QueryString["cveDepcia"];
                            ReportParameter[] rpParam7 = new ReportParameter[2];
                            rpParam7[0] = new ReportParameter("idProceso", strRequest1);
                            rpParam7[1] = new ReportParameter("cveDepcia", strRequest2);
                            ReportViewer1.ServerReport.SetParameters(rpParam7);
                            break;

                        case "PERFILUSUARIOPROC": //LISTA LOS USUARIOS POR PERFIL SELECCIONADO - SE MANDA A TRAER DESDE 'PERFILES -> VER USUARIOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAPERFUSUARSP";
                            hf_idUsuario.Value = Request.QueryString["IdItem"].ToString();
                            ReportParameter rpParam8 = new ReportParameter("idUsuario", hf_idUsuario.Value);
                            ReportViewer1.ServerReport.SetParameters(rpParam8);
                            break;

                        case "ENLACESOPERATIV": //LISTA LOS USUARIOS POR PERFIL SELECCIONADO - SE MANDA A TRAER DESDE 'PERFILES -> VER USUARIOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAENLACOPERASP";
                            strRequest1 = Request.QueryString["idProceso"];
                            strRequest2 = Request.QueryString["cveDepcia"];
                            ReportParameter[] rpParam9 = new ReportParameter[2];
                            rpParam9[0] = new ReportParameter("idProceso", strRequest1);
                            rpParam9[1] = new ReportParameter("cveDepcia", strRequest2);
                            ReportViewer1.ServerReport.SetParameters(rpParam9);
                            break;

                        case "ENLACESOPERATIV_R": //LISTA LOS USUARIOS POR PERFIL SELECCIONADO - SE MANDA A TRAER DESDE 'PERFILES -> VER USUARIOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAENLAOPERECSP";
                            strRequest1 = Request.QueryString["idProceso"];
                            strRequest2 = Request.QueryString["cveDepcia"];
                            ReportParameter[] rpParam10 = new ReportParameter[2];
                            rpParam10[0] = new ReportParameter("idProceso", strRequest1);
                            rpParam10[1] = new ReportParameter("cveDepcia", strRequest2);
                            ReportViewer1.ServerReport.SetParameters(rpParam10);
                            break;

                        case "SUPERVISORDEPEND": //LISTA LOS USUARIOS POR PERFIL SELECCIONADO - SE MANDA A TRAER DESDE 'PERFILES -> VER USUARIOS'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RASUPERVDEPSP";
                            strRequest1 = Request.QueryString["IdItem"].ToString();
                            ReportParameter rpParam11 = new ReportParameter("idUsuario", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam11);
                            break;

                        case "BITACORA": //BITÁCORA DE SUPERVISIÓN - SE MANDA A TRAER DESDE 'SUPERVISIÓN/(DEPENDENCIA)/BITÁCORA/ -> REPORTE'
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RABITACORASP";
                            strRequest1 = Request.QueryString["idProceso"];
                            strRequest2 = Request.QueryString["cveDepcia"];
                            ReportParameter[] rpParam13 = new ReportParameter[2];
                            //rpParam13[0] = new ReportParameter("idSupervisor", idSupervisor);
                            rpParam13[0] = new ReportParameter("idProceso", strRequest1);
                            rpParam13[1] = new ReportParameter("cveDepcia", strRequest2);
                            ReportViewer1.ServerReport.SetParameters(rpParam13);
                            break;

                        case "SOLICITUD": //REPORTE DE LA SOLICITUD ENVIADA PARA REALIALIZAR UN PROCESO E-R - SE MANDA A TRAER DESDE EL MÓDULO SOLICITUD Y AL ENVIAR SOLICITUD
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RASOLICITSP";
                            strRequest1 = Request.QueryString["strscveSolProc"];
                            ReportParameter rpParam14 = new ReportParameter("cveSolicitud", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam14);
                            break;

                        case "SUPERVISORPROC": //REPORTE DE LOS PROCESOS ASIGNADOS A UN SUPERVISOR CG
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RASUPERPROC";
                            strRequest1 = Request.QueryString["IdItem"].ToString();
                            ReportParameter rpParam15 = new ReportParameter("idUsuario", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam15);
                            break;

                        case "SOLICITUDES": //REPORTE DE TODAS LAS SOLICITUDES DE INTERVENCIÓN, ENVIADAS PARA REALIALIZAR UN PROCESO E-R - SE MANDA A TRAER DESDE EL CATÁLOGO DE PROCESOS
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RASOLICITUDES";
                            break;

                        case "ANEXOSEXCL": // REPORTE DE ANEXOS EXCLUIDOS POR DEPENDENCIA
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAANEXEXCL";
                            strRequest1 = Request.QueryString["IdParticipante"].ToString();
                            ReportParameter rpParam16 = new ReportParameter("intIDPARTICIPANTE", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam16);
                            break;

                        case "ANEXOSINCLU": //REPORTE DE ANEXOS INCLUIDOS POR DEPENDENCIA
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAANEXINCLU";
                            strRequest1 = Request.QueryString["IdParticipante"].ToString();
                            ReportParameter rpParam17 = new ReportParameter("intIDPARTICIPANTE", strRequest1);
                            ReportViewer1.ServerReport.SetParameters(rpParam17);
                            break;

                        case "MOTIVOS": //REPORTE DE LOS MOTIVOS - SE MANDA A TRAER DESDE EL CATÁLOGO DE MOTIVOS
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RAMOTIVOS";
                            break;

                        case "TITULARES": //REPORTE DE TITULARES DE DEPENDENCIA - SE MANDA A TRAER DESDE EL CAMBIO DE TITULAR
                            ReportViewer1.ServerReport.ReportPath = strReportPath + "RATITULARES";
                            break;
                    }
                }
            }

        }
    }



[Serializable()]
public class Credencialesx2 : Microsoft.Reporting.WebForms.IReportServerCredentials
{
    string _userName;
    string _password;
    string _domain;

    public Credencialesx2(string userName, string password, string domain)
    {
        _userName = userName;
        _password = password;
        _domain = domain;
    }
    public System.Security.Principal.WindowsIdentity ImpersonationUser
    {
        get { return null; }
    }
    public System.Net.ICredentials NetworkCredentials
    {
        get { return new System.Net.NetworkCredential(_userName, _password, _domain); }
    }

    public bool GetFormsCredentials(out System.Net.Cookie authCookie, out string userName, out string password, out string authority)
    {
        userName = _userName;
        password = _password;
        authority = _domain;

        authCookie = new System.Net.Cookie(".ASPXAUTH", ".ASPXAUTH", "/", "Domain");
        return true;
    }
}
