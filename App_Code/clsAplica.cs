using System;
using System.Collections.Generic;
using System.Linq;
using libFunciones;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Web;

/// <summary>
/// Objetivo:                       Clase para el manejo de la tabla APEAPLICA
/// Versión:                        1.0
/// Autor:                          Daniel Ramírez Hernández
/// Fecha de Creación:              16 de Marzo 2013
/// Tablas de la BD que utiliza:    APEAPLICA
/// </summary>

namespace nsSERUV
{
    public class clsAplica
    {
        #region Variables privadas

        ArrayList lstParametros = new ArrayList();

        private int _idAplica;          //ID en la tabla APEAPLICA
        private int _idAnexo;           //ID foráneo del Anexo
        private string _strDAplica;     //Descripción de la configuración del Aplicativo del Anexo
        private string _strSiglas;      //Siglas de la configuración del Aplicativo del Anexo
        private char _chrIndActivo;   //Caracter que indica si el Aplicativo está activo o no
        private string _strAccion;   // Variable para controlar la acción a realizar
        private List<clsAplica> _laAplica; //Lista donde almacenaremos los datos traidos de la Base de Datos

        private string _strResp;

        #endregion

        #region Constructores
        /// <summary>
        /// Constructor de la clase clsUsuario
        /// </summary>
        public clsAplica()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        #endregion

        #region GET y SETs
        public int idAplica { get { return _idAplica; } set { _idAplica = value; } }
        public int idAnexo { get { return _idAnexo; } set { _idAnexo = value; } }
        public string strDAplica { get { return _strDAplica; } set { _strDAplica = value; } }
        public string strSiglas { get { return _strSiglas; } set { _strSiglas = value; } }
        public char chrIndActivo { get { return _chrIndActivo; } set { _chrIndActivo = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public List<clsAplica> laAplica { get { return _laAplica; } set { _laAplica = value; } }
        #endregion

        #region fGetAplica
        /// <summary>
        /// Función que consulta las Guías
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public bool fGetAplica()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion.Trim()));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_APEAPLICA", lstParametros))
                {
                    laAplica = new List<clsAplica>();
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "SELECCIONAR");

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

        #region fGetAplica2
        /// <summary>
        /// Función que consulta las Guías
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public bool fGetAplica2()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", this._idAnexo));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                {
                    laAplica = new List<clsAplica>();
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "SELECCIONAR2");

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

        #region fActualizaAplicDepcia
        /// <summary>
        /// Función que realiza la asignación o desasignación del anexo por dependencia
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nidAplica">Id del aplica (id del bloque)</param>
        /// <param name="nIdDepcia">Número de la dependencia</param>
        /// <param name="nIdAnexo">Id del anexo</param>
        /// <param name="cIndActivo">Indicador de activo (S - Si, N - No)</param>
        /// <returns>Una cadena para indicar si se realizó correctamente la operación (S - Si, N - No)</returns>
        public string fActualizaAplicDepcia(int nidAplica, int nIdDepcia, int nIdAnexo, char cIndActivo)
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "CAMBIA_ESTADO_APLICA"));
                lstParametros.Add(lSQL.CrearParametro("@intIDAPLICA", nidAplica));
                lstParametros.Add(lSQL.CrearParametro("@intIDDEPCIA", nIdDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intIDANEXO", nIdAnexo));
                lstParametros.Add(lSQL.CrearParametro("@chrAPLICA", cIndActivo));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                if (objDALSQL.ExecQuery_OUT("PA_IDUH_APRAPLICDEPCIA", lstParametros))
                {
                    System.Collections.ArrayList arrOUT = objDALSQL.Get_aOutput();
                    this._strResp = arrOUT[0].ToString();
                }
            }
            return _strResp;
        }

        #endregion

        #region void fllena_Arreglo(DataSet dataset, string op)
        /// <summary>
        /// Procedimiento que llena una lista de apartados
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="dataset">DataSet que nos regresa los datos de la BD </param>
        /// <param name="op">Opción a ejecutar de acuerdo a la consulta que se quiere realizar</param>
        private void fllena_Arreglo(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "SELECCIONAR":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAplica objAplica = new clsAplica();

                                objAplica.idAplica = int.Parse(row["idAplica"].ToString());
                                objAplica.strDAplica = row["sDAplica"].ToString();

                                laAplica.Add(objAplica);
                                // laPeriodosEntrega = null;
                            }
                            break;

                        case "SELECCIONAR2":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAplica objAplica = new clsAplica();

                                objAplica.idAplica = int.Parse(row["idAplica"].ToString());
                                objAplica.strDAplica = row["sDAplica"].ToString();
                                objAplica.chrIndActivo = Char.Parse(row["cIndAplica"].ToString());

                                laAplica.Add(objAplica);
                                // laPeriodosEntrega = null;
                            }
                            break;

                    }
                }
                else
                    laAplica = null;
            }
            catch
            {
                laAplica = null;
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

    }
}