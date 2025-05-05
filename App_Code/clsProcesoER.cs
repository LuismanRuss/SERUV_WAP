using System;
using System.Collections.Generic;
using System.Web;
using libFunciones;
using System.Data;
using System.Threading;

/// Objetivo:                       
/// Versión:                        1.0
/// Autor:                          L.I. Jesús Montero Cuevas , casí MRT Erik José Enríquez Carmona
/// Fecha de Creación:              22 de Febrero 2013
/// Modificó:                       Jesús Montero Cuevas 9/Marzo/2013
/// Fecha de última Mod:            05 de Marzo 2013 4:50 pm
/// Tablas de la BD que utiliza:    APBPARTICIPANTE, AWVDEPCIA, APBPROCESO, APRPARTAPLIC, APRAPLICDEPCIA, APEAPLICA, APRANEXAPLIC, APVANEXO, APRAPARANEX, APVAPARTADO, APRGUIAPART

namespace nsSERUV
{
    public class clsProcesoER : IDisposable
    {
        #region VARIABLES GLOBALES DE LA CLASE

        #region //--JESÚS MONTERO CUEVAS---
        System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
        bool blnRespuesta = false;
        private List<clsProcesoER> _laPeriodosEntrega;
        public List<clsProcesoER> laRegresaDatos { get { return _laPeriodosEntrega; } set { _laPeriodosEntrega = value; } }
        private List<clsDepcia> _laDependencias;
        public List<clsDepcia> laDependencias { get { return _laDependencias; } set { _laDependencias = value; } }
        private List<clsDepcia> _laParticipantes;
        public List<clsDepcia> laParticipantes { get { return _laParticipantes; } set { _laParticipantes = value; } }
        private List<clsDepcia> _laDepcias;
        public List<clsDepcia> laDepcias { get { return _laDepcias; } set { _laDepcias = value; } }
        private List<clsProcesoER> _laRegresaDatos2;
        public List<clsProcesoER> laRegresaDatos2 { get { return _laRegresaDatos2; } set { _laRegresaDatos2 = value; } }
        private List<clsProcesoER> _laCargaPart;
        public List<clsProcesoER> laCargaPart { get { return _laCargaPart; } set { _laCargaPart = value; } }
        private List<clsProcesoER> _laProcPorSujObl;
        public List<clsProcesoER> laProcPorSujObl { get { return _laProcPorSujObl; } set { _laProcPorSujObl = value; } }
        private List<clsProcesoER> _laDepSujObl;
        public List<clsProcesoER> laDepSujObl { get { return _laDepSujObl; } set { _laDepSujObl = value; } }
        private List<clsProcesoER> _laPerfUsu;
        public List<clsProcesoER> laPerfUsu { get { return _laPerfUsu; } set { _laPerfUsu = value; } }

        private string _strResp;

        #region 
        /// <summary>

        /// //JESÚS MONTERO CUEVAS
        /// </summary>
        private string _sCuenta;
        private string _sNombre;
        private string _sCorreo;
        private string _sDDepcia;
        private string _sDPuesto;
        private string _sDPerfil;

        private int _nDepcia;
        private string _sDPeriodo;
        private string _sDProceso;
        private string _sDTipoPeri;
        private string _sFInicio;
        private string _sFFinal;
        private char _cIndActivo;
        private string _sGuiaER;
        private int _nPuesto;
        private string _nEliminar;
        private string _sProceso;
        private string _sNombreArch;
        private string _puesto;
        private string _dependencia;
        private string _cIndCerrado;
        private string _sFechaCierre;

        #endregion

        #endregion

        #region
        private string _sSujetoObligado;
        private string _sSujetoReceptor;
        private string _dFechaExtemporanea;
        private int _nIdParticipante;
        private int _idProcExtem;
        private string _sNombreR;
        private int _nIdPerfil;
        private int _nidPartNue;    //Variable que regresa el ID del Nuevo Participante (Cambio de Sujeto Obligado)
        #endregion

        #region //--Erik José Enríquez Carmona
        /// <summary>
        /// Propiedades privadas Erik José Enríquez Carmona
        /// </summary>
        System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros
        clsDALSQL _objDALSQL;
        libSQL _libSQL;
        clsValidacion _libFunciones;

        private int _idUsuario;                     // ID del usuario que se va a consultar
        private string _strNomUsuario;              // Nombre del usuario que esta conformando la ER
        private int _idProceso;                     // ID del proceso ER
        private string _strNomProceso;              // Nombre del proceso ER
        private string _dteFInicial;                // Fecha Inicial de un proceso ER
        private string _dteFFinal;                  // Fecha Final de un proceso ER
        private int _intTieneProcesos;              // Variable para determinar si tiene procesos que atender o consultar
        private int _idAnexoActual;                 // ID del anexo que se va a buscar
        private List<clsProceso> _lstProcesos;      // Listado de procesos ER

        private string _strAccion;                  // Variable para controlar la acción a realizar
        private string _strOpcion;                  // Variable para manejar la opción CARGA/CONSULTA
        #endregion

        #region //--Ma. Guadalupe Dominguez
        /// <summary>
        /// Propiedades privadas Erik José Enríquez Carmona
        /// </summary>
        private int _nidProcPart;

        #endregion

        #endregion

        #region Procedimiento de Clase

        #region public bool fGetPeriodosEntregaHistorico()
        /// <summary>
        /// Regresa los Periodos de una entrega que ya estan cerrados
        /// </summary>
        /// <returns></returns>
        public bool fGetPeriodosEntregaHistorico()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBT_PROC_ER_H"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PERIODOS_HIST");
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region public bool fGetPeriodosEntrega()
        /// <summary>
        /// Regresa los Periodos de una entrega
        /// </summary>
        /// <returns></returns>
        public bool fGetPeriodosEntrega()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_PERIODOS_ENTREGA"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PERIODOS");
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region bool fActiva_Desactiva_Periodo(int nIdPeriodo, string strIndActivo)
        /// <summary>
        /// Método que activa o desactiva el proceso E-R
        /// </summary>
        /// <param name="nIdPeriodo">ID del proceso-ER</param>
        /// <param name="strIndActivo">indicador activo</param>
        /// <returns></returns>
        public bool fActiva_Desactiva_Periodo(int nidProceso, string strIndActivo, int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "CAMBIA_EDO_PERIODO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nidProceso));
                lstParametros.Add(lSQL.CrearParametro("@chrCINDACTIVO", strIndActivo));
                lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nIdUsuario));
                blnRespuesta = objDALSQL.ExecQuery("PA_IDUH_PROCESOER", lstParametros);
            }
            return blnRespuesta;
        }
        #endregion

        #region  bool fElimina_Periodo(int nIdPeriodo)
        /// <summary>
        /// MÉtodo que elimina el proceso ER
        /// </summary>
        /// <param name="nIdPeriodo">ID del proceso-ER</param>
        /// <returns></returns>
        public string fElimina_Periodo(int nidProceso, int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINAR_PERIODO"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nidProceso));
                lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nIdUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_PROCESOER", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }
            }
            return _strResp;
        }
        #endregion

        #region bool fGetSujetosObligados()
        /// <summary>
        ///----**********---------------************----------------------**************------------------
        ///----**********---------------************----------------------**************------------------
        ///--------------  MÉTODOS DE LA PARTE DE CAMBIO DE SUJETO OBLIGADO  -----------------------------
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public bool fGetSujetosObligados(int nIdProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_SUJETOS_OBLIGADOS"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    laDependencias = new List<clsDepcia>();
                    laParticipantes = new List<clsDepcia>();
                    laRegresaDatos2 = new List<clsProcesoER>();
                    laProcPorSujObl = new List<clsProcesoER>();
                    laDepSujObl = new List<clsProcesoER>();
                    laPerfUsu = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "SUJETOS_OBLIGADOS");
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region bool fGetPartXProc
        /// <summary>

        ///--------------  MÉTODOS DE LA PARTE DE CAMBIO DE PARTICIPANTES  -----------------------------
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        /// Método que regresa los particiapntes por proceso
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>

        public bool fGetPartXProc(int nIdProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_PARTICIPANTES"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    laCargaPart = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PARTICIPANTES");
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region bool fGetPartXProcHist
        /// <summary>

        ///--------------  MÉTODOS DE LA PARTE DE CAMBIO DE PARTICIPANTES  -----------------------------
        ///  AUTOR: JESÚS MONTERO CUEVAS
        ///  Método que regresa los particiapntes del proceso historico
        /// </summary>
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>

        public bool fGetPartXProcHist(int nIdProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_PART_HIST"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PROCESOER", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PARTICIPANTES_HIST");
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region Métodos Ma. Guadalupe Domínguez Julián
        /// <summary>
        /// Consulta usuarios para configurar como supervisores
        /// Autor: Maria Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="nidProceso">identificador del proceso</param>
        /// <param name="sSeleccionadas">idprospart de las dependencias seleccionadas</param>
        /// <param name="nIdUsuario">identificador de usuario logueado</param>
        /// <returns>Lista de usuarios</returns>
        public string fConsultaUsuarios(int nidProceso, string sSeleccionadas, int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONSULTA_USUA"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nidProceso));

                if (objDALSQL.ExecQuery_SET("PA_SELV_SUPERVISOR", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    //  laCargaPart = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "USUARIO_SUPERVISOR");
                }
            }
            return _strResp;
        }
        /// <summary>
        /// Permite actualizar la asignación de supervisores a las dependencias
        /// Autor: Maria Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="nIdProceso">Identificador del proceso</param>
        /// <param name="sarrIdDepcia">Arreglo de idProcPart de las dependencias</param>
        /// <param name="sSuperSAF">indicador supervisor SAF</param>
        /// <param name="sSuperCG">indicadoe de supervisor CG</param>
        /// <param name="sSuperSU">indicador de supervisor</param>
        /// <param name="cIndAplica">indicador de agregar ó quitar a un usuario como supervisor</param>
        /// <param name="idUsuario">identificador de usuario</param>
        /// <returns>indicador 1 éxito, 2 error</returns>
        public string pActualiza_aplica_Depcia(int nIdProceso, string sarrIdDepcia, char sSuperSAF, char sSuperCG, char sSuperSU, char cIndAplica, int idUsuario)
        {
            string sAccion;
            if (cIndAplica == 'S')
            {
                sAccion = "ACTUALIZA_APLICA_DEPCIA";
            }
            else
            {
                sAccion = "QUITA_APLICA_DEPCIA";
            }
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", sAccion));
                lstParametros.Add(lSQL.CrearParametro("@idPROCESO", nIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@strPARTICIPANTES", sarrIdDepcia));
                lstParametros.Add(lSQL.CrearParametro("@strSAF", sSuperSAF));
                lstParametros.Add(lSQL.CrearParametro("@strCG", sSuperCG));
                lstParametros.Add(lSQL.CrearParametro("@strSU", sSuperSU));
                lstParametros.Add(lSQL.CrearParametro("@idUSUARIO", idUsuario));

                if (objDALSQL.ExecQuery_SET("PA_IDUH_SUPERVISOR", lstParametros))
                {
                    _strResp = "1";
                }
                else
                {
                    _strResp = "0";
                }
            }
            return _strResp;
        }


        #region bool fUsuaDepcia

        /// <summary>
        /// Obtiene los supervisores por dependencia de un determinado proceso
        /// Autor: Maria Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="nIdProceso">identificador del proceso</param>
        /// <returns>lista de usuarios por dependencia</returns>
        public bool fUsuaDepcia(int nIdProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_PARTICIPANTES_DEPCIA"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_SUPERVISOR", lstParametros))
                {
                    laRegresaDatos = new List<clsProcesoER>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PARTICIPANTES_DEPCIA");
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
        #endregion

        #region bool fCambSujOb()
        /// <summary>
        /// Método que asigna a un usuario como sujeto obligado de una dependencia
        ///--------------  MÉTODO QUE CAMBIA SUJETO OBLIGADO  -----------------------------
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        /// <returns>Booleano que indica si el cambio de sujeto obligado se realizó satisfactoriamente</returns>
        /// 

        public string fCambSujOb(int nIdParticipante, int idUsuario, int idProceso, int idUsuarioNuevo, int idDependencia, int idPuesto)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "CAMBSUJOBL"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", idProceso));
                lstParametros.Add(lSQL.CrearParametro("@intSUJETOOBLIGADO", idUsuarioNuevo));
                lstParametros.Add(lSQL.CrearParametro("@intNFKDEPCIA", idDependencia));
                lstParametros.Add(lSQL.CrearParametro("@intNFKPUESTO", idPuesto));

                lstParametros.Add(lSQL.CrearParametro("@idPartAnt", 0, SqlDbType.Int, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@idPartNue", 0, SqlDbType.Int, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_PROCESOER", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[2].ToString();

                    if (this._strResp == "1")//Si la acción se realiza correctamente entonces se envia notificación
                    {
                        this._nIdParticipante = Convert.ToInt32(arrOUT[0].ToString());
                        this._nidPartNue = Convert.ToInt32(arrOUT[1].ToString());

                        Thread tmod = new Thread(() => fNotCamSujOb(_nIdParticipante, _nidPartNue));      //Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                        tmod.Start();
                    }
                }
            }
            return _strResp;
        }

        #endregion

        #region fNotCamSujOb(_nIdParticipante,_nidPartNue)
        /// <summary>
        /// Procedimiento que obtiene los datos de los participantes a los cuales se les enviara la notificación de cambio de sujeto obligado
        /// Autor: Edgar Morales González
        /// </summary>
        /// <param name="_nIdParticipante">Id del participante que deja de ser sujeto obligado</param>
        /// <param name="_nidPartNue">ID del participante que es asignado como sujeto obligado</param>
        /// <returns></returns>
        public bool fNotCamSujOb(int _nIdParticipante, int _nidPartNue)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strOPCION", "CAM_SUJ_OB"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPARTANT", _nIdParticipante));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPARTNUE", _nidPartNue));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", _lstParametros))
                {
                    DataSet ds = objDALSQL.Get_dtSet();                         //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                    string dato = clsJsonMethods.ConvertDataSetToXML(ds);       //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                    clsWSNotif wsNotif = new clsWSNotif();                      //  Crea un objeto que se usara para la comunicación con la clase del WebService
                    wsNotif.SendNotif(dato, "CAMB_SUJ_OB");
                }
                else
                {
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region void pLlenar_Lista(DataSet dataset, string op)
        /// <summary>
        ///  //----**********---------------************----------------------**************------------------
        ///  //----**********---------------************----------------------**************------------------
        ///  //--------------  MÉTODO QUE LLENA LA LISTA PARA MANDARLA AL CLIENTE  ---------------------------
        ///  //AUTOR: JESÚS MONTERO CUEVAS-----------------------------------------------------------
        /// </summary>
        /// <param name="dataset">el dataset con las tablas de la consulta</param>
        /// <param name="op">la opción que realizará</param>
        private void pLlenar_Lista(DataSet dataset, string op)
        {
            try
            {
                string sFi, sFf, sFc = "";
                switch (op)
                {
                    case "PERIODOS"://Se llena la lista que contendra los procesos-ER abiertos
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objProcER = new clsProcesoER();
                            objProcER.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objProcER.sProceso = row["sProceso"].ToString();
                            sFi = row["dFInicio"].ToString();
                            objProcER.sFInicio = DateTime.Parse(sFi).ToString("dd-MM-yyyy");
                            sFf = row["dFFinal"].ToString();
                            objProcER.sFFinal = DateTime.Parse(sFf).ToString("dd-MM-yyyy");
                            objProcER.sDTipoPeri = row["sDTipoProc"].ToString();
                            objProcER.sDPeriodo = row["sDProceso"].ToString();
                            objProcER.cIndActivo = char.Parse(row["cIndActivo"].ToString());
                            objProcER.sGuiaER = row["sGuiaER"].ToString();
                            objProcER.nDepcia = int.Parse(row["nFKDepcia"].ToString());
                            objProcER.nPuesto = int.Parse(row["nFKPuesto"].ToString());
                            objProcER.puesto = row["puesto"].ToString();
                            objProcER.dependencia = row["dependencia"].ToString();
                            objProcER.nEliminar = row.Table.Columns.Contains("eliminar") ? row["eliminar"].ToString() : "vacio".ToString();
                            laRegresaDatos.Add(objProcER);
                        }
                        break;

                    case "PERIODOS_HIST"://se llena la lista que contendrá los procesos-ER cerrados(históric)
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objProcER = new clsProcesoER();
                            objProcER.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objProcER.sProceso = row["sProceso"].ToString();
                            objProcER.sDPeriodo = row["sDProceso"].ToString();
                            objProcER.sGuiaER = row["sGuiaER"].ToString();
                            objProcER.sDTipoPeri = row["sDTipoProc"].ToString();
                            sFi = row["dFInicio"].ToString();
                            objProcER.sFInicio = DateTime.Parse(sFi).ToString("dd-MM-yyyy");
                            sFf = row["dFFinal"].ToString();
                            objProcER.sFFinal = DateTime.Parse(sFf).ToString("dd-MM-yyyy");
                            objProcER.nDepcia = int.Parse(row["nFKDepcia"].ToString());
                            objProcER.nPuesto = int.Parse(row["nFKPuesto"].ToString());
                            objProcER.puesto = row["puesto"].ToString();
                            objProcER.dependencia = row["dependencia"].ToString();
                            sFc = row["fechaCierre"].ToString();
                            objProcER.sFechaCierre = DateTime.Parse(sFc).ToString("dd-MM-yyyy");

                            laRegresaDatos.Add(objProcER);
                        }
                        break;

                    case "SUJETOS_OBLIGADOS"://lista que contiene los usuarios que se mostrarán en el grid de cambio de sujeto obligado
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objProcER = new clsProcesoER();
                            objProcER.idUsuario = int.Parse(row["idUsuario"].ToString());
                            objProcER.sCuenta = row["sCuenta"].ToString();
                            objProcER.sNombre = row["sNombre"].ToString();
                            objProcER.sCorreo = row["sCorreo"].ToString();
                            objProcER.sDDepcia = row["sDDepcia"].ToString();
                            objProcER.sDPuesto = row["sDPuesto"].ToString();

                            objProcER.laPerfUsu = new List<clsProcesoER>();
                            objProcER.laProcPorSujObl = new List<clsProcesoER>();

                            if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                            {
                            }
                            else
                            {
                                objProcER.laPerfUsu = getPerfilesXusu(dataset, objProcER.idUsuario);
                            }

                            if (dataset.Tables[2] == null || dataset.Tables[2].Rows.Count == 0)
                            {
                            }
                            else
                            {
                                objProcER.laProcPorSujObl = getProcesosXSujObl(dataset, objProcER.idUsuario);
                            }
                            laRegresaDatos.Add(objProcER);
                        }

                        foreach (DataRow row in dataset.Tables[4].Rows)//PROCESO ER
                        {
                            clsProcesoER objProcER = new clsProcesoER();
                            if (dataset.Tables[4] == null || dataset.Tables[3].Rows.Count == 0)
                            {
                            }
                            else
                            {
                                objProcER.nIdProceso = int.Parse(row["idProceso"].ToString());
                                objProcER.sDProceso = row["sDProceso"].ToString();
                                objProcER.laDependencias = new List<clsDepcia>();

                                if (dataset.Tables[5] == null || dataset.Tables[5].Rows.Count == 0)
                                {
                                }
                                else
                                {
                                    objProcER.laDependencias = getDepciaXProcER(dataset, objProcER.nIdProceso);
                                }
                                laRegresaDatos2.Add(objProcER);
                            }
                        }
                        break;

                    case "PARTICIPANTES"://lista que se llenará con las dependencias de un Proceso-ER
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objProcER = new clsProcesoER();

                            if (row["idParticipante"].ToString() == null)
                            {
                                objProcER.nIdParticipante = 0;
                            }
                            else
                            {
                                objProcER.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                            }

                            objProcER.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objProcER.sDProceso = row["sDProceso"].ToString();
                            objProcER.nDepcia = int.Parse(row["nDepcia"].ToString());
                            objProcER.sDDepcia = row["sDDepcia"].ToString();
                            objProcER.sSujetoObligado = row["sNombre"].ToString();
                            objProcER.sNombreR = row["sNombreR"].ToString();
                            objProcER.sDPuesto = row["sDPuesto"].ToString();
                            objProcER.nPuesto = int.Parse(row["nFKPuesto"].ToString());
                            objProcER.laCargaPart = new List<clsProcesoER>();

                            if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                            {
                                //objProcER.laCargaPart = null;
                            }
                            else
                            {
                                objProcER.laCargaPart = getCargasProParticipante(dataset, objProcER.nIdParticipante);
                            }
                            laRegresaDatos.Add(objProcER);
                        }

                        break;
                    case "PARTICIPANTES_DEPCIA":

                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objDepcia = new clsProcesoER();
                            objDepcia.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                            objDepcia.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objDepcia.sDProceso = row["sDProceso"].ToString();
                            objDepcia.nDepcia = int.Parse(row["nDepcia"].ToString());
                            objDepcia.nPuesto = int.Parse(row["nFKPuesto"].ToString());
                            objDepcia.nidProcPart = int.Parse(row["idProcPart"].ToString());
                            objDepcia.sDDepcia = row["sDDepcia"].ToString();
                            objDepcia.sSujetoObligado = row["sNombreO"].ToString();
                            objDepcia.sNombreR = row["sNombreR"].ToString();
                            //objUsuario.strsDCPerfil = row["sDPerfil"].ToString();


                            //objUsuario.intProceso = int.Parse(row["nIdProceso"].ToString());
                            List<clsDepcia> arrDepcias = new List<clsDepcia>();
                            List<clsDepcia> arrDepcias2 = new List<clsDepcia>();
                            List<clsDepcia> arrDepcias3 = new List<clsDepcia>();

                            //List<int> lstProcesos = new List<int>();
                            foreach (DataRow row2 in dataset.Tables[1].Rows)
                            {
                                //List<clsPerfil> arrPerfiles = new List<clsPerfil>();
                                if (objDepcia.nidProcPart == int.Parse(row2["idProcPart"].ToString()))
                                {
                                    clsDepcia objUsuario = new clsDepcia();
                                    objUsuario.nDepcia = int.Parse(row2["nDepcia"].ToString());
                                    objUsuario.sNombre = row2["supervisorSAF"].ToString();
                                    arrDepcias.Add(objUsuario);
                                }
                            }

                            foreach (DataRow row3 in dataset.Tables[2].Rows)
                            {
                                //List<clsPerfil> arrPerfiles = new List<clsPerfil>();
                                if (objDepcia.nidProcPart == int.Parse(row3["idProcPart"].ToString()))
                                {
                                    clsDepcia objUsuario = new clsDepcia();
                                    objUsuario.nDepcia = int.Parse(row3["nDepcia"].ToString());
                                    objUsuario.sNombre = row3["supervisorCG"].ToString();
                                    arrDepcias2.Add(objUsuario);
                                }
                            }

                            foreach (DataRow row4 in dataset.Tables[3].Rows)
                            {
                                //List<clsPerfil> arrPerfiles = new List<clsPerfil>();
                                if (objDepcia.nidProcPart == int.Parse(row4["idProcPart"].ToString()))
                                {
                                    clsDepcia objUsuario = new clsDepcia();
                                    objUsuario.nDepcia = int.Parse(row4["nDepcia"].ToString());
                                    objUsuario.sNombre = row4["supervisor"].ToString();
                                    arrDepcias3.Add(objUsuario);
                                }
                            }

                            objDepcia.laDependencias = arrDepcias;
                            objDepcia.laParticipantes = arrDepcias2;
                            objDepcia.laDepcias = arrDepcias3;

                            laRegresaDatos.Add(objDepcia);
                        }

                        break;
                    case "USUARIO_SUPERVISOR":

                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objDepcia = new clsProcesoER();
                            objDepcia.idUsuario = int.Parse(row["idUsuario"].ToString());
                            //if (row["idPerfil"].ToString() != "")
                            //{
                            //    objDepcia.nIdPerfil = int.Parse(row["idPerfil"].ToString());
                            //}
                            //else
                            //{
                            //    objDepcia.nIdPerfil = 0;
                            //}
                            objDepcia.sNombre = row["sNombre"].ToString();
                            //if (row["idFKProceso"].ToString() != "")
                            //{
                            //    objDepcia.idProceso = int.Parse(row["idFKProceso"].ToString());
                            //}
                            //else
                            //{
                            //    objDepcia.idProceso = 0;
                            //}

                            List<clsProcesoER> arrDepcias = new List<clsProcesoER>();
                            List<clsProcesoER> arrDepcias2 = new List<clsProcesoER>();
                            List<clsProcesoER> arrDepcias3 = new List<clsProcesoER>();

                            foreach (DataRow row2 in dataset.Tables[1].Rows)
                            {
                                if (objDepcia.idUsuario == int.Parse(row2["idUsuario"].ToString()))
                                {
                                    clsProcesoER objUsuario = new clsProcesoER();
                                    if (row2["idPerfil"].ToString() != "")
                                    {
                                        objUsuario.nIdPerfil = int.Parse(row2["idPerfil"].ToString());
                                    }
                                    else
                                    {
                                        objUsuario.nIdPerfil = 0;
                                    }

                                    objUsuario.sNombre = row2["sNombre"].ToString();
                                    if (row2["idFKProcPart"].ToString() != "")
                                    {
                                        objUsuario.nidProcPart = int.Parse(row2["idFKProcPart"].ToString());
                                    }
                                    else
                                    {
                                        objUsuario.nidProcPart = 0;
                                    }
                                    objUsuario.nDepcia = int.Parse(row2["nFKDepcia"].ToString());
                                    objUsuario.sDDepcia = row2["sDDepcia"].ToString();
                                    arrDepcias.Add(objUsuario);
                                }
                            }

                            foreach (DataRow row3 in dataset.Tables[2].Rows)
                            {
                                if (objDepcia.idUsuario == int.Parse(row3["idUsuario"].ToString()))
                                {
                                    clsProcesoER objUsuario = new clsProcesoER();
                                    objUsuario.nIdPerfil = int.Parse(row3["idPerfil"].ToString());
                                    objUsuario.sNombre = row3["sNombre"].ToString();
                                    objUsuario.nidProcPart = int.Parse(row3["idFKProcPart"].ToString());
                                    objUsuario.nDepcia = int.Parse(row3["nFKDepcia"].ToString());
                                    objUsuario.sDDepcia = row3["sDDepcia"].ToString();
                                    arrDepcias2.Add(objUsuario);
                                }
                            }

                            foreach (DataRow row4 in dataset.Tables[3].Rows)
                            {
                                if (objDepcia.idUsuario == int.Parse(row4["idUsuario"].ToString()))
                                {
                                    clsProcesoER objUsuario = new clsProcesoER();
                                    objUsuario.nIdPerfil = int.Parse(row4["idPerfil"].ToString());
                                    objUsuario.sNombre = row4["sNombre"].ToString();
                                    objUsuario.nidProcPart = int.Parse(row4["idFKProcPart"].ToString());
                                    objUsuario.nDepcia = int.Parse(row4["nFKDepcia"].ToString());
                                    objUsuario.sDDepcia = row4["sDDepcia"].ToString();
                                    arrDepcias3.Add(objUsuario);
                                }
                            }
                            objDepcia.laDepSujObl = arrDepcias;
                            objDepcia.laRegresaDatos2 = arrDepcias2;
                            objDepcia.laCargaPart = arrDepcias3;

                            laRegresaDatos.Add(objDepcia);
                        }

                        break;

                    case "PARTICIPANTES_HIST"://Esta lista se llenará con las dependencias del proceso-ER (histórico)
                        laRegresaDatos.Add(null);
                        foreach (DataRow row4 in dataset.Tables[0].Rows)
                        {
                            clsProcesoER objPartHist = new clsProcesoER();
                            objPartHist.nIdParticipante = int.Parse(row4["idParticipante"].ToString());
                            objPartHist.nIdProceso = int.Parse(row4["idProceso"].ToString());
                            objPartHist.sDProceso = row4["sDProceso"].ToString();
                            objPartHist.nDepcia = int.Parse(row4["nDepcia"].ToString());
                            objPartHist.nPuesto = int.Parse(row4["nFKPuesto"].ToString());
                            objPartHist.sDDepcia = row4["sDDepcia"].ToString();
                            objPartHist.sSujetoObligado = row4["sNombreO"].ToString();
                            objPartHist.sNombreR = row4["sNombreR"].ToString();
                            objPartHist.cIndCerrado = row4["cIndCerrado"].ToString();
                            laRegresaDatos.Add(objPartHist);
                        }
                        break;
                }//termina el switch
            }
            catch
            {
                laRegresaDatos = null;
            }
            finally
            {
                dataset = null;
            }
        }



        /// <summary>
        ///  Método que obtiene los perfiles por usuario
        /// </summary>
        /// <param name="dataset">dataset que contiene la tabla con la consulta de los perfiles</param>
        /// <param name="idUsuario">ID del usuario</param>
        /// <returns></returns>
        public List<clsProcesoER> getPerfilesXusu(DataSet dataset, int idUsuario)
        {
            DataTable tabla = dataset.Tables[1];
            List<clsProcesoER> laPerfXusu = new List<clsProcesoER>();
            clsProcesoER objPerfxUsu;
            DataRow[] result = tabla.Select("idUsuario =" + idUsuario);
            foreach (DataRow row in result)
            {
                objPerfxUsu = new clsProcesoER();
                objPerfxUsu.idUsuario = int.Parse(row["idUsuario"].ToString());
                objPerfxUsu.nIdPerfil = int.Parse(row["nIdPerfil"].ToString());
                objPerfxUsu.sDPerfil = row["sDPerfil"].ToString();

                laPerfXusu.Add(objPerfxUsu);
            }
            return laPerfXusu;
        }

        /// <summary>
        /// Método que obtiene los procesos por sujeto obligado
        /// </summary>
        /// <param name="dataset">dataset que contiene la tabla con la consulta de los procesos</param>
        /// <param name="NidUsuario">ID del usuario</param>
        /// <returns></returns>
        public List<clsProcesoER> getProcesosXSujObl(DataSet dataset, int NidUsuario)
        {
            DataTable tabla = dataset.Tables[2];
            List<clsProcesoER> laProcesoPorUsuario = new List<clsProcesoER>();
            clsProcesoER objProcesoxUusuario;
            DataRow[] result = tabla.Select("idUsuario =" + NidUsuario);
            foreach (DataRow row in result)
            {
                objProcesoxUusuario = new clsProcesoER();
                objProcesoxUusuario.idUsuario = int.Parse(row[0].ToString());
                objProcesoxUusuario.nIdProceso = int.Parse(row[1].ToString());
                objProcesoxUusuario.sDProceso = row[2].ToString();

                if (dataset.Tables[3] == null || dataset.Tables[3].Rows.Count == 0)
                {
                }
                else
                {
                    objProcesoxUusuario.laDepSujObl = getDepXSujObl(dataset, objProcesoxUusuario.idUsuario = int.Parse(row[0].ToString()), objProcesoxUusuario.nIdProceso = int.Parse(row[1].ToString()));
                }

                laProcesoPorUsuario.Add(objProcesoxUusuario);
            }
            return laProcesoPorUsuario;
        }


        /// <summary>
        /// Método que obtiene las dependencias por sujeto obligado
        /// </summary>
        /// <param name="dataset">dataset que contiene la tabla con las dependencias en las cuales se encuentra el usuario como sujeto obligado</param>
        /// <param name="idUsuario">ID del usuario</param>
        /// <param name="IdProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public List<clsProcesoER> getDepXSujObl(DataSet dataset, int idUsuario, int IdProceso)
        {
            DataTable tabla = dataset.Tables[3];
            List<clsProcesoER> laDepSujObl = new List<clsProcesoER>();
            clsProcesoER objDepXUsuario;
            DataRow[] result = tabla.Select("idUsuario ='" + idUsuario + "' AND idProceso='" + IdProceso + "'");
            foreach (DataRow row in result)
            {
                objDepXUsuario = new clsProcesoER();
                objDepXUsuario.idUsuario = int.Parse(row["idUsuario"].ToString());
                objDepXUsuario.nIdProceso = int.Parse(row["idProceso"].ToString());
                objDepXUsuario.nDepcia = int.Parse(row["nDepcia"].ToString());
                objDepXUsuario.sDDepcia = row["sDDepcia"].ToString();

                laDepSujObl.Add(objDepXUsuario);
            }
            return laDepSujObl;
        }

        /// <summary>
        /// Método que obtiene las cargas por participante
        /// </summary>
        /// <param name="dataset">dataset que obtiene la tabla con las cargas del participante</param>
        /// <param name="nIdParticipante">ID del particiapnte</param>
        /// <returns></returns>
        public List<clsProcesoER> getCargasProParticipante(DataSet dataset, int nIdParticipante)
        {
            DataTable tabla = dataset.Tables[1];
            List<clsProcesoER> laProcesoER = new List<clsProcesoER>();
            clsProcesoER objProcesoER;
            DataRow[] result = tabla.Select("idParticipante =" + nIdParticipante);
            foreach (DataRow row in result)
            {
                objProcesoER = new clsProcesoER
                {
                    nIdParticipante = int.Parse(row[0].ToString()),
                    sNombre = row[1].ToString(),
                    sNombreArch = row[2].ToString(),
                };
                laProcesoER.Add(objProcesoER);
            }
            return laProcesoER;
        }

        /// <summary>
        /// Método que obtiene las dependencias por proceso
        /// </summary>
        /// <param name="dataset">dataset que contiene la tabla con la consulta que trae las dependencias</param>
        /// <param name="nIdProceso">ID del proceso</param>
        /// <returns></returns>
        public List<clsDepcia> getDepciaXProcER(DataSet dataset, int nIdProceso)
        {
            DataTable tabla = dataset.Tables[5];
            List<clsDepcia> laDepcia = new List<clsDepcia>();
            clsDepcia objDepcia;
            DataRow[] result = tabla.Select("idProceso =" + nIdProceso);
            foreach (DataRow row in result)
            {
                objDepcia = new clsDepcia
                {
                    idProceso = int.Parse(row[0].ToString()),
                    nDepcia = int.Parse(row[1].ToString()),
                    sDDepcia = row[2].ToString(),
                    idParticipante = int.Parse(row[3].ToString()),
                    laPuestos = getPuestoXDepcia(dataset,
                                                                        nDepcia = int.Parse(row[1].ToString()),
                                                                        idProceso = int.Parse(row[0].ToString()))
                };
                laDepcia.Add(objDepcia);
            }
            return laDepcia;
        }

        /// <summary>
        /// Método que obtiene puesto por dependencia
        /// </summary>
        /// <param name="dataset">dataset que contiene la tabla con la consulta</param>
        /// <param name="nDepcia">clave de la dependencia</param>
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public List<clsPuesto> getPuestoXDepcia(DataSet dataset, int nDepcia, int nIdProceso)
        {
            DataTable tabla = dataset.Tables[6];
            List<clsPuesto> laPuesto = new List<clsPuesto>();
            clsPuesto objPuesto;
            DataRow[] result = tabla.Select("idProceso ='" + nIdProceso + "' AND nDepcia='" + nDepcia + "'");
            foreach (DataRow row in result)
            {
                objPuesto = new clsPuesto
                {
                    idProceso = int.Parse(row[0].ToString()),
                    nDepcia = int.Parse(row[1].ToString()),
                    nPuesto = int.Parse(row[2].ToString()),
                    sDPuesto = row[3].ToString(),
                    laSujObl = getSujOblXPuesto(dataset,
                                                                         idProceso = int.Parse(row[0].ToString()),
                                                                         nDepcia = int.Parse(row[1].ToString()),
                                                                         nPuesto = int.Parse(row[2].ToString())
                                                                        )
                };
                laPuesto.Add(objPuesto);
            }
            return laPuesto;
        }


        /// <summary>
        /// Método que relaciona al sujeto obligado con su puesto
        /// </summary>
        /// <param name="dataset">el dataset que contiene la tabla con la consulta</param>
        /// <param name="idProceso">ID del proceso-ER</param>
        /// <param name="nDepcia">clave de la dependencia</param>
        /// <param name="nPuesto">ID del puesto del sujeto obligado</param>
        /// <returns></returns>
        public List<clsParticipante> getSujOblXPuesto(DataSet dataset, int idProceso, int nDepcia, int nPuesto)
        {
            DataTable tabla = dataset.Tables[7];
            List<clsParticipante> laSujObl = new List<clsParticipante>();
            clsParticipante objPart;
            DataRow[] result = tabla.Select("idProceso ='" + idProceso + "'AND nDepcia='" + nDepcia + "'AND nPuesto='" + nPuesto + "'");
            foreach (DataRow row in result)
            {
                objPart = new clsParticipante
                {
                    idProceso = int.Parse(row[0].ToString()),
                    nDepcia = int.Parse(row[1].ToString()),
                    nPuesto = int.Parse(row[2].ToString()),
                    sNombre = row[3].ToString()
                };
                laSujObl.Add(objPart);
            }
            return laSujObl;
        }

        #endregion

        #region clsApartado pGetAnexos(DataSet dsDatos, clsApartado objApartado)
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="dsDatos">Data Set con los datos</param>
        /// <param name="objApartado">Objeto actual apartado</param>
        /// <returns>Un objeto apartado con el listado de Anexos asociados a él</returns>
        private clsApartado pGetAnexos(DataSet dsDatos, clsApartado objApartado)
        {
            if (dsDatos != null && objApartado != null)
            {
                if (dsDatos.Tables[4] != null)
                {
                    try
                    {
                        /*SE ASIGNA LA TABLA DONDE VIENEN LOS ANEXOS*/
                        DataTable dtTabla = dsDatos.Tables[4];
                        //if (dtTabla.Columns.Contains("nIdParticipante") && dtTabla.Columns.Contains("nIdApartado") && dtTabla.Columns.Contains("nIdAnexo") && dtTabla.Columns.Contains("sAnexo")
                        //    && dtTabla.Columns.Contains("sDAnexo") && dtTabla.Columns.Contains("cIndAplica") && dtTabla.Columns.Contains("cIndEntrega")
                        //    && dtTabla.Columns.Contains("nIdUsuario") && dtTabla.Columns.Contains("nIdUsuarioO") && dtTabla.Columns.Contains("nIdPartAplic")
                        //    )
                        if (dtTabla.Columns.Contains("nIdParticipante") && dtTabla.Columns.Contains("nIdApartado") && dtTabla.Columns.Contains("nIdAnexo")
                            && dtTabla.Columns.Contains("cIndEntrega") && dtTabla.Columns.Contains("sAnexo") && dtTabla.Columns.Contains("sDAnexo")
                            && dtTabla.Columns.Contains("nIdPartAplic") && dtTabla.Columns.Contains("nIdUsuario")
                            && dtTabla.Columns.Contains("sJustificacion") && !dtTabla.Columns.Contains("nNumArchivos")
                            && dtTabla.Columns.Contains("cTipo") && !dtTabla.Columns.Contains("cIndActa")
                            //&& dtTabla.Columns.Contains("nIdUsuario") && dtTabla.Columns.Contains("nIdUsuarioO") && dtTabla.Columns.Contains("nIdPartAplic")
                            )
                        {
                            DataRow[] drResultado = dtTabla.Select("nIdParticipante = " + objApartado.idParticipante +
                                                                    " AND nIdApartado=" + objApartado.idApartado
                                                                    );
                            using (this._libFunciones = new clsValidacion())
                            {
                                foreach (DataRow dtRow in drResultado)
                                {
                                    objApartado.lstAnexos.Add(new clsAnexo(this._libFunciones.IsNumeric(dtRow["nIdAnexo"].ToString()) ? int.Parse(dtRow["nIdAnexo"].ToString()) : 0
                                                                            , dtRow["cIndEntrega"].ToString()
                                                                            , dtRow["sAnexo"].ToString()
                                                                            , dtRow["sDAnexo"].ToString()
                                                                            , this._libFunciones.IsNumeric(dtRow["nIdPartAplic"].ToString()) ? int.Parse(dtRow["nIdPartAplic"].ToString()) : 0
                                                                            , this._libFunciones.IsNumeric(dtRow["nIdUsuario"].ToString()) ? int.Parse(dtRow["nIdUsuario"].ToString()) : 0
                                                                            , dtRow["sJustificacion"].ToString()
                                                                            , Char.Parse(dtRow["cTipo"].ToString())
                                                                            ));
                                }
                                objApartado.chrIndAnxInt = (objApartado.lstAnexos.Exists(delegate (clsAnexo x) { return x.charIndEntrega.Equals("E"); }) ? "E" :
                                                           (objApartado.lstAnexos.Exists(delegate (clsAnexo x) { return x.charIndEntrega.Equals("I"); }) ? "I" : "P"));
                            }
                        }
                        else // Monitoreo
                        {
                            DataRow[] drResultado = dtTabla.Select("nIdParticipante = " + objApartado.idParticipante +
                                                                    " AND nIdApartado=" + objApartado.idApartado
                                                                    );
                            using (this._libFunciones = new clsValidacion())
                            {
                                foreach (DataRow dtRow in drResultado)
                                {
                                    objApartado.lstAnexos.Add(new clsAnexo(this._libFunciones.IsNumeric(dtRow["nIdAnexo"].ToString()) ? int.Parse(dtRow["nIdAnexo"].ToString()) : 0
                                                                            , dtRow["cIndEntrega"].ToString()
                                                                            , dtRow["sAnexo"].ToString()
                                                                            , dtRow["sDAnexo"].ToString()
                                                                            , this._libFunciones.IsNumeric(dtRow["nIdPartAplic"].ToString()) ? int.Parse(dtRow["nIdPartAplic"].ToString()) : 0
                                                                            , this._libFunciones.IsNumeric(dtRow["nIdUsuario"].ToString()) ? int.Parse(dtRow["nIdUsuario"].ToString()) : 0
                                                                            , dtRow["sJustificacion"].ToString()
                                                                            , this._libFunciones.IsNumeric(dtRow["nNumArchivos"].ToString()) ? int.Parse(dtRow["nNumArchivos"].ToString()) : 0
                                                                            , Char.Parse(dtRow["cIndActa"].ToString())
                                                                            , (dtTabla.Columns.Contains("cTipo") ? Char.Parse(dtRow["cTipo"].ToString()) : Char.Parse(" "))
                                                                            ));
                                }
                                //objApartado.chrIndAnxInt = (objApartado.lstAnexos.Exists(delegate(clsAnexo x) { return x.charIndEntrega.Equals("E"); }) ? "E" :
                                //                           (objApartado.lstAnexos.Exists(delegate(clsAnexo x) { return x.charIndEntrega.Equals("I"); }) ? "I" : "P"));
                            }
                        }
                    }
                    catch
                    {
                        objApartado.lstAnexos = null;
                    }
                    finally
                    {
                        dsDatos.Dispose();
                    }
                }
            }
            return objApartado;
        }
        #endregion

        #region clsParticipante pGetEOReceptor(DataSet dsDatos, clsParticipante objParticipante)
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// Regresa una lista con los enlaces operativos (SO) de un participante
        /// </summary>
        /// <param name="dsDatos">Data Set con los datos</param>
        /// <param name="objParticipante">Objeto actual participante</param>
        /// <returns>Objeto Participante</returns>
        private clsParticipante pGetEOReceptor(DataSet dsDatos, clsParticipante objParticipante)
        {
            if (dsDatos != null && objParticipante != null)
            {
                try
                {
                    DataTable dtTablaEOReceptor = (dsDatos.Tables[6] != null ? dsDatos.Tables[6] : null);
                    if (dtTablaEOReceptor != null)
                    {
                        DataRow[] drResultado = dtTablaEOReceptor.Select("nIdParticipante = " + objParticipante.idParticipante +
                                                                        " AND idFKUOReceptor=" + objParticipante.idUsuarioR
                                                                        );
                        using (this._libFunciones = new clsValidacion())
                        {
                            objParticipante.lstEOReceptor = new List<clsUsuario>();
                            foreach (DataRow dtRow in drResultado)
                            {
                                clsUsuario objEO = new clsUsuario();
                                objEO.strNombre = (dtTablaEOReceptor.Columns.Contains("sNomEnlaceR") ? dtRow["sNomEnlaceR"].ToString() : string.Empty);
                                objEO.strCorreo = (dtTablaEOReceptor.Columns.Contains("sCorreo") ? dtRow["sCorreo"].ToString() : string.Empty);
                                objEO.chrPrincipal = char.Parse((dtTablaEOReceptor.Columns.Contains("cIndPrincipalR") ? dtRow["cIndPrincipalR"].ToString() : string.Empty));

                                objParticipante.lstEOReceptor.Add(objEO);
                            }
                        }
                    }
                    else
                    {
                        objParticipante.lstEOObligado = null;
                    }
                }
                catch
                {
                    objParticipante.lstEOObligado = null;
                }
                finally
                {
                    dsDatos.Dispose();
                }
            }
            return objParticipante;
        }
        #endregion

        #region clsParticipante pGetEOObligado(DataSet dsDatos, clsParticipante objParticipante)
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// Regresa una lista con los enlaces operativos (SO) de un participante
        /// </summary>
        /// <param name="dsDatos">Data Set con los datos</param>
        /// <param name="objParticipante">Objeto actual participante</param>
        /// <returns>Objeto Participante</returns>
        private clsParticipante pGetEOObligado(DataSet dsDatos, clsParticipante objParticipante)
        {
            if (dsDatos != null && objParticipante != null)
            {
                try
                {
                    DataTable dtTablaEOObligado = (dsDatos.Tables[5] != null ? dsDatos.Tables[5] : null);
                    if (dtTablaEOObligado != null)
                    {
                        DataRow[] drResultado = dtTablaEOObligado.Select("nIdParticipante = " + objParticipante.idParticipante +
                                                                        " AND idFKUObligado=" + objParticipante.idUsuarioO
                                                                        );
                        using (this._libFunciones = new clsValidacion())
                        {
                            objParticipante.lstEOObligado = new List<clsUsuario>();
                            foreach (DataRow dtRow in drResultado)
                            {
                                clsUsuario objEO = new clsUsuario();
                                objEO.strNombre = (dtTablaEOObligado.Columns.Contains("sNomEnlaceO") ? dtRow["sNomEnlaceO"].ToString() : string.Empty);
                                objEO.strCorreo = (dtTablaEOObligado.Columns.Contains("sCorreo") ? dtRow["sCorreo"].ToString() : string.Empty);
                                objEO.chrPrincipal = char.Parse((dtTablaEOObligado.Columns.Contains("cIndPrincipal") ? dtRow["cIndPrincipal"].ToString() : string.Empty));
                                objParticipante.lstEOObligado.Add(objEO);
                            }
                        }
                    }
                    else
                    {
                        objParticipante.lstEOObligado = null;
                    }
                }
                catch
                {
                    objParticipante.lstEOObligado = null;
                }
                finally
                {
                    dsDatos.Dispose();
                }
            }
            return objParticipante;
        }
        #endregion

        #region clsParticipante pGetApartados(DataSet dsDatos, clsParticipante objParticipante)
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="dsDatos">Data Set con los datos</param>
        /// <param name="objParticipante">Objeto actual participante</param>
        /// <returns>Un objeto participante con los apartados y anexos asociados a él</returns>
        private clsParticipante pGetApartados(DataSet dsDatos, clsParticipante objParticipante)
        {
            if (dsDatos != null && objParticipante != null)
            {
                if (dsDatos.Tables[3] != null)
                {
                    /*SE ASIGNA LA TABLA DONDE VIENEN LOS APARTADOS*/
                    DataTable dtTabla = dsDatos.Tables[3];
                    try
                    {

                        DataRow[] drResultado = dtTabla.Select("nIdParticipante = " + objParticipante.idParticipante);
                        using (this._libFunciones = new clsValidacion())
                        {
                            foreach (DataRow dtRow in drResultado)
                            {
                                clsApartado objApartado = new clsApartado(dtTabla.Columns.Contains("nIdParticipante") ? this._libFunciones.IsNumeric(dtRow["nIdParticipante"].ToString()) ? int.Parse(dtRow["nIdParticipante"].ToString()) : 0 : 0
                                                                            , dtTabla.Columns.Contains("nIdApartado") ? this._libFunciones.IsNumeric(dtRow["nIdApartado"].ToString()) ? int.Parse(dtRow["nIdApartado"].ToString()) : 0 : 0
                                                                            , dtTabla.Columns.Contains("sApartado") ? dtRow["sApartado"].ToString() : string.Empty
                                                                            , dtTabla.Columns.Contains("sDApartado") ? dtRow["sDApartado"].ToString() : string.Empty
                                                                            , dtTabla.Columns.Contains("cAplica") ? dtRow["cAplica"].ToString() : string.Empty);

                                objApartado = pGetAnexos(dsDatos, objApartado);
                                objParticipante.lstApartados.Add(objApartado);
                            }
                        }

                    }
                    finally
                    {
                        dsDatos.Dispose();
                    }
                }
            }
            return objParticipante;
        }
        #endregion

        #region clsProceso pGetParticipantes(DataTable dtTabla, clsProceso objProceso)
        /// <summary>
        /// 
        /// Autor: Erik José Enríquez Carmona  
        /// </summary>
        /// <param name="dtTabla">Tabla que contien los participantes de un proceso</param>
        /// <param name="objProceso">Objeto proceso que contendrá los participantes</param>
        /// <returns> Regresa el Objeto Proceso con sus Participantes Asociado</returns>
        public clsProceso pGetParticipantes(DataSet dsDatos, clsProceso objProceso)
        {
            if (dsDatos != null && objProceso != null)
            {
                if (dsDatos.Tables[2] != null)
                {
                    /*SE ASIGNA LA TABLA DONDE VIENEN LOS PARTICIPANTES*/
                    DataTable dtTabla = dsDatos.Tables[2];
                    try
                    {
                        if (dtTabla.Columns.Contains("nIdParticipante") && dtTabla.Columns.Contains("nPuesto") && dtTabla.Columns.Contains("sDPuesto") && dtTabla.Columns.Contains("nIdUsuario") &&
                            dtTabla.Columns.Contains("sDPerfil") && dtTabla.Columns.Contains("sOEnviar") && dtTabla.Columns.Contains("sOCerrar") && dtTabla.Columns.Contains("nFKDepcia") &&
                            dtTabla.Columns.Contains("sDCDepcia") && dtTabla.Columns.Contains("nIdUsuarioO") && dtTabla.Columns.Contains("nNomUsuarioO") && dtTabla.Columns.Contains("cEstatusE") &&
                            dtTabla.Columns.Contains("fAvance") && dtTabla.Columns.Contains("nIdUsuarioT") && dtTabla.Columns.Contains("nNomUsuarioT")
                            ) // Registro
                        {
                            DataRow[] drResultado = dtTabla.Select("nIdProceso = " + objProceso.idProceso);
                            using (this._libFunciones = new clsValidacion())
                            {
                                foreach (DataRow dtRow in drResultado)
                                {
                                    clsParticipante objParticipante = new clsParticipante(this._libFunciones.IsNumeric(dtRow["nIdParticipante"].ToString()) ? int.Parse(dtRow["nIdParticipante"].ToString()) : 0
                                                                                        , this._libFunciones.IsNumeric(dtRow["nPuesto"].ToString()) ? int.Parse(dtRow["nPuesto"].ToString()) : 0
                                                                                        , dtRow["sDPuesto"].ToString()
                                                                                        , dtRow["sDPerfil"].ToString()
                                                                                        , dtRow["sOEnviar"].ToString()
                                                                                        , dtRow["sOCerrar"].ToString()
                                                                                        , this._libFunciones.IsNumeric(dtRow["nFKDepcia"].ToString()) ? int.Parse(dtRow["nFKDepcia"].ToString()) : 0
                                                                                        , dtRow["sDCDepcia"].ToString()
                                                                                        , this._libFunciones.IsNumeric(dtRow["nIdUsuarioO"].ToString()) ? int.Parse(dtRow["nIdUsuarioO"].ToString()) : 0
                                                                                        , dtRow["nNomUsuarioO"].ToString()
                                                                                        , this._libFunciones.IsNumeric(dtRow["nIdUsuarioT"].ToString()) ? int.Parse(dtRow["nIdUsuarioT"].ToString()) : 0
                                                                                        , dtRow["nNomUsuarioT"].ToString()
                                                                                        , dtRow["cEstatusE"].ToString()
                                                                                        , this._libFunciones.IsNumeric(dtRow["fAvance"].ToString()) ? float.Parse((float.Parse(dtRow["fAvance"].ToString())).ToString("0.00")) : 0
                                                                                        , dtRow.Table.Columns.Contains("dFInicio") ? this._libFunciones.IsDate(dtRow["dFInicio"].ToString()) ? DateTime.Parse(dtRow["dFInicio"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("dFFinal") ? this._libFunciones.IsDate(dtRow["dFFinal"].ToString()) ? DateTime.Parse(dtRow["dFFinal"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                                        );
                                    //objParticipante._c
                                    objParticipante.nAPendientes = (dtRow.Table.Columns.Contains("nPendientes") ? this._libFunciones.IsNumeric(dtRow["nPendientes"].ToString()) ? int.Parse(dtRow["nPendientes"].ToString()) : 0 : 0);
                                    objParticipante.nAIntegrados = (dtRow.Table.Columns.Contains("nIntegrados") ? this._libFunciones.IsNumeric(dtRow["nIntegrados"].ToString()) ? int.Parse(dtRow["nIntegrados"].ToString()) : 0 : 0);
                                    objParticipante = pGetApartados(dsDatos, objParticipante);
                                    objProceso.lstParticipantes.Add(objParticipante);
                                }
                            }
                        }
                        else // Monitoreo
                        {
                            DataRow[] drResultado = dtTabla.Select("nIdProceso = " + objProceso.idProceso);
                            using (this._libFunciones = new clsValidacion())
                            {
                                foreach (DataRow dtRow in drResultado)
                                {
                                    clsParticipante objParticipante = new clsParticipante(dtRow.Table.Columns.Contains("nIdParticipante") ? (this._libFunciones.IsNumeric(dtRow["nIdParticipante"].ToString()) ? int.Parse(dtRow["nIdParticipante"].ToString()) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("nPuesto") ? (this._libFunciones.IsNumeric(dtRow["nPuesto"].ToString()) ? int.Parse(dtRow["nPuesto"].ToString()) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("sDPuesto") ? (dtRow["sDPuesto"].ToString()) : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("sDPerfil") ? (dtRow["sDPerfil"].ToString()) : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("sONotificaciones") ? dtRow["sONotificaciones"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("sOApertura") ? dtRow["sOApertura"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("nFKDepcia") ? (this._libFunciones.IsNumeric(dtRow["nFKDepcia"].ToString()) ? int.Parse(dtRow["nFKDepcia"].ToString()) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("sDCDepcia") ? dtRow["sDCDepcia"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("nIdUsuarioO") ? (this._libFunciones.IsNumeric(dtRow["nIdUsuarioO"].ToString()) ? int.Parse(dtRow["nIdUsuarioO"].ToString()) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("nNomUsuarioO") ? dtRow["nNomUsuarioO"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("nIdUsuarioR") ? (this._libFunciones.IsNumeric(dtRow["nIdUsuarioR"].ToString()) ? int.Parse(dtRow["nIdUsuarioR"].ToString()) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("nNomUsuarioR") ? dtRow["nNomUsuarioR"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("nIdUsuarioT") ? (this._libFunciones.IsNumeric(dtRow["nIdUsuarioT"].ToString()) ? int.Parse(dtRow["nIdUsuarioT"].ToString()) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("nNomUsuarioT") ? dtRow["nNomUsuarioT"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("cEstatusE") ? dtRow["cEstatusE"].ToString() : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("fAvance") ? (this._libFunciones.IsNumeric(dtRow["fAvance"].ToString()) ? float.Parse((float.Parse(dtRow["fAvance"].ToString())).ToString("0.00")) : 0) : 0
                                                                                        , dtRow.Table.Columns.Contains("dFInicio") ? this._libFunciones.IsDate(dtRow["dFInicio"].ToString()) ? DateTime.Parse(dtRow["dFInicio"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                                        , dtRow.Table.Columns.Contains("dFFinal") ? this._libFunciones.IsDate(dtRow["dFFinal"].ToString()) ? DateTime.Parse(dtRow["dFFinal"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                                        , this._strOpcion
                                                                                        );

                                    objParticipante.cIndCerrado = (dtRow.Table.Columns.Contains("cIndCerrado") ? dtRow["cIndCerrado"].ToString() : string.Empty);
                                    objParticipante.nAExluidos = (dtRow.Table.Columns.Contains("nExcluidos") ? (this._libFunciones.IsNumeric(dtRow["nExcluidos"].ToString()) ? int.Parse(dtRow["nExcluidos"].ToString()) : 0) : 0);

                                    objParticipante = pGetApartados(dsDatos, objParticipante);
                                    objParticipante = pGetEOObligado(dsDatos, objParticipante);
                                    objParticipante = pGetEOReceptor(dsDatos, objParticipante);
                                    objProceso.lstParticipantes.Add(objParticipante);
                                }
                            }
                        }
                    }
                    finally
                    {
                        dsDatos.Dispose();
                    }
                }

            }
            return objProceso;
        }
        #endregion

        #region pSetPropiedades()
        /// <summary>
        /// Setea las propiedades del objeto
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <returns>Verdadero si el proceso es exitoso y falso si fallo</returns>
        private void pSetPropiedades()
        {

            try
            {
                using (this._libFunciones = new clsValidacion())
                {
                    if (this._objDALSQL.Get_dtSet() != null && this._objDALSQL.Get_dtSet().Tables.Count > 0)
                    {
                        if (this._objDALSQL.Get_dtSet().Tables[0] != null) // En la tabla 0, regresa las propiedades generales
                        {
                            DataRow drGeneral = this._objDALSQL.Get_dtSet().Tables[0].Rows[0];
                            if (this._strOpcion.Equals("CARGA"))
                            {
                                this._intTieneProcesos = 1;
                            }
                            else if (this._strOpcion.Equals("MONITOREO"))
                            {
                                this._intTieneProcesos = drGeneral.Table.Columns.Contains("nNumProcesos") ? this._libFunciones.IsNumeric(drGeneral["nNumProcesos"].ToString()) ? int.Parse(drGeneral["nNumProcesos"].ToString()) : 0 : 0;
                            }
                            this._idUsuario = drGeneral.Table.Columns.Contains("nIdUsuario") ? this._libFunciones.IsNumeric(drGeneral["nIdUsuario"].ToString()) ? int.Parse(drGeneral["nIdUsuario"].ToString()) : 0 : 0;
                            this._strNomUsuario = drGeneral.Table.Columns.Contains("nNomUsuario") ? drGeneral["nNomUsuario"].ToString() : string.Empty;
                        }
                        if (this._objDALSQL.Get_dtSet().Tables[1] != null) // Vienen los procesos ER
                        {
                            this._lstProcesos = new List<clsProceso>();
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
                                objProceso = pGetParticipantes(this._objDALSQL.Get_dtSet(), objProceso);
                                this._lstProcesos.Add(objProceso);
                            }
                        }
                        //this._intTieneProcesos = this._lstProcesos.Count;
                    }
                    else
                    {
                        this._lstProcesos = null;
                        this._intTieneProcesos = 0;
                    }
                }
            }
            catch
            {
                this._intTieneProcesos = 0;
            }
            finally
            {
                this._objDALSQL.Get_dtSet().Dispose();
            }
        }


        #endregion

        #region void pGetProcesoERH()
        /// <summary>
        /// Retorna procesos ER activos e históricos 
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        public void pGetProcesoERH()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._idUsuario));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion.Trim()));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_MONITOREO", this._lstParametros))
                    {
                        pSetPropiedades();
                    }
                }
            }
        }
        #endregion

        #region pGetProcesosER()
        /// <summary>
        /// Retorna los procesos ER
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        public void pGetProcesosER()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para utilizar la capa de acceso a datos
            {
                using (this._libSQL = new libSQL()) // Objeto para utilizar la capa de acceso a datos
                {
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._idUsuario));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intPROCESO", this._idProceso));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTICIPANTE", this._nIdParticipante));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion.Trim()));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_REGISTRO", this._lstParametros))
                    {
                        pSetPropiedades(); // Se asignan las propiedades necesarias para un proceso ER
                    }
                }
            }

        }

        #endregion

        #region IDisposable Members
        /// <summary>
        /// Procedimiento para destruir un objeto te tipo anexo
        /// </summary>
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #endregion

        #region GETs y SETs
        #region GETs y SETs JESUS MONTERO CUEVAS
        /// <summary>
        /// JESUS MONETERO CUEVAS
        /// </summary>
        public int nIdProceso { get { return _idProceso; } set { _idProceso = value; } }
        public int nDepcia { get { return _nDepcia; } set { _nDepcia = value; } }
        public string sDPeriodo { get { return _sDPeriodo; } set { _sDPeriodo = value; } }
        public string sDProceso { get { return _sDProceso; } set { _sDProceso = value; } }
        public string sDTipoPeri { get { return _sDTipoPeri; } set { _sDTipoPeri = value; } }
        public string sFInicio { get { return _sFInicio; } set { _sFInicio = value; } }
        public string sFFinal { get { return _sFFinal; } set { _sFFinal = value; } }
        public char cIndActivo { get { return _cIndActivo; } set { _cIndActivo = value; } }
        public string sGuiaER { get { return _sGuiaER; } set { _sGuiaER = value; } }

        public string sSujetoObligado { get { return _sSujetoObligado; } set { _sSujetoObligado = value; } }
        public string sSujetoReceptor { get { return _sSujetoReceptor; } set { _sSujetoReceptor = value; } }
        public string dFechaExtemporanea { get { return _dFechaExtemporanea; } set { _dFechaExtemporanea = value; } }


        public string sCuenta { get { return _sCuenta; } set { _sCuenta = value; } }
        public string sNombre { get { return _sNombre; } set { _sNombre = value; } }
        public string sCorreo { get { return _sCorreo; } set { _sCorreo = value; } }
        public string sDDepcia { get { return _sDDepcia; } set { _sDDepcia = value; } }
        public string sDPuesto { get { return _sDPuesto; } set { _sDPuesto = value; } }
        public string sDPerfil { get { return _sDPerfil; } set { _sDPerfil = value; } }

        public int nPuesto { get { return _nPuesto; } set { _nPuesto = value; } }

        public string nEliminar { get { return _nEliminar; } set { _nEliminar = value; } }
        public int nIdParticipante { get { return _nIdParticipante; } set { _nIdParticipante = value; } }
        public int idProcExtem { get { return _idProcExtem; } set { _idProcExtem = value; } }
        public string sProceso { get { return _sProceso; } set { _sProceso = value; } }
        public string sNombreR { get { return _sNombreR; } set { _sNombreR = value; } }
        public string sNombreArch { get { return _sNombreArch; } set { _sNombreArch = value; } }
        public int nIdPerfil { get { return _nIdPerfil; } set { _nIdPerfil = value; } }
        public string puesto { get { return _puesto; } set { _puesto = value; } }
        public string dependencia { get { return _dependencia; } set { _dependencia = value; } }

        public int nidPartNue { get { return _nidPartNue; } set { _nidPartNue = value; } }     //Variable que regresa el id del Nuevo Participante (cambio sujeto obligado)

        public string cIndCerrado { get { return _cIndCerrado; } set { _cIndCerrado = value; } }
        public string sFechaCierre { get { return _sFechaCierre; } set { _sFechaCierre = value; } }


        #endregion

        #region GETs y SETs ERIK JOSE ENRIQUEZ CARMONA
        /// <summary>
        /// ERIK JOSE ENRIQUEZ CARMONA
        /// </summary>
        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }                             // ID del proceso ER
        public string strNomProceso { get { return _strNomProceso; } set { _strNomProceso = value; } }              // Nombre del proceso ER
        public string dteFInicial { get { return _dteFInicial; } set { _dteFInicial = value; } }                    // Fecha Inicial de un proceso ER
        public string dteFFinal { get { return _dteFFinal; } set { _dteFFinal = value; } }                          // Fecha Final de un proceso ER
        public int idUsuario { get { return _idUsuario; } set { _idUsuario = value; } }                             // ID del usuario que se va a consultar
        public string strNomUsuario { get { return _strNomUsuario; } set { _strNomUsuario = value; } }              // Nombre del usuario que esta conformando la ER
        public int intTieneProcesos { get { return _intTieneProcesos; } set { _intTieneProcesos = value; } }        // Variable para determinar si tiene procesos que atender o consultar
        public int idAnexoActual { get { return _idAnexoActual; } set { _idAnexoActual = value; } }                 // ID del anexo que se va a buscar
        public List<clsProceso> lstProcesos { get { return _lstProcesos; } set { _lstProcesos = value; } }          // Listado de procesos ER
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }                          // Variable para controlar la acción a realizar
        public string strOpcion { get { return _strOpcion; } set { _strOpcion = value; } }                          // Variable para manejar la opción CARGA/CONSULTA

        #endregion

        #region GETs y SETs Ma. Guadalupe Dominguez Julián
        /// <summary>
        /// 
        /// </summary>
        public int nidProcPart { get { return _nidProcPart; } set { _nidProcPart = value; } }                             // ID del proceso ER

        #endregion
        #endregion
    }
}