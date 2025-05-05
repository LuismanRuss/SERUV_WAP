using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;
using libFunciones;

/// Autor: L.I. Jesús Montero Cuevas 

public partial class Administracion_Administracion_General_Procesos_ER_SAACASUOB : System.Web.UI.Page
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


    #region fPinta_Grid
    /// <summary>
    /// MÉTODO QUE REGRESA LOS DATOS DEL PROCESO, ASI COMO LA LISTA DE LOS USUARIOS QUE SE MUESTRAN EN EL GRID
    /// </summary>
    /// <param name="idproceso">ID del proceso que se selecciona en la forma de procesos</param>
    /// <returns></returns>
    [WebMethod(EnableSession=true)]    
    public static string fPinta_Grid(int idproceso)
    {
        clsProcesoER objProcER = new clsProcesoER();
        string strCadena = string.Empty;
        try
        {
            objProcER.fGetSujetosObligados(idproceso);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += "{'datos':[" + serializer.Serialize(objProcER.laRegresaDatos).Normalize() + "," + serializer.Serialize(objProcER.laRegresaDatos2).Normalize() + "]}";
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objProcER.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion


    #region CambSujObl
    /// <summary>
    ///  MÉTODO QUE GUARDA AL NUEVO SUJETO OBLIGADO DE LA DEPENDENCIA
    /// </summary>
    /// <param name="nIdParticipante">ID del partcipante</param>
    /// <param name="idProceso">ID del proceso ER</param>
    /// <param name="idUsuarioNuevo">ID del usuario que se asignará como sujeto obligado de la dependencia</param>
    /// <param name="nIdUsuario">ID del usuario logueado</param>
    /// <param name="idDependencia">Clave de la dependencia</param>
    /// <param name="idPuesto">Clave del puesto</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static int CambSujObl(int nIdParticipante, int idProceso, int idUsuarioNuevo, int nIdUsuario, int idDependencia, int idPuesto)
    {
        int nRespuesta = 0;
        var objProcER = new clsProcesoER();
        try
        {
            nRespuesta = Convert.ToInt32(objProcER.fCambSujOb(nIdParticipante, nIdUsuario, idProceso, idUsuarioNuevo, idDependencia, idPuesto));
        }
        catch (Exception)
        {

        }
        finally
        {
            objProcER.Dispose();
        }
        return nRespuesta;
    }
    #endregion
}