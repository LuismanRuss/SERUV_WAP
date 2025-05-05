using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace libFunciones
{
    public class clsValidacion : IDisposable
    {
        /// <summary>
        /// Objetivo:                       Clase para el manejo de validaciones
        /// Versión:                        1.0
        /// Autor:                          L.I. casí MRT Erik José Enríquez Carmona
        /// Fecha de Creación:              21 de Febrero 2013
        /// Modificó:                       L.I. casí MRT Erik José Enríquez Carmona
        /// Fecha de última Mod:            21 de Febrero 2013
        /// Tablas de la BD que utiliza:    NINGUNA
        /// </summary>
        public clsValidacion()
        {
        }

        #region string ConvertDatePicker(Object obj)
        /// <summary>
        /// Convierte una fecha de DatePicker a formato SQL Server
        /// Autor: Erik José Enríquez Carmona
        /// </summary>
        /// <param name="obj">Cadena a convertir</param>
        /// <returns>Cadena convertida o cadena vacia</returns>
        public string ConvertDatePicker(Object obj)
        {
            string strDate = obj.ToString();
            try
            {
                string[] strTempDate = strDate.Split(('-'));
                return strTempDate[2] + "-" + strTempDate[1] + "-" + strTempDate[0];
            }
            catch
            {
                return string.Empty;
            }
        }
        #endregion

        #region bool IsDate(Object obj)
        /// <summary>
        /// Valida si una cadena es objeto
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <param name="obj">Objeto Fecha</param>
        /// <returns>Verdadero si es fecha, falso si no</returns>
        public bool IsDate(Object obj)
        {
            string strDate = obj.ToString();
            try
            {
                DateTime dt = DateTime.Parse(strDate);
                if (dt != DateTime.MinValue && dt != DateTime.MaxValue)
                    return true;
                return false;
            }
            catch
            {
                return false;
            }
        }
        #endregion
        #region IsNumeric
        /// <summary>
        /// Valida si una cadena es objeto
        /// Autor: L.I. Erik José Enriquez Carmona
        /// </summary>
        /// <param name="Expression">Objeto expresion donde se recibe un valor</param>
        /// <returns>Verdadero si es numerico, falso si no</returns>
        public bool IsNumeric(object Expression)
        {

            bool isNum;
            double retNum;
            isNum = Double.TryParse(Convert.ToString(Expression), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out retNum);
            return isNum;
        }
        #endregion

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