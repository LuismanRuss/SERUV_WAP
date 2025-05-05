using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_Proceso_SAMPERPRO : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    #endregion

    #region Pinta_Grid
    /// <summary>
    /// Función que devuelve el listado de usuarios.
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nIdProceso">Id del proceso</param>
    /// <returns>Una cadena con la lista de usuarios con sus respectivos perfiles en el proceso seleccionado</returns>
    [WebMethod(EnableSession = true)]
    public static string Pinta_Grid(int nIdProceso)
    {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;

        try
        {
            objUsuario.fGetUsuariosProcesoDisp(nIdProceso);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter()});
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