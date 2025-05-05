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
/// Descripción breve de clsCategoria
/// </summary>

namespace nsSERUV
{
    public class clsCategoria
    {
        #region Propiedades privadas de la clase

        private int _nCategoria;
        private string _sDCategoria;
        private string _strAccion;
        private int _intResp;

        private List<clsCategoria> _lstRegresaDatos;
        private System.Collections.ArrayList _lstParametros;

        #endregion

        #region GET's Y SET's
        public int nCategoria { get { return _nCategoria; } set { _nCategoria = value; } }
        public string sDCategoria { get { return _sDCategoria; } set { _sDCategoria = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public List<clsCategoria> lstRegresaDatos { get { return _lstRegresaDatos; } set { _lstRegresaDatos = value; } }
        #endregion

        #region procedimientos de la clase Categoría
        public clsCategoria()
        {
            //
            // TODO: Agregar aquí la lógica del constructor
            //
        }

        public int fObtieneCategoria()
        {
            this._lstParametros = new System.Collections.ArrayList();
            _intResp = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", _strAccion));
                if (objDALSQL.ExecQuery_SET("PA_SELV_CATEGORIA", _lstParametros))
                {
                    pLlenarLista(objDALSQL.Get_dtSet(), "CATEGORIA");
                }
            }

            return _intResp;
        }

        public void pLlenarLista(DataSet dataset, string strOpcion)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (strOpcion)
                    {
                        case "CATEGORIA": // Llena la lista con información de la bitácora
                            lstRegresaDatos = new List<clsCategoria>();
                            //lstRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsCategoria objCategoria = new clsCategoria();
                                objCategoria.nCategoria = int.Parse(row["nCategoria"].ToString());
                                objCategoria.sDCategoria = row["sDCategoria"].ToString();
                                lstRegresaDatos.Add(objCategoria);
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