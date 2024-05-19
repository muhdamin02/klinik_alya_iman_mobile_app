import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/widgets.dart';

Future<void> generateAndSavePDF(
    BuildContext context, List<dynamic> appointmentStats) async {
  final pdf = pdfLib.Document();
  pdf.addPage(
    pdfLib.Page(
      build: (pdfLib.Context context) {
        return pdfLib.Center(
          child: pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Text('Appointment Statistics',
                  style: pdfLib.TextStyle(
                      fontSize: 24, fontWeight: pdfLib.FontWeight.bold)),
              pdfLib.SizedBox(height: 20),
              TableHelper.fromTextArray(
                headers: ['Metric', 'Value'],
                data: [
                  ['Appointments Attended', appointmentStats[0].toString()],
                  ['Appointments Absent', appointmentStats[1].toString()],
                  ['Total Appointments', appointmentStats[2].toString()],
                  [
                    'Attendance Percentage',
                    appointmentStats[3].toStringAsFixed(2)
                  ],
                ],
                cellAlignment: pdfLib.Alignment.centerLeft,
                headerStyle:
                    pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                cellHeight: 30,
                cellPadding: const pdfLib.EdgeInsets.all(5),
              ),
            ],
          ),
        );
      },
    ),
  );

  // Get the document directory
  final directory = await getApplicationDocumentsDirectory();
  DateTime now = DateTime.now();
  DateTime formattedNow =
      DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);

  final filePath = '${directory.path}/report $formattedNow.pdf';

  // Save the PDF to the document directory
  final Uint8List bytes = await pdf.save();
  final file = File(filePath);
  await file.writeAsBytes(bytes);

  // Open the PDF using the device's default PDF viewer
  await OpenFilex.open(filePath);
}
