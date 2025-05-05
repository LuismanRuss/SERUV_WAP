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

public partial class Administracion_Administracion_General_Procesos_ER_SAAPRCENTREC : System.Web.UI.Page
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
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();
                }
            }
        }
    }


    #region pPinta_Grid
    /// <summary>
    ///  FUNCIÓN QUE REGRESA LOS PROCESOS ENTREGA RECEPCIÓN
    /// </summary>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid()
    {
        clsProcesoER objProcER = new clsProcesoER();
        string strCadena = string.Empty;
        try
        {
            objProcER.fGetPeriodosEntrega();
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

    #region fModificaEdo
    /// <summary>
    /// FUNCIÓN QUE CAMBIA EL ESTADO DE UN PROCESO
    /// </summary>
    /// <param name="nIdProceso">ID del proceso seleccionado</param>
    /// <param name="strIndActivo">Indicador activo-inactivo </param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static int fModificaEdo(int nIdProceso, string strIndActivo, int nIdUsuario)
    {
        int nRespuesta = 0;
        clsProcesoER objProcER = new clsProcesoER();
        try
        {
            nRespuesta = Convert.ToInt32(objProcER.fActiva_Desactiva_Periodo(nIdProceso, strIndActivo, nIdUsuario));
        }
        catch
        {
            throw;
        }
        finally
        {
            objProcER.Dispose();
        }
        return nRespuesta;
    }
    #endregion


    #region fEliminaProc
    /// <summary>
    /// FUNCIÓN QUE ELIMNA EL PROCESO ENTREGA RECEPCIÓN
    /// </summary>
    /// <param name="nIdProceso">ID del proceso</param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static int fEliminaProc(int nIdProceso, int nIdUsuario)
    {
        int nRespuesta = 0;
        clsProcesoER objProcER = new clsProcesoER();
        try
        {  
            nRespuesta = Convert.ToInt32(objProcER.fElimina_Periodo(nIdProceso, nIdUsuario));
        }
        catch
        {
            throw;
        }
        finally
        {
            objProcER.Dispose();
        }
        return nRespuesta;
    }
    #endregion
}