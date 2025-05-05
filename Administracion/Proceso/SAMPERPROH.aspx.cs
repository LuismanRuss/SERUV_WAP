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

public partial class Administracion_Proceso_SAMPERPROH : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page Load
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

    #region MuestraPerfiles
    /// <summary>
    /// Función que devuelve el listado de perfiles.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <returns>Regresa una cadena con los perfiles asignados al usuario dentro del proceso</returns>
    [WebMethod(EnableSession = true)]
    public static string MuestraPerfiles()
    {
        clsPerfil objPerfil = new clsPerfil();
        string strCadena = string.Empty;
        try
        {
            objPerfil.fGetPerfiles();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objPerfil.lstPerfiles);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objPerfil.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion

    #region fActualizaDatosUsuario
    /*
    /// <summary>
    /// Función que actualiza el perfil de un usuario al momento de marcar un checkbox
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nidUsuario">Id del Usuario</param>
    /// <param name="nidProceso">Id del proceso</param>
    /// <param name="nPerfil">Id del perfil</param>
    /// <param name="sCheckado">Indicador si el checkbox fue marcado o no (S - Marcado, N - No marcado)</param>
    /// <returns>Un entero indicando si se realizó correctamente la actualización (0 - No se realizo, 1 - Correcto)</returns>
    [WebMethod(EnableSession = true)]
    public static int fActualizaDatosUsuario(int nidUsuario, int nidProceso, int nPerfil, string sCheckado)
    {
        int intRespuesta = 0;
        try
        {
            clsUsuario objUsuario = new clsUsuario();
            intRespuesta = Convert.ToInt32(objUsuario.fActualizaPerfilUsuario(nidUsuario, nidProceso, nPerfil, sCheckado));
        }
        catch
        {
        }
        return intRespuesta;
    }
    */
    #endregion

    #region fActualizaDatosUsuario
    /// <summary>
    /// Función que actualiza los datos del usuario.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nidUsuario">Id del usuario</param>
    /// <param name="nidProceso">Id del proceso</param>
    /// <param name="sPerfiles">cadena con los perfiles</param>
    /// <returns>Un entero indicando si se realizó correctamente la actualización (0 - No se realizo, 1 - Correcto)</returns>
    [WebMethod(EnableSession = true)]
    public static int fActualizaDatosUsuario(int nidUsuario, int nidProceso, string sPerfiles)
    {
        int intRespuesta = 0;
        try
        {
            clsUsuario objUsuario = new clsUsuario();
            intRespuesta = Convert.ToInt32(objUsuario.fActualizaPerfilUsuario(nidUsuario, nidProceso, sPerfiles));
        }
        catch
        {
        }
        return intRespuesta;
    }
    #endregion

    #region fGetPartXUsu
    /// <summary>
    /// Función que valida si el usuario se encuentra asignado a alguna dependencia como sujeto receptor o sujeto obligado.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nIdUsuario">Id del usuario</param>
    /// <param name="sIndicador">Indicador para el tipo de sujeto (Obligado o Receptor)</param>
    /// <returns>Una cadena con la información a los procesos que esta asignado el usuario</returns>
    [WebMethod(EnableSession = true)]
    public static string fGetPartXUsu(int nIdUsuario, string sIndicador)
    {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;
        try
        {
            objUsuario.fGet_Part_X_Perfil_Usu(nIdUsuario, sIndicador);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
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
    #endregion

    #region fDeshabilitaSujeto
    /// <summary>
    /// Funcion que deshabilita los perfiles de sujeto obligado o receptor del proceso que esté asignado.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="sParticipantes">Participantes a los que esta asigando</param>
    /// <param name="sIndSujeto">Indicador para el tipo de sujeto (Obligado o Receptor)</param>
    /// <param name="nUsuario">Id del usuario</param>
    /// <returns>Un entero indicando si se realizó correctamente la actualización (0 - No se realizo, 1 - Correcto)</returns>
    [WebMethod(EnableSession = true)]
    public static int fDeshabilitaSujeto(string sParticipantes, string sIndSujeto, int nUsuario)
    {
        int intRespuesta = 0;
        try
        {
            clsUsuario objUsuario = new clsUsuario();
            intRespuesta = Convert.ToInt32(objUsuario.fDeshabilitasujeto(sParticipantes, sIndSujeto, nUsuario));
        }
        catch {
            throw;
        }
        return intRespuesta;
    }
    #endregion
}