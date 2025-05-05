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

public partial class Administracion_Usuario_SACTITULA : System.Web.UI.Page
{
    #region Page_Load
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

    #region fObtieneDependencias
    /// <summary>
    /// Función que obtiene el listado de dependencias activas
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con el listado de la dependencias</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneDependencias() {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();
        try {
            objDepcia.fObtener_Dependencias_Titular();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
        }
        catch { 

        }
        return strCadena.Normalize();
    }
    #endregion

    #region fObtienePuestos()
    /// <summary>
    /// Función que obtiene la lista de puestos activos
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con el listado de puestos</returns>
    [WebMethod (EnableSession = true)]
    public static string fObtienePuestos() {
        string strCadena = string.Empty;
        clsPuesto objPuesto = new clsPuesto();
        try {
            //objPuesto.fObtener_Puesto();
            objPuesto.fObtener_Puestos();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPuesto.laPuesto).Normalize();
        }
        catch { 
        }
        return strCadena.Normalize();
    }
    #endregion

    #region fObtieneTipoPersonal
    /// <summary>
    /// Función que obtiene la lista de los tipos de personal
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Un entero indicando si se realizó correctamente la operación (0: No se realizó, 1: Se realizó correctamente)</returns>
    [WebMethod (EnableSession = true)]
    public static string fObtieneTipoPersonal() {
        string strCadena = string.Empty;
        clsTipoPersonal objTipoPersonal = new clsTipoPersonal();
        objTipoPersonal.strAccion = "CONS_TIPOPERSONAL";
        try
        {
            objTipoPersonal.fObtieneTipoPersonal();
            JavaScriptSerializer serializar = new JavaScriptSerializer();
            serializar.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializar.Serialize(objTipoPersonal.lstRegresaDatos).Normalize();
        }
        catch { }
        return strCadena;
    }
    #endregion

    #region fObtieneCategoria
    /// <summary>
    /// Función que obtiene el listado de las categorías
    /// Autor: Emmanuel Méndez Flores.
    /// </summary>
    /// <returns>Un entero indicando si se realizó correctamente la operación (0: No se realizó, 1: Se realizó correctamente)</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneCategoria() {
        string strCadena = string.Empty;
        clsCategoria objCategoria = new clsCategoria();
        objCategoria.strAccion = "CONS_CATEGORIA";
        try {
            objCategoria.fObtieneCategoria();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objCategoria.lstRegresaDatos).Normalize();
        }
        catch { }
        return strCadena;
    }
    #endregion

    #region fObtieneTitular
    /// <summary>
    /// Función que obtiene los datos del titular actual
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nDependencia">Clave de la dependencia</param>
    /// <param name="sIndTitular">Indicador de titular (A: Administrador, T:Titular)</param>
    /// <returns>Una cadena con los datos del titular</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneTitular(int nDependencia, string sIndTitular)
    {
        string strCadena = string.Empty;
        clsUsuario objUsuario = new clsUsuario();
        try
        {
            objUsuario.fObtenerTitular_O_Admin(nDependencia, sIndTitular);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos).Normalize();
        }
        catch { 
        }

        return strCadena;
    }
    #endregion

    #region fObtieneUsuarios
    /// <summary>
    /// Función que obtiene a todos los usuarios registrados en el sistema
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con el listado de usuarios</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneUsuarios(){
        string strCadena = string.Empty;
        clsUsuario objUsuario = new clsUsuario();
        try
        {
            objUsuario.fGetUsuarios();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos).Normalize();
        }
        catch { 
        
        }
        return strCadena;
    }
    #endregion

    #region fBuscaUsuario
    /// <summary>
    /// Función que busca la información de un usuario de acuerdo a su cuenta
    /// </summary>
    /// <param name="sCuenta">Cuenta institucional del usuario</param>
    /// <returns>Devuelve una cadena con la información del usuario</returns>
    [WebMethod(EnableSession = true)]
    public static string fBuscaUsuario(string sCuenta) {
        string strCadena = string.Empty;
        int intRespuesta = 0;
        clsUsuario objUsuario = new clsUsuario();
        try
        {
            intRespuesta = objUsuario.fBuscaTitular(sCuenta);
            if (intRespuesta == 1 || intRespuesta == 2)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                strCadena += serializer.Serialize(objUsuario.laRegresaDatos).Normalize();
            }
            else {
                strCadena += intRespuesta;
            }
        }
        catch { 
        
        }
        JavaScriptSerializer serializer2 = new JavaScriptSerializer();
        strCadena = serializer2.Serialize(new { Respuesta = strCadena, msj = objUsuario.strMensajeError });
        return strCadena;
    }
    #endregion

    //#region fGuardaTitular
    ///// <summary>
    ///// Función que guarda la información del nuevo titular o administrador de la dependencia
    ///// Autor: L.I. Emmanuel Méndez Flores
    ///// </summary>
    ///// <param name="nDepcia">Clave de la dependencia</param>
    ///// <param name="nPuesto">Clave del puesto</param>
    ///// <param name="nRespDepcia">Id de la tabla APRRESPDEPCIA</param>
    ///// <param name="nIdTitular">Id del usuario titular</param>
    ///// <param name="nIdNuevoTitular">Id del nuevo titular</param>
    ///// <returns></returns>
    //[WebMethod(EnableSession = true)]
    //public static int fGuardaTitular(int nDepcia, int nPuesto, int nRespDepcia, int nIdTitular, int nIdNuevoTitular, int nUsuario, string sIndTitular, clsUsuario objNuevoTitular, clsUsuario objTitular)
    //{
    //    int intRespuesta = 0;

    //    clsUsuario objUsuario = new clsUsuario();
    //    try
    //    {
    //       intRespuesta = Convert.ToInt32(objUsuario.fGuardaTitular(nDepcia, nPuesto, nRespDepcia, nIdTitular, nIdNuevoTitular, nUsuario, sIndTitular, objNuevoTitular));
    //    }
    //    catch { 

    //    }
            
    //    return intRespuesta;
    //}
    //#endregion


    #region fGuardaTitular
    /// <summary>
    /// Función que actualiza al titular de una dependencia
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="objTitular">Objeto del tipo Usuario que contiene la información del titular actual</param>
    /// <param name="objNuevoTitular">Objeto del tipo Usuario que contiene la información del nuevo titular</param>
    /// <param name="sIndTitular">Indicador del titular (A: Administrador, T: Titular)</param>
    /// <param name="nUsuario">Id del usuario que realiza la actualización</param>
    /// <returns>Un entero indicando si se realizó correctamente la operación (0: No se realizó, 1: Se realizó correctamente)</returns>
    [WebMethod(EnableSession = true)]
    public static int fGuardaTitular(clsUsuario objTitular, clsUsuario objNuevoTitular, string sIndTitular, int nUsuario)
    {
        int intRespuesta = 0;

        clsUsuario objUsuario = new clsUsuario();
        try
        {
            intRespuesta = Convert.ToInt32(objUsuario.fGuardaTitular(objTitular, objNuevoTitular, sIndTitular, nUsuario));
        }
        catch
        {

        }

        return intRespuesta;
    }
    #endregion
}