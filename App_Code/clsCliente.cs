/* 
****************************************************************************************
* CLASE PARA RECUPERAR LA IP Y LAS CARACTERÍSTICAS DEL NAVEGADOR DEL EQUIPO CLIENTE    *
* .NET 2010 - Framework 4.0                                                            *
****************************************************************************************
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Web;
using System.Web.UI;

/// <summary>
///        Objetivo :  Recuperar la IP desde donde se loguea el usuario al sistema así como las características del Navegador.
///         Versión :  1.0
///           Autor :  MTI José Aroldo Alfaro Ávila
///  Fecha Creación :  14/ABR/2013
///  
/// Fecha Ult. Rev. :  14/ABR/2013
/// </summary>

namespace nsSERUV
{
    public class clsCliente : IDisposable
    {
        #region "Variables privadas"
        private string _sIP;
        private string _sName;
        private string _sBrowser;
        private string _sBrowserType;
        private string _sBrowserVersion;
        private string _sBrowserPlatform;
        #endregion


        #region "Propiedades públicas de la clase"
        public string IP
        {
            get { return _sIP; }
        }

        public string Name
        {
            get { return _sName; }
        }

        public string Browser
        {
            get { return _sBrowser; }
        }

        public string BrowserType
        {
            get { return _sBrowserType; }
        }

        public string BrowserVersion
        {
            get { return _sBrowserVersion; }
        }

        public string BrowserPlatform
        {
            get { return _sBrowserPlatform; }
        }
        #endregion

        #region "Métodos públicos de la clase"
        public clsCliente(Page oPage)
        {
            pSet_InitValues();
            pGet_IP();
            pGet_Browser(oPage);
        }
        #endregion

        #region "Métodos privados de la clase"
        private void pSet_InitValues()
        {
            _sIP = "";
            _sName = "";
            _sBrowser = "";
            _sBrowserType = "";
            _sBrowserVersion = "";
            _sBrowserPlatform = "";
        }

        private void pGet_IP()
        {
            _sIP = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            if (_sIP == "::1" || _sIP == "127.0.0.1")
            {
                System.Net.IPHostEntry IPHEntry = null;
                System.Net.IPAddress[] IPAdd = null;

                IPHEntry = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());
                _sName = IPHEntry.HostName;
                IPAdd = IPHEntry.AddressList;
                for (int i = 0; i <= IPAdd.GetUpperBound(0); i++)
                {
                    _sIP = IPAdd[i].ToString();
                }
            }
        }

        private void pGet_Browser(Page oPage)
        {
            HttpBrowserCapabilities hbcBrowser = oPage.Request.Browser;
            _sBrowser = hbcBrowser.Browser;
            _sBrowserType = hbcBrowser.Type;
            _sBrowserVersion = hbcBrowser.Version;
            _sBrowserPlatform = hbcBrowser.Platform;
        }
        #endregion

        #region "Dispose"
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion 
    }
}