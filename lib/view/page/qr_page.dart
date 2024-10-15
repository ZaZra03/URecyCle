import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:urecycle_app/view/page/scan_page.dart';
import '../../services/leaderboard_service.dart';

class QRScanner extends StatefulWidget {
  final String role;

  const QRScanner({super.key, required this.role});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    // detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _processScannedCode(BuildContext context, String? scannedCode) async {
    if (scannedCode == null || _isProcessing) return;

    setState(() {
      _isProcessing = true; // Prevent multiple scans
    });

    // Optionally stop the camera while processing
    controller.stop();

    if (widget.role == 'student') {
      if (scannedCode == 'URECYCLE') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Scan(),
          ),
        ).then((_) {
          // Restart scanner when returning to the page
          controller.start();
          setState(() {
            _isProcessing = false; // Reset the processing flag after navigation
          });
        });
      }
    } else if (widget.role == 'admin') {
      final leaderboardService = LeaderboardService();
      try {
        final data = jsonDecode(scannedCode);
        String name = data['name'];
        String studentNumber = data['studentNumber'];
        int points = data['points'];

        // Deduct points and show reward details
        await leaderboardService.deductPointsFromUser(
          studentNumber,
          (points * 10).toInt(),
        );

        // Show reward details and reset _isProcessing after dialog closes
        await _showRewardDetails(context, name, points);
      } catch (e) {
        print('Failed to decode QR code: $e');
      } finally {
        controller.start(); // Restart scanner
        setState(() {
          _isProcessing = false; // Reset the processing flag after completion
        });
      }
    }
  }



  Future<void> _showRewardDetails(BuildContext context, String name, int points) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reward Details'),
          content: Text('Reward: $name\nPoints: $points'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Restart the scanner after closing the dialog to scan the same code again
                controller.start();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        (MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight) / 2,
      ),
      width: 200,
      height: 200,
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final scannedCode = barcodes.first.rawValue;
                _processScannedCode(context, scannedCode);
              }
            },
          ),
          // Overlay for the scan window
          CustomPaint(
            painter: ScannerOverlay(scanWindow: scanWindow),
          ),
          Positioned(
            top: 50.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.white,
                  iconSize: 32.0,
                  icon: const Icon(Icons.flash_on),
                  onPressed: () async {
                    await controller.toggleTorch();
                  },
                ),
                IconButton(
                  color: Colors.white,
                  iconSize: 32.0,
                  icon: const Icon(Icons.cameraswitch),
                  onPressed: () async {
                    await controller.switchCamera();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow || borderRadius != oldDelegate.borderRadius;
  }
}
