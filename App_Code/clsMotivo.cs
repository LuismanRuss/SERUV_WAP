using System;
using System.Collections.Generic;
using System.Web;
using nsSERUV;
using System.Collections;
using System.Data;
using libFunciones;
/// <summary>
/// Objetivo:                       Clase para el manejo de Motivos
/// Versión:                        1.0
/// Autor:                          Edgar Morales González
/// Fechas:                         11 de Abril de 2013 
/// Modifico:                       Bárbara Vargas Vera
/// Fecha:                          29 Mayo 2013; se agrego parámetros para obtener también el tipo de motivo
/// Tablas de la BD que utiliza:     APCMOTIPROC
/// </summary>

namespace nsSERUV
{
    public class clsMotivo
    {

        #region Variables privadas

        ArrayList lstParametros = new ArrayList();
        clsValidacion _libFunciones;
        private int _idMotiProc;        // Id del Motivo
        private string _strSDMotiProc;  // Descripcion del Motivo
        private char _cIndActivo;       // Indica si el Motivo esta S= Activo N= Inactivo
        private char _cTipoMot;         // Indica el tipo de motivo O=Ordinario, E=Extraordinario
        private string _strACCION;      // Variable para controlar la acción a realizar
        private int _nUsuario;          // Id ligado del usuario que registra y modifica
        private string _strResp;     // Respuesta de la operación

        System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros
        private List<clsMotivo> _laMotivoProceso; //Lista de Motivos

        //private System.Collections.ArrayList lstParametros;

        #endregion

        #region Constructores

        public clsMotivo()
        {
            // Constructor Vacio
        }

        #endregion

        #region Procedimientos de la clase

        #region fObtener_MotivoProceso
        /// <summary>
        /// Función que obtiene los Motivos para el tipo ordinario de un Proceso
        /// Autor: Bárbara Vargas Vera
        /// </summary>
        /// <param name="strACCIONMot">Acción a ejecutar de acuerdo a la consulta que se quiere realizar</param>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si)</returns>
        public bool fObtener_MotivoProceso(String strACCIONMot)
        {
            bool blnRespuesta = false;
            try
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    using (clsDALSQL objDALSQL = new clsDALSQL(false))
                    {
                        libSQL lSQL = new libSQL();
                        _lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCIONMot));
                        if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_MOTIVO", _lstParametros))
                        {
                            laMotivoProceso = new List<clsMotivo>();
                            fLista_MotivoProceso(objDALSQL.Get_dtSet());

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

        #region fLista_MotivoProceso
        /// <summary>
        /// Lista que regresa los distintos motivos para un proceso
        /// Autor: Autor: Bárbara Vargas Vera
        /// </summary>
        /// <param name="dataset">DataSet que nos regresa los datos de la BD </param>
        private void fLista_MotivoProceso(DataSet dataset)
        {
            try
            {
                using (this._libFunciones = new clsValidacion())
                {
                    if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                    {
                        laMotivoProceso.Add(null);
                        foreach (DataRow row in dataset.Tables[0].Rows)
                        {
                            clsMotivo objMotivo = new clsMotivo();
                            //objMotivo.idMotiProc = Convert.ToInt32(row["idMotiProc"].ToString());
                            objMotivo.idMotiProc = row.Table.Columns.Contains("idMotiProc") ? this._libFunciones.IsNumeric(row["idMotiProc"].ToString()) ? int.Parse(row["idMotiProc"].ToString()) : 0 : 0;
                            objMotivo.strSDMotiProc = row["sDMotiProc"].ToString();
                            objMotivo.cTipoMot = Convert.ToChar(row["cTipo"].ToString());
                            objMotivo.cIndActivo = Convert.ToChar(row["cIndActivo"].ToString());
                            laMotivoProceso.Add(objMotivo);
                        }
                    }
                    else
                    {
                        laMotivoProceso = null;
                    }

                }
            }
            catch
            {
                laMotivoProceso = null;
            }
            finally
            {
                dataset = null;
            }
        }

        #endregion

        #region fCreaMotivo
        /// <summary>
        /// Función que Insertara un nuevo Registro de Motivos en la Base de Datos
        /// Autor: Bárbara Vargas Vera
        /// </summary>
        /// <param name="objMotivo"> Objeto de datos de la Clase de Motivos </param>
        public bool fCreaMotivo(clsMotivo objMotivo)//--clsNotificacion objNotificacion)
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                _lstParametros.Add(lSQL.CrearParametro("@strACCION", objMotivo.strACCION));
                _lstParametros.Add(lSQL.CrearParametro("@strDescripcion", objMotivo.strSDMotiProc));
                _lstParametros.Add(lSQL.CrearParametro("@chrTipo", objMotivo.cTipoMot));
                _lstParametros.Add(lSQL.CrearParametro("@intNUsuario", objMotivo.nUsuario));
                _lstParametros.Add(lSQL.CrearParametro("@chrCIndactivo", objMotivo.cIndActivo));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_MOTIVOS", _lstParametros))
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

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #region fGetMotivosActualizar
        /// <summary>
        /// Función que Insertara un nuevo Registro de Motivos en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGetMotivosActualizar()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                using (this._libFunciones = new clsValidacion())
                {
                    libSQL lSQL = new libSQL();

                    System.Collections.ArrayList arrOUT = new ArrayList();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                    lstParametros.Add(lSQL.CrearParametro("@intIdmotivo", this._idMotiProc));
                    lstParametros.Add(lSQL.CrearParametro("@strDescripcion", this._strSDMotiProc));
                    lstParametros.Add(lSQL.CrearParametro("@chrTipo", this._cTipoMot));
                    lstParametros.Add(lSQL.CrearParametro("@intNUsuario", this._nUsuario));


                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));


                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_MOTIVOS", lstParametros))
                    {
                        arrOUT = objDALSQL.Get_aOutput();
                        blnRespuesta = int.Parse(arrOUT[0].ToString());

                    }

                }
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetMotivosElimina
        /// <summary>
        /// Función que Eliminara un Registro de Motivos de la Base de Datos.
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGetMotivosElimina()
        {
            //bool blnRespuesta = false;
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Apartados Asignados a la tabla APRPARTAPLIC
                System.Collections.ArrayList arrOUT = new ArrayList();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                lstParametros.Add(lSQL.CrearParametro("@intIdmotivo", this._idMotiProc));
                lstParametros.Add(lSQL.CrearParametro("@intNUsuario", this._nUsuario));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_IDUH_MOTIVOS", lstParametros))
                {
                    arrOUT = objDALSQL.Get_aOutput();
                    blnRespuesta = int.Parse(arrOUT[0].ToString());

                }


            }

            return blnRespuesta;
        }

        #endregion

        #region fGetValidaMotivo
        /// <summary>
        /// Función que nos devolvera si el Motivo es valido para Insertar o Actualizar
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGetValidaMotivo()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay un anexo asignado a un Participante
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strACCION));
                lstParametros.Add(lSQL.CrearParametro("@strDescripcion", this._strSDMotiProc));
                lstParametros.Add(lSQL.CrearParametro("@intIdmotivo", this._idMotiProc));

                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_SELU_MOTIVO", lstParametros))
                {

                    // Si la consulta nos trajo registros, entonces ya existe ese codigo en la tabla de guia
                    {
                        arrOUT = objDALSQL.Get_aOutput();
                        blnRespuesta = int.Parse(arrOUT[0].ToString());
                    }

                }

            }

            return blnRespuesta;
        }
        #endregion

        #endregion

        #region Getters y Setters
        public int idMotiProc { get { return _idMotiProc; } set { _idMotiProc = value; } }               //  Id del Motivo
        public string strSDMotiProc { get { return _strSDMotiProc; } set { _strSDMotiProc = value; } }   //  Descripcion del Motivo
        public char cIndActivo { get { return _cIndActivo; } set { _cIndActivo = value; } }              //  Indica si el Motivo esta S= Activo N= Inactivo
        public char cTipoMot { get { return _cTipoMot; } set { _cTipoMot = value; } }                  // Indica el tipo de motivo O=Ordinario, E=Extraordinario
        public int nUsuario { get { return _nUsuario; } set { _nUsuario = value; } }
        public string strACCION { get { return _strACCION; } set { _strACCION = value; } }
        public List<clsMotivo> laMotivoProceso { get { return _laMotivoProceso; } set { _laMotivoProceso = value; } }
        public string strResp { get { return _strResp; } set { _strResp = value; } }
        #endregion
    }
}