using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;

/// <summary>
/// Summary description for clsSPARH
/// </summary>

namespace nsSERUV
{

    public class clsSPARH
    {
        public string dateFechaHora;  // Guarda fecha y hora actual de la generación del HMAC
        public string strFirmaDigital; // Firma digiral. Guarda el HMAC
        public string strUrlWebApi;
        public string strApiPublic;
        public string strApiSecret;
        public string strtxtMetodo;
        public string _auxCad01 = string.Empty;
        public string postJsonCifrado = string.Empty;
        public string strMensajeError = string.Empty;
        public clsSPARH()
        {
            dateFechaHora = DateTime.Now.ToString("yyyyMMddHHmmssfff") + "kl"; //Se deben agregar dos caracteres
            strUrlWebApi = ConfigurationManager.AppSettings.Get("UrlWebApi");
            strApiPublic = ConfigurationManager.AppSettings.Get("ApiPublic");
            strApiSecret = DES.funDES_FromBase64(ConfigurationManager.AppSettings.Get("APISecret"));
            strtxtMetodo = ConfigurationManager.AppSettings.Get("txtMetodo");
        }

        public string GeneraHMAC()
        {
            try
            {
                String cadena = dateFechaHora.Trim() + strtxtMetodo + strApiPublic; // Manera obligatoria de concatenar los datos consultados
                String cadenaHash = String.Join("", (new SHA1Managed().ComputeHash(Encoding.UTF8.GetBytes(cadena))).Select(x => x.ToString("X2")).ToArray());
                Byte[] secretBytes = UTF8Encoding.UTF8.GetBytes(strApiSecret); // Se convierte a bytes el API Key
                HMACSHA1 hmac = new HMACSHA1(secretBytes); // Se asignan los bytes del API key a la variable para encriptación
                Byte[] dataBytes = UTF8Encoding.UTF8.GetBytes(cadenaHash); // Se convierte a bytes la cadena concatenada y encriptada previamente
                Byte[] calcHash = hmac.ComputeHash(dataBytes); // Se calcula el HMAC
                String hmacString = Convert.ToBase64String(calcHash); // Se convierte a formato texto el HMAC
                return hmacString; // Se regresa en formato texto el HMAC
            }
            catch (Exception ex) // Mostramos el error en la consola
            {
                return ex.Message;
            }
        }

        public string funGetInfoEmpleado(string sLogin)
        {

            string strResponseValue = string.Empty;
            string strConsulta = "{\"parametros\":{\"noPersonal\":[0],\"login\":\"" + sLogin + "\"},\"opcion\":\"MPersonalUV\"}";
            postJsonCifrado = clsEncriptado.sEncrypt(strConsulta, strApiSecret);

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(strUrlWebApi);
            request.Method = "POST";
            request.Headers.Add("Firma", GeneraHMAC());
            request.Headers.Add("Fecha", dateFechaHora);
            request.Headers.Add("ApiPublic", strApiPublic);
            request.ContentType = "application/json";

            HttpWebResponse response = null;

            try
            {
                using (StreamWriter swJSONPayload = new StreamWriter(request.GetRequestStream()))
                {
                    swJSONPayload.Write(postJsonCifrado);
                    swJSONPayload.Close();
                }

                response = (HttpWebResponse)request.GetResponse();

                using (Stream responseStream = response.GetResponseStream())
                {
                    if (responseStream != null)
                    {
                        using (StreamReader reader = new StreamReader(responseStream))
                        {
                            strResponseValue = reader.ReadToEnd();
                            strResponseValue = clsEncriptado.fnsDesEncripta(strResponseValue, strApiSecret);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                strResponseValue = "{\"errorMessages\":[\"" + ex.Message.ToString() + "\"],\"errors\":{}}";
                strMensajeError = ex.Message.ToString();
                //MessageBox.Show(strResponseValue, "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                if (response != null)
                {
                    ((IDisposable)response).Dispose();
                }
            }
            return strResponseValue;
        }

        public DataSet ConvertJsonToDataTable(string sJSON)
        {
            DataSet dsEmpleado = new DataSet();
            DataTable dtCatalogo = new DataTable();

            try
            {
                Dictionary<string, string> datos = JsonConvert.DeserializeObject<Dictionary<string, string>>(sJSON);
                foreach (var xItem in datos)
                {
                    if (xItem.Key == "resultados")
                    {
                        _auxCad01 = xItem.Value;
                    }
                }

                if (_auxCad01.Length > 0)
                {
                    var jsonLinq = JObject.Parse(_auxCad01);
                    var linqArray = jsonLinq.Descendants().Where(x => x is JArray).First();
                    if (linqArray.Count() > 0)
                    {
                        var jsonArray = new JArray();
                        int _ban = 0;

                        foreach (JObject row in linqArray.Children<JObject>())
                        {
                            foreach (JProperty column in row.Properties())
                            {
                                if (_ban == 0)
                                {
                                    var dtcolumn = new DataColumn();
                                    dtcolumn.ColumnName = column.Name;
                                    dtCatalogo.Columns.Add(dtcolumn);
                                }
                            }
                            _ban = 1;
                            break;
                        }

                        var trgArray = new JArray();
                        foreach (JObject row in linqArray.Children<JObject>())
                        {
                            var createRow = new JObject();
                            foreach (JProperty column in row.Properties())
                            {
                                if (column.Value is JValue)
                                {
                                    createRow.Add(column.Name, column.Value);
                                }
                            }
                            trgArray.Add(createRow);
                        }
                        dtCatalogo = JsonConvert.DeserializeObject<DataTable>(trgArray.ToString());
                        dsEmpleado.Tables.Add(dtCatalogo);
                    }
                    else
                    {
                        //MessageBox.Show("No hay información para convertir", "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else
                {
                    //MessageBox.Show("No hay información para convertir", "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    strMensajeError = "Código " + datos["codigo"] + " - " + datos["mensaje"];
                }
            }
            catch (Exception ex)
            {
                //MessageBox.Show(ex.Message, "ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error);
                strMensajeError = "Hubo un error al convertir los datos";
            }
            return dsEmpleado;
        }
    }
}