import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:urecycle_app/view/page/scan_page.dart';
import '../../services/leaderboard_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScanner extends StatefulWidget {
  final String role;
  final Map<String, bool> binStates;

  const QRScanner({super.key, required this.role, this.binStates = const {}});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isProcessing = false;

  @override
  void initState() {
    print('QRScanner binStates: ${widget.binStates}');
    super.initState();
    _checkAndResetFlagIfNecessary();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final lastScanTime = prefs.getInt('lastScanTime') ?? 0;
      final scannedNonTrash = prefs.getBool('lastScannedNonTrash') ?? false;

      // Get the current timestamp
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Cooldown duration in milliseconds
      const int cooldownDurationMs = 1 * 60 * 1000;

      // Check if the cooldown is still active
      if (scannedNonTrash && currentTime - lastScanTime < cooldownDurationMs) {
        final remainingTime = ((cooldownDurationMs - (currentTime - lastScanTime)) ~/ 60000);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please wait $remainingTime minute(s) before scanning again.'),
          ),
        );

        // Reset processing state and restart scanner
        setState(() {
          _isProcessing = false;
        });
        controller.start();
        return;
      }

      await prefs.setInt('lastScanTime', currentTime);

      // Check if scannedCode matches one of the valid bin types
      const validCodes = ['Plastic', 'Metal', 'Glass', 'Cardboard', 'Paper'];
      if (validCodes.contains(scannedCode)) {
        if (widget.binStates[scannedCode] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scan(scannedCategory: scannedCode),
            ),
          ).then((_) {
            controller.start();
            setState(() {
              _isProcessing = false;
            });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$scannedCode bin is closed.'),
            ),
          );

          // Reset processing state and restart scanner
          setState(() {
            _isProcessing = false;
          });
          controller.start();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid QR code scanned.'),
          ),
        );

        // Reset processing state and restart scanner
        setState(() {
          _isProcessing = false;
        });
        controller.start();
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
          _isProcessing = false; // Reset processing flag after completion
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
                // Restart the scanner after closing the dialog
                controller.start();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _checkAndResetFlagIfNecessary() async {
    final prefs = await SharedPreferences.getInstance();
    final lastScanTime = prefs.getInt('lastScanTime') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Cooldown duration in milliseconds
    const int cooldownDurationMs = 5 * 60 * 1000;

    // Reset the flag only if cooldown has elapsed
    if (currentTime - lastScanTime > cooldownDurationMs) {
      await prefs.setBool('lastScannedNonTrash', false);
    }
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
