using System;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.DirectoryServices; // Referencia al Framework 4.0
using libFunciones;
using System.Data;
using System.Globalization;
using System.Threading;

/// <summary>
/// Objetivo:                       Clase para el manejo de usuarios
/// Versión:                        1.0
/// Autor:                          L.I. casí MRT Erik José Enríquez Carmona
/// Fecha de Creación:              14 de Febrero 2013
/// Modificó:                       Emmanuel Méndez Flores
/// Fecha de última Mod:            11 de Marzo 2013 11:30pm
/// Tablas de la BD que utiliza:    APSUSUARIO, APSACCESO, AWVDEPCIA, APBPROCESO, APSPERFIL
/// </summary>

namespace nsSERUV
{
    public class clsUsuario
    {
        ArrayList lstParametros = new System.Collections.ArrayList();
        bool blnRespuesta = false;

        #region Variables privadas
        private List<clsUsuario> _laUsuarios;
        private int _idUsuario;     // ID en la tabla  APSUSUARIO
        private string _strCuenta;  // Cuenta Institucional que identificará al Usuario del SERUV
        private string _strCorreo;  // Correo Institucional a donde se le enviarán notificaciones del SERUV
        private string _strNombre;  // Nombre del usuario que ingresará al SERUV
        private string _strApPaterno; // Apellido paterno del usuario
        private string _strApMaterno; // Apellido materno del usuario
        // private string _strApellidos; // Apellidos del usuario
        private int _intNumPersonal;  // Número de Personal del Usuario (Opcional en algunos casos)
        private int _intNumDependencia; // Número de Dependencia a la que pertenece el usuario
        // private DateTime _dteFAlta;  // Fecha de Alta del Usuario en el SERUV
        // private DateTime _dteFUltModif; // Fecha de última modificación del Usuario en el SERUV
        // private int _nUsuario;   // ID del usuario que realizo la última operación sobre el usuario
        private char _chrIndEmpleado; // Indica si el usuario es un empleado S=SI, N=NO
        private char _chrIndActivo; // Indica si el usuario está activo S=SI , N=NO
        // private string _strAccion; // Aqui podriamos guardar la acción que vamos a efectuar en el Usuario (Guardar,Actualizar,Eliminar, etc)
        private List<clsUsuario> _lstUsuarios;
        private string _strsDCPuesto; // Nombre del puesto
        private string _strsDCDepcia; // Nombre de la Dependencia a la que pertenece el usuario
        private string _strsDCPerfil; //Perfil del usuario dentro de SERUV
        private char _chrPrincipal;
        private char _chrIndAplicaS;
        private char _chrIndAplicaE;

        private string _strsProceso;
        //private string _strDependencia; 
        //private string _strPuesto; 
        //private string _strPerfil2;
        private int _intPuesto; // Número del puesto asignado
        private int _intTipPersonal; // Número del tipo de personal
        private int _intCategoria; // Número de categoria
        private string _strTipoPersonal; // Descripción del tipo del personal
        private string _strCategoria; // Descripción de la categoría
        private int _intProceso; //ID del proceso asignado al usuario
        private List<clsProceso> _lstProcesos;

        private string _strResp;
        private string _accion;
        private int _idPerfil; //Id del Perfil
        private int _idUsuarioEnlace;
        private List<clsPerfil> _lstPerfiles;



        private int _idParticipante;
        private string _sDDepcia;
        private string _strInstitucion;
        private string _strCargo;
        private int _intRespDepcia;
        private string _strMensajeError;

        #endregion

        #region Constructores
        /// <summary>
        /// Constructor de la clase clsUsuario
        /// </summary>
        public clsUsuario()
        {
            _laUsuarios = new List<clsUsuario>();
            _idUsuario = 0;
            _strCuenta = "";
            _strCorreo = "";
            _strNombre = "";
            _intNumPersonal = 0;
            _intNumDependencia = 0;
            _chrIndEmpleado = 'X';
            _chrIndActivo = 'X';
            _lstUsuarios = new List<clsUsuario>();
            _strsDCPuesto = "";
            _strsDCDepcia = "";
            _strsDCPerfil = "";
            _chrPrincipal = 'X';
            //_strDependencia="";
            //_strPuesto="";
            //_strPerfil2="";
            _intPuesto = 0;
            _intTipPersonal = 0;
            _intCategoria = 0;
            _intProceso = 0;
            _accion = "";
            _strResp = "";
            _idPerfil = 0;
            _intRespDepcia = 0;

            //
            // TODO: Add constructor logic here
            //
        }
        #endregion

        #region Procedimientos de la Clase clsUsuario

        #region pConfigura_Usuario
        /// <summary>
        /// Procedimiento que controlará el ABC de la clase clUsurios
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <returns>Boleano que indica si se realizo correctamente la operación</returns>
        public bool pConfigura_Usuario()
        {
            bool blnRespuesta = false;
            using (clsDALSQL objUsuario = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("idUsuario", this._idUsuario));
                    blnRespuesta = objUsuario.ExecQuery("PA_USUARIO", lstParametros);

                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pGetPropertyAD
        /// <summary>
        /// Procedimiento que regresa el valor de una propiedad de un objeto del AD.
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <param name="searchResult">Objeto con las propiedades consultadas en el AD</param>
        /// <param name="PropertyName">Propiedad que se consulta</param>
        /// <returns>Cadena con el valor de la propiedad</returns>
        private static string pGetPropertyAD(SearchResult searchResult, string PropertyName)
        {
            if (searchResult.Properties.Contains(PropertyName))
            {
                return searchResult.Properties[PropertyName][0].ToString();
            }
            else
            {
                return string.Empty;
            }
        }
        #endregion

        #region pBuscaCuentaEnAD
        /// <summary>
        /// Procedimiento que busca en el AD una cuenta institucional
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si)</returns>
        public bool pBuscaCuentaEnAD(string sCuenta)
        {
            bool blnRespuesta = false;
            clsValidacion validacion = new clsValidacion();
            try
            {
                DirectoryEntry dyeEntry = new DirectoryEntry(System.Configuration.ConfigurationManager.AppSettings["PATH"].ToString().Trim(),
                                                            @"\" + System.Configuration.ConfigurationManager.AppSettings["CTAMASTER"].ToString().Trim(),
                                                            System.Configuration.ConfigurationManager.AppSettings["PASSMASTER"].ToString().Trim(),
                                                            AuthenticationTypes.Secure | AuthenticationTypes.Sealing | AuthenticationTypes.ServerBind);
                DirectorySearcher dsSearch = new DirectorySearcher(dyeEntry);
                dsSearch.Filter = "(SAMAccountName=" + sCuenta + ")";

                SearchResult srResult = dsSearch.FindOne();
                if (srResult != null)
                {
                    this._strCuenta = pGetPropertyAD(srResult, "sAMAccountName");
                    this._strNombre = pGetPropertyAD(srResult, "givenName");
                    this._strCorreo = pGetPropertyAD(srResult, "mail");
                    this._intNumPersonal = validacion.IsNumeric(pGetPropertyAD(srResult, "employeeID")) ? int.Parse(pGetPropertyAD(srResult, "employeeID")) : 0;
                    this._intNumDependencia = validacion.IsNumeric(pGetPropertyAD(srResult, "departmentNumber")) ? int.Parse(pGetPropertyAD(srResult, "departmentNumber")) : 0;
                    blnRespuesta = true;
                }

            }
            catch
            {
                blnRespuesta = false;
            }
            finally
            {
                validacion.Dispose();
            }
            return blnRespuesta;
        }

        #endregion

        #region pLoguinAD
        /// <summary>
        /// Procedimiento que loguea una cuenta al AD
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si)</returns>
        public bool pLoguinAD(string sCuenta, string sPassword)
        {
            bool blnRespuesta = false;
            try
            {
                DirectoryEntry dyeEntry = new DirectoryEntry(System.Configuration.ConfigurationManager.AppSettings["PATH"],
                                                            sCuenta,
                                                            sPassword,
                                                            AuthenticationTypes.Secure | AuthenticationTypes.Sealing | AuthenticationTypes.ServerBind);
                DirectorySearcher dsSearch = new DirectorySearcher(dyeEntry);
                dsSearch.Filter = "(SAMAccountName=" + sCuenta + ")";

                SearchResult result = dsSearch.FindOne();
                if (dsSearch != null)
                {
                    blnRespuesta = true;
                }

            }
            catch
            {
                blnRespuesta = false;
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetInfoAcceso
        /// <summary>
        /// Función que obtiene la información necesaria para identificar al usuario que accede al sistema
        /// Autor: MTI José Aroldo Alfaro Ávila
        /// Fecha: 16-Mar-2013
        /// </summary>
        public string fGetInfoAcceso(string sCuenta)
        {
            string strInfoAcceso = string.Empty;
            using (clsDALSQL cDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "INFOACCESO"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                if (cDALSQL.ExecQuery_SCL("PA_SELU_USUARIO", lstParametros))
                {
                    strInfoAcceso = cDALSQL.Get_sScalar();
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return strInfoAcceso;
        }
        #endregion

        #region pEliminar_UsuarioOp(string accion, int idUsu)
        /// <summary>
        /// Procedimiento que elimina un enlace operativo
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">accion a realizar en este procedimiento almacenado</param>
        /// <param name="idUsu">identificacion del enlace operativo</param>
        /// <param name="idUsuario">identificador del sujeto obligado</param>
        /// <param name="idProceso">identificador del proceso</param>
        /// <param name="idDepcia">identificador de la dependencia</param>
        /// <returns>entero que indica el resultado de la acción y mostrar un mensaje al usuario</returns>
        public int pEliminar_UsuarioOp(string accion, int idUsu, int idUsuario, int idProceso, int idDepcia)
        {
            int blnRespuesta;
            string ac = "ENLACEPRIN";

            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", ac));
                lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsu));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                objusuarios.ExecQuery_SET("PA_SELV_USUARIOENLACE", lstParametros);

                if (objusuarios.Get_dtSet().Tables[0].Rows.Count > 0)
                {
                    blnRespuesta = 0;
                }
                else
                {
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsu));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", idDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                    if (objusuarios.ExecQuery("PA_IDUH_ELIMINAENLACE", lstParametros))
                    {
                        blnRespuesta = 1;

                    }
                    else
                    {
                        blnRespuesta = 2;
                    }
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region pEliminar_UsuarioOpReceptor(string accion, int idUsu)
        /// <summary>
        /// Procedimiento que elimina un enlace operativo receptor
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">acción a realizar en el procedimiento almacenado</param>
        /// <param name="idUsu">identificador del usuario sujeto obligado</param>
        /// <param name="idUsuario">identificador del enlace operativo</param>
        /// <param name="idProceso">identificador del proceso</param>
        /// <param name="idDepcia">identificador de la dependencia</param>
        /// <returns>entero que identifica el resultado de la acción para mostrar un mensaje</returns>
        public int pEliminar_UsuarioOpReceptor(string accion, int idUsu, int idUsuario, int idProceso, int idDepcia)
        {
            int blnRespuesta;
            string strac = "ENLACEPRIN";

            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", strac));
                lstParametros.Add(lSQL.CrearParametro("@intUSUOPRECEPTOR", idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUEORECEP", idUsu));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                objusuarios.ExecQuery_SET("PA_SELV_USUENLACERECEPTOR", lstParametros);

                if (objusuarios.Get_dtSet().Tables[0].Rows.Count > 0)
                {
                    blnRespuesta = 0;
                }
                else
                {
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUOPRECEPTOR", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUEORECEP", idUsu));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", idDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                    if (objusuarios.ExecQuery("PA_IDUH_EENLACERECEPTOR", lstParametros))
                    {
                        blnRespuesta = 1;

                    }
                    else
                    {
                        blnRespuesta = 2;
                    }
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region pConsulta_UsuarioOp
        /// <summary>
        /// Procedimiento que consulta los enlaces operativos de un determinado usuario, dependencia y proceso
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="idUsuario">identificador del sujeto obligado</param>
        /// <param name="idProceso">identificador del proceso</param>
        /// <param name="idDepcia">identificador de la dependencia</param>
        /// <returns>true en el caso de éxito y false en caso contrario</returns>
        public Boolean pConsulta_UsuarioOp(int idUsuario, int idProceso, int idDepcia)
        {
            Boolean blnRespuesta;
            accion = "SELECCIONAR";
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", idDepcia));

                    if (blnRespuesta = objusuarios.ExecQuery_SET("PA_SELV_USUARIOENLACE", lstParametros))
                    {
                        lstUsuarios = new List<clsUsuario>();
                        fllena_Arreglo(objusuarios.Get_dtSet(), "USUARIOS");
                    }
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pConsulta_Enlaces_por_Sujeto_O
        /// <summary>
        /// Consulta información de enlaces operativos y sujeto obligado para configuración de notificaciones
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="idSujeto">identificador del sujeto obligado</param>
        /// <param name="idProceso">identificador del proceso</param>
        /// <param name="idDepcia">identificador de la dependencia</param>
        /// <param name="idUsuario">identificador de usuario</param>
        /// <returns>true en caso de éxito, false en caso de error</returns>
        public Boolean pConsulta_Enlaces_por_Sujeto_O(int idSujeto, int idProceso, int idDepcia, int idUsuario)
        {
            Boolean blnRespuesta;
            string accion = "SELECCIONARENLACES";
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intSUJETO", idSujeto));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", idDepcia));

                    if (blnRespuesta = objusuarios.ExecQuery_SET("PA_SELV_USUARIOENLACE", lstParametros))
                    {
                        lstUsuarios = new List<clsUsuario>();
                        fllena_Arreglo(objusuarios.Get_dtSet(), "ENLACES_OPERATIVOS");
                    }
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fObtener_Nombre_SO
        /// <summary>
        /// Función que obtiene el nombre de un determinado sujeto obligado
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="idUsuariolog">identificador del usuario logueado</param>
        /// <returns>true en caso de éxito, false en caso de error</returns>
        public Boolean fObtener_Nombre_SO(int idUsuariolog)
        {
            Boolean blnRespuesta;
            accion = "NOMBRE_SO";
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", idUsuariolog));

                    if (blnRespuesta = objusuarios.ExecQuery_SET("PA_SELV_USUARIOENLACE", lstParametros))
                    {
                        lstUsuarios = new List<clsUsuario>();
                        fllena_Arreglo(objusuarios.Get_dtSet(), "NOMBRE_USUARIO_LOG");
                    }
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fConsulta_Enlace_Op_Receptor
        /// <summary>
        /// Procedimiento que consulta los enlaces operativos receptores
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">Acción a ejecutar en el procedimeinto almacenado</param>
        /// <returns>true en el caso de no ocurrir algún error, de lo contrario regresa false</returns>
        public Boolean fConsulta_Enlace_Op_Receptor(int idUsuario, int idProceso, int idDepcia)
        {
            Boolean blnRespuesta;
            accion = "SELECCIONAR";
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUOPRECEPTOR", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", idDepcia));

                    if (blnRespuesta = objusuarios.ExecQuery_SET("PA_SELV_USUENLACERECEPTOR", lstParametros))
                    {
                        lstUsuarios = new List<clsUsuario>();
                        fllena_Arreglo(objusuarios.Get_dtSet(), "ENLACERECEPTOR");
                    }
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pConsulta_ProcesoUsuario
        /// <summary>
        /// Procedimiento que consulta los procesos de un determinado usuario
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">Acción a ejecutar en el procedimeinto almacenado</param>
        /// <returns>true en el caso de no ocurrir algún error, de lo contrario regresa false</returns>
        public Boolean pConsulta_ProcesoUsuario(int idUsuario)
        {
            Boolean blnRespuesta;
            accion = "PROCESO_USUARIO";
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", idUsuario));

                    if (blnRespuesta = objusuarios.ExecQuery_SET("PA_SELV_USUARIOENLACE", lstParametros))
                    {
                        lstUsuarios = new List<clsUsuario>();
                        fllena_Arreglo(objusuarios.Get_dtSet(), "PROCESO_USUARIO");
                    }
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pNuevo_Enlace
        /// <summary>
        /// Función que crea un nuevo enlace operativo
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">Acción a realizar en la función</param>
        /// <param name="idusuario">Identificador del usuario para agregar como enlace operativo</param>
        /// <param name="check">indicador que permite saber si es enlace principal ó no</param>
        /// <param name="Usuario">Identificador de usjeto obligado</param>
        /// <param name="intIdDepcia">Identificador de dependencias</param>
        /// <param name="intIdProceso">Identificador de proceso</param>
        /// <returns>int indica el resultado del proceso para mostrar un mensaje al usuario</returns>
        public int pNuevo_Enlace(string accion, int idusuario, string check, int Usuario, int intIdDepcia, int intIdProceso)
        {
            int blnRespuesta;
            string accion2 = "BUSCAENLACE";
            ArrayList arrOutput = new ArrayList();
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", accion2));
                lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", Usuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idusuario));
                lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", intIdDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", SqlDbType.Int, ParameterDirection.Output));


                if (objusuarios.ExecQuery_OUT("PA_SELV_USUARIOENLACE", lstParametros))
                {
                    arrOutput = objusuarios.Get_aOutput();
                    blnRespuesta = int.Parse(arrOutput[0].ToString());
                    if (blnRespuesta == 4)
                    {

                        lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                        lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", Usuario));
                        lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idusuario));
                        lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", intIdDepcia));
                        lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                        lstParametros.Add(lSQL.CrearParametro("@strCHECK", check));

                        if (objusuarios.ExecQuery("PA_IDUH_ELIMINAENLACE", lstParametros))
                        {
                            blnRespuesta = 1;

                        }
                        else
                        {
                            blnRespuesta = 2;
                        }

                    }
                    else
                    {
                        return blnRespuesta;
                    }
                }
                else
                {

                    blnRespuesta = 2;
                }

            }
            return blnRespuesta;
        }
        #endregion

        #region pModificar_Enlace
        /// <summary>
        ///  Función para modificar los datos de un enlace operativo 
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">acción a realizar en la función</param>
        /// <param name="idusuario">identificador de usuario enlace operativo</param>
        /// <param name="check">indicador enlace principal</param>
        /// <param name="Usuario">identificador de usuario sujeto obligado</param>
        /// <param name="intIdDepcia">identificador de la dependencia</param>
        /// <param name="intIdProceso">identificador del proceso</param>
        /// <returns>true en caso de éxito, false en caso contrario</returns>
        public Boolean pModificar_Enlace(string accion, int idusuario, string check, int Usuario, int intIdDepcia, int intIdProceso)
        {
            // string[] blnRespuesta;
            Boolean blnRespuesta;
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", Usuario));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idusuario));
                    lstParametros.Add(lSQL.CrearParametro("@strCHECK", check));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", intIdDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                    blnRespuesta = objusuarios.ExecQuery("PA_IDUH_ELIMINAENLACE", lstParametros);

                    blnRespuesta = true;
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pModificar_Usuario_Enlace_Receptor
        /// <summary>
        /// Función permite modificar un usuario enlace receptor
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">indica la acción a realizr en el procedimiento almacenado</param>
        /// <param name="idusuario">identificador del usuario</param>
        /// <param name="check">indicador de enlace operativo receptor principal</param>
        /// <param name="idSujetObligado">identificador de sujeto obligado</param>
        /// <param name="nDepcia">identificador de la dependencia</param>
        /// <param name="intIdProceso">identificador del proceso</param>
        /// <param name="sNombre">Nombre</param>
        /// <param name="sApPaterno">Apellido paterno</param>
        /// <param name="sApMaterno">Apellido materno</param>
        /// <param name="sCorreo">correo</param>
        /// <param name="sInstitucion">institución</param>
        /// <param name="sCargo">Cargo</param>
        /// <returns>true en caso de éxito, false en caso de error</returns>
        public Boolean pModificar_Usuario_Enlace_Receptor(string accion, string idusuario, string check, int idSujetObligado, int nDepcia, int intIdProceso, string sNombre, string sApPaterno, string sApMaterno, string sCorreo, string sInstitucion, string sCargo)
        {
            // string[] blnRespuesta;
            Boolean blnRespuesta;
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUOPRECEPTOR", idSujetObligado));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUEORECEP", idusuario));
                    lstParametros.Add(lSQL.CrearParametro("@strCHECK", check));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", nDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                    blnRespuesta = objusuarios.ExecQuery("PA_IDUH_EENLACERECEPTOR", lstParametros);

                    blnRespuesta = true;
                    if (sInstitucion != "null" && sCargo != "null")
                    {
                        blnRespuesta = pModificar_Enlace_Receptor("MODIFICA_USUARIORECEPTOR", idusuario, sNombre, sApPaterno, sApMaterno, sCorreo, sInstitucion, sCargo);
                    }


                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pModificar_Enlace_Receptor
        /// <summary>
        /// Función para modificar un enlace operativo receptor
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">acción a realizar en el procedimiento almacenado</param>
        /// <param name="idusuario">identificador de usuario</param>
        /// <param name="sNombre">nombre</param>
        /// <param name="sApPaterno">apellido paterno</param>
        /// <param name="sApMaterno">apellido materno</param>
        /// <param name="sCorreo">correo</param>
        /// <param name="sInstitucion">institución</param>
        /// <param name="sCargo">cargo</param>
        /// <returns>true en caso de éxito, false en caso de error</returns>
        public Boolean pModificar_Enlace_Receptor(string accion, string idusuario, string sNombre, string sApPaterno, string sApMaterno, string sCorreo, string sInstitucion, string sCargo)
        {
            Boolean blnRespuesta;
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idusuario));
                    lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", sNombre));
                    lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", sApPaterno));
                    lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", sApMaterno));
                    lstParametros.Add(lSQL.CrearParametro("@strCORREO", sCorreo));
                    lstParametros.Add(lSQL.CrearParametro("@strINSTITUCION", sInstitucion));
                    lstParametros.Add(lSQL.CrearParametro("@strCARGO", sCargo));
                    blnRespuesta = objusuarios.ExecQuery("PA_IDUH_USUARIO", lstParametros);

                    blnRespuesta = true;
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pNuevo_Enlace_operativo_receptor
        /// <summary>
        /// función para crear un enlace operativo receptor
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">indica la accion a realizar en el procedimiento almacenado</param>
        /// <param name="idusuario">identificador de usuario enlace operativo receptor</param>
        /// <param name="check">indica si es enlace operativo receptor principal</param>
        /// <param name="Usuario">identificador del sujeto obligado</param>
        /// <param name="intIdDepcia">identificador de la dependencia</param>
        /// <param name="intIdProceso">identificador del proceso</param>
        /// <returns>string que indica el resultado para mostrar un mensaje</returns>
        public string pNuevo_Enlace_operativo_receptor(string accion, int idusuario, string check, int Usuario, int intIdDepcia, int intIdProceso)
        {
            string blnRespuesta = "2";
            string accion2 = "BUSCAENLACE";
            ArrayList arrOutput = new ArrayList();
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", accion2));
                lstParametros.Add(lSQL.CrearParametro("@intUSUOPRECEPTOR", Usuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUEORECEP", idusuario));
                lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", intIdDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", SqlDbType.Int, ParameterDirection.Output));

                if (objusuarios.ExecQuery_OUT("PA_SELV_USUENLACERECEPTOR", lstParametros))
                {
                    arrOutput = objusuarios.Get_aOutput();
                    blnRespuesta = arrOutput[0].ToString();

                    if (blnRespuesta == "5")
                    {
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                        lstParametros.Add(lSQL.CrearParametro("@intUSUOPRECEPTOR", Usuario));
                        lstParametros.Add(lSQL.CrearParametro("@intIDUSUEORECEP", idusuario));
                        lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", intIdDepcia));
                        lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                        lstParametros.Add(lSQL.CrearParametro("@strCHECK", check));

                        if (objusuarios.ExecQuery("PA_IDUH_EENLACERECEPTOR", lstParametros))
                        {
                            blnRespuesta = "1";

                        }
                        else
                        {
                            blnRespuesta = "2";
                        }
                    }
                    else
                    {
                        return blnRespuesta;
                    }
                }
                else
                {
                    blnRespuesta = "2";
                }


            }
            return blnRespuesta;
        }
        #endregion

        #region pModificar_Enlace_operativo_receptor
        /// <summary>
        /// función que modifica un enlace operativo receptor
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">acción a realizar en la función</param>
        /// <param name="idusuario">identificador de usuario enlace operativo receptor</param>
        /// <param name="check">indica si es enlace operativo receptor principal</param>
        /// <param name="Usuario">identificador de usuario sujeto obligado</param>
        /// <param name="intIdDepcia">identificador de la dependencia</param>
        /// <param name="intIdProceso">identificador del proceso</param>
        /// <returns>true en caso de éxito, false en caso de error</returns>
        public Boolean pModificar_Enlace_operativo_receptor(string accion, int idusuario, string check, int Usuario, int intIdDepcia, int intIdProceso)
        {
            // string[] blnRespuesta;
            Boolean blnRespuesta;
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", Usuario));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idusuario));
                    lstParametros.Add(lSQL.CrearParametro("@strCHECK", check));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", intIdDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                    blnRespuesta = objusuarios.ExecQuery("PA_IDUH_EENLACERECEPTOR", lstParametros);

                    blnRespuesta = true;
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region   pConsulta_CuenataUsuario(string accion, string cuenta)
        /// <summary>
        /// Función busca una cuenta institucional
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="cuenta">cuenta a buscar</param>
        /// <returns>true en caso de éxito, false en caso contrario</returns>
        public Boolean pConsulta_CuentaUsuario(string cuenta)
        {
            Boolean blnRespuesta;
            string accion = "BUSCAR";
            using (clsDALSQL objUsuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@strCUENTA", cuenta));
                    if (blnRespuesta = objUsuarios.ExecQuery_SET("PA_SELU_BUSCACUENTA", lstParametros))
                    {
                        lstUsuarios = new List<clsUsuario>();
                        fllena_Arreglo(objUsuarios.Get_dtSet(), "BUSCA_CUENTA");
                    }


                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pActualiza_aplica_notifica
        /// <summary>
        ///  Procedimiento que consulta los enlaces operativos de un sujeto obligado
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="accion">Acción a ejecutar en el procedimiento almacenado</param>
        /// <param name="idusuario">Identificación de usuario a dar de alta como enlace operativo</param>
        /// <returns>true en el caso de no ocurrir algún error, de lo contrario regresa false</returns>
        public Boolean pActualiza_aplica_notifica(string accion, int nIdProceso, int nIdDepcia, int nIdUsuario, int nIdPerfil, char cIdAplica, int nIdUsuModif)
        {
            // string[] blnRespuesta;
            Boolean blnRespuesta;
            using (clsDALSQL objusuarios = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", nIdProceso));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", nIdDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intUSUARIO", nIdUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intPERFIL", nIdPerfil));
                    lstParametros.Add(lSQL.CrearParametro("@strAPLICA", cIdAplica));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUMODIF", nIdUsuModif));

                    blnRespuesta = objusuarios.ExecQuery("PA_IDUH_ELIMINAENLACE", lstParametros);


                    blnRespuesta = true;
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fllena_Arreglo(DataSet dataset, string op)
        /// <summary>
        /// Procedimiento que llena una lista de datos del usuario
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="dataset">DataSet de datos resultado de ejecutar el procedimiento almacenado</param>
        /// <param name="op">Opción de acuerdo a la acción a realizar, mostrar usuarios ó buscar un usuario de acuerdo a su cuenta</param>
        private void fllena_Arreglo(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "USUARIOS":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.idUsuario = int.Parse(row["IDuSUARIO"].ToString());
                                objusuario.strNombre = row["sNombre"].ToString();
                                objusuario.strApPaterno = row["sApPaterno"].ToString();
                                objusuario.strApMaterno = row["sApMaterno"].ToString();
                                objusuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objusuario.strCorreo = row["sCorreo"].ToString();
                                objusuario.strsDCDepcia = row["sDCDepcia"].ToString();
                                objusuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                objusuario.strCuenta = row["sCuenta"].ToString();
                                objusuario.chrPrincipal = char.Parse(row["cIndPrincipal"].ToString());

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "BUSCA_CUENTA":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.idUsuario = int.Parse(row["IDuSUARIO"].ToString());
                                objusuario.strNombre = row["sNombre"].ToString();
                                objusuario.strApPaterno = row["sApPaterno"].ToString();
                                objusuario.strApMaterno = row["sApMaterno"].ToString();
                                objusuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objusuario.strCorreo = row["sCorreo"].ToString();
                                objusuario.strsDCDepcia = row["sDCDepcia"].ToString();
                                objusuario.strsDCPuesto = row["sDCPuesto"].ToString();

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "PROCESO_USUARIO":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.strsProceso = row["sDProceso"].ToString();

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "NOMBRE_USUARIO_LOG":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.strNombre = row["sNombre"].ToString();
                                objusuario.strApPaterno = row["sApPaterno"].ToString();
                                objusuario.strApMaterno = row["sApMaterno"].ToString();

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "ENLACERECEPTOR":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.idUsuario = int.Parse(row["idUSUARIO"].ToString());
                                objusuario.strNombre = row["sNombre"].ToString();
                                objusuario.strApPaterno = row["sApPaterno"].ToString();
                                objusuario.strApMaterno = row["sApMaterno"].ToString();
                                objusuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objusuario.strCorreo = row["sCorreo"].ToString();
                                objusuario.strsDCDepcia = row["sDCDepcia"].ToString();
                                objusuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                objusuario.strCuenta = row["sCuenta"].ToString();
                                objusuario.strInstitucion = row["sInstitucion"].ToString();
                                objusuario.strCargo = row["sCargo"].ToString();
                                objusuario.intNumDependencia = int.Parse(row["nFKDepcia"].ToString());
                                objusuario.chrPrincipal = char.Parse(row["cIndPrincipalR"].ToString());

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "ENLACES_OPERATIVOS":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.idUsuario = int.Parse(row["idFKUObligado"].ToString());
                                objusuario.strApPaterno = row["sujeto"].ToString();
                                objusuario.chrIndAplicaS = char.Parse(row["AplicaSujeto"].ToString());
                                objusuario.idUsuarioEnlace = int.Parse(row["idFKUEnlace"].ToString());
                                objusuario.intProceso = int.Parse(row["idFKProceso"].ToString());
                                objusuario.intNumDependencia = int.Parse(row["nFKDepcia"].ToString());
                                objusuario.strNombre = row["sNombre"].ToString();
                                objusuario.idPerfil = int.Parse(row["idPerfil"].ToString());
                                objusuario.strsDCPerfil = row["sDPerfil"].ToString();
                                objusuario.chrPrincipal = char.Parse(row["cIndPrincipal"].ToString());
                                objusuario.chrIndAplicaE = char.Parse(row["AplicaEnlace"].ToString());

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;

                        case "SOLICITUD":
                            lstUsuarios.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objusuario = new clsUsuario();
                                objusuario.idUsuario = int.Parse(row["idFKUsuario"].ToString());
                                objusuario.intNumDependencia = int.Parse(row["nFKDepcia"].ToString());
                                objusuario.intPuesto = int.Parse(row["nFKPuesto"].ToString());
                                objusuario.strNombre = row["sNombre"].ToString();
                                objusuario.strCorreo = row["sCorreo"].ToString();

                                lstUsuarios.Add(objusuario);
                                // laPeriodosEntrega = null;
                            }
                            break;
                    }
                }
                else
                    lstUsuarios = null;
            }
            catch
            {
                lstUsuarios = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fGetUsuarios
        /// <summary>
        /// Procedimiento que obtiene los datos de los usuarios para mostrarlos en el grid
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Un boleano indicando si se realizó correctamente la operación, el listado de usuarios se guarda en la lista laRegresaDatos</returns>
        public bool fGetUsuarios()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONAR"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fExisteUsuario
        /// <summary>
        /// Procedimiento que obtiene los datos de los usuarios para mostrarlos en el grid
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sCuenta">Cuenta del usuario</param>
        /// <returns>Un arreglo de enteros</returns>
        public int[] fExisteUsuario(string sCuenta)
        {
            //int intRespuesta = 0;
            ArrayList arrOutput;
            int[] arrSalida = new int[2];
            //int intIDUsuario = 0;
            int intExiste = 0;
            blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                blnRespuesta = objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros);
                //intExiste = -1;
                if (blnRespuesta)
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intExiste = int.Parse(arrOutput[0].ToString());
                }
                else
                {
                    intExiste = -1;
                }
                arrSalida[0] = Convert.ToInt32(blnRespuesta); //SI EL QUERY SE EJECUTO CORRECTAMENTE
                arrSalida[1] = intExiste; //SI EXISTE EL USUARIO [1: SI EXISTE, 2: SI NO EXISTE]
            }
            return arrSalida;
        }
        #endregion

        #region fGetUsuario
        /// <summary>
        /// Función que obtiene los datos del usuario que se desea dar de alta en el sistema, en caso de no estar dado de alta en el mismo.
        /// Autor: L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <param name="sCuenta">Cuenta</param>
        /// <returns>Un arreglo de enteros para indicar lo que sucedio durante la ejecución de la función</returns>
        public int[] fGetUsuario(string sCuenta)
        {
            ArrayList arrOutput;
            int[] arrSalida = new int[5]; //[0] CONEXIÓN SQL, [1] CONEXIÓN ORACLE, [2] EJECUCIÓN DEL QUERY, [3] DATASET DEL USUARIO DE ORACLE
            int intIDUsuario = 0;
            int intExiste = 0; //0 SI NO EXISTE, 1 SI EXISTE
            int intCnnSQL = 0; // 0 SI NO SE EJECUTÓ, // 1 SI SE EJECUTÓ
            int intQueryORA = 1; // 0 SI NO SE EJECUTÓ, // 1 SI SE EJECUTÓ -- *** CAMBIAR A 0 NUEVAMENTE
            int intCnnORAC = 1; // 0 SI NO SE EJECUTÓ, // 1 SI SE EJECUTÓ --*** CAMBIAR A 0 NUEVAMENTE
            int intDataSet = 0; // 0 SI NO TIENE DATOS, 1 SI TRAE DATOS

            //string strOrderBy = "";
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                blnRespuesta = objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros);
                if (blnRespuesta)
                {
                    intCnnSQL = 1; //SE EJECUTÓ EL QUERY DE SQL
                    arrOutput = objDALSQL.Get_aOutput();
                    intIDUsuario = int.Parse(arrOutput[0].ToString());

                    if (intIDUsuario == 0)
                    {
                        intExiste = 0; // EL USUARIO NO EXISTE EN LA BD

                        /* SIIU */
                        //clsWSOracle cWSOracle = new clsWSOracle();
                        //DataSet dtSet = cWSOracle.funInfoEmpleado_SET(sCuenta);

                        /* SIISU */
                        DataSet dtSet = new DataSet();
                        clsSPARH objSPARH = new clsSPARH();
                        string strJSONEmpleado = objSPARH.funGetInfoEmpleado(sCuenta);

                        if (objSPARH.strMensajeError == "")
                        {
                            dtSet = objSPARH.ConvertJsonToDataTable(strJSONEmpleado);
                        }

                        strMensajeError = objSPARH.strMensajeError;

                        if (strMensajeError == "")
                        {
                            intQueryORA = 1;
                        }

                        if (dtSet.Tables.Count > 0)
                        {
                            //intCnnORAC = 1;
                            intQueryORA = 1; // SE EJECUTÓ EL QUERY DE ORACLE
                            if (dtSet.Tables[0].Rows.Count > 0)
                            {
                                intDataSet = 1;
                                pLlenarLista(dtSet, "USUARIOS_ORA");
                            }
                        }
                    }
                    else //EL USUARIO YA EXISTE
                    {
                        intExiste = 1;
                    }
                }
            }
            arrSalida[0] = intCnnSQL;
            arrSalida[1] = intQueryORA;
            arrSalida[2] = intExiste;
            arrSalida[3] = intDataSet;
            arrSalida[4] = intCnnORAC;
            return arrSalida;
        }

        #endregion

        #region fGetDatosUsuarioEnlaceReceptor
        /// <summary>
        /// función que obtiene datos del usuario de la base de datos SERUV
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="sCuenta">cuenta institucional</param>
        /// <returns>entero indica el resultado de la acción</returns>
        public int fGetDatosUsuarioEnlaceReceptor(string sCuenta) //CAMBIE ARREGLO DE ENTERO A STRING
        {
            int intRespuesta = 0;

            //string strOrderBy = "";
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "VALIDA_USUARIO_OBTIENE_DATOS"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_USUARIO", lstParametros);

                if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                {

                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS_SERUV");
                    intRespuesta = 2;
                }
                else
                {
                    intRespuesta = -2;
                }

            }

            return intRespuesta;
        }

        #endregion

        #region fGetUsuarioEnlaceReceptor
        /// <summary>
        /// Función obtiene los datos de un usuario de oracle
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="sCuenta">cuenta institucional</param>
        /// <returns>entero indica el resultado de la acción</returns>
        public int fGetUsuarioEnlaceReceptor(string sCuenta) //CAMBIE ARREGLO DE ENTERO A STRING
        {
            ArrayList arrOutput;
            int intIDUsuario = 0;
            int intRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                blnRespuesta = objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros);
                if (blnRespuesta)
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intIDUsuario = int.Parse(arrOutput[0].ToString());


                    if (intIDUsuario == 0)
                    {
                        /* SIIU */
                        //clsWSOracle cWSOracle = new clsWSOracle();

                        //DataSet dtSet = cWSOracle.funInfoEmpleado_SET(sCuenta);

                        //if (dtSet.Tables.Count > 0)
                        //{
                        //    if (dtSet.Tables[0].Rows.Count > 0)
                        //    {

                        //        pLlenarLista(dtSet, "USUARIOS_ORA");
                        //        intRespuesta = 1;
                        //    }
                        //}
                        //else
                        //{
                        //    intRespuesta = -1;

                        //}

                        /* FIN SIIU */

                        /* SIISU */
                        DataSet dtSet = new DataSet();
                        clsSPARH objSPARH = new clsSPARH();
                        string strJSONEmpleado = objSPARH.funGetInfoEmpleado(sCuenta);
                        if (objSPARH.strMensajeError == "")
                        {
                            dtSet = objSPARH.ConvertJsonToDataTable(strJSONEmpleado);

                            strMensajeError = objSPARH.strMensajeError;

                            if (strMensajeError == "")
                            {
                                if (dtSet.Tables.Count > 0)
                                {
                                    if (dtSet.Tables[0].Rows.Count > 0)
                                    {

                                        pLlenarLista(dtSet, "USUARIOS_ORA");
                                        intRespuesta = 1;
                                    }
                                }
                                else
                                {
                                    intRespuesta = -1;

                                }
                            }
                            else
                            {
                                intRespuesta = -3;
                            }
                        }
                        else
                        {
                            intRespuesta = -2;
                        }
                        /* FIN SIISU */
                    }
                    else //EL USUARIO YA EXISTE
                    {
                        intRespuesta = fGetDatosUsuarioEnlaceReceptor(sCuenta);
                    }
                }

            }

            return intRespuesta;
        }

        #endregion

        #region fGetUsrPerfil
        /// <summary>
        /// Procedimiento que obtiene los usuarios por tipo de perfil
        /// Autor: Bárbara Vargas Vera
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si) </returns>
        public bool fGetUsrPerfil(int idPerfil)
        {
            // string[] blnRespuesta;
            Boolean blnRespuesta;
            accion = "SELECCIONAR_USR_PERFIL";
            //idPerfil = 4;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONAR_USR_PERFIL"));
                lstParametros.Add(lSQL.CrearParametro("@intPERFIL", idPerfil));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS_PERFIL");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pLlenarLista
        /// <summary>
        /// Llena la lista laRegresaDatos con los usuarios de acuerdo a cada caso
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="dataset">Dataset con la consulta de usuarios</param>
        /// <param name="op">Opción que se ejecutará</param>
        private void pLlenarLista(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "INFOACCESO":
                            laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                //objUsuario.strCuenta = row["sCuenta"].ToString();
                                //objUsuario.idPerfil = int.Parse(row["idPerfil"].ToString());
                                objUsuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objUsuario.idUsuario = int.Parse(row["IDuSUARIO"].ToString());
                                objUsuario.strNombre = row["sNombre"].ToString();
                                objUsuario.strCorreo = row["sCorreo"].ToString();
                                objUsuario.strsDCDepcia = row["sDDepcia"].ToString();
                                objUsuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                objUsuario.strsDCPerfil = row["sDPerfil"].ToString();
                                //objUsuario.strApellidos = row[""].ToString();
                                //objUsuario.strDependencia = row["sDCDepcia"].ToString();
                                //objUsuario.strPuesto = row["sDCPuesto"].ToString();
                                //objUsuario.strPerfil2 = row["sDPerfil"].ToString();
                                //objUsuario.chrIndActivo = char.Parse(row["cIndActivo"].ToString());
                                laRegresaDatos.Add(objUsuario);
                            }
                            break;

                        case "USUARIOS":
                            laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                objUsuario.strCuenta = row["sCuenta"].ToString();
                                objUsuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objUsuario.idUsuario = int.Parse(row["IDuSUARIO"].ToString());
                                objUsuario.strNombre = row["sNombre"].ToString();
                                objUsuario.strCorreo = row["sCorreo"].ToString();
                                objUsuario.strsDCDepcia = row["sDDepcia"].ToString();
                                objUsuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                //objUsuario.strsDCPerfil = row["sDPerfil"].ToString();

                                if (row["cIndEmpleado"].ToString() == "")
                                {
                                    objUsuario.chrIndEmpleado = 'X';
                                }
                                else
                                {
                                    objUsuario.chrIndEmpleado = char.Parse(row["cIndEmpleado"].ToString());
                                }

                                objUsuario.chrIndActivo = char.Parse(row["cIndActivoE"].ToString());
                                //objUsuario.intProceso = int.Parse(row["nIdProceso"].ToString());
                                List<clsPerfil> arrPerfiles = new List<clsPerfil>();
                                List<clsProceso> arrProcesos = new List<clsProceso>();
                                //List<int> lstProcesos = new List<int>();
                                foreach (DataRow row2 in dataset.Tables[1].Rows)
                                {
                                    //List<clsPerfil> arrPerfiles = new List<clsPerfil>();
                                    if (objUsuario.idUsuario == int.Parse(row2["IDuSUARIO"].ToString()))
                                    {
                                        clsPerfil objPerfil = new clsPerfil();
                                        objPerfil.idPerfil = int.Parse(row2["nIdPerfil"].ToString());
                                        objPerfil.strsDCPerfil = row2["sDPerfil"].ToString();
                                        arrPerfiles.Add(objPerfil);
                                    }
                                }

                                foreach (DataRow row3 in dataset.Tables[2].Rows)
                                {
                                    if (objUsuario.idUsuario == int.Parse(row3["IDuSUARIO"].ToString()))
                                    {
                                        clsProceso objProceso = new clsProceso();
                                        objProceso.idProceso = int.Parse(row3["nIdProceso"].ToString());
                                        objProceso.strDProceso = row3["sProceso"].ToString();
                                        arrProcesos.Add(objProceso);
                                    }
                                }
                                objUsuario.lstPerfiles = arrPerfiles;
                                //objUsuario.lstidProcesos = lstProcesos;
                                objUsuario.lstProcesos = arrProcesos;

                                laRegresaDatos.Add(objUsuario);
                            }
                            break;

                        case "USUARIOS_ORA":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                if (row.Table.Columns.Contains("NOPER"))
                                {
                                    objUsuario.intNumPersonal = int.Parse(row["NOPER"].ToString());
                                }
                                else
                                {
                                    objUsuario.intNumPersonal = 0;
                                }

                                if (row.Table.Columns.Contains("CVELOGIN"))
                                {
                                    objUsuario.strCuenta = row["CVELOGIN"].ToString();
                                }
                                else
                                {
                                    objUsuario.strCuenta = " ";
                                }

                                if (row.Table.Columns.Contains("NOMB"))
                                {
                                    objUsuario.strNombre = row["NOMB"].ToString();
                                }
                                else
                                {
                                    objUsuario.strNombre = " ";
                                }

                                if (row.Table.Columns.Contains("APAT"))
                                {
                                    objUsuario.strApPaterno = row["APAT"].ToString();
                                }
                                else
                                {
                                    objUsuario.strApPaterno = " ";
                                }

                                if (row.Table.Columns.Contains("AMAT"))
                                {
                                    objUsuario.strApMaterno = row["AMAT"].ToString();
                                }
                                else
                                {
                                    objUsuario.strApMaterno = " ";
                                }

                                if (row.Table.Columns.Contains("CORREO"))
                                {
                                    objUsuario.strCorreo = row["CORREO"].ToString();
                                }
                                else
                                {
                                    objUsuario.strCorreo = " ";
                                }

                                if (row.Table.Columns.Contains("NDEP"))
                                {
                                    objUsuario.intNumDependencia = int.Parse(row["NDEP"].ToString());
                                }
                                else
                                {
                                    objUsuario.intNumDependencia = 0;
                                }

                                if (row.Table.Columns.Contains("DDEP"))
                                {
                                    objUsuario.strsDCDepcia = row["DDEP"].ToString();
                                }
                                else
                                {
                                    objUsuario.strsDCDepcia = " ";
                                }

                                if (row.Table.Columns.Contains("NPUE"))
                                {
                                    objUsuario.intPuesto = int.Parse(row["NPUE"].ToString());
                                }
                                else
                                {
                                    objUsuario.intPuesto = 0;
                                }

                                if (row.Table.Columns.Contains("DPUE"))
                                {
                                    objUsuario.strsDCPuesto = row["DPUE"].ToString();
                                }
                                else
                                {
                                    objUsuario.strsDCPuesto = " ";
                                }

                                if (row.Table.Columns.Contains("NPUE"))
                                {
                                    objUsuario.intPuesto = int.Parse(row["NPUE"].ToString());
                                }
                                else
                                {
                                    objUsuario.intPuesto = 0;
                                }

                                if (row.Table.Columns.Contains("NTPE"))
                                {
                                    objUsuario.intTipPersonal = int.Parse(row["NTPE"].ToString());
                                }
                                else
                                {
                                    objUsuario.intTipPersonal = 0;
                                }

                                if (row.Table.Columns.Contains("NCAT"))
                                {
                                    objUsuario.intCategoria = int.Parse(row["NCAT"].ToString());
                                }
                                else
                                {
                                    objUsuario.intCategoria = 0;
                                }

                                objUsuario.chrIndEmpleado = 'S';
                                objUsuario.chrIndActivo = 'S';
                                laRegresaDatos.Add(objUsuario);
                            }
                            break;

                        case "USUARIOS_PERFIL":
                            laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                objUsuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objUsuario.idUsuario = int.Parse(row["IDuSUARIO"].ToString());
                                objUsuario.strNombre = row["sNombre"].ToString();
                                objUsuario.strCorreo = row["sCorreo"].ToString();
                                objUsuario.strsDCDepcia = row["sDDepcia"].ToString();
                                objUsuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                objUsuario.strsDCPerfil = row["sDPerfil"].ToString();
                                laRegresaDatos.Add(objUsuario);
                            }
                            break;

                        case "DEPENDENCIAXUSUARIO":
                            //laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                objUsuario.idParticipante = int.Parse(row["idParticipante"].ToString());
                                objUsuario.sDDepcia = row["sDDepcia"].ToString();

                                laRegresaDatos.Add(objUsuario);
                            }
                            break;
                        case "USUARIOS_SERUV":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                objUsuario.intPuesto = int.Parse(row["nFKPuesto"].ToString());
                                objUsuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                objUsuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objUsuario.strCuenta = row["sCuenta"].ToString();
                                objUsuario.strNombre = row["sNombre"].ToString();
                                objUsuario.strApPaterno = row["sApPaterno"].ToString();
                                objUsuario.strApMaterno = row["sApMaterno"].ToString();
                                objUsuario.strCorreo = row["sCorreo"].ToString();
                                objUsuario.intNumDependencia = int.Parse(row["nFKDepcia"].ToString());
                                objUsuario.strsDCDepcia = row["sDCDepcia"].ToString();
                                objUsuario.chrIndEmpleado = 'S';
                                objUsuario.chrIndActivo = char.Parse(row["cIndActivo"].ToString());
                                objUsuario.intTipPersonal = int.Parse(row["nFKTipoPers"].ToString());
                                objUsuario.intCategoria = int.Parse(row["nFKCategoria"].ToString());

                                objUsuario.idUsuario = int.Parse(row["idUSUARIO"].ToString());
                                objUsuario.strInstitucion = row["sInstitucion"].ToString();
                                objUsuario.strCargo = row["sCargo"].ToString();
                                laRegresaDatos.Add(objUsuario);
                            }
                            break;
                        case "TITULAR_AMDMIN":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                objUsuario.strNombre = row["sNombre"].ToString();
                                objUsuario.idUsuario = int.Parse(row["idUsuario"].ToString());
                                objUsuario.intPuesto = int.Parse(row["nFKPuesto"].ToString());
                                objUsuario.strsDCPuesto = row["sDPuesto"].ToString();
                                objUsuario.intTipPersonal = int.Parse(row["nFKTipoPers"].ToString());
                                objUsuario.strTipoPersonal = row["sDTipoPers"].ToString();
                                objUsuario.intCategoria = int.Parse(row["nFKCategoria"].ToString());
                                objUsuario.strCategoria = row["sDCategoria"].ToString();
                                objUsuario.intRespDepcia = int.Parse(row["idRespDepcia"].ToString());
                                laRegresaDatos.Add(objUsuario);
                            }
                            break;
                        case "SUPERIOR_JERARQUICO":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsUsuario objUsuario = new clsUsuario();
                                objUsuario.intPuesto = int.Parse(row["nFKPuesto"].ToString());
                                objUsuario.strsDCPuesto = row["sDCPuesto"].ToString();
                                objUsuario.intNumPersonal = int.Parse(row["nPersonal"].ToString());
                                objUsuario.strCuenta = row["sCuenta"].ToString();
                                objUsuario.strNombre = row["sNombre"].ToString();
                                objUsuario.strApPaterno = row["sApPaterno"].ToString();
                                objUsuario.strApMaterno = row["sApMaterno"].ToString();
                                objUsuario.strCorreo = row["sCorreo"].ToString();
                                objUsuario.intNumDependencia = int.Parse(row["nFKDepcia"].ToString());
                                objUsuario.strsDCDepcia = row["sDCDepcia"].ToString();
                                objUsuario.chrIndEmpleado = 'S';
                                objUsuario.chrIndActivo = char.Parse(row["cIndActivo"].ToString());
                                objUsuario.intTipPersonal = int.Parse(row["nFKTipoPers"].ToString());
                                objUsuario.intCategoria = int.Parse(row["nFKCategoria"].ToString());

                                objUsuario.idUsuario = int.Parse(row["idUSUARIO"].ToString());
                                objUsuario.strInstitucion = row["sInstitucion"].ToString();
                                objUsuario.strCargo = row["sCargo"].ToString();
                                laRegresaDatos.Add(objUsuario);
                                objUsuario.lstPerfiles = new List<clsPerfil>();

                                foreach (DataRow row2 in dataset.Tables[1].Rows)
                                {
                                    clsPerfil objPerfil = new clsPerfil();
                                    objPerfil.idPerfil = int.Parse(row2["nIdPerfil"].ToString());
                                    //objPerfil.strsDCPerfil = row2["sDPerfil"].ToString();
                                    objUsuario.lstPerfiles.Add(objPerfil);
                                }
                            }
                            break;
                    }
                }
            }
            catch
            {
                laRegresaDatos = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fGuardarInformacion
        /// <summary>
        /// Función que guarda la información de los usuario, es decir sus datos y los perfiles asignados
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nDepcia">Número de la dependencia</param>
        /// <param name="nPuesto">Número del puesto</param>
        /// <param name="sNombre">Nombre</param>
        /// <param name="sApPaterno">Apellido paterno</param>
        /// <param name="sApMaterno">Apellido Materno</param>
        /// <param name="sCuenta">Cuenta</param>
        /// <param name="nNumPersonal">Número de personal</param>
        /// <param name="sCorreo">Correo</param>
        /// <param name="nTper">Número tipo de personal</param>
        /// <param name="nCategoria">Número de categoría</param>
        /// <param name="cIndEmpleado">Indicador de empleado</param>
        /// <param name="cIndActivo">Indicador de activo</param>
        /// <param name="nUsuario">Id del usuario que realiza la acción</param>
        /// <param name="sCheck">Indicador si se marco o no el checkbox de administrador</param>
        /// <returns>Una cadena que indica si se ejecutó correctamente la operación (0 - No, 1 - Si)</returns>
        public string fGuardarInformacion(int nDepcia, int nPuesto, string sNombre, string sApPaterno, string sApMaterno, string sCuenta,
            int nNumPersonal, string sCorreo, int nTper, int nCategoria, char cIndEmpleado, char cIndActivo, int nUsuario, string sPerfiles)
        {
            ArrayList arrOutput = new ArrayList();
            //Array arrPerfiles = sPerfiles.Split(',');
            int intIDUsuario = 0;
            //int idFProceso = 0;
            libSQL lSQL = new libSQL();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                objDALSQL.Conectar();
                string strApellidos = sApPaterno + " " + sApMaterno;
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", nPuesto));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", nNumPersonal));
                lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", sNombre));
                lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", sApPaterno));
                lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", sApMaterno));
                lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                lstParametros.Add(lSQL.CrearParametro("@strCORREO", sCorreo));
                lstParametros.Add(lSQL.CrearParametro("@intTPER", nTper));
                lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", nCategoria));
                lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", cIndEmpleado));
                lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", cIndActivo));
                lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intIDUsuario = int.Parse(arrOutput[0].ToString());

                    this._strResp = arrOutput[1].ToString();
                    if (this._strResp == "1")
                    {
                        //arrOutput = objDALSQL.Get_aOutput().ToArray;
                        //intIDUsuario = arrOutput[0];
                        //intIDUsuario = objDALSQL.Get_aOutput().ToArray[0];

                        //if (arrPerfiles.Length > 0)
                        //{
                        //for (int i = 0; i < arrPerfiles.Length; i++)
                        //{
                        if (sPerfiles.Length > 0)
                        {
                            sPerfiles = sPerfiles.Substring(0, sPerfiles.Length - 1);
                        }
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDAR_ADMINISTRADOR"));
                        lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intIDUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@strPERFILESASIGNADOS", sPerfiles));
                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                        if (objDALSQL.ExecQuery_OUT("PA_IDUH_ACCESO", lstParametros))
                        {
                            System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                            this._strResp = arrOUT[0].ToString();
                        }
                        //if (sCheck == "S")
                        //{
                        //    lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDAR_ADMINISTRADOR"));
                        //    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intIDUsuario));
                        //    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                        //    if (objDALSQL.ExecQuery_OUT("PA_IDUH_ACCESO", lstParametros))
                        //    {
                        //        System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                        //        this._strResp = arrOUT[0].ToString();
                        //    }
                        //}
                        //}
                        //}
                    }
                    else
                    {
                        return _strResp;
                    }
                }
                else
                {
                    // Mensaje
                    //this._strResp = arrOutput[1].ToString();
                }
                objDALSQL.Desconectar();
            }
            return _strResp;
        }
        #endregion

        #region fGuardarInformacionReceptor
        /// <summary>
        /// Función que busca un usuario en oracle y lo guarda en la base de datos seruv tabla usuarios
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="nDepcia">número de la dependencia del sujeto receptor</param>
        /// <param name="nidDependencia">número de la dependencia del enlace receptor</param>
        /// <param name="nPuesto">identificador del puesto</param>
        /// <param name="sNombre">nombre</param>
        /// <param name="sApPaterno">apellido paterno</param>
        /// <param name="sApMaterno">apellido materno</param>
        /// <param name="sCuenta">cuenta</param>
        /// <param name="nNumPersonal">número de personal</param>
        /// <param name="sCorreo">correo</param>
        /// <param name="nTper">tipo de personal</param>
        /// <param name="nCategoria">número de catogoría</param>
        /// <param name="cIndEmpleado">indicador de empleado</param>
        /// <param name="cIndActivo">indicador de activo</param>
        /// <param name="idSujetObligado">id del sujeto obligado</param>
        /// <param name="intIdProceso">indicador del proceso</param>
        /// <param name="check">indicador  de enlace operativo receptor principal</param>
        /// <param name="nUsuario">identificador del usuario que lo agrega</param>
        /// <param name="sInstitucion">institución</param>
        /// <param name="sCargo">cargo</param>
        /// <returns> string que indica el resultado de la acción</returns>
        public string fGuardarInformacionReceptor(int nDepcia, int nidDependencia, int nPuesto, string sNombre, string sApPaterno, string sApMaterno, string sCuenta, int nNumPersonal, string sCorreo, int nTper, int nCategoria, char cIndEmpleado, char cIndActivo, int idSujetObligado, int intIdProceso, string check, int nUsuario, string sInstitucion, string sCargo)
        {
            ArrayList arrOutput = new ArrayList();
            int intIDUsuario = 0;
            libSQL lSQL = new libSQL();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                objDALSQL.Conectar();
                string strApellidos = sApPaterno + " " + sApMaterno;
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIORECEPTOR"));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nidDependencia));
                lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", nPuesto));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", nNumPersonal));
                lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", sNombre));
                lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", sApPaterno));
                lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", sApMaterno));
                lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                lstParametros.Add(lSQL.CrearParametro("@strCORREO", sCorreo));
                lstParametros.Add(lSQL.CrearParametro("@intTPER", nTper));
                lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", nCategoria));
                lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", cIndEmpleado));
                lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", cIndActivo));
                lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nUsuario));
                lstParametros.Add(lSQL.CrearParametro("@strINSTITUCION", sInstitucion));
                lstParametros.Add(lSQL.CrearParametro("@strCARGO", sCargo));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intIDUsuario = int.Parse(arrOutput[0].ToString());

                    this._strResp = arrOutput[1].ToString();

                    if (this._strResp == "1")
                    {

                        _strResp = pNuevo_Enlace_operativo_receptor("NUEVOENLACE", intIDUsuario, check, idSujetObligado, nDepcia, intIdProceso);

                    }
                    else
                    {
                        return _strResp;
                    }
                }
                else
                {

                }
                objDALSQL.Desconectar();
            }
            return _strResp;
        }
        #endregion

        #region fActualizaEdoAdmin
        /// <summary>
        /// Función que actualiza el perfil de administrador de un usuario.
        /// Autor: L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <param name="nidUsuario">Id del usuario</param>
        /// <param name="sCheck">Indica si el checkbox de administrador está marcado o no</param>
        /// <returns>Una cadena para indicar si se realizó correctamente la operación</returns>
        public string fActualizaEdoAdmin(int intIDUsuario, string sPerfiles)
        {
            libSQL lSQL = new libSQL();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                //lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDAR_ADMINISTRADOR"));
                //lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nidUsuario));
                //lstParametros.Add(lSQL.CrearParametro("@strPERFILESASIGNADOS", sPerfiles));
                //lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                //if (objDALSQL.ExecQuery_OUT("PA_IDUH_ACCESO", lstParametros))
                //{
                //    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                //    this._strResp = arrOUT[0].ToString();
                //}
                if (sPerfiles.Length > 0)
                {
                    sPerfiles = sPerfiles.Substring(0, sPerfiles.Length - 1);
                }
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDAR_ADMINISTRADOR"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intIDUsuario));
                lstParametros.Add(lSQL.CrearParametro("@strPERFILESASIGNADOS", sPerfiles));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_ACCESO", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }
            }
            return _strResp;
        }
        #endregion

        #region fActualizaPerfilUsuario
        /// <summary>
        /// Función que actualiza la información de los usuarios, es decir sus datos y los perfiles asignados
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nidProceso">Id del proceso</param>
        /// <param name="nidUsuario">Id del usuario</param>
        /// <param name="sPerfiles">Perfiles asignados</param>
        /// <returns>Una cadena indicando si se ejecutó correctamente la operación (0 - No, 1 - Si)</returns>
        public string fActualizaPerfilUsuario(int nidUsuario, int nidProceso, string sPerfiles)
        {
            Array arrPerfiles = sPerfiles.Split(',');
            sPerfiles = "";
            for (int i = 0; i < arrPerfiles.Length; i++)
            {
                if (arrPerfiles.GetValue(i).ToString().Length > 0)
                {
                    if (i == 0)
                    {
                        sPerfiles += arrPerfiles.GetValue(i).ToString();
                    }

                    else
                    {
                        sPerfiles += ",";
                        sPerfiles += arrPerfiles.GetValue(i).ToString();
                    }
                }
            }
            libSQL lSQL = new libSQL();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                System.Collections.ArrayList arrOUT = new ArrayList();
                this._strResp = "";
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_ACTUALIZA_ACCESO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nidUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDFKPROCESO", nidProceso));
                lstParametros.Add(lSQL.CrearParametro("@strPERFILESASIGNADOS", sPerfiles));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_ACCESO", lstParametros))
                {
                    arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }
                //blnRespuesta = objDALSQL.ExecQuery("PA_IDUH_ACCESO", lstParametros);
                /*
                objDALSQL.Conectar();
                //PRIMERO ELIMINAMOS LA RELACIÓN USUARIO-PERFILES
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINA_ACCESO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nidUsuario));
                //lstParametros.Add(lSQL.CrearParametro("@intIDFKPROCESO", idFProceso));
                blnRespuesta = objDALSQL.ExecQuery("PA_IDUH_ACCESO", lstParametros);
                if (blnRespuesta)
                {
                    //AGREGAMOS LA(S) RELACIÓN(ES) USUARIO-PERFILES
                    for (int i = 0; i < arrPerfiles.Length; i++)
                    {
                        if (arrPerfiles.GetValue(i).ToString().Length > 0)
                        {
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_ACCESO"));
                            lstParametros.Add(lSQL.CrearParametro("@intIDPERFIL", int.Parse(arrPerfiles.GetValue(i).ToString())));
                            lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nidUsuario));
                            lstParametros.Add(lSQL.CrearParametro("@intIDFKPROCESO", nidProceso));
                            blnRespuesta = objDALSQL.ExecQuery("PA_IDUH_ACCESO", lstParametros);
                        }
                    }
                }
                objDALSQL.Desconectar();
                */
            }
            return _strResp;
        }
        #endregion

        #region fGuardaUsuario
        ///// <summary>
        ///// Procedimiento que guarda los datos del usuario
        ///// Autor: L.I. Emmanuel Méndez Flores
        ///// </summary>
        //public bool fGuardaUsuario(int nDepcia, int nPuesto, string sNombre, string sApPaterno, string sApMaterno, string sCuenta,
        //    int nNumPersonal, string sCorreo, int nTper, int nCategoria, char cIndEmpleado, char cIndActivo)
        //{
        //    using (clsDALSQL objDALSQL = new clsDALSQL(false))
        //    {
        //        libSQL lSQL = new libSQL();
        //        string strApellidos = sApPaterno + " " + sApMaterno;
        //        lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
        //        lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nDepcia));
        //        lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", nPuesto));
        //        lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
        //        lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", nNumPersonal));
        //        lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", sNombre));
        //        lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
        //        lstParametros.Add(lSQL.CrearParametro("@strCORREO", sCorreo));
        //        lstParametros.Add(lSQL.CrearParametro("@intTPER", nTper));
        //        lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", nCategoria));
        //        lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", cIndEmpleado));
        //        lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", cIndActivo));
        //        blnRespuesta = objDALSQL.ExecQuery("PA_IDUH_USUARIO", lstParametros);
        //    }
        //    return blnRespuesta;
        //}

        #endregion

        #region fGuardaPerfiles
        /// <summary>
        /// Procedimiento que guarda los perfiles asignados de usuario
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si) </returns>
        public bool fGuardaPerfiles(String sPerfiles)
        {

            foreach (int intIdPerfil in sPerfiles)
            {
                using (clsDALSQL objDALSQL = new clsDALSQL(false))
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_ACCESO"));
                    lstParametros.Add(lSQL.CrearParametro("@intIDPERFIL", intIdPerfil));
                    //lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", ));
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region fGetIdUsuario
        ///// <summary>
        ///// Procedimiento que recupera el id de un usuario
        ///// Autor: L.I. Emmanuel Méndez Flores
        ///// </summary>
        //public int fGetIdUsuario(string sCuenta) { 
        //    int intIdUsuario=0;
        //    using (clsDALSQL objDALSQL = new clsDALSQL(false)){
        //        libSQL lSQL= new libSQL();
        //        lstParametros.Add(lSQL.CrearParametro("strACCION", "SELECCIONA_IDUSUARIO"));
        //        lstParametros.Add(lSQL.CrearParametro("strCUENTA", sCuenta));
        //        objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros);
        //    }
        //    return intIdUsuario;
        //}
        #endregion

        #region fActiva_Desactiva_Usuario
        /// <summary>
        /// Procedimiento que cambia el estado de un Usuario
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nidUsuario">Id del usuario</param>
        /// <param name="strIndActivo">Indicador si el usuario se va activar o desactivar</param>
        /// <returns>Una cadena para indicar si se realizó correctamente la operación</returns>
        public string fActiva_Desactiva_Usuario(int nidUsuario, string strIndActivo)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "MODIFICA_EDO_USUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nidUsuario));
                lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", strIndActivo));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }
                //blnRespuesta = objDALSQL.ExecQuery("PA_IDUH_USUARIO", lstParametros);
            }
            return _strResp;
        }
        #endregion

        #region fBuscaCuenta
        /// <summary>
        /// Procedimiento que busca un Usuario por su cuenta institucional
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sCuenta">Cuenta del usuario</param>
        /// <returns>Un boleano para indicar si se realizo correctamente la operación</returns>
        public bool fBuscaCuenta(string sCuenta)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_USUARIO_CUENTA"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS");
                }
                else
                {
                    //obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region IDisposable Members
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #region fGetUsuarios_por_dependencia
        /// <summary>
        /// Procedimiento que busca a los usuarios por dependencia
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nIdDepcia">Número de la dependencia</param>
        /// <returns>Un boleano para indicar si se realizó correctamente la operación</returns>
        public bool fGetUsuarios_por_dependencia(int nIdDepcia)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_USR_DEPCIA"));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nIdDepcia));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGet_Part_X_Perfil_Usu
        /// <summary>
        /// Procedimiento que regresa las dependencias y participantes en las cuales esta actuando el usuario
        /// Autor: L.I. Jesús Montero Cuevas
        /// </summary>
        /// <param name="sIndicador"></param>
        /// <param name="nIdusuario">Id del usuario</param>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public bool fGet_Part_X_Perfil_Usu(int nIdusuario, string sIndicador)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_PART_X_PERFIL_USU"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdusuario));
                lstParametros.Add(lSQL.CrearParametro("@strINDICADORUSU", sIndicador));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "DEPENDENCIAXUSUARIO");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region fDeshabilitasujeto
        /// <summary>
        /// Procedimiento que deshabilita a un sujeto obligado o receptor del proceso al que este asignado
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nIdUsuario">Id del usuario</param>
        /// <param name="sIndSujeto">Indicador del tipo de sujeto</param>
        /// <param name="sParticipantes">Participantes a los que esta asigando</param>
        /// <returns>Una cadena indicando si se realizó correctamente la operación</returns>
        public string fDeshabilitasujeto(string sParticipantes, string sIndSujeto, int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "DESASIGNAR_SUJ-O-R"));
                lstParametros.Add(lSQL.CrearParametro("@strPARTICIPANTES", sParticipantes));
                lstParametros.Add(lSQL.CrearParametro("@strINDICADOR", sIndSujeto));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (blnRespuesta = objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }
            }
            return _strResp;
        }

        #endregion

        #region fGetUsuariosProcesoDisp
        /// <summary>
        /// Procedimiento que busca a los usuarios asignados a un proceso y los que no estan asignados a un proceso
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nIdProceso">Id del proceso</param>
        /// <returns>Un boleano que indica si se realizó correctamente la operación</returns>
        public bool fGetUsuariosProcesoDisp(int nIdProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONAR_USUARIO_PROCESO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region pGetDatosTitularDepcia
        /// <summary>
        /// Funcion que devuelve los datos del titular de una dependencia
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si) </returns>
        public bool pGetDatosTitularDepcia()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._accion.Trim()));
                lstParametros.Add(lSQL.CrearParametro("@intNumDependencia", this._intNumDependencia));
                lstParametros.Add(lSQL.CrearParametro("@intPuesto", this._intPuesto));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_SOLICITUD", lstParametros))
                {
                    laRegresaDatos = new List<clsUsuario>();
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "SOLICITUD");
                    blnRespuesta = true;
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }

            }

            return blnRespuesta;
        }
        #endregion

        #region fIncluirUsuarios
        /// <summary>
        /// Funcion que devuelve los datos de los usuarios a quien se enviarán las notificaciones
        /// Autor: Bárbara Vargas Vera
        /// </summary>
        public string fIncluirUsuarios(string sSeleccionadas)
        {
            //bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                this._strResp = "";
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "INCLUIR_DESTINATARIOS"));
                lstParametros.Add(lSQL.CrearParametro("@strPARTICIPANTES", sSeleccionadas));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", sSeleccionadas));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                //if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                //{
                //    laRegresaDatos = new List<clsUsuario>();
                //    fllena_Arreglo(objDALSQL.Get_dtSet(), "USUARIOS");
                //    blnRespuesta = true;
                //}
                //else
                //{

                //}


                //if (objDALSQL.ExecQuery_OUT("PA_SELV_USUARIO", lstParametros)){
                //    arrOUT = objDALSQL.Get_aOutput();
                //    this._strResp = arrOUT[0].ToString();
                //}

                if (objDALSQL.ExecQuery_SET_OUT("PA_SELV_USUARIO", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    //arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                    //fllena_Arreglo(objDALSQL.Get_dtSet(), "SOLICITUD");

                    DataSet ds = objDALSQL.Get_dtSet();
                    string dato = clsJsonMethods.ConvertDataSetToXML(ds);
                    this._strResp = clsJsonMethods.ConvertDataSetToXML(ds);

                    //clsWSNotif wsNotif = new clsWSNotif();
                    //Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "INC_PART"));
                    //tmod.Start();
                    //}

                }
            }
            return _strResp;
        }
        #endregion

        #region fBuscaTitular
        /// <summary>
        /// Función que busca un usuario dentro del sistema y en caso de no estar en el mismo, lo busca
        /// en la BD de Oracle.
        /// Autor: L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <param name="sCuenta">Cuenta institucional del usuario</param>
        /// <returns>Un entero indicando si se realizó correctamente la operación</returns>
        public int fBuscaTitular(string sCuenta)
        {
            ArrayList arrOutput;
            int intRespuesta = 0;
            int intIDUsuario = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intIDUsuario = int.Parse(arrOutput[0].ToString());
                    if (intIDUsuario == 0)
                    {
                        /* SIIU */
                        //clsWSOracle cWSOracle = new clsWSOracle();

                        //DataSet dtSet = cWSOracle.funInfoEmpleado_SET(sCuenta);

                        //if (dtSet.Tables.Count > 0)
                        //{
                        //    if (dtSet.Tables[0].Rows.Count > 0)
                        //    {
                        //        pLlenarLista(dtSet, "USUARIOS_ORA");
                        //        intRespuesta = 1;
                        //    }
                        //}
                        //else
                        //{
                        //    intRespuesta = -1;
                        //}

                        /* FIN SIIU */

                        /* SIISU */
                        DataSet dtSet = new DataSet();
                        clsSPARH objSPARH = new clsSPARH();
                        string strJSONEmpleado = objSPARH.funGetInfoEmpleado(sCuenta);
                        if (objSPARH.strMensajeError == "")
                        {
                            dtSet = objSPARH.ConvertJsonToDataTable(strJSONEmpleado);

                            strMensajeError = objSPARH.strMensajeError;

                            if (strMensajeError == "")
                            {
                                if (dtSet.Tables.Count > 0)
                                {
                                    if (dtSet.Tables[0].Rows.Count > 0)
                                    {
                                        pLlenarLista(dtSet, "USUARIOS_ORA");
                                        intRespuesta = 1;
                                    }
                                }
                                else
                                {
                                    intRespuesta = -1;
                                }
                            }
                            else
                            {
                                intRespuesta = -3;
                            }
                        }
                        else
                        {
                            intRespuesta = -2;
                        }
                        /* FIN SIISU */
                    }
                    else
                    {
                        intRespuesta = Convert.ToInt32(fGetDatosTitular(sCuenta));
                    }
                }
            }
            return intRespuesta;
        }
        #endregion

        #region fGetDatosTitular
        /// <summary>
        /// Función que obtiene los datos del titular a dar de alta
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sCuenta">Cuenta institucional del usuario</param>
        /// <returns>Un entero indicando el resultado de la acción</returns>
        public int fGetDatosTitular(string sCuenta)
        {
            int intRespuesta = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "VALIDA_USUARIO_OBTIENE_DATOS"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_USUARIO", lstParametros);

                if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                {
                    pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS_SERUV");
                    intRespuesta = 2;
                }
                else
                {
                    intRespuesta = -2;
                }
            }
            return intRespuesta;
        }
        #endregion

        #region fObtenerTitular_O_Admin
        /// <summary>
        /// Función que obtiene los datos del titular o del administrador de una dependencia
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nDependencia">Clave de la dependencia</param>
        /// <param name="sIndTitular">Indicador de que persona se quieren obtener los datos (A: Administrador, T: Titular)</param>
        /// <returns>Devuelve un entero si se realizó correctamente la acción (0: No, 1: Si)</returns>
        public int fObtenerTitular_O_Admin(int nDependencia, string sIndTitular)
        {
            int intRespuesta = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "BUSCA_TITULAR_O_ADMIN"));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nDependencia));
                lstParametros.Add(lSQL.CrearParametro("@chrINDTITULAR", sIndTitular));

                if (objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros))
                {
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        pLlenarLista(objDALSQL.Get_dtSet(), "TITULAR_AMDMIN");
                        intRespuesta = 1;
                    }
                }
            }
            return intRespuesta;
        }
        #endregion

        #region fGuardaTitular
        /// <summary>
        /// Función que se encarga guardar la información del nuevo titular
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nDepcia">Clave de la dependencia</param>
        /// <param name="nPuesto">Clave del puesto</param>
        /// <param name="nRespDepcia">Id de la tabla APRRESPDEPCIA</param>
        /// <param name="nIdTitular">Id del titular actual</param>
        /// <param name="nIdNuevoTitular">Id del nuevo titular</param>
        /// <param name="nUsuario">Id del usuario que realiza la operación</param>
        /// <param name="sIndTitular">Indicador de titular (A: Administrador, T: Titular)</param>
        /// <param name="objNuevoTitular">Objeto de tipo Usuario con la información del nuevo titular</param>
        /// <returns>Un entero indicando si se realizó correctamente la operación (0: No se realizó, 1: Se realizó correctamente)</returns>
        public int fGuardaTitular(int nDepcia, int nPuesto, int nRespDepcia, int nIdTitular, int nIdNuevoTitular, int nUsuario, string sIndTitular, clsUsuario objNuevoTitular)
        {
            int intRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                if (nIdNuevoTitular == 0)
                {
                    System.Collections.ArrayList arrOUTSO = new ArrayList();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                    lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objNuevoTitular.strCuenta));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                    arrOUTSO = objDALSQL.Get_aOutput();
                    int intIDUsuarioSO = int.Parse(arrOUTSO[0].ToString());
                    if (intIDUsuarioSO == 0)
                    {
                        ArrayList arrOutputSO = new ArrayList();
                        string strApellidos = objNuevoTitular.strApPaterno + " " + objNuevoTitular.strApMaterno;
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                        lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objNuevoTitular.intNumDependencia));
                        lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objNuevoTitular.intPuesto));
                        lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objNuevoTitular.strCuenta));
                        lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", objNuevoTitular.intNumPersonal));
                        lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", objNuevoTitular.strNombre));
                        lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", objNuevoTitular.strApPaterno));
                        lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", objNuevoTitular.strApMaterno));
                        lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                        lstParametros.Add(lSQL.CrearParametro("@strCORREO", objNuevoTitular.strCorreo));
                        lstParametros.Add(lSQL.CrearParametro("@intTPER", objNuevoTitular.intTipPersonal));
                        lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objNuevoTitular.intCategoria));
                        lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", objNuevoTitular.chrIndEmpleado));
                        lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", objNuevoTitular.chrIndActivo));
                        lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                        if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                        {
                            arrOutputSO = objDALSQL.Get_aOutput();
                            intIDUsuarioSO = int.Parse(arrOutputSO[0].ToString());
                            nIdNuevoTitular = intIDUsuarioSO;
                        }
                    }
                }

                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZA_TITULAR"));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", nPuesto));
                lstParametros.Add(lSQL.CrearParametro("@intIDRESPDEPCIA", nRespDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intIDTITULAR", nIdTitular));
                lstParametros.Add(lSQL.CrearParametro("@intIDNUEVOTITULAR", nIdNuevoTitular));
                lstParametros.Add(lSQL.CrearParametro("@chrINDTITULAR", sIndTitular));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                {
                    ArrayList arrOUT = objDALSQL.Get_aOutput();
                    intRespuesta = int.Parse(arrOUT[0].ToString());
                }
            }

            return intRespuesta;
        }
        #endregion


        #region fGuardaTitular
        /// <summary>
        /// Funció que se encarga de guardar la información del nuevo titular
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="objTitular">Objeto de tipo Usuario que contiene la información del titular</param>
        /// <param name="objNuevoTitular">Objeto de tipo Usuario que contiene la información del nuevo titular</param>
        /// <param name="sIndTitular">Indicador de titular (A: Administrador, T: Titular)</param>
        /// <param name="nUsuario">Id del usuario que realiza la actualización</param>
        /// <returns>Un entero indicando si se realizó correctamente la operación (0: No se realizó, 1: Se realizó correctamente)</returns>
        public int fGuardaTitular(clsUsuario objTitular, clsUsuario objNuevoTitular, string sIndTitular, int nUsuario)
        {
            int intRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                if (objNuevoTitular.idUsuario == 0)
                {
                    System.Collections.ArrayList arrOUTSO = new ArrayList();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                    lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objNuevoTitular.strCuenta));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                    if (objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros))
                    {
                        arrOUTSO = objDALSQL.Get_aOutput();
                        int intIDUsuarioSO = int.Parse(arrOUTSO[0].ToString());
                        if (intIDUsuarioSO == 0)
                        {
                            ArrayList arrOutputSO = new ArrayList();
                            string strApellidos = objNuevoTitular.strApPaterno + " " + objNuevoTitular.strApMaterno;
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                            lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objNuevoTitular.intNumDependencia));
                            lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objNuevoTitular.intPuesto));
                            lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objNuevoTitular.strCuenta));
                            lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", objNuevoTitular.intNumPersonal));
                            lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", objNuevoTitular.strNombre));
                            lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", objNuevoTitular.strApPaterno));
                            lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", objNuevoTitular.strApMaterno));
                            lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                            lstParametros.Add(lSQL.CrearParametro("@strCORREO", objNuevoTitular.strCorreo));
                            lstParametros.Add(lSQL.CrearParametro("@intTPER", objNuevoTitular.intTipPersonal));
                            lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objNuevoTitular.intCategoria));
                            lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", objNuevoTitular.chrIndEmpleado));
                            lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", objNuevoTitular.chrIndActivo));
                            lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nUsuario));
                            lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                            lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                            if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                            {
                                arrOutputSO = objDALSQL.Get_aOutput();
                                intIDUsuarioSO = int.Parse(arrOutputSO[0].ToString());
                                objNuevoTitular.idUsuario = intIDUsuarioSO;
                            }
                        }
                    }
                }

                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZA_TITULAR"));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objTitular._intNumDependencia));
                lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objTitular.intPuesto));
                lstParametros.Add(lSQL.CrearParametro("@intIDRESPDEPCIA", objTitular.intRespDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intIDTITULAR", objTitular.idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDNUEVOTITULAR", objNuevoTitular.idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intTPER", objNuevoTitular.intTipPersonal));
                lstParametros.Add(lSQL.CrearParametro("@intPUESTONUEVOTITULAR", objNuevoTitular.intPuesto));
                lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objNuevoTitular.intCategoria));
                lstParametros.Add(lSQL.CrearParametro("@chrINDTITULAR", sIndTitular));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                {
                    ArrayList arrOUT = objDALSQL.Get_aOutput();
                    intRespuesta = int.Parse(arrOUT[0].ToString());
                }
            }

            return intRespuesta;
        }
        #endregion

        #region
        /// <summary>
        /// Autor: L.I Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sCuenta">Cuenta institucional</param>
        /// <returns></returns>
        public bool fGetUsuarioSupJerarquico(string sCuenta)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTIENE_DATOS_VALIDA_SUP"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_USUARIO", lstParametros);

                if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                {

                    pLlenarLista(objDALSQL.Get_dtSet(), "SUPERIOR_JERARQUICO");
                    blnRespuesta = true;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetUsuarioReceptor
        /// <summary>
        /// Función obtiene los datos de un usuario de oracle
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sCuenta">cuenta institucional</param>
        /// <returns>entero indica el resultado de la acción</returns>
        public int fGetUsuarioReceptor(string sCuenta, string sPerfil) //CAMBIE ARREGLO DE ENTERO A STRING
        {
            ArrayList arrOutput;
            int intIDUsuario = 0;
            int intRespuesta = 0;
            strMensajeError = "";

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                blnRespuesta = objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros);
                if (blnRespuesta)
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intIDUsuario = int.Parse(arrOutput[0].ToString());


                    if (intIDUsuario == 0)
                    {
                        //clsWSOracle cWSOracle = new clsWSOracle();

                        //DataSet dtSet = cWSOracle.funInfoEmpleado_SET(sCuenta);

                        //if (dtSet.Tables.Count > 0)
                        //{
                        //    if (dtSet.Tables[0].Rows.Count > 0)
                        //    {

                        //        pLlenarLista(dtSet, "USUARIOS_ORA");
                        //        intRespuesta = 1;
                        //    }
                        //}
                        //else
                        //{
                        //    intRespuesta = -1;

                        //}

                        /* SIISU */
                        DataSet dtSet = new DataSet();
                        clsSPARH objSPARH = new clsSPARH();
                        string strJSONEmpleado = objSPARH.funGetInfoEmpleado(sCuenta);
                        if (objSPARH.strMensajeError == "")
                        {
                            dtSet = objSPARH.ConvertJsonToDataTable(strJSONEmpleado);

                            strMensajeError = objSPARH.strMensajeError;

                            if (strMensajeError == "")
                            {
                                if (dtSet.Tables.Count > 0)
                                {
                                    if (dtSet.Tables[0].Rows.Count > 0)
                                    {

                                        pLlenarLista(dtSet, "USUARIOS_ORA");
                                        intRespuesta = 1;
                                    }
                                }
                                else
                                {
                                    intRespuesta = -1;

                                }
                            }
                            else
                            {
                                intRespuesta = -3;
                            }
                        }
                        else
                        {
                            strMensajeError = "ERROR: " + objSPARH.strMensajeError;
                            intRespuesta = -2;
                        }
                        /* FIN SIISU */
                    }
                    else //EL USUARIO YA EXISTE
                    {
                        if (sPerfil == "SR")
                        {
                            if (!fValidaSujetoReceptorenProceso(sCuenta))
                            {
                                intRespuesta = fGetDatosUsuarioEnlaceReceptor(sCuenta);
                            }
                            else
                            {
                                intRespuesta = -5;
                            }
                        }
                        else
                        {
                            intRespuesta = fGetDatosUsuarioEnlaceReceptor(sCuenta);
                        }
                    }
                }

            }

            return intRespuesta;
        }

        #endregion

        #region
        /// <summary>
        /// Función que valida si un sujeto receptor se encuentra participando en un proceso activo
        /// L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <param name="sCuenta">Cuenta Institucional</param>
        /// <returns>Booleano que indica si se encuentra o no en un proceso activo (False: No, True: Si)</returns>
        public bool fValidaSujetoReceptorenProceso(string sCuenta)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "VALIDA_USUARIO_RECEPTOR"));
                lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_SET("PA_SELU_USUARIO", lstParametros))
                {
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        blnRespuesta = true;
                    }
                }
            }
            return blnRespuesta;
        }

        #endregion

        #endregion

        #region GET y SETs
        public int idUsuario { get { return _idUsuario; } set { _idUsuario = value; } }   // ID en la tabla  APSUSUARIO
        public string strCuenta { get { return _strCuenta; } set { _strCuenta = value; } }  // Cuenta Institucional que identificará al Usuario del SERUV
        public string strCorreo { get { return _strCorreo; } set { _strCorreo = value; } }  // Correo Institucional a donde se le enviarán notificaciones del SERUV
        public string strNombre { get { return _strNombre; } set { _strNombre = value; } } // Nombre del usuario que ingresará al SERUV
        public string strApPaterno { get { return _strApPaterno; } set { _strApPaterno = value; } } // Apellido paterno del usuario
        public string strApMaterno { get { return _strApMaterno; } set { _strApMaterno = value; } } // Apellido materno del usuario
        // public string strApellidos { get { return _strApellidos; } set { _strApellidos = value; } } // Apellidos del usuario
        public int intNumPersonal { get { return _intNumPersonal; } set { _intNumPersonal = value; } }  // Número de Personal del Usuario (Opcional en algunos casos)
        public int intNumDependencia { get { return _intNumDependencia; } set { _intNumDependencia = value; } } // Número de dependencia a la que pertenece le usuario
        // public DateTime dteFAlta { get { return _dteFAlta; } set { _dteFAlta = value; } }  // Fecha de Alta del Usuario en el SERUV
        // public DateTime dteFUltModif { get { return _dteFUltModif; } set { _dteFUltModif = value; } } // Fecha de última modificación del Usuario en el SERUV
        // public int nUsuario { get { return _nUsuario; } set { _nUsuario = value; } }   // ID del usuario que realizo la última operación sobre el usuario
        public char chrIndEmpleado { get { return _chrIndEmpleado; } set { _chrIndEmpleado = value; } }
        public char chrIndActivo { get { return _chrIndActivo; } set { _chrIndActivo = value; } } // Indica si el usuario está activo S=SI , N=NO
        // public string strAccion { get { return strAccion; } set { strAccion = value; } }
        public string strsDCPuesto { get { return _strsDCPuesto; } set { _strsDCPuesto = value; } }
        public string strsDCDepcia { get { return _strsDCDepcia; } set { _strsDCDepcia = value; } }
        public string strsDCPerfil { get { return _strsDCPerfil; } set { _strsDCPerfil = value; } }
        public string strsProceso { get { return _strsProceso; } set { _strsProceso = value; } }
        public char chrPrincipal { get { return _chrPrincipal; } set { _chrPrincipal = value; } }
        public char chrIndAplicaE { get { return _chrIndAplicaE; } set { _chrIndAplicaE = value; } }
        public char chrIndAplicaS { get { return _chrIndAplicaS; } set { _chrIndAplicaS = value; } }
        public List<clsUsuario> lstUsuarios { get { return _lstUsuarios; } set { _lstUsuarios = value; } }
        public List<clsUsuario> laRegresaDatos { get { return _laUsuarios; } set { _laUsuarios = value; } }
        //public string strDependencia { get { return _strDependencia; } set { _strDependencia = value; } }
        //public string strPuesto { get { return _strPuesto; } set { _strPuesto = value; } }
        //public string strPerfil2 { get { return _strPerfil2; } set { _strPerfil2 = value; } }

        public int intPuesto { get { return _intPuesto; } set { _intPuesto = value; } }
        public int intTipPersonal { get { return _intTipPersonal; } set { _intTipPersonal = value; } }
        public int intCategoria { get { return _intCategoria; } set { _intCategoria = value; } }
        public string strTipoPersonal { get { return _strTipoPersonal; } set { _strTipoPersonal = value; } }
        public string strCategoria { get { return _strCategoria; } set { _strCategoria = value; } }
        public int intProceso { get { return _intProceso; } set { _intProceso = value; } }
        public List<clsProceso> lstProcesos { get { return _lstProcesos; } set { _lstProcesos = value; } }
        public int idPerfil { get { return _idPerfil; } set { _idPerfil = value; } }
        public string accion { get { return _accion; } set { _accion = value; } }

        public List<clsPerfil> lstPerfiles { get { return _lstPerfiles; } set { _lstPerfiles = value; } }

        public int idParticipante { get { return _idParticipante; } set { _idParticipante = value; } }
        public int idUsuarioEnlace { get { return _idUsuarioEnlace; } set { _idUsuarioEnlace = value; } }
        public string sDDepcia { get { return _sDDepcia; } set { _sDDepcia = value; } }
        public string strInstitucion { get { return _strInstitucion; } set { _strInstitucion = value; } }
        public string strCargo { get { return _strCargo; } set { _strCargo = value; } }
        public int intRespDepcia { get { return _intRespDepcia; } set { _intRespDepcia = value; } }

        public string strMensajeError { get { return _strMensajeError; } set { _strMensajeError = value; } }

        #endregion
    }
}