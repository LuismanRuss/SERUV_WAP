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


public partial class Registro_SCAENVIO : System.Web.UI.Page
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
                }
                //  hf_idUsuario.Value = "4"; 
            }
        }
    }

    [WebMethod]
    public static int Enviar(int idFKUsuDest, int idFKProceso, string sAsunto, string sMensaje, int idUsuRemit)
    {
        int intRespuesta = 0;
        try
        {
            clsNotificacion objNotifica = new clsNotificacion();
            objNotifica.idFKUsuDest = idFKUsuDest;
            objNotifica.idProceso = idFKProceso;
            objNotifica.sAsunto = sAsunto;
            objNotifica.sMensaje = sMensaje;
            objNotifica.idUsuRemit = idUsuRemit;
            objNotifica.strACCION = "ENVIAR_MENSAJE";
            intRespuesta = Convert.ToInt32(objNotifica.pEnviarMensaje());
        }
        catch (Exception Ex)
        {
            String Err = Ex.Message;
        }
        return intRespuesta;
    }

    [WebMethod(EnableSession = true)]
    public static string BuscaUsuario(string sCuenta)
    {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;
        int[] arrRespuesta = new int[5];
        try
        {
            //ARRRESPUESTA[0] - 0 NO SE EJECUTO EL QUERY, 1 SE EJECUTO EL QUERY
            //ARRRESPUESTA[1] - 0 NO EXISTE EL USUARIO, 1 SI EXISTE EL USUARIO
            arrRespuesta = objUsuario.fGetUsuario(sCuenta.ToLower());
            if (arrRespuesta[0] == 1) // SE REALIZÓ EL QUERY DE SQL
            {
                if (arrRespuesta[2] == 0) //EL USUARIO NO EXISTE EN LA BD
                {
                    if (arrRespuesta[4] == 1) // SE LOGRÓ LA CONEXIÓN DE ORACLE
                    {
                        if (arrRespuesta[1] == 1) // SE REALIZÓ EL QUERY DE ORACLE
                        {
                            if (arrRespuesta[3] == 1) //TRAE LOS DATOS DEL USUARIO
                            {
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
                            }
                            else
                            {
                                strCadena = "-3";
                            }
                        }
                        else
                        {
                            strCadena = "-2";
                            //strCadena = arrRespuesta[4];
                        }
                    }
                    else
                    {
                        strCadena = "-4";
                    }
                }
                else
                {
                    strCadena = "0";
                }
            }
            else
            {
                strCadena = "-1";
            }
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objUsuario.Dispose();
        }
        return strCadena.Normalize();
    }

    [WebMethod(EnableSession = true)]
    public static int fGuardarInformacion(int nDepcia, int nPuesto, string sNombre, string sApPaterno, string sApMaterno, string sCuenta,
            int nNumPersonal, string sCorreo, int nTper, int nCategoria, char cIndEmpleado, char cIndActivo, int nUsuario, string scheck)
    {
        clsUsuario objUsuario = new clsUsuario();
        int intRespuesta = 0;
        try
        {
            intRespuesta = Convert.ToInt32(objUsuario.fGuardarInformacion(nDepcia, nPuesto, sNombre, sApPaterno, sApMaterno, sCuenta, nNumPersonal, sCorreo, nTper,
                                        nCategoria, cIndEmpleado, cIndActivo, nUsuario, scheck));
        }
        catch (Exception Ex)
        {
            String Err = Ex.Message;
        }
        finally
        {
        }
        return intRespuesta;
    }

    [WebMethod(EnableSession = true)]
    public static int fActualizaDatosUsuario(int nidPerfil, string scheck)
    {
        int intRespuesta = 0;
        try
        {
            clsUsuario objUsuario = new clsUsuario();
            intRespuesta = Convert.ToInt32(objUsuario.fActualizaEdoAdmin(nidPerfil, scheck));
        }
        catch
        {

        }
        return intRespuesta;
    }

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

}