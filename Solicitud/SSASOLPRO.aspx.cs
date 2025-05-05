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


public partial class Solicitud_SSASOLPRO : System.Web.UI.Page
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
                    //hf_idUsuario.Value = "4";

                    // Variables que vendran por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                    
                }

                string[] vecContext = Context.User.Identity.Name.ToString().Split('|');
                using (clsAcceso objAcceso= new clsAcceso(vecContext[1], clsAcceso.eGetInfo.Acceso)){
                    if (objAcceso.EsAdmin) {
                        hf_esAdministrador.Value = "S";
                    }
                }
            }
        }

    }

    //#region Método para Mostrar ListaPuesto
    ///// <summary>
    ///// Función que Obtiene la Lista de Puestos de la Base de datos
    ///// Autor: Daniel Ramírez Hernández
    ///// </summary>
    ///// <param name="cuenta"></param>
    ///// <returns>Cadena en formato JSON con la Lista de Puestos</returns>
    //[WebMethod(EnableSession = true)]
    //public static string DibujaListPuesto2()
    //{
    //    string strCadena = string.Empty;
    //    clsPuesto objPuesto = new clsPuesto();

    //    if (objPuesto.fObtener_PuestoER())
    //    {
    //        JavaScriptSerializer serializer = new JavaScriptSerializer();
    //        strCadena += serializer.Serialize(objPuesto.laPuesto).Normalize();
    //    }
    //    else
    //    {
    //        strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
    //    }
    //    return strCadena.Normalize();
    //}

    //#endregion

    #region Método para Mostrar ListaPuesto2
    /// <summary>
    /// Función que Obtiene la Lista de Puestos de la Base de datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="cuenta"></param>
    /// <returns>Cadena en formato JSON con la Lista de Puestos</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListPuesto(int idUsuario)
    {
        string strCadena = string.Empty;
        clsPuesto objPuesto = new clsPuesto();

        //if (objPuesto.fObtener_PuestoER())
        if (objPuesto.fObtener_PuestoXDependencia(idUsuario))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objPuesto.laPuesto).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }

    #endregion

    //#region Método para Mostrar Lista Dependencia
    ///// <summary>
    ///// Función que Obtiene la Lista de Dependencia de la Base de Datos
    ///// Autor: Daniel Ramírez Hernández
    ///// </summary>
    ///// <param name="cuenta">Id del puesto</param>
    ///// <returns>Cadena en formato JSON con los datos del Puesto</returns>
    //[WebMethod(EnableSession = true)]
    //public static string DibujaListDepcia2(int nPuesto)
    //{
    //    string strCadena = string.Empty;
    //    clsDepcia objDepcia = new clsDepcia();

    //    if (objDepcia.fObtener_DependenciaPER(nPuesto))
    //    {
    //        JavaScriptSerializer serializer = new JavaScriptSerializer();
    //        strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
    //    }
    //    else
    //    {
    //        strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
    //    }
    //    return strCadena.Normalize();
    //}

    //#endregion

    #region Método para Mostrar Lista Dependencia
    /// <summary>
    /// Función que Obtiene la Lista de Dependencia de la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="cuenta">Id del puesto</param>
    /// <returns>Cadena en formato JSON con los datos del Puesto</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListDepcia(int nPuesto, int idUsuario)
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();

        //if (objDepcia.fObtener_DependenciaPER(nPuesto))
        if (objDepcia.fObtenerDependenciasSolicitud(nPuesto, idUsuario))
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

    #region Método para Mostrar Tipos de Proceso
    /// <summary>
    /// Función que Obtiene la Lista de Tipos de Proceso de la BD
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="cuenta">Accion a realizar en la BD</param>
    /// <returns>Cadena en formato JSON</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListTipoProc(string strACCION
        , string strACCIONMot
        )
    {
        string strCadena = string.Empty;
        clsProceso objProceso = new clsProceso();
        clsMotivo objMotivo = new clsMotivo();
        try
        {
            objProceso.fObtener_TipoProceso(strACCION);
            objMotivo.fObtener_MotivoProceso(strACCIONMot);
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            // strCadena += jsSerializer.Serialize(objProceso.laTipoProceso).Normalize();
            strCadena += "{'datos':[" + jsSerializer.Serialize(objProceso.laTipoProceso).Normalize() + "," + jsSerializer.Serialize(objMotivo.laMotivoProceso).Normalize() + "]}";

        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
        }
        return strCadena;
    }
    #endregion

    #region Método para Buscar los Datos del Titular de una Dependencia
    /// <summary>
    /// Función que Busca los Datos del Titular de una Dependencia
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="cuenta">Objeto de Datos del Sujeto Obligado</param>
    /// <returns>Cadena en formato JSON</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosTitular(clsUsuario objSujetobligado)
    {
        string strCadena = string.Empty;

        if (objSujetobligado.pGetDatosTitularDepcia())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena = serializer.Serialize(objSujetobligado);
            objSujetobligado.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Método para Buscar los Datos del Sujeto Receptor en SERUV/ORACLE
    /// <summary>
    /// Función que Busca los Datos del usuario y obtiene el perfil de superior jerárquico
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="cuenta">Cuenta del Usuario</param>
    /// <returns>Cadena en formato JSON con los datos del Usuario</returns>
    [WebMethod(EnableSession = true)]
    public static string BuscaUsuario(string sCuenta, string sPerfil)
    {

        string cadena = string.Empty;
        int intRespuesta;
        //string accion = "BUSCAR";
        clsUsuario us = new clsUsuario();

        try
        {
            //intRespuesta = us.fGetUsuarioEnlaceReceptor(sCuenta.ToLower());
            intRespuesta = us.fGetUsuarioReceptor(sCuenta.ToLower(), sPerfil);
            if (intRespuesta == 1 || intRespuesta == 2)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                // cadena = serializer.Serialize(us.pConsulta_UsuarioOp());
                cadena += serializer.Serialize(us.laRegresaDatos).Normalize();
            }
            else
            {
                //if (intRespuesta==0)
                //{
                //    cadena = "Ha ocurrido un error en la base de datos";
                //}
                //else
                //{
                //    if (intRespuesta == -1 || intRespuesta == -2)
                //    {
                //        cadena = "El usuario no existe favor de solicitar su registro";
                //    }

                //}
                if (us.strMensajeError == ""){
                    cadena += intRespuesta;
                }
                else
                {
                    cadena += us.strMensajeError;
                }
                
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


    #region BuscaUsuarioSuperior
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sCuenta"></param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string BuscaUsuarioSuperior(string sCuenta) {
        string cadena = string.Empty;
        //string accion = "BUSCAR";
        clsUsuario us = new clsUsuario();

        try
        {
            if (us.fGetUsuarioSupJerarquico(sCuenta))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                cadena += serializer.Serialize(us.laRegresaDatos).Normalize();
            }
        }
        catch
        {
            cadena = string.Empty;
        }


        return cadena.Normalize();
    }
    #endregion


    #region Método para Buscar los Datos del Enlace Principal en el SERUV

    /// <summary>
    /// Función que busca una cuenta institucional
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="cuenta">Cuenta institucional a buscar en la tabla de usuarios</param>
    /// <returns>Datos del usuario buscado</returns>
    [WebMethod(EnableSession = true)]
    public static string buscaCuenta(string cuenta)
    {

        string cadena = string.Empty;
        //string accion = "BUSCAR";
        clsUsuario us = new clsUsuario();
        if (us.pConsulta_CuentaUsuario(cuenta))
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

    #region Método para Insertar la Solicitud en la Base de Datos
    /// <summary>
    /// Función que Busca los Datos del Sujeto Receptor en SERUV/ORACLE
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="cuenta">Datos para Insertar en la Tabla de APVSOLPRO</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Insertar_Solicitud(clsSolicitud objSolicitud, clsUsuario objUsuario, clsUsuario objUsuarioSO, clsUsuario objUsuarioEnlace, string sEnlace, string sBusquedaSR)
    {
        int blnResultado = 0;

        blnResultado = objSolicitud.fInsertarSolicitud(objUsuario, objUsuarioSO, objUsuarioEnlace, sEnlace, sBusquedaSR);

        return blnResultado;
    }

    #endregion

    #region Método para Generar un Número de Folio para la Solicitud de un Proceso E-R
    /// <summary>
    /// Función para Generar un Número de Folio para la Solicitud de un Proceso E-R
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="cuenta">Objeto de Datos de la Solicitud</param>
    /// <returns>Cadena en formato JSON</returns>
    [WebMethod(EnableSession = true)]
    public static string Codigo_Solicitud(clsSolicitud objSolicitud)
    {
        string strCadena = string.Empty;

        if (objSolicitud.fGetCodigoSolicitud())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena = serializer.Serialize(objSolicitud);
            objSolicitud.Dispose();
        }

        return strCadena.Normalize();
        
   }

    #endregion

    #region fBuscarSujetoObligado
    [WebMethod(EnableSession=true)]
    public static string fBuscarSujetoObligado(clsUsuario objUsuario){
        string strCadena = string.Empty;
        int intRespuesta = 0;
        try
        {
            intRespuesta = objUsuario.fBuscaTitular(objUsuario.strCuenta);
            if (intRespuesta == 1 || intRespuesta == 2)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                strCadena += serializer.Serialize(objUsuario.laRegresaDatos).Normalize();
            }
            else
            {
                strCadena += intRespuesta;
            }
        }
        catch { 
        
        }
        JavaScriptSerializer serializer2 = new JavaScriptSerializer();
        strCadena = serializer2.Serialize(new { Respuesta = strCadena, msj = objUsuario.strMensajeError });
        return strCadena;
    }
    #endregion

    #region fObtieneProcesos
    /// <summary>
    /// Función que obtiene los procesos activa en que participa el sujeto receptor
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="sCuenta">Cuenta institucional del usuario</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneProcesosSR(string sCuenta) {
        string strCadena = string.Empty;
        try
        {
            clsProceso objProceso = new clsProceso();
            objProceso.fObtieneProcesosUsuario(sCuenta);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objProceso.laTipoProceso).Normalize();
        }
        catch
        {
        }

        return strCadena.Normalize();
    }
    #endregion


}