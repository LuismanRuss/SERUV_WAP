using System;
using System.Collections.Generic;
using System.Web;
using libFunciones;
using System.Data;
using nsSERUV;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Collections;
using System.Threading;

/// <summary>
/// Objetivo:                       Clase para el manejo de Notificaciones dentro de un Proceso ER
/// Versión:                        1.0
/// Autor:                          Edgar Morales González
/// Tablas de la BD que utiliza:    APCNOTIFICA y APRNOTIPROC
/// </summary>
/// 

namespace nsSERUV
{
    public class clsNotificacion : IDisposable
    {
        #region variables de la clase Notificacion
        private int _nUsuario;                  //  Id del usuario que envia la notificacion
        private int _idNotifica;                //  Id de la notificación en cuestión
        private string _strAsunto;              //  Asunto del correo
        private string _strMensaje;             //  Asunto del mensaje
        private char _cIndActivo;               //  Indica si la notificación esta activa
        private char _cLunes;                   //  Indica si la notificación se enviara el día lunes
        private char _cMartes;                  //  Indica si la notificación se enviara el día martes
        private char _cMiercoles;               //  Indica si la notificación se enviara el día miercoles
        private char _cJueves;                  //  Indica si la notificación se enviara el día jueves
        private char _cViernes;                 //  Indica si la notificación se enviara el día viernes
        private char _cSabado;                  //  Indica si la notificación se enviara el día sabado
        private char _cDomingo;                 //  Indica si la notificación se enviara el día domingo

        //private int _idUsuarioR;

        private List<clsNotificacion> _laNotificacion; //Lista de Notificacion
        private System.Collections.ArrayList lstParametros;

        System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros para enviar notificación
        clsDALSQL _objDALSQL;
        libSQL _libSQL;
        //clsValidacion _libFunciones;


        private string _strACCION;                  //Indica la Accion que ejecutara el procedimiento almacenado
        private string _strOPCION;
        //Getters y Setters para el Manejo de la tabla APRNOTIPROC
        //private int _idNotiProc;
        //private int _idFKNotifica;
        //private int _idFKProceso;
        private int _nDiasAntes;
        private string _strDFIniProc;
        private string _strDFFinProc;
        //private string _strDFAlta;
        //private string _strDFUltModif;

        private int _idUsuRemit;
        private int _idFKUsuDest;
        private int _idProceso;
        private string _sAsunto;
        private string _sMensaje;
        private char _cIndLectura;
        private char _cIndTipo;
        private string _sFEnvio;
        private string _sDestinatario;
        private string _sProceso;
        private string _sRemitente;
        private string _sTipoM;
        private int _nDependencia;

        //-- Tipo Notificacion
        private char _cTipoNot;
        //--Cierra TipoNot
        #endregion

        #region Constructor de la clase clsNotificacion
        public clsNotificacion()
        {

        }
        #endregion

        #region Getters y Setters de la clase Notificacion
        public string strAsunto { get { return _strAsunto; } set { _strAsunto = value; } }
        public string strMensaje { get { return _strMensaje; } set { _strMensaje = value; } }
        public int nUsuario { get { return _nUsuario; } set { _nUsuario = value; } }
        public char cIndActivo { get { return _cIndActivo; } set { _cIndActivo = value; } }
        public char cLunes { get { return _cLunes; } set { _cLunes = value; } }
        public char cMartes { get { return _cMartes; } set { _cMartes = value; } }
        public char cMiercoles { get { return _cMiercoles; } set { _cMiercoles = value; } }
        public char cJueves { get { return _cJueves; } set { _cJueves = value; } }
        public char cViernes { get { return _cViernes; } set { _cViernes = value; } }
        public char cSabado { get { return _cSabado; } set { _cSabado = value; } }
        public char cDomingo { get { return _cDomingo; } set { _cDomingo = value; } }
        public string strACCION { get { return _strACCION; } set { _strACCION = value; } }
        public string strOPCION { get { return _strOPCION; } set { _strOPCION = value; } }
        public List<clsNotificacion> laNotificacion { get { return _laNotificacion; } set { _laNotificacion = value; } }
        public int idNotifica { get { return _idNotifica; } set { _idNotifica = value; } }

        //Getters y Setters para el Manejo de la tabla APRNOTIPROC
        //public int idNotiProc { get { return _idNotiProc; } set { _idNotiProc = value; } }
        //public int idFKNotifica { get { return _idFKNotifica; } set { _idFKNotifica = value; } }
        //public int idFKProceso { get { return _idFKProceso; } set { _idFKProceso = value; } }
        public int nDiasAntes { get { return _nDiasAntes; } set { _nDiasAntes = value; } }
        public string strDFIniProc { get { return _strDFIniProc; } set { _strDFIniProc = value; } }
        public string strDFFinProc { get { return _strDFFinProc; } set { _strDFFinProc = value; } }

        //public string strDFAlta { get { return _strDFAlta; } set { _strDFAlta = value; } }
        //public string strDFUltModif { get { return _strDFUltModif; } set { _strDFUltModif = value; } }

        public int idUsuRemit { get { return _idUsuRemit; } set { _idUsuRemit = value; } }
        public int idFKUsuDest { get { return _idFKUsuDest; } set { _idFKUsuDest = value; } }
        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }
        public string sAsunto { get { return _sAsunto; } set { _sAsunto = value; } }
        public string sMensaje { get { return _sMensaje; } set { _sMensaje = value; } }
        public char cIndLectura { get { return _cIndLectura; } set { _cIndLectura = value; } }
        public char cIndTipo { get { return _cIndTipo; } set { _cIndTipo = value; } }
        public string sFEnvio { get { return _sFEnvio; } set { _sFEnvio = value; } }
        public string sDestinatario { get { return _sDestinatario; } set { _sDestinatario = value; } }
        public string sProceso { get { return _sProceso; } set { _sProceso = value; } }
        public string sRemitente { get { return _sRemitente; } set { _sRemitente = value; } }
        public string sTipoM { get { return _sTipoM; } set { _sTipoM = value; } }
        public int nDependencia { get { return _nDependencia; } set { _nDependencia = value; } }
        //--cTipoNot publica
        public char cTipoNot { get { return _cTipoNot; } set { _cTipoNot = value; } }
        //--- cierra cTipoNot

        #endregion

        /* Para la utilización de la capa de acceso a datos */
        //libSQL _lbSQL;
        //clsDALSQL _cDASQL;
        /****************************************************/

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion 

        #region fCreaNotificacion
        /// <summary>
        ///  Autor:  Edgar Morales González
        ///  Objetivo: Función que se usa para insertar una nueva notificación
        /// </summary>
        /// <param name="objNotificacion"> Objeto que trae la información de la notificación que se insertara</param>
        /// <returns></returns>
        public bool fCreaNotificacion(clsNotificacion objNotificacion)
        {
            bool blnRespuesta = false;
            this.lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", objNotificacion.strACCION));
                lstParametros.Add(lSQL.CrearParametro("@strSASUNTO", objNotificacion.strAsunto));
                lstParametros.Add(lSQL.CrearParametro("@strSMENSAJE", objNotificacion.strMensaje));
                lstParametros.Add(lSQL.CrearParametro("@chrCLUNES", objNotificacion.cLunes));
                lstParametros.Add(lSQL.CrearParametro("@chrCMARTES", objNotificacion.cMartes));
                lstParametros.Add(lSQL.CrearParametro("@chrCMIERCOLES", objNotificacion.cMiercoles));
                lstParametros.Add(lSQL.CrearParametro("@chrCJUEVES", objNotificacion.cJueves));
                lstParametros.Add(lSQL.CrearParametro("@chrCVIERNES", objNotificacion.cViernes));
                lstParametros.Add(lSQL.CrearParametro("@chrCSABADO", objNotificacion.cSabado));
                lstParametros.Add(lSQL.CrearParametro("@chrCDOMINGO", objNotificacion.cDomingo));
                lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", objNotificacion.nUsuario));
                lstParametros.Add(lSQL.CrearParametro("@chrCINDACTIVO", objNotificacion.cIndActivo));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_NOTIFICA", lstParametros))
                {
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

        #region fObtener_Notificaciones
        /// <summary>
        /// Autor:      Edgar Morales González
        /// Objetivo:   función para Obtener todas las Notificaciones para pintar el Grid
        /// </summary>
        /// <param name="strACCION">Acción que ejecutara el procedimiento almacenado</param>
        /// <returns></returns>
        public bool fObtener_Notificaciones(string strACCION)
        {
            bool blnRespuesta = false;
            this.lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACION", lstParametros))
                {
                    string op = "total";
                    laNotificacion = new List<clsNotificacion>();
                    fLista_Notificacion(objDALSQL.Get_dtSet(), op);
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

        #region fGetNotificacion
        /// <summary>
        /// Procedimiento que obtiene los datos completos de una notificación
        /// Autor: Bárbara Vargas Vera
        /// </summary>         

        public bool fGetNotificacion(int idUsuario, string strOPCION)
        //     public bool fGetNotificacion(int idUsuario, string strOPCION, int idProceso)
        {
            bool blnRespuesta = false;
            //Boolean blnRespuesta;            
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                //strACCION = "DATOS_NOTIFICACION";
                this.lstParametros = new System.Collections.ArrayList();
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strOPCION", strOPCION));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                // lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", idProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", lstParametros))
                {
                    //string op = "MENSAJES";
                    //if()
                    //{
                    //    laNotificacion = new List<clsNotificacion>();
                    //    fLista_Notificacion(objDALSQL.Get_dtSet(), "MENSAJES");
                    //}
                    //else{
                    laNotificacion = new List<clsNotificacion>();
                    fLista_Notificacion(objDALSQL.Get_dtSet(), "MENSAJES");
                    //}
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

        #region fGetNotificacionProc 

        /// <summary>
        /// Procedimiento que obtiene los datos completos de una notificación para Proceso
        /// Autor: Edgar Morales González
        /// <param name="idUsuario">Id del Usuario</param>
        /// </summary>         

        public bool fGetNotificacionProc(int idUsuario)
        {
            bool blnRespuesta = false;
            //Boolean blnRespuesta;            
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                //strACCION = "DATOS_NOTIFICACION";
                this.lstParametros = new System.Collections.ArrayList();
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "DATOS_NOTIFICACION"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACION", lstParametros))
                {
                    //string op = "MENSAJES";
                    //if()
                    //{
                    //    laNotificacion = new List<clsNotificacion>();
                    //    fLista_Notificacion(objDALSQL.Get_dtSet(), "MENSAJES");
                    //}
                    //else{
                    laNotificacion = new List<clsNotificacion>();
                    fLista_Notificacion(objDALSQL.Get_dtSet(), "MENSAJES");
                    //}
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }
        #endregion         ??

        #region función para actualizar una nueva notificación
        /// <summary>
        /// Función que actualiza las notificaciones
        /// Autor: Bárbara Vargas Vera
        /// </summary>        
        /// <param name="objNotificacion">Objeto que contiene la informacion de la notificación que se actualizara</param>
        public bool fActualizaNotifica(clsNotificacion objNotificacion)
        {
            bool blnRespuesta = false;


            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                this.lstParametros = new System.Collections.ArrayList();
                //lstParametros.Add(lSQL.CrearParametro("@strACCION", "MODIFICA_NOTIFICACION"));
                lstParametros.Add(lSQL.CrearParametro("@intIDNOTIFICA", idNotifica));

                lstParametros.Add(lSQL.CrearParametro("@strACCION", objNotificacion.strACCION));
                lstParametros.Add(lSQL.CrearParametro("@strSASUNTO", objNotificacion.strAsunto));
                lstParametros.Add(lSQL.CrearParametro("@strSMENSAJE", objNotificacion.strMensaje));
                lstParametros.Add(lSQL.CrearParametro("@chrCLUNES", objNotificacion.cLunes));
                lstParametros.Add(lSQL.CrearParametro("@chrCMARTES", objNotificacion.cMartes));
                lstParametros.Add(lSQL.CrearParametro("@chrCMIERCOLES", objNotificacion.cMiercoles));
                lstParametros.Add(lSQL.CrearParametro("@chrCJUEVES", objNotificacion.cJueves));
                lstParametros.Add(lSQL.CrearParametro("@chrCVIERNES", objNotificacion.cViernes));
                lstParametros.Add(lSQL.CrearParametro("@chrCSABADO", objNotificacion.cSabado));
                lstParametros.Add(lSQL.CrearParametro("@chrCDOMINGO", objNotificacion.cDomingo));
                lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", objNotificacion.nUsuario));
                lstParametros.Add(lSQL.CrearParametro("@chrCINDACTIVO", objNotificacion.cIndActivo));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_NOTIFICA", lstParametros))
                {
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

        #region pEnviarMensaje()
        /// <summary>
        /// Procedimiento que enviar la respuesta a una notificación recibida
        /// Autor: Bárbara Vargas Vera
        /// </summary>
        public int pEnviarMensaje()
        {
            int intRespuesta = 0;
            this.lstParametros = new System.Collections.ArrayList();
            ArrayList arrOutput = new ArrayList();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@intIDDESTINATARIO", idFKUsuDest));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", idProceso));
                lstParametros.Add(lSQL.CrearParametro("@strASUNTO", sAsunto));
                lstParametros.Add(lSQL.CrearParametro("@strMENSAJE", sMensaje));
                lstParametros.Add(lSQL.CrearParametro("@intIDREMITENTE", idUsuRemit));
                lstParametros.Add(lSQL.CrearParametro("@strOPCION", strACCION));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_MENSAJE", lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intRespuesta = int.Parse(arrOutput[0].ToString());

                    if (intRespuesta == 1)
                    {
                        DataSet ds = objDALSQL.Get_dtSet();                                                 //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);                               //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                                              //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "ENVIARESPUESTA"));          //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                        tmod.Start();

                    }
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

        #region CorreoRespuesta

        /// <summary>
        /// Procedimiento que envia la notificacion
        /// Autor: Bárbara Vargas Vera 
        /// </summary>
        /// <param name="idFKUsuDest">ID del usuario a quien se enviara el mensaje</param>
        /// <param name="idProceso">Id del proceso al cual hace referencia el mensaje</param>
        /// <param name="idUsuRemit">Id del usuario que envia el mensaje</param>
        /// <param name="sAsunto">Asunto del mensaje</param>
        /// <param name="sMensaje">Cuerpo del mensaje</param>

        public void CorreoRespuesta(int idFKUsuDest, int idProceso, string sAsunto, string sMensaje, int idUsuRemit)
        {
            this.lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIdUsuDest", idFKUsuDest));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDPROCESO", idProceso));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strAsunto", sAsunto));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strMensaje", sMensaje));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIdUsuRemit", idUsuRemit));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", "CORREO_RESPUESTA"));
                    // this.lstParametros.Add(this._libSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", this.lstParametros))
                    {
                        DataSet ds = this._objDALSQL.Get_dtSet();                           //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);               //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                              //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        wsNotif.SendNotif(dato, "CORREO_RESPUESTA");                        //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria
                    }
                }
            }
        }

        #endregion

        #region función para llenar la Lista de la Notificacion
        /// <summary>
        /// Función para llenar la lista 
        /// Autor: Edgar Morales González
        /// </summary>
        /// <returns>regresa una lista con información acerca de las notificaciones</returns>
        private void fLista_Notificacion(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "total":

                            laNotificacion.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsNotificacion objNotificacion = new clsNotificacion();

                                objNotificacion.idNotifica = int.Parse(row["idNotifica"].ToString());
                                objNotificacion.strAsunto = row["sAsunto"].ToString();
                                objNotificacion.strMensaje = row["sMensaje"].ToString();
                                objNotificacion.cLunes = char.Parse(row["cLunes"].ToString());
                                objNotificacion.cMartes = char.Parse(row["cMartes"].ToString());
                                objNotificacion.cMiercoles = char.Parse(row["cMiercoles"].ToString());
                                objNotificacion.cJueves = char.Parse(row["cJueves"].ToString());
                                objNotificacion.cViernes = char.Parse(row["cViernes"].ToString());
                                objNotificacion.cSabado = char.Parse(row["cSabado"].ToString());
                                objNotificacion.cDomingo = char.Parse(row["cDomingo"].ToString()); ;

                                laNotificacion.Add(objNotificacion);
                            }
                            break;

                        case "NotList":

                            laNotificacion.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsNotificacion objNotificacion = new clsNotificacion();

                                objNotificacion.idNotifica = int.Parse(row["idNotifica"].ToString());
                                objNotificacion.strAsunto = row["sAsunto"].ToString();
                                objNotificacion.strMensaje = row["sMensaje"].ToString();

                                laNotificacion.Add(objNotificacion);
                            }
                            break;

                        case "NOTIFICACIONES":
                            laNotificacion.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsNotificacion objNotificacion = new clsNotificacion();

                                objNotificacion.idNotifica = int.Parse(row["idNotifica"].ToString());
                                objNotificacion.strAsunto = row["sAsunto"].ToString();
                                objNotificacion.strMensaje = row["SMensaje"].ToString();
                                objNotificacion.cLunes = char.Parse(row["cLunes"].ToString());
                                objNotificacion.cMartes = char.Parse(row["cMartes"].ToString());
                                objNotificacion.cMiercoles = char.Parse(row["cMiercoles"].ToString());
                                objNotificacion.cJueves = char.Parse(row["cJueves"].ToString());
                                objNotificacion.cViernes = char.Parse(row["cViernes"].ToString());
                                objNotificacion.cSabado = char.Parse(row["cSabado"].ToString());
                                objNotificacion.cDomingo = char.Parse(row["cDomingo"].ToString());
                                //objNotificacion.cIndActivo = char.Parse(row["cIndActivo"].ToString());
                                laNotificacion.Add(objNotificacion);
                            }
                            break;

                        //laNotificacion.Add(objNotificacion);
                        // laPeriodosEntrega = null;

                        case "MENSAJES":
                            string senvio = "";
                            laNotificacion.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsNotificacion objNotificacion = new clsNotificacion();
                                objNotificacion.idNotifica = int.Parse(row["idNotifica"].ToString());
                                objNotificacion.sDestinatario = row["Destinatario"].ToString();
                                objNotificacion.idProceso = int.Parse(row["idFKProceso"].ToString());
                                objNotificacion.sProceso = row["Proceso"].ToString();
                                objNotificacion.sAsunto = row["Asunto"].ToString();
                                objNotificacion.sMensaje = row["Mensaje"].ToString();
                                senvio = row["Fechaenvio"].ToString();
                                objNotificacion.sFEnvio = DateTime.Parse(senvio).ToString("dd-MM-yyyy HH:mm");
                                //objNotificacion.sFEnvio = DateTime.Parse(senvio).ToString("dd-MM-yyyy");
                                objNotificacion.sRemitente = row["Remitente"].ToString();
                                // objNotificacion.sTipoM = row["TipoCorreo"].ToString();
                                objNotificacion.cIndLectura = char.Parse(row["cIndLectura"].ToString());
                                objNotificacion.idFKUsuDest = int.Parse(row["idFKUsuDest"].ToString());
                                objNotificacion.idUsuRemit = int.Parse(row["idUsuRemit"].ToString());
                                laNotificacion.Add(objNotificacion);
                            }
                            break;
                        case "ConfNot":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsNotificacion objNotificacion = new clsNotificacion();
                                objNotificacion.idNotifica = int.Parse(row["idConfNotif"].ToString());
                                objNotificacion.cIndActivo = char.Parse(row["cIndActivo"].ToString());
                                laNotificacion.Add(objNotificacion);
                            }
                            break;
                    }
                }
                else
                    laNotificacion = null;
            }
            catch
            {
                laNotificacion = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion                               

        #region función para desactivar una Notificación

        public bool modifNotificacion(clsNotificacion objNotificacion)
        {
            bool blnRespuesta = false;
            this.lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", objNotificacion.strACCION));
                lstParametros.Add(lSQL.CrearParametro("@intIDNOTIFICA", objNotificacion.idNotifica));


                if (blnRespuesta = objDALSQL.ExecQuery_SET("[PA_SELV_NOTIFICACION]", lstParametros))
                {

                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {

                        blnRespuesta = false; //No se puede eliminar el registro ya que la notificacion esta asociada a un proceso activo

                    }
                    else
                        if (objDALSQL.Get_dtSet().Tables[0].Rows.Count == 0)
                    {
                        lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", objNotificacion.nUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@chrCINDACTIVO", "N"));
                        lstParametros.Add(lSQL.CrearParametro("@intIDNOTIFICA", objNotificacion.idNotifica));
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", "MODIFICA_ESTADO_NOTIFICACION"));
                        blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_NOTIFICA", lstParametros);
                    }
                    else
                    {
                        blnRespuesta = false;
                    }
                }
                return blnRespuesta;
            }
        }
        #endregion

        // #region ObtieneNotificaciones

        //public bool fObtener_NotiProceso(int idNotIni, string strACCION)
        //{
        //    bool blnRespuesta = false;
        //    this.lstParametros = new System.Collections.ArrayList();

        //    using (clsDALSQL objDALSQL = new clsDALSQL(false))
        //    {
        //        libSQL lSQL = new libSQL();
        //        lstParametros.Add(lSQL.CrearParametro("@intNotIni",idNotIni));
        //        lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));

        //        if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACION", lstParametros))
        //        {
        //            string op = "NotList";
        //            laNotificacion = new List<clsNotificacion>();
        //            fLista_Notificacion(objDALSQL.Get_dtSet(),op);
        //        }
        //        else
        //        {
        //            // obtener error
        //            //objDALSQL.Get_sError;
        //        }
        //    }
        //    return blnRespuesta;
        //}
        //#endregion


        //public bool fObtener_NotiFin(int idNotIni, int idNotProc, string strACCION)
        //{
        //    bool blnRespuesta = false;
        //    this.lstParametros = new System.Collections.ArrayList();

        //    using (clsDALSQL objDALSQL = new clsDALSQL(false))
        //    {
        //        libSQL lSQL = new libSQL();
        //        lstParametros.Add(lSQL.CrearParametro("@intNotIni", idNotIni));
        //        lstParametros.Add(lSQL.CrearParametro("@intNotProc", idNotProc));
        //        lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));

        //        if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACION", lstParametros))
        //        {
        //            string op = "NotList";
        //            laNotificacion = new List<clsNotificacion>();
        //            fLista_Notificacion(objDALSQL.Get_dtSet(), op);
        //        }
        //        else
        //        {
        //            // obtener error
        //            //objDALSQL.Get_sError;
        //        }
        //    }
        //    return blnRespuesta;
        //}

        #region fMensajeLeido () 
        /// <summary>
        /// Función que actualiza el indicador de leido de un mensaje, al momento que el usuario da click en el boton Ver
        /// Autor: Edgar Morales González
        /// </summary>
        public bool fMensajeLeido(clsNotificacion objNotificacion)
        {
            bool blnRespuesta = false;
            this.lstParametros = new System.Collections.ArrayList();

            try
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    using (clsDALSQL objDALSQL = new clsDALSQL(false))
                    {
                        libSQL lSQL = new libSQL();
                        System.Collections.ArrayList arrOUT = new ArrayList();
                        lstParametros.Add(lSQL.CrearParametro("@intIDMENSAJE", idNotifica));
                        lstParametros.Add(lSQL.CrearParametro("@strOPCION", strACCION));
                        lstParametros.Add(lSQL.CrearParametro("@intIDDESTINATARIO", idFKUsuDest));
                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                        if (objDALSQL.ExecQuery_OUT("PA_IDUH_MENSAJE", lstParametros))
                        {
                            arrOUT = objDALSQL.Get_aOutput();
                            blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);
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

        #region fGuardaMensaje()
        /// <summary>
        /// Procedimiento para enviar la solicitud de apertura de un proceso, se envia a los supervisores
        /// Autor: Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Un entero indicando si se realizó correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGuardaMensaje()
        {
            int intRespuesta = 0;
            this.lstParametros = new System.Collections.ArrayList();
            ArrayList arrOutput = new ArrayList();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@intIDREMITENTE", _idUsuRemit));
                //lstParametros.Add(lSQL.CrearParametro("@intIDDESTINATARIO", _idFKUsuDest));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPENDENCIA ", _nDependencia));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", _idProceso));
                lstParametros.Add(lSQL.CrearParametro("@strASUNTO", _sAsunto));
                lstParametros.Add(lSQL.CrearParametro("@strMENSAJE", _sMensaje));
                lstParametros.Add(lSQL.CrearParametro("@strOPCION", _strACCION));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_MENSAJE", lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intRespuesta = int.Parse(arrOutput[0].ToString());

                    if (intRespuesta == 1)
                    {
                        DataSet ds = objDALSQL.Get_dtSet();                                         //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);                       //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                                      //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "SOL_REAP"));        //Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                        tmod.Start();

                    }
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

        #region fValidaNotificaciones()
        /// <summary>
        /// Función que valida si el usuario tiene notificaciones sin leer
        /// Autor: Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Entero que indica si cuenta con notificaciones sin leer o no</returns>
        public int fValidaNotificaciones()
        {
            //bool blnRespuesta = false;
            this.lstParametros = new System.Collections.ArrayList();
            ArrayList arrOutput = new ArrayList();
            int intExiste = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idFKUsuDest));
                lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_SELU_MENSAJE", lstParametros))
                {
                    arrOutput = objDALSQL.Get_aOutput();
                    intExiste = int.Parse(arrOutput[0].ToString());

                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return intExiste;
        }
        #endregion

        #region  fConfigNotificaciones
        /// <summary>
        /// Función que guardara los valores para la nueva configuración de las notificaciones del SERUV
        /// Autor: Edgar Morales González
        /// </summary>
        /// <returns>regresa un booleano que indica si el proceso fue creado correctamente o no</returns>
        /// <param name="idUsuario">ID del usuario que modifica la configuración</param>
        /// <param name="status">Variable que indica el valor para la configuración de las notificaciones </param>
        public bool fConfigNotificaciones(char status, int idUsuario)
        {
            bool blnRespuesta = false;

            try
            {
                cIndActivo = status;
                nUsuario = idUsuario;

                this.lstParametros = new System.Collections.ArrayList();

                using (clsDALSQL objDALSQL = new clsDALSQL(false))
                {
                    libSQL lSQL = new libSQL();

                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "MOD_CONFIG_NOTIF"));
                    lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", nUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@chrCINDACTIVO", cIndActivo));

                    if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_NOTIFICA", lstParametros))
                    {
                        blnRespuesta = true;
                    }
                }
            }
            catch { }

            return blnRespuesta;
        }
        #endregion

        #region fGetConfigNot()
        /// <summary>
        /// Función que regresa el estado de la configuración de las notificaciones
        /// Autor: Edgar Morales González
        /// </summary>
        /// <returns>regresa una lista con el estado de la configuración de las notificaciones</returns>
        public bool fGetConfigNot()
        {
            bool blnRespuesta = false;
            try
            {
                this.lstParametros = new System.Collections.ArrayList();
                using (clsDALSQL objDALSQL = new clsDALSQL(false))
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "ESTADO_CONF_NOT"));

                    if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACION", lstParametros))
                    {
                        string op = "ConfNot";
                        laNotificacion = new List<clsNotificacion>();
                        fLista_Notificacion(objDALSQL.Get_dtSet(), op);
                    }
                }
            }
            catch { }
            return blnRespuesta;
        }
        #endregion

    }
}