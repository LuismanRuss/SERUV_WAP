using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using libFunciones;
using System.Web.Script.Serialization;

public partial class SASANXDEP : System.Web.UI.Page
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
      

    #region Metodo para Mostrar Lista Dependencia
    /// <summary>
    /// Método que muestra la lista de dependencias
    /// </summary>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <param name="intUsuariolog">Identificador del usuario logueado</param>
    /// <returns>Cadena que contiene la lista de dependencias</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListDepcia(int intIdProceso, int intUsuariolog)
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();
        string strAccion = "CONS_DEPCIA_PROCES_SO_E";

        if (objDepcia.fObtener_Dependencia(intIdProceso, intUsuariolog, strAccion))
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

    #region Metodo para ObtieneNombreSO
    /// <summary>
    /// Método consulta el nombre del sujeto obligado
    /// </summary>
    /// <param name="intUsuariolog">identificador del usuario logueado</param>
    /// <returns>Cadena que tiene el nombre del sujeto obligado</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtieneNombreSO(int intUsuariolog)
    {
        string strCadena = string.Empty;
        clsUsuario objSO = new clsUsuario();

        if (objSO.fObtener_Nombre_SO(intUsuariolog))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objSO.lstUsuarios).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region Metodo para DibujaSujetoOblig
    /// <summary>
    /// Método que obtiene el nombre del sujeto obligado
    /// </summary>
    /// <param name="depcia">Identificador de la dependencia</param>
    /// <param name="proceso">Identificado del proceso</param>
    /// <returns>obtiene el nombre del sujeto obligado</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaSujetoOblig(int depcia, int proceso)
    {
        string strCadena = string.Empty;
        clsProceso objSO = new clsProceso();

        if (objSO.fObtener_Sujeto_Obligado_Dependencia(depcia, proceso))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objSO.laTipoProceso).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region Metodo para Mostrar Tipos de Proceso
    /// <summary>
    /// Método que obtiene la lista de procesos
    /// </summary>
    /// <param name="intIdSujetoOb">Identificador del sujeto obligado</param>
    /// <returns>Cadena que contiene la lista de procesos</returns>
    [WebMethod(EnableSession = true)]
    public static string DibujaListTipoProc(int intIdSujetoOb)
    {
        string strCadena = string.Empty;
        string strAccion = "OBTENER_PROCESO_POR_USU_SE";
        clsProceso objProceso = new clsProceso();

        if (objProceso.fObtener_ProcesoUsuario(strAccion, intIdSujetoOb))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            strCadena += serializer.Serialize(objProceso.laTipoProceso).Normalize();
        }
        else
        {
            strCadena += "{'resultado':'2','mensaje':'No se encontraron registros con la opción '}";
        }
        return strCadena.Normalize();
    }
    #endregion

    #region ObtenerDatos
    /// <summary>
    /// Método que obtiene una lista de apartados correspondientes a una determinada dependencia, proceso y sujeto obligado
    /// </summary>
    /// <param name="nDepcia">Número de dependencia</param>
    /// <param name="nProceso">Número de proceso</param>
    /// <param name="nSujetoObligado">Número de sujeto obligado</param>
    /// <returns>Lista de apartados</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtenerDatos(int nDepcia, int nProceso, int nSujetoObligado)
    {      
        string cadena = string.Empty;
        string strAccion = "SELECCIONAR";
        clsApartado apartado = new clsApartado();
        if (apartado.pConsulta_Apartados(strAccion, nDepcia, nProceso, nSujetoObligado))
        {                    
            cadena += "{\"resultado\":\"1\",\"mensaje\":\"Obtiene Apartados\",\"datos\":[{\"id\": \"\", \"apartado\": \"NOMBRE\"}";
            if(apartado.liApartados !=null){
            foreach (clsApartado ap in apartado.liApartados)
            {
                cadena += ",{";
                cadena += "\"idAp\":\"" + ap.idApartado + "\","; 
                cadena += "\"Dapartado\":\"" + ap.strDescApartado + "\",";
                cadena += "\"sApartado\":\"" + ap.strApartado + "\"";
                
                cadena += "}";
              
            }
            }
            cadena += "]}";
        }
        else
        {
            cadena += "{\"resultado\":\"2\",\"mensaje\":\"No se encontraron registros con la opción seleccionada\"}";
        }
        return cadena.Normalize();
    }
    #endregion

    #region  ObtenerAnexos
    /// <summary>
    /// Método consulta anexos a partir del identificador del apartado, identificador de usuario, identificador del proceso y de la dependencia
    /// </summary>
    /// <param name="idApartado">Identificador del apartado</param>
    /// <param name="idusuario">Identificador del usuario</param>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <param name="intIdDepcia">Identificador de la dependencia</param>
    /// <returns>Obtiene una cadena que contiene la lista de anexos</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtenerAnexos(int idApartado, int idusuario, int intIdProceso, int intIdDepcia)
    {
        string strCadena = string.Empty;
        string strAccion = "SELECCIONAR";
         string strAc1 = "OBLIGATORIO";
         string strAc2 = "APLICA";
         string strAc3 = "NOAPLICA";
         string strAc4 = "TOTAL";
        clsAnexo anexo = new clsAnexo();

        if (anexo.pConsulta_Anexos(strAccion, idApartado, idusuario, intIdProceso, intIdDepcia) && anexo.lstAnexo != null)
        {
            strCadena += "{\"resultado\":\"1\",\"mensaje\":\"Obtiene Apartados\",\"datos\":[{\"id\": \"\", \"danexo\": \"NOMBRE\",\"anexo\": \"anexo\"}";
            foreach (clsAnexo ap in anexo.lstAnexo)
            {
                strCadena += ",{";
                strCadena += "\"idAnexo\":\"" + ap.idAnexo + "\",";
                strCadena += "\"Danexo\":\"" + ap.strDAnexo + "\",";
                strCadena += "\"sAnexo\":\"" + ap.strCveAnexo + "\",";
                strCadena += "\"chrAlcance\":\"" + ap.chrAlcance + "\",";
                strCadena += "\"excluido\":\"" + ap.strExcluir + "\",";
                strCadena += "\"entrega\":\"" + ap.strEntrega + "\"";
                strCadena += "}";
            }



            strCadena += "],";

            if (anexo.pConsulta_Anexos(strAc1, idApartado, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += "\"obligatorio\":\"" + ap.strObliga + "\","; 
                }
            }
            if (anexo.pConsulta_Anexos(strAc2, idApartado, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += "\"aplica\":\"" + ap.strAplica + "\",";
                }
            }
            if (anexo.pConsulta_Anexos(strAc3, idApartado, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += "\"naplica\":\"" + ap.strAplicable + "\",";
                }
            }
            if (anexo.pConsulta_Anexos(strAc4, idApartado, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += "\"total\":\"" + ap.strTotal + "\"";
                }
            }


            strCadena += "}";
        }
        else
        {
            strCadena += "{\"resultado\":\"2\",\"mensaje\":\"No se encontraron registros con la opción seleccionada\"}";
        }
          
        return strCadena.Normalize();
    }

    #endregion
    //*********************************************************************************************
    #region ObtenerTotalAnexos
    /// <summary>
    /// Método que calcula el total de anexos en base al identificador de usuario, identificador de proceso, identificador de la dependencia
    /// </summary>
    /// <param name="idusuario">Identificador de usuario</param>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <param name="intIdDepcia">Identificador de la dependencia</param>
    /// <returns>Cadena total de anexos</returns>
    [WebMethod(EnableSession = true)]
    public static string ObtenerTotalAnexos(int idusuario, int intIdProceso, int intIdDepcia)
    {

        string strCadena = string.Empty;     
      
        string strAc2 = "APLICA";
        string strAc3 = "NOAPLICA";
         string strAc4 = "TOTAL";
     
        clsAnexo anexo = new clsAnexo();          
           
            strCadena += "{\"resultado\":\"1\",\"mensaje\":\"Obtiene Apartados\"}";          

            if (anexo.pConsulta_TotalAnexos(strAc2, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += ",{\"aplica\":\"" + ap.strAplica + "\",";
                }
            }
        
            if (anexo.pConsulta_TotalAnexos(strAc3, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += "\"naplica\":\"" + ap.strAplicable + "\",";
                }
               
            }
            if (anexo.pConsulta_TotalAnexos(strAc4, idusuario, intIdProceso, intIdDepcia))
            {
                foreach (clsAnexo ap in anexo.lstAnexo)
                {
                    strCadena += "\"total\":\"" + ap.strTotal + "\"";
                }
                strCadena += "}";
            }
             
            else
            {
                strCadena += "{\"resultado\":\"2\",\"mensaje\":\"No se encontraron registros con la opción seleccionada\"}";
            }

        return strCadena.Normalize();
    }

    #endregion


}


