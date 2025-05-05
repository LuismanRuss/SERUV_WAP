using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Registro_SCCUSUARI : System.Web.UI.Page
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
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena += serializer.Serialize(objUsuario.laRegresaDatos);
        }
        catch
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
        Registro_SCCUSUARI obj = new Registro_SCCUSUARI();
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