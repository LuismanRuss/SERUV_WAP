using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using libFunciones;
using nsSERUV;

public partial class Monitoreo_SMABITACO : System.Web.UI.Page
{
    #region Page_Load
    /// <summary>
    /// Page_Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
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
    #endregion

    #region fObtieneApartados
    /// <summary>
    /// Función que devuelve los apartados con sus correspondientes anexos.
    /// Autor: L.I. Emmnauel Méndez Flores.
    /// </summary>
    /// <param name="nIdParticipante">Id del participante</param>
    /// <returns>Una cadena con los apartados y sus correspondientes anexos.</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneApartados(int nIdParticipante)
    {
        string strCadena = string.Empty;
        clsApartado objApartado = new clsApartado();
        objApartado.idParticipante = nIdParticipante;
        objApartado.strAccion = "OBTIENE_APARTADOS_ANEXOS";
        objApartado.fObtieneApartados();
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
        strCadena += serializer.Serialize(objApartado.liApartados);
        return strCadena;
    }
    #endregion

    #region fGuardarBitacora
    /// <summary>
    /// Función que guarda la bitácora de la dependencia.
    /// </summary>
    /// <param name="nProceso">Id del proceso</param>
    /// <param name="nAnexo">Id del anexo</param>
    /// <param name="nApartado">Id del apartado</param>
    /// <param name="nDepcia">Número de la dependencia</param>
    /// <param name="nRecomenda">Id de la recomendación</param>
    /// <param name="sObservaciones">Observaciones de la bitácora</param>
    /// <param name="iAvance">Porcentaje del avance</param>
    /// <param name="nUsuarioSup">Id del usuario que guarda la bitácora</param>
    /// <returns>Un entero indicando que se realizó correctamente la operación</returns>
    [WebMethod(EnableSession = true)]
    public static int fGuardarBitacora(int nProceso, int nAnexo, int nApartado, int nDepcia, int nRecomenda ,string sObservaciones, float iAvance, int nUsuarioSup)
    {
        int intResp = 0;
        clsBitacora objBitacora = new clsBitacora();
        objBitacora.idFKProceso = nProceso;
        objBitacora.nFKDepcia = nDepcia;
        objBitacora.idFKApartado = nApartado;
        objBitacora.idFKAnexo = nAnexo;
        objBitacora.idRecomenda = nRecomenda;
        objBitacora.sObervaciones = sObservaciones;
        objBitacora.iAvance = iAvance;
        objBitacora.nUsuarioSup = nUsuarioSup;
        objBitacora.strAccion = "GUARDA_BITACORA";

        try
        {
            intResp = objBitacora.fGuardarBitacora();
        }
        catch { 
        
        }
        return intResp;
    }
    #endregion

    #region fObtieneRecomendaciones
    /// <summary>
    /// Función que devuelve el listado de las recomendaciones.
    /// L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con la lista de las recomendaciones.</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneRecomendaciones() {
        string strResp = string.Empty;
        clsBitacora objBitacora = new clsBitacora();
        objBitacora.strAccion = "SELECCIONA_RECOMENDACIONES";
        try {
            objBitacora.fObtieneRecomendaciones();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strResp += serializer.Serialize(objBitacora.lstRegresaDatos);
        }
        catch {
            strResp = string.Empty;
        }
        return strResp.Normalize();
    }
    #endregion

    #region fObtieneObservaciones
    /// <summary>
    /// Función que devuelve la bitácora de la dependencia.
    /// L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="nProceso">Id del proceso</param>
    /// <param name="nDepcia">Número de la dependencia</param>
    /// <returns>Una cadena con los datos de la bitácora.</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneObservaciones(int nProceso, int nDepcia)
    {
        string strCadena = string.Empty;
        clsBitacora objBitacora = new clsBitacora();
        objBitacora.idFKProceso = nProceso;
        objBitacora.nFKDepcia = nDepcia;
        objBitacora.strAccion = "OBTIENE_OBSERV";
        try {
            objBitacora.fObtieneObservaciones();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objBitacora.lstRegresaDatos);
        }
        catch {
            strCadena = string.Empty;
        }
        return strCadena.Normalize();
    }
    #endregion

    #region fEnviarBitacora
    /// <summary>
    /// Función que envía la bitácora a los supervisores.
    /// L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nProceso">Id del proceso</param>
    /// <param name="nParticipante">Id del participante</param>
    /// <param name="nDepcia">Número de la dependencia</param>
    /// <param name="nSupervisor">Id del usuario supervisor</param>
    /// <returns>Un entero que indica si se realizó correctamente la operacion o no (0 - No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int fEnviarBitacora(int nProceso, int nParticipante, int nDepcia, int nSupervisor)
    {
        int intResp = 0;
        clsBitacora objBitacora = new clsBitacora();
         intResp = objBitacora.fGetDatos_Notificacion(nProceso, nDepcia, nParticipante, nSupervisor);     
       // intResp = 1;
        return intResp;
    }
    #endregion
}