using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_SAMPERFIL : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #region Pinta_Grid
    /// <summary>
    /// Función que devuelve los perfiles existentes en la BD.
    /// Autor: Bárbara Vargas Vera.
    /// </summary>
    
    [WebMethod(EnableSession = true)]
    public static string Pinta_Grid()
    {
        clsPerfil objPerfil = new clsPerfil();
        string strCadena = string.Empty;
        try
        {
            objPerfil.fGetPerfilesConAdm();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objPerfil.lstPerfiles);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objPerfil.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion

}