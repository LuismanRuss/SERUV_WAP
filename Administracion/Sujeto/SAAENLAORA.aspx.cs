using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using libFunciones;
using System.Web.Services;
using System.Web.Script.Serialization;
using nsSERUV;

public partial class SAAENLAORA : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {


                using (clsValidacion objValidacion = new clsValidacion())
                {                  
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                }               

                hf_intDependencia.Value = Request.QueryString["idDepcia"];
                hf_intProceso.Value = Request.QueryString["idProceso"];
            }
        }  
    }

    #region BuscaUsuario
    /// <summary>
    /// Función que busca una cuenta institucional
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="sCuenta">Cuenta</param>
    /// <returns>Datos del usuario buscado</returns>
    [WebMethod(EnableSession = true)]
    public static string BuscaUsuario(string sCuenta)
    {

        string cadena = string.Empty;
        int intRespuesta;       
        clsUsuario us = new clsUsuario();

        try
        {
            intRespuesta = us.fGetUsuarioEnlaceReceptor(sCuenta);
            if (intRespuesta == 1 || intRespuesta == 2)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();               
                cadena += serializer.Serialize(us.laRegresaDatos).Normalize();
            }
            else
            {             
                cadena += intRespuesta;
            }
        }
        catch
        {
            cadena = string.Empty;
        }
        JavaScriptSerializer serializer2 = new JavaScriptSerializer();
        cadena = serializer2.Serialize(new { Respuesta = cadena, msj = us.strMensajeError });
        return cadena.Normalize();
    }

    #endregion
     

    #region fGuardarInformacion
    /// <summary>
    /// Función guarda un nuevo usuario como enlace receptor
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="nDepcia">número de la dependencia del Sujeto obligado Receptor</param>
    /// <param name="nidDependencia">número de la dependencia del enlace receptor</param>
    /// <param name="nPuesto">número de puesto</param>
    /// <param name="sNombre">Nombre del enlace receptor</param>
    /// <param name="sApPaterno">Apellido paterno</param>
    /// <param name="sApMaterno">Apellido materno</param>
    /// <param name="sCuenta">Cuenta institucional</param>
    /// <param name="nNumPersonal">Numero de personal</param>
    /// <param name="sCorreo">Correo institucional</param>
    /// <param name="nTper">numero de tipo de personal</param>
    /// <param name="nCategoria">Numero de categoría</param>
    /// <param name="cIndEmpleado">Bandera S/N si es empleado o no</param>
    /// <param name="cIndActivo">Bandera de indicador de activo S/N</param>
    /// <param name="idSujetObligado">Identificador de sujeto obligado receptor</param>
    /// <param name="intIdProceso">Identificador del proceso del sujeto receptor</param>
    /// <param name="check">Bandera S/N indicador si es principal o no</param>
    /// <param name="nUsuario">Identificador del usuario sujeto obligado</param>
    /// <param name="sInstitucion">Institución a la que pertenece el enlace receptor</param>
    /// <param name="sCargo">Cargo del sujeto receptor</param>
    /// <returns>Datos del enlace receptor</returns>
    [WebMethod(EnableSession = true)]
    public static int fGuardarInformacion(int nDepcia, int nidDependencia, int nPuesto, string sNombre, string sApPaterno, string sApMaterno, string sCuenta, int nNumPersonal, string sCorreo, int nTper, int nCategoria, char cIndEmpleado, char cIndActivo, int idSujetObligado, int intIdProceso, string check, int nUsuario, string sInstitucion, string sCargo)

    {
        clsUsuario objUsuario = new clsUsuario();
        int intRespuesta = 0;
        try
        {
            intRespuesta = Convert.ToInt32(objUsuario.fGuardarInformacionReceptor(nDepcia, nidDependencia, nPuesto, sNombre, sApPaterno, sApMaterno, sCuenta, nNumPersonal, sCorreo, nTper, nCategoria, cIndEmpleado, cIndActivo, idSujetObligado, intIdProceso, check, nUsuario, sInstitucion, sCargo));

         
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
    #endregion
   

    #region modificarUsuario_EnlaceReceptor
    /// <summary>
    /// Función modifica un usuario como enlace receptor
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="idusuario">Identificador del usuario</param>
    /// <param name="check">Bandera S/N identifica si es principal o no</param>
    /// <param name="idSujetObligado">Identificador del sujeto receptor</param>
    /// <param name="nDepcia">número de la dependencia</param>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <param name="sNombre">Nombre del enlace receptor</param>
    /// <param name="sApPaterno">Apellido paterno</param>
    /// <param name="sApMaterno">Apellido materno</param>
    /// <param name="sCorreo">Correo institucional</param>
    /// <param name="sInstitucion">Institución</param>
    /// <param name="sCargo">Cargo</param>
    /// <returns>true ó falce según si se ejecuto correctamente</returns>
    [WebMethod(EnableSession = true)]
    public static string modificarUsuario_EnlaceReceptor(string idusuario, string check, int idSujetObligado, int nDepcia, int intIdProceso, string sNombre, string sApPaterno, string sApMaterno, string sCorreo, string sInstitucion, string sCargo)
    {
        string cadena = string.Empty;
        string accion = "MODIFICARENLACE";
        clsUsuario us = new clsUsuario();
        int idusu = int.Parse(idusuario);      
        try
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();          
            cadena += serializer.Serialize(us.pModificar_Usuario_Enlace_Receptor(accion, idusuario, check, idSujetObligado, nDepcia, intIdProceso, sNombre, sApPaterno, sApMaterno, sCorreo, sInstitucion, sCargo));

        }
        catch (Exception)
        {

            throw;
        }        
        return cadena.Normalize();
    }
    #endregion
}