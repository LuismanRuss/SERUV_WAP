using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Cierre_SCCUSUARIO : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    #region Método para Pintar datos en el Grid
    /// <summary>
    /// Autor: Bárbara Vargas Vera
    /// Objetivo:  Función donde se realiza la búsqueda de los usuarios a desplegar en la tabla
    /// </summary>
    [WebMethod(EnableSession = true)]
    public static string Pinta_Grid()
    {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;

        try
        {
            objUsuario.fGetUsuarios();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = 500000000;
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objUsuario.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion

}