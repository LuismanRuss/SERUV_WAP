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

public partial class SAAENLACE : System.Web.UI.Page
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
               //  hf_idUsuario.Value = "369";
                
            }
        }
    }

    #region Método para Mostrar Lista Dependencia

    /// <summary>
    /// Función que obtiene la lista de dependencias de acuerdo a un proceso y un usuario
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <param name="intUsuariolog">Identificador del usuario</param>
    /// <returns>Cadena de dependencias en formato json</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListDepcia(int intIdProceso, int intUsuariolog)
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();

        if (objDepcia.fObtener_Dependencia_receptor("CONS_DEPCIA_PROCES",intIdProceso, intUsuariolog))
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

    #region Método para ObtieneNombreSO
    /// <summary>
    /// Función que obtiene el nombre del sujeto obligado a partir del id usuario
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="idUsuariolog">Identificador del usuario</param>
    /// <returns>Nombre del sujeto obligado</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtieneNombreSO(int idUsuariolog)
    {
        string strCadena = string.Empty;
        clsUsuario objSO = new clsUsuario();

        if (objSO.fObtener_Nombre_SO(idUsuariolog))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objSO.lstUsuarios).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion  

    #region Método para Mostrar Tipos de Proceso
    /// <summary>
    /// Función que obtiene los procesos en los que se encuentra un usuario
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="intIdSujetoOb">Identificador del usuario sujeto obligado</param>
    /// <returns>Cadena en formato json que contiene todos los procesos </returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListTipoProc(int intIdSujetoOb)
    {
        string strCadena = string.Empty;
        string strAccion = "OBTENER_PROCESO_POR_USU_SO";
        clsProceso objProceso = new clsProceso();

        if (objProceso.fObtener_ProcesoUsuario_SO(strAccion, intIdSujetoOb))
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
    /// Función que obtiene los enlaces operativos de un sujeto obligado
    /// Autor: Ma. Guadalupe Dominguez Julián   
    /// </summary>
    /// <param name="idUsuario">Identificador de usuario</param>
    /// <param name="idProceso">Identificador de proceso</param>
    /// <param name="idDepcia">Identificador de la dependencia</param>
    /// <returns>Obtiene los enlaces opertivos por sujeto obligado, proceso y dependencia</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtenerDatos(int idUsuario,int idProceso, int idDepcia)
    {

        string cadena = string.Empty;
      
        clsUsuario us = new clsUsuario();
        if (us.pConsulta_UsuarioOp(idUsuario, idProceso, idDepcia))
        {
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
               // cadena = serializer.Serialize(us.pConsulta_UsuarioOp());
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

    #region eliminarEnlace
        /// <summary>
        /// Función que elimina un determinado enlace operativo
        /// Autor: Ma. Guadalupe Dominguez Julián    
        /// </summary>
        /// <param name="idEnlace">Identificador del enlace operativo</param>
        /// <param name="idUsuario">Identificador del sujeto obligado</param>
        /// <param name="idProceso">Identificador del proceso</param>
        /// <param name="idDepcia">Identificador de la dependencia</param>
        /// <returns>1 en el caso de realizar la acción satisfactoriamente de lo contrario regresa 0</returns>
        [WebMethod(EnableSession = true)]
        public static int eliminarEnlace(int idEnlace, int idUsuario, int idProceso, int idDepcia)
        {
            int intResultado = 0;
            string accion = "ELIMINAR";
            clsUsuario us = new clsUsuario();

            intResultado = us.pEliminar_UsuarioOp(accion, idEnlace, idUsuario, idProceso, idDepcia);
                return intResultado;
        }
      #endregion


}