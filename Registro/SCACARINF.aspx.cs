using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization; 
using libFunciones;
using nsSERUV;

public partial class Registro_SCACARINF : System.Web.UI.Page
{
    #region protected void Page_Load(object sender, EventArgs e)
    /// <summary>
    /// Procedimiento que se ejecuta al cargar la página del lado del servidor
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!Session.IsNewSession) // Se tiene una sesión
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

    #region static string pDisableArchivo(clsArchivo objArchivo)
    /// <summary>
    /// Procedimiento que "Elimina" un archivo de una ER
    /// Autor: Erik José Enríquez Carmona
    /// </summary>
    /// <param name="objArchivo">Objeto de tipo clsArchivo</param>
    /// <returns>Una cadena con las propiedades del archivo</returns>
    [WebMethod(EnableSession = true)]
    public static string pDisableArchivo(clsArchivo objArchivo)
    {
        string strDatosArchivo = string.Empty;

        if (objArchivo != null)
        {
            objArchivo.pSaveFileBD(); // Se actualiza el valor de activo en la BD
            JavaScriptSerializer serializer = new JavaScriptSerializer(); // se crea un objeto para serializar el resultado a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se le quiran las propiedades nulas
            strDatosArchivo = serializer.Serialize(objArchivo); // se serializa a una cadena
            objArchivo.Dispose();   
        }
        return strDatosArchivo;
    }
    #endregion

    #region string pGetDatosAnexo(clsAnexo objAnexo)
    /// <summary>
    /// Procedimiento que regresara informacion asociada a un Anexo
    /// Autor: Erik Jose Enriquez Carmona
    /// Ultima Actualizacion: 10 de Marzo de 2013
    /// </summary>
    /// <param name="objAnexo">Objeto Anexo</param>
    /// <returns>Una cadena con las propiedades que se necesitan del anexo</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosAnexo(clsAnexo objAnexo)
    {
        string strDatosAnexo = string.Empty;
        if (objAnexo != null)
        {
            objAnexo.pGetDatosERAnexo(); // Se consultas las propiedades necesarias del anexo
            JavaScriptSerializer serializer = new JavaScriptSerializer(); // se crea un objeto para serializar el resultado a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se le quiran las propiedades nulas
            strDatosAnexo = serializer.Serialize(objAnexo); // se serializa a una cadena
            objAnexo.Dispose();   
        }
        return strDatosAnexo.Normalize();
    }
    #endregion

    #region string pGetDatosER(clsRegistro objRegistro)
    /// <summary>
    /// Procedimiento que desplegará la información que se tendra que atender en el proceso ER
    /// Autor: Erik José Enríquez Carmonabj
    /// Última Actualización: 06 Marzo 2013
    /// </summary>
    /// <param name="objRegistro">Objeto que contiene la información de la ER</param>
    /// <returns></returns>
    [WebMethod(EnableSession = true)]
    public static string pGetDatosER(clsProcesoER objProceso)
    {
        string strDatosER = string.Empty;
        if (objProceso != null)
        {
            objProceso.pGetProcesosER(); // Se consulta la información de un proceso ER
            var serializer = new JavaScriptSerializer(); // se crea un objeto para serializar el resultado a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se le quiran las propiedades nulas 
            strDatosER = serializer.Serialize(objProceso); // se serializa a una cadena
            objProceso.Dispose();
        }
        
        return strDatosER.Normalize();
    }
    #endregion

    #region static string pGetNumArchivosXAnexo(clsApartado objApartado)
    /// <summary>
    /// Procedimiento que regresa el número de archivos por Archivos en cada anexo de un apartado
    /// </summary>
    /// <param name="objApartado">Objeto Apartado</param>
    /// <returns>Objeto Apartado</returns>
    [WebMethod(EnableSession = true)]
    public static string pGetNumArchivosXAnexo(clsApartado objApartado)
    {
        string strDatosApartado = string.Empty;

        if (objApartado != null)
        {
            objApartado.pGetNumArchivosXAnexo(); // Se consulta el numero de archivos por anexo
            JavaScriptSerializer serializer = new JavaScriptSerializer(); // se crea un objeto para serializar el resultado a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se le quiran las propiedades nulas 
            strDatosApartado = serializer.Serialize(objApartado);// se serializa a una cadena
            objApartado.Dispose();
        }

        return strDatosApartado.Normalize();
    }
    #endregion

    #region static string pConfigAnexo(clsAnexo objAnexo)
    /// <summary>
    /// Integra o no integra una anexo de una ER
    /// </summary>
    /// <param name="objAnexo">Objeto anexo</param>
    /// <returns>Objeto Anexo</returns>
    [WebMethod(EnableSession = true)]
    public static string pConfigAnexo(clsAnexo objAnexo)
    {
        string strDatosAnexo = string.Empty;
        if (objAnexo != null)
        {
            objAnexo.fGetAnexosActualizar(); // Se integra o desintegra un anexo
            JavaScriptSerializer serializer = new JavaScriptSerializer(); // se crea un objeto para serializar el resultado a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se le quiran las propiedades nulas 
            strDatosAnexo = serializer.Serialize(objAnexo); // se serializa a una cadena
            objAnexo.Dispose();
        }
        return strDatosAnexo.Normalize();
    }
    #endregion

    #region static string pEntrega(clsParticipante objParticipante)
    /// <summary>
    /// Procedimiento que realiza la entrega de un participante
    /// </summary>
    /// <param name="objParticipante">Objeto Participante</param>
    /// <returns>Objeto Participante</returns>
    [WebMethod(EnableSession = true)]
    public static string pEntrega(clsParticipante objParticipante)
    {
        string strDatosParticipante = string.Empty;

        if (objParticipante != null)
        {
            objParticipante.pEnviarER(); // Se envía la ER de un participante
            JavaScriptSerializer serializer = new JavaScriptSerializer(); // se crea un objeto para serializar el resultado a json
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() }); // se le quiran las propiedades nulas 
            strDatosParticipante = serializer.Serialize(objParticipante);// se serializa a una cadena
            objParticipante.Dispose();
        }
        return strDatosParticipante;
    }
    #endregion
}