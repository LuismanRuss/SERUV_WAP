using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_SARUSRDEP : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page_Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    #endregion

    #region pLlenaSelect
    /// <summary>
    /// Función que devuelve la lista de dependencias.
    /// Autor: L.I Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con la lista de todas las dependencias.</returns>
    [WebMethod(EnableSession = true)]
    public static string pLlenaSelect() {
        clsDepcia objDepcia = new clsDepcia();
        string strCadena = string.Empty;
        try
        {
            objDepcia.fObtener_Dependencia();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally {
            //objDepcia.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region pPintaGrid
    /// <summary>
    /// Función que devuelve la lista de usuarios asociados a la dependencia seleccionada.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nIdDepcia">Número de la dependencia</param>
    /// <returns>Una cadena con la lista de los usuarios asociados a esa dependencia.</returns>
    [WebMethod(EnableSession = true)]
    public static string pPintaGrid(int nIdDepcia) {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;
        try
        {
            objUsuario.fGetUsuarios_por_dependencia(nIdDepcia);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally {
            objUsuario.Dispose();
        }
        return strCadena;
    }
    #endregion

}