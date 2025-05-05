using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using libFunciones;
using nsSERUV;
using System.Web.Script.Serialization; 

public partial class Administracion_Guia_SAAGUIAERH : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    // Variables que vendran por URL o por sesión
                    //hf_idUsuario.Value = "4";

                    // Variables que vendran por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();

                }
            }
        }
    }

    #region Método para Insertar, Modificar y Actualizar una Guía
    /// <summary>
    /// Función que Inserta, Modifica y Actualiza una Guía en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objGuias">Objeto de Datos de la clase Guias</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Actualizar_Guia(clsGuia objGuia)
    {
        int blnResultado = 0;

        blnResultado = objGuia.fGetGuiasActualizar();

        return blnResultado;
    }

    #endregion

    #region Método para saber si existe una Guía Vigente
    /// <summary>
    /// Función que Inserta, Modifica y Actualiza una Guía en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static bool Guias_Activas()
    {
        bool blnResultado = false;
        clsGuia objProcER = new clsGuia();

        if (objProcER.fGetGuiasActivas(objProcER))
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

    #region Método para saber si la Guía actual esta Vigente o si existe ya alguna vigente
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

    #region Método para Actualizar la Vigencia de la Guía
    /// <summary>
    /// Función para Actualizar la Vigencia de la Guía en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objGuias">Objeto de Datos de la clase Guias</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Guias</returns>
    [WebMethod(EnableSession = true)]
    public static string Actualizar_Vigencia(clsGuia objGuia)
    {
        //int blnResultado = 0;
        string strDatosAnexo = string.Empty;

        if (objGuia.strAccion == "CAMBIAR_VIGENCIA2")
        {
            if (objGuia.chrIndVigente.ToString() == "N")
            {

                if (objGuia.fGetValidaProcesosAnexos())
                {
                    //se validó y se cambio la vigencia de S -> N del registro actual
                    //objGuia.fGetActualizarTodo();
                    objGuia.strRespuesta = objGuia.fGetGuiasActualizar().ToString();
                    
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
                            objGuia.strRespuesta = "2";
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
                {   //no se validó, solo se cambia la fecha del registro actual
                    objGuia.chrIndVigente = 'S';
                    //objGuia.fGetActualizarTodo();
                    objGuia.strRespuesta = objGuia.fGetGuiasActualizar().ToString();

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
                            objGuia.strRespuesta = "2";
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
                objGuia.strRespuesta = objGuia.fGetGuiasActualizar().ToString();
                
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
                        objGuia.strRespuesta = "2";
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

        if (objGuia.strAccion == "FECHA_VIGENCIA2")
        {
           // if (objGuia.fGetActualizarTodo())
            objGuia.strRespuesta = objGuia.fGetGuiasActualizar().ToString();
            
                //solo se cambio la fecha y se crea histórico
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
                objGuia.strRespuesta = "2";
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

    #region Método para Validar el Código de la Guía
    /// <summary>
    /// Función para Validar que el Codigo de la Guía no se repita en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objGuias">Objeto de Datos de la clase Guias</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Validar_Codigo(clsGuia objGuia)
    {
        int blnResultado = 0;

        blnResultado = objGuia.fGetCodigoGuia();

        return blnResultado;
    }

    #endregion

}