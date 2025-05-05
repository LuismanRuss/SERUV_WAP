using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using libFunciones;
using System.Web.Script.Serialization;

public partial class Administracion_Proceso_SASPARTICA : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (PreviousPage != null)
            {

            }
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

    #region pObtieneDatos
    /// <summary>
    /// Función que obtiene la lista de dependencias de un proceso
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="nIdProceso">Identificador del proceso</param>
    /// <param name="arridDepcias">Arreglo de identificador de dependencias</param>
    /// <param name="idUsuario">Identificador de usuario</param>
    /// <returns>Datos de usuarios Administradores y sin perfil</returns>

    [WebMethod(EnableSession = true)]
    public static string pObtieneDatos(int nIdProceso, string arridDepcias, int idUsuario)
    {
        clsProcesoER objProcER = new clsProcesoER();
        string strCadena = string.Empty;
        try
        {
            objProcER.fConsultaUsuarios(nIdProceso, arridDepcias, idUsuario);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objProcER.laRegresaDatos).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objProcER.Dispose();
        }
        return strCadena;
    }

    #endregion


    #region pActualizaDepcia
    /// <summary>
    /// Función que actualiza la asignación de supervisores
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="nIdProceso">Identificador de proceso</param>
    /// <param name="sarrIdDepcia">Arreglo de identificador de Dependencias</param>
    /// <param name="sSuperSAF">Indicador S/N supervisor SAF</param>
    /// <param name="sSuperCG">Indentificador S/N supervisor CG</param>
    /// <param name="cIndAplica">Identificador S/N activo</param>
    /// <param name="idUsuario">Identificador de usuario</param>
    /// <returns>0 en el caso de ocurrir un error y 1 en el caso de éxito</returns>
    [WebMethod(EnableSession = true)]
    public static string pActualizaDepcia(int nIdProceso, string sarrIdDepcia, char sSuperSAF, char sSuperCG, char sSuperSU, char cIndAplica, int idUsuario)
    {
        string cadena = string.Empty;      
        clsProcesoER us = new clsProcesoER();    
        try
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();          
            cadena += serializer.Serialize(us.pActualiza_aplica_Depcia(nIdProceso, sarrIdDepcia, sSuperSAF, sSuperCG, sSuperSU, cIndAplica, idUsuario));
        }
        catch (Exception)
        {
            throw;
        }      
        return cadena.Normalize();
    }
    #endregion
}