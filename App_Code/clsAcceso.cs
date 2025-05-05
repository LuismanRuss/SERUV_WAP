using System;
using System.Collections;
using System.Data;


namespace nsSERUV
{
    public class clsAcceso : IDisposable
    {
        #region "Tipos públicos"
        public enum eGetInfo { Logueo = 1, Acceso = 2 };
        #endregion


        #region "Variables privadas"
        ArrayList laParametros = new ArrayList();
        private int _nIdUsuario;
        private string _sCuenta;
        private string _sCorreo;
        private string _sNombre;
        private bool _bEsUsuarioActivo;
        private bool _bEsPerfilActivo;
        private string _sPerfiles;
        private string _sPermisos;
        private bool _bEsSA;
        private bool _bEsAdmin;
        private bool _bEsSupervisor;
        private bool _bEsSujObligado;
        private bool _bEsSujReceptor;
        private bool _bEsEnlace;
        private bool _bEsEnlaceR;
        private bool _bEsSupSAF;
        private bool _bEsSupCG;
        private bool _bEsSupJerarquico;
        private string _sError;
        #endregion


        #region "Propiedades públicas de la clase"
        public int IdUsuario { get { return _nIdUsuario; } }

        public string Cuenta { get { return _sCuenta; } }

        public string Correo { get { return _sCorreo; } }

        public string Nombre { get { return _sNombre; } }

        public bool EsUsuarioActivo { get { return _bEsUsuarioActivo; } }

        public bool EsPerfilActivo { get { return _bEsPerfilActivo; } }

        public string Perfiles { get { return _sPerfiles; } }

        public string Permisos { get { return _sPermisos; } }

        public bool EsSA { get { return _bEsSA; } }

        public bool EsAdmin { get { return _bEsAdmin; } }

        public bool EsSupervisor { get { return _bEsSupervisor; } }

        public bool EsSujObligado { get { return _bEsSujObligado; } }

        public bool EsSujReceptor { get { return _bEsSujReceptor; } }

        public bool EsEnlace { get { return _bEsEnlace; } }

        public bool EsEnlaceR { get { return _bEsEnlaceR; } }

        public bool EsSupSAF { get { return _bEsSupSAF; } }

        public bool EsSupCG { get { return _bEsSupCG; } }

        public bool EsSupJerarquico { get { return _bEsSupJerarquico; } }

        public string MsgError { get { return _sError; } }
        #endregion


        #region "Constructor de la Clase"
        public clsAcceso(string sCuenta, eGetInfo eTipoInfo)
        {
            _sCuenta = sCuenta;
            pSet_InitValues();
            switch (eTipoInfo)
            {
                case eGetInfo.Logueo:
                    pGet_InfoLogueo();
                    break;
                case eGetInfo.Acceso:
                    pGet_InfoAcceso();
                    break;
            }
        }
        #endregion


        #region "Métodos privados de la clase"

        #region "pGet_InfoLogueo"
        /// <summary>
        /// Procedimiento que obtiene el ID y los indicadores para determinar si un usuario tiene permiso de acceder al sistema
        /// Autor: MTI José Aroldo Alfaro Ávila
        /// Fecha: 21-Abr-2013
        /// </summary>
        private void pGet_InfoLogueo()
        {
            using (clsDALSQL cDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                laParametros.Add(lSQL.CrearParametro("@sACCION", "LOGUEO"));
                laParametros.Add(lSQL.CrearParametro("@sCUENTA", _sCuenta));
                if (cDALSQL.ExecQuery_TBL("PA_ACCESO", laParametros, ""))
                {
                    DataTable dtTable = cDALSQL.Get_dtTable();
                    DataRow dtRow = dtTable.Rows[0];
                    _nIdUsuario = dtRow.Table.Columns.Contains("IdUsuario") ? Convert.ToInt32(dtRow["IdUsuario"].ToString()) : 0;
                    _bEsUsuarioActivo = dtRow.Table.Columns.Contains("UsuarioActivo") ? (dtRow["UsuarioActivo"].ToString() == "S" ? true : false) : false;
                    _bEsPerfilActivo = dtRow.Table.Columns.Contains("PerfilActivo") ? (dtRow["PerfilActivo"].ToString() == "S" ? true : false) : false;
                }
                else
                {
                    // obtener error
                    _sError = cDALSQL.Get_sError();
                }
            }
        }
        #endregion

        #region "pGet_InfoAcceso"
        /// <summary>
        /// Procedimiento que obtiene la información necesaria para identificar al usuario que accede al sistema y los perfiles que tiene asociados
        /// Autor: MTI José Aroldo Alfaro Ávila
        /// Fecha: 21-Abr-2013
        /// </summary>
        private void pGet_InfoAcceso()
        {
            using (clsDALSQL cDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                laParametros.Add(lSQL.CrearParametro("@sACCION", "ACCESO"));
                laParametros.Add(lSQL.CrearParametro("@sCUENTA", _sCuenta));
                if (cDALSQL.ExecQuery_TBL("PA_ACCESO", laParametros, ""))
                {
                    DataTable dtTable = cDALSQL.Get_dtTable();
                    DataRow dtRow = dtTable.Rows[0];
                    _nIdUsuario = dtRow.Table.Columns.Contains("IdUsuario") ? Convert.ToInt32(dtRow["IdUsuario"].ToString()) : 0;
                    //_sCuenta = dtRow.Table.Columns.Contains("Cuenta") ? dtRow["Cuenta"].ToString() : string.Empty;
                    _sCorreo = dtRow.Table.Columns.Contains("Correo") ? dtRow["Correo"].ToString() : string.Empty;
                    _sNombre = dtRow.Table.Columns.Contains("Nombre") ? dtRow["Nombre"].ToString() : string.Empty;
                    _sPerfiles = dtRow.Table.Columns.Contains("Perfiles") ? dtRow["Perfiles"].ToString() : string.Empty;
                    _sPermisos = dtRow.Table.Columns.Contains("Permisos") ? dtRow["Permisos"].ToString() : string.Empty;
                    if (_sPerfiles != string.Empty)
                    {
                        string[] vecPerfiles = _sPerfiles.Split('|');
                        string[] vecPerfil = null;
                        foreach (string sPerfil in vecPerfiles)
                        {
                            vecPerfil = sPerfil.Split(',');
                            switch (vecPerfil[0])
                            {
                                case "1":
                                    _bEsSA = true; break;
                                case "2":
                                    _bEsAdmin = true; break;
                                case "3":
                                    _bEsSupervisor = true; break;
                                case "4":
                                    _bEsSujObligado = true; break;
                                case "5":
                                    _bEsSujReceptor = true; break;
                                case "6":
                                    _bEsEnlace = true; break;
                                case "7":
                                    _bEsEnlaceR = true; break;
                                case "8":
                                    _bEsSupSAF = true; break;
                                case "9":
                                    _bEsSupCG = true; break;
                                case "10":
                                    _bEsSupJerarquico = true; break;
                            }
                        }

                    }
                }
                else
                {
                    // obtener error
                    _sError = cDALSQL.Get_sError();
                }
            }
        }
        #endregion

        #region "pSet_InitValues"
        /// <summary>
        /// Procedimiento que inicializa las propiedades públicas de la clase
        /// Autor: MTI José Aroldo Alfaro Ávila
        /// Fecha: 21-Abr-2013
        /// </summary>
        private void pSet_InitValues()
        {
            _nIdUsuario = 0;
            _sCorreo = string.Empty;
            _sNombre = string.Empty;
            _bEsUsuarioActivo = false;
            _bEsPerfilActivo = false;
            _sPerfiles = string.Empty;
            _sPermisos = string.Empty;
            _bEsSA = false;
            _bEsAdmin = false;
            _bEsSupervisor = false;
            _bEsSujObligado = false;
            _bEsSujReceptor = false;
            _bEsEnlace = false;
            _bEsEnlaceR = false;
            _bEsSupSAF = false;
            _bEsSupCG = false;
            _bEsSupJerarquico = false;
            _sError = "";
        }
        #endregion

        #endregion

        #region "Dispose"
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion 

    }
}