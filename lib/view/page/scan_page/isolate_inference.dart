import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:camera/camera.dart';

class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort,
        debugName: _debugName);
    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateModel isolateModel in port) {
      // Process Image
      img.Image processedImage = preprocessImage(isolateModel);

      // Convert Image to Byte List
      Uint8List input = _imageToByteListUint8(processedImage, isolateModel.inputSize);

      // Run Inference
      final output = runInference(input, isolateModel.interpreterAddress);

      // Send results back to the main thread
      isolateModel.responsePort.send(output.map((e) => e.toInt()).toList());
    }
  }

  static img.Image preprocessImage(IsolateModel model) {
    img.Image image = img.copyResize(
      model.image!,
      width: model.inputSize,
      height: model.inputSize,
    );

    if (Platform.isAndroid && model.isCameraFrame()) {
      image = img.copyRotate(image, 90);
    }

    return image;
  }

  static Uint8List _imageToByteListUint8(img.Image image, int inputSize) {
    Uint8List buffer = Uint8List(inputSize * inputSize * 3);
    var bufferIndex = 0;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        buffer[bufferIndex++] = img.getRed(pixel);
        buffer[bufferIndex++] = img.getGreen(pixel);
        buffer[bufferIndex++] = img.getBlue(pixel);
      }
    }
    return buffer;
  }

  static List<int> runInference(Uint8List input, int interpreterAddress) {
    Interpreter interpreter = Interpreter.fromAddress(interpreterAddress);
    var output = List<int>.filled(23, 0).reshape([1, 23]);

    try {
      interpreter.run(input, output);
    } catch (e) {
      print('Inference error: $e');
      return List<int>.filled(23, 0); // Default return on error
    }

    return output[0]; // Assuming you want to return a flat list of output values
  }

}

class IsolateModel {
  final CameraImage? cameraImage;
  final img.Image? image;
  final int interpreterAddress;
  final List<int> inputShape;
  final int inputSize;
  late SendPort responsePort;

  IsolateModel(
      this.cameraImage,
      this.image,
      this.interpreterAddress,
      this.inputShape,
      this.inputSize,
      );

  bool isCameraFrame() => cameraImage != null;
}
