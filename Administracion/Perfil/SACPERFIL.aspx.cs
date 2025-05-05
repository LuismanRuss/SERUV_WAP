using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_Perfil_SACPERFIL : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {

                    
            }
        }
    }

    #region Pinta_GridP
    /// <summary>
    /// Función que devuelve los usuarios con el perfil seleccionado.
    /// Autor: Bárbara Vargas Vera.
    /// Parámetro: id del perfil
    /// </summary>
    

    [WebMethod(EnableSession = true)]
    public static string Pinta_GridP(int idPerfil)
    {
        clsUsuario objUsuario = new clsUsuario();
        //int idPerf = idPerfil;
        string strCadena = string.Empty;

        try
        {
            objUsuario.fGetUsrPerfil(idPerfil);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            
        }
        return strCadena.Normalize();
    }
    #endregion


}