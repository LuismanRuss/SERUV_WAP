using System.Configuration;
using System.Web.Configuration;
using nsSERUV;
using System.Data;
using System;
using SERUV_WAP;
//using System.ServiceModel;

/// Objetivo:                       
/// Versión:                        1.0
/// Autor:                          L.S.C.A. Edgar Morales González

public class clsWSNotif
{
    public clsWSNotif()
    {
        // TODO: Add constructor logic here
    }

    #region  Propiedades
    private System.Collections.ArrayList lstParametros;
    string KeyWsSeruv;
    string strMailsTo;
    #endregion

    #region  SendNotif 
    //Verifica si las notificaciones se encuentran activas o inactivas y manda a llamar al webservice de acuerdo al estado
    public void SendNotif(string strDatos, string opcion)
    {
        KeyWsSeruv = ConfigurationManager.AppSettings["wsSeruv"].ToString();
        strMailsTo = ConfigurationManager.AppSettings["MailsTo"].ToString();   // variable que asigna a quien se enviara el correo
        bool blnRespuesta = false;
        string cIndNotif = "";

        try
        {
            this.lstParametros = new System.Collections.ArrayList();
            using (clsDALSQL objDALSQL = new clsDALSQL(false))
            {
                libSQL lSQL = new libSQL();
                lstParametros.Add(lSQL.CrearParametro("@strACCION", "ESTADO_CONF_NOT"));

                if (blnRespuesta = objDALSQL.ExecQuery_SET("PA_SELV_NOTIFICACION", lstParametros))
                {
                    DataSet ds = new DataSet();
                    ds = objDALSQL.Get_dtSet();

                    if (ds != null && ds.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            cIndNotif = row["cIndActivo"].ToString();
                        }
                    }
                }
            }
            if (cIndNotif == "S")
            {
                fCallWsNot(cIndNotif, strDatos, opcion);
            }
        }
        catch (Exception Ex) { }
    }
    #endregion

    #region fCallWsNot 
    // Envia los datos para que el WebService mande las notificaciones correspondientes

    public void fCallWsNot(string cIndNotif, string strDatos, string opcion)
    {
        string strWebApp = ConfigurationManager.AppSettings.Get("WebApp");

        switch (strWebApp)
        {
            //case "ADWEB":
            //    dsiades.wsSeruvNotif wsNotif_ADWEB = new dsiades.wsSeruvNotif();
            //    wsNotif_ADWEB.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);
            //    break;
            case "DVLP":
            case "TRNG":
                //srvxaddweb.wsSeruvNotif wsNotif_TRNG = new srvxaddweb.wsSeruvNotif();
                //srvxaddweb_WAP.InotifServiceClient wsNotif_TRNG = new srvxaddweb_WAP.InotifServiceClient();
                //wsNotif_TRNG.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);

                SERUV_WAP.wsNotif_DVLP.InotifServiceClient wsNotif_TRNG = new SERUV_WAP.wsNotif_DVLP.InotifServiceClient();
                wsNotif_TRNG.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);

                //xalweb2admvo.wsSeruvNotif wsNotif_TRNG = new xalweb2admvo.wsSeruvNotif();
                //wsNotif_TRNG.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);
                //Prod2012.wsSeruvNotif wsNotif_PROD2012 = new Prod2012.wsSeruvNotif();
                //wsNotif_PROD2012.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);
                break;
            case "ADWEB":
            case "PROD":
            case "PROV":
                //dsiauvmx.wsSeruvNotif wsNotif_PROD = new dsiauvmx.wsSeruvNotif();
                //dsiauvmx_WAP.InotifServiceClient wsNotif_PROD = new dsiauvmx_WAP.InotifServiceClient();
                //wsNotif_PROD.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);

                SERUV_WAP.wsNotif_DVLP.InotifServiceClient wsNotif_PROD = new SERUV_WAP.wsNotif_DVLP.InotifServiceClient();
                wsNotif_PROD.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);

                //SERUV_WAP.wsNotif_PROD.InotifServiceClient wsNotif_PROD = new SERUV_WAP.wsNotif_PROD.InotifServiceClient();
                //wsNotif_PROD.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);

                break;
            //case "PROD2012":
            //    Prod2012.wsSeruvNotif wsNotif_PROD2012 = new Prod2012.wsSeruvNotif();
            //    wsNotif_PROD2012.pCreaNotif(strDatos, opcion, KeyWsSeruv, strMailsTo);
            //    break;
        }
    }
    #endregion
}