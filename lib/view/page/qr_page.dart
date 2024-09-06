import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:urecycle_app/view/page/scan_page.dart';

class BarcodeScannerWithOverlay extends StatefulWidget {
  const BarcodeScannerWithOverlay({super.key});

  @override
  State createState() => _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<BarcodeScannerWithOverlay> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  final String targetQRCode = 'URECYCLE'; // Define the target value

  @override
  void initState() {
    super.initState();
    controller.start(); // Automatically start the scanner
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
          // The Scanner View
          MobileScanner(
            fit: BoxFit.cover,
            controller: controller,
            scanWindow: scanWindow,
            // errorBuilder: (context, error, child) {
            //   return ScannerErrorWidget(error: error);
            // },
          ),
          // Overlay for scan window
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized || !value.isRunning || value.error != null) {
                return const SizedBox.shrink();
              }
              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          // Positioned Flashlight and Switch Camera buttons
          Positioned(
            top: 50.0, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleFlashlightButton(controller: controller),
                SwitchCameraButton(controller: controller),
              ],
            ),
          ),
          // Label for Scanned Barcodes
          Positioned(
            bottom: 50.0, // Adjust the position as needed
            left: 16.0,
            right: 16.0,
            child: ScannedBarcodeLabel(
              barcodes: controller.barcodes,
              targetQRCode: targetQRCode,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    // controller.stop();
    controller.dispose();
    super.dispose();
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

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const Icon(
              Icons.no_flash,
              color: Colors.grey,
            );
        }
      },
    );
  }
}

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
        }

        return IconButton(
          iconSize: 32.0,
          icon: icon,
          onPressed: () async {
            await controller.switchCamera();
          },
        );
      },
    );
  }
}

class ScannedBarcodeLabel extends StatefulWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
    required this.targetQRCode,
  });

  final Stream<BarcodeCapture> barcodes;
  final String targetQRCode;

  @override
  State createState() => _ScannedBarcodeLabelState();
}

class _ScannedBarcodeLabelState extends State<ScannedBarcodeLabel> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.barcodes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'Error scanning. Please try again.',
            style: TextStyle(color: Colors.red),
          );
        }
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isNotEmpty) {
          final displayValue = scannedBarcodes.first.displayValue ?? 'No display value.';

          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (displayValue == widget.targetQRCode) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Scan(),
                ),
              );
            }
          });

          return Text(
            displayValue,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white),
          );
        }

        return const Text(
          'Scan something!',
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }
}
