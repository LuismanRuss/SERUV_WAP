using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data;
using libFunciones;
using System.Globalization;

/// <summary>
/// Objetivo:                      Clase para el manejo de Guías
/// Versión:                       1.0
/// Autor:                         Daniel Ramírez Hernández
/// Fecha de Creación:             25 de Febrero 2013
/// Modificó:                      Daniel Ramírez Hernández
/// Fecha de última Mod:            
/// Tablas de la BD que utiliza:   APVGUIAER
/// </summary>
/// 
namespace nsSERUV
{
    public class clsGuia
    {
        #region Variables privadas


        ArrayList lstParametros = new ArrayList();
        clsValidacion _libFunciones;
        private int _idGuiaER;// ID en la tabla APVGUIAER
        private string _strGuiaER;//Clave de la Guía
        private string _strDGuiaER;//Descripcion de la Guía
        private string _strDCGuiaER;//Descripcion corta de la Guía
        private string _dteFAlta;  // Fecha de Alta de la Guía en el SERUV
        private string _dteFUltModif; // Fecha de última modificación de la Guía el SERUV
        private int _intUsuario;// Id no ligado del usuario que registra y modifica
        private char _chrIndActivo;//Caracter que indica si la Guía está activo ó inactivo
        private string _dteFBaja; // Fecha que indica, cuando fue dado de baja la guía
        private char _chrIndVigente;//Caracter que indica si la Guía está Vigente o no
        private string _dteFVigente; // Fecha de Vigencia de la Guía Activa
        private string _strAccion;   // Variable para controlar la acción a realizar
        private string _strRespuesta;   // Variable que controla las respuesta de los metodos del cliente al servidor
        private List<clsGuia> _laGuiasER; //Lista donde almacenaremos los datos traidos de la Base de Datos

        #endregion

        #region Constructores
        /// <summary>
        /// Constructor de la clase clsUsuario
        /// </summary>
        public clsGuia()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        #endregion

        #region GET y SETs
        public int idGuiaER { get { return _idGuiaER; } set { _idGuiaER = value; } }
        public string strGuiaER { get { return _strGuiaER; } set { _strGuiaER = value; } }
        public string strDGuiaER { get { return _strDGuiaER; } set { _strDGuiaER = value; } }
        public string strDCGuiaER { get { return _strDCGuiaER; } set { _strDCGuiaER = value; } }
        public string dteFAlta { get { return _dteFAlta; } set { _dteFAlta = value; } }
        public string dteFUltModif { get { return _dteFUltModif; } set { _dteFUltModif = value; } }
        public int intUsuario { get { return _intUsuario; } set { _intUsuario = value; } }
        public char chrIndActivo { get { return _chrIndActivo; } set { _chrIndActivo = value; } }
        public List<clsGuia> laGuiasER { get { return _laGuiasER; } set { _laGuiasER = value; } }
        public string dteFVigente { get { return _dteFVigente; } set { _dteFVigente = value; } }
        public char chrIndVigente { get { return _chrIndVigente; } set { _chrIndVigente = value; } }
        public string dteFBaja { get { return _dteFBaja; } set { _dteFBaja = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public string strRespuesta { get { return _strRespuesta; } set { _strRespuesta = value; } }

        #endregion

        #region Procedimientos de la Clase clsGuia

        #region fGetGuiasEntrega
        /// <summary>
        /// Función que consulta las Guías
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
        public bool fGetGuiasEntrega()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                //lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_GUIAS"));
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion.Trim()));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros))
                {
                    laGuiasER = new List<clsGuia>();
                    pLista_GuiasER(objDALSQL.Get_dtSet(), "GUIAS");

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

        #region pLista_GuiasER
        /// <summary>
        /// Procedimiento que nos devolverá una Lista de la Base de datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="dataset">DataSet que nos regresa los datos de la BD </param>
        /// <param name="op">Opción a ejecutar de acuerdo a la consulta que se quiere realizar</param>
        private void pLista_GuiasER(DataSet dataset, string op)
        {
            try
            {
                using (this._libFunciones = new clsValidacion())
                {
                    if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                    {
                        switch (op)
                        {
                            case "GUIAS":
                                laGuiasER.Add(null);
                                foreach (DataRow row in dataset.Tables[0].Rows)
                                {
                                    clsGuia objProcER = new clsGuia();
                                    //objProcER.idGuiaER = int.Parse(row["IDGUIAER"].ToString());
                                    objProcER.idGuiaER = row.Table.Columns.Contains("IDGUIAER") ? this._libFunciones.IsNumeric(row["IDGUIAER"].ToString()) ? int.Parse(row["IDGUIAER"].ToString()) : 0 : 0;
                                    objProcER.strGuiaER = row["CLAVE"].ToString();
                                    objProcER.strDGuiaER = row["DESCRIPCION"].ToString();
                                    objProcER.strDCGuiaER = row["OBSERVACION"].ToString();
                                    objProcER.dteFAlta = row["FALTA"].ToString();
                                    objProcER.intUsuario = int.Parse(row["USUARIO"].ToString());
                                    objProcER.chrIndActivo = Convert.ToChar(row["ESTADO"].ToString());
                                    objProcER.dteFBaja = row["FBAJA"].ToString();
                                    objProcER.dteFVigente = row.Table.Columns.Contains("FVIGENTE") ? this._libFunciones.IsDate(row["FVIGENTE"].ToString()) ? DateTime.Parse(row["FVIGENTE"].ToString()).ToString("dd-MM-yyyy") : string.Empty : string.Empty;
                                    //objProcER.dteFVigente = row["FVIGENTE"].ToString();
                                    objProcER.chrIndVigente = Convert.ToChar(row["VIGENCIA"].ToString());


                                    laGuiasER.Add(objProcER);
                                    // laPeriodosEntrega = null;
                                }
                                break;

                            case "ESTADO":

                                foreach (DataRow row in dataset.Tables[0].Rows)
                                {
                                    clsGuia objProcER = new clsGuia();
                                    objProcER.strGuiaER = row["ESTADO"].ToString();
                                    objProcER.strDGuiaER = row["DESCRIPCION"].ToString();
                                    objProcER.strDCGuiaER = row["ESTADO"].ToString();
                                    objProcER.idGuiaER = int.Parse(row["IDGUIAER"].ToString());



                                    laGuiasER.Add(objProcER);
                                    // laPeriodosEntrega = null;
                                }
                                break;

                            case "GUIA_ACTIVA":
                                foreach (DataRow row in dataset.Tables[0].Rows)
                                {
                                    clsGuia objGuiaAct = new clsGuia();
                                    objGuiaAct.idGuiaER = int.Parse(row["idGuiaER"].ToString());
                                    objGuiaAct.strGuiaER = row["sGuiaER"].ToString();
                                    objGuiaAct.strDGuiaER = row["sDGuiaER"].ToString();


                                    laGuiasER.Add(objGuiaAct);
                                    // laPeriodosEntrega = null;
                                }
                                break;
                        }
                    }
                    else
                        laGuiasER = null;
                }
            }
            catch
            {
                laGuiasER = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }//FIN_funcion Lista_Valida(DataSet dataset, string op)

        #endregion

        #region fGetGuiasActualizar
        /// <summary>
        /// Función que Insertará un nuevo Registro de Guía en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetGuiasActualizar()
        {
            int blnRespuesta = 0;
            string dteTemporal = "";

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    using (this._libFunciones = new clsValidacion())
                    {
                        libSQL lSQL = new libSQL();

                        //Modificamos el formato de la fecha de vigencia a ser enviada
                        if (!this.dteFVigente.Equals(string.Empty))
                        {
                            //DateTimeFormatInfo dtfs = new DateTimeFormatInfo();
                            //dtfs.ShortDatePattern = "MM-dd-yyyy";
                            //dtfs.DateSeparator = "-";
                            //DateTime sFeInicial = Convert.ToDateTime(this._dteFVigente, dtfs);
                            dteTemporal = this._dteFVigente;
                            this._dteFVigente = (objValidacion.IsDate(objValidacion.ConvertDatePicker(this._dteFVigente)) ? DateTime.Parse(objValidacion.ConvertDatePicker(this._dteFVigente)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                        }

                        System.Collections.ArrayList arrOUT = new ArrayList();
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                        lstParametros.Add(lSQL.CrearParametro("@intUsuario", this._intUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                        lstParametros.Add(lSQL.CrearParametro("@strGuiaER", this._strGuiaER));
                        lstParametros.Add(lSQL.CrearParametro("@strDGuiaER", this._strDGuiaER));
                        lstParametros.Add(lSQL.CrearParametro("@strDCGuiaER", this._strDCGuiaER));
                        //lstParametros.Add(lSQL.CrearParametro("@chrIndActivo", this._chrIndActivo));
                        lstParametros.Add(lSQL.CrearParametro("@chrIndVigente", this._chrIndVigente));
                        if (!this.dteFVigente.Equals(string.Empty))
                            lstParametros.Add(lSQL.CrearParametro("@dteFVigente", this._dteFVigente.ToString()));
                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                        lstParametros.Add(lSQL.CrearParametro("@idGuiaRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                        //if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros))
                        //{
                        //    blnRespuesta = true;
                        //}

                        if (objDALSQL.ExecQuery_OUT("PA_IDUH_GUIAS", lstParametros))
                        {
                            //arrOUT = objDALSQL.Get_aOutput();
                            //blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);

                            arrOUT = objDALSQL.Get_aOutput();
                            blnRespuesta = int.Parse(arrOUT[0].ToString());

                            if (blnRespuesta == 1)
                            {
                                if (this._strAccion == "FECHA_VIGENCIA2")
                                {
                                    this._idGuiaER = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);
                                    this._dteFVigente = dteTemporal;

                                }

                                if (this._strAccion == "CAMBIAR_VIGENCIA2")
                                {
                                    this._dteFVigente = dteTemporal;
                                    this._idGuiaER = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);

                                }
                            }
                        }

                    }
                }
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetGuiasActivas
        /// <summary>
        /// Función que nos devolverá True o False, si ya hay alguna Guía Activa
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si) </returns>
        public bool fGetGuiasActivas(clsGuia objDatos)
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si existe alguna guía vigente
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_GUIA_ACTIVA"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros))
                {
                    // Si la consulta nos trajo registros, entonces si hay Guía vigente
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        blnRespuesta = true; //mandamos la bandera false al cliente
                    }
                    else // si no trajo datos, es que no hay Guía Activa
                    {

                        blnRespuesta = false;  // mandamos la bandera true al cliente

                    }
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

        #region fGetGuiasVigentes
        /// <summary>
        /// Función que nos devolverá True o False, si ya hay alguna Guía Activa
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="objDatos">Objeto de Datos de la clase Guías</param>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si)</returns>
        public bool fGetGuiasVigentes(clsGuia objDatos)
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si la guía actual esta vigente
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUIA_VIGENTE"));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros))
                {
                    // Si la consulta nos trajo registros, entonces esa Guía esta Vigente
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        blnRespuesta = true; //habilitamos los dos combos
                    }
                    else // si no trajo datos, es que esa guía no esta vigente
                    {

                        //Mandamos a llamar a nuestro procedimiento Almacenado, para preguntar si hay alguna guia vigente
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUIA_VIGENTE2"));
                        objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros);

                        // Si la consulta nos trajo registros, entonces si hay alguna guia vigente
                        if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                        {
                            blnRespuesta = false; //deshabilitamos la opción de VIGENTE
                        }

                        else
                        {
                            blnRespuesta = true; //habilitamos los dos combos
                        }

                    }
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

        #region fGetGuiasdeProcesoActivas
        /// <summary>
        /// Función que nos devolverá True: Si hay algún Proceso Activo asignados a la Guía que se modificará
        /// Función que nos devolverá False: Si se modificó el estado Activo de la Guía, como sus Apartados y Anexos      
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="objDatos">Objeto de Datos de la clase Guías</param>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si) </returns>
        public int fGetGuiasdeProcesoActivas(clsGuia objDatos)
        {
            int intRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si la guía esta Vigente
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "GUIA_VIGENTE"));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros);

                // Si la consulta nos trajo un registro, entonces la guia esta vigente, no se puede modificar el estado
                if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                {
                    intRespuesta = 1; //mandamos la bandera 1 con el mensaje correspondiente
                }

                else
                {
                    //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Procesos Activos ligados a a la Guía 
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", "ESTADO_PROCESO_GUIA"));
                    lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                    objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros);

                    // Si la consulta nos trajo registros, entonces si hay Procesos ligados a a la Guía cEstatus
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0 && objDALSQL.Get_dtSet().Tables[0].Rows.Contains("cEstatus")
                        && !objDALSQL.Get_dtSet().Tables[0].Rows.Find("cEstatus").Equals(string.Empty))
                    {
                        intRespuesta = 2; //mandamos la bandera 2 con el mensaje correspondiente
                    }
                    else
                    {

                        //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Anexos asignados a participantes 
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", "VERIFICAR_ANEXOS"));
                        lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                        objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros);

                        // Si la consulta nos trajo registros, entonces si hay participantes ligados a a la Guía
                        if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                        {
                            intRespuesta = 3; //mandamos la bandera 3 con el mensaje correspondiente
                        }

                        else // si no trajo datos, es que ya se valido todo las restricciones ==> PODEMOS MODIFICAR ESTADO
                        {

                            //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si eliminar o cambiar estado
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "ESTADO_PROCESO_GUIA2"));
                            lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                            objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros);

                            // Si la consulta nos trajo registros, entonces si hay Procesos ligados a a la Guía
                            if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                            {
                                this.strAccion = "ESTADO";
                                //Mandamos a llamar a nuestro procedimiento Almacenado, para Modificar el Estado de la Guía
                                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZAR_ESTADO"));
                                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                                //lstParametros.Add(lSQL.CrearParametro("@chrIndActivo", objDatos.chrIndActivo));
                                lstParametros.Add(lSQL.CrearParametro("@intUsuario", objDatos.intUsuario));
                                objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros);
                                intRespuesta = 4;  // mandamos la bandera 4 con el mensaje correspondiente
                            }

                            else
                            {
                                this.strAccion = "ELIMINAR";
                                //Mandamos a llamar a nuestro procedimiento Almacenado, para la eliminacion de la Guía
                                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINAR"));
                                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                                objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros);
                                intRespuesta = 4;  // mandamos la bandera 4 con el mensaje correspondiente
                            }

                            //if (this.strAccion == "ESTADO")
                            //{
                            //    //Mandamos a llamar a nuestro procedimiento Almacenado, para Modificar el Estado de la Guía
                            //    lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZAR_ESTADO"));
                            //    lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                            //    lstParametros.Add(lSQL.CrearParametro("@chrIndActivo", objDatos.chrIndActivo));
                            //    lstParametros.Add(lSQL.CrearParametro("@intUsuario", objDatos.intUsuario));
                            //    objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros);
                            //    intRespuesta = 4;  // mandamos la bandera 4 con el mensaje correspondiente
                            //}
                            //else if (this.strAccion == "ELIMINAR")
                            //{
                            //    //Mandamos a llamar a nuestro procedimiento Almacenado, para la eliminacion de la Guía
                            //    lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINAR"));
                            //    lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                            //    objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros);
                            //    intRespuesta = 4;  // mandamos la bandera 4 con el mensaje correspondiente

                            //}
                        }
                    }
                }
            }

            return intRespuesta;
        }
        #endregion

        #region fGetGuiasdeProcesoActivas2
        /// <summary>
        /// Función que nos devolverá True: Si hay algún Proceso Activo asignados a la Guia que se modificará
        /// Función que nos devolverá False: Si se modifico el estado Activo de la Guia, como sus Apartados y Anexos      
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <param name="objDatos">Objeto de Datos de la clase Guías</param>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si) </returns>
        public int fGetGuiasdeProcesoActivas2(clsGuia objDatos)
        {
            int intRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();
                //lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_GUIAS"));
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "VALIDA_TODO"));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this.idGuiaER));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_SELV_GUIASER", lstParametros))
                {
                    arrOUT = objDALSQL.Get_aOutput();
                    intRespuesta = (int.Parse(arrOUT[0].ToString()));

                    switch (intRespuesta)
                    {
                        case 1:
                            // Si la consulta nos trajo un registro, entonces la guia esta vigente, no se puede inactivar
                            intRespuesta = 1; //mandamos la bandera 1 con el mensaje correspondiente
                            break;
                        case 2:
                            // Si la consulta nos trajo registros, entonces si hay Procesos ligados a a la Guía cEstatus, no se puede inactivar
                            intRespuesta = 2; //mandamos la bandera 2 con el mensaje correspondiente
                            break;
                        case 3:
                            // Si la consulta nos trajo registros, entonces si hay participantes ligados a a la Guía
                            intRespuesta = 3; //mandamos la bandera 3 con el mensaje correspondiente
                            break;
                        case 4:
                            // Si la consulta nos trajo registros, entonces si hay apartados activos a la guía
                            intRespuesta = 4; //mandamos la bandera 4 con el mensaje correspondiente
                            break;
                        case 5:
                            //Mandamos a llamar a nuestro procedimiento Almacenado, para Modificar el Estado de la Guía
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZAR_ESTADO"));
                            lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                            lstParametros.Add(lSQL.CrearParametro("@intUsuario", objDatos.intUsuario));
                            objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros);
                            intRespuesta = 5;  // mandamos la bandera 4 con el mensaje correspondiente
                            break;
                        case 6:
                            //Mandamos a llamar a nuestro procedimiento Almacenado, para la eliminacion de la Guía
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINAR"));
                            lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                            objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros);
                            intRespuesta = 6;  // mandamos la bandera 4 con el mensaje correspondiente
                            break;
                    }

                }

            }


            return intRespuesta;
        }
        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

        #region Función que obtiene la Guia Vigente
        // Autor: Edgar Morales Gonzalez
        public bool fObtener_GuiaVigente(string strACCION)
        {
            bool blnRespuesta = false;
            this.lstParametros = new System.Collections.ArrayList();

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", strACCION));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros))
                {
                    laGuiasER = new List<clsGuia>();
                    pLista_GuiasER(objDALSQL.Get_dtSet(), "GUIA_ACTIVA");
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

        #region fGetFechaVigentes
        /// <summary>
        /// Función que nos devolverá True o False, si ya hay alguna Guía Activa
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0 - No, 1 - Si)</returns>

        public int fGetFechaVigentes()
        {
            int blnRespuesta = 0;
            string dteTemporal = "";

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    using (this._libFunciones = new clsValidacion())
                    {
                        libSQL lSQL = new libSQL();

                        //Modificamos el formato de la fecha de vigencia a ser enviada
                        if (!this.dteFVigente.Equals(string.Empty))
                        {
                            //DateTimeFormatInfo dtfs = new DateTimeFormatInfo();
                            //dtfs.ShortDatePattern = "MM-dd-yyyy";
                            //dtfs.DateSeparator = "-";
                            //DateTime sFeInicial = Convert.ToDateTime(this._dteFVigente, dtfs);
                            dteTemporal = this._dteFVigente;
                            this._dteFVigente = (objValidacion.IsDate(objValidacion.ConvertDatePicker(this._dteFVigente)) ? DateTime.Parse(objValidacion.ConvertDatePicker(this._dteFVigente)).ToString("yyyyMMdd HH:mm:ss") : DateTime.Now.ToString("yyyy/MM/dd HH:mm"));
                        }

                        ////Modificamos el formato de la fecha de vigencia a ser enviada
                        //DateTimeFormatInfo dtfs = new DateTimeFormatInfo();
                        //dtfs.ShortDatePattern = "MM-dd-yyyy";
                        //dtfs.DateSeparator = "-";
                        //DateTime sFeInicial = Convert.ToDateTime(this._dteFVigente, dtfs);

                        //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si la guia actual esta vigente
                        System.Collections.ArrayList arrOUT = new ArrayList();
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                        lstParametros.Add(lSQL.CrearParametro("@intUsuario", this._intUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                        lstParametros.Add(lSQL.CrearParametro("@chrIndVigente", this._chrIndVigente));
                        if (!this.dteFVigente.Equals(string.Empty))
                            lstParametros.Add(lSQL.CrearParametro("@dteFVigente", this._dteFVigente.ToString()));
                        lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                        lstParametros.Add(lSQL.CrearParametro("@idGuiaRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                        //if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_IDUH_GUIAS", lstParametros))
                        //{
                        //    blnRespuesta = true;

                        //}

                        if (objDALSQL.ExecQuery_OUT("PA_IDUH_GUIAS", lstParametros))
                        {
                            //arrOUT = objDALSQL.Get_aOutput();
                            //blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);

                            arrOUT = objDALSQL.Get_aOutput();
                            blnRespuesta = int.Parse(arrOUT[0].ToString());

                            if (blnRespuesta == 1)
                            {
                                if (this._strAccion == "FECHA_VIGENCIA")
                                {
                                    this._idGuiaER = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);
                                    this._dteFVigente = dteTemporal;
                                }

                                if (this._strAccion == "CAMBIAR_VIGENCIA")
                                {
                                    this._dteFVigente = dteTemporal;
                                    this._idGuiaER = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);
                                }
                            }
                        }
                    }
                }

            }

            return blnRespuesta;
        }
        #endregion

        #region fGetValiaProcesosAnexos
        /// <summary>
        /// Función que Valida si hay procesos o anexos, asignados a esa guia
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un Booleano que indica si se realizo correctamente la operación (false - No, true - Si)</returns>
        public bool fGetValidaProcesosAnexos()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Procesos Activos
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ESTADO_PROCESO_CERRADO"));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros))
                {
                    // Si la consulta nos trajo registros, entonces existen procesos abiertos ligados a esa guía
                    if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)

                    {
                        blnRespuesta = false; //mandamos a la bandera false ya que no podemos eliminar
                    }
                    else // si no trajo datos, es que no hay ningun proceso activo asignado a esa guía
                    {
                        blnRespuesta = true; // mandamos true, podemos modificar la vigencia 


                        //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Anexos asignados a Participantes
                        //lstParametros.Add(lSQL.CrearParametro("@strACCION", "VERIFICAR_ANEXOS"));
                        //lstParametros.Add(lSQL.CrearParametro("@idGuiaER", objDatos.idGuiaER));
                        //objDALSQL.ExecQuery_SET("PA_SELV_GUIASER", lstParametros);

                        //// Si la consulta nos trajo registros, entonces si hay Anexos Asignados
                        //if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                        //{
                        //    blnRespuesta = false; //mandamos a la bandera false ya que no podemos eliminar
                        //}
                        //else
                        //{

                        //    blnRespuesta = true;  // mandamos true, podemos modificar la vigencia                 
                        //}

                    }
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

        #region fGetValidaGuiaER
        /// <summary>
        /// Objetivo:   Indicar si la guia se encuentra vigente al momento de crear un proceso
        /// Autor:      Edgar Morales González
        /// </summary>
        /// <returns>Booleano que devuelve si la guía se encuentra vigente o no</returns>
        public bool fGetValidaGuiaER(clsGuia objGuiaER)
        {
            bool blnRespuesta = false;
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();
                //lstParametros.Add(lSQL.CrearParametro("@strACCION", "OBTENER_GUIAS"));
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this.strAccion));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this.idGuiaER));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_SELV_GUIASER", lstParametros))
                {
                    arrOUT = objDALSQL.Get_aOutput();
                    blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);

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

        #region fGetCodigoGuia
        /// <summary>
        /// Función que nos devolverá si el código de la guía es valido para Insertar o Actualizar
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetCodigoGuia()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                System.Collections.ArrayList arrOUT = new ArrayList();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay un anexo asignado a un Participante
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "VERIFICA_CODIGO"));
                lstParametros.Add(lSQL.CrearParametro("@strGuiaER", this._strGuiaER));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                if (objDALSQL.ExecQuery_OUT("PA_SELV_GUIASER", lstParametros))
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

    }
}