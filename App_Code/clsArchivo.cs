using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using libFunciones;
//using itextsharp;

/// <summary>
/// Objetivo:                       Clase para el manejo de Archivos
/// Versión:                        1.0
/// Autor:                          L.I. Erik José Enríquez Carmona
/// Fecha de Creación:              22 de Febrero 2013
/// Modificó:                       L.I. Erik José Enríquez Carmona
/// Fecha de última Mod:            22 de Febrero 2013
/// Tablas de la BD que utiliza:    DOCARCHIVO, DOCFORMATO
/// </summary>
///  
namespace nsSERUV
{
    public class clsArchivo : IDisposable
    {
        #region Propiedades privadas del Objeto
        //private int OleHeaderLength;
        private System.Collections.ArrayList _lstParametros = new System.Collections.ArrayList(); // lista de parametros
        private clsDALSQL _objDALSQL;
        private libSQL _libSQL;
        private clsValidacion _libFunciones;

        private string _gidFormato;       // GUID del Archivo
        private string _strNomArchivo;  // Nombre del Archivo
        private string _strMimeType;    // MIME type del Archivo
        private int _nTamanio;     // Tamaño del archivo expresado en bytes/bits
        private int _nFojas;
        private string _strTipo;        // Tipo de Documento (F=Formato, G=Guía)
        private byte[] _bytDatos1;      // Arreglo de bytes donde se guarda el contenido del archivo
        private byte[] _bytDatos2;      // Arreglo de bytes donde se guardará la cadena de comprobación del archivo
        private string _dteFAlta;       // Fecha de alta del Archivo
        private string _dteFCorte;       // Fecha de corte del archivo
        private char _chrIndActivo;     // Indicador de registro activo (S=Activo, N=Inactivo)
        private string _strObserva;      // Observaciones asociadas al archivo
        private int _idUsuario;      // ID del usuario que cargo el archivo
        private int _idUsuarioO;     // ID del usuario que cargo el archivo
        private int _idPartAplic;    // Dato necesario para cargar el archivo ER
        private char _chrTipo;     // Indicador de Tipo de Documento (F=Formato, G=Guía)
        private char _chrTipoInfo;
        private string _strAcuerdo;
        private string _dteFAcuerdo;
        private string _strNomUsuario;  // Nombre del usuario que cargo el archivo
        private string _strMensaje;
        private string _strAccion;       // Variable de acción del objeto
        private string _strOpcion;       // Variable de opción del objeto
        private string _strResp;         // Variable donde se regresa el resultado de la acción
        #endregion

        #region Contructor(es)

        #region clsArchivo()
        /// <summary>
        /// Constructor vacios
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de Ultima Actualizacion: 10 de Marzo de 2013
        /// </summary>
        public clsArchivo()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        #endregion

        #region clsArchivo(string sGidFormato, string sNomArchivo, string dFechaAlta)
        /// <summary>
        /// Constructor con 3 parametros
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de última modificación: 12 Marzo 2013
        /// </summary>
        /// <param name="sGidFormato">GUID del archivo</param>
        /// <param name="sNomArchivo">Nombre del archivo</param>
        /// <param name="dFechaAlta">Fecha de alta del archivo</param>
        public clsArchivo(string sGidFormato, string sNomArchivo, string dFechaAlta)
        {
            this._gidFormato = sGidFormato;
            this._strNomArchivo = sNomArchivo;
            this._dteFAlta = dFechaAlta;
        }
        #endregion

        #region (string sGidFormato, string sNomArchivo, string dFechaAlta, string dFechaCorte, string sNomUsuarioC, string sObservaciones)
        /// <summary>
        /// Constructor con 6 parametros
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de última modificación: 12 Marzo 2013
        /// </summary>
        /// <param name="sGidFormato">GUID del archivo</param>
        /// <param name="sNomArchivo">Nombre del archivo</param>
        /// <param name="dFechaAlta">Fecha de alta del archivo</param>
        /// <param name="dFechaCorte">Fecha de corte del archivo</param>
        /// <param name="sNomUsuarioC">Nombre del usuario que carga el archivo</param>
        /// <param name="sObservaciones">Observaciones asociadas al archivo</param>
        public clsArchivo(string sGidFormato, string sNomArchivo, string dFechaAlta, string dFechaCorte, string sNomUsuarioC, string sObservaciones)
        {
            this._gidFormato = sGidFormato;
            this._strNomArchivo = sNomArchivo;
            this._dteFAlta = dFechaAlta;
            this._dteFCorte = dFechaCorte;
            this._strNomUsuario = sNomUsuarioC;
            this._strObserva = sObservaciones;
        }
        #endregion

        #region public clsArchivo(string sGidFormato, string sNomArchivo, string dFechaAlta, string dFechaCorte, string sNomUsuarioC, string sObservaciones, char cTipo, string sNumAcuerdo, string dFAcuerdo, int nTamaño)
        /// <summary>
        /// Constructor con 6 parametros
        /// Autor: Erik Jose Enriquez Carmona
        /// Fecha de última modificación: 12 Marzo 2013
        /// </summary>
        /// <param name="sGidFormato">GUID del archivo</param>
        /// <param name="sNomArchivo">Nombre del archivo</param>
        /// <param name="dFechaAlta">Fecha de alta del archivo</param>
        /// <param name="dFechaCorte">Fecha de corte del archivo</param>
        /// <param name="sNomUsuarioC">Nombre del usuario que carga el archivo</param>
        /// <param name="sObservaciones">Observaciones asociadas al archivo</param>
        public clsArchivo(string sGidFormato, string sNomArchivo, string dFechaAlta, string dFechaCorte, string sNomUsuarioC, string sObservaciones, char cTipo, string sNumAcuerdo, string dFAcuerdo, int nTamaño, int nFojas)
        {
            this._gidFormato = sGidFormato;
            this._strNomArchivo = sNomArchivo;
            this._dteFAlta = dFechaAlta;
            this._dteFCorte = dFechaCorte;
            this._strNomUsuario = sNomUsuarioC;
            this._strObserva = sObservaciones;
            this._chrTipoInfo = cTipo;
            this._strAcuerdo = sNumAcuerdo;
            this._dteFAcuerdo = dFAcuerdo;
            this._nTamanio = nTamaño;
            this._nFojas = nFojas;
        }
        #endregion

        #endregion

        #region Procedimientos de Clase

        #region void pSetPropiedadesDWU()
        /// <summary>
        /// Procedimiento privado donde se asignan las propiedades necesarias para descargar un archivo
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de Última Actualización: 11 Marzo 2013
        /// </summary>
        private void pSetPropiedadesDWU()
        {
            try
            {
                if (this._objDALSQL.Get_dtSet() != null && this._objDALSQL.Get_dtSet().Tables.Count > 0) // Se valida que el dataSet no sea nulo y que se haya seleccionado algo
                {
                    using (this._libFunciones = new clsValidacion()) // Objeto de validación
                    {
                        if (this._objDALSQL.Get_dtSet().Tables[0] != null) // Se valida que la tabla 0 contenga datos
                        {
                            DataRow drDatos = this._objDALSQL.Get_dtSet().Tables[0].Rows[0];
                            if (drDatos.Table.Columns.Contains("sNomArchivo")
                                && drDatos.Table.Columns.Contains("sMimeType")
                                && drDatos.Table.Columns.Contains("bDatos")
                                ) // Se validan las propiedades necesarias para el procedimiento
                            {
                                this._strNomArchivo = drDatos["sNomArchivo"].ToString();
                                this._strMimeType = drDatos["sMimeType"].ToString();
                                this._strNomUsuario = drDatos["sNomUsuario"].ToString();
                                this._bytDatos1 = (byte[])drDatos["bDatos"];
                            }
                        }
                    }
                }
            }
            catch
            {
                this._bytDatos1 = null;
            }
            finally
            {
                this._objDALSQL.Get_dtSet().Dispose();
            }
        }
        #endregion

        #region bool pGetArchivoBDDWU()
        /// <summary>
        /// Procedimiento que lee los datos de una BD para descargar un archivo
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de Última Actualización: 11 Marzo 2013
        /// </summary>
        /// <returns></returns>
        public void pGetArchivoBDDWU()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para utilizar la capa de acceso a datos
            {
                using (this._libSQL = new libSQL())// Objeto para utilizar la capa de acceso a datos
                {
                    this._lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._idUsuario));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strGUID", this._gidFormato));
                    this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion));

                    if (this._objDALSQL.ExecQuery_SET("PA_SELU_ARCHIVOBD", this._lstParametros))
                    {
                        pSetPropiedadesDWU(); // Procedimiento que asigna las propiedades necesarias para poder descargar un archivo
                    }
                }
            }
        }
        #endregion

        #region public bool pValidaArchivo(FileUpload fuArchivo, string[] ext)
        /// <summary>
        /// Procedimiento que valida el archivo a subir
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="fuArchivo">Control FileUpload</param>
        /// <param name="ext">Arreglo con extensiones permitidas</param>
        /// <returns></returns>
        public bool pValidaArchivo(FileUpload fuArchivo, string[] ext)
        {
            bool blnRespuesta = false;

            if (fuArchivo.HasFile) // Se valida que el objeto fuArchivo tenga un archivo
            {

                this._strNomArchivo = Path.GetFileName(fuArchivo.PostedFile.FileName);
                string strExt = Path.GetExtension(this._strNomArchivo);
                strExt = strExt.Replace(".", "");

                if (this._strNomArchivo.Equals(string.Empty)) // Se valida que el nombre del archivo no este vacio
                {
                    this._strMensaje = "Seleccione un archivo";
                    return false;
                }

                if (fuArchivo.PostedFile.ContentLength > ((int.Parse(System.Configuration.ConfigurationManager.AppSettings["TArchivoER"]) * 1024) * 1024))
                { // Se valida qué el peso del archivo no sobrepase en megas al definido en el appSettings en la variable TArchivoER
                    this._strMensaje = "No se permite archivos con peso mayor a " + System.Configuration.ConfigurationManager.AppSettings["TArchivoER"] + " MBytes";
                    return false;

                }

                // Se valida que solo se puedan subir archivos con extensión definida en la variable ExtER o ExtAN, dependiendo si se pretende subir un formato/guía o un archivo de ER
                for (int j = 0; j < ext.Length; j++)
                {
                    if (strExt.ToLower().Trim() == ext[j].ToLower().Trim())
                    {
                        blnRespuesta |= true;
                        break;
                    }
                }

                if (!blnRespuesta)
                {
                    this._strMensaje = "Extensión incorrecta, solo se permiten archivos con las extensiones " + String.Join(", ", ext).ToLower();
                    return false;
                }
                else
                {
                    return true;
                }
                // fin de validación extensiones 
            }
            else
            {
                this._strMensaje = "Seleccione un archivo";
                return false;
            }
        }
        #endregion

        #region public void pUpdateFileBD()
        /// <summary>
        /// Procedimiento que actualiza el detalle de una archivo en una ER
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        public void pUpdateFileBD()
        {
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para utilizar la capa de acceso a datos
            {
                using (this._libSQL = new libSQL()) // Objeto para utilizar la capa de acceso a datos
                {
                    using (this._libFunciones = new clsValidacion()) // Objeto para utilizar la capa de acceso a datos
                    {
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTAPLIC", this._idPartAplic));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@dteFCORTE", this._dteFCorte));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strOBSERVA", this._strObserva));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strNACUERDO", this._strAcuerdo));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strGUID", this._gidFormato));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@chrCTIPO", this._chrTipoInfo));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@dteFACUERDO", (this._dteFAcuerdo.Trim().Equals(string.Empty) ? null : this._dteFAcuerdo)));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                        if (this._objDALSQL.ExecQuery_OUT("PA_IDUH_ARCHIVOBD", this._lstParametros))
                        {
                            System.Collections.ArrayList arrOUT = this._objDALSQL.Get_aOutput();
                            this._strResp = arrOUT[0].ToString();
                        }
                    }
                }
            }
        }
        #endregion

        #region bool pSaveFileBD()
        /// <summary>
        /// Procedimiento público que guarda/deshabilita un archivo en la BD, es ocupado para subir formato/guía y archivos de una ER
        /// Autor: Erik José Enríquez Carmona
        /// Fecha de última actualización: 12 Marzo 2013
        /// </summary>
        /// <returns>True si la operación es satisfactoría, False si fallo la operación</returns>
        public bool pSaveFileBD()
        {
            bool blnRespuesta = false;
            this._lstParametros = new System.Collections.ArrayList();
            using (this._objDALSQL = new clsDALSQL(false)) // Objeto para utilizar la capa de acceso a datos
            {
                using (this._libSQL = new libSQL()) // Objeto para utilizar la capa de acceso a datos
                {
                    using (this._libFunciones = new clsValidacion()) // Objeto para utilizar la capa de acceso a datos
                    {
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strGUID", this._gidFormato));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strNOMARCHIVO", this._strNomArchivo));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strMIMETYPE", this._strMimeType));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intTAMANIO", this._nTamanio));

                        if (!this._strAccion.Equals("DISABLE")) // Cuando se va a deshabilitar/eliminar el archivo no se envía el arreglo de bytes 
                            this._lstParametros.Add(this._libSQL.CrearParametro("@bytDATOS", this._bytDatos1, SqlDbType.VarBinary, this._bytDatos1.Length));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strACCION", this._strAccion));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strOPCION", this._strOpcion));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIO", this._idUsuario));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intIDUSUARIOOB", this._idUsuarioO));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intIDPARTAPLIC", this._idPartAplic));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@dteFCORTE", this._dteFCorte));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strOBSERVA", this._strObserva));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@chrCTIPO", this._chrTipo));

                        this._lstParametros.Add(this._libSQL.CrearParametro("@chrCTIPOINFO", this._chrTipoInfo));
                        this._lstParametros.Add(this._libSQL.CrearParametro("@strNACUERDO", this._strAcuerdo));
                        if (this._strOpcion != "DOCFORMATO") // Opción para cuando se va a cargar un archivo ER
                        {
                            this._lstParametros.Add(this._libSQL.CrearParametro("@dteFACUERDO", (this._dteFAcuerdo.Trim().Equals(string.Empty) ? null : this._dteFAcuerdo)));
                            if (this._bytDatos1 != null)
                            {

                                using (iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(this._bytDatos1)) // Objeto para extraer el número de hojas de una archivo
                                {
                                    this._lstParametros.Add(this._libSQL.CrearParametro("@intFOJAS", reader.NumberOfPages));
                                }
                            }
                        }
                        this._lstParametros.Add(this._libSQL.CrearParametro("@intRESP", 0, SqlDbType.Int, ParameterDirection.Output));

                        if (this._objDALSQL.ExecQuery_OUT("PA_IDUH_ARCHIVOBD", this._lstParametros))
                        {
                            System.Collections.ArrayList arrOUT = this._objDALSQL.Get_aOutput();
                            blnRespuesta = (int.Parse(arrOUT[0].ToString()) == 1 ? true : false);
                            this._strResp = arrOUT[0].ToString();
                        }
                    }
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region bool pUploadFile(FileUpload fuArchivo, string sOpcion, string sAccion)
        /// <summary>
        /// Procedimiento que carga un archivo al servidor
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="fuArchivo">Control de Servidor tipo FileUpload</param>
        /// <param name="sOpcion">Opcion: Formato/Guia o ArchivoER</param>
        /// <param name="sAccion">Acción a realizar</param>
        /// <returns></returns>
        public bool pUploadFileBD(FileUpload fuArchivo, string sOpcion, string sAccion)
        {
            bool blnRespuesta = false;

            try
            {
                if (fuArchivo.HasFile)
                {
                    this._gidFormato = Guid.NewGuid().ToString();
                    this._strAccion = sAccion;
                    this._strOpcion = sOpcion;
                    this._strNomArchivo = Path.GetFileName(fuArchivo.PostedFile.FileName);
                    this._strMimeType = fuArchivo.PostedFile.ContentType;
                    this._nTamanio = Convert.ToInt32(fuArchivo.PostedFile.InputStream.Length);
                    this._bytDatos1 = new byte[fuArchivo.PostedFile.InputStream.Length];
                    fuArchivo.PostedFile.InputStream.Read(this._bytDatos1, 0, this._nTamanio);
                    blnRespuesta = pSaveFileBD();
                }
            }
            catch
            {
                blnRespuesta = false;
            }
            return blnRespuesta;
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

        #region GETs y SETs
        public string gidFormato { get { return _gidFormato; } set { _gidFormato = value; } }       // GUID del Archivo
        public string strNomArchivo { get { return _strNomArchivo; } set { _strNomArchivo = value; } }  // Nombre del Archivo
        public string strMimeType { get { return _strMimeType; } set { _strMimeType = value; } }    // MIME type del Archivo
        public int nTamanio { get { return _nTamanio; } set { _nTamanio = value; } }     // Tamaño del archivo expresado en bytes
        public int nFojas { get { return _nFojas; } set { _nFojas = value; } }
        public string strTipo { get { return _strTipo; } set { _strTipo = value; } }        // Tipo de Documento (F=Formato, G=Guía)
        public byte[] bytDatos1 { get { return _bytDatos1; } set { _bytDatos1 = value; } }      // Arreglo de bytes donde se guarda el contenido del archivo
        public byte[] bytDatos2 { get { return _bytDatos2; } set { _bytDatos2 = value; } }      // Arreglo de bytes donde se guardará la cadena de comprobación del archivo
        public string dteFAlta { get { return _dteFAlta; } set { _dteFAlta = value; } }       // Fecha de alta del Archivo
        public string dteFCorte { get { return _dteFCorte; } set { _dteFCorte = value; } }      // Fecha de corte del archivo
        public int idUsuario { get { return _idUsuario; } set { _idUsuario = value; } }        // ID del usuario que cargo el archivo
        public int idUsuarioO { get { return _idUsuarioO; } set { _idUsuarioO = value; } }
        public int idPartAplic { get { return _idPartAplic; } set { _idPartAplic = value; } }
        public string strNomUsuario { get { return _strNomUsuario; } set { _strNomUsuario = value; } } // Nombre del usuario que cargo el archivo
        public char chrIndActivo { get { return _chrIndActivo; } set { _chrIndActivo = value; } }     // Indicador de registro activo (S=Activo, N=Inactivo)
        public char chrTipo { get { return _chrTipo; } set { _chrTipo = value; } }     // Indicador de Tipo de Documento (F=Formato, G=Guía)
        public string strObserva { get { return _strObserva; } set { _strObserva = value; } }
        public string strAccion { get { return _strAccion; } set { _strAccion = value; } }  // Variable de acción del objeto
        public string strOpcion { get { return _strOpcion; } set { _strOpcion = value; } }  // Variable de opción del objeto
        public string strMensaje { get { return _strMensaje; } set { _strMensaje = value; } }
        public string strResp { get { return _strResp; } set { _strResp = value; } }

        public char chrTipoInfo { get { return _chrTipoInfo; } set { _chrTipoInfo = value; } }
        public string strAcuerdo { get { return _strAcuerdo; } set { _strAcuerdo = value; } }
        public string dteFAcuerdo { get { return _dteFAcuerdo; } set { _dteFAcuerdo = value; } }
        #endregion
    }
}