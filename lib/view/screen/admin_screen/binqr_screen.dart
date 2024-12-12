import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../constants.dart';

class BinQRScreen extends StatefulWidget {
  const BinQRScreen({super.key});

  @override
  State createState() => _BinQRScreenState();
}

class _BinQRScreenState extends State<BinQRScreen> {
  static const String _fixedSalt = "urecycle_salt2024";
  final Map<String, String> _binQRData = {
    'Plastic': '',
    'Metal': '',
    'Glass': '',
    'Paper': '',
    'Cardboard': '',
  };

  @override
  void initState() {
    super.initState();
    _generateAllQRs();
  }

  void _generateQR(String binType) {
    final randomValue = Random().nextInt(1 << 32).toString();
    final qrData = jsonEncode({
      "binType": binType,
      "hash": sha256.convert(utf8.encode('$binType$_fixedSalt$randomValue')).toString(),
    });
    setState(() {
      _binQRData[binType] = qrData;
    });
  }


  void _generateAllQRs() {
    _binQRData.keys.forEach(_generateQR);
  }

  Future<void> _exportToPdf({String? specificBin}) async {
    final pdf = pw.Document();

    final binsToExport = specificBin != null
        ? {specificBin: _binQRData[specificBin]!}
        : _binQRData;

    binsToExport.forEach((bin, qrData) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    '$bin Bin QR Code',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    height: 200,
                    width: 200,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: qrData,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });

    final directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final file = File('${directory.path}/BinQRReport.pdf');
    await file.writeAsBytes(await pdf.save());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to Downloads folder: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bin QR Codes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportToPdf(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: _binQRData.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '${entry.key} Bin',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    QrImageView(
                      data: entry.value,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _exportToPdf(specificBin: entry.key),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Export QR'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _generateQR(entry.key),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Regenerate QR'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
