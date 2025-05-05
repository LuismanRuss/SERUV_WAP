using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using nsSERUV;
using libFunciones;
using System.Web.Services;

public partial class Cierre_SCAGEACTA : System.Web.UI.Page
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

    [WebMethod(EnableSession = true)]
    public static string getDatosActa(int nIdParticipante)
    {
        string strCadena = string.Empty;
        clsCierre objCierre = new clsCierre();
        try
        {
            if (int.Parse(objCierre.fGetDatosActa(nIdParticipante)) == 0)
            {
                strCadena = "0";
            }
            else
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
                strCadena += serializer.Serialize(objCierre.laRegresaDatos).Normalize();
            }
        }
        catch (Exception)
        {
            strCadena = string.Empty;
        }
        finally
        {
            objCierre.Dispose();
        }
        return strCadena;
    }


    [WebMethod(EnableSession = true)]
    public static int GuardarActa(clsCierre objCierre)
    {
        int nResp = 0;
        try
        {
            //clsCierre objCierre = new clsCierre();
            nResp = int.Parse(objCierre.fGuardarActa(objCierre).ToString());
        }
        catch (Exception)
        {
            
            throw;
        }
        return nResp;
    }
}