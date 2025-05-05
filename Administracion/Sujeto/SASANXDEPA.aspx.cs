using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;
using libFunciones;

public partial class SASANXDEPA : System.Web.UI.Page
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
              //  hf_idUsuario.Value = "4"; 
            }
        }
    }

    #region guardaJustificacion
    /// <summary>
    /// Método utilizado para excluir un anexo
    /// Autor: Ma. Guadalupe Dominguez Julián
    /// </summary>
    /// <param name="objAnexo">Objeto con los datos del anexo a excluir</param>
    /// <returns>identificador entero que indica éxito ó error</returns>
    [WebMethod(EnableSession = true)]
    public static int guardaJustificacion(clsAnexo objAnexo)
    {

        string cadena = string.Empty;
        int intResultado;

        intResultado = objAnexo.pGuarda_Justifi_anexo();


        return intResultado;
    }
    #endregion

    #region incluirAnexo
    /// <summary>
    /// Método utilizado para incluir un anexo
    /// Autor: Ma. Guadalupe Dominguez Julián
    /// </summary>
    /// <param name="objAnexo">Objeto con los datos del anexo a incluir</param>
    /// <returns>identificador entero que indica éxito ó error</returns>
    [WebMethod(EnableSession = true)]
    public static int incluirAnexo(clsAnexo objAnexo)
    {

        string cadena = string.Empty;
        int intResultado=1;

        intResultado = objAnexo.pGuarda_Incluir_anexo();


        return intResultado;
    }
    #endregion


}