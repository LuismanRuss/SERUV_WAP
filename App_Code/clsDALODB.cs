/* 
**************************************************************************************
* CLASE PARA EL ACCESO A DATOS MEDIANTE OLEDB                                        *
* .NET 2010 - FrameWork 4.0                                                          *
**************************************************************************************

Objetivo :  Seleccionar/Insertar/Actualizar/Eliminar información de una Base de Datos 
            de Oracle mediante packages.
Autor    :  MTI José Aroldo Alfaro Ávila
Fecha    :  11/MAR/2013
Versión  :  1.0

Fecha Últ. Modif. : 11/MAR/2013
*/


using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.OleDb;

namespace nsSERUV
{
    /// <summary>
    /// Clase para acceso a datos - OleDB
    /// </summary>
    public class clsDALODB : clsDALBase
    {
        private OleDbConnection _odbCnn;
        private Boolean _bMultiQuery;

        #region "Métdos públicos de la Clase"

        public clsDALODB(Boolean bMultiQuery)
        {
            //_odbCnn = new OleDbConnection(DES.funDES_FromBase64(ConfigurationManager.AppSettings["cnnORA"]));
            _odbCnn = new OleDbConnection(ConfigurationManager.AppSettings["cnnORA"]);
            _bMultiQuery = bMultiQuery;
        }

        #endregion


        #region "Métodos privados de la Clase"
        #endregion


        #region Métodos heredados de la Clase clsDALBase

        override public Boolean Conectar()
        {
            Boolean blnStatus = false;

            if (_bMultiQuery)
            {
                _sErrMsg = String.Empty;
                try
                {
                    _odbCnn.Open();
                    blnStatus = true;
                }
                catch (OleDbException odbExcep)
                {
                    _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean Desconectar()
        {
            Boolean blnStatus = false;

            if (_bMultiQuery)
            {
                _sErrMsg = String.Empty;
                try
                {
                    _odbCnn.Close();
                    blnStatus = true;
                }
                catch (OleDbException odbExcep)
                {
                    _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
                }
                finally
                {
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean Conectar(String sConexion)
        {
            Boolean blnStatus = false;

            if (_bMultiQuery)
            {
                Desconectar();
                _odbCnn = new OleDbConnection(sConexion);
                _sErrMsg = String.Empty;
                try
                {
                    _odbCnn.Open();
                    blnStatus = true;
                }
                catch (OleDbException odbExcep)
                {
                    _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }


        override public Boolean ExecQuery_SET(String sProcAlmacenado, ArrayList aParametros)
        {
            Boolean blnStatus = false;
            OleDbDataAdapter odbAdp = new OleDbDataAdapter(sProcAlmacenado, _odbCnn);

            _dtSet = new DataSet();
            _sErrMsg = String.Empty;
            try
            {
                odbAdp.SelectCommand.CommandTimeout = 360;
                odbAdp.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (aParametros != null)
                {
                    for (int i = 0; i < aParametros.Count; i++)
                    {
                        odbAdp.SelectCommand.Parameters.Add(aParametros[i]);
                    }
                    aParametros.Clear();
                }
                if (!_bMultiQuery)
                {
                    _odbCnn.Open();
                }
                odbAdp.Fill(_dtSet);
                blnStatus = true;
            }
            catch (OleDbException odbExcep)
            {
                _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
            }
            finally
            {
                if (!_bMultiQuery)
                {
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean ExecQuery_SET_OUT(String sProcAlmacenado, ArrayList aParametros)
        {
            Boolean blnStatus = false;
            OleDbDataAdapter odbAdp = new OleDbDataAdapter(sProcAlmacenado, _odbCnn);

            _dtSet = new DataSet();
            _sErrMsg = String.Empty;
            try
            {
                odbAdp.SelectCommand.CommandTimeout = 360;
                odbAdp.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (aParametros != null)
                {
                    for (int i = 0; i < aParametros.Count; i++)
                    {
                        odbAdp.SelectCommand.Parameters.Add(aParametros[i]);
                    }
                    aParametros.Clear();
                }
                if (!_bMultiQuery)
                {
                    _odbCnn.Open();
                }
                odbAdp.Fill(_dtSet);
                blnStatus = true;
            }
            catch (OleDbException odbExcep)
            {
                _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
            }
            finally
            {
                if (!_bMultiQuery)
                {
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean ExecQuery_TBL(String sProcAlmacenado, ArrayList aParametros, String sOrdenadoPor)
        {
            Boolean blnStatus = false;
            OleDbDataAdapter odbAdp = new OleDbDataAdapter(sProcAlmacenado, _odbCnn);

            _dtTable = new DataTable();
            _sErrMsg = String.Empty;
            try
            {
                odbAdp.SelectCommand.CommandTimeout = 360;
                odbAdp.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (aParametros != null)
                {
                    for (int i = 0; i < aParametros.Count; i++)
                    {
                        odbAdp.SelectCommand.Parameters.Add(aParametros[i]);
                    }
                    aParametros.Clear();
                }
                if (!_bMultiQuery)
                {
                    _odbCnn.Open();
                }
                odbAdp.Fill(_dtTable);
                _dtTable.DefaultView.Sort = sOrdenadoPor;
                blnStatus = true;
            }
            catch (OleDbException odbExcep)
            {
                _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
            }
            finally
            {
                if (!_bMultiQuery)
                {
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean ExecQuery_SCL(String sProcAlmacenado, ArrayList aParametros)
        {
            Boolean blnStatus = false;
            OleDbCommand odbCmd = new OleDbCommand(sProcAlmacenado, _odbCnn);

            _sScalar = String.Empty;
            _sErrMsg = String.Empty;
            try
            {
                odbCmd.CommandTimeout = 360;
                odbCmd.CommandType = CommandType.StoredProcedure;
                if (aParametros != null)
                {
                    for (int i = 0; i < aParametros.Count; i++)
                    {
                        odbCmd.Parameters.Add(aParametros[i]);
                    }
                    aParametros.Clear();
                }
                if (!_bMultiQuery)
                {
                    _odbCnn.Open();
                }
                _sScalar = odbCmd.ExecuteScalar().ToString();
                if (_sScalar == null) { _sScalar = String.Empty; }
                blnStatus = true;
            }
            catch (OleDbException odbExcep)
            {
                _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
            }
            finally
            {
                if (!_bMultiQuery)
                {
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean ExecQuery_OUT(String sProcAlmacenado, ArrayList aParametros)
        {
            Boolean blnStatus = false;
            OleDbCommand odbCmd = new OleDbCommand(sProcAlmacenado, _odbCnn);

            _aOutput = new ArrayList();
            _sErrMsg = String.Empty;
            try
            {
                odbCmd.CommandTimeout = 360;
                odbCmd.CommandType = CommandType.StoredProcedure;
                if (aParametros != null)
                {
                    for (int i = 0; i < aParametros.Count; i++)
                    {
                        odbCmd.Parameters.Add(aParametros[i]);
                    }
                    aParametros.Clear();
                }
                if (!_bMultiQuery)
                {
                    _odbCnn.Open();
                }
                odbCmd.ExecuteNonQuery();
                for (int i = 0; i < odbCmd.Parameters.Count; i++)
                {
                    if (odbCmd.Parameters[i].Direction == ParameterDirection.Output)
                    {
                        _aOutput.Add(odbCmd.Parameters[i].Value);
                    }
                }
                blnStatus = true;
            }
            catch (OleDbException odbExcep)
            {
                _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
            }
            finally
            {
                if (!_bMultiQuery)
                {
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        override public Boolean ExecQuery(String sProcAlmacenado, ArrayList aParametros)
        {
            Boolean blnStatus = false;
            OleDbCommand odbCmd = new OleDbCommand(sProcAlmacenado, _odbCnn);

            _sErrMsg = String.Empty;
            try
            {
                odbCmd.CommandTimeout = 360;
                odbCmd.CommandType = CommandType.StoredProcedure;
                if (aParametros != null)
                {
                    for (int i = 0; i < aParametros.Count; i++)
                    {
                        odbCmd.Parameters.Add(aParametros[i]);
                    }
                    aParametros.Clear();
                }
                if (!_bMultiQuery)
                {
                    _odbCnn.Open();
                }
                odbCmd.ExecuteNonQuery();
                blnStatus = true;
            }
            catch (OleDbException odbExcep)
            {
                _sErrMsg = odbExcep.ErrorCode.ToString() + " - " + odbExcep.Message;
            }
            finally
            {
                if (!_bMultiQuery)
                {
                    _odbCnn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return blnStatus;
        }

        #endregion
    }
}