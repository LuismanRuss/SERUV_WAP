 using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using libFunciones;

public partial class Administracion_Proceso_SAAPROCESH : System.Web.UI.Page
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



    #region VerificaCodigo
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Regresa el codigo con el que se va a generar el proceso
    /// </summary>
    /// <returns>regresa una cadena que contiene el código </returns>
    [WebMethod(EnableSession = true)]
    public static string VerificaCodigo()
    {
        string strCadena = string.Empty;
        clsProceso objProceso = new clsProceso();
        try
        {
            objProceso.fGeneraCodigo();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });     // Quita Nulos
            strCadena += serializer.Serialize(objProceso.laDatosProceso).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objProcER.Dispose();
        }
        return strCadena;
    }
    #endregion

    #region DibujaListPuesto
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Devuelve la lista de puestos que se usaran para determinar un proceso entrega-recepción
    /// </summary>
    /// <returns>devuelve una cadena que contigene una lista de puestos, y que se encuentran disponibles para realizar un proceso de entrega-recepción</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListPuesto()
    {
        string strCadena = string.Empty;
        clsPuesto objPuesto = new clsPuesto();

        if (objPuesto.fObtener_PuestoER())
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objPuesto.laPuesto).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region DibujaListDepcia
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Devuelve la lista de dependencias que cuentan con un puesto determinado, para crear el proceso entrega-recepción
    /// </summary>
    /// <param name="nPuesto">numero de puesto, que servira para devolver las dependencias que tengan este puesto asociado</param>
    /// <returns>devuelve una cadena que contiene una lista de dependencias relacionadas a un puesto, y que se encuentran disponibles para realizar un proceso de entrega-recepción</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListDepcia(int nPuesto)
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();

        if (objDepcia.fObtener_DependenciaPER(nPuesto))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region Metodo DibujaListTipoProc
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Regresa una lista con los tipos de proceso disponibles para crear un proceso, además devuelve otra lista con los motivos disponibles de acuerdo al tipo de proceso seleccionado
    /// </summary>
    /// <param name="strACCION">Acción que ejecutara el procedimiento almacenado para devolver los tipos de proceso</param>
    /// <param name="strACCIONMot">Acción que ejecutara el procedimiento almacenado para devolver los motivos</param>
    /// <returns>devuelve una cadena con 2 listas, una con la información referente a los tipos de proceso, la otra con información de los motivos disponibles</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListTipoProc(string strACCION
        , string strACCIONMot
        )
    {
        string strCadena = string.Empty;
        clsProceso objProceso = new clsProceso();
        clsMotivo objMotivo = new clsMotivo();
        try
        {
            objProceso.fObtener_TipoProceso(strACCION);
            objMotivo.fObtener_MotivoProceso(strACCIONMot);
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
           // strCadena += jsSerializer.Serialize(objProceso.laTipoProceso).Normalize();
            strCadena += "{'datos':[" + jsSerializer.Serialize(objProceso.laTipoProceso).Normalize() + "," + jsSerializer.Serialize(objMotivo.laMotivoProceso).Normalize() + "]}";
     
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally 
        { 
        }
        return strCadena;
    }
    #endregion

    #region GuiaVigente
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Mostrar la guia vigente a la hora de creación de un nuevo proceso
    /// </summary>
    /// <param name="strACCION">Indica la acción que realizara el procedimiento almacenado para devolver la guia vigente</param>
    /// <returns>devuelve una cadena con la información de la guia vigente al momento de accesar a la forma SAAPROCESH</returns>
    [WebMethod(EnableSession = true)]
    public static string GuiaVigente(string strACCION)
    {
        string strCadena = string.Empty;
        clsGuia objGuiaAct = new clsGuia();
        clsProceso objProceso = new clsProceso(); //ss

        try
        {
            objProceso.fGeneraCodigo();
            objGuiaAct.fObtener_GuiaVigente(strACCION);
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            // strCadena += jsSerializer.Serialize(objProceso.laTipoProceso).Normalize();
            strCadena += 
               "{'datos':[" + 
                jsSerializer.Serialize(objGuiaAct.laGuiasER).Normalize()
               + "," + jsSerializer.Serialize(objProceso.laDatosProceso).Normalize() 
               + "]}"
                ;

        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
        }
        return strCadena;
    }
    #endregion

    #region DibujaNotInicial
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Metodo para Mostrar Lista de Notificaciones para el Inicio del Proceso
    /// </summary>
    /// <param name="strACCION">Accion que realizara el procedimiento almacenado, se usa para traer las notificaciones que pueden asociarse a un proceso</param>
    /// <returns>regresa una cadena que contiene una lista con información de las notificaciones que pueden asociarse a un proceso</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaNotInicial(string strACCION)
    {
        clsNotificacion objNotificacion = new clsNotificacion();
        string strCadena = string.Empty;
        try
        {
            objNotificacion.fObtener_Notificaciones(strACCION);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });     // Quita Nulos
            strCadena += serializer.Serialize(objNotificacion.laNotificacion).Normalize();
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objProcER.Dispose();
        }
        return strCadena;
    }
    #endregion


    #region insertaProceso
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Metodo para Insertar un Nuevo Proceso
    /// </summary>
    /// <param name="objProceso">objeto que contiene la información necesaria para la creación de un nuevo proceso</param>
    /// <returns>devuelve un booleano que indica si la acción se realizó satisfactoriamente o no</returns>
    [WebMethod(EnableSession = true)]
    public static bool insertaProceso(clsProceso objProceso)
    {
        bool blnResultado = false;
        try
        {
            if (objProceso.fCreaProceso(objProceso))
            {
                blnResultado = true;
            }
            else
            {
                blnResultado = false;
            }
        }
        catch (Exception)
        {
        }
        return blnResultado;
    }
    #endregion

    #region pDatosProceso
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Metodo que trae los datos de un Proceso, incluyendo las notificaciones asociadas al mismo
    /// </summary>
    /// <param name="nIdProceso">ID del proceso del cual traera la información del mismo, asi como las notificaciones asociadas a este</param>
    /// <returns>regresa una cadena con dos listas, una referente a información del proceso a consultar, otra con datos de las notificaciones asociadas al proceso</returns>
    [WebMethod(EnableSession = true)]
    public static string pDatosProceso(int nIdProceso)
    {
        clsProceso cProceso = new clsProceso();
        string strCadena = string.Empty;
        try
        {
            cProceso.fGetDatosProceso(nIdProceso);
            JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
            strCadena += "{'datos':[" + jsSerializer.Serialize(cProceso.laDatosProceso).Normalize() + "," + jsSerializer.Serialize(cProceso.laNotif).Normalize() + "]}";
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objProc.Dispose();
        }
        return strCadena;
    }
    #endregion


    #region VerificarParticipantes
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Envia la dependencia, puesto y tipo de proceso, para que el procedimiento almacenado busque los participantes activos en otros procesos y los devuelva
    /// </summary>
    /// <param name="nPuesto">numero de puesto del proceso que se va a crear</param>
    /// <param name="nDepcia">numer de dependencia del proceso que se va a crear</param>
    /// <param name="tipoProc">tipo de proceso que se va a crear</param>
    /// <returns>regresa una cadena con los participantes (los que corresponderian al proceso a guardar)activos en otros procesos</returns>
    [WebMethod(EnableSession = true)]
    public static string VerificarParticipantes(int nPuesto, int nDepcia,int tipoProc)
    {
        string strCadena = string.Empty;
        clsProceso objProceso = new clsProceso();

        try
        {
            objProceso.fVerifPart(nPuesto, nDepcia, tipoProc);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objProceso.laDatosProceso).Normalize();
        }
        catch 
        {
            strCadena = string.Empty;
        }
       
        return strCadena;
    }
    #endregion

    #region VerificaGuiaER
    /// <summary>
    /// Autor:      Edgar Morales González
    /// Objetivo:   Verifica que la guia exista al momento de guardar el proceso
    /// </summary>
    /// <param name="objGuiaER">objeto que trae los datos necesarios para verificar el estado de la guia </param>
    /// <returns>booleano //Indica si la guia existe al momento de guardar el proceso</returns>
    [WebMethod(EnableSession = true)]
    public static bool VerificaGuiaER(clsGuia objGuiaER) 
    {
      bool blnRespuesta = false;
        try{
           if(objGuiaER.fGetValidaGuiaER(objGuiaER))
           {
               blnRespuesta = true;
           }
        }
        catch
        {
        }
      return blnRespuesta;
    }
    #endregion

}