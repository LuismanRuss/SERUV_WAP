using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using nsSERUV;
using System.Web.Script.Serialization;

public partial class Cierre_SCAGEACTA7 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string Acta_Apartados(clsApartado objApartados)
    {
        string strCadena = string.Empty;

        if (objApartados.fGetListaApartadosActa(objApartados))
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new JavaScriptConverter[] { new NullPropertiesConverter() });
            strCadena = serializer.Serialize(objApartados);
            objApartados.Dispose();
        }
        return strCadena.Normalize();
    }
}