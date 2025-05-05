using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using libFunciones;
using System.Threading;

/// Versión:                        1.0
/// Autor:                          L.I. Jesús Montero Cuevas 
/// Fecha de Creación:              12 de Abril 2013
/// Modificó:                       Jesús Montero Cuevas 6/Mayo/2013

namespace nsSERUV
{
    public class clsCierre : IDisposable
    {
        #region VARIABLES GLOBALES
        System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
        bool blnRespuesta = false;
        private List<clsCierre> _laRegresaDatos;
        private List<clsCierre> _laAvanceGeneral;
        private List<clsCierre> _laAvanceDepcia;
        private List<clsCierre> _laDepcias;
        private List<clsCierre> _laPerfiles;

        private int _nIdUsuario;
        private int _nIdProceso;
        private string _sDProceso;
        private int _nIdParticipante;
        private int _nDepcia;
        private string _sDDepcia;
        private float _avanceGeneral;
        private float _avanceGeneralProceso;
        private int _excluidos;
        private int _integrados;
        private int _pendientes;
        private string _cIndEntrega;
        private int _nIdAnexo;
        private string _sAnexo;
        private string _sDAnexo;
        private string _sJustificacion;
        private string _sFechaInicio;
        private string _sFechaFinal;
        private string _sEstatus;
        private string _sProceso;
        private string _cEstatus;
        private string _dFInicio;
        private string _dFFinal;
        private string _sDPuesto;
        private string _usuarioObligado;
        private int _nIdApartado;
        private string _sApartado;
        private string _sDApartado;
        private int _nNumArchivos;
        private int _nIdPartAplic;
        private string _sPerfil;
        private string _cEstatusProc;
        private string _strResp;

        #endregion 

        #region PROPIEDADES PARA EL ACTA E-R

        private string _cTipoActa;
        private int _nFKsZona;
        private int _nFKDepcia;
        private string _sCambioDe;
        private string _sNumOficio;
        private string _dFAutoriz;
        private int _idFkUsuAuto;
        private int _idFkUsuEntre;
        private int _nFkPuesto;
        private string _sNomDepEnt;
        private string _sDomDepEnt;
        private string _dFNombram;
        private string _sNomAutori;
        //private int _idFKUsuRecibe;
        //private int _iNumPerRec;

        //private int _idFKUsuRecibe;
        //private int _iNumPerRec;

        private string _uObligado;
        private int _nNumPerEntrega;
        private string _sCargoEntrega;

        private string _uReceptor;
        private int _nNumPerRecibe;
        private string _scargoRecibe;


        private int _idFKDomEntr;
        private string _sNomAdmon;
        private int _iNumPerAdmon;
        private int _idFKDomAdmon;
        private int _idFKDomRecib;
        private string _sNomAudit;
        private string _sNomTest1;
        private int _iEdadTest1;
        private string _sEdoCivilTest1;
        private string _sRFCTest1;

        private string _sTrabTest1;
        private string _sPuesTest1;
        private int _idFKDomTest1;
        private string _sNomTest2;
        private int _iEdadTest2;
        private string _sEdoCivilTest2;
        private string _sRFCTest2;
        private string _sTrabTest2;
        private string _sPuesTest2;
        private int _idFKDomTest2;

        private string _sZona;

        #endregion

        #region Constructores

        public clsCierre()
        {
        }

        public clsCierre(int nIdParticipante, int nIdUsuario,
            string cTipoActa, int nFKsZona, int nFKDepcia, string sCambioDe,
            string sNumOficio, string dFAutoriz
            //int idFkUsuAuto, int idFkUsuEntre, int nFkPuesto, string sNomDepEnt, string sDomDepEnt, string dFNombram,
            //string sNomAutori, int idFKUsuRecibe, int iNumPerRec,
            //int idFKDomEntr, string sNomAdmon, int iNumPerAdmon, int idFKDomAdmon, int idFKDomRecib, string sNomAudit, string sNomTest1, int iEdadTest1, string sEdoCivilTest1, string sRFCTest1,
            //string sTrabTest1, string sPuesTest1, int idFKDomTest1, string sNomTest2, int iEdadTest2, string sEdoCivilTest2, string sRFCTest2, string sTrabTest2, string sPuesTest2, int idFKDomTest2
            )
        {
            this._nIdParticipante = nIdParticipante;
            this._nIdUsuario = nIdUsuario;

            this._cTipoActa = cTipoActa;
            this._nFKsZona = nFKsZona;
            this._nFKDepcia = nFKDepcia;
            this._sCambioDe = sCambioDe;

            this._sNumOficio = sNumOficio;
            this._dFAutoriz = dFAutoriz;
            //this._idFkUsuAuto = idFkUsuAuto;
            //this._idFkUsuEntre = idFkUsuEntre;
            //this._nFkPuesto = nFkPuesto;
            //this._sNomDepEnt = sNomDepEnt;
            //this._sDomDepEnt = sDomDepEnt;
            //this._dFNombram = dFNombram;

            //this._sNomAutori = sNomAutori;
            //this._idFKUsuRecibe = idFKUsuRecibe;
            //this._iNumPerRec = iNumPerRec;

            //this._idFKDomEntr = idFKDomEntr;
            //this._sNomAdmon = sNomAdmon;
            //this._iNumPerAdmon = iNumPerAdmon;
            //this._idFKDomAdmon = idFKDomAdmon;
            //this._idFKDomRecib = idFKDomRecib;
            //this._sNomAudit = sNomAudit;
            //this._sNomTest1 = sNomTest1;
            //this._iEdadTest1 = iEdadTest1;
            //this._sEdoCivilTest1 = sEdoCivilTest1;
            //this._sRFCTest1 = sRFCTest1;

            //this._sTrabTest1 = sTrabTest1;
            //this._sPuesTest1 = sPuesTest1;
            //this._idFKDomTest1 = idFKDomTest1;
            //this._sNomTest2 = sNomTest2;
            //this._iEdadTest2 = iEdadTest2;
            //this._sEdoCivilTest2 = sEdoCivilTest2;
            //this._sRFCTest2 = sRFCTest2;
            //this._sTrabTest2 = sTrabTest2;
            //this._sPuesTest2 = sPuesTest2;
            //this._idFKDomTest2 = idFKDomTest2;
        }

        #endregion

        #region MÉTODOS JESÚS MONTERO CUEVAS


        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que obtiene los procesos en el que el usuario esta como supervisor
        /// <returns></returns>
        public bool fGetProcesos(int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_PROCESO_X_USU_PERFIL"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_CIERRE", lstParametros))
                {
                    laRegresaDatos = new List<clsCierre>();
                    laDepcias = new List<clsCierre>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PROCESOS");
                }
            }
            return blnRespuesta;
        }

        /// <summary>
        ///----**********---------------************----------------------**************------------------
        ///----**********---------------************----------------------**************------------------

        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        /// <returns></returns>
        public bool fGetAvanceProceso(int nIdProceso)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_PROCESO_AVANCE"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_CIERRE", lstParametros))
                {
                    laRegresaDatos = new List<clsCierre>();
                    laAvanceGeneral = new List<clsCierre>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "AVANCE");
                }
            }
            return blnRespuesta;
        }


        /// <summary>
        ///----**********---------------************----------------------**************------------------
        ///----**********---------------************----------------------**************------------------

        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que se encarga de cerrar un proceso
        /// <returns></returns>
        public string fCerrarProceso(int nIdProceso, int nIdParticipante, string strOpCierre)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "CERRAR_PROCESO"));
                lstParametros.Add(lSQL.CrearParametro("@strOPCIERRE", strOpCierre));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_CIERRE", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();

                    if (this._strResp == "1")
                    {
                        //using (clsNotifica objNotifica = new clsNotifica("CIERRE_PROC"))
                        //{
                        //    objNotifica.SendNotificacion(objDALSQL.Get_dtSet());
                        //}

                        DataSet ds = objDALSQL.Get_dtSet();                                             //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);                           //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                                          //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "CIERRE_PROC"));          //Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                        tmod.Start();
                    }
                }
            }
            return _strResp;
        }

        /// <summary>
        ///----**********---------------************----------------------**************------------------
        ///----**********---------------************----------------------**************------------------

        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que devuelve los datos del acta. en estos momentos no se utiliza
        /// <returns></returns>
        public string fGetDatosActa(int nIdParticipante)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_DATOS_ACTA"));
                //lstParametros.Add(lSQL.CrearParametro("@strOPCIERRE", strOpCierre));
                //lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_SET_OUT("PA_SELV_CIERRE", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();

                    if (this._strResp == "1")
                    {
                        laRegresaDatos = new List<clsCierre>();
                        pLlenar_Lista(objDALSQL.Get_dtSet(), "DATOS_ACTA");
                    }
                }
            }
            return _strResp;
        }

        /// <summary>
        ///----**********---------------************----------------------**************------------------
        ///----**********---------------************----------------------**************------------------

        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        /// <returns></returns>
        public string fGuardarActa(clsCierre objCierre)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUARDAR_ACTA"));
                //lstParametros.Add(lSQL.CrearParametro("@strOPCIERRE", strOpCierre));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", objCierre.nIdUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", objCierre.nIdParticipante));

                //------------PARAMETROS DEL ACTA------------------------------

                lstParametros.Add(lSQL.CrearParametro("@strTIPOACTA", objCierre.cTipoActa));
                lstParametros.Add(lSQL.CrearParametro("@intFKZONA", objCierre.nFKsZona));
                lstParametros.Add(lSQL.CrearParametro("@intFKDEPCIA", objCierre.nFKDepcia));
                lstParametros.Add(lSQL.CrearParametro("@strCAMBIODE", objCierre.sCambioDe));
                lstParametros.Add(lSQL.CrearParametro("@strNUMOFICIO", objCierre.sNumOficio));
                lstParametros.Add(lSQL.CrearParametro("@strAUTORIZ", objCierre.dFAutoriz));

                //-----------------------------------------------------------------
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_CIERRE", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();

                    if (this._strResp == "1")
                    {
                        using (clsNotifica objNotifica = new clsNotifica("CIERRE_PROC"))
                        {
                            //objNotifica.SendNotificacion(objDALSQL.Get_dtSet());
                        }
                    }
                }
            }
            return _strResp;
        }


        /// <summary>
        ///  //----**********---------------************----------------------**************------------------
        ///  //----**********---------------************----------------------**************------------------
        ///  //--------------  MÉTODO QUE LLENA LA LISTA PARA MANDARLA AL CLIENTE  ---------------------------
        ///  //AUTOR: JESÚS MONTERO CUEVAS-----------------------------------------------------------
        /// </summary>Método que llena las listas con los resultados de las consultas
        /// <param name="dataset"></param>
        /// <param name="op"></param>
        private void pLlenar_Lista(DataSet dataset, string op)
        {
            try
            {
                //if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                //{
                switch (op)
                {
                    case "AVANCE":
                        //avance general
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsCierre objCie = new clsCierre();
                            objCie.avanceGeneralProceso = float.Parse(row["avanceGeneralProceso"].ToString());
                            objCie.nIdProceso = int.Parse(row["idProceso"].ToString());
                            laAvanceGeneral.Add(objCie);

                        }

                        //datos para el grid
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[1].Rows)
                        {
                            clsCierre obCie = new clsCierre();
                            obCie.nIdProceso = int.Parse(row["idProceso"].ToString());
                            obCie.nDepcia = int.Parse(row["nDepcia"].ToString());
                            obCie.sDDepcia = row["sDDepcia"].ToString();
                            obCie.avanceGeneral = float.Parse(row["avanceGeneral"].ToString());
                            obCie.excluidos = int.Parse(row["excluidos"].ToString());
                            obCie.integrados = int.Parse(row["integrados"].ToString());
                            obCie.pendientes = int.Parse(row["pendientes"].ToString());
                            obCie.cIndEntrega = row["cIndEntrega"].ToString();
                            obCie.cEstatus = row["cEstatus"].ToString();
                            obCie.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                            obCie.sDProceso = row["nombreProceso"].ToString();

                            laRegresaDatos.Add(obCie);
                        }
                        break;

                    case "PROCESOS":
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsCierre obCie = new clsCierre();
                            obCie.nIdProceso = int.Parse(row["idProceso"].ToString());
                            obCie.sProceso = row["sProceso"].ToString();
                            obCie.sDProceso = row["sDProceso"].ToString();
                            obCie.sFechaInicio = DateTime.Parse(row["dFInicio"].ToString()).ToString("dd-MM-yyyy");
                            obCie.sFechaFinal = DateTime.Parse(row["dFFinal"].ToString()).ToString("dd-MM-yyyy");
                            obCie.sEstatus = row["cEstatus"].ToString();

                            obCie.laDepcias = new List<clsCierre>();


                            if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                            {
                                obCie.laDepcias = null;
                            }
                            else
                            {
                                obCie.laDepcias = getDepciasXProc(dataset, obCie.nIdProceso);
                            }

                            laRegresaDatos.Add(obCie);

                        }
                        break;

                    case "DATOS_ACTA":
                        if (dataset.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsCierre objCie = new clsCierre();
                                objCie.cTipoActa = row["cTipoActa"].ToString();
                                objCie.nFKsZona = int.Parse(row["nFKSZona"].ToString());
                                objCie.sZona = row["sDZona"].ToString();
                                objCie.sDDepcia = row["sDDepcia"].ToString();
                                objCie.sCambioDe = row["sCambioDe"].ToString();

                                objCie.sNumOficio = row["sNumOficio"].ToString();
                                objCie.dFAutoriz = row["dFAutoriz"].ToString();
                                objCie.uObligado = row["uObligado"].ToString();
                                objCie.nNumPerEntrega = int.Parse(row["nNumPerEntrega"].ToString());
                                objCie.sCargoEntrega = row["cargoEntrega"].ToString();
                                objCie.uReceptor = row["uReceptor"].ToString();
                                objCie.nNumPerRecibe = int.Parse(row["nNumPerRecibe"].ToString());
                                objCie.scargoRecibe = row["cargoRecibe"].ToString();
                                laRegresaDatos.Add(objCie);

                            }
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
        /// Método que relaciona las dependencias con sus proceso
        /// </summary>
        /// <param name="dataset">dataset que devuelve la tabla que contiene las dependencias por proceso</param>
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public List<clsCierre> getDepciasXProc(DataSet dataset, int nIdProceso)
        {
            DataTable tabla = dataset.Tables[1];
            List<clsCierre> laRegresa = new List<clsCierre>();
            clsCierre obj;
            DataRow[] result = tabla.Select("idFKProceso =" + nIdProceso);
            foreach (DataRow row in result)
            {
                obj = new clsCierre();

                obj.nIdProceso = int.Parse(row["idFKProceso"].ToString());
                obj.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                obj.sDDepcia = row["sDDepcia"].ToString();

                laRegresa.Add(obj);
            }
            return laRegresa;
        }
        #endregion


        #region GET'S Y SET'S

        public List<clsCierre> laRegresaDatos { get { return _laRegresaDatos; } set { _laRegresaDatos = value; } }
        public List<clsCierre> laAvanceGeneral { get { return _laAvanceGeneral; } set { _laAvanceGeneral = value; } }
        public List<clsCierre> laAvanceDepcia { get { return _laAvanceDepcia; } set { _laAvanceDepcia = value; } }
        public List<clsCierre> laDepcias { get { return _laDepcias; } set { _laDepcias = value; } }
        public List<clsCierre> laPerfiles { get { return _laPerfiles; } set { _laPerfiles = value; } }


        public int nIdUsuario { get { return _nIdUsuario; } set { _nIdUsuario = value; } }
        public int nIdProceso { get { return _nIdProceso; } set { _nIdProceso = value; } }
        public int nIdParticipante { get { return _nIdParticipante; } set { _nIdParticipante = value; } }
        public int nDepcia { get { return _nDepcia; } set { _nDepcia = value; } }
        public string sDDepcia { get { return _sDDepcia; } set { _sDDepcia = value; } }
        public float avanceGeneral { get { return _avanceGeneral; } set { _avanceGeneral = value; } }
        public int excluidos { get { return _excluidos; } set { _excluidos = value; } }
        public int integrados { get { return _integrados; } set { _integrados = value; } }
        public int pendientes { get { return _pendientes; } set { _pendientes = value; } }
        public string cIndEntrega { get { return _cIndEntrega; } set { _cIndEntrega = value; } }
        public float avanceGeneralProceso { get { return _avanceGeneralProceso; } set { _avanceGeneralProceso = value; } }
        public string sDProceso { get { return _sDProceso; } set { _sDProceso = value; } }
        public int nIdAnexo { get { return _nIdAnexo; } set { _nIdAnexo = value; } }
        public string sAnexo { get { return _sAnexo; } set { _sAnexo = value; } }
        public string sDAnexo { get { return _sDAnexo; } set { _sDAnexo = value; } }
        public string sJustificacion { get { return _sJustificacion; } set { _sJustificacion = value; } }
        public string sFechaInicio { get { return _sFechaInicio; } set { _sFechaInicio = value; } }
        public string sFechaFinal { get { return _sFechaFinal; } set { _sFechaFinal = value; } }
        public string sEstatus { get { return _sEstatus; } set { _sEstatus = value; } }
        public string sProceso { get { return _sProceso; } set { _sProceso = value; } }
        public string cEstatus { get { return _cEstatus; } set { _cEstatus = value; } }

        public string dFInicio { get { return _dFInicio; } set { _dFInicio = value; } }
        public string dFFinal { get { return _dFFinal; } set { _dFFinal = value; } }
        public string sDPuesto { get { return _sDPuesto; } set { _sDPuesto = value; } }
        public string usuarioObligado { get { return _usuarioObligado; } set { _usuarioObligado = value; } }

        public int nIdApartado { get { return _nIdApartado; } set { _nIdApartado = value; } }
        public string sApartado { get { return _sApartado; } set { _sApartado = value; } }
        public string sDApartado { get { return _sDApartado; } set { _sDApartado = value; } }

        public int nNumArchivos { get { return _nNumArchivos; } set { _nNumArchivos = value; } }
        public int nIdPartAplic { get { return _nIdPartAplic; } set { _nIdPartAplic = value; } }

        public string sPerfil { get { return _sPerfil; } set { _sPerfil = value; } }
        public string cEstatusProc { get { return _cEstatusProc; } set { _cEstatusProc = value; } }
        #endregion

        #region GET'S Y SET'S PROPIEDADES ACTA E-R

        public string cTipoActa { get { return _cTipoActa; } set { _cTipoActa = value; } }
        public int nFKsZona { get { return _nFKsZona; } set { _nFKsZona = value; } }
        public int nFKDepcia { get { return _nFKDepcia; } set { _nFKDepcia = value; } }

        public string sCambioDe { get { return _sCambioDe; } set { _sCambioDe = value; } }
        public string sNumOficio { get { return _sNumOficio; } set { _sNumOficio = value; } }
        public string dFAutoriz { get { return _dFAutoriz; } set { _dFAutoriz = value; } }
        public int idFkUsuAuto { get { return _idFkUsuAuto; } set { _idFkUsuAuto = value; } }
        public int idFkUsuEntre { get { return _idFkUsuEntre; } set { _idFkUsuEntre = value; } }
        public int nFkPuesto { get { return _nFkPuesto; } set { _nFkPuesto = value; } }
        public string sNomDepEnt { get { return _sNomDepEnt; } set { _sNomDepEnt = value; } }
        public string sDomDepEnt { get { return _sDomDepEnt; } set { _sDomDepEnt = value; } }
        public string dFNombram { get { return _dFNombram; } set { _dFNombram = value; } }
        public string sNomAutori { get { return _sNomAutori; } set { _sNomAutori = value; } }
        //public int idFKUsuRecibe { get { return _idFKUsuRecibe; } set { _idFKUsuRecibe = value; } }
        //public int iNumPerRec { get { return _iNumPerRec; } set { _iNumPerRec = value; } }
        public int idFKDomEntr { get { return _idFKDomEntr; } set { _idFKDomEntr = value; } }
        public string sNomAdmon { get { return _sNomAdmon; } set { _sNomAdmon = value; } }
        public int iNumPerAdmon { get { return _iNumPerAdmon; } set { _iNumPerAdmon = value; } }
        public int idFKDomAdmon { get { return _idFKDomAdmon; } set { _idFKDomAdmon = value; } }
        public int idFKDomRecib { get { return _idFKDomRecib; } set { _idFKDomRecib = value; } }
        public string sNomAudit { get { return _sNomAudit; } set { _sNomAudit = value; } }
        public string sNomTest1 { get { return _sNomTest1; } set { _sNomTest1 = value; } }
        public int iEdadTest1 { get { return _iEdadTest1; } set { _iEdadTest1 = value; } }
        public string sEdoCivilTest1 { get { return _sEdoCivilTest1; } set { _sEdoCivilTest1 = value; } }
        public string sRFCTest1 { get { return _sRFCTest1; } set { _sRFCTest1 = value; } }
        public string sTrabTest1 { get { return _sTrabTest1; } set { _sTrabTest1 = value; } }
        public string sPuesTest1 { get { return _sPuesTest1; } set { _sPuesTest1 = value; } }
        public int idFKDomTest1 { get { return _idFKDomTest1; } set { _idFKDomTest1 = value; } }
        public string sNomTest2 { get { return _sNomTest2; } set { _sNomTest2 = value; } }
        public int iEdadTest2 { get { return _iEdadTest2; } set { _iEdadTest2 = value; } }
        public string sEdoCivilTest2 { get { return _sEdoCivilTest2; } set { _sEdoCivilTest2 = value; } }
        public string sRFCTest2 { get { return _sRFCTest2; } set { _sRFCTest2 = value; } }
        public string sTrabTest2 { get { return _sTrabTest2; } set { _sTrabTest2 = value; } }
        public string sPuesTest2 { get { return _sPuesTest2; } set { _sPuesTest2 = value; } }
        public int idFKDomTest2 { get { return _idFKDomTest2; } set { _idFKDomTest2 = value; } }

        public string sZona { get { return _sZona; } set { _sZona = value; } }
        public string uObligado { get { return _uObligado; } set { _uObligado = value; } }
        public int nNumPerEntrega { get { return _nNumPerEntrega; } set { _nNumPerEntrega = value; } }
        public string sCargoEntrega { get { return _sCargoEntrega; } set { _sCargoEntrega = value; } }

        public string uReceptor { get { return _uReceptor; } set { _uReceptor = value; } }
        public int nNumPerRecibe { get { return _nNumPerRecibe; } set { _nNumPerRecibe = value; } }
        public string scargoRecibe { get { return _scargoRecibe; } set { _scargoRecibe = value; } }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion


        class clsDomicilio
        {
            private int _idDomicilio;
            private string _sCalle;
            private string _sNumExt;
            private string _sNumInEnt;
            private string _sColonia;
            private int _iCodPostal;
            private string _sMpio;
            private string _sCiudad;

            public clsDomicilio()
            {
            }

            public clsDomicilio(string sCalle, string sNumExt, string sNumInEnt, string sColonia, int iCodPostal, string sMpio, string sCiudad)
            {
                this._sCalle = sCalle;
                this._sNumExt = sNumExt;
                this._sNumInEnt = sNumInEnt;
                this._sColonia = sColonia;
                this._iCodPostal = iCodPostal;
                this._sMpio = sMpio;
                this._sCiudad = sCiudad;
            }

            public int idDomicilio { get { return _idDomicilio; } set { _idDomicilio = value; } }
            public string sCalle { get { return _sCalle; } set { _sCalle = value; } }
            public string sNumExt { get { return _sNumExt; } set { _sNumExt = value; } }
            public string sNumInEnt { get { return _sNumInEnt; } set { _sNumInEnt = value; } }
            public string sColonia { get { return _sColonia; } set { _sColonia = value; } }
            public int iCodPostal { get { return _iCodPostal; } set { _iCodPostal = value; } }
            public string sMpio { get { return _sMpio; } set { _sMpio = value; } }
            public string sCiudad { get { return sCiudad; } set { _sCiudad = value; } }
        }
    }
}