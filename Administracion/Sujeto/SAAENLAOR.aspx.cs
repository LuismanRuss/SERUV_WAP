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

public partial class SAAENLAOR : System.Web.UI.Page
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

    #region Metodo para Mostrar Tipos de Proceso

    /// <summary>
    /// Función que obtiene los procesos por usuario
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="nSujetoRecept">Identificador del sujeto receptor</param>
    /// <returns>Regresa los procesos</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListTipoProc(int nSujetoRecept)
    {
        string strCadena = string.Empty;
        string strAccion = "OBTENER_PROCESO_POR_USU_RECEPTOR";
        clsProceso objProceso = new clsProceso();

        if (objProceso.fObtener_ProcesoUsuario_SO(strAccion, nSujetoRecept))
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

    #region Metodo para Mostrar Lista Dependencia
    /// <summary>
    /// Función que obtiene las dependencias en las que esta inscrito el sujeto obligado
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="nIdProceso">Identificador del proceso</param>
    /// <param name="nUsuariolog">Identificador del usuario</param>
    /// <returns>Lista de dependencias</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListDepcia(int nIdProceso, int nUsuariolog)
    {
        string strAccion = "CONS_DEPCIA_PROCES_RECEPTOR";
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();

        if (objDepcia.fObtener_Dependencia_receptor(strAccion, nIdProceso, nUsuariolog))
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

    #region Metodo para ObtieneNombreSO
    /// <summary>
    /// Función que obtiene el nombre del sujeto obligado a partir del id usuario
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="nidUsuariolog">Identificador del usuario logueado</param>
    /// <returns>Nombre del sujeto obligado</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtieneNombreSO(int nidUsuariolog)
    {
        string strCadena = string.Empty;
        clsUsuario objSO = new clsUsuario();

        if (objSO.fObtener_Nombre_SO(nidUsuariolog))
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

    #region ObtenerDatos

    /// <summary>
    /// Función que obtiene los datos de los enlaces receptores de un sujeto receptor
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="nidUsuario">Identificador del usuario receptor</param>
    /// <param name="nidProceso">Identificador del proceso</param>
    /// <param name="nidDepcia">Identificador de la dependencia</param>
    /// <returns>Obtiene los enlaces operativos receptores</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtenerDatos(int nidUsuario, int nidProceso, int nidDepcia)
    {

        string cadena = string.Empty;

        clsUsuario us = new clsUsuario();
        if (us.fConsulta_Enlace_Op_Receptor(nidUsuario, nidProceso, nidDepcia))
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

    #region eliminarEnlace

    /// <summary>
    /// Función que obtiene el nombre del sujeto obligado a partir del id usuario
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="idEnlace">Identificador del Enlace receptor</param>
    /// <param name="idUsuario">Identificador del usuario receptor</param>
    /// <param name="idProceso">Identificador del proceso</param>
    /// <param name="idDepcia">Identificaor de la dependencia</param>
    /// <returns>Regresa un entero 0/1 según el resultado de la acción</returns>
    [WebMethod(EnableSession = true)]
    public static int eliminarEnlace(int idEnlace, int idUsuario, int idProceso, int idDepcia)
    {
        int intResultado = 0;
        string accion = "ELIMINAR";
        clsUsuario us = new clsUsuario();

        intResultado = us.pEliminar_UsuarioOpReceptor(accion, idEnlace, idUsuario, idProceso, idDepcia);
        return intResultado;
    }
    #endregion
}