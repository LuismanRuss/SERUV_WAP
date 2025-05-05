using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using libFunciones;
using nsSERUV;

public partial class Administracion_SACUSUARI : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page_Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
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
            }
        }
    }
    #endregion

    #region BuscarCuenta
    /// <summary>
    /// Función que devuelve los datos del usuario en caso de encontrarlo.
    /// L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="sCuenta">Cuenta del usuario</param>
    /// <returns>Una cadena con los datos del usuario en caso de encontrarla</returns>
    [WebMethod(EnableSession = true)]
    public static string BuscarCuenta(string sCuenta)
    {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;
        try
        {
            objUsuario.fBuscaCuenta(sCuenta);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objUsuario.Dispose();
        }

        return strCadena.Normalize();
    }
    #endregion

    #region MuestraPerfiles
    /// <summary>
    /// Función que devuelve la lista de los perfiles activos de la tabla APCSUPERVISOR
    /// L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con los perfiles activos</returns>
    [WebMethod(EnableSession = true)]
    public static string MuestraPerfiles() {
        clsPerfil objPerfil = new clsPerfil();
        string strCadena = string.Empty;
        try
        {
            objPerfil.fGetPerfiles();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPerfil.lstPerfiles);
        }
        catch {
            strCadena = string.Empty;
        }
        finally {
            objPerfil.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion

    #region MuestraPerfilAdministrador
    /// <summary>
    /// Función que regresa el perfil de administrador
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Cadena con los datos del perfil del administrador.</returns>
    [WebMethod(EnableSession = true)]
    public static string MuestraPerfilAdministrador() {
        clsPerfil objPerfil = new clsPerfil();
        string strCadena = string.Empty;
        try
        {
            objPerfil.fGetPerfilAdministrador();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPerfil.lstPerfiles);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally {
            objPerfil.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion

    #region BuscaUsuario
    /// <summary>
    /// Función que devuelve los datos del usuario en caso de encontrarlo.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="sCuenta">Cuenta del usuario</param>
    /// <returns>Una cadena con los datos del usuario en caso de encontrarla y en caso contrario un indicador</returns>
    [WebMethod(EnableSession = true)]
    public static string BuscaUsuario(string sCuenta) {
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
                    else {
                        strCadena = "-4";
                    }
                }
                else{
                    strCadena = "0";
                }
            }
            else {
                strCadena = "-1";
            }
        }
        catch (Exception ex)
        {
            strCadena = string.Empty;
        }
        finally {
            objUsuario.Dispose();
        }
        JavaScriptSerializer serializer2 = new JavaScriptSerializer();
        strCadena = serializer2.Serialize(new { Respuesta = strCadena, msj = objUsuario.strMensajeError });
        return strCadena.Normalize();
    }
    #endregion

    #region fGuardarInformacion
    /// <summary>
    /// Función que guarda la información del usuario.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nDepcia">Número de la dependencia</param>
    /// <param name="nPuesto">Número del puesto</param>
    /// <param name="sNombre">Nombre</param>
    /// <param name="sApPaterno">Apellido paterno</param>
    /// <param name="sApMaterno">Apellido materno</param>
    /// <param name="sCuenta">Cuenta del usuario</param>
    /// <param name="nNumPersonal">Número de personal</param>
    /// <param name="sCorreo">Correo</param>
    /// <param name="nTper">Número tipo de personal</param>
    /// <param name="nCategoria">Número de categoría</param>
    /// <param name="cIndEmpleado">Indicador de empleado</param>
    /// <param name="cIndActivo">Indicador de activo</param>
    /// <param name="nUsuario">Id del usuario que lo agrega</param>
    /// <param name="scheck">Indicador si el checkbox de administrador esta marcado o no</param>
    /// <returns>Un entero indicando si se realizo correctamente la operación o no</returns>
    [WebMethod(EnableSession = true)]
    public static int fGuardarInformacion(int nDepcia, int nPuesto, string sNombre, string sApPaterno, string sApMaterno, string sCuenta,
            int nNumPersonal, string sCorreo, int nTper, int nCategoria, char cIndEmpleado, char cIndActivo, int nUsuario, string sPerfiles)
    {
        clsUsuario objUsuario = new clsUsuario();
        int intRespuesta=0;
        try
        {
            intRespuesta = Convert.ToInt32(objUsuario.fGuardarInformacion(nDepcia, nPuesto, sNombre, sApPaterno, sApMaterno, sCuenta, nNumPersonal, sCorreo, nTper,
                                        nCategoria, cIndEmpleado, cIndActivo, nUsuario, sPerfiles));
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

    #region fActualizaDatosUsuario
    /// <summary>
    /// Función que actualiza los datos del usuario.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nUsuario">Id del usuario</param>
    /// <param name="scheck">Indicador si el check fue marcado o no</param>
    /// <returns>Entero</returns>
    [WebMethod(EnableSession = true)]
    public static int fActualizaDatosUsuario(int nUsuario,  string sPerfiles)
    {
        int intRespuesta = 0;
        try
        {
            clsUsuario objUsuario = new clsUsuario();
            intRespuesta = Convert.ToInt32(objUsuario.fActualizaEdoAdmin(nUsuario, sPerfiles));
        }
        catch { 
            
        }
        return intRespuesta;
    }
    #endregion
}