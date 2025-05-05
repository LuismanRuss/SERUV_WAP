using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;
using libFunciones;

public partial class SAAENLACEA : System.Web.UI.Page
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
              //   hf_idUsuario.Value = "369";

                hf_intDependencia.Value = Request.QueryString["idDepcia"];
                hf_intProceso.Value = Request.QueryString["idProceso"];
            }
        }  
    }

    #region buscaCuenta

    /// <summary>
    /// Función que busca una cuenta institucional
    /// Autor: Ma. Guadalupe Dominguez Julián 
    /// </summary>
    /// <param name="cuenta">Cuenta institucional a buscar en la tabla de usuarios</param>
    /// <returns>Datos del usuario buscado</returns>
    [WebMethod(EnableSession = true)]
    public static string buscaCuenta(string cuenta)
    {
        string cadena = string.Empty;
        //string accion = "BUSCAR";
        clsUsuario us = new clsUsuario();
        if (us.pConsulta_CuentaUsuario(cuenta))
        {
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                // cadena = serializer.Serialize(us.pConsulta_UsuarioOp());
                cadena += serializer.Serialize(us.lstUsuarios).Normalize();

            }
            catch (Exception)
            {

                throw;
            }
        }
       
        return cadena.Normalize();
    }

    #endregion 

    #region nuevoEnlace

    /// <summary>
    /// Función para crear un nuevo enlace operativo
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="idusuario">Identificador del usuario enlace operativo</param>
    /// <param name="check">Bandera S/N según sea</param>
    /// <param name="Usuario">Identificador del usuario sujeto obligado</param>
    /// <param name="intIdDepcia">Identificador de la dependencia</param>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <returns>Regresa un entero según el resultado al crear un nuevo enlace</returns>
    [WebMethod(EnableSession = true)]
    public static int nuevoEnlace(string idusuario, string check, int Usuario, int intIdDepcia, int intIdProceso)
    {
        int intResultado;
        string accion = "NUEVOENLACE";
        clsUsuario us = new clsUsuario();
        int idusu = int.Parse(idusuario);

        intResultado = us.pNuevo_Enlace(accion, idusu, check, Usuario, intIdDepcia, intIdProceso);
        return intResultado; 
      
    }

    #endregion

    #region modificarEnlace

    /// <summary>
    /// Función para modificar enlace operativo
    /// Autor: Ma. Guadalupe Dominguez Julián  
    /// </summary>
    /// <param name="idusuario">Identificador del enlace operativo</param>
    /// <param name="check">Bandera con valor S/N según sea enlace principal o no</param>
    /// <param name="Usuario">Identificador del sujeto obligado</param>
    /// <param name="intIdDepcia">Identificador de la dependencia</param>
    /// <param name="intIdProceso">Identificador del proceso</param>
    /// <returns>true o false según el resultado de la acción</returns>
    [WebMethod(EnableSession = true)]
    public static string modificarEnlace(string idusuario, string check, int Usuario, int intIdDepcia, int intIdProceso)
    {

        string cadena = string.Empty;
        string accion = "MODIFICARENLACE";
        clsUsuario us = new clsUsuario();
        int idusu = int.Parse(idusuario);
        //if (us.pNuevo_Enlace(accion, idusu, check))
        //{
        try
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            // cadena = serializer.Serialize(us.pConsulta_UsuarioOp());
            cadena += serializer.Serialize(us.pModificar_Enlace(accion, idusu, check, Usuario, intIdDepcia, intIdProceso));

        }
        catch (Exception)
        {

            throw;
        }
        //}

        return cadena.Normalize();
    }
    #endregion
}