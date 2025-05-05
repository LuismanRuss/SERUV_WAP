using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using nsSERUV;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Administracion_Proceso_SAAPPEREX : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession)
            {
                using (clsValidacion objValidacion = new clsValidacion())
                {
                    // Variables que vendrán por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    //idUsuario = int.Parse((objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString());

                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                    hf_indicadorPagina.Value = Request.QueryString["pagina"];
                }
            }
        }
    }


    #region fGuardaPerExt
    /// <summary>
    /// método que guarda los periodos extemporáneos de una dependencia
    /// </summary>
    /// <param name="nIdParticipante">ID del participante</param>
    /// <param name="sJustificacion">justificación del periodo extemporaneo</param>
    /// <param name="idProcExtem"></param>
    /// <param name="sFeIn">fecha inicial</param>
    /// <param name="sFeFIn">fecha final</param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fGuardaPerExt(int nIdParticipante, string sJustificacion, int idProcExtem, string sFeIn, string sFeFIn, int nIdUsuario)
    {
        string sRespuesta = "";
        clsParticipante objPart = new clsParticipante();
        try
        {
            sRespuesta = objPart.fGuarPerExt(sJustificacion, nIdParticipante, idProcExtem, sFeIn, sFeFIn, nIdUsuario);
        }
        catch
        {
            throw;
        }
        finally
        {
            objPart.Dispose();
        }
        return sRespuesta;
    }
    #endregion


    #region fGetDatos
    /// <summary>
    ///  método que regresa los periodos extemporáneos de un participante
    /// </summary>
    /// <param name="idParticipante">ID del participante</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string fGetDatos(int idParticipante)
    {
        clsParticipante objPart = new clsParticipante();
        string strCadena = string.Empty;
        try
        {
            objPart.fGetPeriodosExtemporaneos(idParticipante);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPart.laRegresaDatos).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objPart.Dispose();
        }
        return strCadena;
    }
    #endregion
}