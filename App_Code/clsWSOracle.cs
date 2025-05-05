using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;
using System.Web;


/// <summary>
///       Objetivo :   Clase para leer el Web Service que recupera información del Empleado desde Oracle
///        Versión :   1.0
///          Autor :   MTI José Aroldo Alfaro Ávila
/// Fecha Creación :   04/Abr/2013
/// </summary>
namespace nsSERUV
{
    public class clsWSOracle
    {
        public clsWSOracle()
        {
            //
            // TODO: Agregar aquí la lógica del constructor
            //
        }

        public DataSet funInfoEmpleado_SET(string sLogin)
        {
            DataSet dtSet = new DataSet();
            string[] vecWSOracleParam = ConfigurationManager.AppSettings["wsOracle"].ToString().Split('@');
            string strWebApp = ConfigurationManager.AppSettings.Get("WebApp");
            String strXMLBase64 = "";

            switch (strWebApp)
            {
                //case "ADWEB":
                //    dsiades.wsGetInfoEmpleado wsInfoEmp_ADWEB = new dsiades.wsGetInfoEmpleado();
                //    strXMLBase64 = wsInfoEmp_ADWEB.funGetInfoEmpleado(sLogin, vecWSOracleParam[0], vecWSOracleParam[1]);
                //    break;
                case "DVLP":
                case "TRNG":
                    //srvxaddweb.wsGetInfoEmpleado wsInfoEmp_TRNG = new srvxaddweb.wsGetInfoEmpleado();
                    SERUV_WAP.wsGetInfoEmpleado_DVLP.wsGetInfoEmpleado wsInfoEmp_TRNG = new SERUV_WAP.wsGetInfoEmpleado_DVLP.wsGetInfoEmpleado();
                    strXMLBase64 = wsInfoEmp_TRNG.funGetInfoEmpleado(sLogin, vecWSOracleParam[0], vecWSOracleParam[1]);

                    //xalweb2admvo.wsGetInfoEmpleado wsInfoEmp_TRNG = new xalweb2admvo.wsGetInfoEmpleado();
                    //strXMLBase64 = wsInfoEmp_TRNG.funGetInfoEmpleado(sLogin, vecWSOracleParam[0], vecWSOracleParam[1]);
                    break;
                case "ADWEB":
                case "PROD":
                case "PROV":
                    //dsiauvmx.wsGetInfoEmpleado wsInfoEmp_PROD = new dsiauvmx.wsGetInfoEmpleado();
                    //strXMLBase64 = wsInfoEmp_PROD.funGetInfoEmpleado(sLogin, vecWSOracleParam[0], vecWSOracleParam[1]);

                    SERUV_WAP.wsGetInfoEmpleado_PROD.wsGetInfoEmpleado wsInfoEmp_PROD = new SERUV_WAP.wsGetInfoEmpleado_PROD.wsGetInfoEmpleado();
                    strXMLBase64 = wsInfoEmp_PROD.funGetInfoEmpleado(sLogin, vecWSOracleParam[0], vecWSOracleParam[1]);

                    break;
                //case "PROD2012":
                //    Prod2012.wsGetInfoEmpleado wsInfoEmp_PROD2012 = new Prod2012.wsGetInfoEmpleado();
                //    strXMLBase64 = wsInfoEmp_PROD2012.funGetInfoEmpleado(sLogin, vecWSOracleParam[0], vecWSOracleParam[1]);
                //    break;
            }
            Byte[] bytFromBase64 = System.Convert.FromBase64String(strXMLBase64);
            String strXML = ASCIIEncoding.ASCII.GetString(bytFromBase64);
            StringReader srReader = new StringReader(strXML);
            dtSet.ReadXml(srReader);
            return dtSet;
        }

    }

}