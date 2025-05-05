using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using nsSERUV;
using libFunciones;
using System.Web.Services;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Cierre_SCSCIEPRO : System.Web.UI.Page
{
   private static int nIdUsuario = 0;//variable que contiene el ID del usuario logueado

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
                    nIdUsuario = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0);
                }
            }
        }
    }

    #region
    /// <summary>
    /// función que regresa los procesos en los que un usuario está como supervisor
    /// </summary>
    /// <param name="nIdUsuario">ID del usuario</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pGetProceso(int nIdUsuario)
    {
        clsCierre objCierre = new clsCierre();
        string strCadena = string.Empty;
        try
        {
            objCierre.fGetProcesos(nIdUsuario);
            //esta parte de abajo serializa la lista que regresa la consulta y la convierte a formato JSON
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objCierre.laRegresaDatos).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objCierre.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region
    /// <summary>
    /// función que regresa el avance del proceso, sus dependencias y su respectivo avance
    /// </summary>
    /// <param name="nIdProceso">ID del proceso</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int nIdProceso)
    {
        clsSupervision objSup = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            objSup.fGetAvanceProceso(nIdProceso, "CIERRE", nIdUsuario);
            //esta parte de abajo serializa la lista que regresa la consulta y la convierte a formato JSON
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
           strCadena += "{'datos':[" + serializer.Serialize(objSup.laAvanceGeneral).Normalize() + "," + serializer.Serialize(objSup.laRegresaDatos).Normalize() + "]}";//concateno dos listas para regresarlas en un solo JSON
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objSup.Dispose();
        }
        return strCadena;
    }
    #endregion
}