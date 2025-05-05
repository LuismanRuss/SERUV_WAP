using System;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;


/// <summary>
/// Clase que se usa para agregar marca de agua a los arhivos PDF, código adaptado a las necesidades del SERUV
/// </summary>

public class clsWaterMark2 : IDisposable
{
    #region "Variables privadas"
    private byte[] _aPDFBytes;
    #endregion

    #region "Propiedades públicas de la clase"
    public byte[] PDFBytes { get { return _aPDFBytes; } }
    #endregion


    #region "Constructor de la Clase"
    public clsWaterMark2(byte[] aPDFBytes, string sText)
    {
        _aPDFBytes = aPDFBytes;
        //pAddWatermarkText("", "", sText, BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED), 17, BaseColor.BLACK, 0.3f, 30f);
        pAddWatermarkText(sText, BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED), 17, BaseColor.BLACK, 0.3f, 30f);
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

                for (int nPag = 1; nPag <= reader.NumberOfPages; nPag++)
                {
                    Rectangle tamPagina = reader.GetPageSizeWithRotation(nPag);
                    PdfContentByte over = stamper.GetOverContent(nPag);
                    over.BeginText();
                    WriteTextToDocument(watermarkFont, tamPagina, over, gstate, watermarkText);
                    over.EndText();
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

    private static void WriteTextToDocument(BaseFont bf, Rectangle tamPagina, PdfContentByte over, PdfGState gs, string texto)

    {
        over.SetGState(gs);
        over.SetRGBColorFill(220, 220, 220);
        over.SetTextRenderingMode(PdfContentByte.TEXT_RENDER_MODE_STROKE);
        over.SetFontAndSize(bf, 46);
        Single anchoDiag = (Single)Math.Sqrt(Math.Pow((tamPagina.Height - 120), 2) + Math.Pow((tamPagina.Width - 60), 2));
        Single porc = (Single)100 * (anchoDiag / bf.GetWidthPoint(texto, 46));
        over.SetHorizontalScaling(porc);
        double angPage = (-1) * Math.Atan((tamPagina.Height - 60) / (tamPagina.Width - 60));
        over.SetTextMatrix((float)Math.Cos(angPage), (float)Math.Sin(angPage), (float)((-1F) * Math.Sin(angPage)),
        (float)Math.Cos(angPage), 30F, (float)tamPagina.Height - 60);
        over.ShowText(texto);
    }
    #region "Dispose"
    public void Dispose()
    {
        GC.SuppressFinalize(this);
    }
    #endregion
}
