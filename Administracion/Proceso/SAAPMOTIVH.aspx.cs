using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using libFunciones;
using nsSERUV;
using System.Web.Script.Serialization; 

public partial class Administracion_Proceso_SAAPMOTIVH : System.Web.UI.Page
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

    #region Método para Insertar un Motivo
    /// <summary>
    /// Función que Inserta un Motivo en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la Clase Motivos</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Insertar_Motivos(clsMotivo objMotivos)
    {
        int blnResultado = 0;

        blnResultado = objMotivos.fGetMotivosActualizar();

        return blnResultado;
    }

    #endregion

    #region Método para Actualizar un Motivo
    /// <summary>
    /// Función para Actualizar un Motivo en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la Clase Motivos</param>
    /// <returns>Cadena en formato JSON con los datos de los Motivos</returns>
    [WebMethod(EnableSession = true)]
    public static string Actualizar_Motivos(clsMotivo objMotivos)
    {
        //bool blnResultado = false;
        string strDatosAnexo = string.Empty;

        objMotivos.strResp = objMotivos.fGetMotivosActualizar().ToString();

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
        strDatosAnexo = serializer.Serialize(objMotivos);
        objMotivos.Dispose();
        //blnResultado = true;


        return strDatosAnexo.Normalize();
    }

    #endregion

    #region Método para verificar si el Motivo es valido para Insertar o Actualizar
    /// <summary>
    /// Función para verificar si el Motivo es Valido para Insertar o Actualizar
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la Clase Motivos</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Valida_Motivos(clsMotivo objMotivos)
    {
        int blnResultado = 0;

        blnResultado = objMotivos.fGetValidaMotivo();

        return blnResultado;
    }

    #endregion
}