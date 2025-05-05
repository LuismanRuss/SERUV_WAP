using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using iTextSharp.text;
using iTextSharp.text.pdf;

/// <summary> 
/// URL: http://stackoverflow.com/questions/5871831/how-to-use-itextsharp-to-remove-the-security-of-a-pdf-and-water-watermark-the-pd
/// Código adaptado a las necesitades del SERUV
/// MTI José Aroldo Alfaro Ávila
/// 01/Julio/2013
/// </summary>

namespace nsSERUV
{
    public class clsWaterMark : IDisposable
    {
        #region "Variables privadas"
        private byte[] _aPDFBytes;
        #endregion


        #region "Propiedades públicas de la clase"
        public byte[] PDFBytes { get { return _aPDFBytes; } }
        #endregion


        #region "Constructor de la Clase"
        public clsWaterMark(byte[] aPDFBytes, string sText)
        {
            _aPDFBytes = aPDFBytes;
            //pAddWatermarkText("", "", sText, BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED), 17, BaseColor.BLACK, 0.3f, 30f);
            pAddWatermarkText(sText, BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED), 17, BaseColor.BLACK, 0.3f, 45f);
        }
        #endregion

        //private void pAddWatermarkText(string sourceFile, string outputFile, string watermarkText, BaseFont watermarkFont, float watermarkFontSize, BaseColor watermarkFontColor, float watermarkFontOpacity, float watermarkRotation)
        private void pAddWatermarkText(string watermarkText, BaseFont watermarkFont, float watermarkFontSize, BaseColor watermarkFontColor, float watermarkFontOpacity, float watermarkRotation)
        {
            try
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    PdfReader reader = null;
                    PdfStamper stamper = null;
                    PdfGState gstate = null;
                    PdfContentByte underContent = null;
                    Rectangle rect = null;
                    int pageCount = 0;

                    ////reader = new PdfReader(sourceFile);
                    reader = new PdfReader(_aPDFBytes);
                    rect = reader.GetPageSizeWithRotation(1);
                    ////stamper = new PdfStamper(reader, new FileStream(outputFile, FileMode.CreateNew), '\0', true);
                    stamper = new PdfStamper(reader, ms);

                    gstate = new PdfGState();
                    gstate.FillOpacity = watermarkFontOpacity;
                    gstate.StrokeOpacity = watermarkFontOpacity;
                    pageCount = reader.NumberOfPages;
                    for (int i = 1; i <= pageCount; i++)
                    {
                        underContent = stamper.GetUnderContent(i);
                        //_with1 = underContent;
                        underContent.SaveState();
                        underContent.SetGState(gstate);
                        underContent.SetColorFill(watermarkFontColor);
                        underContent.BeginText();
                        underContent.SetFontAndSize(watermarkFont, watermarkFontSize);
                        underContent.SetTextMatrix(30, 30);
                        underContent.ShowTextAligned(Element.ALIGN_CENTER, watermarkText, rect.Width / 2, rect.Height / 2, watermarkRotation);
                        underContent.EndText();
                        underContent.RestoreState();
                    }
                    stamper.Close();
                    reader.Close();
                    _aPDFBytes = ms.ToArray();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region "Dispose"
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}