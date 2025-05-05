using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using libFunciones;
using System.Globalization;
using System.Threading;
/// <summary>
/// Objetivo:                       Clase para el manejo de los participantes de una ER
/// Versión:                        1.0
/// Autor:                          Erik José Enríquez Carmona, Jesús Montero Cuevas
/// Fecha de Creación:              5 de Marzo 2013
/// Fecha ultima modificacion:      19 de Marzo 2013 por Jesús Montero Cuevas
/// Tablas de la BD que utiliza:    
/// </summary>
/// 
namespace nsSERUV
{
    public class clsParticipante : IDisposable
    {
        #region Variables globales Jesús Montero Cuevas

        System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
        private clsDALSQL _objDALSQL;
        private libSQL _libSQL;
        private clsValidacion _libFunciones;
        bool blnRespuesta = false;

        #endregion

        #region Propiedades privadas
        #region Propiedades Erik José Enríquez Carmona 
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// Propiedades que se utilizan en la forma SRACARINF.aspx
        /// </summary>
        private int _idParticipante;        // ID del participante de una ER

        private string _strDPuesto;         // Descripción del puesto
        private int _idUsuarioO;            // ID del usuario Obligado
        private int _idUsuarioT;            // ID del usuario Obligado
        private int _idUsuarioR;            // ID del usuario Receptor
        private string _strNomUsuarioO;     // Nombre del usuario Obligado
        private string _strNomUsuarioT;     // Nombre del usuario Obligado
        private string _strNomUsuarioR;     // Nombre del usuario Receptor
        private string _strPefilUsuario;    // Perfil del usuario que entro a realizar la carga de información
        private string _strNomDepcia;       // Nombre de la dependencia donde se va a realizar la carga de información

        private string _cIndCerrado;        // Indicador de cerrado del participante
        private string _strOPEnviar;        // Opción para enviar la ER
        private string _strOPCerrar;        // Opción para cerrar Anexos
        private string _strEstatusP;        // Estatus de la entrega del participante

        private string _strOPNotif;         // Opción para enviar/ver notificaciones
        private string _strOPApertura;      // Opción para solicitar/Apertura

        private float _fltAvance;           // Avance de la entrega 

        private List<clsApartado> _lstApartados;    //Lista de apartados por participante
        private List<clsUsuario> _lstEOObligado;
        private List<clsUsuario> _lstEOReceptor;


        private int _idProceso;             //id del proceso
        private int _nDepcia;               //clave de la dependencia
        private int _nPuesto;
        private string _sNombre;

        private int _idUsuario;
        private string _strAccion;
        private string _strOpcion;
        private string _strResp;

        private string _dFInicio;
        private string _dFFin;

        private int _nAPendientes;
        private int _nAExluidos;
        private int _nAIntegrados;

        #endregion
        #endregion

        #region Propiedades Jesús Montero Cuevas
        private List<clsProcesoER> _laPeriodosEntrega;
        private List<clsParticipante> _laRegresaDatos;
        private string _sFInicio;
        private string _sFFinal;
        private string _sJustificacion;
        private int _nidPerfil;
        private string _sDPerfil;
        private List<clsParticipante> _laPerfiles;
        public List<clsParticipante> laPerfiles { get { return _laPerfiles; } set { _laPerfiles = value; } }
        #endregion

        #region Contructor(es)

        #region clsParticipante()
        /// <summary>
        /// Constructor vacio
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        public clsParticipante()
        {
        }
        #endregion

        #region clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPEnviar, string sOPCerrar, int nDepcia, string sDDepcia, int nIdUsuarioO, string sNomUsuarioO, string sEstatusP, float nAvance)
        /// <summary>
        /// Contructor con 10 parametros utilizado por la clase clsProcesoER en el procedimiento pSetPropiedades()
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nPuesto">Número de puesto</param>
        /// <param name="sDPuesto">Descripción del puesto</param>
        /// <param name="sDPerfil">Descripción del perfil del usuario en ese participante</param>
        /// <param name="sOPEnviar">Opción enviar Entrega</param>
        /// <param name="sOPCerrar">Opción cerrar Anexos</param>
        /// <param name="nDepcia">Número de Dependencia</param>
        /// <param name="sDDepcia">Descripción de la Dependencia</param>
        /// <param name="nIdUsuarioO">ID del usuario Obligado</param>
        /// <param name="sNomUsuarioO">Nombre del usuario obligado</param>
        /// <param name="sEstatusP">Estatus de la Entrega del Participante</param>
        /// <param name="nAvance">% de Avance de la entrega</param>
        public clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPEnviar, string sOPCerrar, int nDepcia, string sDDepcia, int nIdUsuarioO,
                                string sNomUsuarioO, string sEstatusP, float nAvance)
        {
            this._idParticipante = nIdParticipante;
            this._nPuesto = nPuesto;
            this._strDPuesto = sDPuesto;
            this._strPefilUsuario = sDPerfil;
            this._strOPEnviar = sOPEnviar;
            this._strOPCerrar = sOPCerrar;
            this._nDepcia = nDepcia;
            this._strNomDepcia = sDDepcia;
            this._idUsuarioO = nIdUsuarioO;
            this._strNomUsuarioO = sNomUsuarioO;
            this._strEstatusP = sEstatusP;
            this._fltAvance = nAvance;

            this._lstApartados = new List<clsApartado>();
        }
        #endregion

        #region clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPEnviar, string sOPCerrar, int nDepcia, string sDDepcia, int nIdUsuarioO, string sNomUsuarioO, int nIdUsuarioT, string sNomUsuarioT, string sEstatusP, float nAvance, string dFInicio, string dFFin)
        /// <summary>
        /// Contructor con 12 parametros utilizado por la clase clsProcesoER en el procedimiento pSetPropiedades()
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nPuesto">Número de puesto</param>
        /// <param name="sDPuesto">Descripción del puesto</param>
        /// <param name="sDPerfil">Descripción del perfil del usuario en ese participante</param>
        /// <param name="sOPEnviar">Opción enviar Entrega</param>
        /// <param name="sOPCerrar">Opción cerrar Anexos</param>
        /// <param name="nDepcia">Número de Dependencia</param>
        /// <param name="sDDepcia">Descripción de la Dependencia</param>
        /// <param name="nIdUsuarioO">ID del usuario Obligado</param>
        /// <param name="sNomUsuarioO">Nombre del usuario obligado</param>
        /// <param name="nIdUsuarioT">ID del usuario Titular</param>
        /// <param name="sNomUsuarioT">Nombre del usuario titular</param>
        /// <param name="sEstatusP">Estatus de la Entrega del Participante</param>
        /// <param name="nAvance">% de Avance de la entrega</param>
        public clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPEnviar, string sOPCerrar, int nDepcia, string sDDepcia, int nIdUsuarioO,
                                string sNomUsuarioO, int nIdUsuarioT, string sNomUsuarioT, string sEstatusP, float nAvance, string dFInicio, string dFFin)
        {
            this._idParticipante = nIdParticipante;
            this._nPuesto = nPuesto;
            this._strDPuesto = sDPuesto;
            this._strPefilUsuario = sDPerfil;
            this._strOPEnviar = sOPEnviar;
            this._strOPCerrar = sOPCerrar;
            this._nDepcia = nDepcia;
            this._strNomDepcia = sDDepcia;
            this._idUsuarioO = nIdUsuarioO;
            this._strNomUsuarioO = sNomUsuarioO;
            this._idUsuarioT = nIdUsuarioT;
            this._strNomUsuarioT = sNomUsuarioT;
            this._strEstatusP = sEstatusP;
            this._fltAvance = nAvance;
            this._dFInicio = dFInicio;
            this._dFFin = dFFin;

            this._lstApartados = new List<clsApartado>();
        }
        #endregion

        #region clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPNotificacion, string sOPApertura, int nDepcia, string sDDepcia, int nIdUsuarioO, string sNomUsuarioO, int nIdUsuarioT, string sNomUsuarioT, string sEstatusP, float nAvance, string dFInicio, string dFFin, string sOpcion)
        /// <summary>
        /// Contructor con 10 parametros utilizado por la clase clsProcesoER en el procedimiento pSetPropiedades()
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nPuesto">Número de puesto</param>
        /// <param name="sDPuesto">Descripción del puesto</param>
        /// <param name="sDPerfil">Descripción del perfil del usuario en ese participante</param>
        /// <param name="sOPEnviar">Opción enviar Entrega</param>
        /// <param name="sOPCerrar">Opción cerrar Anexos</param>
        /// <param name="nDepcia">Número de Dependencia</param>
        /// <param name="sDDepcia">Descripción de la Dependencia</param>
        /// <param name="nIdUsuarioO">ID del usuario Obligado</param>
        /// <param name="sNomUsuarioO">Nombre del usuario obligado</param>
        /// <param name="sEstatusP">Estatus de la Entrega del Participante</param>
        /// <param name="nAvance">% de Avance de la entrega</param>
        public clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPNotificacion, string sOPApertura, int nDepcia, string sDDepcia, int nIdUsuarioO,
                                string sNomUsuarioO, int nIdUsuarioT, string sNomUsuarioT, string sEstatusP, float nAvance, string dFInicio, string dFFin, string sOpcion)
        {
            this._idParticipante = nIdParticipante;
            this._nPuesto = nPuesto;
            this._strDPuesto = sDPuesto;
            this._strPefilUsuario = sDPerfil;
            this._strOPNotif = sOPNotificacion;
            this._strOPApertura = sOPApertura;
            this._nDepcia = nDepcia;
            this._strNomDepcia = sDDepcia;
            this._idUsuarioO = nIdUsuarioO;
            this._strNomUsuarioO = sNomUsuarioO;
            this._idUsuarioT = nIdUsuarioT;
            this._strNomUsuarioT = sNomUsuarioT;
            this._strEstatusP = sEstatusP;
            this._fltAvance = nAvance;
            this._dFInicio = dFInicio;
            this._dFFin = dFFin;

            this._lstApartados = new List<clsApartado>();
        }
        #endregion

        #region clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPNotificacion, string sOPApertura, int nDepcia, string sDDepcia, int nIdUsuarioO, string sNomUsuarioO, int nIdUsuarioR, string sNomUsuarioR,int nIdUsuarioT, string sNomUsuarioT, string sEstatusP, float nAvance, string dFInicio, string dFFin, string sOpcion)
        /// <summary>
        /// Contructor con 10 parametros utilizado por la clase clsProcesoER en el procedimiento pSetPropiedades()
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nPuesto">Número de puesto</param>
        /// <param name="sDPuesto">Descripción del puesto</param>
        /// <param name="sDPerfil">Descripción del perfil del usuario en ese participante</param>
        /// <param name="sOPEnviar">Opción enviar Entrega</param>
        /// <param name="sOPCerrar">Opción cerrar Anexos</param>
        /// <param name="nDepcia">Número de Dependencia</param>
        /// <param name="sDDepcia">Descripción de la Dependencia</param>
        /// <param name="nIdUsuarioO">ID del usuario Obligado</param>
        /// <param name="sNomUsuarioO">Nombre del usuario obligado</param>
        /// <param name="sEstatusP">Estatus de la Entrega del Participante</param>
        /// <param name="nAvance">% de Avance de la entrega</param>
        public clsParticipante(int nIdParticipante, int nPuesto, string sDPuesto, string sDPerfil, string sOPNotificacion, string sOPApertura, int nDepcia, string sDDepcia, int nIdUsuarioO,
                                string sNomUsuarioO, int nIdUsuarioR, string sNomUsuarioR, int nIdUsuarioT, string sNomUsuarioT, string sEstatusP, float nAvance, string dFInicio, string dFFin, string sOpcion)
        {
            this._idParticipante = nIdParticipante;
            this._nPuesto = nPuesto;
            this._strDPuesto = sDPuesto;
            this._strPefilUsuario = sDPerfil;
            this._strOPNotif = sOPNotificacion;
            this._strOPApertura = sOPApertura;
            this._nDepcia = nDepcia;
            this._strNomDepcia = sDDepcia;
            this._idUsuarioO = nIdUsuarioO;
            this._strNomUsuarioO = sNomUsuarioO;
            this._idUsuarioR = nIdUsuarioR;
            this._strNomUsuarioR = sNomUsuarioR;
            this._idUsuarioT = nIdUsuarioT;
            this._strNomUsuarioT = sNomUsuarioT;
            this._strEstatusP = sEstatusP;
            this._fltAvance = nAvance;
            this._dFInicio = dFInicio;
            this._dFFin = dFFin;

            this._lstApartados = new List<clsApartado>();
        }
        #endregion

        #endregion

        #region Métodos Jesús Montero Cuevas
        /// <summary>
        /// Método que se encarga de asignar sujeto receptor al participante
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nIdSujRecp">ID del usuario que se asiganará como sujeto receptor</param>
        /// <param name="nIdUsuario">ID del usuario logueado</param>
        /// <returns></returns>
        public string fAsignarSujReceptor(int nIdParticipante, int nIdSujRecp, int nIdUsuario)
        {

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ASIG_SUJRECP"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intUSUARIORECP", nIdSujRecp));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));              //regreso la respuesta de la acción
                lstParametros.Add(lSQL.CrearParametro("@intNUEVOPARTICIPANTE", 0, SqlDbType.Int, ParameterDirection.Output)); //regreso el ID del nuevo participante despues de duplicar los registros 

                if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_PARTICIPANTE", lstParametros))                                       //Ejecuto el ´procedimiento almacenado
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString() + "," + arrOUT[1].ToString();

                    DataSet ds = objDALSQL.Get_dtSet();                                         //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                    string dato = clsJsonMethods.ConvertDataSetToXML(ds);                       //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                    clsWSNotif wsNotif = new clsWSNotif();                                      //  Crea un objeto que se usara para la comunicación con la clase del WebService
                    Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "SUJ_RECP"));        //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                    tmod.Start();
                }
            }
            return _strResp;      //regreso la respuesta de la operación
        }



        /// <summary>
        /// Método que se encarga de incluir dependencias a un proceso
        /// </summary>
        /// <param name="sSeleccionadas">cadena con las dependencias</param>
        /// <param name="nIdUsuario">ID usuario logueado</param>
        /// <param name="nidProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public string fIncluirDependencias(string sSeleccionadas, int nIdUsuario, int nidProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "INCLUIR_PART"));
                lstParametros.Add(lSQL.CrearParametro("@strPARTICIPANTES", sSeleccionadas));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nidProceso));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_PARTICIPANTE", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();

                    DataSet ds = objDALSQL.Get_dtSet();                                           //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                    string dato = clsJsonMethods.ConvertDataSetToXML(ds);                        //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                    clsWSNotif wsNotif = new clsWSNotif();                                      //  Crea un objeto que se usara para la comunicación con la clase del WebService
                    Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "INC_PART"));        //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                    tmod.Start();
                }
            }
            return _strResp; //Regreso la respuesta
        }


        /// <summary>
        /// Método que exluye un participante del proceso
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nUsuario">ID del usuario logueado</param>
        /// <returns></returns>
        public string fExcluirParticipante(int nIdParticipante, int nUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "EXCL_PART"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_PARTICIPANTE", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }

                // no borrar
                //if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_PARTICIPANTE", lstParametros))
                //{
                //    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                //    this._strResp = arrOUT[0].ToString();

                //if (this._strResp == "1")
                //{
                //    DataSet ds = objDALSQL.Get_dtSet();
                //    string dato = clsJsonMethods.ConvertDataSetToXML(ds);

                //    clsWSNotif wsNotif = new clsWSNotif();
                //    Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "EXC_PART"));
                //    tmod.Start();
                //}
                //}
            }
            return _strResp; //Regreso la respuesta
        }

        /// <summary>
        /// Método que guarda periodos extemporaneos de un participante
        /// </summary>
        /// <param name="sJustificacion">Justificación del periodo extemporaneo</param>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="idProcExtem">ID procExtem</param>
        /// <param name="sFeIn">fecha inicial</param>
        /// <param name="sFeFIn">fecha final</param>
        /// <param name="nIdUsuario">ID del usuario logueado</param>
        /// <returns></returns>
        public string fGuarPerExt(string sJustificacion, int nIdParticipante, int idProcExtem, string sFeIn, string sFeFIn, int nIdUsuario)
        {
            using (clsValidacion objValidacion = new clsValidacion())
            {
                string sFeInicial1 = (objValidacion.IsDate(objValidacion.ConvertDatePicker(sFeIn)) ? DateTime.Parse(objValidacion.ConvertDatePicker(sFeIn)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                string sFeFinal1 = (objValidacion.IsDate(objValidacion.ConvertDatePicker(sFeFIn)) ? DateTime.Parse(objValidacion.ConvertDatePicker(sFeFIn)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));

                using (clsDALSQL objDALSQL = new clsDALSQL(false))
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "GD_PERI_EXT"));
                    lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                    lstParametros.Add(lSQL.CrearParametro("@intIDPROCEXTEM", idProcExtem));
                    lstParametros.Add(lSQL.CrearParametro("@strJUSTIFICACION", sJustificacion));
                    lstParametros.Add(lSQL.CrearParametro("@strFEIN", sFeInicial1));
                    lstParametros.Add(lSQL.CrearParametro("@strFEFIN", sFeFinal1));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    lstParametros.Add(lSQL.CrearParametro("@intNUEVOPARTICIPANTE", 0, SqlDbType.Int, ParameterDirection.Output));

                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_PARTICIPANTE", lstParametros))
                    {
                        System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                        this._strResp = arrOUT[0].ToString() + "," + arrOUT[1].ToString();
                    }

                    ////No borrar
                    //if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_PARTICIPANTE", lstParametros))
                    //{
                    //    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    //    this._strResp = arrOUT[0].ToString() + "," + arrOUT[1].ToString();

                    //    if (arrOUT[0].ToString() == "1")
                    //    {
                    //     DataSet ds = objDALSQL.Get_dtSet();
                    //    string dato = clsJsonMethods.ConvertDataSetToXML(ds);

                    //    clsWSNotif wsNotif = new clsWSNotif();
                    //    Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "PART_EXT"));
                    //    tmod.Start();
                    //    }
                    //}
                }
            }
            //objArchivo.dteFCorte = (objValidacion.IsDate(objValidacion.ConvertDatePicker(txt_dFCorte.Text)) ? DateTime.Parse(objValidacion.ConvertDatePicker(txt_dFCorte.Text)).ToString("yyyyMMdd HH:mm s") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
            return _strResp; //Regreso la respuesta de la operación
        }

        /// <summary>
        /// Método que regresa los usuarios que podrán ser asignados como sujeto receptor en la dependencia
        /// </summary>
        /// <param name="nIdParticipante"></param>
        /// <param name="idProceso"></param>
        /// <returns></returns>
        public bool fGetSujetoReceptor(int nIdParticipante, int idProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBT_SUJ_RECP"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", idProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PARTICIPANTE", lstParametros))
                {
                    laRegresaDatos = new List<clsParticipante>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "SUJETO RECEPTOR");
                }
            }
            return blnRespuesta;
        }

        /// <summary>
        /// Método que obtiene los periodos extemporaneos de una dependencia
        /// </summary>
        /// <param name="idParticipante">ID del particiapnte</param>
        /// <returns></returns>
        public bool fGetPeriodosExtemporaneos(int idParticipante)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "PER_EXT"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", idParticipante));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PARTICIPANTE", lstParametros))
                {
                    laRegresaDatos = new List<clsParticipante>();       //Creo la lista que regresara el periodo extemporaneo del participante
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PERIODO EXTEMPORANEO");  //Se manda a llamar el método que llenara la lista con el resultado de la consulta
                }
            }
            return blnRespuesta;
        }


        /// <summary>
        /// Método que regresa los participantes que no estan asociados a un proceso
        /// </summary>
        /// <returns></returns>
        public bool getParticipantesSinProceso()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "PARTSINPROC"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_PARTICIPANTE", lstParametros))
                {
                    laRegresaDatos = new List<clsParticipante>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PARTICIPANTES SIN PERIODO");
                }
            }
            return blnRespuesta;
        }

        /// <summary>
        /// Este método es llamado por varios metodos el cual se encarga de llenar las listas con los resultaos de las consultas
        /// </summary>
        /// <param name="dataset">el dataset que contiene el resultado de la consulta</param>
        /// <param name="op">la opción del case</param>
        private void pLlenar_Lista(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "SUJETO RECEPTOR":
                            laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsParticipante objPart = new clsParticipante();
                                objPart.idUsuario = int.Parse(row["idUsuario"].ToString());
                                objPart.sNombre = row["sNombre"].ToString();

                                if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                                {
                                    laRegresaDatos.Add(null);
                                }
                                else
                                {
                                    objPart.laPerfiles = getPerfilesXUsuario(dataset, objPart.idUsuario);
                                }
                                laRegresaDatos.Add(objPart);
                            }
                            break;

                        case "PERIODO EXTEMPORANEO":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsParticipante objPart = new clsParticipante();
                                objPart.idParticipante = int.Parse(row["idParticipante"].ToString());
                                objPart.sFInicio = DateTime.Parse(row["dFInicio"].ToString()).ToString("dd-MM-yyyy");
                                objPart.sFFinal = DateTime.Parse(row["dFFinal"].ToString()).ToString("dd-MM-yyyy");
                                objPart.sJustificacion = row["sJustificacion"].ToString();
                                laRegresaDatos.Add(objPart);
                            }
                            break;

                        case "PARTICIPANTES SIN PERIODO":
                            laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsParticipante objPart = new clsParticipante();
                                objPart.nDepcia = int.Parse(row["nDepcia"].ToString());
                                objPart.strDDepcia = row["sDDepcia"].ToString();
                                laRegresaDatos.Add(objPart);
                            }
                            break;
                    }
                }
                else
                {
                    laRegresaDatos.Add(null);
                }
            }
            catch
            {
                laRegresaDatos.Add(null);
            }
            finally
            {
                dataset = null;
            }
        }


        /// <summary>
        /// Método que regresa los perfiles por usuario
        /// </summary>
        /// <param name="dataset">Recibe el datasaet que contiene la tabla que es llena por la consulta</param>
        /// <param name="NidUsuario">ID del usuario</param>
        /// <returns></returns>
        public List<clsParticipante> getPerfilesXUsuario(DataSet dataset, int NidUsuario)
        {
            DataTable tabla = dataset.Tables[1];
            List<clsParticipante> laPerfilPorUsuario = new List<clsParticipante>();
            clsParticipante objPart;
            DataRow[] result = tabla.Select("idUsuario =" + NidUsuario);
            foreach (DataRow row in result)
            {
                objPart = new clsParticipante();
                objPart.idUsuario = int.Parse(row["idUsuario"].ToString());
                objPart.nIdPerfil = int.Parse(row["idPerfil"].ToString());
                objPart.sDPerfil = row["sDPerfil"].ToString();
                laPerfilPorUsuario.Add(objPart);
            }
            return laPerfilPorUsuario;
        }


        #endregion

        #region Métodos Erik José Enríquez Carmona

        #region clsApartado pGetAnexos(DataSet dsDatos, clsApartado objApartado)
        /// <summary>
        /// Función asigna los anexos pertenecientes a una apartado
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="dsDatos">Data Set con los datos</param>
        /// <param name="objApartado">Objeto actual apartado</param>
        /// <returns>Un objeto clsApartado con una listado de anexos</returns>
        private clsApartado pGetAnexos(DataSet dsDatos, clsApartado objApartado)
        {
            if (dsDatos != null && objApartado != null)
            {
                if (dsDatos.Tables[1] != null)
                {
                    try
                    {
                        /*SE ASIGNA LA TABLA DONDE VIENEN LOS ANEXOS*/
                        DataTable dtTabla = dsDatos.Tables[1];
                        if (dtTabla.Columns.Contains("nIdParticipante") && dtTabla.Columns.Contains("nIdApartado") && dtTabla.Columns.Contains("nIdAnexo")
                            && dtTabla.Columns.Contains("cIndEntrega") && dtTabla.Columns.Contains("sAnexo") && dtTabla.Columns.Contains("sDAnexo")
                            && dtTabla.Columns.Contains("nIdPartAplic") && dtTabla.Columns.Contains("nIdUsuario")
                            && dtTabla.Columns.Contains("sJustificacion") && !dtTabla.Columns.Contains("nNumArchivos")
                            ) // Se validan las propiedades necesarias para la asignación de propiedades (módulo de registro)
                        {
                            DataRow[] drResultado = dtTabla.Select("nIdParticipante = " + objApartado.idParticipante +
                                                                    " AND nIdApartado=" + objApartado.idApartado
                                                                    ); // Se oconsulta la tala asignando a cada participante y apartado los anexos que le corresponden 
                            using (this._libFunciones = new clsValidacion()) // Objeto de validación
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
                                                                            ));
                                }
                                // Proceso para determinar si el apartado contiene anexos integrados, excluidos o pendientes
                                objApartado.chrIndAnxInt = (objApartado.lstAnexos.Exists(delegate (clsAnexo x) { return x.charIndEntrega.Equals("E"); }) ? "E" :
                                                           (objApartado.lstAnexos.Exists(delegate (clsAnexo x) { return x.charIndEntrega.Equals("I"); }) ? "I" : "P"));
                            }
                        }
                        else // Opción ocuapada en los modulos de monitoreo y cierre, las propiedades necesarias son distintas a las de registro
                        {
                            DataRow[] drResultado = dtTabla.Select("nIdParticipante = " + objApartado.idParticipante +
                                                                    " AND nIdApartado=" + objApartado.idApartado
                                                                    ); // Se oconsulta la tala asignando a cada participante y apartado los anexos que le corresponden 
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
                                                                            ));
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
            return objApartado;
        }
        #endregion

        #region clsParticipante pGetApartados(DataSet dsDatos)
        /// <summary>
        /// Función que asigna los apartados que le corresponden a un participante
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="dsDatos">Data Set con los datos</param>
        /// <param name="objParticipante">Objeto actual participante</param>
        /// <returns></returns>
        private void pGetApartados(DataSet dsDatos)
        {
            if (dsDatos != null)
            {
                if (dsDatos.Tables[0] != null)
                {
                    /*SE ASIGNA LA TABLA DONDE VIENEN LOS APARTADOS*/
                    DataTable dtTabla = dsDatos.Tables[0];
                    try
                    {
                        // Se consulta por participante, los apartados que le corresponde
                        DataRow[] drResultado = dtTabla.Select("nIdParticipante = " + this._idParticipante);
                        using (this._libFunciones = new clsValidacion())
                        {
                            this._lstApartados = null;
                            this._lstApartados = new List<clsApartado>();
                            foreach (DataRow dtRow in drResultado)
                            {
                                clsApartado objApartado = new clsApartado(dtTabla.Columns.Contains("nIdParticipante") ? this._libFunciones.IsNumeric(dtRow["nIdParticipante"].ToString()) ? int.Parse(dtRow["nIdParticipante"].ToString()) : 0 : 0
                                                                            , dtTabla.Columns.Contains("nIdApartado") ? this._libFunciones.IsNumeric(dtRow["nIdApartado"].ToString()) ? int.Parse(dtRow["nIdApartado"].ToString()) : 0 : 0
                                                                            , dtTabla.Columns.Contains("sApartado") ? dtRow["sApartado"].ToString() : string.Empty
                                                                            , dtTabla.Columns.Contains("sDApartado") ? dtRow["sDApartado"].ToString() : string.Empty
                                                                            , dtTabla.Columns.Contains("cAplica") ? dtRow["cAplica"].ToString() : string.Empty);

                                objApartado = pGetAnexos(dsDatos, objApartado); // se consultan los anexos que le corresponden al apartado del partcipante
                                this._lstApartados.Add(objApartado); // se asigna el objeto apartado con su listado de anexos a el listado de apartado del participante
                            }
                        }
                    }
                    finally
                    {
                        dsDatos.Dispose();
                    }
                }
            }
        }
        #endregion

        #region void pGetDatosERH()
        /// <summary>
        /// Regresará información asociada a la ER de un participante
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actialización: 29 Abril 2013
        /// </summary>
        public void pGetDatosERH()
        {
            this.lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para utilizar la capa de acceso a datos
            {
                using (this._libSQL = new libSQL()) // Objeto para utilizar la capa de acceso a datos
                {
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._idUsuario));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTICIPANTE", this._idParticipante));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion));
                    if (this._objDALSQL.ExecQuery_SET_OUT("PA_SELV_MONITOREO", this.lstParametros))
                    {
                        pGetApartados(this._objDALSQL.Get_dtSet()); // Se asignan los apartados y anexos que le corresponden a un participante
                    }
                }
            }
        }
        #endregion

        #region void pEnviarER()
        /// <summary>
        /// Envia una proceso ER de un participante para su revisión
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actialización: 22 Marzo 2013
        /// </summary>
        public void pEnviarER()
        {
            this.lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para utilizar la capa de acceso a datos
            {
                using (this._libSQL = new libSQL()) // Objeto para utilizar la capa de acceso a datos
                {
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTICIPANTE", this._idParticipante));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._idUsuario));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    if (this._objDALSQL.ExecQuery_SET_OUT("PA_IDUH_PARTICIPANTE", this.lstParametros))
                    {
                        System.Collections.ArrayList arrOUT = this._objDALSQL.Get_aOutput();
                        this._strResp = arrOUT[0].ToString();

                        if (this._strResp.Equals("1"))
                        {
                            DataSet ds = this._objDALSQL.Get_dtSet(); // se consulta el dataSet donde se almacena las personas a las cuales se va a notificar del envió de una ER
                            string dato = clsJsonMethods.ConvertDataSetToXML(ds); // Se convierte el dataSet en un XML para la comunicación con el WebService que envía las notificaciones

                            clsWSNotif wsNotif = new clsWSNotif(); // Se crea un objeto de la clase que conecta con el WebService
                            Thread tmod = new Thread(() => wsNotif.SendNotif(dato, strAccion)); // Se crea un hilo de ejecución el envio de notificaciones asincronas
                            tmod.Start(); // se ejecuta el hilo
                        }
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
        /// <summary>
        /// Autor Erik José Enríquez Carmona
        /// </summary>
        /// 

        public int idParticipante { get { return _idParticipante; } set { _idParticipante = value; } }

        public int idUsuarioO { get { return _idUsuarioO; } set { _idUsuarioO = value; } }
        public string strNomUsuarioO { get { return _strNomUsuarioO; } set { _strNomUsuarioO = value; } }

        public int idUsuarioT { get { return _idUsuarioT; } set { _idUsuarioT = value; } }
        public string strNomUsuarioT { get { return _strNomUsuarioT; } set { _strNomUsuarioT = value; } }

        public int idUsuarioR { get { return _idUsuarioR; } set { _idUsuarioR = value; } }
        public string strNomUsuarioR { get { return _strNomUsuarioR; } set { _strNomUsuarioR = value; } }

        public string strPerfilUsuario { get { return _strPefilUsuario; } set { _strPefilUsuario = value; } }
        public string strOPEnviar { get { return _strOPEnviar; } set { _strOPEnviar = value; } }
        public string strOPCerrar { get { return _strOPCerrar; } set { _strOPCerrar = value; } }

        public string strEstatusP { get { return _strEstatusP; } set { _strEstatusP = value; } }
        public float fltAvance { get { return _fltAvance; } set { _fltAvance = value; } }

        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }
        public int nDepcia { get { return _nDepcia; } set { _nDepcia = value; } }
        public string strDDepcia { get { return _strNomDepcia; } set { _strNomDepcia = value; } }
        public int nPuesto { get { return _nPuesto; } set { _nPuesto = value; } }
        public string strDPuesto { get { return _strDPuesto; } set { _strDPuesto = value; } }
        public string sNombre { get { return _sNombre; } set { _sNombre = value; } }

        public List<clsApartado> lstApartados { get { return _lstApartados; } set { _lstApartados = value; } }
        public List<clsUsuario> lstEOObligado { get { return _lstEOObligado; } set { _lstEOObligado = value; } }
        public List<clsUsuario> lstEOReceptor { get { return _lstEOReceptor; } set { _lstEOReceptor = value; } }

        public int idUsuario { get { return _idUsuario; } set { _idUsuario = value; } }

        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public string strOpcion { get { return _strOpcion; } set { _strOpcion = value; } }
        public string strResp { get { return _strResp; } set { _strResp = value; } }

        public string dteFInicio { get { return _dFInicio; } set { _dFInicio = value; } }
        public string dteFFin { get { return _dFFin; } set { _dFFin = value; } }

        public string strOPNotif { get { return _strOPNotif; } set { _strOPNotif = value; } }
        public string strOPApertura { get { return _strOPApertura; } set { _strOPApertura = value; } }

        public int nAPendientes { get { return _nAPendientes; } set { _nAPendientes = value; } }
        public int nAIntegrados { get { return _nAIntegrados; } set { _nAIntegrados = value; } }
        public int nAExluidos { get { return _nAExluidos; } set { _nAExluidos = value; } }

        public string cIndCerrado { get { return _cIndCerrado; } set { _cIndCerrado = value; } }

        #endregion

        #region GETs y SETs Jesús Montero Cuevas
        public List<clsProcesoER> laPeriodosEntrega { get { return _laPeriodosEntrega; } set { _laPeriodosEntrega = value; } }
        public List<clsParticipante> laRegresaDatos { get { return _laRegresaDatos; } set { _laRegresaDatos = value; } }
        public string sFInicio { get { return _sFInicio; } set { _sFInicio = value; } }
        public string sFFinal { get { return _sFFinal; } set { _sFFinal = value; } }
        public string sJustificacion { get { return _sJustificacion; } set { _sJustificacion = value; } }
        public int nIdPerfil { get { return _nidPerfil; } set { _nidPerfil = value; } }
        public string sDPerfil { get { return _sDPerfil; } set { _sDPerfil = value; } }
        #endregion
    }
}