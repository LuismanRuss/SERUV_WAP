using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Text;
using System.IO;
using System.Xml;
namespace nsSERUV
{
    public class clsJsonMethods
    {

        #region Procedimientos de la Clase

        #region Convierte DataTable a Json
        /// <summary>
        /// Autor:          Edgar Morales González
        /// Objetivo:       Convertir un DataTable en un jSON
        /// </summary>
        /// <param name="dt">objeto del tipo Datatable</param>
        /// <returns>regresa un string en formato jSON con la información del DataSet</returns>
        public static string DStoJSON(DataTable dt)
        {
            //----------------------------------------
            StringBuilder JsonString = new StringBuilder();
            StringBuilder tmpR;
            StringBuilder tmpA;

            if (((dt == null)
                        || (dt.Rows.Count == 0)))
            {
                return String.Empty;
            }
            // serializo
            JsonString.Append("{");
            JsonString.Append('"' + "dato" + '"' + ":[");
            tmpA = new StringBuilder();
            foreach (DataRow f in dt.Rows)
            {
                tmpA.Append("{");
                tmpR = new StringBuilder();
                foreach (DataColumn c in dt.Columns)
                {
                    tmpR.Append(('"' + c.ColumnName + '"' + (":\""
                                    + (f[c.ColumnName].ToString() + "\","))));
                }
                tmpA.Append(tmpR.ToString().Remove((tmpR.ToString().Length - 1), 1));
                tmpA.Append("},");
            }
            JsonString.Append(tmpA.ToString().Remove((tmpA.ToString().Length - 1), 1));
            JsonString.Append("]}");
            return JsonString.ToString();
        }
        #endregion


        ////////////////////////////////////////
        #region ConvertDataSetToXML
        /// <summary>
        /// Autor:          Edgar Morales González
        /// Objetivo:       Función que convierte un DataSet en un string con formato XML
        /// </summary>
        /// <param name="xmlDS"></param>
        /// <returns>Devuelve un string que contiene información proveniente de un DataSet</returns>
        public static string ConvertDataSetToXML(DataSet xmlDS)
        {
            try
            {
                MemoryStream ms = new MemoryStream();
                xmlDS.WriteXml(ms);

                StreamReader sr = new StreamReader(ms, System.Text.Encoding.UTF8);
                ms.Position = 0;
                String strXml = sr.ReadToEnd();
                sr.Close();
                ms.Close();

                return strXml;
            }
            catch
            {
                return String.Empty;
            }
            finally
            {
                //  if (writer != null) writer.Close();
            }
        }
        #endregion


        #endregion
    }
}