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

public partial class Cierre_SCSCIEDEP : System.Web.UI.Page
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
            }
        }
    }

    #region
    /// <summary>
    /// función que regresa los datos generales de la dependencia  y sus anexos
    /// </summary>
    /// <param name="idParticipante">ID del particiapnte</param>
    /// <param name="idUsuario">ID del usuario logueado</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pPinta_Grid(int idParticipante, int idUsuario)
    {
        clsSupervision objSup = new clsSupervision();
        string strCadena = string.Empty;
        try
        {
            objSup.GetAvanceDepcia(idParticipante, idUsuario);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            //la siguiente linea concatena 4 listas, datos generales de la dependencia, apartados con sus anexosm enlaces operativos y enlaces operativos receptores
            strCadena += "{'datos':[" + serializer.Serialize(objSup.laAvanceDepcia).Normalize() + "," + serializer.Serialize(objSup.laRegresaDatos).Normalize() + "," + serializer.Serialize(clsSupervision.laEnlaceOperativo).Normalize() + "," + serializer.Serialize(clsSupervision.laEnlaceOperativoReceptor).Normalize() + "]}";
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

    #region
    /// <summary>
    /// función que cierra el proceso de la depemdencia
    /// </summary>
    /// <param name="idProceso">ID del proceso</param>
    /// <param name="idParticipante">ID del participante</param>
    /// <param name="strOpcion"></param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static int fCerrarProceso(int idProceso, int idParticipante, string strOpcion)
    {
        clsCierre objCierre = new clsCierre();
        int resp = 0;
        try
        {
            if (strOpcion == "CDEPCIA")//cierra el proceso de la dependencia
            {
                resp = int.Parse(objCierre.fCerrarProceso(idProceso, idParticipante, "CDEPCIA").ToString());//le asigno a la variable resp la respuesta que traigo del procedimiento almacenado que cierra el proceso
            }
            else//esta ya no se ocupa actualmente, servia para cerrar el proceso en general
            {
                resp = int.Parse(objCierre.fCerrarProceso(idProceso, idParticipante, "CPROCESO").ToString());
            }
        }
        catch (Exception)
        {
            throw;
        }
        return resp;
    }
    #endregion
}