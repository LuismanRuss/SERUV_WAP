using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using libFunciones;
using nsSERUV;
using System.Web.Script.Serialization; 


public partial class Administracion_Guia_SAAAPARTAH : System.Web.UI.Page
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
                    //hf_idUsuario.Value = "4";

                    // Variables que vendran por URL o por sesión
                    string[] strSesion = Context.User.Identity.Name.Split(('|'));
                    hf_idUsuario.Value = (objValidacion.IsNumeric(strSesion[0]) ? int.Parse(strSesion[0]) : 0).ToString();

                }
            }
        }

    }

    #region Metodo para Insertar un Apartado
    /// <summary>
    /// Función que Inserta un Apartado en la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="Codigo">Codigo del Apartado</param>
    /// <param name="Descripcion">Descripcion del Apartado</param>
    /// <param name="Orden">Numero de Orden del Apartado</param>
    /// <param name="Indicador">Indicador para saber si es de Sujeto Obligado o Contraloria</param>
    /// <param name="Observacion">Observaciones en el Apartado</param>
    /// <returns>Un Booleano que indica si se realizo correctamente la operación (false- No, true - Si)</returns>
    
    [WebMethod(EnableSession = true)]
    public static bool Alta_Apartados(String Codigo, String Descripcion, int Orden, string Indicador, String Observacion)
    {
        bool blnResultado = false;
        clsApartado objProcER = new clsApartado();

        objProcER.strApartado = Codigo;
        objProcER.strDescApartado = Descripcion;
        objProcER.intnOrden = Orden;
        objProcER.chrAplica = Indicador.ToString();
        objProcER.strDescCortApartado = Observacion;


        if (objProcER.fGetApartadosInserta(objProcER))
        {

            blnResultado = true;
        }
        else
        {
            blnResultado = false;
        }
        return blnResultado;
    }

    #endregion

    #region Metodo para Insertar, Modificar y Actualizar un Apartado
    /// <summary>
    /// Funcion que Insertar, Modifica y Actualiza un Apartado de la Base de Datos
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objApartados">Objeto de Datos de la clase Apartados</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Apartados</returns>
    [WebMethod(EnableSession = true)]
    public static string Actualizar_Apartados(clsApartado objApartados)
    {
        //bool blnResultado = false;
        string strDatosAnexo = string.Empty;

            objApartados.strResp = objApartados.fGetApartadosActualizar().ToString();
        
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strDatosAnexo = serializer.Serialize(objApartados);
            objApartados.Dispose();
            //blnResultado = true;
        

        return strDatosAnexo.Normalize();
    }

    #endregion

    #region Metodo para Validar el Código del Apartado
    /// <summary>
    /// Funcion que Valida el codigo del Apartado para que no se repíta en la BD
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objApartados">Objeto de Datos de la clase Apartados</param>
    /// <returns>Un entero que indica si se realizo correctamente la operación (0- No, 1 - Si)</returns>
    [WebMethod(EnableSession = true)]
    public static int Validar_Codigo(clsApartado objApartados)
    {
        int blnResultado = 0;

        blnResultado = objApartados.fGetCodigoApartado();

        return blnResultado;
    }

    #endregion

    #region Metodo para Verificar si el Apartado tiene configurado el Acta E-R
    /// <summary>
    /// Funcion que Verifica si el Apartado tiene configurado el Acta E-R
    /// Autor: Daniel Ramírez Hernández
    /// </summary>
    /// <param name="objApartados">Objeto de Datos de la clase Apartados</param>
    /// <returns>Cadena en formato JSON con los datos del Objeto Apartados</returns>
    [WebMethod(EnableSession = true)]
    public static string Validar_Acta(clsApartado objApartados)
    {
        string strDatosApartados = string.Empty;

        objApartados.strResp = objApartados.fGetVerificaActa().ToString();

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
        strDatosApartados = serializer.Serialize(objApartados);
        objApartados.Dispose();
        //blnResultado = true;

        return strDatosApartados.Normalize();
    }

    #endregion

}