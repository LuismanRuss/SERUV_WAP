using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization; 


public partial class Administracion_Guia_SAAVIGGUI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #region Metodo para saber si la Guía actual esta Vigente o si existe ya alguna vigente
    /// <summary>
    /// Función para saber si la Guía actual esta Vigente o si existe ya alguna vigente
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objGuias">Objeto de Datos de la clase Guias</param>
    /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static bool Guias_Vigentes(clsGuia objGuia)
    {
        bool blnResultado = false;

        if (objGuia.fGetGuiasVigentes(objGuia))
        {

            blnResultado = true;
        }
        else
        {
            blnResultado = false;
        }
        return blnResultado;
    }

    #endregion

    #region Metodo para Actualizar la Vigencia de la Guía
    /// <summary>
    /// Función para Actualizar la Vigencia de la Guía
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objGuias">Objeto de Datos de la clase Guias</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Guias</returns>
    [WebMethod(EnableSession = true)]
    public static string Actualizar_Vigencia(clsGuia objGuia)
    {
        //int blnResultado = 0;
        string strDatosAnexo = string.Empty;

        if (objGuia.strAccion == "CAMBIAR_VIGENCIA")
        {
            if (objGuia.chrIndVigente.ToString() == "N")
            {

                if (objGuia.fGetValidaProcesosAnexos())
                {
                    //se valido y se cambio la vigencia de S -> N del registro actual
                    objGuia.strRespuesta = objGuia.fGetFechaVigentes().ToString();

                    switch (objGuia.strRespuesta)
                    {
                        case "1":
                            objGuia.strRespuesta = "1";
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                        case "2":
                            objGuia.strRespuesta = "6";
                            JavaScriptSerializer serializer2 = new JavaScriptSerializer();
                            serializer2.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer2.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                        case "0":
                            objGuia.strRespuesta = "5";
                            JavaScriptSerializer serializer3 = new JavaScriptSerializer();
                            serializer3.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer3.Serialize(objGuia);
                            objGuia.Dispose();
                            break;
                    }

                }
                else
                {   //no se valido, solo se cambia la fecha del registro actual

                    objGuia.chrIndVigente = 'S';

                    objGuia.strRespuesta = objGuia.fGetFechaVigentes().ToString();


                    switch (objGuia.strRespuesta)
                    {
                        case "1":
                            objGuia.strRespuesta = "3";
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                        case "2":
                            objGuia.strRespuesta = "6";
                            JavaScriptSerializer serializer2 = new JavaScriptSerializer();
                            serializer2.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer2.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                        case "0":
                            objGuia.strRespuesta = "5";
                            JavaScriptSerializer serializer3 = new JavaScriptSerializer();
                            serializer3.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer3.Serialize(objGuia);
                            objGuia.Dispose();
                            break;
                    }

                }
            }
            else if (objGuia.chrIndVigente.ToString() == "S")
            {
                    objGuia.strRespuesta = objGuia.fGetFechaVigentes().ToString();

                    switch (objGuia.strRespuesta)
                    {
                        case "1":
                            objGuia.strRespuesta = "4";
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                        case "2":
                            objGuia.strRespuesta = "6";
                            JavaScriptSerializer serializer2 = new JavaScriptSerializer();
                            serializer2.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer2.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                        case "0":
                            objGuia.strRespuesta = "5";
                            JavaScriptSerializer serializer3 = new JavaScriptSerializer();
                            serializer3.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                            strDatosAnexo = serializer3.Serialize(objGuia);
                            objGuia.Dispose();
                            break;

                    }

            }

        }

        if (objGuia.strAccion == "FECHA_VIGENCIA")
        {
                objGuia.strRespuesta = objGuia.fGetFechaVigentes().ToString();

                switch (objGuia.strRespuesta)
                {
                    case "1":
                        objGuia.strRespuesta = "2";
                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                        serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                        strDatosAnexo = serializer.Serialize(objGuia);
                        objGuia.Dispose();
                        break;

                    case "2":
                        objGuia.strRespuesta = "6";
                        JavaScriptSerializer serializer2 = new JavaScriptSerializer();
                        serializer2.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                        strDatosAnexo = serializer2.Serialize(objGuia);
                        objGuia.Dispose();
                        break;

                    case "0":
                        objGuia.strRespuesta = "5";
                        JavaScriptSerializer serializer3 = new JavaScriptSerializer();
                        serializer3.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                        strDatosAnexo = serializer3.Serialize(objGuia);
                        objGuia.Dispose();
                        break;

                }

        }
        return strDatosAnexo.Normalize();

    }

    #endregion

}