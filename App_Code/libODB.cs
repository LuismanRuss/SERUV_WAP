/* 
**************************************************************************************
* CLASE PARA FUNCIONES Y PROCEDIMIENTOS PROPIOS DE OLEDB                             *
* .NET 2010 - FrameWork 4.0                                                          *
**************************************************************************************

Objetivo :  Encapsular todas las funciones y procedimientos que se utilizarán con Oracle.
Autor    :  MTI José Aroldo Alfaro Ávila
Fecha    :  11/MAR/2013
Versión  :  1.0

Fecha Últ. Modif. : 11/MAR/2013
*/

using System;
using System.Data;
using System.Data.OleDb;

namespace nsSERUV
{
    /// <summary>
    /// Clase para funciones y procedimientos propios de OleDB
    /// </summary>
    public class libODB : IDisposable
    {
        public libODB()
        {
            //
            // TODO: Agregar aquí la lógica del constructor
            //
        }

        public OleDbParameter CrearParametro(string sNombre, object oValor)
        {
            OleDbParameter odbParam = new OleDbParameter();

            odbParam.ParameterName = sNombre;
            odbParam.Value = oValor;
            return odbParam;
        }

        public OleDbParameter CrearParametro(string sNombre, object oValor, OleDbType tTipo)
        {
            OleDbParameter odbParam = new OleDbParameter();

            odbParam.ParameterName = sNombre;
            odbParam.Value = oValor;
            odbParam.OleDbType = tTipo;
            return odbParam;
        }

        public OleDbParameter CrearParametro(string sNombre, object oValor, OleDbType tTipo, int nTamanio, byte nEscala)
        {
            OleDbParameter odbParam = new OleDbParameter();

            odbParam.ParameterName = sNombre;
            odbParam.Value = oValor;
            odbParam.OleDbType = tTipo;
            odbParam.Size = nTamanio;
            odbParam.Scale = nEscala;
            return odbParam;
        }

        public OleDbParameter CrearParametro(string sNombre, OleDbType tTipo, System.Data.ParameterDirection tDireccion)
        {
            OleDbParameter odbParam = new OleDbParameter();

            odbParam.ParameterName = sNombre;
            odbParam.OleDbType = tTipo;
            odbParam.Direction = tDireccion;
            return odbParam;
        }

        public OleDbParameter CrearParametro(string sNombre, object oValor, OleDbType tTipo, int nTamanio, byte nEscala, System.Data.ParameterDirection tDireccion)
        {
            OleDbParameter odbParam = new OleDbParameter();

            odbParam.ParameterName = sNombre;
            odbParam.Value = oValor;
            odbParam.OleDbType = tTipo;
            odbParam.Size = nTamanio;
            odbParam.Scale = nEscala;
            odbParam.Direction = tDireccion;
            return odbParam;
        }


        #region IDisposable Members
        /// <summary>
        /// Procedimiento para destruir objetos
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion

    }
}