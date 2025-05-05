using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data;
using libFunciones;
using nsSERUV;

/// <summary>
/// Objetivo:                       Clase para el manejo de Puestos
/// Versión:                        1.0
/// Autor:                          LSCA Edgar Morales González
/// Fechas:                         25 de Febrero de 2013 al 28 de Febrero de 2013
/// Tablas de la BD que utiliza:    AWVPUESTO
/// </summary>

namespace nsSERUV
{

    public class clsPuesto
    {

        #region Propiedades usadas para el manejo de la clase Puesto
        //Propiedades de la clase Puesto
        private int _nPuesto; // Id del Puesto
        private string _sDPuesto; // Descripción del Puesto
        private List<clsPuesto> _laPuesto; //Lista de Puestos
        private int _idProceso;  //Id del Proceso
        private int _nDepcia;   //Número de la Dependencia 
        private List<clsParticipante> _laSujObl; //Lista de Participantes
        #endregion

        #region Procedimientos de la Clase

        #region fObtener_Puestos
        /// <summary>
        /// Obtiene Lista de Puestos apoyandose en el metodo pLista_Puesto
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns></returns>
        public bool fObtener_Puestos()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_PUESTOS"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("[PA_SELU_PUESTO]", _lstParametros))
                {
                    laPuesto = new List<clsPuesto>();
                    fLista_Puesto(objDALSQL.Get_dtSet(), "Puesto");
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



        #region fObtener_Puesto( )
        //Obtiene Lista de Puestos apoyandose en el metodo pLista_Puesto
        public bool fObtener_Puesto()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_PUESTO"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("[PA_SELU_PUESTO]", _lstParametros))
                {
                    laPuesto = new List<clsPuesto>();
                    fLista_Puesto(objDALSQL.Get_dtSet(), "Puesto");
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

        #region fObtener_PuestoER
        /// <summary>
        /// Función para obtener los puestos disponibles para un proceso entrega-recepción, se apoya en el metodo pLista_Puesto
        /// Autor: Edgar Morales González
        /// </summary>

        public bool fObtener_PuestoER()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_PUESTO_ER"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("[PA_SELU_PUESTO]", _lstParametros))
                {
                    laPuesto = new List<clsPuesto>();
                    fLista_Puesto(objDALSQL.Get_dtSet(), "Puesto");
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

        #region fObtener_PuestoXDependencia
        /// <summary>
        /// Función para obtener el listado de puestos de acuerdo a una dependencia
        /// Autor: Emmanuel Méndez Flores
        /// </summary>
        /// <param name="idUsuario">id del usuario logueado</param>
        /// <returns></returns>
        public bool fObtener_PuestoXDependencia(int idUsuario)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "CONS_PUESTO_X_DEPENDENCIA"));
                _lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_PUESTO", _lstParametros))
                {
                    laPuesto = new List<clsPuesto>();
                    fLista_Puesto(objDALSQL.Get_dtSet(), "Puesto");
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fObtenerPuestosAltaDepto
        /// <summary>
        /// Función para obtener el listado de puestos para la forma de alta de departamentos
        /// Autor: Emmanuel Méndez Flores
        /// </summary>
        /// <returns></returns>
        public bool fObtenerPuestosAltaDepto()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                _lstParametros.Add(lSQL.CrearParametro("@strACCION", "PUESTOS_ALTA_DEPTOS"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_PUESTO", _lstParametros))
                {
                    laPuesto = new List<clsPuesto>();
                    fLista_Puesto(objDALSQL.Get_dtSet(), "Puesto");
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fLista_Puesto
        /// <summary>
        /// Objetivo:   Función que llena una lista con la información de los puestos
        /// Autor: Edgar Morales González
        /// </summary>
        /// <returns>regresa una lista con la informacion de los puestos /returns>
        /// 

        private void fLista_Puesto(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "Puesto":
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsPuesto puesto = new clsPuesto();
                                puesto._nPuesto = Convert.ToInt32(row["nPuesto"].ToString());
                                puesto._sDPuesto = row["sDPuesto"].ToString();

                                laPuesto.Add(puesto);
                            }
                            break;
                    }
                }
                else
                    laPuesto = null;
            }
            catch
            //(Exception ex)
            {
                laPuesto = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion 

        #region IDisposable Members
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #endregion

        #region Getters y Setters de la clase Puesto
        public int nPuesto { get { return _nPuesto; } set { _nPuesto = value; } }
        public string sDPuesto { get { return _sDPuesto; } set { _sDPuesto = value; } }
        public System.Collections.ArrayList _lstParametros;
        public List<clsPuesto> laPuesto { get { return _laPuesto; } set { _laPuesto = value; } }
        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }
        public int nDepcia { get { return _nDepcia; } set { _nDepcia = value; } }
        public List<clsParticipante> laSujObl { get { return _laSujObl; } set { _laSujObl = value; } }
        #endregion
    }
}