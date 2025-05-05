using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using libFunciones;
using nsSERUV;

public partial class Administracion_SAAGUIAER : System.Web.UI.Page
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


    #region Metodo para Mostrar la Lista de Guías Activas
    /// <summary>
    /// Función que consulta las Guías y nos devuelve la Lista de Guías 
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objGuias">Objeto de Datos de la clase Guias</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Guias</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosGuias(clsGuia objGuias)
    {
        string strCadena = string.Empty;
        if (objGuias.fGetGuiasEntrega())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena = serializer.Serialize(objGuias);
            objGuias.Dispose();
        }
        return strCadena.Normalize();
    }

    #endregion

    #region Metodo para cambiar la Vigencia de la Guía
    /// <summary>
    /// Función que cambia la Vigencia de la Guía 
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="IdGuia">ID de la Guía</param>
    /// <param name="chrIndicador">Indicador de estado de la Guía</param>
    /// <param name="strAccion">Acción que se usara en los Procedimientos Almacenados</param>
    /// <param name="intUsuario">Número del Usuario que Actualizó</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    
    [WebMethod(EnableSession = true)]
    public static int fEstado_Guia(int IdGuia, char chrIndicador, string strAccion, int intUsuario)
    {
        int intResultado = 0;
        clsGuia objProcER = new clsGuia();

        objProcER.idGuiaER = IdGuia;
        objProcER.chrIndActivo = chrIndicador;
        objProcER.strAccion = strAccion;
        objProcER.intUsuario = intUsuario;

        intResultado = objProcER.fGetGuiasdeProcesoActivas(objProcER);

        return intResultado;
    }

    #endregion

    #region Metodo para Eliminar o Inactivar la Guía
    /// <summary>
    /// Función que Elimina o Inactiva una Guía de la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="IdGuia">ID de la Guía</param>
    /// <param name="strAccion">Acción que se usará en los Procedimientos Almacenados</param>
    /// <param name="intUsuario">Número del Usuario que Actualizó</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
        public static int fEliminar_Guia(int IdGuia, string strAccion, int intUsuario)
        {
            int intResultado = 0;
            clsGuia objProcER = new clsGuia();

            objProcER.idGuiaER = IdGuia;
            objProcER.strAccion = strAccion;
            objProcER.intUsuario = intUsuario;

            intResultado = objProcER.fGetGuiasdeProcesoActivas2(objProcER);

            return intResultado;
        }

    #endregion
}