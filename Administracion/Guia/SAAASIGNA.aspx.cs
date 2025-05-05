using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using nsSERUV;

public partial class Administracion_Guia_SAAASIGNA : System.Web.UI.Page
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

    #region pGetBloques
    /// <summary>
    /// Función que obtiene el listado de bloques asignados al anexo seleccionado.
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nIdApartado">Id del anexo</param>
    /// <returns>Una cadena con los bloques asignados al anexo</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetBloques(int nIdAnexo) {
        string strCadena = string.Empty;
        bool blnRespuesta = false;
        clsAplica objAplica = new clsAplica();
        objAplica.strAccion = "ANEXAPLICA";
        objAplica.idAnexo = nIdAnexo;
        try
        {
            blnRespuesta = objAplica.fGetAplica2();
            if (blnRespuesta)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                strCadena += serializer.Serialize(objAplica);
            }
            else {
                strCadena = "0";
            }
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally { 
        
        }
        return strCadena.Normalize();
    }
    #endregion

    #region pGetDependencias
    /// <summary>
    /// Función que obtiene el listado de dependencias asociadas al bloque seleccionado y el indicador si aplica o no la dependencia al anexo.
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nIdAplica">Id aplica (bloque)</param>
    /// <param name="nIdAnexo">Id del anexo</param>
    /// <returns>Una cadena con el listado de dependencias asociadas al bloque seleccionado y el indicador si aplica o no la dependencia al anexo.</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDependencias(int nIdAplica, int nIdAnexo)
    {
        string strCadena = string.Empty;
        int intRespuesta = 0;
        clsDepcia objDepcia = new clsDepcia();
        try
        {
            intRespuesta = objDepcia.fObtener_DependenciasBloque(nIdAplica, nIdAnexo);
            if (intRespuesta != -1)
            {
                if (intRespuesta != 0)
                {
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    strCadena += serializer.Serialize(objDepcia.laDepcia);
                }
                else {
                    return strCadena = "0";
                }
            }
            else {
                return strCadena = "-1";
            }
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

    #region pActualizaAsignacion
    /// <summary>
    /// Función que actualiza la asignación del anexo a la dependencia.
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nidAplica">Id aplica (bloque)</param>
    /// <param name="nIdDepcia">Número de la dependencia</param>
    /// <param name="nIdAnexo">Id del anexo</param>
    /// <param name="cIndActivo">Indicador de activo</param>
    /// <returns>Un entero que indica si se realizó correctamente la asignación del anexo a la dependencia.</returns>
    [WebMethod(EnableSession = true)]
    public static int pActualizaAsignacion(int nidAplica, int nIdDepcia, int nIdAnexo, char cIndActivo)
    {
        int intRespuesta= 0;
        try
        {
            clsAplica objAplica = new clsAplica();
            intRespuesta = Convert.ToInt32(objAplica.fActualizaAplicDepcia(nidAplica, nIdDepcia, nIdAnexo, cIndActivo));
        }
        catch
        {
            throw;
        }
        return Convert.ToInt32(intRespuesta);
    }
    #endregion

}