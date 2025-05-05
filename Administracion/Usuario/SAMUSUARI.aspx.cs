using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Administracion_SAMUSUARI : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page_Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    #endregion

    #region Pinta_Grid
    /// <summary>
    /// Función que devuelve los datos del usuario para mostrarlos en el grid.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <returns>Cadena con los datos de los usuarios registrados en el sistema.</returns>
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
        catch(Exception ex)
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

    #region
    // FORMA ANTERIOR DE CREAR UNA CADENA EN FORMATO JSON
    //[WebMethod(EnableSession = true)]
    //public static string pPinta_Grid()
    //{
    //    string strCadena = string.Empty;
    //    clsUsuario objUsuario = new clsUsuario();

    //    if (objUsuario.fGetUsuarios())
    //    {
    //        strCadena += "{'resultado':'1','mensaje':'Obtiene Usuarios','datos':[{'col1': '', 'col2': 'NOMBRE'}";
    //        foreach (clsUsuario procER in objUsuario.laRegresaDatos)
    //        {
    //            strCadena += ",{";
    //           // strCadena += "'intNusuario':'" + procER.nUsuario.ToString() + "',";
    //            strCadena += "'intNumPersonal':'" + procER.intNumPersonal.ToString() + "',";
    //            strCadena += "'chrIndActivo':'" + procER.chrIndActivo.ToString() + "',";
    //            strCadena += "'strCorreo':'" + procER.strCorreo.ToString() + "',";
    //            strCadena += "'strDependencia':'" + procER.strDependencia.ToString() + "',";
    //            strCadena += "'strNombre':'" + procER.strNombre.ToString() + "',";
    //            strCadena += "'strPuesto':'" + procER.strPuesto.ToString() + "',";
    //            strCadena += "}";
    //        }

    //        strCadena += "]}";
    //    }
    //    else
    //    {
    //        strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
    //    }
    //    return strCadena.Normalize();
    //}
    #endregion

    #region ValidaProceso
    /// <summary>
    /// Función que valida si un usuario se encuentra en un proceso activo.
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nidProceso">Id del proceso</param>
    /// <returns>Entero que indica si el usuario se encuentra en un proceso o no (0 - No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int ValidaProceso(int nidProceso)
    {
        int intRespuesta = 0;
        try
        {
            clsProceso objProceso = new clsProceso();
            intRespuesta = Convert.ToInt32(objProceso.fVerificaProcesoActivo(nidProceso));
        }
        catch
        {
            
        }
        return intRespuesta;
    }
    #endregion

    #region ModificaEdo
    /// <summary>
    /// Función que modifica el estado de un usuario.
    /// Autor: L.I Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nidUsuario">Id del usuario</param>
    /// <param name="strIndActivo">Indicador si se desactivará o inactivará</param>
    /// <returns>Un entero indicando si se realizó correctamente la transacción (0 - No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int ModificaEdo(int nidUsuario, string strIndActivo)
    {
        int respuesta = 0;
        try
        {
            clsUsuario objUsuario = new clsUsuario();
            respuesta = Convert.ToInt32(objUsuario.fActiva_Desactiva_Usuario(nidUsuario, strIndActivo));

        }
        catch
        {
            throw;
        }
        return respuesta;
    }
    #endregion

}