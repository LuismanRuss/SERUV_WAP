using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using libFunciones;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_Sujeto_SCSNOTISO : System.Web.UI.Page
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


            }
        }
    }

    
    #region Metodo para Mostrar Lista Dependencia

    /// <summary>
    /// Función que obtiene la lista de dependencias de acuerdo a un proceso y un usuario
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <param name="intUsuariolog">Identificador del usuario</param>
    /// <returns>una cadena json con las dependencias</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListDepcia(int intIdProceso, int intUsuariolog)
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();
        string strAccion = "CONS_DEPCIA_PROCES_SO";
        if (objDepcia.fObtener_Dependencia(intIdProceso, intUsuariolog, strAccion))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region Metodo para Mostrar Tipos de Proceso
    /// <summary>
    /// Función para obtener la lista de procesos a los q pertenece un Sujeto obligado
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="intIdSujetoOb">Identificador del sujeto obligado</param>
    /// <returns>json con los procesos</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListTipoProc(int intIdSujetoOb)
    {
        string strCadena = string.Empty;
        string strAccion = "OBTENER_PROCESO_POR_USU";
        clsProceso objProceso = new clsProceso();

        if (objProceso.fObtener_ProcesoUsuario(strAccion, intIdSujetoOb))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objProceso.laTipoProceso).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region ObtenerDatos
    /// <summary>
    /// función que obtiene el sujeto obligado y sus respectivos enlaces operativos
    /// Autor: Ma. Guadalupe Dominguez Julián
    /// </summary>
    /// <param name="nidSujeto">Identificador del sujeto obligado</param>
    /// <param name="nidProceso">Identificador del Proceso</param>
    /// <param name="nidDepcia">Identificador de la dependencia</param>
    /// <param name="nidUsuario">Identificador del usuario q se loguea</param>
    /// <returns>regresa json con los datos de sujeto obligado y sus enlaces operativos</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtenerDatos(int nidSujeto, int nidProceso, int nidDepcia, int nidUsuario)
    {

        string cadena = string.Empty;

        clsUsuario us = new clsUsuario();
        if (us.pConsulta_Enlaces_por_Sujeto_O(nidSujeto, nidProceso, nidDepcia, nidUsuario))
        {
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();               
                cadena += serializer.Serialize(us.lstUsuarios).Normalize();
            }
            catch (Exception)
            {

                throw;
            }
        }
        return cadena.Normalize();
    }
    #endregion

    #region pActualizaAplica
    /// <summary>
    /// Procedimiento que modifica el estado aplica para enviar notificaciones tanto a enlaces operativos y sujeto obligado 
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="nIdProceso">Identificador del proceso</param>
    /// <param name="nIdDepcia">Identificador de la dependencia</param>
    /// <param name="nIdUsuario">Identificador del usuario</param>
    /// <param name="nIdPerfil">Identificador del perfil</param>
    /// <param name="cIdAplica">Caracter q identifica si aplica S/N</param>
    /// <param name="nIdUsuModif">Identificador del usuario que está realizando los cambios</param>
    /// <returns>Regresa un json con la información actualizada</returns>
    [WebMethod(EnableSession = true)]
    public static string pActualizaAplica(int nIdProceso, int nIdDepcia, int nIdUsuario, int nIdPerfil, char cIdAplica, int nIdUsuModif)
    {

        string cadena = string.Empty;
        string accion = "ACTUALIZA_APLICA_NOTIF";
        clsUsuario us = new clsUsuario();
        int idusu = nIdUsuario;        
        try
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();            
            cadena += serializer.Serialize(us.pActualiza_aplica_notifica(accion, nIdProceso, nIdDepcia, nIdUsuario, nIdPerfil, cIdAplica, nIdUsuModif));

        }
        catch (Exception)
        {

            throw;
        }
      
        return cadena.Normalize();
    }
    #endregion
}