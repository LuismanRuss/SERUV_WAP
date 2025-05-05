using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using libFunciones;
using System.Threading;


/// Versión:                        1.0
/// Autor:                          L.I. Jesús Montero Cuevas 
/// Fecha de Creación:              12 de Abril 2013
/// Modificó:                       Jesús Montero Cuevas 12/Abril/2013
/// 

namespace nsSERUV
{
    public class clsSupervision : IDisposable
    {
        #region VARIABLES GLOBALES

        System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
        bool blnRespuesta = false;

        private List<clsSupervision> _laRegresaDatos;
        private List<clsSupervision> _laAvanceGeneral;
        private List<clsSupervision> _laAvanceDepcia;
        private List<clsSupervision> _laAnexos;
        private List<clsSupervision> _laDepcias;
        private List<clsSupervision> _laPerfiles;

        public static List<clsSupervision> laEnlaceOperativo;
        public static List<clsSupervision> laEnlaceOperativoReceptor;
        private string _strResp;
        clsValidacion _libFunciones;

        #endregion

        #region PROPIEDADES DE CLASE
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
        private string _chrAplica;
        private int _nNumArchivos;
        private int _nIdPartAplic;
        private string _sPerfil;
        private string _cEstatusProc;
        private string _cIndActivo;
        private string _cEstatusDepcia;
        private string _cIndEntregaDepcia;
        private int _anexTotales;
        private int _anexIntegrados;
        private string _sGuiaER;
        private string _cIndCerrado;
        private string _nFKDepcia;
        private string _nFKDepciaProc;
        private string _usuarioReceptor;
        private string _enlaceOperativo;
        private string _cIndPrincipal;
        private string _enlaceOperativoReceptor;
        private string _cIndPrincipalR;
        private string _sCorreo;
        private string _dextemInicio;
        private string _dextemFinal;
        private string _cIndActa;
        #endregion


        #region fGetAnexosExcluidos
        /// <summary>
        ///----**********---------------************----------------------**************------------------
        ///----**********---------------************----------------------**************------------------
        /// Método que obtiene los anexos excluidos del participante
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        ///<param name="nIdParticipante">ID del participante</param> 
        ///<param name="numeroAnexos">Número de anexos excluidos de la dependencia</param> 
        /// <returns></returns>
        public bool fGetAnexosExcluidos(int nIdParticipante, int numeroAnexos)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_ANEX_EXCLUIDOS"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intNUMEROANEXOS", numeroAnexos));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_SET_OUT("PA_SELV_SUPERVISION", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                    if (_strResp == "1")
                    {
                        laRegresaDatos = new List<clsSupervision>();
                        pLlenar_Lista(objDALSQL.Get_dtSet(), "ANEX_EXCLUIDOS");
                        blnRespuesta = true;
                    }
                    else
                    {
                        blnRespuesta = false;
                    }
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region fGetAnexosPendientes
        /// <summary>
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que obtiene los anexos pendientes del participante
        ///<param name="nIdParticipante">ID del participante</param> 
        ///<param name="numeroAnexos">Número de anexos pendientes de la dependencia</param> 
        /// <returns></returns>
        public bool fGetAnexosPendientes(int nIdParticipante, int numeroAnexos)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_ANEX_PENDIENTES"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intNUMEROANEXOS", numeroAnexos));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (blnRespuesta = objDALSQL.ExecQuery_SET_OUT("PA_SELV_SUPERVISION", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                    if (_strResp == "1")
                    {
                        laRegresaDatos = new List<clsSupervision>();
                        pLlenar_Lista(objDALSQL.Get_dtSet(), "ANEX_PENDIENTES");
                        blnRespuesta = true;
                    }
                    else
                    {
                        blnRespuesta = false;
                    }
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetAnexosIntegrados
        /// <summary>
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que obtiene los anexos integrados de una dependencia
        ///<param name="nIdParticipante">ID del participante</param> 
        ///<param name="numeroAnexos">Número de anexos integrados de la dependencia</param> 
        /// <returns></returns>
        public bool fGetAnexosIntegrados(int nIdParticipante, int numeroAnexos)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_ANEX_INTEGRADOS"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intNUMEROANEXOS", numeroAnexos));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (blnRespuesta = objDALSQL.ExecQuery_SET_OUT("PA_SELV_SUPERVISION", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                    if (_strResp == "1")
                    {
                        laRegresaDatos = new List<clsSupervision>();
                        pLlenar_Lista(objDALSQL.Get_dtSet(), "ANEX_INTEGRADOS");
                    }
                    else
                    {
                        blnRespuesta = false;
                    }
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetProcesos
        /// <summary>
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que regresa los procesos en los que un usuario está como supervisor
        ///<param name="nIdUsuario">ID del usuario logueado</param> 
        /// <returns></returns>
        public bool fGetProcesos(int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_PROCESO_X_USU_PERFIL"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_SUPERVISION", lstParametros))
                {
                    laRegresaDatos = new List<clsSupervision>();//lista que regresa los procesos
                    laDepcias = new List<clsSupervision>();//lista que regresa las dependencias del proceso
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "PROCESOS");
                }
            }
            return blnRespuesta;
        }
        #endregion


        #region fGetAvanceProceso
        /// <summary>
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>Método que obtiene el avance del proceso y el avance de sus dependencias
        ///<param name="nIdProceso">ID del proceso ER</param> 
        ///<param name="opcion">opción que me dice si es el avance de la página de supervisión o la de cierre</param> 
        ///<param name="nIdUsuario">ID del usuario logueado</param> 
        /// <returns></returns>
        public bool fGetAvanceProceso(int nIdProceso, string opcion, int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_PROCESO_AVANCE"));
                lstParametros.Add(lSQL.CrearParametro("@strOPCION", opcion));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_SUPERVISION", lstParametros))
                {
                    laRegresaDatos = new List<clsSupervision>();
                    laAvanceGeneral = new List<clsSupervision>();

                    if (opcion == "SUPERVISION")
                    {
                        pLlenar_Lista(objDALSQL.Get_dtSet(), "AVANCE");
                    }
                    else
                    {
                        pLlenar_Lista(objDALSQL.Get_dtSet(), "AVANCE_CIERRE");
                    }
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region GetAvanceDepcia
        /// <summary>
        ///  AUTOR: JESÚS MONTERO CUEVAS
        /// </summary>
        ///<param name="nIdParticipante">ID del participante</param> 
        ///<param name="nIdUsuario">ID del usuario logueado</param> 
        /// <returns></returns>
        public bool GetAvanceDepcia(int nIdParticipante, int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GET_AVANCE_DEPCIA"));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nIdParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_SUPERVISION", lstParametros))
                {
                    laRegresaDatos = new List<clsSupervision>();
                    laAvanceDepcia = new List<clsSupervision>();
                    laPerfiles = new List<clsSupervision>();
                    laEnlaceOperativo = new List<clsSupervision>();
                    laEnlaceOperativoReceptor = new List<clsSupervision>();

                    pLlenar_Lista(objDALSQL.Get_dtSet(), "AVANCE_DEPCIA");
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region Abre_Proceso
        /// <summary>
        /// Método que abre el proceso de una dependencia
        /// </summary>
        /// <param name="idParticipante">ID del participante que se va a abrir</param>
        /// <param name="idUsuario">ID del usuario logueado</param>
        /// <param name="sJustificacion">justificación de porque se abre</param>
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public string Abre_Proceso(int idParticipante, int idUsuario, string sJustificacion, int nIdProceso)
        {
            int strIdParticipante_salida;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                using (this._libFunciones = new clsValidacion())
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "ABRIR_PROCESO"));
                    lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", idParticipante));
                    lstParametros.Add(lSQL.CrearParametro("@strJUSTIFICACION", sJustificacion));
                    lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTESALIDA", 0, SqlDbType.Int, ParameterDirection.Output));

                    if (objDALSQL.ExecQuery_SET_OUT("PA_IDUH_SUPERVISION", lstParametros))
                    {
                        System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();

                        this._strResp = arrOUT[0].ToString();
                        strIdParticipante_salida = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);
                        this._strResp += "," + strIdParticipante_salida;

                        if (arrOUT[0].ToString() == "1") //si la acción se realizó correctamente entonces se envia notificación
                        {
                            DataSet ds = objDALSQL.Get_dtSet();                       //  DataSet que almacenará la información necesaria para enviar la notificación correspondiente
                            string dato = clsJsonMethods.ConvertDataSetToXML(ds);     //  string que almacenará el XML 

                            clsWSNotif wsNotif = new clsWSNotif();                    //  Crea un objeto que se usará para la comunicación con la clase del WebService
                            Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "REAP_PROC"));   //Hilo de ejecución para enviar la notificación correspondiente
                            tmod.Start();

                        }
                    }
                }
            }
            return _strResp;
        }
        #endregion


        #region
        /// <summary>
        ///  //--------------  MÉTODO QUE LLENA LA LISTA PARA MANDARLA AL CLIENTE  ---------------------------
        ///  //AUTOR: JESÚS MONTERO CUEVAS-----------------------------------------------------------
        /// </summary>
        /// <param name="dataset">dataset que contiene las consultas </param>
        /// <param name="op">opción</param>
        private void pLlenar_Lista(DataSet dataset, string op)
        {
            try
            {
                switch (op)
                {
                    case "AVANCE"://se llena la lista que trae el avance general del proceso, sus dependencias y sus respectivos avances en la parte de supervisión
                                  //avance general
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.avanceGeneralProceso = float.Parse(row["avanceGeneralProceso"].ToString());
                            objSup.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objSup.sEstatus = row["cEstatus"].ToString();
                            laAvanceGeneral.Add(objSup);
                        }

                        //datos para el grid
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[1].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objSup.nDepcia = int.Parse(row["nDepcia"].ToString());
                            objSup.sDDepcia = row["sDDepcia"].ToString();
                            objSup.avanceGeneral = float.Parse(row["avanceGeneral"].ToString());
                            objSup.excluidos = int.Parse(row["excluidos"].ToString());
                            objSup.integrados = int.Parse(row["integrados"].ToString());
                            objSup.pendientes = int.Parse(row["pendientes"].ToString());
                            objSup.cIndEntrega = row["cIndEntrega"].ToString();
                            objSup.cEstatus = row["cEstatus"].ToString();
                            objSup.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                            objSup.sDProceso = row["nombreProceso"].ToString();
                            objSup.cIndCerrado = row["cIndCerrado"].ToString();

                            laRegresaDatos.Add(objSup);
                        }
                        break;


                    case "AVANCE_CIERRE"://se llena la lista que trae el avance general del proceso, sus dependencias y sus respectivos avances en la parte de cierre
                                         //avance general
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.sFechaInicio = DateTime.Parse(row["dFInicio"].ToString()).ToString("dd/MM/yyyy");
                            objSup.sFechaFinal = DateTime.Parse(row["dFFinal"].ToString()).ToString("dd/MM/yyyy");
                            objSup.sEstatus = row["cEstatus"].ToString();
                            laAvanceGeneral.Add(objSup);
                        }

                        //datos para el grid
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[1].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objSup.nDepcia = int.Parse(row["nDepcia"].ToString());
                            objSup.sDDepcia = row["sDDepcia"].ToString();
                            objSup.avanceGeneral = float.Parse(row["avanceGeneral"].ToString());
                            objSup.excluidos = int.Parse(row["excluidos"].ToString());
                            objSup.integrados = int.Parse(row["integrados"].ToString());
                            objSup.pendientes = int.Parse(row["pendientes"].ToString());
                            objSup.cIndEntrega = row["cIndEntrega"].ToString();
                            objSup.cEstatus = row["cEstatus"].ToString();
                            objSup.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                            objSup.sDProceso = row["nombreProceso"].ToString();
                            objSup.cIndCerrado = row["cIndCerrado"].ToString();

                            laRegresaDatos.Add(objSup);
                        }
                        break;

                    case "PROCESOS"://se llena la lista con los procesos en los que un usuario se encuentra como supervisor
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objSup.sProceso = row["sProceso"].ToString();
                            objSup.sDProceso = row["sDProceso"].ToString();
                            objSup.sFechaInicio = DateTime.Parse(row["dFInicio"].ToString()).ToString("dd/MM/yyyy");
                            objSup.sFechaFinal = DateTime.Parse(row["dFFinal"].ToString()).ToString("dd/MM/yyyy");
                            objSup.sEstatus = row["cEstatus"].ToString();
                            objSup.laDepcias = new List<clsSupervision>();

                            if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                            {
                                objSup.laDepcias = null;
                            }
                            else
                            {
                                objSup.laDepcias = getDepciasXProc(dataset, objSup.nIdProceso);
                            }
                            laRegresaDatos.Add(objSup);
                        }
                        break;

                    case "ANEX_EXCLUIDOS"://se llena la lista que regresa los anexos excluidos
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdAnexo = int.Parse(row["idAnexo"].ToString());
                            objSup.sAnexo = row["sAnexo"].ToString();
                            objSup.sDAnexo = row["sDAnexo"].ToString();
                            objSup.sJustificacion = row["sJustificacion"].ToString();

                            laRegresaDatos.Add(objSup);
                        }
                        break;

                    case "ANEX_PENDIENTES"://se llena la lista que regresa los anexos pendientes
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdAnexo = int.Parse(row["idAnexo"].ToString());
                            objSup.sAnexo = row["sAnexo"].ToString();
                            objSup.sDAnexo = row["sDAnexo"].ToString();

                            laRegresaDatos.Add(objSup);
                        }
                        break;

                    case "ANEX_INTEGRADOS"://se llena la lista que regresa los anexos integrados
                        laRegresaDatos.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdAnexo = int.Parse(row["idAnexo"].ToString());
                            objSup.sAnexo = row["sAnexo"].ToString();
                            objSup.sDAnexo = row["sDAnexo"].ToString();

                            laRegresaDatos.Add(objSup);
                        }
                        break;

                    case "AVANCE_DEPCIA"://se llena las listas del avance de la dependencia, anexos, enlaces operativos
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdProceso = int.Parse(row["idProceso"].ToString());
                            objSup.sProceso = row["sProceso"].ToString();
                            objSup.dFInicio = DateTime.Parse(row["dFInicio"].ToString()).ToString("dd-MM-yyyy");
                            objSup.dFFinal = DateTime.Parse(row["dFFinal"].ToString()).ToString("dd-MM-yyyy");
                            objSup.sDPuesto = row["sDPuesto"].ToString();
                            objSup.usuarioObligado = row["usuarioObligado"].ToString();
                            objSup.cEstatusDepcia = row["cEstatusDepcia"].ToString();
                            objSup.sDDepcia = row["deependencia"].ToString();
                            objSup.sDProceso = row["nombreProceso"].ToString();
                            objSup.avanceGeneral = float.Parse(row["avanceGeneral"].ToString());
                            objSup.cIndEntrega = row["cIndEntrega"].ToString();
                            objSup.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                            objSup.cEstatusProc = row["cEstatusProc"].ToString();
                            objSup.cIndActivo = row["cIndActivo"].ToString();
                            objSup.cIndEntregaDepcia = row["cIndEntregaDepcia"].ToString();
                            objSup.anexTotales = int.Parse(row["anexTotales"].ToString());
                            objSup.anexIntegrados = int.Parse(row["anexIntegrados"].ToString());
                            objSup.sGuiaER = row["sGuiaER"].ToString();
                            objSup.cIndCerrado = row["cIndCerrado"].ToString();
                            objSup.nFKDepcia = row["nFKDepcia"].ToString();
                            objSup.nFKDepciaProc = row["nFKDepciaProc"].ToString();
                            objSup.usuarioReceptor = row["usuarioReceptor"].ToString();
                            objSup.nFKDepcia = row["nFKDepcia"].ToString();

                            if (row["extemInicio"].ToString() != "")
                            {
                                objSup.dextemInicio = DateTime.Parse(row["extemInicio"].ToString()).ToString("dd-MM-yyyy");
                                objSup.dextemFinal = DateTime.Parse(row["extemFinal"].ToString()).ToString("dd-MM-yyyy");
                            }
                            else
                            {
                                objSup.dextemInicio = null;
                                objSup.dextemFinal = null;
                            }


                            objSup.cIndCerrado = row["cIndCerrado"].ToString();
                            objSup.laPerfiles = new List<clsSupervision>();

                            if (dataset.Tables[1] == null || dataset.Tables[1].Rows.Count == 0)
                            {
                                laRegresaDatos = null;
                            }
                            else
                            {
                                objSup.laPerfiles = getPerfiles(dataset, objSup.nIdParticipante);
                            }
                            laRegresaDatos.Add(objSup);
                        }


                        foreach (DataRow row in dataset.Tables[2].Rows)
                        {
                            clsSupervision objSup = new clsSupervision();
                            objSup.nIdProceso = int.Parse(row["nIdProceso"].ToString());
                            objSup.nIdParticipante = int.Parse(row["nIdParticipante"].ToString());
                            objSup.nIdApartado = int.Parse(row["nIdApartado"].ToString());
                            objSup.sApartado = row["sApartado"].ToString();
                            objSup.sDApartado = row["sDApartado"].ToString();
                            objSup.chrAplica = row["cAplica"].ToString();
                            objSup.laAnexos = new List<clsSupervision>();

                            if (dataset.Tables[3] == null || dataset.Tables[3].Rows.Count == 0)
                            {
                                laAvanceDepcia = null;
                            }
                            else
                            {
                                objSup.laAnexos = getAnexosApartado(dataset, objSup.nIdParticipante, objSup.nIdApartado);
                            }

                            laAvanceDepcia.Add(objSup);
                        }

                        if (dataset.Tables[4] == null || dataset.Tables[4].Rows.Count == 0)
                        {
                            laEnlaceOperativo = null;
                        }
                        else
                        {
                            foreach (DataRow rowEO in dataset.Tables[4].Rows)
                            {
                                clsSupervision objSup = new clsSupervision();
                                objSup.enlaceOperativo = rowEO["enlaceOperativo"].ToString();
                                objSup.cIndPrincipal = rowEO["cIndPrincipal"].ToString();
                                objSup.sCorreo = rowEO["sCorreo"].ToString();
                                laEnlaceOperativo.Add(objSup);
                            }
                        }


                        if (dataset.Tables[5] == null || dataset.Tables[5].Rows.Count == 0)
                        {
                            laEnlaceOperativoReceptor = null;
                        }
                        else
                        {
                            foreach (DataRow rowEOR in dataset.Tables[5].Rows)
                            {
                                clsSupervision objSup = new clsSupervision();
                                objSup.enlaceOperativoReceptor = rowEOR["enlaceOperativoReceptor"].ToString();
                                objSup.cIndPrincipalR = rowEOR["cIndPrincipalR"].ToString();
                                objSup.sCorreo = rowEOR["sCorreo"].ToString();
                                laEnlaceOperativoReceptor.Add(objSup);
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
        #endregion

        #region getDepciasXProc
        /// <summary>
        /// Método que obtiene las dependencias por proceso
        /// </summary>
        /// <param name="dataset">dataset </param>
        /// <param name="nIdProceso">ID del proceso-ER</param>
        /// <returns></returns>
        public List<clsSupervision> getDepciasXProc(DataSet dataset, int nIdProceso)
        {
            DataTable tabla = dataset.Tables[1];
            List<clsSupervision> laRegresa = new List<clsSupervision>();
            clsSupervision obj;
            DataRow[] result = tabla.Select("idFKProceso =" + nIdProceso);
            foreach (DataRow row in result)
            {
                obj = new clsSupervision();
                obj.nIdProceso = int.Parse(row["idFKProceso"].ToString());
                obj.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                obj.sDDepcia = row["sDDepcia"].ToString();

                laRegresa.Add(obj);
            }
            return laRegresa;
        }
        #endregion


        #region getAnexosApartado
        /// <summary>
        /// Método que obtiene los anexos por apartado
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nIdApartado">ID del apartado</param>
        /// <returns></returns>
        public List<clsSupervision> getAnexosApartado(DataSet dataset, int nIdParticipante, int nIdApartado)
        {
            DataTable tabla = dataset.Tables[3];
            List<clsSupervision> laRegresa = new List<clsSupervision>();
            clsSupervision obj;
            DataRow[] result = tabla.Select("nIdParticipante ='" + nIdParticipante + "' AND nIdApartado='" + nIdApartado + "'");
            foreach (DataRow row in result)
            {
                obj = new clsSupervision();

                obj.nIdParticipante = int.Parse(row["nIdParticipante"].ToString());
                obj.nIdApartado = int.Parse(row["nIdApartado"].ToString());
                obj.nIdAnexo = int.Parse(row["nIdAnexo"].ToString());
                obj.cIndEntrega = row["cIndEntrega"].ToString();
                obj.sAnexo = row["sAnexo"].ToString();
                obj.sDAnexo = row["sDAnexo"].ToString();
                obj.sAnexo = row["sAnexo"].ToString();
                obj.nNumArchivos = int.Parse(row["nNumArchivos"].ToString());
                obj.nIdPartAplic = int.Parse(row["nIdPartAplic"].ToString());
                obj.cIndActa = row["cIndActa"].ToString();

                laRegresa.Add(obj);
            }
            return laRegresa;
        }
        #endregion

        #region getPerfiles
        /// <summary>
        /// Método que obtiene los perfiles de la dependencia
        /// </summary>
        /// <param name="dataset">dataset</param>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <returns></returns>
        public List<clsSupervision> getPerfiles(DataSet dataset, int nIdParticipante)
        {
            DataTable tabla = dataset.Tables[1];
            List<clsSupervision> laRegresa = new List<clsSupervision>();
            clsSupervision obj;
            DataRow[] result = tabla.Select("idParticipante =" + nIdParticipante);
            foreach (DataRow row in result)
            {
                obj = new clsSupervision();
                obj.nIdParticipante = int.Parse(row["idParticipante"].ToString());
                obj.nIdProceso = int.Parse(row["idFKProceso"].ToString());
                obj.sPerfil = row["sDPerfil"].ToString();

                laRegresa.Add(obj);
            }
            return laRegresa;
        }
        #endregion



        #region GET'S Y SET'S

        public List<clsSupervision> laRegresaDatos { get { return _laRegresaDatos; } set { _laRegresaDatos = value; } }
        public List<clsSupervision> laAvanceGeneral { get { return _laAvanceGeneral; } set { _laAvanceGeneral = value; } }
        public List<clsSupervision> laAvanceDepcia { get { return _laAvanceDepcia; } set { _laAvanceDepcia = value; } }
        public List<clsSupervision> laAnexos { get { return _laAnexos; } set { _laAnexos = value; } }
        public List<clsSupervision> laDepcias { get { return _laDepcias; } set { _laDepcias = value; } }
        public List<clsSupervision> laPerfiles { get { return _laPerfiles; } set { _laPerfiles = value; } }

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
        public string cIndActivo { get { return _cIndActivo; } set { _cIndActivo = value; } }
        public string cEstatusDepcia { get { return _cEstatusDepcia; } set { _cEstatusDepcia = value; } }
        public string cIndEntregaDepcia { get { return _cIndEntregaDepcia; } set { _cIndEntregaDepcia = value; } }
        public int anexTotales { get { return _anexTotales; } set { _anexTotales = value; } }
        public int anexIntegrados { get { return _anexIntegrados; } set { _anexIntegrados = value; } }
        public string sGuiaER { get { return _sGuiaER; } set { _sGuiaER = value; } }
        public string cIndCerrado { get { return _cIndCerrado; } set { _cIndCerrado = value; } }
        public string chrAplica { get { return _chrAplica; } set { _chrAplica = value; } }
        public string nFKDepcia { get { return _nFKDepcia; } set { _nFKDepcia = value; } }
        public string nFKDepciaProc { get { return _nFKDepciaProc; } set { _nFKDepciaProc = value; } }
        public string usuarioReceptor { get { return _usuarioReceptor; } set { _usuarioReceptor = value; } }
        public string enlaceOperativo { get { return _enlaceOperativo; } set { _enlaceOperativo = value; } }
        public string cIndPrincipal { get { return _cIndPrincipal; } set { _cIndPrincipal = value; } }
        public string enlaceOperativoReceptor { get { return _enlaceOperativoReceptor; } set { _enlaceOperativoReceptor = value; } }
        public string cIndPrincipalR { get { return _cIndPrincipalR; } set { _cIndPrincipalR = value; } }
        public string sCorreo { get { return _sCorreo; } set { _sCorreo = value; } }
        public string dextemInicio { get { return _dextemInicio; } set { _dextemInicio = value; } }
        public string dextemFinal { get { return _dextemFinal; } set { _dextemFinal = value; } }
        public string cIndActa { get { return _cIndActa; } set { _cIndActa = value; } }
        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}