using System;
using System.Collections.Generic;
using System.Web;
using libFunciones;
using System.Data;
using System.Data.SqlClient;

/// Objetivo:                       
/// Versión:                        1.0
/// Autor:                          L.I. Jesús Montero Cuevas 
/// Fecha de Creación:              28 de Febrero 2013
/// Modificó:                       L.I. Jesús Montero Cuevas
/// Fecha de última Mod:            28 de Febrero 2013
/// Tablas de la BD que utiliza:  

namespace nsSERUV
{
    public class clsAvance : IDisposable
    {
        //-------VARIABLES GLOBALES DE LA CLASE-----------------------
        //--JESÚS MONTERO CUEVAS---

        System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
        bool blnRespuesta = false;
        //private List<clsAvance> _laRegresaDatos;
        public List<clsAvance> laRegresaDatos { get { return laRegresaDatos; } set { laRegresaDatos = value; } }

        //-------------------------------------------------------------------------------
        //------PROPIEDADES PARA OBTENER DATOS GENERALES DE LA FORMA SVAAVANCE.aspx ---------------------
        //JESÚS MONTERO CUEVAS
        private int _idUsuario;
        private string _sDDepcia;
        private string _sDPeriodo;


        public int idUsuario { get { return _idUsuario; } set { _idUsuario = value; } }
        public string sDDepcia { get { return _sDDepcia; } set { _sDDepcia = value; } }
        public string sDPeriodo { get { return _sDPeriodo; } set { _sDPeriodo = value; } }


        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //------------------------------------------------------------
        //-------------MÉTODOS DE LA PARTE DE AVANCES-------------
        // AUTOR: JESÚS MONTERO CUEVAS------------------------------

        public bool fGetAvancesXDependencia()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "AVANCESXDEPCIA"));
                //lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", intIdUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_AVANCESER", lstParametros))
                {
                    var laRegresaDatos = new List<clsAvance>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "AVANXDEPEN");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }


        public bool fGetDatosAvances(int nIdUsuario)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_GEN_AVAN"));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", nIdUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_AVANCESER", lstParametros))
                {
                    var laRegresaDatos = new List<clsAvance>();
                    pLlenar_Lista(objDALSQL.Get_dtSet(), "DATOS");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return blnRespuesta;
        }

        //----**********---------------************----------------------**************------------------
        //----**********---------------************----------------------**************------------------

        //--------------  MÉTODO QUE LLENA LA LISTA PARA MANDARLA AL CLIENTE  ---------------------------
        //AUTOR: JESÚS MONTERO CUEVAS-----------------------------------------------------------

        private void pLlenar_Lista(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "DATOS":
                            // laRegresaDatos.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                var objAvance = new clsAvance();
                                objAvance.idUsuario = int.Parse(row["idUsuario"].ToString());
                                objAvance.sDDepcia = row["sDDepcia"].ToString();
                                objAvance.sDPeriodo = row["sDPeriodo"].ToString();
                                laRegresaDatos.Add(objAvance);
                            }
                            break;

                        case "AVANXDEPEN":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                var objAvance = new clsAvance();

                            }
                            break;
                    }
                }
                else
                    laRegresaDatos = null;
            }
            catch //(Exception ex)
            {
                laRegresaDatos = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }


        //----**********---------------************----------------------**************------------------
        //----**********---------------************----------------------**************------------------

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}