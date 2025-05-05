using System;
using System.Collections.Generic;
using System.Web;
using System.DirectoryServices; // Referencia al Framework 4.0
using libFunciones;
using System.Data;

/// <summary>
/// Objetivo:                       Clase para el manejo de perfiles
/// Versión:                        1.0
/// Autor:                          L.I. Emmanuel Méndez Flores
/// Fecha de Creación:              6 de Marzo 2013
/// Tablas de la BD que utiliza:    APSUSUARIO
/// </summary>

namespace nsSERUV
{
    public class clsPerfil
    {

        System.Collections.ArrayList lstParametros = new System.Collections.ArrayList();
        bool blnRespuesta = false;

        #region Variables Privadas
        private List<clsPerfil> _lstPerfiles;
        private int _idPerfil; // ID del perfil
        private string _strsDCPerfil; // Nombre del perfil
        #endregion


        #region Procedimientos de la clase

        #region clsPerfil
        public clsPerfil()
        {
            //
            // TODO: Agregar aquí la lógica del constructor
            //
        }
        #endregion

        #region fGetPerfiles
        /// <summary>
        /// Función que obtiene la lista de perfiles.
        /// Autor: L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <returns>Boleano que indica si se realizó correctamente la operación, los perfiles se insertan en la lista lstPerfiles</returns>
        public bool fGetPerfiles()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_PERFILES"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_PERFIL", lstParametros))
                {
                    lstPerfiles = new List<clsPerfil>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "PERFILES");
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetPerfilesConAdm
        public bool fGetPerfilesConAdm()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_PERFILES_TODOS"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_PERFIL", lstParametros))
                {
                    lstPerfiles = new List<clsPerfil>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "PERFILES");
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region fGetPerfilAdministrador
        /// <summary>
        /// Función que recupera la información del perfil de administrador
        /// Autor: L.I. Emmanuel Méndez Flores
        /// </summary>
        /// <returns>Boleano que indica si se realizó correctamente la operación</returns>
        public bool fGetPerfilAdministrador()
        {
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "SELECCIONA_PERFIL_ADMINISTRADOR"));
                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELU_PERFIL", lstParametros))
                {
                    lstPerfiles = new List<clsPerfil>();
                    pLlenarLista(objDALSQL.Get_dtSet(), "PERFILES");
                }
            }
            return blnRespuesta;
        }
        #endregion

        #region pLlenarLista
        /// <summary>
        /// Función que se encarga de llenar la lista lstPerfiles de acuerdo a una opción.
        /// Autor: L.I. Emmanuel Méndez Flores.
        /// </summary>
        /// <param name="dataset">Dataset con la información de los perfiles</param>
        /// <param name="op">Opción a ejecutar dentro de la función</param>
        private void pLlenarLista(DataSet dataset, string op)
        {
            try
            {
                if (dataset != null && dataset.Tables[0].Rows.Count > 0)
                {
                    switch (op)
                    {
                        case "PERFILES":
                            lstPerfiles.Add(null);
                            foreach (DataRow row in dataset.Tables[0].Rows)
                            {
                                clsPerfil objPerfil = new clsPerfil();
                                objPerfil.idPerfil = int.Parse(row["idPerfil"].ToString());
                                objPerfil.strsDCPerfil = row["sDPerfil"].ToString();//strsDCPerfil
                                lstPerfiles.Add(objPerfil);
                            }
                            break;
                    }
                }
            }
            catch //(Exception ex)
            {
                lstPerfiles = null;
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

        #region GET y SETs
        public int idPerfil { get { return _idPerfil; } set { _idPerfil = value; } }
        public string strsDCPerfil { get { return _strsDCPerfil; } set { _strsDCPerfil = value; } }
        public List<clsPerfil> lstPerfiles { get { return _lstPerfiles; } set { _lstPerfiles = value; } }
        #endregion

    }
}