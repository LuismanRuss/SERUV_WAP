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

public partial class Administracion_Guia_SAAANEXOS : System.Web.UI.Page
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

    #region Metodo para Mostrar la Lista de Anexos
    /// <summary>
    /// Función que nos trae la Lista de Anexos de la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos del Anexo</param>
    /// <returns>Cadena en formato JSON con los datos de los Anexos</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosAnexos(clsAnexo objAnexos)
    {
        string strCadena = string.Empty;

        if (objAnexos.fGetAnexos())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena = serializer.Serialize(objAnexos);
            objAnexos.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Metodo para Eliminar o Inactivar un Anexo
    /// <summary>
    /// Función que Elimina o Inactiva un Anexo de la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objAnexos">Objeto de Datos del Anexo</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int fEliminar_Anexos(clsAnexo objAnexos)
    {

        int intResultado = 0;

        intResultado = objAnexos.fGetAnexosElimina();

        return intResultado;
    }

    #endregion
}