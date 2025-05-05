using System;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Data;
using libFunciones;
using System.Web.Services;
using nsSERUV;

/// <summary>
/// Objetivo:                       Clase para el manejo de Dependencias
/// Versión:                        1.0
/// Autor:                          Edgar Morales González, Jesús Montero Cuevas
/// Fechas:                         25 de Febrero de 2013 al 28 de Febrero de 2013
/// Tablas de la BD que utiliza:    AWVDEPCIA
/// 
/// Modifico:                       Emmanuel Méndez Flores
/// Fecha:                          18 de Febrero del 2013
/// </summary>

namespace nsSERUV
{
    public class clsDepcia
    {
        public clsDepcia()
        {
        }

        private List<clsDepcia> _laParticipantes;
        public List<clsDepcia> laParticipantes { get { return _laParticipantes; } set { _laParticipantes = value; } }
        private List<clsPuesto> _laPuestos;
        public List<clsPuesto> laPuestos { get { return _laPuestos; } set { _laPuestos = value; } }


        //Propiedades de la clase Dependencia
        #region Propiedades usadas para el manejo de la clase Dependencia
        private int _nDepcia; // Id de la Dependencia
        private String _sDDepcia; // Descripción de la Dependencia
        private String _sDCDepcia; // Descripción corta de la Dependencia
        private List<clsDepcia> _laDepcia; //Lista de Dependencias
        private clsUsuario _objUsuario; //Usuario responsable de la dependencia
        private int _nPuesto; //Clave del puesto que tiene asignada la dependencia
        private int _nDepciaPadre;
        private string _sDDepciaPadre;
        private int _idParticipante;
        private string _sNombre;
        private int _idProceso;
        private char _cIndAplicaAnexo;
        private string _strNomSO;
        private string _strIndSO;
        private string _strIndEOP;
        private string _strDProceso;
        private int _IDUsuarioSO;
        private int _IDPerfil;
        private string _sTitular;

        #endregion

        #region Getters y Setters usados para el manejo de la clase Dependencia
        public int nDepcia { get { return _nDepcia; } set { _nDepcia = value; } }
        public String sDDepcia { get { return _sDDepcia; } set { _sDDepcia = value; } }
        public String sDCDepcia { get { return _sDCDepcia; } set { _sDCDepcia = value; } }
        public System.Collections.ArrayList _lstParametros { get; set; }
        public List<clsDepcia> laDepcia { get { return _laDepcia; } set { _laDepcia = value; } }
        public clsUsuario objUsuario { get { return _objUsuario; } set { _objUsuario = value; } }
        public int nPuesto { get { return _nPuesto; } set { _nPuesto = value; } }
        public int nDepciaPadre { get { return _nDepciaPadre; } set { _nDepciaPadre = value; } }
        public string sDDepciaPadre { get { return _sDDepciaPadre; } set { _sDDepciaPadre = value; } }
        public int idParticipante { get { return _idParticipante; } set { _idParticipante = value; } }
        public string sNombre { get { return _sNombre; } set { _sNombre = value; } }
        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }
        public char cIndAplicaAnexo { get { return _cIndAplicaAnexo; } set { _cIndAplicaAnexo = value; } }
        public int IDUsuarioSO { get { return _IDUsuarioSO; } set { _IDUsuarioSO = value; } }
        public int IDPerfil { get { return _IDPerfil; } set { _IDPerfil = value; } }
        public string strIndSO { get { return _strIndSO; } set { _strIndSO = value; } }
        public string strIndEOP { get { return _strIndEOP; } set { _strIndEOP = value; } }
        public string strNomSO { get { return _strNomSO; } set { _strNomSO = value; } }
        public string strDProceso { get { return _strDProceso; } set { _strDProceso = value; } }
        public string sTitular { get { return _sTitular; } set { _sTitular = value; } }
        #endregion

        /* Para la utilización de la capa de acceso a datos */
        //libSQL _lbSQL;
        //clsDALSQL _cDASQL;
        /****************************************************/


        #region fObtener_Dependencia()
        /// <summary>
        /// Función para obtener la lista de dependencias
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Un boleano que indica si se realizó o no correctamente el query</returns>
        public bool fObtener_Dependencia()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_DEPCIA"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "Depcia");
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

        #region fObtener_Dependencia
        /// <summary>
        /// Procedimiento que obtiene las dependencias a partir de un proceso y de un usuario 
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="intIdProceso">Identificador del proceso</param>
        /// <param name="intUsuariolog">Identificador del usuario que ha ingresado al sistema</param>
        /// <returns>true si la acción fue realizada correctamente de lo contrario retorna false</returns>
        public bool fObtener_Dependencia(int intIdProceso, int intUsuariolog, string strAccion)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));
                _lstParametros.Add(lSQL.CrearParametro("@intNPROCESO", intIdProceso));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intUsuariolog));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "DepciaSO");
                }
                else
                {

                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fObtener_Dependencia_receptor
        /// <summary>
        /// Procedimiento que obtiene las dependencias a partir de una acción, el proceso y de un usuario receptor 
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="strAccion">Cadena que identifica la acción a ejecutar en el procedimiento almacenado</param>
        /// <param name="intIdProceso">Identificador del proceso</param>
        /// <param name="intUsuariolog">Identificador del usuario receptor</param>
        /// <returns>true si la acción fue realizada correctamente de lo contrario retorna false</returns>
        public bool fObtener_Dependencia_receptor(string strAccion, int intIdProceso, int intUsuariolog)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));
                _lstParametros.Add(lSQL.CrearParametro("@intNPROCESO", intIdProceso));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intUsuariolog));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "Depcia");
                }
                else
                {

                }
            }
            return blnRespuesta;
        }
        #endregion

        public bool fObtener_Dependencias_Titular()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_DEPENDENCIAS_TITULAR"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "DepciaTitular");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }

        //Obtiene una Lista de Dependencias que se mostraran en un listbox en la forma AltaProceso 
        #region función para Listar las Dependencias
        private void fLista_Depcia(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "Depcia":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsDepcia depcia = new clsDepcia();
                                depcia.nDepcia = Convert.ToInt32(row["nDepcia"].ToString());
                                depcia.sDDepcia = row["Dependencia"].ToString();
                                //  depcia.sNombre = row["cIndEntrega"].ToString();

                                laDepcia.Add(depcia);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "DepciaSO":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsDepcia depcia = new clsDepcia();

                                depcia.IDUsuarioSO = Convert.ToInt32(row["IDUsuarioSO"].ToString());
                                depcia.strNomSO = row["NomSO"].ToString();
                                depcia.IDPerfil = Convert.ToInt32(row["IDPerfil"].ToString());
                                depcia.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                depcia.strDProceso = row["sDProceso"].ToString();
                                depcia.strIndSO = row["IndSO"].ToString();
                                depcia.strIndEOP = row["IndEOP"].ToString();
                                depcia.nDepcia = Convert.ToInt32(row["nFKDepcia"].ToString());
                                depcia.sDDepcia = row["sDDepcia"].ToString();
                                depcia.sNombre = row["cIndEntrega"].ToString();


                                laDepcia.Add(depcia);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "DepciaBloque":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsDepcia depcia = new clsDepcia();
                                depcia.nDepcia = Convert.ToInt32(row["nDepcia"].ToString());
                                depcia.sDDepcia = row["Dependencia"].ToString();
                                depcia.cIndAplicaAnexo = char.Parse(row["cAplica"].ToString());

                                laDepcia.Add(depcia);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "DepciaTitular":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsDepcia depcia = new clsDepcia();
                                depcia.nDepcia = Convert.ToInt32(row["nDepcia"].ToString());
                                depcia.sDDepcia = row["sDDepcia"].ToString();
                                //depcia.sTitular = row["sNombre"].ToString();

                                laDepcia.Add(depcia);
                            }
                            break;
                        case "DepciaNoInst":
                            laDepcia.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsDepcia objDepcia = new clsDepcia();
                                objDepcia.nDepcia = Convert.ToInt32(row["nDepcia"].ToString());
                                objDepcia.sDDepcia = row["sDDepcia"].ToString();
                                objDepcia.sDCDepcia = row["sDCDepcia"].ToString();
                                objDepcia.nPuesto = Convert.ToInt32(row["nPuestoEntrega"].ToString());
                                objDepcia.nDepciaPadre = Convert.ToInt32(row["nDepciaPadre"].ToString());
                                objDepcia.sDDepciaPadre = row["sDDepciaPadre"].ToString();
                                objDepcia.objUsuario = new clsUsuario();
                                objDepcia.objUsuario.idUsuario = Convert.ToInt32(row["idUsuario"].ToString());
                                objDepcia.objUsuario.strNombre = row["sNombre"].ToString();
                                objDepcia.objUsuario.intNumPersonal = Convert.ToInt32(row["nPersonal"].ToString());
                                objDepcia.objUsuario.strCuenta = row["sCuenta"].ToString();
                                objDepcia.objUsuario.intTipPersonal = Convert.ToInt32(row["nTipoPers"].ToString());
                                objDepcia.objUsuario.strTipoPersonal = row["sDTipoPers"].ToString();
                                objDepcia.objUsuario.intPuesto = Convert.ToInt32(row["nPuesto"].ToString());
                                objDepcia.objUsuario.strsDCPuesto = row["sDPuesto"].ToString();
                                objDepcia.objUsuario.intCategoria = Convert.ToInt32(row["nCategoria"].ToString());
                                objDepcia.objUsuario.strCategoria = row["sDCategoria"].ToString();

                                laDepcia.Add(objDepcia);
                            }
                            break;
                    }
                }
                else
                    laDepcia = null;
            }
            catch
            {
                laDepcia = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }

        #endregion


        //Obtiene Lista de Dependencias 
        //**** Si llegan a esta función, comentenla por favor ****
        #region función para obtener Lista de Dependencias
        public bool fObtener_DependenciaER(int nPuesto)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_DEPCIA_ER"));
                _lstParametros.Add(lSQL.CrearParametro("@intNPuesto", nPuesto));


                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "Depcia");
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

        #region función para obtener Lista de Dependencias
        /// <summary>
        /// Autor:          Edgar Morales González
        /// Objetivo:       Obtener la lista de dependencias en relación a un puesto
        /// </summary>
        /// <param name="nPuesto"> número del puesto que servira para buscar las dependencias que tengan ese puesto</param>
        /// <returns></returns>
        public bool fObtener_DependenciaPER(int nPuesto)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_DEPCIA_PER"));
                _lstParametros.Add(lSQL.CrearParametro("@intNPuesto", nPuesto));


                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "Depcia");
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

        #region fGetDependenciasBloque
        /// <summary>
        /// Procedimiento que obtiene la lista de dependencias de acuerdo a un idAplica
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nIdAplica">Id aplica (Id del bloque)</param>
        /// <param name="nIdAnexo">Id del anexo</param>
        /// <returns>Un entero que indica 1 - Si trae dependencia, 0 - Si no trae dependencias, -1 - No se pudo ejecutar </returns>
        public int fObtener_DependenciasBloque(int nIdAplica, int nIdAnexo)
        {
            bool blnRespuesta = false;
            int intRespuesta = 0;
            this._lstParametros = new System.Collections.ArrayList();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_DEPEDENCIAS_PARTBLOQUE"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDAPLICA", nIdAplica));
                _lstParametros.Add(lSQL.CrearParametro("@intANEXO", nIdAnexo));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        fLista_Depcia(objDALSQL.Get_dtSet(), "DepciaBloque");
                        intRespuesta = 1; // TRAE DEPENDENCIAS
                    }
                    else
                    {
                        intRespuesta = 0; // NO HAY DEPENDENCIAS ASOCIADAS A UN PROCESO DEL BLOQUE SELECCIONADO
                    }
                }
                else
                {
                    intRespuesta = -1; // NO PUDO EJECUTAR EL QUERY
                }
            }
            return intRespuesta;
        }
        #endregion

        #region
        public bool fObtenerDependenciasSolicitud(int nPuesto, int idUsuario)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_DEPENDENCIAS_SOLICITUD"));
                _lstParametros.Add(lSQL.CrearParametro("@intNPuesto", nPuesto));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));


                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "Depcia");
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

        #region fGuardaNuevoDepartamento
        /// <summary>
        /// Función que guarda los departamentos que no están dados de alta en el catálogo institucional de dependencias
        /// L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nDepciaPadre">Clave de la dependecia que depende el nuevo departamento</param>
        /// <param name="sDescripLarga">Descripcion larga del departamento</param>
        /// <param name="sDescripCorta">Descripción corta del departamento</param>
        /// /// <param name="nTitular">ID del usuario titular del departamento</param>
        /// <param name="nUsuario">ID del usuario que realiza la acción</param>
        /// <returns></returns>
        public int fGuardaNuevoDepartamento(int nDepciaPadre, string sDescripLarga, string sDescripCorta, clsUsuario objNuevoTitular, int nPuesto, int nUsuario)
        {
            int intRespuesta = 0;
            this._lstParametros = new System.Collections.ArrayList();
            ArrayList arrOutput = new ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                if (objNuevoTitular.idUsuario == 0)
                {
                    int intIDUsuarioSO = 0;
                    ArrayList arrOutputSO = new ArrayList();
                    string strApellidos = objNuevoTitular.strApPaterno + " " + objNuevoTitular.strApMaterno;
                    _lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                    _lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objNuevoTitular.intNumDependencia));
                    _lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objNuevoTitular.intPuesto));
                    _lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objNuevoTitular.strCuenta));
                    _lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", objNuevoTitular.intNumPersonal));
                    _lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", objNuevoTitular.strNombre));
                    _lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", objNuevoTitular.strApPaterno));
                    _lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", objNuevoTitular.strApMaterno));
                    _lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                    _lstParametros.Add(lSQL.CrearParametro("@strCORREO", objNuevoTitular.strCorreo));
                    _lstParametros.Add(lSQL.CrearParametro("@intTPER", objNuevoTitular.intTipPersonal));
                    _lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objNuevoTitular.intCategoria));
                    _lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", objNuevoTitular.chrIndEmpleado));
                    _lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", objNuevoTitular.chrIndActivo));
                    _lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nUsuario));
                    _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                    _lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", _lstParametros))
                    {
                        arrOutputSO = objDALSQL.Get_aOutput();
                        intIDUsuarioSO = int.Parse(arrOutputSO[0].ToString());
                        objNuevoTitular.idUsuario = intIDUsuarioSO;
                    }
                }
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "AGREGA_DEPENDENCIA"));
                _lstParametros.Add(lSQL.CrearParametro("@intDEPCIAPADRE", nDepciaPadre));
                _lstParametros.Add(lSQL.CrearParametro("@strDESCRIPCIONLARGA", sDescripLarga));
                _lstParametros.Add(lSQL.CrearParametro("@strDESCRIPCIONCORTA", sDescripCorta));
                _lstParametros.Add(lSQL.CrearParametro("@intRESPONSABLE", objNuevoTitular.idUsuario));
                _lstParametros.Add(lSQL.CrearParametro("@intPUESTO", nPuesto));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPUESTORESP", objNuevoTitular.intPuesto));
                _lstParametros.Add(lSQL.CrearParametro("@intTPERRESP", objNuevoTitular.intTipPersonal));
                _lstParametros.Add(lSQL.CrearParametro("@intCATEGORIARESP", objNuevoTitular.intCategoria));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nUsuario));
                _lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_DEPCIA", _lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intRespuesta = Convert.ToInt32(arrOutput[0].ToString());
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return intRespuesta;
        }
        #endregion

        #region fObtieneDepartamentos
        /// <summary>
        /// Función que obtiene la lista de dependencias de acuerdo a un idAplica
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns></returns>
        public bool fObtieneDepartamentos()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "DEPARTAMENTOS_NO_INSTITU"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_DEPCIA", _lstParametros))
                {
                    laDepcia = new List<clsDepcia>();
                    fLista_Depcia(objDALSQL.Get_dtSet(), "DepciaNoInst");
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

        #region fActualizaDescripDeptos
        /// <summary>
        /// Función que actualiza las descripciones del departamento.
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sDescripLarga">Descripción Larga del departamento</param>
        /// <param name="sDescripCorta">Descripción corta del departamento</param>
        /// <param name="nUsuario">ID del usuario que realiza la operación</param>
        /// <returns>Entero que indica si se realizó correctamente la operación (0 - No, 1 - Si)</returns>
        public int fActualizaDescripDeptos(int nDepcia, string sDescripLarga, string sDescripCorta, int nTipPersonal, int nPuesto, int nCategoria, int nUsuarioResp, int nUsuario)
        {
            int intRespuesta = 0;
            this._lstParametros = new System.Collections.ArrayList();
            ArrayList arrOutput = new ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZA_DESCRIPCION_DEPTOS"));
                _lstParametros.Add(lSQL.CrearParametro("@intDEPCIA", nDepcia));
                _lstParametros.Add(lSQL.CrearParametro("@strDESCRIPCIONLARGA", sDescripLarga));
                _lstParametros.Add(lSQL.CrearParametro("@strDESCRIPCIONCORTA", sDescripCorta));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPUESTORESP", nPuesto));
                _lstParametros.Add(lSQL.CrearParametro("@intTPERRESP", nTipPersonal));
                _lstParametros.Add(lSQL.CrearParametro("@intCATEGORIARESP", nCategoria));
                _lstParametros.Add(lSQL.CrearParametro("@intRESPONSABLE", nUsuarioResp));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nUsuario));
                _lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_DEPCIA", _lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intRespuesta = Convert.ToInt32(arrOutput[0].ToString());
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return intRespuesta;
        }
        #endregion

        #region IDisposable Members
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

    }
}