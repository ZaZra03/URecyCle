import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

import '../../constants.dart';

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
  String _classificationResult = '';
  bool _isProcessing = true;
  bool _isCameraInitialized = false;
  int? _classificationIndex;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
    _loadLabels();
    WidgetsBinding.instance.addPostFrameCallback((_) => _takePictureAndProcess());
  }

  Future<void> _initializeCamera() async {
    if (_isCameraInitialized) return;  // Prevent reinitialization if already initialized

    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController?.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;  // Set flag to true after initialization
      });
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
    try {
      print('Taking picture...');

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        print('No image selected.');
        if (mounted) {
          setState(() {
            _isProcessing = false;
            _classificationResult = 'No image selected.';
          });
        }
        return;
      }

      print('Image selected: ${pickedFile.path}');

      final bytes = await pickedFile.readAsBytes();
      final processedImage = _preprocessImage(bytes);

      Float32List input = _imageToByteListFloat32(processedImage, _inputSize);

      print('Running inference...');
      final output = _runInference(input);

      int maxIndex = output.indexWhere((element) => element == output.reduce((a, b) => a > b ? a : b));
      print('Inference result index: $maxIndex, label: ${_labels[maxIndex]}');

      if (mounted) {
        setState(() {
          _classificationResult = _labels[maxIndex];
          _classificationIndex = maxIndex;
        });
      }

      // Navigate directly to the result screen based on the classification result
      if (mounted) {
        if (_classificationIndex != null && _classificationIndex! >= 0 && _classificationIndex! <= 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Green(result: _classificationResult)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Red(result: _classificationResult)),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          _classificationResult = 'Error occurred while processing.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
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
    return output[0];
  }

  @override
  Widget build(BuildContext context) {
    return _isProcessing
        ? Container() // Show an empty container while processing
        : Scaffold(
      body: Center(
        child: _cameraController != null && _cameraController!.value.isInitialized
            ? CameraPreview(_cameraController!)
            : const CircularProgressIndicator(),  // Show loading while camera is initializing
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

class Red extends StatelessWidget {
  final String result;

  const Red({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.workspace_premium_outlined,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thanks for being eco-friendly!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Disposed Waste: $result',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'You have received 10 points!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8, // Responsive width
                    alignment: Alignment.center,
                    child: const Text(
                      "Go Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Green extends StatelessWidget {
  final String result;

  const Green({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.workspace_premium_outlined,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thanks for being eco-friendly!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Disposed Waste: $result',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'You have received 10 points!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8, // Responsive width
                    alignment: Alignment.center,
                    child: const Text(
                      "Go Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
