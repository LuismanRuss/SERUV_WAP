using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using libFunciones;
using nsSERUV;

public partial class Administracion_Guia_SAAANEXOSH : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    //Variables que vendran por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();

                }
            }
        }

    }

    #region Muestra la Lista de las Dependencias del Catalogo de APEAPLICA
    /// <summary>
    /// Función que nos trae la Lista de las Dependencias del Catálogo de APEAPLICA
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAplica">Objeto de Datos de la clase Aplica</param>
    /// <returns>Cadena en formato JSON con los datos del Objecto Aplica</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosAplica(clsAplica objAplica)
    {
        string strCadena = string.Empty;
        if (objAplica.fGetAplica())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena = serializer.Serialize(objAplica);
            objAplica.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Muestra la Lista de las Dependencias Checadas Previamente
    /// <summary>
    /// Función que nos trae la Lista de las Dependencias Checadas Previamente
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAplica">Objeto de Datos de la clase Aplica</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Aplica</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosAplica2(clsAplica objAplica)
    {
        string strCadena = string.Empty;
        if (objAplica.fGetAplica2())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena = serializer.Serialize(objAplica);
            objAplica.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Metodo para Modificar y Actualizar un Anexo
    /// <summary>
    /// Función que Modifica y Actualiza un Anexo
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la clase Anexo</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Anexo</returns>
    [WebMethod(EnableSession = true)]
    public static string Actualizar_Anexos2(clsAnexo objAnexos)
    {
        string strDatosAnexo = string.Empty;

             objAnexos.strResp = objAnexos.fGetAnexosActualizar2().ToString();
        
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosAnexo = serializer.Serialize(objAnexos);
            objAnexos.Dispose();
            //blnResultado = true;

        return strDatosAnexo.Normalize();
    }

    #endregion

    #region Metodo para Insertar un Anexo
    /// <summary>
    /// Función para Insertar un Anexo en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la clase Anexo</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Actualizar_Anexos4(clsAnexo objAnexos)
    {
        int blnResultado = 0;

        blnResultado = objAnexos.fGetAnexosActualizar4();

        return blnResultado;
    }

    #endregion

    #region Metodo para Validar el Código y el Orden del Anexo
    /// <summary>
    /// Funcion para Validar el Código y el Orden del Anexo
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la clase Anexo</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Validar_Codigo(clsAnexo objAnexos)
    {
        int blnResultado = 0;

        blnResultado = objAnexos.fGetCodigoAnexo();

        return blnResultado;
    }

    #endregion

    #region Metodo para Verificar si el Acta E-R ya esta asignado o si esta asignado al Anexo actual
    /// <summary>
    /// Funcion para Verificar si el Acta E-R ya esta asignado o si esta asignado al Anexo actual
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la clase Anexo</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Verifica_Acta(clsAnexo objAnexos)
    {
        int blnResultado = 0;

        blnResultado = objAnexos.fGetVerificaActa();

        return blnResultado;
    }

    #endregion

}