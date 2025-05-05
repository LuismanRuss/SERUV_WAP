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

public partial class Administracion_Guia_SAAAPARTA : System.Web.UI.Page
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
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();


                }
            }
        }

    }

    #region Metodo para Mostrar la Lista de Apartados
    /// <summary>
    /// Función que nos trae la Lista de Apartados para mostrar en el Grid
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objApartados">Objeto de Datos de la clase Apartados</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Apartados</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosApartados(clsApartado objApartados)
    {
        string strCadena = string.Empty;

        if (objApartados.pGetListaApartados(objApartados))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena = serializer.Serialize(objApartados);
            objApartados.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Metodo para Eliminar o Inactivar un Apartado
    /// <summary>
    /// Función para Eliminar o Inactivar un Apartado de la BD
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objApartados">Objeto de Datos de la clase Apartados</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int fEliminar_Apartado(clsApartado objApartados)
    {

        int intResultado = 0;

        intResultado = objApartados.fGetApartadosElimina();

        return intResultado;
    }

    #endregion
}