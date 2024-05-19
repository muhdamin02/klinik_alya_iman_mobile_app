import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

Future<void> generateAndSavePDF(BuildContext context) async {
  final pdf = pdfLib.Document();
  pdf.addPage(
    pdfLib.Page(
      build: (pdfLib.Context context) {
        return pdfLib.Center(
          child: pdfLib.Text('Hello, this is a PDF document!'),
        );
      },
    ),
  );

  // Get the document directory
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/example.pdf';

  // Save the PDF to the document directory
  final Uint8List bytes = await pdf.save();
  await File(filePath).writeAsBytes(bytes);

  // Open the PDF using the device's default PDF viewer
  ProcessResult result = await Process.run('open', [filePath]);
  print(result.stdout);
  print(result.stderr);
}
