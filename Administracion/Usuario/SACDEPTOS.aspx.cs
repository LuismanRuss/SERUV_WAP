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

public partial class Administracion_Usuario_SACDEPTOS : System.Web.UI.Page
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

    #region fObtieneDependencias
    /// <summary>
    /// Función que obtiene el listado de dependencias activas
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Una cadena con el listado de la dependencias</returns>
    [WebMethod(EnableSession = true)]
    public static string fObtieneDependencias()
    {
        string strCadena = string.Empty;
        clsDepcia objDepcia = new clsDepcia();
        try
        {
            objDepcia.fObtener_Dependencia();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objDepcia.laDepcia).Normalize();
        }
        catch
        {

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
    [WebMethod(EnableSession = true)]
    public static string fObtienePuestos()
    {
        string strCadena = string.Empty;
        clsPuesto objPuesto = new clsPuesto();
        try
        {
            //objPuesto.fObtener_Puesto();
            objPuesto.fObtener_Puestos();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPuesto.laPuesto).Normalize();
        }
        catch
        {
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
    [WebMethod(EnableSession = true)]
    public static string fObtieneTipoPersonal()
    {
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
    public static string fObtieneCategoria()
    {
        string strCadena = string.Empty;
        clsCategoria objCategoria = new clsCategoria();
        objCategoria.strAccion = "CONS_CATEGORIA";
        try
        {
            objCategoria.fObtieneCategoria();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objCategoria.lstRegresaDatos).Normalize();
        }
        catch { }
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
    public static string fBuscaUsuario(string sCuenta)
    {
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
            else
            {
                strCadena += intRespuesta;
            }
        }
        catch
        {

        }
        return strCadena;
    }
    #endregion

    #region MuestraPuestosEntregar
    /// <summary>
    /// Función que regresa el perfil de administrador
    /// Autor: L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <returns>Cadena con los datos del perfil del administrador.</returns>
    [WebMethod(EnableSession = true)]
    public static string fMuestraPuestosEntregar()
    {
        clsPuesto objPuesto = new clsPuesto();
        string strCadena = string.Empty;
        try
        {
            objPuesto.fObtenerPuestosAltaDepto();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objPuesto.laPuesto);
        }
        catch
        {
            strCadena = string.Empty;
        }
        finally
        {
            objPuesto.Dispose();
        }
        return strCadena.Normalize();
    }
    #endregion

    #region fGuardaDepartamento
    /// <summary>
    /// Función que guarda un nuevo departamento
    /// L.I. Emmanuel Méndez Flores
    /// </summary>
    /// <param name="nDepciaPadre">Clave de la dependencia de la que depende el departamento</param>
    /// <param name="sDescripLarga">Descripción larga del departamento</param>
    /// <param name="sDescripCorta">Descripción corta del departamento</param>
    /// <param name="nTitular">ID del usuario titular del departamento</param>
    /// <param name="nPuesto">Clave del puesto asignado al departamento</param>
    /// <param name="nUsuario">ID del usuario que realiza la operación</param>
    /// <returns>Entero que indica si se realizo correctamente la operación o no (0 - No, 1 - Sí)</returns>
    [WebMethod(EnableSession = true)]
    public static int fGuardaDepartamento(int nDepciaPadre, string sDescripLarga, string sDescripCorta, clsUsuario objNuevoTitular, int nPuesto, int nUsuario)
    {
        int intRespuesta = 0;
        clsDepcia objDepcia = new clsDepcia();
        try
        {
            intRespuesta = objDepcia.fGuardaNuevoDepartamento(nDepciaPadre, sDescripLarga, sDescripCorta, objNuevoTitular, nPuesto, nUsuario);
        }
        catch (Exception Ex)
        {
            String Err = Ex.Message;
        }
        finally {
            objDepcia.Dispose();   
        }

        return intRespuesta;
    }
    #endregion

    #region fActualizaDepartamento
    /// <summary>
    /// Función que actualiza las descripciones del departamento
    /// Autor: L.I. Emmanuel Méndez Flores.
    /// </summary>
    /// <param name="sDescripLarga">Descripción larga del departamento</param>
    /// <param name="sDescripCorta">Descripción corta del departamento</param>
    /// <param name="nUsuario">ID del usuario que realiza la operación</param>
    /// <returns>Entero que indica si se realizó correctamente la operación (0 - No, 1 - Si) </returns>
    [WebMethod(EnableSession = true)]
    public static int fActualizaDepartamento(int nDepcia, string sDescripLarga, string sDescripCorta, int nTipPersonal, int nPuesto, int nCategoria, int nUsuarioResp, int nUsuario){
        int intRespuesta = 0;
        clsDepcia objDepcia = new clsDepcia();
        try
        {
            intRespuesta = objDepcia.fActualizaDescripDeptos(nDepcia, sDescripLarga, sDescripCorta, nTipPersonal, nPuesto, nCategoria, nUsuarioResp, nUsuario);
        }
        catch (Exception Ex)
        {
            String Err = Ex.Message;
        }
        finally {
            objDepcia.Dispose();
        }

        return intRespuesta;
    }
    #endregion

}