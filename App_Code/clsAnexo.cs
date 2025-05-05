using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using libFunciones;
using System.Threading;

/// <summary>
/// Objetivo:                       Clase para el manejo de Anexos 
/// Versión:                        1.0
/// Autor:                          L.I. Erik José Enríquez Carmona
/// Fecha de Creación:              22 de Febrero 2013
/// Modificó:                       Erik José Enríquez Carmona
/// Fecha de última Mod:            09 de marzo 2013
/// Tablas de la BD que utiliza:    
/// </summary>
/// 

namespace nsSERUV
{
    public class clsAnexo : IDisposable
    {

        #region Propiedades privadas del Objeto
        /// <summary>
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// 
        System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros
        clsDALSQL _objDALSQL;
        libSQL _libSQL;
        clsValidacion _libFunciones;

        ArrayList lstParametros = new ArrayList();

        private int _idAnexo;           // ID del Anexo
        private int _idApartado;        // ID fóraneo de la tabla  APVAPARTADO
        private int _idGuiaER;          // ID de la guia
        //private int _idPartAplica;
        private string _strFormato;     // Descripcion del Formato del Anexo
        private string _strInstructivo; // Descripcion del Instructivo del Anexo
        private int _intNumArchivos;    // Variable ocupada en el registro de información
        private string _strCveAnexo;    // Clave del Anexo
        private string _strDAnexo;      // Descripción del Anexo
        private string _strNOficial;    // Codigo del Formato del Anexo
        private string _strDCAnexo;     // Observaciones del Anexo
        private int _intnOrden;         // Numero de Orden Asignado del Apartado
        private string _dteFAlta;       // Fecha de Alta del Anexo en el SERUV
        private string _dteFUltModif;   // Fecha de última Modificación del Anexo en el SERUV
        private int _intNumUsuario;     // Id no ligado del usuario que registra y modifica
        private string _dteFBaja;       // Fecha de baja del Anexo
        private char _chrIndActivo;   //Caracter que indica si el Anexo está activo ó inactivo
        private char _chrAlcance;  //Caracter que Indentifica la aplicación del anexo. G=General E=Específica
        private char _chrTipo;     //Caracter que Identifica el tipo P=Público, C=Confidencial, R=Reservado
        private char _chrFuente;     //Caracter Indicador para distinguir si es F(Formato), S(Sistema) ó U (URL)
        private char _chrNotificacion;     //Caracter Indicador de Notificaciones N(No enviar Notificacion), S(Enviar Notificacion)
        private char _cIndActa;      //Identifica si el anexo esta configurado como acta entrega recepción S=SI, N=NO

        //private string _strJutificacion;
        private string _strgidFKFGuia;       //ID foráneo de la tabla DOCFORMATO - Guía
        private string _strgidFKFFormato;    //ID foráneo de la tabla DOCFORMATO - Formato

        //private List<int> _lstAplica;       //Lista donde almacenare los id del catalogo APEAPLICA

        private char _chrContraloria;     //Caracter que Identifica si aplica el anexo para contraloria
        private char _chrEAcademicas;     //Caracter que Identifica si aplica el anexo para entidades academicas
        private char _chrORectoria;       //Caracter que Identifica si aplica el anexo para oficina de la rectoria
        private char _chrSAcademica;      //Caracter que Identifica si aplica el anexo para secretaria academica
        private char _chrSFinanzas;       //Caracter que Identifica si aplica el anexo para secretaria de finanzas
        private char _chrSRectoria;       //Caracter que Identifica si aplica el anexo para secretaria de la rectoria

        private int _idAplica;       //Id de la tabla APEAPLICA
        private string _strDAplica;  //Descripción de la configuración de Aplica

        private string _chrIndEntrega;
        private string _chrIndAplica;       //Caracter que Identifica si el anexo es de Sujeto Obligado o Contraloria

        private int _idUsuario;
        private int _idUsuarioLOG;
        private int _idUsuarioO;
        private int _idPartAplic;
        private int _idParticipante;
        private int _idProceso;
        private int _idDependencia;

        private string _strTotal;
        private string _strTotalAplica;
        private string _strTotalObligat;

        private string _strAplicable;
        private string _strAccion;          // Variable para deternimar la acción sobre el objeto
        private string _strOpcion;          // Variable que identifica la opcion dentro del procedimiento almacenado

        private clsArchivo _docFormato;
        private clsArchivo _docGuia;
        private List<clsArchivo> _lstArchivosER;    // Listado de archivos de una ER asociados a un anexo

        private string _strJustificacion;
        private string _strExcluir;
        private string _strEntrega;
        private string _strResp;            // Respuesta de la operación
        private List<clsAnexo> _lstAnexo;
        private List<clsAplica> _laAplica;  // Lista donde almacenaremos los idAplica del Anexo

        #endregion

        #region Constructor(es)

        #region clsAnexo
        /// <summary>
        /// Constructor sin parámetros
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        public clsAnexo()
        {

        }
        #endregion

        #region clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion)
        /// <summary>
        /// Contructor con  parámetros
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 15 Marzo 2013
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="chrIndAnxInt">Indica si el anexo está Integrado</param>
        public clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion)
        {
            this._idAnexo = idAnexo;
            this._chrIndEntrega = sIndAnxInt;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._idPartAplic = idPartAplic;
            this._idUsuario = nIdUsuario;
            this._strJustificacion = sJustificacion;
            //this._lstArchivosER = new List<clsArchivo>(); // Se crea la lista para los archivos de la ER
        }
        #endregion

        #region clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, char cTipo)
        /// <summary>
        /// Contructor con  parámetros
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 15 Marzo 2013
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="chrIndAnxInt">Indica si el anexo está Integrado</param>
        public clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, char cTipo)
        {
            this._idAnexo = idAnexo;
            this._chrIndEntrega = sIndAnxInt;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._idPartAplic = idPartAplic;
            this._idUsuario = nIdUsuario;
            this._strJustificacion = sJustificacion;
            this._chrTipo = cTipo;
            //this._lstArchivosER = new List<clsArchivo>(); // Se crea la lista para los archivos de la ER
        }
        #endregion

        #region clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, int nNumArchivos)
        /// <summary>
        /// Contructor con  parámetros
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 15 Marzo 2013
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="chrIndAnxInt">Indica si el anexo está Integrado</param>
        public clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, int nNumArchivos)
        {
            this._idAnexo = idAnexo;
            this._chrIndEntrega = sIndAnxInt;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._idPartAplic = idPartAplic;
            this._idUsuario = nIdUsuario;
            this._strJustificacion = sJustificacion;
            this._intNumArchivos = nNumArchivos;
            //this._lstArchivosER = new List<clsArchivo>(); // Se crea la lista para los archivos de la ER
        }
        #endregion

        #region clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, int nNumArchivos, string cIndActa)
        /// <summary>
        /// Contructor con  parámetros
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 15 Marzo 2013
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="chrIndAnxInt">Indica si el anexo está Integrado</param>
        public clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, int nNumArchivos, char cIndActa)
        {
            this._idAnexo = idAnexo;
            this._chrIndEntrega = sIndAnxInt;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._idPartAplic = idPartAplic;
            this._idUsuario = nIdUsuario;
            this._strJustificacion = sJustificacion;
            this._intNumArchivos = nNumArchivos;
            this._cIndActa = cIndActa;
            //this._lstArchivosER = new List<clsArchivo>(); // Se crea la lista para los archivos de la ER
        }
        #endregion

        #region clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, int nNumArchivos, string cIndActa , char cTipo)
        /// <summary>
        /// Contructor con  parámetros
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 15 Marzo 2013
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="chrIndAnxInt">Indica si el anexo está Integrado</param>
        public clsAnexo(int idAnexo, string sIndAnxInt, string sCveAnexo, string sDAnexo, int idPartAplic, int nIdUsuario, string sJustificacion, int nNumArchivos, char cIndActa, char cTipo)
        {
            this._idAnexo = idAnexo;
            this._chrIndEntrega = sIndAnxInt;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._idPartAplic = idPartAplic;
            this._idUsuario = nIdUsuario;
            this._strJustificacion = sJustificacion;
            this._intNumArchivos = nNumArchivos;
            this._cIndActa = cIndActa;
            this._chrTipo = cTipo;
            //this._lstArchivosER = new List<clsArchivo>(); // Se crea la lista para los archivos de la ER
        }
        #endregion

        #region clsAnexo(int idAnexo, string sCveAnexo, string sDAnexo)
        /// <summary>
        /// Contructor con 3 parámetros
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="sCveAnexo">Clave del Anexo</param>
        /// <param name="sDCAnexo">Descripción del Anexo</param>
        public clsAnexo(int idAnexo, string sCveAnexo, string sDAnexo)
        {
            this._idAnexo = idAnexo;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._intNumArchivos = 0;
            this._strExcluir = string.Empty;
        }
        #endregion

        #region clsAnexo(int idAnexo, string sCveAnexo, string sDAnexo, string cIndAnxEx, string chrIndAnxInt)
        /// <summary>
        /// Contructor con 5 parámetros
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 10 Marzo 2013
        /// </summary>
        /// <param name="idAnexo">Id del Anexo</param>
        /// <param name="sCveAnexo">Clave del Anexo</param>
        /// <param name="sDCAnexo">Descripción del Anexo</param>
        /// <param name="cIndAnxEx">Indica si el anexo está excluido</param>
        /// <param name="chrIndAnxInt">Indica si el anexo está Integrado</param>
        public clsAnexo(int idAnexo, string sCveAnexo, string sDAnexo, string sIndAnxEx, string sIndAnxInt)
        {
            this._idAnexo = idAnexo;
            this._strCveAnexo = sCveAnexo;
            this._strDAnexo = sDAnexo;
            this._chrIndAplica = sIndAnxEx;
            this._chrIndEntrega = sIndAnxInt;
            this._intNumArchivos = 0;
            //this._strTotal = string.Empty;
            //this._strTotalAplica = string.Empty;
            //this._strTotalObligat = string.Empty;
            //this._strAplicable = string.Empty;
            //this._strJustificacion = string.Empty;
            //this._strExcluir = string.Empty;

            //this._lstArchivosER = new List<clsArchivo>(); // Se crea la lista para los archivos de la ER
        }
        #endregion

        #endregion

        #region Procedimientos de Clase


        #region void pSetPropiedades()
        /// <summary>
        /// Procedimiento que asigna valores a las propiedades de un Anexo necesarias 
        /// para un proceso entrega - recepción
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de Última Actualización: 10 de Marzo de 2013
        /// </summary>
        private void pSetPropiedades()
        {
            try
            {
                if (this._objDALSQL.Get_dtSet() != null && this._objDALSQL.Get_dtSet().Tables.Count > 0)
                {
                    using (this._libFunciones = new clsValidacion())
                    {
                        if (this._objDALSQL.Get_dtSet().Tables[0] != null)
                        {
                            DataRow drGeneral = this._objDALSQL.Get_dtSet().Tables[0].Rows[0];
                            this._chrFuente = (drGeneral.Table.Columns.Contains("cFuente") ? Char.Parse(drGeneral["cFuente"].ToString().Trim()) : Char.Parse(""));
                            this._strNOficial = (drGeneral.Table.Columns.Contains("sNOficial") ? drGeneral["sNOficial"].ToString() : string.Empty);

                            if (drGeneral.Table.Columns.Contains("gidFKFFormato")
                                && drGeneral.Table.Columns.Contains("sNomFormato")
                                && !drGeneral["gidFKFFormato"].ToString().Equals(string.Empty)
                                && drGeneral.Table.Columns.Contains("sFAltaFormato")
                                )
                            { // Datos del Formato
                                this._docFormato = new clsArchivo(drGeneral["gidFKFFormato"].ToString()
                                                                 , drGeneral["sNomFormato"].ToString()
                                                                 , this._libFunciones.IsDate(drGeneral["sFAltaFormato"].ToString()) ? DateTime.Parse(drGeneral["sFAltaFormato"].ToString()).ToString("dd-MM-yyyy") : string.Empty

                                                                 );
                            }
                            if (drGeneral.Table.Columns.Contains("gidFKFGuia")
                                && drGeneral.Table.Columns.Contains("sNomGuia")
                                && !drGeneral["gidFKFGuia"].ToString().Equals(string.Empty)
                                && drGeneral.Table.Columns.Contains("sFAltaGuia")
                                )
                            { // Datos de la Guía
                                this._docGuia = new clsArchivo(drGeneral["gidFKFGuia"].ToString()
                                                             , drGeneral["sNomGuia"].ToString()
                                                             , this._libFunciones.IsDate(drGeneral["sFAltaGuia"].ToString()) ? DateTime.Parse(drGeneral["sFAltaGuia"].ToString()).ToString("dd-MM-yyyy") : string.Empty
                                                             );
                            }
                        }
                        if (this._objDALSQL.Get_dtSet().Tables[1] != null)
                        {   // Datos de los archivos de la ER
                            this._lstArchivosER = new List<clsArchivo>();
                            foreach (DataRow dtRow in this._objDALSQL.Get_dtSet().Tables[1].Rows)
                            {
                                this._lstArchivosER.Add(new clsArchivo(dtRow.Table.Columns.Contains("gidFKArchivo") ? dtRow["gidFKArchivo"].ToString() : string.Empty
                                                                     , dtRow.Table.Columns.Contains("sNomArchivo") ? dtRow["sNomArchivo"].ToString() : string.Empty
                                                                     , dtRow.Table.Columns.Contains("dFAlta") ? this._libFunciones.IsDate(dtRow["dFAlta"].ToString()) ? DateTime.Parse(dtRow["dFAlta"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                     , dtRow.Table.Columns.Contains("dFCorte") ? this._libFunciones.IsDate(dtRow["dFCorte"].ToString()) ? DateTime.Parse(dtRow["dFCorte"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                     , dtRow.Table.Columns.Contains("sNomUsuario") ? dtRow["sNomUsuario"].ToString() : string.Empty
                                                                     , dtRow.Table.Columns.Contains("sObserva") ? dtRow["sObserva"].ToString().Replace('"', ' ').Replace('\'', ' ').Replace('\n', '.').Replace('\r', ' ').Replace('|', ' ') : string.Empty
                                                                     , char.Parse(dtRow.Table.Columns.Contains("cTipo") ? dtRow["cTipo"].ToString() : " ")
                                                                     , dtRow.Table.Columns.Contains("sNumAcuerdo") ? dtRow["sNumAcuerdo"].ToString() : string.Empty
                                                                     , dtRow.Table.Columns.Contains("dFAcuerdo") ? this._libFunciones.IsDate(dtRow["dFAcuerdo"].ToString()) ? DateTime.Parse(dtRow["dFAcuerdo"].ToString()).ToString("dd/MM/yyyy") : string.Empty : string.Empty
                                                                     , dtRow.Table.Columns.Contains("nTamArchivo") ? this._libFunciones.IsNumeric(dtRow["nTamArchivo"].ToString()) ? int.Parse(dtRow["nTamArchivo"].ToString()) : 0 : 0
                                                                     , dtRow.Table.Columns.Contains("nFojas") ? this._libFunciones.IsNumeric(dtRow["nFojas"].ToString()) ? int.Parse(dtRow["nFojas"].ToString()) : 0 : 0
                                                                     ));
                            }

                            if (this._lstArchivosER.Count == 0)
                            {
                                this._lstArchivosER = null;
                            }

                        }
                    }
                }
            }
            catch
            {
                this._lstArchivosER = null;
                this._docFormato = null;
                this._docGuia = null;
            }
            finally
            {
                this._objDALSQL.Get_dtSet().Dispose();
            }
        }
        #endregion

        #region pGetDatosERAnexo()
        /// <summary>
        /// Consulta y asigna propiedades de un anexo que son necesarias para el registro de información de 
        /// una entrega - recepción
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de Última actualización: 10 de Marzo de 2013
        /// </summary>
        public void pGetDatosERAnexo()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDANEXO", this._idAnexo));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTAPLICA", this._idPartAplic));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion.Trim()));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_REGISTRO", this._lstParametros))
                    {
                        pSetPropiedades(); // Se asignan propiedades 
                    }
                }
            }
        }
        #endregion

        #region pGetDatosERAnexoH()
        /// <summary>
        /// Consulta y asigna propiedades de un anexo que son necesarias para el registro de información de 
        /// una entrega - recepción
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de Última actualizacion: 10 de Marzo de 2013
        /// </summary>
        public void pGetDatosERAnexoH()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDANEXO", this._idAnexo));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTAPLICA", this._idPartAplic));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion.Trim()));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_MONITOREO", this._lstParametros))
                    {
                        pSetPropiedades(); // Se asignan propiedades
                    }
                }
            }
        }
        #endregion

        #region Boolean pConsulta_Anexos(string accion, int idapartado)
        /// <summary>
        /// Procedimiento que consulta los anexos por apartado
        /// Autor: Ma. Guadalupe Dominguez Julián 
        /// </summary>
        /// <param name="strAccion">Acción a ejecutar en el procedimiento almacenado</param>
        /// <param name="idApartado">Identificador de un apartado para la consulta de anexos</param>
        /// <param name="idusuario">Identificador del usuario</param>
        /// <param name="intIdProceso">Identificador del proceso</param>
        /// <param name="intIdDepcia">Identificador de la Dependencia</param>
        /// <returns>true si se ha ejecutado con éxito la operación del procedimiento almacenado</returns>   
        public Boolean pConsulta_Anexos(string strAccion, int idApartado, int idusuario, int intIdProceso, int intIdDepcia)
        {
            Boolean blnRespuesta;
            using (clsDALSQL objAnexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));
                    lstParametros.Add(lSQL.CrearParametro("@idAPARTADO", idApartado));
                    lstParametros.Add(lSQL.CrearParametro("@idPARTICIPANTE", idusuario));
                    lstParametros.Add(lSQL.CrearParametro("@idPROCESO", intIdProceso));
                    lstParametros.Add(lSQL.CrearParametro("@idDEPCIA", intIdDepcia));
                    blnRespuesta = objAnexo.ExecQuery_SET("PA_SELV_ANEXO", lstParametros);

                    lstAnexo = new List<clsAnexo>();
                    fllena_Arreglo(objAnexo.Get_dtSet(), strAccion, idusuario, intIdProceso, intIdDepcia);
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

        #region Boolean pConsulta_TotalAnexos(string strAccion, int idusuario, int intIdProceso, int intIdDepcia)
        /// <summary>
        /// Procedimiento que consulta el total de anexos
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="strAccion">Acción a ejecutar en el procedimiento almacenado</param>
        /// <param name="idusuario">Identificador del usuario</param>
        /// <param name="intIdProceso">Identificador del proceso</param>
        /// <param name="intIdDepcia">Identificador de la dependencia</param>
        /// <returns>regresa true si la acción fue correcta de lo contrario regresa false</returns>
        ///       
        public Boolean pConsulta_TotalAnexos(string strAccion, int idusuario, int intIdProceso, int intIdDepcia)
        {
            // string[] blnRespuesta;          

            Boolean blnRespuesta;
            using (clsDALSQL objAnexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
                try
                {
                    libSQL lSQL = new libSQL();
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));
                    lstParametros.Add(lSQL.CrearParametro("@idPARTICIPANTE", idusuario));
                    lstParametros.Add(lSQL.CrearParametro("@idPROCESO", intIdProceso));
                    lstParametros.Add(lSQL.CrearParametro("@idDEPCIA", intIdDepcia));
                    blnRespuesta = objAnexo.ExecQuery_SET("PA_SELV_ANEXO", lstParametros);

                    lstAnexo = new List<clsAnexo>();

                    fllena_Arreglo(objAnexo.Get_dtSet(), strAccion, idusuario, intIdProceso, intIdDepcia);
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

        #region pBusca_AnexoExcluido(int idanexo, int idusuario, int intIdProceso, int intIdDepcia)

        /// <summary>
        /// Procedimiento que verifica si un anexo está excluido
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="idanexo">Id del anexo a buscar</param>
        /// <param name="usuario">Identificador del usuario logueado</param>
        /// <param name="intIdProceso">Identificador del proceso</param>
        /// <param name="intIdDepcia">Identificador de la dependencia</param>
        /// <returns>si está excluido ó no</returns>   
        public string pBusca_AnexoExcluido(int idanexo, int idusuario, int intIdProceso, int intIdDepcia)
        {
            // string[] blnRespuesta; 
            string accion = "BUSCAR";
            string excluido = "";
            using (clsDALSQL objAnexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", idanexo));
                lstParametros.Add(lSQL.CrearParametro("@idUSUARIO", idusuario));
                lstParametros.Add(lSQL.CrearParametro("@intDEPENDENCIA", intIdDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                objAnexo.ExecQuery_SET("PA_SELU_JUSTIFICACION", lstParametros);

                foreach (DataRow row in objAnexo.Get_dtSet().Tables[0].Rows)
                {
                    excluido = row["cIndAplica"].ToString();
                }

                //if (objAnexo.Get_dtSet().Tables[0].Rows.Count > 0)
                //{ 
                //    blnRespuesta = 1;
                //}
                //else
                //{
                //    blnRespuesta = 0;
                //}
            }

            return excluido;
        }
        #endregion

        #region pBusca_AnexoIncluido(int idanexo, int idusuario, int intIdProceso, int intIdDepcia)

        /// <summary>
        /// Procedimiento que verifica si un anexo está incluido
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="idanexo">Id del anexo a buscar</param>
        /// <param name="usuario">Identificador del usuario logueado</param>
        /// <param name="intIdProceso">Identificador del proceso</param>
        /// <param name="intIdDepcia">Identificador de la dependencia</param>
        /// <returns>si está incluido ó no</returns>   
        public string pBusca_AnexoIncluido(int idanexo, int idusuario, int intIdProceso, int intIdDepcia)
        {
            string straccion3 = "TIPO-ENTREGA";
            string entrega = "";
            using (clsDALSQL objAnexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", straccion3));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", idanexo));
                lstParametros.Add(lSQL.CrearParametro("@idUSUARIO", idusuario));
                lstParametros.Add(lSQL.CrearParametro("@intDEPENDENCIA", intIdDepcia));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", intIdProceso));
                objAnexo.ExecQuery_SET("PA_SELU_JUSTIFICACION", lstParametros);

                foreach (DataRow row in objAnexo.Get_dtSet().Tables[0].Rows)
                {
                    entrega = row["cIndEntrega"].ToString();
                }
            }

            return entrega;
        }
        #endregion

        #region fVerifica_AnexoAlcance(int idanexo)
        /// <summary>
        /// Procedimiento que busca el alcance de un anexo
        /// Autor: Ma. Guadalupe Dominguez Julián
        /// </summary>
        /// <param name="idanexo">Id del anexo a buscar</param>       
        /// <returns>Regresa el alcance del anexo</returns>        
        public string fVerifica_AnexoAlcance(int idanexo)
        {
            // string[] blnRespuesta; 
            string accion = "ALCANCE-ANEXO";
            string alcance = "";
            using (clsDALSQL objAnexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", accion));
                // lstParametros.Add(lSQL.CrearParametro("@idPROCESO", idProceso));
                // lstParametros.Add(lSQL.CrearParametro("@idPARTICIPANTE", idUsuario));
                // lstParametros.Add(lSQL.CrearParametro("@intDEPENDENCIA", idDependencia));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", idanexo));
                objAnexo.ExecQuery_SET("PA_SELV_ANEXO", lstParametros);

                foreach (DataRow row in objAnexo.Get_dtSet().Tables[0].Rows)
                {
                    alcance = row["cIndAlcance"].ToString();
                }
            }

            return alcance;
        }
        #endregion

        #region void fllena_Arreglo(DataSet dataset, string op)
        /// <summary>    
        /// Procedimiento que llena lista de anexos
        /// Autor: Ma. Guadalupe Dominguez Julián    
        /// </summary>
        /// <param name="dataset">DataSet resultado de la consulta</param>
        /// <param name="op">Opción a ejecutar de acuerdo a la consulta que se quiere realizar</param>
        /// <param name="usuario">Identificador de Usuario logueado </param>
        /// <param name="dataset">DataSet que nos regresa los datos de la BD </param>
        /// <param name="intIdProceso">Identificador de Número de Proceso </param>
        /// <param name="intIdDepcia">Identificador del Número de la Dependencia </param>   
        public void fllena_Arreglo(DataSet dataset, string strAccion, int idusuario, int intIdProceso, int intIdDepcia)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (strAccion)
                    {
                        case "OBLIGATORIO":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAnexo objobligatorio = new clsAnexo();
                                objobligatorio.strObliga = row["obligatorio"].ToString();
                                lstAnexo.Add(objobligatorio);

                            }
                            break;

                        case "SELECCIONAR":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAnexo objAnexo = new clsAnexo();
                                objAnexo.strDAnexo = row["sDAnexo"].ToString();
                                objAnexo.idAnexo = int.Parse(row["idAnexo"].ToString());
                                objAnexo.strCveAnexo = row["sAnexo"].ToString();
                                if (pBusca_AnexoExcluido(int.Parse(row["idAnexo"].ToString()), idusuario, intIdProceso, intIdDepcia) == "N")
                                {
                                    objAnexo.strExcluir = "[Excluido]";
                                    //objAnexo.strExcluir = "<a style=\"color:#666\">"+"Excluido"+"</a>";

                                }
                                else
                                {
                                    objAnexo.strExcluir = "";
                                }
                                if (fVerifica_AnexoAlcance(int.Parse(row["idAnexo"].ToString())) == "G")
                                {
                                    objAnexo.chrAlcance = 'G';
                                    //objAnexo.strExcluir = "<a style=\"color:#666\">"+"Excluido"+"</a>";

                                }
                                else
                                {
                                    objAnexo.chrAlcance = 'E';
                                }

                                if (pBusca_AnexoIncluido(int.Parse(row["idAnexo"].ToString()), idusuario, intIdProceso, intIdDepcia) == "I")
                                {
                                    objAnexo.strEntrega = "[Integrado]";
                                    //objAnexo.strExcluir = "<a style=\"color:#666\">"+"Excluido"+"</a>";

                                }
                                else
                                {
                                    objAnexo.strEntrega = "";
                                }
                                lstAnexo.Add(objAnexo);

                            }
                            break;
                        case "APLICA":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAnexo objaplicable = new clsAnexo();
                                objaplicable.strAplica = row["aplica"].ToString();
                                //objaplicable.intTotalAplica = row["aplica"].ToString();
                                lstAnexo.Add(objaplicable);

                            }
                            break;
                        case "NOAPLICA":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAnexo objnoaplica = new clsAnexo();
                                objnoaplica.strAplicable = row["noAplica"].ToString();
                                //objnoaplica.intNaplicable = row["noAplica"].ToString();
                                lstAnexo.Add(objnoaplica);

                            }
                            break;
                        case "TOTAL":

                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAnexo objototal = new clsAnexo();
                                objototal.strTotal = row["total"].ToString();
                                lstAnexo.Add(objototal);

                            }
                            break;

                        case "ANEXOS":
                            lstAnexo.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsAnexo objAnexos = new clsAnexo();
                                objAnexos.idAnexo = int.Parse(row["nIdAnexo"].ToString());
                                objAnexos.strFormato = row["sFormato"].ToString();
                                objAnexos.strInstructivo = row["sInstructivo"].ToString();
                                objAnexos.strNOficial = row["sCodigoFormato"].ToString();
                                objAnexos.strCveAnexo = row["sCodigo"].ToString();
                                objAnexos.strDAnexo = row["sDescripcion"].ToString();
                                objAnexos.intnOrden = int.Parse(row["nOrden"].ToString());
                                objAnexos.strDCAnexo = row["sObservaciones"].ToString();
                                objAnexos.chrIndActivo = Char.Parse(row["cEstado"].ToString());
                                objAnexos.chrAlcance = Char.Parse(row["cAplicacion"].ToString());
                                objAnexos.chrFuente = Char.Parse(row["cFuente"].ToString());
                                objAnexos.chrTipo = Char.Parse(row["cTipodeInfo"].ToString());
                                objAnexos._cIndActa = Char.Parse(row["cIndActa"].ToString());

                                lstAnexo.Add(objAnexos);

                            }
                            break;
                    }
                }
                else
                    lstAnexo = null;
            }
            catch
            {
                lstAnexo = null;
                //mensaje = ex.ToString();
            }
            finally
            {
                dataset = null;
            }
        }
        #endregion

        #region pGuarda_Justifi_anexo()
        /// <summary>
        /// Procedimiento que agregar una justificación de exclusión de un anexo
        /// Autor: Ma. Guadalupe Dominguez Julián    
        /// </summary>   
        /// <returns>entero para identificar el resultado</returns>
        public int pGuarda_Justifi_anexo()
        {
            int blnRespuesta;
            string accecible = null;
            string entrega = null;
            var straccion2 = "ALCANCE-ANEXO";
            var straccion3 = "TIPO-ENTREGA";
            using (clsDALSQL objanexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", straccion2));
                lstParametros.Add(lSQL.CrearParametro("@idPROCESO", idProceso));
                lstParametros.Add(lSQL.CrearParametro("@idPARTICIPANTE", idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", idAnexo));
                objanexo.ExecQuery_SET("PA_SELV_ANEXO", lstParametros);

                foreach (DataRow row in objanexo.Get_dtSet().Tables[0].Rows)
                {
                    accecible = row["cIndAlcance"].ToString();
                }

                if (accecible != "G")
                {
                    lstParametros.Add(lSQL.CrearParametro("@strACCION", straccion3));
                    lstParametros.Add(lSQL.CrearParametro("@idANEXO", idAnexo));
                    lstParametros.Add(lSQL.CrearParametro("@idUSUARIO", idUsuario));
                    lstParametros.Add(lSQL.CrearParametro("@intDEPENDENCIA", idDependencia));
                    lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                    objanexo.ExecQuery_SET("PA_SELU_JUSTIFICACION", lstParametros);

                    foreach (DataRow row in objanexo.Get_dtSet().Tables[0].Rows)
                    {
                        entrega = row["cIndEntrega"].ToString();
                    }

                    if (entrega != "I")
                    {
                        lstParametros.Add(lSQL.CrearParametro("@idUSUARIO", idUsuario));
                        lstParametros.Add(lSQL.CrearParametro("@idUSUARIOLOG", idUsuarioLOG));
                        lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));
                        lstParametros.Add(lSQL.CrearParametro("@idANEXO", idAnexo));
                        lstParametros.Add(lSQL.CrearParametro("@intDEPENDENCIA", idDependencia));
                        lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                        lstParametros.Add(lSQL.CrearParametro("@strJUSTIF", strJustificacion));
                        if (objanexo.ExecQuery("PA_IDUH_JUSTIFICACION", lstParametros))
                        {
                            //Thread tmod = new Thread(() => pEnviarNotif_EI_Anexo(idUsuario, idApartado, idAnexo, idDependencia, idProceso, idUsuarioLOG));  //Hilo que mandará a llamar la función encargada de extraer la información para la notificación necesaria.
                            //tmod.Start();                     //Hilo que manda a llamar el método de la notificación

                            blnRespuesta = 1;
                        }
                        else
                        {
                            blnRespuesta = 2;
                        }
                    }
                    else
                    {
                        blnRespuesta = 4;
                    }
                }
                else
                {
                    blnRespuesta = 3;
                }
            }
            return blnRespuesta;
        }

        #endregion

        #region pGuarda_Incluir_anexo()
        /// <summary>
        /// Procedimiento que agregar una justificación de inclución de un anexo
        /// Autor: Ma. Guadalupe Dominguez Julián    
        /// </summary>       
        /// <returns>entero que identifica el resultado</returns>
        public int pGuarda_Incluir_anexo()
        {
            int blnRespuesta;
            using (clsDALSQL objanexo = new clsDALSQL(false))
            {
                System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();

                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@idUSUARIO", idUsuario));
                lstParametros.Add(lSQL.CrearParametro("@idUSUARIOLOG", idUsuarioLOG));
                lstParametros.Add(lSQL.CrearParametro("@strACCION", strAccion));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", idAnexo));
                lstParametros.Add(lSQL.CrearParametro("@intPROCESO", idProceso));
                lstParametros.Add(lSQL.CrearParametro("@intDEPENDENCIA", idDependencia));
                lstParametros.Add(lSQL.CrearParametro("@strJUSTIF", strJustificacion));
                if (objanexo.ExecQuery("PA_IDUH_JUSTIFICACION", lstParametros))
                {

                    //Thread tmod = new Thread(() => pEnviarNotif_EI_Anexo(idUsuario, idApartado, idAnexo, idDependencia, idProceso, idUsuarioLOG));    //Hilo que mandará a llamar la función encargada de extraer la información para la notificación necesaria.
                    //tmod.Start();       //Hilo que manda a llamar el método de la notificación
                    blnRespuesta = 1;
                }
                else
                {
                    blnRespuesta = 2;
                }

            }
            return blnRespuesta;
        }
        #endregion

        #region pEnviarNotif_EI_Anexo(int idUsuario, int idApartado, int idAnexo, int idDependencia, int idProceso,int idUsuarioLOG)

        /// <summary>
        /// Procedimiento que envía la notificación de que se ha incluido ó excluido un anexo
        /// Autor: Ma. Guadalupe Dominguez Julián    
        /// </summary>
        /// <param name="idUsuario">Identificador del usuario</param>
        /// <param name="idApartado">Identificador del Apartado al cual pertenece el anexo</param>
        /// <param name="idAnexo">Identificador del anexo excluido ó incluido</param>
        /// <param name="idDependencia">Identificador de la dependencia</param>
        /// <param name="idProceso">Identificador del proceso</param>
        public void pEnviarNotif_EI_Anexo(int idUsuario, int idApartado, int idAnexo, int idDependencia, int idProceso, int idUsuarioLOG)
        {
            this.lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", idUsuario));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@idUSUARIOLOG", idUsuarioLOG));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDAPARTADO", idApartado));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDANEXO", idAnexo));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDDEPCIA", idDependencia));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDPROCESO", idProceso));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", "EXCLU_INCLU_ANEXO"));

                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", this.lstParametros))
                    {

                        DataSet ds = this._objDALSQL.Get_dtSet();                     //  DataSet que almacenará la información necesaria para enviar la notificación correspondiente
                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);            //  string que almacenará el XML  devuelto tras la conversión de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                   //  Crea un objeto que se usará para la comunicación con la clase del WebService
                        wsNotif.SendNotif(dato, "EXCLU_INCLU_ANEXO");              //   manda a llamar la notificación, pasando como parámetro la opción de la notificación
                    }
                }
            }
        }

        #endregion

        #region fGetAnexos
        /// <summary>
        /// Función que consulta la Lista de Anexos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns> 
        public bool fGetAnexos()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion.Trim()));
                lstParametros.Add(lSQL.CrearParametro("@idAPARTADO", this._idApartado));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                {
                    lstAnexo = new List<clsAnexo>();
                    fllena_Arreglo(objDALSQL.Get_dtSet(), "ANEXOS", 0, 0, 0);

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

        #region fGetAnexosActualizar
        /// <summary>
        /// Función que Insertará un nuevo Registro de Anexos en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// Modificó: Erik José Enríquez Carmona
        /// </summary>
        /// <returns> Un booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns> 
        public bool fGetAnexosActualizar()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();

            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para uso de la capa de acceso a datos
            {
                using (this._libFunciones = new clsValidacion()) // Objeto para validaciones
                {
                    libSQL lSQL = new libSQL();
                    System.Collections.ArrayList arrOUT = new ArrayList();
                    this._lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                    this._lstParametros.Add(lSQL.CrearParametro("@idParticipante", this._idParticipante));
                    this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@idPartAplica", this._idPartAplic));
                    this._lstParametros.Add(lSQL.CrearParametro("@cIndEntrega", this._chrIndEntrega));
                    this._lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@idPartAplicRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                    if (this._objDALSQL.ExecQuery_SET_OUT("PA_IDUH_ANEXOS", this._lstParametros))
                    {
                        arrOUT = this._objDALSQL.Get_aOutput();
                        blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);
                        this._strResp = arrOUT[0].ToString(); // Respuesta de la acción
                        this._idPartAplic = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0); //Nuevo idPartAplic despues de integra o desintegrar un anexo

                        // No se borra porque es el código necesario para cuando un usuario integra o desintegra un anexo y se pretendía enviar una notificación
                        //using (clsNotifica objNotifica = new clsNotifica(strAccion))
                        //{
                        //    objNotifica.SendNotificacion(this._objDALSQL.Get_dtSet());
                        //}

                    }
                }
            }

            return blnRespuesta;
        }
        #endregion

        #region fGetAnexosActualizar2
        /// <summary>
        /// Función que Insertará un nuevo Registro de Anexos en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns> 
        public int fGetAnexosActualizar2()
        {
            int blnRespuesta = 0;
            int idAnexo = 0;
            int idAnexoTemp = 0;
            this._lstParametros = new System.Collections.ArrayList();

            using (this._objDALSQL = new clsDALSQL(true))
            {
                this._objDALSQL.Conectar();
                using (this._libFunciones = new clsValidacion())
                {
                    libSQL lSQL = new libSQL();

                    fGetAnexosVigentes();

                    System.Collections.ArrayList arrOUT = new ArrayList();
                    this._lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                    this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                    this._lstParametros.Add(lSQL.CrearParametro("@idPartAplica", this._idPartAplic));
                    this._lstParametros.Add(lSQL.CrearParametro("@strGIDFKFGuia", this._strgidFKFGuia));
                    this._lstParametros.Add(lSQL.CrearParametro("@strGIDFKFFormato", this._strgidFKFFormato));
                    this._lstParametros.Add(lSQL.CrearParametro("@strNOficial", this._strNOficial));
                    this._lstParametros.Add(lSQL.CrearParametro("@strCveAnexo", this._strCveAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@strDAnexo", this._strDAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@strDCAnexo", this._strDCAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@intnOrden", this._intnOrden));
                    this._lstParametros.Add(lSQL.CrearParametro("@chrFuente", this._chrFuente));
                    this._lstParametros.Add(lSQL.CrearParametro("@chrAlcance", this._chrAlcance));
                    this._lstParametros.Add(lSQL.CrearParametro("@chrTipo", this._chrTipo));
                    this._lstParametros.Add(lSQL.CrearParametro("@cIndActa", this._cIndActa));
                    this._lstParametros.Add(lSQL.CrearParametro("@intNumUsuario", this._intNumUsuario));
                    this._lstParametros.Add(lSQL.CrearParametro("@cIndEntrega", this._chrIndEntrega));
                    this._lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@idAnexoRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@idPartAplicRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    //this._lstParametros.Add(lSQL.CrearParametro("@sNomArchivo", String.Empty, SqlDbType.VarChar, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@sNomArchivo", String.Empty, SqlDbType.VarChar, 200, 0, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@sNomInstructivo", String.Empty, SqlDbType.VarChar, 200, 0, ParameterDirection.Output));

                    if (this._objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", this._lstParametros))
                    {
                        arrOUT = this._objDALSQL.Get_aOutput();
                        blnRespuesta = int.Parse(arrOUT[0].ToString());
                    }

                    if (blnRespuesta == 1)
                    {

                        if (this._strAccion == "INSERTAR" || this._strAccion == "ACTUALIZAR" || this._strAccion == "ACTUALIZAR_NO_VIGENTE") //INSERTARE la relacion de anexo - aplica
                        {
                            idAnexo = int.Parse(arrOUT[1].ToString()); //recupero el idAnexo para insertar la relacion anexo - aplica
                            idAnexoTemp = idAnexo;

                            //this._idAnexo = (this._libFunciones.IsNumeric(arrOUT[1].ToString()) ? int.Parse(arrOUT[1].ToString()) : 0);

                            //this._strFormato = arrOUT[3].ToString();
                            this._strFormato = (arrOUT[3].ToString() != String.Empty ? arrOUT[3].ToString() : String.Empty);
                            this._strInstructivo = (arrOUT[4].ToString() != String.Empty ? arrOUT[4].ToString() : String.Empty);

                            if (this._laAplica != null) //Pregunto si la lista de aplica no viene vacia
                            {
                                foreach (var p in this._laAplica)
                                {
                                    this._lstParametros.Add(lSQL.CrearParametro("@strACCION", "ANEXAPLICA"));
                                    this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", idAnexo));
                                    this._lstParametros.Add(lSQL.CrearParametro("@idAplica", p.idAplica));
                                    this._lstParametros.Add(lSQL.CrearParametro("@chrAplica", p.chrIndActivo));

                                    this._objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", this._lstParametros);
                                }
                            }
                        } //fin if insertar 2

                        if (this._strOpcion == "ANEXAPLICA_VIGENTE") //INSERTAR VIGENTE LOS CHECKBOX
                        {

                            this._lstParametros.Add(lSQL.CrearParametro("@strACCION", "INSERTAR_ANEXO_VIGENTE"));
                            this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", idAnexo));
                            this._objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", this._lstParametros);

                        } //fin if insertar 3

                        if (this._strAccion == "ACTUALIZAR") //ACTUALIZAR VIGENTE LOS CHECBOX
                        {

                            this._lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZAR_TODO"));
                            this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                            this._lstParametros.Add(lSQL.CrearParametro("@idAnexoNuevo", idAnexo));
                            this._objDALSQL.ExecQuery("PA_IDUH_ANEXOS", this._lstParametros);

                            this._idAnexo = idAnexoTemp; //Actualizo el Objeto de Anexo con el Nuevo id de Anexo para regresarlo al Cliente

                            if (this._chrNotificacion == 'S')
                            {

                                Thread tmod = new Thread(() => pEnviarNotifAnexo(idAnexo));     //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                                tmod.Start();       //  Hilo que manda a llamar el metodo para laAplica notificación

                            }
                        } //fin if insertar 3

                        if (this._strAccion == "ACTUALIZAR_NO_VIGENTE") //ACTUALIZAR ID ANEXO PARA GUIAS NO VIGENTES
                        {
                            this._idAnexo = idAnexoTemp; //Actualizo el Objeto de Anexo con el Nuevo id de Anexo para regresarlo al Cliente
                        }


                        this._objDALSQL.Desconectar();
                    }
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetAnexosActualizar4
        /// <summary>
        /// Función que Insertará un nuevo Registro de Anexos en la Base de Datos
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetAnexosActualizar4()
        {
            int blnRespuesta = 0;
            int idAnexo = 0;
            //int idAnexoTemp = 0;
            //int contador = 0;
            this._lstParametros = new System.Collections.ArrayList();


            //using (this._objDALSQL = new clsDALSQL(false))
            using (this._objDALSQL = new clsDALSQL(true))
            {
                this._objDALSQL.Conectar();

                using (this._libFunciones = new clsValidacion())
                {
                    libSQL lSQL = new libSQL();

                    fGetAnexosVigentes();

                    System.Collections.ArrayList arrOUT = new ArrayList();
                    this._lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                    this._lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                    this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@idApartado", this._idApartado));
                    this._lstParametros.Add(lSQL.CrearParametro("@idPartAplica", this._idPartAplic));
                    this._lstParametros.Add(lSQL.CrearParametro("@strGIDFKFGuia", this._strgidFKFGuia));
                    this._lstParametros.Add(lSQL.CrearParametro("@strGIDFKFFormato", this._strgidFKFFormato));
                    this._lstParametros.Add(lSQL.CrearParametro("@strNOficial", this._strNOficial));
                    this._lstParametros.Add(lSQL.CrearParametro("@strCveAnexo", this._strCveAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@strDAnexo", this._strDAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@strDCAnexo", this._strDCAnexo));
                    this._lstParametros.Add(lSQL.CrearParametro("@intnOrden", this._intnOrden));
                    this._lstParametros.Add(lSQL.CrearParametro("@chrFuente", this._chrFuente));
                    this._lstParametros.Add(lSQL.CrearParametro("@chrAlcance", this._chrAlcance));
                    this._lstParametros.Add(lSQL.CrearParametro("@chrTipo", this._chrTipo));
                    this._lstParametros.Add(lSQL.CrearParametro("@cIndActa", this._cIndActa));
                    this._lstParametros.Add(lSQL.CrearParametro("@intNumUsuario", this._intNumUsuario));
                    this._lstParametros.Add(lSQL.CrearParametro("@cIndEntrega", this._chrIndEntrega));
                    this._lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@idAnexoRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    this._lstParametros.Add(lSQL.CrearParametro("@idPartAplicRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                    //this._lstParametros.Add(lSQL.CrearParametro("@intContador", 0, SqlDbType.Int, ParameterDirection.Output));

                    if (this._objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", this._lstParametros))
                    {
                        arrOUT = this._objDALSQL.Get_aOutput();
                        //blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);
                        blnRespuesta = int.Parse(arrOUT[0].ToString());

                    }

                    if (this._strAccion == "INSERTAR" || this._strAccion == "ACTUALIZAR" || this._strAccion == "ACTUALIZAR_NO_VIGENTE" && blnRespuesta == 1) //INSERTARE la relacion de anexo - aplica
                    {
                        idAnexo = int.Parse(arrOUT[1].ToString()); //recupero el idAnexo para insertar la relacion anexo - aplica
                        //idAnexoTemp = idAnexo;
                        if (this._laAplica != null) //Pregunto si la lista de aplica no viene vacia
                        {
                            foreach (var p in this._laAplica)
                            {
                                this._lstParametros.Add(lSQL.CrearParametro("@strACCION", "ANEXAPLICA"));
                                this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", idAnexo));
                                this._lstParametros.Add(lSQL.CrearParametro("@idAplica", p.idAplica));
                                this._lstParametros.Add(lSQL.CrearParametro("@chrAplica", p.chrIndActivo));

                                this._objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", this._lstParametros);
                            }
                        }
                    } //fin if insertar 2

                    if (this._strOpcion == "ANEXAPLICA_VIGENTE") //INSERTAR VIGENTE LOS CHECKBOX
                    {
                        this._lstParametros.Add(lSQL.CrearParametro("@strACCION", "INSERTAR_ANEXO_VIGENTE"));
                        this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", idAnexo));
                        this._objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", this._lstParametros);

                    } //fin if insertar 3

                    if (this._strAccion == "ACTUALIZAR") //ACTUALIZAR VIGENTE LOS CHECBOX
                    {

                        this._lstParametros.Add(lSQL.CrearParametro("@strACCION", "ACTUALIZAR_TODO"));
                        this._lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                        this._lstParametros.Add(lSQL.CrearParametro("@idAnexoNuevo", idAnexo));
                        this._objDALSQL.ExecQuery_SET("PA_IDUH_ANEXOS", this._lstParametros);

                        //this._idAnexo = idAnexoTemp; //Actualizo el Objeto de Anexo con el Nuevo id de Anexo para regresarlo al Cliente
                        if (this._chrNotificacion == 'S')
                        {
                            Thread tmod = new Thread(() => pEnviarNotifAnexo(idAnexo));                 //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                            tmod.Start();

                        }
                    } //fin if insertar 3

                    //pEnviarNotifAnexo(idAnexo);

                }
                this._objDALSQL.Desconectar();
            }

            return blnRespuesta;
        }

        #endregion

        #region fGetAnexosVigentes
        /// <summary>
        /// Función que actualizará la acción(strAccion) y la opción (strOpcion), si el anexo es vigente o no vigente
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns> 
        public bool fGetAnexosVigentes()
        {
            bool blnRespuesta = false;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ANEXO_GUIA_VIGENTE"));
                lstParametros.Add(lSQL.CrearParametro("@idAPARTADO", this._idApartado));

                if (blnRespuesta = this._objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                {
                    // Si la consulta nos trajo registros, entonces existen ese anexo pertenece a la Guia vigente
                    if (this._objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    {
                        switch (this._strAccion)
                        {
                            case "INSERTAR":
                                this._strAccion = "INSERTAR";
                                this._strOpcion = "ANEXAPLICA_VIGENTE";
                                break;
                            case "ACTUALIZAR":
                                this._strAccion = "ACTUALIZAR";
                                break;
                        }


                    }
                    else // si no trajo datos, es que ese anexo no es de la guia vigente
                    {
                        switch (this._strAccion)
                        {
                            case "INSERTAR":
                                this._strAccion = "INSERTAR";
                                this._strOpcion = "ANEXAPLICA_NO_VIGENTE";
                                break;
                            case "ACTUALIZAR":
                                this._strAccion = "ACTUALIZAR_NO_VIGENTE";
                                break;
                        }

                    }
                }
                else
                {

                }

            }

            return blnRespuesta;
        }
        #endregion

        #region fGetAnexosElimina
        /// <summary>
        /// Función que Eliminará un Registro de Anexos de la Base de Datos, asi como sus Relaciones de: APRAPARANEX, APRANEXAPLIC
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetAnexosElimina()
        {
            //bool blnRespuesta = false;
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay Anexos Asignados a la tabla APRPARTAPLIC
                System.Collections.ArrayList arrOUT = new ArrayList();
                System.Collections.ArrayList arrOUT2 = new ArrayList();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "APRPARTAPLIC"));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", this._idAnexo));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                //if (objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                if (objDALSQL.ExecQuery_OUT("PA_SELV_ANEXO", lstParametros))
                {
                    // Si la consulta nos trajo registros, entonces ese anexo ya esta asignado a participantes de un proceso
                    //if (objDALSQL.Get_dtSet().Tables[0].Rows.Count > 0)
                    //{
                    //    blnRespuesta = 2; //mandamos a la bandera false ya que no podemos eliminar
                    //}
                    arrOUT = objDALSQL.Get_aOutput();
                    blnRespuesta = int.Parse(arrOUT[0].ToString());
                    switch (blnRespuesta)
                    {

                        case 1:
                            //El Anexo no esta asignado a ningun participantes, podemos eliminarlo fisicamente

                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "ELIMINAR"));
                            lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                            lstParametros.Add(lSQL.CrearParametro("@intNumUsuario", this._intNumUsuario));
                            lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                            if (objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", lstParametros))
                            {
                                arrOUT2 = objDALSQL.Get_aOutput();
                                blnRespuesta = (int.Parse(arrOUT2[0].ToString()) == 1 ? 1 : 0);
                            }
                            break;
                        case 2:
                            //No se puede eliminar ya que tiene Anexos asignados a Participantes
                            blnRespuesta = 2;
                            break;
                        case 3:
                            //Existe historico del anexo, Inactivamos el Anexo
                            lstParametros.Add(lSQL.CrearParametro("@strACCION", "INACTIVAR"));
                            lstParametros.Add(lSQL.CrearParametro("@idAnexo", this._idAnexo));
                            lstParametros.Add(lSQL.CrearParametro("@intNumUsuario", this._intNumUsuario));
                            lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                            if (objDALSQL.ExecQuery_OUT("PA_IDUH_ANEXOS", lstParametros))
                            {
                                arrOUT2 = objDALSQL.Get_aOutput();
                                blnRespuesta = (int.Parse(arrOUT2[0].ToString()) == 1 ? 1 : 0);
                            }
                            break;

                    }

                }

            }

            return blnRespuesta;
        }
        #endregion

        #region fGetCargaAnexo()
        /// <summary>
        /// Función que obtiene los archivos cargados de un anexo
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <param name="idUsuario">Id del usuario</param>
        /// <returns>Un dataset con la información de los archivos cargados en ese anexo</returns>
        public DataSet fGetCargaAnexo(int idUsuario)
        {
            DataSet dtsAnexos = new DataSet();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strOPCION", this._strOpcion));
                lstParametros.Add(lSQL.CrearParametro("@intIDPROCESO", this._idProceso));
                lstParametros.Add(lSQL.CrearParametro("@intIDUSUARIO", idUsuario));  // Id del Usuario
                lstParametros.Add(lSQL.CrearParametro("@intIDPARTICIPANTE", this._idParticipante));
                lstParametros.Add(lSQL.CrearParametro("@intID", this._idAnexo));
                if (objDALSQL.ExecQuery_SET("PA_SELV_EXPORTARER", lstParametros))
                {
                    dtsAnexos = objDALSQL.Get_dtSet();
                    //laRegresaDatos = new List<clsUsuario>();
                    //pLlenarLista(objDALSQL.Get_dtSet(), "USUARIOS");
                }
                else
                {
                    // obtener error
                    //objDALSQL.Get_sError;
                }
            }
            return dtsAnexos;
        }
        #endregion

        #region void public void pEnviarNotifAnexo(int idAnexoNuevo)
        /// <summary>
        /// Envía una proceso ER de un participante para su revisión
        /// </summary>
        public void pEnviarNotifAnexo(int idAnexoNuevo)
        {
            this.lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false))
            {
                using (this._libSQL = new libSQL())
                {
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDANEXO", this._idAnexo));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@intIDANEXONUEVO", idAnexoNuevo));
                    this.lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", "ANEXO"));
                    if (this._objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACIONES", this.lstParametros))
                    {
                        DataSet ds = this._objDALSQL.Get_dtSet();                         //  DataSet que almacenara la informacion necesaria para enviar la notificación correspondiente
                        string dato = clsJsonMethods.ConvertDataSetToXML(ds);               //  string que almacenara el XML  devuelto tras la conversion de un DataSet a un XML

                        clsWSNotif wsNotif = new clsWSNotif();                            //  Crea un objeto que se usara para la comunicación con la clase del WebService
                        wsNotif.SendNotif(dato, "ANEXO");                                   //  Hilo que mandara a llamar la función encargada de extraer la información para la notificación necesaria.
                    }
                }
            }
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

        #region fGetCodigoAnexo
        /// <summary>
        /// Función que nos devolverá si el código y el orden del Apartado es válido para Insertar o Actualizar
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetCodigoAnexo()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();

                System.Collections.ArrayList arrOUT = new ArrayList();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar si hay un anexo asignado a un Participante
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                lstParametros.Add(lSQL.CrearParametro("@strCveAnexo", this._strCveAnexo));
                lstParametros.Add(lSQL.CrearParametro("@intnOrden", this._intnOrden));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                lstParametros.Add(lSQL.CrearParametro("@idAPARTADO", this._idApartado));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));


                if (objDALSQL.ExecQuery_OUT("PA_SELV_ANEXO", lstParametros))
                {

                    // Si la consulta nos trajo registros, entonces ya existe ese codigo en la tabla de guia
                    {
                        arrOUT = objDALSQL.Get_aOutput();
                        blnRespuesta = int.Parse(arrOUT[0].ToString());
                    }

                }


                /*
                if (objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                {

                    // Si la consulta nos trajo registros, entonces ya existe ese codigo en la tabla de anexos
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
        /// Función que nos devolverá si el acta de entrega recepción ya esta asignado a un apartado y si esta asigando al anexo actual
        /// Autor: Daniel Ramírez Hernández
        /// </summary>
        /// <returns> Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
        public int fGetVerificaActa()
        {
            int blnRespuesta = 0;

            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                //Mandamos a llamar a nuestro procedimiento Almacenado, para verificar el acta de entrega
                System.Collections.ArrayList arrOUT = new ArrayList();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", this._strAccion));
                lstParametros.Add(lSQL.CrearParametro("@idGuiaER", this._idGuiaER));
                lstParametros.Add(lSQL.CrearParametro("@idANEXO", this._idAnexo));
                lstParametros.Add(lSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));
                //if (objDALSQL.ExecQuery_SET("PA_SELV_ANEXO", lstParametros))
                if (objDALSQL.ExecQuery_OUT("PA_SELV_ANEXO", lstParametros))
                {

                    arrOUT = objDALSQL.Get_aOutput();
                    blnRespuesta = int.Parse(arrOUT[0].ToString());
                }
            }

            return blnRespuesta;
        }
        #endregion

        #endregion

        #region GETs y SETs
        public int idAnexo { get { return _idAnexo; } set { _idAnexo = value; } }
        public int idApartado { get { return _idApartado; } set { _idApartado = value; } }
        public int idGuiaER { get { return _idGuiaER; } set { _idGuiaER = value; } }
        public string strCveAnexo { get { return _strCveAnexo; } set { _strCveAnexo = value; } }
        public string strDAnexo { get { return _strDAnexo; } set { _strDAnexo = value; } }
        public string strNOficial { get { return _strNOficial; } set { _strNOficial = value; } }
        public string strDCAnexo { get { return _strDCAnexo; } set { _strDCAnexo = value; } }
        public int intnOrden { get { return _intnOrden; } set { _intnOrden = value; } }
        public string dteFAlta { get { return _dteFAlta; } set { _dteFAlta = value; } }
        public string dteFUltModif { get { return _dteFUltModif; } set { _dteFUltModif = value; } }
        public int intNumUsuario { get { return _intNumUsuario; } set { _intNumUsuario = value; } }
        public string dteFBaja { get { return _dteFBaja; } set { _dteFBaja = value; } }
        public char chrIndActivo { get { return _chrIndActivo; } set { _chrIndActivo = value; } }
        public char chrAlcance { get { return _chrAlcance; } set { _chrAlcance = value; } }
        public char chrTipo { get { return _chrTipo; } set { _chrTipo = value; } }
        public char chrFuente { get { return _chrFuente; } set { _chrFuente = value; } }
        public char chrNotificacion { get { return _chrNotificacion; } set { _chrNotificacion = value; } }
        public char cIndActa { get { return _cIndActa; } set { _cIndActa = value; } }
        public string strFormato { get { return _strFormato; } set { _strFormato = value; } }
        public string strInstructivo { get { return _strInstructivo; } set { _strInstructivo = value; } }
        public int intNumArchivos { get { return _intNumArchivos; } set { _intNumArchivos = value; } }
        public int idAplica { get { return _idAplica; } set { _idAplica = value; } }
        public string strDAplica { get { return _strDAplica; } set { _strDAplica = value; } }

        public char chrContraloria { get { return _chrContraloria; } set { _chrContraloria = value; } }
        public char chrEAcademicas { get { return _chrEAcademicas; } set { _chrEAcademicas = value; } }
        public char chrORectoria { get { return _chrORectoria; } set { _chrORectoria = value; } }
        public char chrSAcademica { get { return _chrSAcademica; } set { _chrSAcademica = value; } }
        public char chrSFinanzas { get { return _chrSFinanzas; } set { _chrSFinanzas = value; } }
        public char chrSRectoria { get { return _chrSRectoria; } set { _chrSRectoria = value; } }

        public string strgidFKFGuia { get { return _strgidFKFGuia; } set { _strgidFKFGuia = value; } }
        public string strgidFKFFormato { get { return _strgidFKFFormato; } set { _strgidFKFFormato = value; } }

        public string charIndEntrega { get { return _chrIndEntrega; } set { _chrIndEntrega = value; } }


        public int idUsuario { get { return _idUsuario; } set { _idUsuario = value; } }
        public int idUsuarioLOG { get { return _idUsuarioLOG; } set { _idUsuarioLOG = value; } }
        public int idUsuarioO { get { return _idUsuarioO; } set { _idUsuarioO = value; } }
        public int idPartAplic { get { return _idPartAplic; } set { _idPartAplic = value; } }
        public int idParticipante { get { return _idParticipante; } set { _idParticipante = value; } }
        public int idProceso { get { return _idProceso; } set { _idProceso = value; } }
        public int idDependencia { get { return _idDependencia; } set { _idDependencia = value; } }

        public string strAplicable { get { return _strAplicable; } set { _strAplicable = value; } }
        public string strExcluir { get { return _strExcluir; } set { _strExcluir = value; } }
        public string strEntrega { get { return _strEntrega; } set { _strEntrega = value; } }

        public string strTotal { get { return _strTotal; } set { _strTotal = value; } }
        public string strJustificacion { get { return _strJustificacion; } set { _strJustificacion = value; } }

        public clsArchivo docFormato { get { return _docFormato; } set { _docFormato = value; } }
        public clsArchivo docGuia { get { return _docGuia; } set { _docGuia = value; } }

        public List<clsAnexo> lstAnexo { get { return _lstAnexo; } set { _lstAnexo = value; } }
        public List<clsAplica> laAplica { get { return _laAplica; } set { _laAplica = value; } }
        public List<clsArchivo> lstArchivos { get { return _lstArchivosER; } set { _lstArchivosER = value; } }

        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }
        public string strOpcion { get { return _strOpcion; } set { _strOpcion = value; } }

        public string strObliga { get { return _strTotalObligat; } set { _strTotalObligat = value; } }
        public string strAplica { get { return _strTotalAplica; } set { _strTotalAplica = value; } }
        public string strResp { get { return _strResp; } set { _strResp = value; } }
        #endregion
    }
}