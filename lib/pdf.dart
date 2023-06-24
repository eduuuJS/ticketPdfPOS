import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<List<int>> generatePDF() async {
  const width = 210.0;
  final pdf = pw.Document();
  final date = DateTime.now();
  List<Map<String, dynamic>> productos = [
    {
      'cantidad': "1.000 PR",
      'descripcion': 'COJIN ORTOPÉDICO D',
      'precioUnitario': 10.00,
      'total': 20.00
    },
    {
      'cantidad': "15.000 NIU",
      'descripcion': 'BLUSA BLANCA VERDE S',
      'precioUnitario': 15.00,
      'total': 45.00
    },
    {
      'cantidad': "12.000 BG",
      'descripcion': 'avarios',
      'precioUnitario': 8.00,
      'total': 8.00
    },
    {
      'cantidad': "6.000 NIU",
      'descripcion': 'ARROZ CON POLLO',
      'precioUnitario': 8.00,
      'total': 8.00
    },
  ];

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(width, double.infinity, marginAll: 10.0),
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.SizedBox(height: 15.0),
            pw.Container(
              width: width - 20,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(height: 15.0),
                    pw.Column(children: [
                      textPdf("L", isBold: true),
                      textPdf("EMPRESA PRUEBA", isBold: true),
                      textPdf("RUC: 12345678901", isBold: true),
                      textPdf("AV. DOS DE MAYOR NRO. 516 (OFICINA 201)"),
                      textPdf(
                          "Web: laesystems.com / FB: laesystemsperu / IG: @laesystems info@laesystems.com"),
                      textPdf("995885177"),
                      textPdf("FACTURA ELECTRÓNICA $date", isBold: true),
                    ]),
                    pw.SizedBox(height: 15.0),
                  ]),
            ),
            pw.SizedBox(height: 9.0),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  textPdfRight("RUC          20602630073"),
                  textPdf(
                      "SOLUCIONES EMPRESARIALES SEAR S.A.C. CAL. LAS GAVIOTAS INT. 2P MZA. L LOTE 18 URB. LOS PINOS",
                      isCentered: false),
                ]),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Row(
                        children: [
                          textPdfRight("FE. EMISIÓN", isBold: true),
                          pw.SizedBox(width: 5.0),
                          textPdfRight("23/06/2023 16:41:13"),
                        ],
                      ),
                      pw.SizedBox(width: 5.0),
                      pw.Row(
                        children: [
                          textPdfRight("FE. VCTO.", isBold: true),
                          pw.SizedBox(width: 5.0),
                          textPdfRight("23/06/2023"),
                        ],
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      textPdfRight("CAJERO", isBold: true),
                      pw.SizedBox(width: 5.0),
                      textPdfRight("GEANCARLOS"),
                    ],
                  ),
                ]),
            pw.SizedBox(height: 9.0),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['CANT.', 'DESCRIPCIÓN', 'P.U.', 'TOTAL'],
                ...productos.map((item) => [
                      item['cantidad'].toString(),
                      item['descripcion'],
                      '${item['precioUnitario']}',
                      '${item['total']}',
                    ]),
              ],
              headerStyle: pw.TextStyle(
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(
                fontSize: 7,
              ),
              border: null,
              headerPadding: const pw.EdgeInsets.all(1),
              cellPadding: const pw.EdgeInsets.all(1),
              cellAlignment: pw.Alignment.center,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

pw.Container textPdf(String text,
    {bool isBold = false, bool isCentered = true, double width = 210}) {
  return pw.Container(
      padding: const pw.EdgeInsets.only(top: 1.0),
      width: width - 20,
      alignment: isCentered ? pw.Alignment.center : pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        textAlign: isCentered ? pw.TextAlign.center : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: isBold ? pw.FontWeight.bold : null,
        ),
      ));
}

pw.Container textPdfRight(
  String text, {
  bool isBold = false,
}) {
  return pw.Container(
      padding: const pw.EdgeInsets.only(top: 1.0),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: isBold ? pw.FontWeight.bold : null,
        ),
      ));
}
