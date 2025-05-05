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

public partial class Administracion_Usuario_SAMDEPTOS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #region fObtieneDepartamentos
    /// <summary>
    /// Función que obtiene el listado de dependencias que no están en el catálogo institucional
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con el listado de la dependencias</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneDepartamentos()
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();
        try
        {
            objDepcia.fObtieneDepartamentos();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
        }
        catch
        {

        }
        return strCadena.Normalize();
    }
    #endregion
}