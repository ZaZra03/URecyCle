import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  final _inputSize = 224;
  List<String> _labels = [];
  String _classificationResult = 'No result';
  bool _isProcessing = false;  // Flag to track if the classification is processing

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
    _loadLabels();
    _takePictureAndProcess(); // Trigger the capture and processing when the page is loaded
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController?.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Model Loading Error'),
            content: const Text('Unable to load the model. Please ensure that the file is correctly placed in the assets directory.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString('assets/model.txt');
      setState(() {
        _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      });
      print('Labels loaded successfully');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<void> _takePictureAndProcess() async {
    setState(() {
      _isProcessing = true;  // Start processing
    });

    try {
      print('Taking picture...');

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        print('No image selected.');
        setState(() {
          _isProcessing = false;  // Stop processing
        });
        return;
      }

      print('Image selected: ${pickedFile.path}');

      final bytes = await pickedFile.readAsBytes();
      final processedImage = _preprocessImage(bytes);

      Float32List input = _imageToByteListFloat32(processedImage, _inputSize);

      print('Running inference...');
      final output = _runInference(input);

      if (output.isEmpty) {
        print('Inference output is empty.');
        setState(() {
          _isProcessing = false;  // Stop processing
        });
        return;
      }

      int maxIndex = output.indexWhere((element) => element == output.reduce((a, b) => a > b ? a : b));
      print('Inference result index: $maxIndex, label: ${_labels[maxIndex]}');

      setState(() {
        _classificationResult = _labels[maxIndex];
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isProcessing = false;  // Stop processing
      });
    }
  }

  img.Image _preprocessImage(Uint8List imageData) {
    print('Preprocessing image...');
    img.Image image = img.decodeImage(imageData)!;
    img.Image resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);
    print('Image resized to $_inputSize x $_inputSize');
    return resizedImage;
  }

  Float32List _imageToByteListFloat32(img.Image image, int inputSize) {
    print('Converting image to Float32List...');
    var buffer = Float32List(inputSize * inputSize * 3);
    var bufferIndex = 0;
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        buffer[bufferIndex++] = (img.getRed(pixel) / 127.5) - 1.0;
        buffer[bufferIndex++] = (img.getGreen(pixel) / 127.5) - 1.0;
        buffer[bufferIndex++] = (img.getBlue(pixel) / 127.5) - 1.0;
      }
    }
    print('Image converted to Float32List.');
    return buffer;
  }

  List<double> _runInference(Float32List input) {
    print('Running model inference...');

    var inputShape = [1, _inputSize, _inputSize, 3];
    var reshapedInput = input.buffer.asFloat32List(0, input.length);

    var output = List.filled(6, 0.0).reshape([1, 6]);

    _interpreter?.run(reshapedInput.reshape(inputShape), output);

    print('Inference complete. Output: $output');
    return output[0]; // Returning the first (and only) output array
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()  // Show loading indicator while processing
            : Text(
          'Result: $_classificationResult',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }
}
