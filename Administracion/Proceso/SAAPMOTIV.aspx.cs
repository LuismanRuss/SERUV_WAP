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

public partial class Administracion_Proceso_SAAPMOTIV : System.Web.UI.Page
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
                    // hf_idUsuario.Value = "4";

                    // Variables que vendran por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();


                }
            }
        }

    }

    #region Método para Mostrar la Lista de Motivos
    /// <summary>
    /// Función para Mostrar la Lista de Motivos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la Clase Motivos</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto de Motivos</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosMotivos(clsMotivo objMotivos)
    {
        string strCadena = string.Empty;

        String Motivo = objMotivos.strACCION;

        if (objMotivos.fObtener_MotivoProceso(Motivo))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena = serializer.Serialize(objMotivos);
            objMotivos.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Método para Inactivar o Eliminar un Motivo
    /// <summary>
    /// Función para Inactivar o Eliminar un Motivo
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos de la Clase Motivos</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int fGetMotivosElimina(clsMotivo objMotivos)
    {

        int intResultado = 0;

        intResultado = objMotivos.fGetMotivosElimina();

        return intResultado;
    }

    #endregion

}