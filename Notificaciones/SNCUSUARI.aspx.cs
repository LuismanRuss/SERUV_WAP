using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Notificaciones_SNCUSUARI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string Pinta_Grid()
    {
        clsUsuario objUsuario = new clsUsuario();
        string strCadena = string.Empty;

        try
        {
            objUsuario.fGetUsuarios();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = 500000000;

            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
        }
        catch (Exception ex)
        {
            strCadena = string.Empty;
        }
        finally
        {
            //objUsuario.Dispose();
        }
        return strCadena.Normalize();
    }


    [WebMethod(EnableSession = true)]
    public static int fIncluirDest(string sSeleccionadas)
    {
        Notificaciones_SNCUSUARI obj = new Notificaciones_SNCUSUARI();
        clsUsuario objUsuario = new clsUsuario();
        //clsParticipante objPart = new clsParticipante();
        int nRespuesta = 0;

        try
        {
            nRespuesta = Convert.ToInt32(objUsuario.fIncluirUsuarios(sSeleccionadas));
        }
        catch
        {
            nRespuesta = 0;
        }
        finally
        {
            objUsuario.Dispose();
        }
        return nRespuesta;
    }
}