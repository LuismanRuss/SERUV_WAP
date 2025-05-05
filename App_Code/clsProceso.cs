using System;
using System.Collections.Generic;
using System.Collections;
using System.Web;
using System.Data;
using libFunciones;
using System.Globalization;
using System.Web.Script.Serialization;
using System.ComponentModel;
using System.Threading;

/// <summary>
/// Objetivo:                       Clase para el registro de información de una ER
/// Versión:                        1.0
/// Autor:                          L.I. casí MRT Erik José Enríquez Carmona
/// Fecha de Creación:              25 de Febrero 2013
/// Modificó:                       Edgar Morales González
/// Fecha de última Mod:            13-04-2013
/// Tablas de la BD que utiliza:    APBPARTICIPANTE, APRANEXPART, AWVDEPCIA, APSUSUARIO, APRCORTE, APBPROCESO, APCTIPOPERI, APVANEXO, APVAPARTADO, APVGUIAER
/// </summary>
namespace nsSERUV
{
    public class clsProceso : IDisposable
    {
        #region Propiedades privadas del Objeto
        /// <summary>
        /// Propiedades privadas Erik José Enríquez Carmona
        /// </summary>
        ///
        clsDALSQL _objDALSQL;
        libSQL _libSQL;
        clsValidacion _libFunciones;
        private List<clsNotificacion> _laNotif;
        public List<clsNotificacion> laNotif { get { return _laNotif; } set { _laNotif = value; } }
        private int _idProceso;         // ID del participante
        private string _strDProceso;    // Descripción del proceso
        private string _strEstatus;     // Estado operativo de la ER
        private string _dteFInicio;     // Fecha inicio del proceso ER
        private string _dteFFin;        // Fecha fin del proceso ER
        private string _strAccion;       // Variable que controlará la acción a realizar

        private string _strEXCEPTO;     // Condiciona si el proceso se agregara excluyendo dependencias 0=no 1=si
        private char _cCondicion; // Condición para agregar proceso ordinario
        private string _sDGuiaER;

        private List<clsProceso> _laTipoProceso; //Lista para Tipos de Procesos
        private int _idTipoProc; // ID del Tipo de Proceso
        private string _strDTipoProc; // DEscripcion del Tipo de Proceso     
        private int _idFKGuiaER; // ID de la guia que usara el Proceso
        private int _nFKPuesto; //  Numero de Puesto a Entregar
        private int _nFKDepcia; //  Numero de Dependencia a Entregar
        private string _strProceso; //  Clave del Proceso
        private string _strObservaciones;   //  Observaciones acerca del Proceso
        private string _strOpcion;                  // Variable para manejar la opción CARGA/CONSULTA
        private int _nUsuario;  //  Numero de Usuario que afecta el registro de Proceso
        private char _cIndActivo;   //  Indica si el Proceso esta Activo o Inactivo 
        private char _cIndElim;     //  Indica si el Proceso fue S=Eliminado , N= No eliminado

        private int _idFKMotiProc;  //ID  que especifica el Motivo del Proceso
        private string _strSDMotiProc;  //  Descripcion del Motivo

        private string _strJustExt;     // Justificacion de la creacion del Proceso Extemporaneo
        private string _strAccionExt;   //  Accion que determina si se crea  o no el Proceso Extemporaneo al Crear el Proceso Normal
        private string _dteFExtIni;     //  Fecha de Inicio del Proceso Extemporaneo
        private string _dteFExtFin;     //  Fecha Final del Proceso extemporaneo

        private int _idNotIni;  // ID de la Notificacion Inicial
        private int _nDiasAntNot1;  //Dias Antes de la Notificacion Inicial       
        private string _strAccionNot1;  // Indica la Accion para la Notificacion1

        private string _dteFIniNot;     // Fecha Inicial para la Notificacion Durante el Proceso
        private string _dteFinNot;      // Fecha Final para la Notificacion Durante el Proceso
        private int _idNotProc;         // ID de la Notificacion Durante el Proceso
        private string _strAccionNot2;   // Accion Para la Notificacion Durante el Proceso

        private int _idNotFin;          // ID de la Notificacion antes de Finalizar el ProcesoER
        private int _nDiasAntNot3;      //  Numero de Dias antes de la Notificacion Final
        private string _strAccionNot3;  // Accion Para la Notificacion 3

        private int _idProcesoCreado;    // Id del Proceso Creado
        private int _nTraeCarga;        // Indica si el Proceso Tiene Carga 1=si tiene Carga 0= no tiene Carga
        private int _nAccionFecProc;    // Indica accion en caso de modificar fecha 1= Modificar 0=No Modificar

        private string _strDepcia;
        private string _strPuesto;
        private int _idProcExt;
        private string _strNombre;
        private int _intParticipante;
        private int _intUsuario;
        private string _strsApPaterno;
        private string _strsApMaterno;
        private string _strNomSO;
        private string _strIndSO;
        private string _strIndEOP;


        private int _idNotIniAct;
        private int _idNotProcAct;
        private int _idNotFinAct;

        private int _IDUsuarioSO;
        private int _IDPerfil;


        private List<clsProceso> _laDatosProceso;
        private List<clsProcesoER> _lstProcesosH;
        private List<clsProceso> _laProcExtemporaneo;


        private List<clsParticipante> _lstParticiapantes;   // Listado de particiantes por proceso ER
        /* Para la utilización de la capa de acceso a datos */
        System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros
        //clsDALSQL _objDALSQL;
        //libSQL _libSQL;
        //clsValidacion _libFunciones;
        /****************************************************/

        #endregion

        #region Contructor(es)

        #region clsProceso()
        /// <summary>
        /// Constructor Vacio
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        public clsProceso()
        {
        }
        #endregion

        #region clsProceso(int nIdProceso, string sCveProceso, string sDProceso, string sEstatus, string dFInicio, string dFFin, string sDGuiaER)
        /// <summary>
        /// Constructor utilizado por la clase clsProcesoER en la función pSetPropiedades()
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="nIdProceso">Id del Proceso</param>
        /// <param name="sDProceso">Descripción del proceso</param>
        /// <param name="sEstatus">Estatus del proceso</param>
        /// <param name="dFInicio">Fecha de Inicio del proceso</param>
        /// <param name="dFFin">Fecha Fin del proceso</param>
        /// <param name="dFFin">Descripción de la guía utilizada</param>
        public clsProceso(int nIdProceso, string sCveProceso, string sDProceso, string sEstatus, string dFInicio, string dFFin, string sDGuiaER, string sPuesto)
        {
            this._idProceso = nIdProceso;
            this._strProceso = sCveProceso;
            this._strDProceso = sDProceso;
            this._strEstatus = sEstatus;
            this._dteFInicio = dFInicio;
            this._dteFFin = dFFin;
            this._sDGuiaER = sDGuiaER;
            this._strPuesto = sPuesto;

            this._lstParticiapantes = new List<clsParticipante>();
        }
        #endregion

        #region clsProceso(int nIdProceso, string sDProceso, string sEstatus, string sDGuiaER)
        /// <summary>
        /// Constructor utilizado por la clase clsProcesoER en la función pSetPropiedades()
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="nIdProceso">Id del Proceso</param>
        /// <param name="sDProceso">Descripción del proceso</param>
        /// <param name="sEstatus">Estatus del proceso</param>
        /// <param name="dFFin">Descripción de la guía utilizada</param>
        public clsProceso(int nIdProceso, string sDProceso, string sEstatus, string sDGuiaER)
        {
            this._idProceso = nIdProceso;
            this._strDProceso = sDProceso;
            this._strEstatus = sEstatus;
            this._sDGuiaER = sDGuiaER;

            this._lstParticiapantes = new List<clsParticipante>();
        }
        #endregion


        #endregion 

        #region Procedimientos de Clase

        #region void pSetProcesosH()
        /// <summary>
        /// Procedimiento que asignará las propiedades de los procesos/proceso donde ha participado un usuario
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        private void pSetProcesosH()
        {
            try
            {
                using (this._libFunciones = new clsValidacion()) // Objeto para validaciones
                {
                    if (this._objDALSQL.Get_dtSet() != null && this._objDALSQL.Get_dtSet().Tables.Count > 0) // Se valida que el dataSet contenga datos
                    {
                        if (this._objDALSQL.Get_dtSet().Tables[0] != null)  // Se valida que la tabla 0 contenga datos
                        {
                            this._lstProcesosH = new List<clsProcesoER>();
                            foreach (DataRow drGeneral in this._objDALSQL.Get_dtSet().Tables[0].Rows) // En la tabla 0 contiene los datos del usuario
                            {
                                clsProcesoER objProcesoER = new clsProcesoER();
                                objProcesoER.idUsuario = drGeneral.Table.Columns.Contains("nIdUsuario") ? this._libFunciones.IsNumeric(drGeneral["nIdUsuario"].ToString()) ? int.Parse(drGeneral["nIdUsuario"].ToString()) : 0 : 0;
                                objProcesoER.strNomUsuario = drGeneral.Table.Columns.Contains("nNomUsuario") ? drGeneral["nNomUsuario"].ToString() : string.Empty;

                                if (this._objDALSQL.Get_dtSet().Tables[1] != null) // En la tabla 1 se tiene los datos de los procesos/proceso donde ha participado
                                {
                                    objProcesoER.lstProcesos = new List<clsProceso>();
                                    objProcesoER.lstProcesos.Add(null);
                                    foreach (DataRow dtRow in this._objDALSQL.Get_dtSet().Tables[1].Rows)
                                    {
                                        clsProceso objProceso = new clsProceso(dtRow.Table.Columns.Contains("nIdProceso") ? this._libFunciones.IsNumeric(dtRow["nIdProceso"].ToString()) ? int.Parse(dtRow["nIdProceso"].ToString()) : 0 : 0,
                                                                                dtRow.Table.Columns.Contains("sCveProc") ? dtRow["sCveProc"].ToString() : string.Empty,
                                                                                dtRow.Table.Columns.Contains("sDCProceso") ? dtRow["sDCProceso"].ToString() : string.Empty,
                                                                                dtRow.Table.Columns.Contains("sEstadoP") ? dtRow["sEstadoP"].ToString() : string.Empty,
                                                                                dtRow.Table.Columns.Contains("dFInicio") ? this._libFunciones.IsDate(dtRow["dFInicio"].ToString()) ? DateTime.Parse(dtRow["dFInicio"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty,
                                                                                dtRow.Table.Columns.Contains("dFFinal") ? this._libFunciones.IsDate(dtRow["dFFinal"].ToString()) ? DateTime.Parse(dtRow["dFFinal"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty,
                                                                                dtRow.Table.Columns.Contains("sDGuia") ? dtRow["sDGuia"].ToString() : string.Empty,
                                                                                dtRow.Table.Columns.Contains("sDPerfil") ? dtRow["sDPerfil"].ToString() : string.Empty
                                                                                );
                                        objProceso = objProcesoER.pGetParticipantes(this._objDALSQL.Get_dtSet(), objProceso); // Se consulta los participantes(dependencias) en donde esta participando el usuarios
                                        objProcesoER.lstProcesos.Add(objProceso); // Se agregan el/los proceso(s)
                                    }
                                }

                                this._lstProcesosH.Add(objProcesoER); // Se agrega el objeto que contiene toda la información que es necesaría para poder desplegar el/los procesos donde ha participado un usuario 
                            }
                        }
                    }
                }
            }
            catch
            {
                this._laDatosProceso = null;
            }
            finally
            {
                this._objDALSQL.Get_dtSet().Dispose();
            }
        }
        #endregion

        #region void fGetProcesosH()
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// Función que regresará los procesos historicos/actuales en los que participa un usuario
        /// </summary>
        public void fGetProcesosH()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._nUsuario));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDPROCESO", this._idProceso));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion.Trim()));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_MONITOREO", this._lstParametros))
                    {
                        pSetProcesosH();  // Se asigna la información necesaría que contiene el/los proceso(s) donde ha participado un usuario
                    }
                }
            }
        }
        #endregion

        #region fObtener_Sujeto_Obligado_Dependencia
        /// <summary>
        /// Procedimiento que obtiene el sujeto obligado de una dependencia y un proceso
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="depcia">Identificador de la dependencia</param>
        /// <param name="proceso">Identificador del proceso</param>
        /// <returns>Regresa los datos del sujeto obligado</returns>
        public bool fObtener_Sujeto_Obligado_Dependencia(int depcia, int proceso)
        {
            bool blnRespuesta = false;
            string strACCION = "OBTENER_SUJETO_DEP_PROCES";
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", proceso));
                _lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", depcia));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    string op = "SujetoObligado";
                    laTipoProceso = new List<clsProceso>();
                    fLista_TipoProceso(objDALSQL.Get_dtSet(), op);
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

        #region fObterner_TipoProceso
        /// <summary>
        /// Función que obtiene el sujeto obligado de una dependencia y un proceso
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="strACCION">Indica la acción que se realizara en el procedimiento almacenado</param>
        /// <returns>Regresa los datos de los tipos de proceso, se apoya en el metodo pLista_Puesto</returns>

        public bool fObtener_TipoProceso(string strACCION)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    string op = "TipoProceso";
                    laTipoProceso = new List<clsProceso>();
                    fLista_TipoProceso(objDALSQL.Get_dtSet(), op);
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

        #region fLista_TipoProceso
        /// <summary>
        /// Función que devuelve una lista con información acerca de los tipos de procesos
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="op">Indica la acción que se realizara en el procedimiento almacenado</param>
        /// <returns>Regresa los datos de los tipos de proceso</returns>

        private void fLista_TipoProceso(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "TipoProceso":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso tipoProc = new clsProceso();
                                tipoProc.idTipoProc = Convert.ToInt32(row["idTipoProc"].ToString());
                                tipoProc.strDTipoProc = row["sDTipoProc"].ToString();

                                laTipoProceso.Add(tipoProc);

                            }
                            break;
                        case "ProcesoActivo":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso tipoProc = new clsProceso();
                                tipoProc.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                tipoProc.strDProceso = row["sDProceso"].ToString();

                                laTipoProceso.Add(tipoProc);

                            }
                            break;
                        case "SujetoObligado":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso SujetoProc = new clsProceso();
                                SujetoProc.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                SujetoProc.intParticipante = Convert.ToInt32(row["idParticipante"].ToString());
                                SujetoProc.intUsuario = Convert.ToInt32(row["idFKUsuario"].ToString());
                                SujetoProc.strNombre = row["sNombre"].ToString();
                                SujetoProc.strsApPaterno = row["sApPaterno"].ToString();
                                SujetoProc.strsApMaterno = row["sApMaterno"].ToString();
                                SujetoProc.nFKDepcia = Convert.ToInt32(row["nFKDepcia"].ToString());

                                laTipoProceso.Add(SujetoProc);
                            }
                            break;
                        case "OBTENER_PROCESO_POR_USU":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso tipoProc = new clsProceso();

                                tipoProc.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                tipoProc.strDProceso = row["sDProceso"].ToString();

                                laTipoProceso.Add(tipoProc);

                            }
                            break;
                        case "OBTENER_PROCESO_POR_USU_SE":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso tipoProc = new clsProceso();

                                tipoProc.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                tipoProc.strDProceso = row["sDProceso"].ToString();

                                laTipoProceso.Add(tipoProc);

                            }
                            break;
                        case "ProcesoUsuarioSO":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso tipoProc = new clsProceso();
                                tipoProc.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                tipoProc.strDProceso = row["sDProceso"].ToString();
                                laTipoProceso.Add(tipoProc);

                            }
                            break;
                        case "ProcesosUsuario":
                            laTipoProceso = new List<clsProceso>();
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsProceso objProceso = new clsProceso();

                                objProceso.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                                objProceso.strDProceso = row["sDProceso"].ToString();
                                objProceso.strProceso = row["sProceso"].ToString();

                                laTipoProceso.Add(objProceso);

                            }
                            break;
                    }
                }
                else

                    laTipoProceso = null;
            }
            catch
            {

                laTipoProceso = null;

            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fObtener_ProcesoActivo
        public bool fObtener_ProcesoActivo(string strACCION)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    string op = "ProcesoActivo";
                    laTipoProceso = new List<clsProceso>();
                    fLista_TipoProceso(objDALSQL.Get_dtSet(), op);
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

        #region fObtener_ProcesoUsuario_SO
        /// <summary>
        /// Procedimiento que obtiene los procesos en base a un sujeto obligado
        /// Autor: Ma. Guadalupe Dominguez Julián 
        /// </summary>
        /// <param name="strACCION">Acción a realizar en el procedimiento almacenado</param>
        /// <param name="intIdSujetoOb">Identificador de sujeto obligado</param>
        /// <returns>regresa una lista de procesos</returns>
        public bool fObtener_ProcesoUsuario_SO(string strACCION, int intIdSujetoOb)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intIdSujetoOb));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    string op = "ProcesoUsuarioSO";
                    laTipoProceso = new List<clsProceso>();
                    fLista_TipoProceso(objDALSQL.Get_dtSet(), op);
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

        #region fObtener_ProcesoUsuario
        /// <summary>
        /// Procedimiento que obtiene los procesos de un sujeto obligado en base a un usuario
        /// Autor: Ma. Guadalupe Dominguez Julián  
        /// </summary>
        /// <param name="strACCION">Acción a realizar el procedimiento almacenado</param>
        /// <param name="intIdSujetoOb">Identificador de usuario</param>
        /// <returns>Datos del sujeto obligado y del usuario logueado</returns>
        public bool fObtener_ProcesoUsuario(string strACCION, int intIdSujetoOb)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intIdSujetoOb));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    string op = strACCION;
                    laTipoProceso = new List<clsProceso>();
                    fLista_TipoProceso(objDALSQL.Get_dtSet(), op);
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

        #region fCreaProceso 
        /// <summary>
        /// Procedimiento que recibe un objeto json con información de un proceso, lo recorre e inserta un nuevo proceso en la BD (APBPROCESO)
        /// Autor: Edgar Morales González
        /// </summary>
        /// <returns>regresa un booleano que indica si el proceso fue creado correctamente o no</returns>
        public bool fCreaProceso(clsProceso objProceso)
        {
            bool blnRespuesta = false;

            try
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    using (clsDALSQL objDALSQL = new clsDALSQL(false))
                    {
                        libSQL lSQL = new libSQL();

                        _lstParametros.Add(lSQL.CrearParametro("@strACCION", objProceso.strAccion));
                        _lstParametros.Add(lSQL.CrearParametro("@intIDFKGUIAER", objProceso.idFKGuiaER));
                        _lstParametros.Add(lSQL.CrearParametro("@intIDFKTIPOPROC", objProceso.idTipoProc));
                        _lstParametros.Add(lSQL.CrearParametro("@intNFKPUESTO", objProceso.nFKPuesto));
                        _lstParametros.Add(lSQL.CrearParametro("@intNFKDEPCIA", objProceso.nFKDepcia));
                        _lstParametros.Add(lSQL.CrearParametro("@strSPROCESO", objProceso.strProceso));
                        _lstParametros.Add(lSQL.CrearParametro("@strSDPROCESO", objProceso.strDProceso));
                        _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", objProceso.idProceso));

                        //Convierte los strings con las fechas del proceso al formato necesario para insertarlo en la BD
                        objProceso.dteFInicio = (objValidacion.IsDate(objValidacion.ConvertDatePicker(objProceso.dteFInicio)) ? DateTime.Parse(objValidacion.ConvertDatePicker(objProceso.dteFInicio)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                        objProceso.dteFFin = (objValidacion.IsDate(objValidacion.ConvertDatePicker(objProceso.dteFFin)) ? DateTime.Parse(objValidacion.ConvertDatePicker(objProceso.dteFFin)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));

                        _lstParametros.Add(lSQL.CrearParametro("@dteDFINICIO", objProceso.dteFInicio));
                        _lstParametros.Add(lSQL.CrearParametro("@dteDFFINAL", objProceso.dteFFin));
                        _lstParametros.Add(lSQL.CrearParametro("@strSOBSERVACIONES", objProceso.strObservaciones));
                        _lstParametros.Add(lSQL.CrearParametro("@chrCESTATUS", objProceso.strEstatus));
                        _lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", objProceso.nUsuario));
                        _lstParametros.Add(lSQL.CrearParametro("@chrCINDACTIVO", objProceso.cIndActivo));

                        _lstParametros.Add(lSQL.CrearParametro("@chrCONDICION", objProceso.cCondicion));
                        _lstParametros.Add(lSQL.CrearParametro("@strEXCEPTO", objProceso.strEXCEPTO));
                        _lstParametros.Add(lSQL.CrearParametro("@chrCINDELIM", objProceso.cIndElim));

                        objProceso.dteFExtIni = (objValidacion.IsDate(objValidacion.ConvertDatePicker(objProceso.dteFExtIni)) ? DateTime.Parse(objValidacion.ConvertDatePicker(objProceso.dteFExtIni)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                        objProceso.dteFExtFin = (objValidacion.IsDate(objValidacion.ConvertDatePicker(objProceso.dteFExtFin)) ? DateTime.Parse(objValidacion.ConvertDatePicker(objProceso.dteFExtFin)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));

                        _lstParametros.Add(lSQL.CrearParametro("@dteDFINICIOEXT", objProceso.dteFExtIni));
                        _lstParametros.Add(lSQL.CrearParametro("@dteDFFINALEXT", objProceso.dteFExtFin));
                        _lstParametros.Add(lSQL.CrearParametro("@strSJUSTEXT", objProceso.strJustExt));
                        _lstParametros.Add(lSQL.CrearParametro("@strACCIONEXT", objProceso.strAccionExt));

                        _lstParametros.Add(lSQL.CrearParametro("@strACCIONFECHPROC", objProceso.nAccionFecProc));

                        _lstParametros.Add(lSQL.CrearParametro("@intIDFKNOT1", objProceso.idNotIni));
                        _lstParametros.Add(lSQL.CrearParametro("@intNDIASANTINIPROC", objProceso.nDiasAntNot1));
                        _lstParametros.Add(lSQL.CrearParametro("@strACCIONNOT1", objProceso.strAccionNot1));

                        objProceso.dteFIniNot = (objValidacion.IsDate(objValidacion.ConvertDatePicker(objProceso.dteFIniNot)) ? DateTime.Parse(objValidacion.ConvertDatePicker(objProceso.dteFIniNot)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                        objProceso.dteFinNot = (objValidacion.IsDate(objValidacion.ConvertDatePicker(objProceso.dteFinNot)) ? DateTime.Parse(objValidacion.ConvertDatePicker(objProceso.dteFinNot)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));

                        _lstParametros.Add(lSQL.CrearParametro("@intIDFKNOT2", objProceso.idNotProc));
                        _lstParametros.Add(lSQL.CrearParametro("@dteDFINIPROC", objProceso.dteFIniNot));
                        _lstParametros.Add(lSQL.CrearParametro("@dteDFFINPROC", objProceso.dteFinNot));
                        _lstParametros.Add(lSQL.CrearParametro("@strACCIONNOT2", objProceso.strAccionNot2));

                        _lstParametros.Add(lSQL.CrearParametro("@intIDFKNOT3", objProceso.idNotFin));
                        _lstParametros.Add(lSQL.CrearParametro("@intNDIASANTFINPROC", objProceso.nDiasAntNot3));
                        _lstParametros.Add(lSQL.CrearParametro("@strACCIONNOT3", objProceso.strAccionNot3));
                        _lstParametros.Add(lSQL.CrearParametro("@intIDFKMOTIPROC", objProceso.idFKMotiProc));

                        System.Collections.ArrayList arrOUT = new ArrayList();
                        _lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                        _lstParametros.Add(lSQL.CrearParametro("@intIDULTPROC", 0, SqlDbType.Int, ParameterDirection.Output));

                        if (objDALSQL.ExecQuery_OUT("PA_IDUH_PROCESOER", _lstParametros))
                        {
                            arrOUT = objDALSQL.Get_aOutput();
                            blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);

                            if (blnRespuesta == true)
                            {
                                if (objProceso.strAccion == "INSERTAR_PROCESO")
                                {
                                    objProceso.idProcesoCreado = int.Parse(arrOUT[1].ToString());

                                    //Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                                    Thread tins = new Thread(() => fDatosNotCreaProceso(idProcesoCreado));
                                    tins.Start();
                                }
                                else if (objProceso.strAccion == "ACTUALIZAR_PROC")
                                {
                                    if (objProceso.strAccionExt == "1" || objProceso.nAccionFecProc == 1)
                                    {
                                        //Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                                        Thread tmod = new Thread(() => fDatosNotModProceso(idProceso, objProceso.strAccionExt, objProceso.nAccionFecProc));
                                        tmod.Start();

                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
            }
            return blnRespuesta;
        }
        #endregion

        #region fDatosNotCreaProceso
        /// <summary>
        /// Función que traerá los datos para generar la notificación cuando se modifican las fechas de un proceso
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="idProcesoCreado">ID del proceso que acaba de ser creado</param>
        public void fDatosNotCreaProceso(int idProcesoCreado)
        {
            bool blnRespuesta = false;
            int a = idProcesoCreado;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strOPCION", "NUEVO_PROCESO"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", idProcesoCreado));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", _lstParametros))
                {
                    DataSet ds = objDALSQL.Get_dtSet();                     //  DataSet que almacenará la información necesaria para enviar la notificación correspondiente
                    string dato = clsJsonMethods.ConvertDataSetToXML(ds);   //  string que almacenará el XML 

                    clsWSNotif wsNotif = new clsWSNotif();                  //  Crea un objeto que se usará para la comunicación con la clase del WebService
                    wsNotif.SendNotif(dato, "NUEVO_PROCESO");
                }
                else
                {
                }
            }
        }
        #endregion

        #region fDatosNotModProceso
        /// <summary>
        /// Función que traerá los datos para generar la notificación cuando se modifican las fechas de un proceso
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="idProcesoCreado">ID del proceso que acaba de ser creado</param>
        /// <param name="strAccionExt">Acción que indica si se afectaron las fechas extemporaneas del proceso</param>
        /// <param name="nAccionFecProc">Acción que indica si las fechas del proceso se modificaron</param>
        public void fDatosNotModProceso(int idProcesoCreado, string strAccionExt, int nAccionFecProc)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strOPCION", "MOD_PROCESO"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", idProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", _lstParametros))
                {
                    DataSet ds = objDALSQL.Get_dtSet();                         //  DataSet que almacenará la información necesaria para enviar la notificación correspondiente
                    string dato = clsJsonMethods.ConvertDataSetToXML(ds);       //  string que almacenará el XML 

                    clsWSNotif wsNotif = new clsWSNotif();                      //  Crea un objeto que se usará para la comunicación con la clase del WebService

                    if (nAccionFecProc == 1)
                    {
                        wsNotif.SendNotif(dato, "MODIFICAR_FEC_PROCESO");
                    }
                    if (strAccionExt == "1")
                    {
                        wsNotif.SendNotif(dato, "MODIFICAR_PROCESO_EXT");
                    }
                }
                else
                {
                }
            }
        }
        #endregion

        #region fGetDatosProceso
        /// <summary>
        /// Función que traerá los datos de un  proceso
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="nIdProceso">ID del proceso a consultar</param>
        /// <returns>Regresa la información del proceso que se consulta, apoyandose en la función fLista_Proceso</returns>
        public bool fGetDatosProceso(int nIdProceso)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_DATOS_PROCESO"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    laDatosProceso = new List<clsProceso>();
                    laNotif = new List<clsNotificacion>();
                    fLista_Proceso(objDALSQL.Get_dtSet());
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fLista_Proceso
        /// <summary>
        /// Función que llena dos listas para mostrar los datos de un  proceso y las notificaciones asociadas al mismo
        /// Autor: Edgar Morales González
        /// </summary>
        /// <returns>Regresa la información del proceso que se consulta, apoyandose en la función fLista_Proceso</returns>
        private void fLista_Proceso(DataSet dataset)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    string sFi, sFf, sFIniExt, sFFinExt = "";
                    string cCons = "";
                    string idMotProc = "";

                    foreach (DataRow row in dataset.Tables[0].Rows)             //Recorre una tabla y llena una lista con los datos del proceso
                    {
                        clsProceso LiDatosProc = new clsProceso();
                        LiDatosProc.idProceso = Convert.ToInt32(row["idProceso"].ToString());
                        LiDatosProc.strProceso = row["sProceso"].ToString();
                        LiDatosProc.nFKDepcia = Convert.ToInt32(row["nFKDepcia"].ToString());
                        LiDatosProc.strDepcia = row["sDDepcia"].ToString();
                        LiDatosProc.nFKPuesto = Convert.ToInt32(row["nFKPuesto"].ToString());
                        LiDatosProc.strPuesto = row["sDPuesto"].ToString();
                        LiDatosProc.strDProceso = row["sDProceso"].ToString();
                        LiDatosProc.idFKGuiaER = Convert.ToInt32(row["idGuiaER"].ToString());
                        LiDatosProc.sDGuiaER = row["sDGuiaER"].ToString();
                        LiDatosProc.idTipoProc = Convert.ToInt32(row["idFKTipoProc"].ToString());
                        LiDatosProc.strDTipoProc = row["sDTipoProc"].ToString();

                        idMotProc = row["idFKMotiProc"].ToString();
                        if (idMotProc != "" && idMotProc != null)
                        {
                            LiDatosProc.idFKMotiProc = Convert.ToInt32(idMotProc);
                        }


                        sFi = row["dFInicio"].ToString();
                        LiDatosProc.dteFInicio = DateTime.Parse(sFi).ToString("dd-MM-yyyy");

                        sFf = row["dFFinal"].ToString();
                        LiDatosProc.dteFFin = DateTime.Parse(sFf).ToString("dd-MM-yyyy");
                        LiDatosProc.strObservaciones = row["sObservaciones"].ToString();

                        cCons = row["cConsideracion"].ToString();
                        if (cCons != "" && cCons != null)
                        {
                            LiDatosProc.cCondicion = Convert.ToChar(cCons);
                        }

                        ///---ext
                        if (row["dFFInicioEX"].ToString() != "")
                        {
                            sFIniExt = row["dFFInicioEX"].ToString();
                            LiDatosProc.dteFExtIni = DateTime.Parse(sFIniExt).ToString("dd-MM-yyyy");
                        }
                        if (row["dFFinalEX"].ToString() != "")
                        {
                            sFFinExt = row["dFFinalEX"].ToString();

                            LiDatosProc.dteFExtFin = DateTime.Parse(sFFinExt).ToString("dd-MM-yyyy");
                        }
                        if (row["sJustificacion"].ToString() != "")
                        {
                            LiDatosProc.strJustExt = row["sJustificacion"].ToString();
                        }///----ext 
                        //////

                        if (dataset.Tables[2].Rows.Count == 0)
                        {
                            LiDatosProc.nTraeCarga = 0;
                        }
                        else if (dataset.Tables[2] != null && dataset.Tables[2].Rows.Count > 0)
                        {
                            foreach (DataRow row3 in dataset.Tables[2].Rows)
                            {
                                LiDatosProc.nTraeCarga = Convert.ToInt32(row3["idProceso"].ToString());
                            }
                        }

                        //////////


                        laDatosProceso.Add(LiDatosProc);
                    }

                    foreach (DataRow row in dataset.Tables[1].Rows)     //Se recorre una tabla para llenar una lista que devolvera las notificaciones
                    {
                        clsNotificacion LiDatosNot = new clsNotificacion();
                        string dAntes, fIniNot, fFinNot, cInd = "";
                        /////////////////
                        string cTipoNot = "";
                        ///////////////////
                        if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                        {
                        }
                        else
                        {
                            LiDatosNot.idNotifica = Convert.ToInt32(row["idNotifica"].ToString());
                            LiDatosNot.strAsunto = row["sAsunto"].ToString();

                            dAntes = row["nDiasAntes"].ToString();
                            if (dAntes != "")
                            {
                                LiDatosNot.nDiasAntes = Convert.ToInt32(row["nDiasAntes"].ToString());
                            }
                            fIniNot = row["dFIniProc"].ToString();
                            if (fIniNot != "")
                            {
                                LiDatosNot.strDFIniProc = DateTime.Parse(fIniNot).ToString("dd-MM-yyyy");
                            }
                            fFinNot = row["dFFinProc"].ToString();
                            if (fFinNot != "")
                            {
                                LiDatosNot.strDFFinProc = DateTime.Parse(fFinNot).ToString("dd-MM-yyyy");
                            }

                            cInd = row["cIndActivo"].ToString();
                            LiDatosNot.cIndActivo = Convert.ToChar(cInd);

                            cTipoNot = row["cTipNotifica"].ToString();
                            if (cTipoNot != "" && cTipoNot != null)
                            {
                                LiDatosNot.cTipoNot = Convert.ToChar(cTipoNot);
                            }
                            laNotif.Add(LiDatosNot);
                        }
                    }
                }
                else
                {
                    laDatosProceso = null;
                    laNotif = null;
                }
            }
            catch (Exception ex)
            {
                laDatosProceso = null;
                mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fLista_DatosProceso
        /// <summary>
        /// Función que regresa una lista con los datos de los participantes asociados a un proceso ya existente
        /// Autor: Edgar Morales González
        /// </summary>
        private void fLista_DatosProceso(DataSet dataset)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    laDatosProceso.Add(null);
                    foreach (DataRow row in dataset.Tables[0].Rows)
                    {
                        clsProceso DatosProc = new clsProceso();
                        DatosProc.nFKDepcia = Convert.ToInt32(row["nFKDepcia"].ToString());
                        DatosProc.nFKPuesto = Convert.ToInt32(row["nFKPuesto"].ToString());
                        DatosProc.strProceso = row["sProceso"].ToString();

                        laDatosProceso.Add(DatosProc);
                    }
                }
                else
                {
                    laDatosProceso = null;
                }
            }
            catch (Exception ex)
            {
                laDatosProceso = null;
                mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fVerifPart
        /// <summary>
        /// Función usada para verificar si los participantes que se incluirán en un proceso se encuentran activos en otro proceso existente
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="nDepcia">Número del dependencia</param>
        /// <param name="nPuesto">Número del puesto</param>
        /// <param name="tipoProc">Id del tipo de proceso</param>
        /// <returns>Regresa datos de los participantes que estan asociados a un proceso</returns>
        /// 
        public bool fVerifPart(int nPuesto, int nDepcia, int tipoProc)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                this._lstParametros = new System.Collections.ArrayList();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "VERIF_PART"));
                _lstParametros.Add(lSQL.CrearParametro("@nFKPuesto", nPuesto));
                _lstParametros.Add(lSQL.CrearParametro("@nFKDepcia", nDepcia));
                _lstParametros.Add(lSQL.CrearParametro("@TIPOPROC", tipoProc));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {
                    laDatosProceso = new List<clsProceso>();
                    fLista_DatosProceso(objDALSQL.Get_dtSet());
                }

            }
            return blnRespuesta;
        }
        #endregion

        #region fVerificaProcesoActivo
        /// <summary>
        /// Procedimiento que regresa si el usuario tiene un proceso activo
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nidProceso">Id del proceso</param>
        /// <returns>Entero que indica si el usuario se encuentra en un proceso activo</returns>
        public int fVerificaProcesoActivo(int nidProceso)
        {
            int intRespuesta = 0;
            ArrayList arrOutput;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                this._lstParametros = new System.Collections.ArrayList();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "PROCESO_ACTIVO"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nidProceso));
                _lstParametros.Add(lSQL.CrearParametro("@intExiste", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_SELU_PROCESO", _lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intRespuesta = int.Parse(arrOutput[0].ToString());
                }
            }
            return intRespuesta;
        }
        #endregion

        #region fGeneraCodigo (Función que regresa el codigo generado en la BD para crear un nuevo proceso)
        /// <summary>
        /// Objetivo:   Función usada para regresar el código para el nuevo proceso que se va a crear
        /// Autor:      Edgar Morales González
        /// </summary>
        /// <returns>Regresa el código generado en la BD para el nuevo proceso que se va a crear</returns>
        public bool fGeneraCodigo()
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "GENERA_CODIGO"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", _lstParametros))
                {

                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        clsProceso LiDatosProc = new clsProceso();
                        laDatosProceso = new List<clsProceso>();
                        objDALSQL.Get_dtSet();
                        DataRow drGeneral = objDALSQL.Get_dtSet().Tables[0].Rows[0];
                        LiDatosProc.strProceso = drGeneral.Table.Columns.Contains("strCodigo") ? drGeneral["strCodigo"].ToString() : "";

                        laDatosProceso.Add(LiDatosProc);
                    }
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region fGetCargaProceso()
        /// <summary>
        /// Procedimiento que obtiene los archivos cargados de un proceso
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="idUsuario">Id del usuario</param>
        /// <returns>Dataset con la información de los archivos cargados en el proceso</returns>
        public DataSet fGetCargaProceso(int idUsuario)
        {
            DataSet dtsProceso = new DataSet();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", this._idProceso));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", this.intParticipante));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));  // Id del Usuario
                _lstParametros.Add(lSQL.CrearParametro("@strOPCION", this._strOpcion));
                if (objDALSQL.ExecQuery_SET("PA_SELV_EXPORTARER", _lstParametros))
                {
                    dtsProceso = objDALSQL.Get_dtSet();
                    //laRegresaDatos = new List<clsUsuario>();
                    //pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return dtsProceso;
        }
        #endregion


        #region fObtieneProcesosUsuario
        /// <summary>
        /// Función que obtiene los procesos activos en que participa un usuario
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="sCuenta">Cuenta institucional del usuario</param>
        /// <returns>Boleano indicado si se realizó la acción</returns>
        public bool fObtieneProcesosUsuario(string sCuenta)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTIENE_PROCESOS"));
                _lstParametros.Add(lSQL.CrearParametro("@strCUENTA", sCuenta));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_SET("PA_SELU_USUARIO", _lstParametros))
                {
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        fLista_TipoProceso(objDALSQL.Get_dtSet(), "ProcesosUsuario");
                        blnRespuesta = true;
                    }
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

        #endregion

        #region GETs y SETs
        /// <summary>
        /// Propiedades publicas Erik José Enríquez Carmona
        /// </summary>
        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }             // ID del participante
        public string strDProceso { get { return _strDProceso; } set { _strDProceso = value; } }    // Descripción del proceso
        public string dteFInicio { get { return _dteFInicio; } set { _dteFInicio = value; } }       // Fecha inicio del proceso ER
        public string dteFFin { get { return _dteFFin; } set { _dteFFin = value; } }                // Fecha fin del proceso ER
        public string strEstatus { get { return _strEstatus; } set { _strEstatus = value; } }       // Estado operativo de la ER
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }          // Variable que controlará la acción a realizar
        public string strOpcion { get { return _strOpcion; } set { _strOpcion = value; } }          // Variable que controlará la opción a realizar
        public List<clsParticipante> lstParticipantes { get { return _lstParticiapantes; } set { _lstParticiapantes = value; } }    // Listado de particiantes por proceso ER

        public List<clsProceso> laTipoProceso { get { return _laTipoProceso; } set { _laTipoProceso = value; } }    //Lista que Mostrara los Tipos de Procesos
        public int idTipoProc { get { return _idTipoProc; } set { _idTipoProc = value; } }  // ID del Tipo de Proceso
        public string strDTipoProc { get { return _strDTipoProc; } set { _strDTipoProc = value; } } //  Descripcion del Tipo de Proceso
        public int idFKGuiaER { get { return _idFKGuiaER; } set { _idFKGuiaER = value; } } //  ID de la guia que usara el Proceso
        public int nFKPuesto { get { return _nFKPuesto; } set { _nFKPuesto = value; } }    //  Numero de Puesto a Entregar
        public int nFKDepcia { get { return _nFKDepcia; } set { _nFKDepcia = value; } }  //  Numero de Dependencia a Entregar
        public string strProceso { get { return _strProceso; } set { _strProceso = value; } }   //  Clave del Proceso
        public string strObservaciones { get { return _strObservaciones; } set { _strObservaciones = value; } }  //  Observaciones acerca del Proceso
        public int nUsuario { get { return _nUsuario; } set { _nUsuario = value; } }   //  Numero de Usuario que afecta el registro de Proceso
        public char cIndActivo { get { return _cIndActivo; } set { _cIndActivo = value; } }// Indica si el Proceso esta Activo o Inactivo
        public char cIndElim { get { return _cIndElim; } set { _cIndElim = value; } }    //  Indica si el Proceso fue S=Eliminado , N= No eliminado

        public int idFKMotiProc { get { return _idFKMotiProc; } set { _idFKMotiProc = value; } }        // Id del Motivo del Proceso
        public string strSDMotiProc { get { return _strSDMotiProc; } set { _strSDMotiProc = value; } }   //  Descripcion del Motivo

        public string strIndSO { get { return _strIndSO; } set { _strIndSO = value; } }
        public string strIndEOP { get { return _strIndEOP; } set { _strIndEOP = value; } }

        public string dteFExtIni { get { return _dteFExtIni; } set { _dteFExtIni = value; } }          //  Fecha de Inicio del Proceso Extemporaneo     
        public string dteFExtFin { get { return _dteFExtFin; } set { _dteFExtFin = value; } }          //  Fecha Final del Proceso extemporaneo
        public string strJustExt { get { return _strJustExt; } set { _strJustExt = value; } }          // Justificacion de la creacion del Proceso Extemporaneo
        public string strAccionExt { get { return _strAccionExt; } set { _strAccionExt = value; } }    //  Accion que determina si se crea  o no el Proceso Extemporaneo al Crear el Proceso Normal

        public int idNotIni { get { return _idNotIni; } set { _idNotIni = value; } }   // ID de la Notificacion Inicial
        public int nDiasAntNot1 { get { return _nDiasAntNot1; } set { _nDiasAntNot1 = value; } }  //Dias Antes de la Notificacion Inicial
        public string strAccionNot1 { get { return _strAccionNot1; } set { _strAccionNot1 = value; } } // Indica la Accion para la Notificacion1

        public string dteFIniNot { get { return _dteFIniNot; } set { _dteFIniNot = value; } }
        public string dteFinNot { get { return _dteFinNot; } set { _dteFinNot = value; } }
        public int idNotProc { get { return _idNotProc; } set { _idNotProc = value; } }
        public string strAccionNot2 { get { return _strAccionNot2; } set { _strAccionNot2 = value; } }


        public int idNotFin { get { return _idNotFin; } set { _idNotFin = value; } }                      // ID de la Notificacion antes de Finalizar el ProcesoER
        public int nDiasAntNot3 { get { return _nDiasAntNot3; } set { _nDiasAntNot3 = value; } }          //  Numero de Dias antes de la Notificacion Final
        public string strAccionNot3 { get { return _strAccionNot3; } set { _strAccionNot3 = value; } }    // Accion Para la Notificacion 3
        public List<clsProceso> laDatosProceso { get { return _laDatosProceso; } set { _laDatosProceso = value; } }
        public string strEXCEPTO { get { return _strEXCEPTO; } set { _strEXCEPTO = value; } }
        public string mensaje { get; set; }
        public string sDGuiaER { get { return _sDGuiaER; } set { _sDGuiaER = value; } }

        public string strDepcia { get { return _strDepcia; } set { _strDepcia = value; } }
        public string strPuesto { get { return _strPuesto; } set { _strPuesto = value; } }
        public int idProcExt { get { return _idProcExt; } set { _idProcExt = value; } }
        public int intParticipante { get { return _intParticipante; } set { _intParticipante = value; } }
        public string strNombre { get { return _strNombre; } set { _strNombre = value; } }
        public string strsApPaterno { get { return _strsApPaterno; } set { _strsApPaterno = value; } }
        public string strsApMaterno { get { return _strsApMaterno; } set { _strsApMaterno = value; } }
        public string strNomSO { get { return _strNomSO; } set { _strNomSO = value; } }
        public int intUsuario { get { return _intUsuario; } set { _intUsuario = value; } }


        public List<clsProceso> laProcExtemporaneo { get { return _laProcExtemporaneo; } set { _laProcExtemporaneo = value; } }

        public int idNotIniAct { get { return _idNotIniAct; } set { _idNotIniAct = value; } }
        public int idNotProcAct { get { return _idNotProcAct; } set { _idNotProcAct = value; } }
        public int idNotFinAct { get { return _idNotFinAct; } set { _idNotFinAct = value; } }
        public int IDUsuarioSO { get { return _IDUsuarioSO; } set { _IDUsuarioSO = value; } }
        public int IDPerfil { get { return _IDPerfil; } set { _IDPerfil = value; } }

        public char cCondicion { get { return _cCondicion; } set { _cCondicion = value; } }   //Condiciona la creacion del proceso U=Unica Dependencia, D= Con sus Dependencias /entidades a cargo, N=No aplica

        public int idProcesoCreado { get { return _idProcesoCreado; } set { _idProcesoCreado = value; } }
        public int nTraeCarga { get { return _nTraeCarga; } set { _nTraeCarga = value; } }
        public int nAccionFecProc { get { return _nAccionFecProc; } set { _nAccionFecProc = value; } }

        public List<clsProcesoER> lstProcesosH { get { return _lstProcesosH; } set { _lstProcesosH = value; } }
        #endregion
    }
}