using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
//using System.Web.Script.Serialization;
using System.Collections;
using libFunciones;
using nsSERUV;

/// <summary>
/// Descripción breve de clsTipoPersonal
/// </summary>
namespace nsSERUV
{
    public class clsTipoPersonal
    {
        #region Propiedades privadas de la clase

        private int _nTipoPers;
        private string _sDTipoPers;
        private string _strAccion;
        private List<clsTipoPersonal> _lstRegresaDatos;
        private System.Collections.ArrayList _lstParametros;

        private int _intResp;

        #endregion

        #region GET's Y SET's
        public int nTipoPers { get { return _nTipoPers; } set { _nTipoPers = value; } }
        public string sDTipoPers { get { return _sDTipoPers; } set { _sDTipoPers = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public List<clsTipoPersonal> lstRegresaDatos { get { return _lstRegresaDatos; } set { _lstRegresaDatos = value; } }
        #endregion

        public clsTipoPersonal()
        {
            //
            // TODO: Agregar aquí la lógica del constructor
            //
        }

        #region fObtieneTipoPersonal
        /// <summary>
        /// Función que obtiene la lista de tipos de personal
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns></returns>
        public int fObtieneTipoPersonal()
        {
            this._lstParametros = new System.Collections.ArrayList();
            _intResp = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", _strAccion));
                if (objDALSQL.ExecQuery_SET("PA_SELV_TIPOPERSONAL", _lstParametros))
                {
                    pLlenarLista(objDALSQL.Get_dtSet(), "TIPO_PERSONAL");
                }
            }
            return _intResp;
        }
        #endregion

        #region pLlenarLista
        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataset"></param>
        /// <param name="strOpcion"></param>
        public void pLlenarLista(DataSet dataset, string strOpcion)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (strOpcion)
                    {
                        case "TIPO_PERSONAL": // Llena la lista con información de la bitácora
                            lstRegresaDatos = new List<clsTipoPersonal>();
                            //lstRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsTipoPersonal objTipoPersonal = new clsTipoPersonal();
                                objTipoPersonal.nTipoPers = int.Parse(row["nTipoPers"].ToString());
                                objTipoPersonal.sDTipoPers = row["sDTipoPers"].ToString();
                                lstRegresaDatos.Add(objTipoPersonal);
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

    }
}