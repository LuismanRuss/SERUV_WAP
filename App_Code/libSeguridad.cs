/*
***************************************************************************
* LIBRERÍA CON FUNCIONES DE CRIPTOGRAFÍA (UNIDIRECCIONAL Y BIDIRECCIONAL) *
* .NET 2010 - FrameWork 4.0                                               *
***************************************************************************

Objetivo :  Encriptar y desencriptar información con distintos niveles de seguridad
Autor    :  MTI José Aroldo Alfaro Avila
Fecha    :  21/FEB/2013
Versión  :  1.0

Fecha de última modificación : 21/FEB/2013
*/

using System;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.IO;


namespace nsSERUV
{

    // CRIPTOGRAFÍA UNIDIRECCIONAL
    public static class Hash
    {
        public static string HashTextSHA1(string TextToHash)
        {
            SHA1CryptoServiceProvider SHA1 = null;
            byte[] bytValue = null;
            byte[] bytHash = null;

            SHA1 = new SHA1CryptoServiceProvider();
            bytValue = System.Text.Encoding.UTF8.GetBytes(TextToHash);
            bytHash = SHA1.ComputeHash(bytValue);
            SHA1.Clear();
            return Convert.ToBase64String(bytHash);
        }

        public static string HashTextMD5(string TextToHash)
        {
            MD5CryptoServiceProvider md5 = null;
            byte[] bytValue = null;
            byte[] bytHash = null;

            md5 = new MD5CryptoServiceProvider();
            bytValue = System.Text.Encoding.UTF8.GetBytes(TextToHash);
            bytHash = md5.ComputeHash(bytValue);
            md5.Clear();
            return Convert.ToBase64String(bytHash);
        }
    }


    // CRIPTOGRAFÍA BIDIRECCIONAL
    public static class DES
    {
        public static string funDES_ToBase64(string sValue)
        {
            byte[] bytBuff = System.Text.Encoding.UTF8.GetBytes(sValue);
            return Convert.ToBase64String(bytBuff);
        }

        public static string funDES_FromBase64(string sValue)
        {
            byte[] bytBuff = Convert.FromBase64String(sValue);
            return System.Text.Encoding.UTF8.GetString(bytBuff);
        }
    }


    // CLASE QUE UTILIZA MIUV PARA ENCRIPTAR LAS CREDENCIALES ENVIADAS
    // IMPORTADA DE LA APLICACIÓN MIUV
    public static class Encrypt
    {
        static int tamanoClave = 32; //tamaño de la clave de cifrado
        static int vectorInicio = 16; //vector de inicio para Rijndael

        static string llaveCadena = "colibriazul";//
        static string vectorCadena = "13976";//


        /**k
            * Cifra una cadena texto
            * 
            * @param	cadenaSinCifrar	mensaje sin cifrar
            * @return	string			texto cifrado
            */

        public static string fun_Encriptar(string sValue)
        {
            return encriptarCadenaRSA(sValue, getLlave(), getVector());
        }

        /**
            * Descifra una cadena texto
            * 
            * @param	cadenaCifrada	mensaje cifrado
            * @return	string			texto descifrado
            */

        public static string fun_Desencriptar(string sValue)
        {
            return desencriptaCadenaRSA(sValue, getLlave(), getVector());
        }

        /**
            * Cifra una cadena texto con el algoritmo de MD5
            * 
            * @param	cadenaSinCifrar	mensaje plano (sin cifrar)
            * @return	string			texto cifrado
            */

        public static string MD5(string cadenaSinCifrar)
        {
            MD5 md5 = MD5CryptoServiceProvider.Create();
            ASCIIEncoding encoding = new ASCIIEncoding();
            byte[] stream = null;
            StringBuilder sb = new StringBuilder();
            stream = md5.ComputeHash(encoding.GetBytes(cadenaSinCifrar));
            for (int i = 0; i < stream.Length; i++) sb.AppendFormat("{0:x2}", stream[i]);
            return sb.ToString();
        }

        /**
            * Cifra una cadena texto con el algoritmo de SHA1
            * 
            * @param	cadenaSinCifrar	mensaje plano (sin cifrar)
            * @return	string			texto cifrado
            */

        public static string SHA1(string cadenaSinCifrar)
        {
            SHA1 sha1 = SHA1Managed.Create();
            ASCIIEncoding encoding = new ASCIIEncoding();
            byte[] stream = null;
            StringBuilder sb = new StringBuilder();
            stream = sha1.ComputeHash(encoding.GetBytes(cadenaSinCifrar));
            for (int i = 0; i < stream.Length; i++) sb.AppendFormat("{0:x2}", stream[i]);
            return sb.ToString();
        }

        private static byte[] getLlave()
        {
            byte[] clave = UTF8Encoding.UTF8.GetBytes(llaveCadena);
            Array.Resize<byte>(ref clave, tamanoClave);
            return clave;
        }

        private static byte[] getVector()
        {
            byte[] vector = UTF8Encoding.UTF8.GetBytes(vectorCadena);
            Array.Resize<byte>(ref vector, vectorInicio);
            return vector;
        }

        /**
            * Cifra una cadena texto con el algoritmo de Rijndael
            * 
            * @param	cadenaSinCifrar	mensaje plano (sin cifrar)
            * @param	llave				clave del cifrado para Rijndael
            * @param	vector				vector de inicio para Rijndael
            * @return	string			texto cifrado
            */



        private static string encriptarCadenaRSA(string cadenaSinCifrar, byte[] llave, byte[] vector)
        {
            Rijndael RijndaelAlg = Rijndael.Create();

            MemoryStream memoryStream = new MemoryStream();

            CryptoStream cryptoStream = new CryptoStream(memoryStream,
                                                            RijndaelAlg.CreateEncryptor(llave, vector),
                                                            CryptoStreamMode.Write);
            byte[] plainMessageBytes = UTF8Encoding.UTF8.GetBytes(cadenaSinCifrar);

            cryptoStream.Write(plainMessageBytes, 0, plainMessageBytes.Length);

            cryptoStream.FlushFinalBlock();

            byte[] cipherMessageBytes = memoryStream.ToArray();
            memoryStream.Close();
            cryptoStream.Close();


            return Convert.ToBase64String(cipherMessageBytes);
        }

        /**
            * Descifra una cadena de texto cifrada con el algoritmo de Rijndael
            * 
            * @param	cadenaCifrada	mensaje cifrado
            * @param	llave					clave del cifrado para Rijndael
            * @param	vector					vector de inicio para Rijndael
            * @return	string				texto descifrado (plano)
            */

        private static string desencriptaCadenaRSA(string cadenaCifrada, byte[] llave, byte[] vector)
        {

            byte[] cipherTextBytes = Convert.FromBase64String(cadenaCifrada);

            byte[] plainTextBytes = new byte[cipherTextBytes.Length];

            Rijndael RijndaelAlg = Rijndael.Create();

            MemoryStream memoryStream = new MemoryStream(cipherTextBytes);

            CryptoStream cryptoStream = new CryptoStream(memoryStream,
                                                            RijndaelAlg.CreateDecryptor(llave, vector),
                                                            CryptoStreamMode.Read);
            int decryptedByteCount = cryptoStream.Read(plainTextBytes, 0, plainTextBytes.Length);


            memoryStream.Close();
            cryptoStream.Close();

            return Encoding.UTF8.GetString(plainTextBytes, 0, decryptedByteCount);
        }
    }

}