import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class TicketPdf {
  double widthPrinterInMm;
  double widthPrinterinPx = 150.0;
  String? organizationName;
  String? companyName;
  String? ruc;
  List<String>? mediaData;
  String? typeDocumentSale;
  String? serieDocument;
  String? typeDocumentClient;
  String? documentNumberClient;
  String? nameClient;
  String? addressClient;
  String? emisionDate;
  String? expirationDate;
  String? sellerName;
  String? logoImage;
  String? slogan;
  List<PrintableProduct>? products;
  List<PrintableTotal>? totalDescriptions;
  List<PrintableTotal>? totalDescriptionsPayment;
  List<PrintableTotal>? listDeliveryData;
  List<String>? bankAccounts;

  TicketPdf(
      {required this.widthPrinterInMm,
      this.organizationName,
      this.companyName,
      this.ruc,
      this.mediaData,
      this.typeDocumentSale,
      this.serieDocument,
      this.typeDocumentClient,
      this.documentNumberClient,
      this.nameClient,
      this.addressClient,
      this.emisionDate,
      this.expirationDate,
      this.sellerName,
      this.slogan,
      this.products,
      this.totalDescriptions,
      this.totalDescriptionsPayment,
      this.bankAccounts,
      this.listDeliveryData,
      this.logoImage})
      : widthPrinterinPx = widthPrinterInMm * 2.8;

  Future<List<int>> generatePDF() async {
    final pdf = pw.Document();
    // final netImage = await networkImage(logoImage ??
    //     "https://laesystems.com/principal/assets/img/backgrounds/logo_laesystems.png?ver=2.1.0");

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat(widthPrinterinPx, double.infinity, marginAll: 10.0),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // pw.Container(
              //   width: widthPrinterinPx - 20,
              //   child: pw.Row(
              //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //       children: [
              //         pw.SizedBox(width: 15.0),
              //         pw.Image(netImage, width: widthPrinterinPx - 85),
              //         pw.SizedBox(width: 15.0),
              //       ]),
              // ),
              pw.Container(
                width: widthPrinterinPx - 20,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(height: 15.0),
                      pw.Column(children: [
                        textPdf(organizationName ?? "", isBold: true),
                        textPdf(companyName ?? "", isBold: true),
                        textPdf("RUC: ${ruc ?? ""}", isBold: true),
                        pw.Column(
                            children: List.generate((mediaData ?? []).length,
                                (index) => textPdf(mediaData![index]))),
                        textPdf(
                            "${generateNameDocumentSale(typeDocumentSale!)} ${serieDocument ?? ""}",
                            isBold: true),
                      ]),
                      pw.SizedBox(height: 15.0),
                    ]),
              ),
              pw.SizedBox(height: 9.0),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    textPdfRight(
                        "${typeDocumentClient ?? "OTROS"}          ${documentNumberClient ?? "0"}"),
                    textPdf(nameClient ?? "clientes varios", isCentered: false),
                    textPdf(addressClient ?? "", isCentered: false),
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
                            textPdfRight(emisionDate ?? ""),
                          ],
                        ),
                        pw.SizedBox(width: 5.0),
                        pw.Row(
                          children: [
                            textPdfRight("FE. VCTO.", isBold: true),
                            pw.SizedBox(width: 5.0),
                            textPdfRight(expirationDate ?? ""),
                          ],
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        textPdfRight("CAJERO", isBold: true),
                        pw.SizedBox(width: 5.0),
                        textPdfRight(sellerName ?? ""),
                      ],
                    ),
                  ]),
              pw.SizedBox(height: 9.0),
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['CANT.', 'DESCRIPCIÓN', 'P.U.', 'TOTAL'],
                  ...products!.map((item) => [
                        item.quantity,
                        item.name,
                        item.price,
                        item.total,
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
              pw.SizedBox(height: 9.0),
              pw.Container(
                  child: pw.Column(
                      children: List.generate(
                          (totalDescriptions ?? []).length,
                          (index) => pw.Row(children: [
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Row(children: [
                                    pw.Spacer(),
                                    textPdfRight(
                                        totalDescriptions![index].description,
                                        isBold: true),
                                  ]),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Spacer(),
                                    textPdfRight(
                                        totalDescriptions![index].value,
                                        isBold: true),
                                  ]),
                                ),
                              ])))),
              pw.SizedBox(height: 9.0),
              pw.Container(
                  child: pw.Column(
                      children: List.generate(
                          (totalDescriptionsPayment ?? []).length,
                          (index) => pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    textPdfRight(
                                        "${totalDescriptionsPayment![index].description}:",
                                        isBold: true),
                                    pw.SizedBox(width: 4.0),
                                    pw.Container(
                                      width: widthPrinterinPx - 85,
                                      child: textPdf(
                                          totalDescriptionsPayment![index]
                                              .value,
                                          isCentered: false),
                                    ),
                                  ])))),
              pw.SizedBox(height: 9.0),
              pw.Container(
                  child: pw.Column(
                      children: List.generate(
                          (listDeliveryData ?? []).length,
                          (index) => pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    textPdfRight(
                                        "${listDeliveryData![index].description}:",
                                        isBold: true),
                                    pw.SizedBox(width: 4.0),
                                    pw.Container(
                                      width: widthPrinterinPx - 85,
                                      child: textPdf(
                                          listDeliveryData![index].value,
                                          isCentered: false),
                                    ),
                                  ])))),
              pw.SizedBox(height: 9.0),
              textPdf("CUENTAS BANCARIAS", isBold: true, isCentered: false),
              pw.Container(
                  child: pw.Column(
                      children: List.generate(
                (bankAccounts ?? []).length,
                (index) => textPdf(bankAccounts![index], isCentered: false),
              ))),
              pw.SizedBox(height: 9.0),
              typeDocumentSale != "2"
                  ? pw.Column(children: [
                      textPdf(
                        "Representación impresa de la ${generateNameDocumentSale(typeDocumentSale!)}, visita laesystems.com",
                      ),
                      pw.SizedBox(height: 9.0),
                    ])
                  : pw.SizedBox(),
              textPdf(
                slogan ?? "",
              ),
              pw.SizedBox(height: 5.0),
              textPdf(
                "Generado por laesystems.com",
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Container textPdf(String text,
      {bool isBold = false, bool isCentered = true}) {
    return pw.Container(
        padding: const pw.EdgeInsets.only(top: 1.0),
        width: widthPrinterinPx - 20,
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

  String generateNameDocumentSale(String code) {
    String name = "";
    switch (code) {
      case "2":
        name = "NOTA DE VENTA";
        break;
      case "3":
        name = "FACTURA";
        break;
      case "4":
        name = "BOLETA";
        break;
      default:
        name = "NOTA DE VENTA";
    }

    return name;
  }
}

class PrintableProduct {
  String quantity;
  String name;
  String price;
  String total;

  PrintableProduct(
      {required this.quantity,
      required this.name,
      required this.price,
      required this.total});
}

class PrintableTotal {
  String description;
  String value;

  PrintableTotal({required this.description, required this.value});
}
