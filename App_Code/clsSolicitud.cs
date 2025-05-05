using System;
using System.Collections.Generic;
using System.Web;
using nsSERUV;
using System.Collections;
using System.Data;
using libFunciones;
using System.Threading;
/// <summary>
/// Objetivo:                       Clase para el manejo de Solicitudes de un Proceso de E-R
/// Versión:                        1.0
/// Autor:                          Daniel Ramírez Hernández 
/// Fechas:                         08 de Julio de 2013 
/// Tablas de la BD que utiliza:     APVSOLIPRO
/// </summary>
/// 

namespace nsSERUV
{
    public class clsSolicitud
    {

        #region Variables privadas

        ArrayList lstParametros = new ArrayList();
        clsValidacion _libFunciones;

        private string _cveSolProc;     //Folio Generado para el envío de la Solicitud
        private int _idSolProc;         //Identificador de tabla APVSOLIPRO
        private int _nFKPuesto;         //Identificador de la tabla AWVPUESTO, para identificar el puesto que se va esta solicitando
        private int _nFKDepcia;         //Identificador de la tabla AWVDEPCIA, para identificar la dependencia/entidad que se esta solicitando
        private int _idFKUsuSO;         //Identificador del titular (Sujeto obligado) de la dependencia que se esta haciendo la solicitud
        private int _idFKUsuEOP;        //Identificador del usuario 'Enlace Operativo Principal' que participará
        private int _idFKMotiProc;      //Identificador del motivo del porque se hace la solicitud
        private int _idFKUsuRecep;      //Identificador del Usuario receptor
        private string _sLugar;         //Lugar donde se realizará la entrega
        private char _cIndTipo;         //Identificador para saber si el SR es interno o externo
        private string _dFSeparacion;   //Fecha a partir de cuando se ejercería la separación del cargo
        private string _sObservaciones; //Observaciones aplicables a la solicitud
        private int _nUsuario;          //Identificador del usuario que envia la solicitud
        private string _dFEnvioSolic;   //Fecha de envio de la solicitud
        private char _cIndActivo;       //Indicador del estado de activo del registro
        private string _sMotivo;        //Motivo de la entrega
        private string _sDependencia;   //Dependencia que se entrega
        private string _sPuesto;        //Puesto que se entrega
        private string _sNombreSO;      //Nombre del sujeto obligado
        private string _sCorreoSO;      //Correo del sujeto obligado
        private string _sNombreEO;      //Nombre del enlace operativo
        private string _sCorreoEO;      //Cuenta del enlace operativo
        private string _sCuentaSR;      // Variable donde guardamos la cuenta del SR
        private string _sNombreSR;      // Variable donde guardamos el Nombre del SR
        private string _sCorreoSR;      // Variable donde guardamos el Correo del SR
        private string _strACCION;      // Variable para controlar la acción a realizar


        System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros
        private List<clsSolicitud> _laSolicitudProceso;

        //private System.Collections.ArrayList lstParametros;

        #endregion

        #region Constructores
        public clsSolicitud()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        #endregion

        #region Procedimientos de la clase

        #region fInsertarSolicitud
        /// <summary>
        /// Función que Insertará la Solicitud de Proceso E-R en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si) </returns>
        public int fInsertarSolicitud(clsUsuario objUsuario, clsUsuario objSujetoObligado, clsUsuario objUsuarioEnlance, string sEnlace, string sBusquedaSR)
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    using (this._libFunciones = new clsValidacion())
                    {
                        libSQL lSQL = new libSQL();

                        //Modificamos el formato de la fecha de Separacion a ser enviada
                        if (!this._dFSeparacion.Equals(string.Empty))
                        {

                            this._dFSeparacion = (objValidacion.IsDate(objValidacion.ConvertDatePicker(this._dFSeparacion)) ? DateTime.Parse(objValidacion.ConvertDatePicker(this._dFSeparacion)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                        }

                        //Verifica si el sujeto obligado está dado de alta, si no lo está, lo agrega
                        if (this._idFKUsuSO == 0)
                        {
                            System.Collections.ArrayList arrOUTSO = new ArrayList();
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                            lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objSujetoObligado.strCuenta));
                            lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                            if (objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros))
                            {
                                arrOUTSO = objDALSQL.Get_aOutput();
                                int intIDUsuarioSO = int.Parse(arrOUTSO[0].ToString());
                                if (intIDUsuarioSO == 0)
                                {
                                    ArrayList arrOutputSO = new ArrayList();
                                    string strApellidos = objSujetoObligado.strApPaterno + " " + objSujetoObligado.strApMaterno;
                                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objSujetoObligado.intNumDependencia));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objSujetoObligado.intPuesto));
                                    lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objSujetoObligado.strCuenta));
                                    lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", objSujetoObligado.intNumPersonal));
                                    lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", objSujetoObligado.strNombre));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", objSujetoObligado.strApPaterno));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", objSujetoObligado.strApMaterno));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                                    lstParametros.Add(lSQL.CrearParametro("@strCORREO", objSujetoObligado.strCorreo));
                                    lstParametros.Add(lSQL.CrearParametro("@intTPER", objSujetoObligado.intTipPersonal));
                                    lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objSujetoObligado.intCategoria));
                                    lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", objSujetoObligado.chrIndEmpleado));
                                    lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", objSujetoObligado.chrIndActivo));
                                    lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", this._nUsuario));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                                    {
                                        arrOutputSO = objDALSQL.Get_aOutput();
                                        intIDUsuarioSO = int.Parse(arrOutputSO[0].ToString());
                                        this._idFKUsuSO = intIDUsuarioSO;
                                    }
                                }
                            }
                        }
                        ///////////***/////////

                        //Verifica si se asigno un enlace operativo, en ese caso verifica si esta dado de alta en el sistema y en caso de no estarlo, lo agrega
                        if (sEnlace == "S")
                        {
                            System.Collections.ArrayList arrOUTEnlace = new ArrayList();
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                            lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objUsuarioEnlance.strCuenta));
                            lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                            if (objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros))
                            {
                                arrOUTEnlace = objDALSQL.Get_aOutput();
                                int intIDUsuario = int.Parse(arrOUTEnlace[0].ToString());
                                if (intIDUsuario == 0)
                                {
                                    ArrayList arrOutputEnlance = new ArrayList();
                                    string strApellidos = objUsuarioEnlance.strApPaterno + " " + objUsuarioEnlance.strApMaterno;
                                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objUsuarioEnlance.intNumDependencia));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objUsuarioEnlance.intPuesto));
                                    lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objUsuarioEnlance.strCuenta));
                                    lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", objUsuarioEnlance.intNumPersonal));
                                    lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", objUsuarioEnlance.strNombre));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", objUsuarioEnlance.strApPaterno));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", objUsuarioEnlance.strApMaterno));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                                    lstParametros.Add(lSQL.CrearParametro("@strCORREO", objUsuarioEnlance.strCorreo));
                                    lstParametros.Add(lSQL.CrearParametro("@intTPER", objUsuarioEnlance.intTipPersonal));
                                    lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objUsuarioEnlance.intCategoria));
                                    lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", objUsuarioEnlance.chrIndEmpleado));
                                    lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", objUsuarioEnlance.chrIndActivo));
                                    lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", this._nUsuario));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                                    {
                                        arrOutputEnlance = objDALSQL.Get_aOutput();
                                        intIDUsuario = int.Parse(arrOutputEnlance[0].ToString());
                                        this._idFKUsuEOP = intIDUsuario;
                                    }
                                }
                            }
                        }
                        //////*****/////

                        // Verifica si se realizo la búsqueda del sujeto receptor
                        if (sBusquedaSR == "S")
                        {
                            // Verifica si el sujeto receptor está dado de alta si no lo agrega
                            System.Collections.ArrayList arrOUT1 = new ArrayList();
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_IDUSUARIO"));
                            lstParametros.Add(lSQL.CrearParametro("@strCUENTA", this._sCuentaSR));
                            lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", 0, SqlDbType.Int, ParameterDirection.Output));
                            if (objDALSQL.ExecQuery_OUT("PA_SELU_USUARIO", lstParametros))
                            {
                                arrOUT1 = objDALSQL.Get_aOutput();
                                int intIDUsuario = int.Parse(arrOUT1[0].ToString());
                                if (intIDUsuario == 0)
                                {
                                    ArrayList arrOutput = new ArrayList();
                                    string strApellidos = objUsuario.strApPaterno + " " + objUsuario.strApMaterno;
                                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDA_USUARIO"));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", objUsuario.intNumDependencia));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDPUESTO", objUsuario.intPuesto));
                                    lstParametros.Add(lSQL.CrearParametro("@strCUENTA", objUsuario.strCuenta));
                                    lstParametros.Add(lSQL.CrearParametro("@intNUMPERSONAL", objUsuario.intNumPersonal));
                                    lstParametros.Add(lSQL.CrearParametro("@strNOMBRE", objUsuario.strNombre));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPPATERNO", objUsuario.strApPaterno));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPMATERNO", objUsuario.strApMaterno));
                                    lstParametros.Add(lSQL.CrearParametro("@strAPELLIDOS", strApellidos));
                                    lstParametros.Add(lSQL.CrearParametro("@strCORREO", objUsuario.strCorreo));
                                    lstParametros.Add(lSQL.CrearParametro("@intTPER", objUsuario.intTipPersonal));
                                    lstParametros.Add(lSQL.CrearParametro("@intCATEGORIA", objUsuario.intCategoria));
                                    lstParametros.Add(lSQL.CrearParametro("@chrINDEMPLEADO", objUsuario.chrIndEmpleado));
                                    lstParametros.Add(lSQL.CrearParametro("@chrINDACTIVO", objUsuario.chrIndActivo));
                                    lstParametros.Add(lSQL.CrearParametro("@intNUSUARIO", this._nUsuario));
                                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", SqlDbType.Int, ParameterDirection.Output));
                                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_USUARIO", lstParametros))
                                    {
                                        arrOutput = objDALSQL.Get_aOutput();
                                        intIDUsuario = int.Parse(arrOutput[0].ToString());
                                        this._idFKUsuRecep = intIDUsuario;
                                    }
                                }
                            }
                        }


                        System.Collections.ArrayList arrOUT = new ArrayList();
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                        lstParametros.Add(lSQL.CrearParametro("@strCveSolProc", this._cveSolProc));
                        lstParametros.Add(lSQL.CrearParametro("@intnFKPuesto", this._nFKPuesto));
                        lstParametros.Add(lSQL.CrearParametro("@intFKDepcia", this._nFKDepcia));
                        lstParametros.Add(lSQL.CrearParametro("@intIdFKUsuSO", this._idFKUsuSO));
                        lstParametros.Add(lSQL.CrearParametro("@intidFKUsuEOP", this._idFKUsuEOP));
                        lstParametros.Add(lSQL.CrearParametro("@intIdFKMotiProc", this._idFKMotiProc));
                        lstParametros.Add(lSQL.CrearParametro("@intIdFKUsuRecep", this._idFKUsuRecep));

                        lstParametros.Add(lSQL.CrearParametro("@strLugar", this._sLugar));
                        lstParametros.Add(lSQL.CrearParametro("@chrTipo", this._cIndTipo));
                        lstParametros.Add(lSQL.CrearParametro("@dteFSeparacion", this._dFSeparacion));
                        lstParametros.Add(lSQL.CrearParametro("@strObservaciones", this._sObservaciones));
                        lstParametros.Add(lSQL.CrearParametro("@intNUsuario", this._nUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@strsNombreSR", this._sNombreSR));
                        lstParametros.Add(lSQL.CrearParametro("@strsCorreoSR", this._sCorreoSR));


                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));


                        if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_SOLICITUD", lstParametros))
                        {
                            arrOUT = objDALSQL.Get_aOutput();
                            blnRespuesta = int.Parse(arrOUT[0].ToString());

                            if (blnRespuesta == 1)
                            {
                                DataSet ds = objDALSQL.Get_dtSet();                                         //  DataSet que almacenará la información necesaria para enviar la notificación correspondiente
                                string dato = clsJsonMethods.ConvertDataSetToXML(ds);                       //  string que almacenará el XML  devuelto tras la conversión de un DataSet a un XML

                                clsWSNotif wsNotif = new clsWSNotif();                                      //  Crea un objeto que se usara para la comunicación con la clase del WebService
                                Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "SOL_PROCESO"));     //  Hilo que mandará a llamar la función encargada de extraer la información para la notificación necesaria.
                                tmod.Start();
                            }
                        }

                    }
                }
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetCodigoSolicitud
        /// <summary>
        /// Función que nos generará un folio para la solicitud de un proceso E-R
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si) </returns>
        public bool fGetCodigoSolicitud()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                //lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@strCveSolProc", String.Empty, SqlDbType.VarChar, 200, 0, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("[PA_SELV_SOLICITUD]", lstParametros))
                {
                    arrOUT = objDALSQL.Get_aOutput();
                    this._cveSolProc = arrOUT[0].ToString();

                    if (this._cveSolProc != "")
                    {
                        blnRespuesta = true;
                    }

                }


            }

            return blnRespuesta;
        }
        #endregion

        #region fGetSolicitudes
        /// <summary>
        /// Función que obtiene el listado de todas las solicitudes de intervención
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns></returns>
        public string fGetSolicitudes()
        {
            string strCadena = string.Empty;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                //System.Collections.ArrayList arrOUT = new ArrayList();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                if (objDALSQL.ExecQuery_SET("PA_SELV_SOLICITUD", lstParametros))
                {
                    laSolicitudProceso = new List<clsSolicitud>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "SOLICITUD");
                }
            }
            return strCadena;
        }
        #endregion

        #region fModificaEstado
        /// <summary>
        /// Función que modifica el indicador de activo a una solicitud de intervención
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Un entero indicando si se realizó o no la acción (0: No, 1: Si)</returns>
        public int fModificaEstado()
        {
            int intResp = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                lstParametros.Add(lSQL.CrearParametro("@intIDSOLIPROC", this.idSolProc));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_SOLICITUD", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = new ArrayList();
                    arrOUT = objDALSQL.Get_aOutput();
                    intResp = int.Parse(arrOUT[0].ToString());
                }
            }
            return intResp;
        }
        #endregion

        #region pLlenarLista
        /// <summary>
        /// Procedimiento que llena la lista laSolicitudProceso
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="dataset">Dataset con los datos de la solicitud</param>
        /// <param name="op">Opción que se ejecutará dentro del procedimiento</param>
        public void pLlenarLista(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "SOLICITUD":
                            laSolicitudProceso.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsSolicitud objSolicitud = new clsSolicitud();
                                objSolicitud.idSolProc = int.Parse(row["idSolProc"].ToString());
                                objSolicitud.cveSolProc = row["cveSolProc"].ToString();
                                objSolicitud.sPuesto = row["sDPuesto"].ToString();
                                objSolicitud.sDependencia = row["sDepcia"].ToString();
                                objSolicitud.sNombreSO = row["SujetoObligado"].ToString();
                                objSolicitud.sCorreoSO = row["sCorreoSO"].ToString();
                                objSolicitud.sNombreEO = row["EnlaceOp"].ToString();
                                objSolicitud.sCorreoEO = row["sCorreoEOP"].ToString();
                                objSolicitud.sMotivo = row["sDMotiProc"].ToString();
                                objSolicitud.sNombreSR = row["SujetoReceptor"].ToString();
                                objSolicitud.sCorreoSR = row["sCorreoReceptor"].ToString();
                                objSolicitud.sLugar = row["sLugar"].ToString();
                                objSolicitud.cIndTipo = Char.Parse(row["cIndTipo"].ToString());
                                objSolicitud.dFSeparacion = row["FechaSeparación"].ToString();
                                objSolicitud.sObservaciones = row["sObservaciones"].ToString();
                                objSolicitud.dFEnvioSolic = row["FechaSolicitud"].ToString();
                                objSolicitud.cIndActivo = Char.Parse(row["cIndActivo"].ToString());
                                laSolicitudProceso.Add(objSolicitud);
                            }
                            break;
                    }
                }
            }
            catch { laSolicitudProceso = null; }
            finally { dataset = null; }
        }
        #endregion

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #region Getters y Setters

        public string cveSolProc { get { return _cveSolProc; } set { _cveSolProc = value; } }
        public int idSolProc { get { return _idSolProc; } set { _idSolProc = value; } }
        public int nFKPuesto { get { return _nFKPuesto; } set { _nFKPuesto = value; } }
        public int nFKDepcia { get { return _nFKDepcia; } set { _nFKDepcia = value; } }
        public int idFKUsuSO { get { return _idFKUsuSO; } set { _idFKUsuSO = value; } }
        public int idFKUsuEOP { get { return _idFKUsuEOP; } set { _idFKUsuEOP = value; } }
        public int idFKMotiProc { get { return _idFKMotiProc; } set { _idFKMotiProc = value; } }
        public int idFKUsuRecep { get { return _idFKUsuRecep; } set { _idFKUsuRecep = value; } }
        public string sLugar { get { return _sLugar; } set { _sLugar = value; } }
        public char cIndTipo { get { return _cIndTipo; } set { _cIndTipo = value; } }
        public string dFSeparacion { get { return _dFSeparacion; } set { _dFSeparacion = value; } }
        public string sObservaciones { get { return _sObservaciones; } set { _sObservaciones = value; } }
        public int nUsuario { get { return _nUsuario; } set { _nUsuario = value; } }
        public string dFEnvioSolic { get { return _dFEnvioSolic; } set { _dFEnvioSolic = value; } }
        public char cIndActivo { get { return _cIndActivo; } set { _cIndActivo = value; } }
        public string strACCION { get { return _strACCION; } set { _strACCION = value; } }
        public string sCuentaSR { get { return _sCuentaSR; } set { _sCuentaSR = value; } }
        public string sNombreSR { get { return _sNombreSR; } set { _sNombreSR = value; } }
        public string sCorreoSR { get { return _sCorreoSR; } set { _sCorreoSR = value; } }
        public string sMotivo { get { return _sMotivo; } set { _sMotivo = value; } }
        public string sDependencia { get { return _sDependencia; } set { _sDependencia = value; } }
        public string sPuesto { get { return _sPuesto; } set { _sPuesto = value; } }
        public string sNombreSO { get { return _sNombreSO; } set { _sNombreSO = value; } }
        public string sCorreoSO { get { return _sCorreoSO; } set { _sCorreoSO = value; } }
        public string sNombreEO { get { return _sNombreEO; } set { _sNombreEO = value; } }
        public string sCorreoEO { get { return _sCorreoEO; } set { _sCorreoEO = value; } }


        public List<clsSolicitud> laSolicitudProceso { get { return _laSolicitudProceso; } set { _laSolicitudProceso = value; } }
        #endregion




    }
}