using System;
using System.Collections.Generic;
using System.Web;
using libFunciones;
using System.Data;
using nsSERUV;
using System.Web.Script.Serialization;
using System.Collections;
using System.Threading;
/// <summary>
/// Objetivo                    :  Guardar y recuperar los datos de la bitácora.
/// Versión                     :  1.0
/// Autor                       :  L.I. Emmanuel Méndez Flores
/// Fecha Creación              :  3/Julio/2013
/// Tablas de la BD que utiliza :  APCBITACORA, APRBITACOMEN, APCRECOMENDACION
/// </summary>
namespace nsSERUV
{
    public class clsBitacora
    {
        #region Propiedades privadas de la clase

        private int _idBitacora;
        private int _idFKProceso;
        private int _nFKDepcia;
        private int _idFKApartado;
        private int _idFKAnexo;
        private string _sObservaciones;
        private float _iAvance;
        private string _dteFAlta;
        private int _nUsuarioSup;
        private int _idRecomenda;
        private string _sDRecomenda;
        private string _strAccion;

        private System.Collections.ArrayList _lstParametros;
        private List<clsBitacora> _lstRegresaDatos;
        private int _intResp;


        #endregion

        #region GET's Y SET's

        public int idBitacora { get { return _idBitacora; } set { _idBitacora = value; } }
        public int idFKProceso { get { return _idFKProceso; } set { _idFKProceso = value; } }
        public int nFKDepcia { get { return _nFKDepcia; } set { _nFKDepcia = value; } }
        public int idFKApartado { get { return _idFKApartado; } set { _idFKApartado = value; } }
        public int idFKAnexo { get { return _idFKAnexo; } set { _idFKAnexo = value; } }
        public string sObervaciones { get { return _sObservaciones; } set { _sObservaciones = value; } }
        public float iAvance { get { return _iAvance; } set { _iAvance = value; } }
        public string dteFAlta { get { return _dteFAlta; } set { _dteFAlta = value; } }
        public int nUsuarioSup { get { return _nUsuarioSup; } set { _nUsuarioSup = value; } }
        public int idRecomenda { get { return _idRecomenda; } set { _idRecomenda = value; } }
        public string sDRecomenda { get { return _sDRecomenda; } set { _sDRecomenda = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public List<clsBitacora> lstRegresaDatos { get { return _lstRegresaDatos; } set { _lstRegresaDatos = value; } }

        #endregion

        #region Constructores
        public clsBitacora()
        {
            //
            // TODO: Agregar aquí la lógica del constructor
            //
        }
        #endregion

        #region procedimientos de la clase clsBitacora

        #region fGuardarBitacora()
        /// <summary>
        /// Procedimiento que guarda las observaciones hechas a un anexo
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Entero que indica si se realizó correctamente la operación</returns>
        public int fGuardarBitacora()
        {
            this._lstParametros = new System.Collections.ArrayList();
            _intResp = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", _strAccion));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", _idFKProceso));
                _lstParametros.Add(lSQL.CrearParametro("@intIDAPARTADO", _idFKApartado));
                _lstParametros.Add(lSQL.CrearParametro("@intIDANEXO", _idFKAnexo));
                _lstParametros.Add(lSQL.CrearParametro("@intIDDEPENDENCIA", _nFKDepcia));
                _lstParametros.Add(lSQL.CrearParametro("@intIDRECOMENDA", _idRecomenda));
                _lstParametros.Add(lSQL.CrearParametro("@strOBSERVACIONES", _sObservaciones));
                _lstParametros.Add(lSQL.CrearParametro("@fltAVANCE", _iAvance));
                _lstParametros.Add(lSQL.CrearParametro("@intUSUARIOSUP", _nUsuarioSup));
                _lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_BITACORA", _lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    _intResp = Convert.ToInt32(arrOUT[0].ToString());
                }
            }
            return _intResp;
        }
        #endregion

        #region fObtieneObservaciones()
        /// <summary>
        /// Procedimiento que obtiene las observaciones hechas a un anexo
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Un boleano que indica si se realizó correctamente la operación</returns>
        public bool fObtieneObservaciones()
        {
            bool blnResp = false;
            this._lstParametros = new System.Collections.ArrayList();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", _strAccion));
                _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", _idFKProceso));
                _lstParametros.Add(lSQL.CrearParametro("@intIDDEPENDENCIA", _nFKDepcia));
                if (objDALSQL.ExecQuery_SET("PA_SELV_BITACORA", _lstParametros))
                {
                    pLlenarLista(objDALSQL.Get_dtSet(), "BITACORA");
                }
            }
            return blnResp;
        }
        #endregion

        #region fObtieneRecomendaciones
        /// <summary>
        /// Procedimiento que obtiene las recomendaciones del catálogo
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Un entero indicando si se realizó correctamente la operación </returns>
        public int fObtieneRecomendaciones()
        {
            _intResp = 0;
            this._lstParametros = new System.Collections.ArrayList();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", _strAccion));
                if (objDALSQL.ExecQuery_SET("PA_SELV_RECOMENDACION", _lstParametros))
                {
                    pLlenarLista(objDALSQL.Get_dtSet(), "RECOMENDACION");
                }
            }
            return _intResp;
        }
        #endregion

        #region pLlenarLista
        /// <summary>
        /// Procedimiento que llena la lista _lstRegresaDatos de acuerdo a una opción
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="dataset">Dataset con la información de la bitácora.</param>
        /// <param name="strOpcion">Opción a ejecutar</param>
        public void pLlenarLista(DataSet dataset, string strOpcion)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (strOpcion)
                    {
                        case "BITACORA": // Llena la lista con información de la bitácora
                            lstRegresaDatos = new List<clsBitacora>();
                            //lstRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsBitacora objBitacora = new clsBitacora();
                                objBitacora.idBitacora = int.Parse(row["idBitacora"].ToString());
                                objBitacora._idFKAnexo = int.Parse(row["idFKAnexo"].ToString());
                                objBitacora._idRecomenda = int.Parse(row["idFKRecomenda"].ToString());
                                objBitacora._sObservaciones = row["sObservaciones"].ToString();
                                lstRegresaDatos.Add(objBitacora);
                            }
                            break;
                        case "RECOMENDACION": // Llena la lista con las recomendaciones.
                            lstRegresaDatos = new List<clsBitacora>();
                            //lstRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsBitacora objBitacora = new clsBitacora();
                                objBitacora.idRecomenda = int.Parse(row["idRecomenda"].ToString());
                                objBitacora.sDRecomenda = row["sDRecomenda"].ToString(); ;
                                lstRegresaDatos.Add(objBitacora);
                            }
                            break;
                    }
                }
            }
            catch
            {
                lstRegresaDatos = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fGetDatos_Notificacion
        /// <summary>
        /// Procedimiento que obtiene los datos para enviar la notificación con las observaciones
        /// Autor: Edgar Morales González
        /// </summary>
        /// 
        public int fGetDatos_Notificacion(int nProceso, int nDepcia, int nParticipante, int nSupervisor)
        {
            try
            {
                string strAccion = "ENVIA_OBSERV";
                this._lstParametros = new System.Collections.ArrayList();
                using (clsDALSQL objDASQL = new clsDALSQL(false))
                {

                    libSQL lSQL = new libSQL();
                    _lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nProceso));
                    _lstParametros.Add(lSQL.CrearParametro("@intIDDEPENDENCIA", nDepcia));
                    _lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", nParticipante));
                    _lstParametros.Add(lSQL.CrearParametro("@intUSUARIOSUP", nSupervisor));
                    _lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));

                    if (objDASQL.ExecQuery_SET("PA_SELV_BITACORA", _lstParametros))
                    {
                        DataSet ds = objDASQL.Get_dtSet();                                                  //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente

                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);                               //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                                               //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        Thread tmod = new Thread(() => wsNotif.SendNotif(dato, "OBS_BITACORA"));            //Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                        tmod.Start();

                        _intResp = 1;   //Hizo bien el Query
                    }
                    else
                    {
                        _intResp = 0; // No hizo la consulta
                    }
                }
            }
            catch
            {
                _intResp = -1; //Error 
            }
            return _intResp;
        }
        #endregion

        #endregion
    }
}