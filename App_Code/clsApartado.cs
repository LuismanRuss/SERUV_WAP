using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using libFunciones;

/// <summary>
/// Objetivo:                       Clase para el manejo de usuarios
/// Versión:                        1.0
/// Autor:                         Ma. Guadalupe Dominguez Julián
/// Fecha de Creación:              22 de Febrero 2013
/// Modificó:                        Ma. Guadalupe Dominguez Julián
/// Fecha de última Mod:            22 de Febrero 2013
/// Tablas de la BD que utiliza:    APVAPARTADO
/// </summary>
/// 
namespace nsSERUV
{
    public class clsApartado
    {


        #region Variables privadas

        ArrayList lstParametros = new ArrayList();
        clsDALSQL _objDALSQL;
        libSQL _libSQL;
        clsValidacion _libFunciones;
        private int _idParticipante;    // ID del participante
        private int _idApartado;     // ID en la tabla  APVAPARTADO
        private int _idGuiaER;// ID foráneo de la tabla APVMETODOLOGIA
        private string _strDGuiaER;//Descripción de la Guía foránea
        private string _strApartado;//Clave del apartado
        private string _strDescApartado;//Descripción del apartado
        private string _strDescCortApartado;//Descripción corta del apartado
        private int _intnOrden; // Número de Orden Asignado a cada Apartado
        private string _dteFAlta;  // Fecha de Alta del Apartado en el SERUV
        private string _dteFUltModif; // Fecha de última modificación del Apartado en el SERUV
        private int _intNumUsuario;     // Id no ligado del usuario que registra y modifica
        private string _chrIndicActivo;   //Caracter que indica si el apartado está activo ó inactivo
        private string _dteFBaja; // Fecha de baja del Apartado
        private string _chrAplica;    //Caracter que indica si el apartado es para el sujeto obligado o para el Comite de Supervisión
        private string _chrIndAnxEx;    // Indica si el apartado tiene anexos excluidos
        private string _chrIndAnxInt;    // Indica si el apartado tiene anexos Integrados/Pendientes/Excluidos
        private List<clsAnexo> _lstAnexos; // listado de anexos
        private List<clsApartado> _liApartados; //listado de Apartados

        private string _strAccion;   // Variable para controlar la acción a realizar
        private string _strOpcion;   // Variable para controlar la opción a realizar

        private string _strResp;     // Respuesta de la operación

        private string _strCveAnexo;    // Clave del Anexo (Validacion de Integracion de Contraloria)
        private string _strDAnexo;      // Descripción del Anexo (Validacion de Integracion de Contraloria)

        #endregion

        #region Constructor(es)

        #region clsApartado()
        /// <summary>
        /// Contructor vacio
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        public clsApartado()
        {
            this._lstAnexos = new List<clsAnexo>();
        }
        #endregion

        #region clsApartado(int nIdParticipante, int nIdApartado, string sApartado, string sDApartado)
        /// <summary>
        /// Constructor con 3 parametros utilizado por la clase clsProcesoER en la función pSetPropiedades()
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nIdApartado">ID de apartado</param>
        /// <param name="sApartado">Clave del apartado</param>
        /// <param name="sDApartado">Descripción del apartado</param>

        public clsApartado(int nIdParticipante, int nIdApartado, string sApartado, string sDApartado)
        {
            this._idParticipante = nIdParticipante;
            this._idApartado = nIdApartado;
            this._strApartado = sApartado;
            this._strDescApartado = sDApartado;
            this._lstAnexos = new List<clsAnexo>();
        }
        #endregion

        #region clsApartado(int nIdParticipante, int nIdApartado, string sApartado, string sDApartado)
        /// <summary>
        /// Constructor con 3 parametros utilizado por la clase clsProcesoER en la función pSetPropiedades()
        /// </summary>
        /// <param name="nIdParticipante">ID del participante</param>
        /// <param name="nIdApartado">ID de apartado</param>
        /// <param name="sApartado">Clave del apartado</param>
        /// <param name="sDApartado">Descripción del apartado</param>

        public clsApartado(int nIdParticipante, int nIdApartado, string sApartado, string sDApartado, string cAplica)
        {
            this._idParticipante = nIdParticipante;
            this._idApartado = nIdApartado;
            this._strApartado = sApartado;
            this._strDescApartado = sDApartado;
            this._chrAplica = cAplica;
            this._lstAnexos = new List<clsAnexo>();
        }
        #endregion

        #region clsApartado(int nIdApartado, string sCveApartado, string sDCApartado, bool bAnexos)
        /// <summary>
        /// Constructor utilizado por la clase clsRegistro en la forma SCIREGISTRO.aspx
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="nIdApartado">ID del Apardado</param>
        /// <param name="sCveApartado">Clave del Apardado</param>
        /// <param name="sApartado">Nombre del Apardado</param>
        /// <param name="bAnexos">Se van a crear los anexos</param>
        public clsApartado(int nIdApartado, string sCveApartado, string sDCApartado, bool bAnexos)
        {
            if (bAnexos)
                this._lstAnexos = new List<clsAnexo>();
            this._idApartado = nIdApartado;
            this._strApartado = sCveApartado;
            this._strDescCortApartado = sDCApartado;

            this._dteFAlta = string.Empty;
            this._dteFUltModif = string.Empty;
        }
        #endregion

        #endregion

        #region Procedimientos de Clase

        #region pConsulta_Apartados
        /// <summary>
        /// Función consulta los apartados correspondientes a un proceso, dependencia, sujeto obligado
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="sAccion">Acción a realizar en el procedimiento almacenado </param>
        /// <param name="nDepcia">numero de dependencia</param>
        /// <param name="nProceso">identificador del proceso</param>
        /// <param name="nSujetoObligado">identificador de sujeto obligado</param>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public Boolean pConsulta_Apartados(string sAccion, int nDepcia, int nProceso, int nSujetoObligado)
        {
            // string[] blnRespuesta;
            Boolean blnRespuesta;
            using (clsDALSQL objApartados = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", sAccion));
                    lstParametros.Add(lSQL.CrearParametro("@intIdDEPCIA", nDepcia));
                    lstParametros.Add(lSQL.CrearParametro("@intIdPROCESO", nProceso));
                    lstParametros.Add(lSQL.CrearParametro("@intIdSUJETO", nSujetoObligado));
                    blnRespuesta = objApartados.ExecQuery_SET("PA_SELV_APARTADOS", lstParametros);
                    liApartados = new List<clsApartado>();

                    fllena_Arreglo(objApartados.Get_dtSet(), sAccion);
                }
                catch
                {
                    blnRespuesta = false;
                }
                finally
                {
                    lstParametros = null;
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetApartadosActualizar
        /// <summary>
        /// Función que Insertara un nuevo Registro de Apartados en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetApartadosActualizar()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                using (this._libFunciones = new clsValidacion())
                {
                    libSQL lSQL = new libSQL();

                    System.Collections.ArrayList arrOUT = new ArrayList();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                    lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                    lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                    lstParametros.Add(lSQL.CrearParametro("@strApartado", this._strApartado));
                    lstParametros.Add(lSQL.CrearParametro("@strDescApartado", this._strDescApartado));
                    lstParametros.Add(lSQL.CrearParametro("@strDescCortApartado", this._strDescCortApartado));
                    lstParametros.Add(lSQL.CrearParametro("@intnOrden", this._intnOrden));
                    lstParametros.Add(lSQL.CrearParametro("@chrIndicAplic", this._chrAplica));
                    lstParametros.Add(lSQL.CrearParametro("@intNumUsuario", this._intNumUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    lstParametros.Add(lSQL.CrearParametro("@idApartadoRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                    //if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_APARTADOS", lstParametros))
                    //{
                    //    blnRespuesta = true;
                    //}

                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_APARTADOS", lstParametros))
                    {
                        arrOUT = objDALSQL.Get_aOutput();
                        blnRespuesta = int.Parse(arrOUT[0].ToString());

                        if (blnRespuesta == 1)
                        {
                            if (this._strAccion == "ACTUALIZAR")
                            {
                                this._idApartado = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);
                            }
                        }
                    }

                }
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetListaApartados
        /// <summary>
        /// Función que Insertara un nuevo Registro de Guía en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="objDatos">Objeto de datos de la Clase de Apartados </param>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public bool pGetListaApartados(clsApartado objDatos)
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_APARTADOS", lstParametros))
                {
                    liApartados = new List<clsApartado>();
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "APARTADOS");
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

        #region fGetListaApartadosActa
        /// <summary>
        /// Función que Lista los Apartados de la Guia Vigente para el Acta que entregaran las depcias.
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="objDatos">Objeto de datos de la Clase de Apartados </param>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public bool fGetListaApartadosActa(clsApartado objDatos)
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion.Trim()));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_APARTADOS", lstParametros))
                {
                    liApartados = new List<clsApartado>();
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "APARTADOS_ACTA");
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
                                clsApartado objApartados = new clsApartado();
                                objApartados.strDescApartado = row["sDApartado"].ToString();
                                objApartados.strApartado = row["sApartado"].ToString();
                                objApartados.idApartado = int.Parse(row["idApartado"].ToString());

                                liApartados.Add(objApartados);
                                // laPeriodosEntrega = null;
                            }
                            break;

                        case "APARTADOS":
                            liApartados.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsApartado objApartados = new clsApartado();
                                objApartados.idApartado = int.Parse(row["IDAPARTADO"].ToString());
                                objApartados.idGuiaER = int.Parse(row["IDGUIA"].ToString());
                                objApartados.strDGuiaER = row["DESCGUIA"].ToString();
                                objApartados.strApartado = row["CLAVE"].ToString();
                                objApartados.strDescApartado = row["DESCRIPCION"].ToString();
                                objApartados.strDescCortApartado = row["OBSERVACIONES"].ToString();
                                objApartados.intnOrden = int.Parse(row["ORDEN"].ToString());
                                objApartados.dteFAlta = row["FALTA"].ToString();
                                objApartados.dteFUltModif = row["FUMODIFICACION"].ToString();
                                objApartados.intNumUsuario = int.Parse(row["USUARIO"].ToString());
                                objApartados.chrIndicActivo = row["ESTADO"].ToString();
                                objApartados.dteFBaja = row["FBAJA"].ToString();
                                objApartados.chrAplica = row["APLICA"].ToString();

                                liApartados.Add(objApartados);
                                // laPeriodosEntrega = null;
                            }
                            break;

                        case "APARTADOS_ACTA":
                            liApartados.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsApartado objApartados = new clsApartado();
                                objApartados.idApartado = int.Parse(row["IDAPARTADO"].ToString());
                                objApartados.strApartado = row["CLAVE"].ToString();
                                objApartados.strDescApartado = row["DESCRIPCION"].ToString();

                                liApartados.Add(objApartados);
                                // laPeriodosEntrega = null;
                            }
                            break;
                        case "APARTADO_ANEX": // Apartados con sus correspondientes anexos
                            liApartados = new List<clsApartado>();
                            //liApartados.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                List<clsAnexo> lstAnexos2 = new List<clsAnexo>();
                                clsApartado objApartado = new clsApartado();
                                objApartado.idApartado = int.Parse(row["nIdApartado"].ToString());
                                objApartado.strApartado = row["sApartado"].ToString();
                                objApartado.strDescApartado = row["sDApartado"].ToString();
                                objApartado.chrAplica = row["cAplica"].ToString();
                                objApartado.intnOrden = int.Parse(row["nOrdenAD"].ToString());
                                int intApartado = int.Parse(row["nIdApartado"].ToString());
                                foreach (DataRow row2 in dataset.Tables[1].Rows)
                                {
                                    if (intApartado == int.Parse(row2["nIdApartado"].ToString()))
                                    {
                                        clsAnexo objAnexo = new clsAnexo();
                                        objAnexo.idAnexo = int.Parse(row2["nIdAnexo"].ToString());
                                        objAnexo.strCveAnexo = row2["sAnexo"].ToString();
                                        objAnexo.strDAnexo = row2["sDAnexo"].ToString();
                                        objAnexo.charIndEntrega = row2["cIndEntrega"].ToString();
                                        lstAnexos2.Add(objAnexo);
                                    }
                                }
                                objApartado.lstAnexos = lstAnexos2;
                                liApartados.Add(objApartado);
                            }
                            break;
                    }
                }
                else
                    liApartados = null;
            }
            catch
            {
                liApartados = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region fGetApartadosInserta
        /// <summary>
        /// Función que Insertara un nuevo Registro de Apartados en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="objDatos">Objeto de datos de la Clase de Apartados </param>
        /// <returns>Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si)</returns>
        public bool fGetApartadosInserta(clsApartado objDatos)
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", "INSERTAR"));
                lstParametros.Add(lSQL.CrearParametro("@strApartado", objDatos.strApartado));
                lstParametros.Add(lSQL.CrearParametro("@strDescApartado", objDatos.strDescApartado));
                lstParametros.Add(lSQL.CrearParametro("@intnOrden", objDatos.intnOrden));
                lstParametros.Add(lSQL.CrearParametro("@chrIndicAplic", objDatos.chrAplica));
                lstParametros.Add(lSQL.CrearParametro("@strDescCortApartado", objDatos.strDescCortApartado));


                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_APARTADOS", lstParametros))
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

        #region fGetApartadosElimina
        /// <summary>
        /// Función que Eliminara un Registro de Apartados de la Base de Datos, asi como sus Anexos, de acuerdo a sus validaciones
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGetApartadosElimina()
        {
            //bool blnRespuesta = false;
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Anexos Activos en el Apartado
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "VERIFICAR_ANEXOS"));
                lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));

                if (objDALSQL.ExecQuery_SET("PA_SELV_APARTADOS", lstParametros))
                {
                    // Si la consulta nos trajo registros, entonces si hay apartados activos
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        blnRespuesta = 2; //mandamos a la bandera false ya que no podemos eliminar
                    }

                    else
                    {

                        //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Apartados Asignados a la tabla APRPARTAPLIC
                        System.Collections.ArrayList arrOUT = new ArrayList();
                        System.Collections.ArrayList arrOUT2 = new ArrayList();
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", "APRPARTAPLIC"));
                        lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                        //if (objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                        if (objDALSQL.ExecQuery_OUT("PA_SELV_APARTADOS", lstParametros))
                        {
                            arrOUT = objDALSQL.Get_aOutput();
                            blnRespuesta = int.Parse(arrOUT[0].ToString());
                            switch (blnRespuesta)
                            {

                                case 1:
                                    //El Anexo no esta asignado a ningun participantes, podemos eliminarlo fisicamente

                                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINAR"));
                                    lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_APARTADOS", lstParametros))
                                    {
                                        arrOUT2 = objDALSQL.Get_aOutput();
                                        blnRespuesta = (int.Parse(arrOUT2[0].ToString()) == 1 ? 1 : 0);
                                    }

                                    break;
                                case 2:
                                    //No se puede eliminar ya que tiene Participantes activos con ese apartado
                                    blnRespuesta = 3;
                                    break;
                                case 3:
                                    //Existe historico del Apartado, Inactivamos el Apartado
                                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "INACTIVAR"));
                                    lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                                    lstParametros.Add(lSQL.CrearParametro("@intNumUsuario", this._intNumUsuario));
                                    lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                                    if (objDALSQL.ExecQuery_OUT("PA_IDUH_APARTADOS", lstParametros))
                                    {
                                        arrOUT2 = objDALSQL.Get_aOutput();
                                        blnRespuesta = (int.Parse(arrOUT2[0].ToString()) == 1 ? 1 : 0);
                                    }
                                    break;

                            }
                        }


                    }

                }

            }

            return blnRespuesta;
        }
        #endregion

        #region void pSetNumArchivosXAnexo()
        /// <summary>
        /// Por apartado, asigna el número de archivos por anexo
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 16 Marzo 2013
        /// </summary>
        private void pSetNumArchivosXAnexo()
        {
            try
            {
                if (this._objDALSQL.Get_dtSet() != null && this._objDALSQL.Get_dtSet().Tables.Count > 0) // Se valida que se tenga una dataSet y contenga tablas en él
                {
                    using (this._libFunciones = new clsValidacion()) // objeto para validar
                    {
                        if (this._objDALSQL.Get_dtSet().Tables[0] != null) // objeto para el usuario de la capa de accesos a datos
                        {
                            DataTable dtTabla = this._objDALSQL.Get_dtSet().Tables[0];
                            if (dtTabla.Columns.Contains("nIdApartado") && dtTabla.Columns.Contains("nIdAnexo") && dtTabla.Columns.Contains("nNumArchivos")
                                ) // Se pregunta si la tabla contiene las propiedades que necesita el método
                            {
                                foreach (clsAnexo objAnexo in this._lstAnexos) // Se recorren los anexos en el apartado para "consultar" en la tabla 0 del dataSet el número de archivos que tiene cargado
                                {
                                    DataRow[] drResultado = dtTabla.Select("nIdApartado = " + this._idApartado +
                                                                            " AND nIdAnexo =" + objAnexo.idAnexo
                                                                        ); // Se hace una select a la tabla 0 con los ids del apartado y anexo y se guarda en la posición 0 de un arreglo de filas
                                    DataRow dtRow = drResultado[0];
                                    objAnexo.intNumArchivos = (this._libFunciones.IsNumeric(dtRow["nNumArchivos"].ToString()) ? int.Parse(dtRow["nNumArchivos"].ToString()) : 0); // se obtiene el número de archivos
                                }

                            }
                        }
                    }
                }
            }
            catch
            {
                foreach (clsAnexo objAnexo in this._lstAnexos)
                {
                    objAnexo.intNumArchivos = 0;
                }
            }
            finally
            {
                this._objDALSQL.Get_dtSet().Dispose();
            }
        }
        #endregion

        #region public void pGetNumArchivosXAnexo()
        /// <summary>
        /// Consulta el número de archivos por anexo y que pertenecen a un apartado
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 16 Marzo 2013
        /// </summary>
        public void pGetNumArchivosXAnexo()
        {
            if (this._lstAnexos != null && this._lstAnexos.Count > 0) // Se valida que el apartado tenga anexos
            {
                using (this._objDALSQL = new clsDALSQL(false)) // Objeto para acceder a la capa de acceso a datos
                {
                    using (this._libSQL = new libSQL()) // Objeto para acceder a la capa de acceso a datos
                    {
                        this.lstParametros = new ArrayList();
                        this.lstParametros.Add(this._libSQL.CrearParametro("@intIDAPARTADO", this._idApartado));
                        this.lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTICIPANTE", this._idParticipante));
                        this.lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion.Trim()));
                        this.lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                        if (this._objDALSQL.ExecQuery_SET("PA_SELV_REGISTRO", this.lstParametros))
                        {
                            pSetNumArchivosXAnexo(); // Procedimiento que asigna el número de archivos por anexo que pertenecen a un apartado
                        }
                    }
                }
            }
        }
        #endregion

        #region fGetCodigoApartado
        /// <summary>
        /// Función que nos devolvera si el código y el orden del Apartado es valido para Insertar o Actualizar
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGetCodigoApartado()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay un anexo asignado a un Participante
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                lstParametros.Add(lSQL.CrearParametro("@strApartado", this._strApartado));
                lstParametros.Add(lSQL.CrearParametro("@intnOrden", this._intnOrden));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_SELV_APARTADOS", lstParametros))
                {

                    // Si la consulta nos trajo registros, entonces ya existe ese codigo en la tabla de guia
                    {
                        arrOUT = objDALSQL.Get_aOutput();
                        blnRespuesta = int.Parse(arrOUT[0].ToString());
                    }

                }
                /*
                if (objDALSQL.ExecQuery_SET("PA_SELV_APARTADOS", lstParametros))
                {

                    // Si la consulta nos trajo registros, entonces ya existe ese codigo en la tabla de apartados
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        blnRespuesta = 1; //mandamos la bandera false al cliente
                    }
                    else // si no trajo datos, es que no existe el codigo en la tabla
                    {

                        blnRespuesta = 2;  // mandamos la bandera true al cliente

                    }

                }
                 */
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetVerificaActa
        /// <summary>
        /// Función que nos devolverá si el Apartado Actual tiene configurado el Anexo de Acta-ER
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>
        public int fGetVerificaActa()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                System.Collections.ArrayList arrOUT = new ArrayList();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay un anexo asignado a un Participante
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@strCveAnexo", String.Empty, SqlDbType.VarChar, 200, 0, ParameterDirection.Output));
                lstParametros.Add(lSQL.CrearParametro("@strDAnexo", String.Empty, SqlDbType.VarChar, 200, 0, ParameterDirection.Output));


                if (objDALSQL.ExecQuery_OUT("PA_SELV_APARTADOS", lstParametros))
                {

                    arrOUT = objDALSQL.Get_aOutput();
                    blnRespuesta = int.Parse(arrOUT[0].ToString());

                    if (blnRespuesta == 1)
                    {
                        this._strCveAnexo = arrOUT[1].ToString();
                        this._strDAnexo = arrOUT[2].ToString();
                    }
                    /*
                    // Si la consulta nos trajo registros, entonces tiene configurado el acta-er
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        blnRespuesta = 1; //mandamos la bandera false al cliente
                    }
                    else // si no trajo datos, es que no existe anexo configurado de acta-er
                    {

                        blnRespuesta = 2;  // mandamos la bandera true al cliente

                    }
                    */
                }
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetCargaApartado()
        /// <summary>
        /// Procedimiento que obtiene los archivos cargados de un apartado
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="nIdProceso">Id del proceso</param>
        /// <param name="idUsuario">Id del usuario</param>
        /// <returns>Dataset con la información de los archivos cargados a ese apartado</returns>
        public DataSet fGetCargaApartado(int nIdProceso, int idUsuario)
        {
            DataSet dtsApartado = new DataSet();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strOPCION", this._strOpcion));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", nIdProceso));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));  // Id del Usuario
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", this._idParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intID", this._idApartado));
                if (objDALSQL.ExecQuery_SET("PA_SELV_EXPORTARER", lstParametros))
                {
                    dtsApartado = objDALSQL.Get_dtSet();
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return dtsApartado;
        }
        #endregion

        #region fObtieneApartados
        /// <summary>
        /// Función para obtener la lista de apartados con sus correspondientes anexos.
        /// Autor: L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <returns>Un entero que indica si se ejecutó correctamente el query</returns>
        public int fObtieneApartados()
        {
            int intResp = 0;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", this._idParticipante));
                if (objDALSQL.ExecQuery_SET("PA_SELV_APARTADOS", lstParametros))
                {
                    intResp = 1;
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "APARTADO_ANEX");
                }
            }
            return intResp;
        }
        #endregion

        #region IDisposable Members
        /// <summary>
        /// Procedimiento para destruir un objeto te tipo anexo
        /// </summary>
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #endregion

        #region GET y SETs
        public int idParticipante { get { return _idParticipante; } set { _idParticipante = value; } }
        public int idApartado { get { return _idApartado; } set { _idApartado = value; } }
        public int idGuiaER { get { return _idGuiaER; } set { _idGuiaER = value; } }
        public string strDGuiaER { get { return _strDGuiaER; } set { _strDGuiaER = value; } }
        public string strApartado { get { return _strApartado; } set { _strApartado = value; } }
        public string strDescApartado { get { return _strDescApartado; } set { _strDescApartado = value; } }
        public string strDescCortApartado { get { return _strDescCortApartado; } set { _strDescCortApartado = value; } }
        public string dteFAlta { get { return _dteFAlta; } set { _dteFAlta = value; } }
        public string dteFUltModif { get { return _dteFUltModif; } set { _dteFUltModif = value; } }
        public string dteFBaja { get { return _dteFBaja; } set { _dteFBaja = value; } }
        public int intNumUsuario { get { return _intNumUsuario; } set { _intNumUsuario = value; } }
        public string chrIndicActivo { get { return _chrIndicActivo; } set { _chrIndicActivo = value; } }
        public string chrAplica { get { return _chrAplica; } set { _chrAplica = value; } }
        public string chrIndAnxEx { get { return _chrIndAnxEx; } set { _chrIndAnxEx = value; } }
        public string chrIndAnxInt { get { return _chrIndAnxInt; } set { _chrIndAnxInt = value; } } // Indica si el apartado tiene anexos Integrados/Pendientes/Excluidos
        public int intnOrden { get { return _intnOrden; } set { _intnOrden = value; } }
        public List<clsApartado> liApartados { get { return _liApartados; } set { _liApartados = value; } }
        public List<clsAnexo> lstAnexos { get { return _lstAnexos; } set { _lstAnexos = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public string strOpcion { get { return _strOpcion; } set { _strOpcion = value; } }
        public string strResp { get { return _strResp; } set { _strResp = value; } }
        public string strCveAnexo { get { return _strCveAnexo; } set { _strCveAnexo = value; } }
        public string strDAnexo { get { return _strDAnexo; } set { _strDAnexo = value; } }

        #endregion

    }
}