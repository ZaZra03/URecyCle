import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import 'package:urecycle_app/services/transaction_service.dart';
import 'package:urecycle_app/view/widget/loading_widget.dart';
import '../../provider/user_provider.dart';
import '../../constants.dart';
import '../screen/user_screen.dart';

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
  // bool _isCameraInitialized = false;
  int? _classificationIndex;

  @override
  void initState() {
    super.initState();
    print("InitState");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Calling Methods");
      _initializeCamera();
      _loadModel();
      _loadLabels();
      _initializeUserProvider();
    });
  }

  void _initializeUserProvider() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user == null || userProvider.lbUser == null) {
      userProvider.fetchUserData();
    }
  }

  Future<void> _initializeCamera() async {
    print("Initializing Scan Camera");
    // print(_isCameraInitialized);
    // if (_isCameraInitialized) return;

    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController?.initialize();
    // if (mounted) {
    //   setState(() {
    //     _isCameraInitialized = true;
    //   });
    // }

    _takePictureAndProcess();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/mobilenetv2_uint8.tflite');
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
      final labelsData = await rootBundle.loadString('assets/mobilenetv3.txt');
      setState(() {
        _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      });
      print('Labels loaded successfully');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<void> _takePictureAndProcess() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    try {
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

      final bytes = await pickedFile.readAsBytes();
      final processedImage = _preprocessImage(bytes);
      final output = _runInference(processedImage);
      int maxScore = output.reduce((a, b) => a > b ? a : b);
      int maxIndex = output.indexWhere((element) => element == maxScore);
      print(maxScore);
      print(maxIndex);

      for (int i = 0; i < output.length; i++) {
        print('${_labels[i]}: ${output[i]}');
      }


      if (mounted) {
        if (maxScore <= 0.5) {
          // Show the "Unknown" result if the confidence score is not greater than 0.65
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Unknown(result: 'Unknown')),
          );
        } else {
          setState(() {
            _classificationResult = _labels[maxIndex];
            _classificationIndex = maxIndex;
          });

          // Handle points, navigation, etc., only if it's a valid classification
          if (_classificationIndex != null && _classificationIndex! >= 0 && _classificationIndex! <= 22) {


            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Recycle(result: _classificationResult)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Trash(result: _classificationResult)),
            );
          }
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

// Resize and convert the image to Uint8List
  Uint8List _preprocessImage(Uint8List imageData) {
    print('Preprocessing image...');

    // Decode the image to an Image object
    img.Image image = img.decodeImage(imageData)!;

    // Resize the image to the model's expected input size (e.g., 224x224)
    img.Image resizedImage = img.copyResize(image, width: _inputSize, height: _inputSize);

    // Convert the resized image to raw RGB pixel data in Uint8List format
    var buffer = Uint8List(_inputSize * _inputSize * 3);  // 224 * 224 * 3 (for RGB)
    var bufferIndex = 0;

    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        int pixel = resizedImage.getPixel(x, y);
        buffer[bufferIndex++] = img.getRed(pixel);   // Red channel
        buffer[bufferIndex++] = img.getGreen(pixel); // Green channel
        buffer[bufferIndex++] = img.getBlue(pixel);  // Blue channel
      }
    }

    print('Image converted to raw RGB Uint8List.');
    return buffer;  // Return raw pixel data as Uint8List
  }


// Run inference using the Uint8List image data
  List<int> _runInference(Uint8List inputImage) {
    print('Running model inference...');

    var inputShape = [1, _inputSize, _inputSize, 3];

    // Pass the Uint8List directly as input
    var output = List<int>.filled(23, 0).reshape([1, 23]);  // Adjust to the output size of your model

    // Run inference
    _interpreter?.run(inputImage.reshape(inputShape), output);

    print('Inference complete. Output: $output');
    return output[0];
  }



  @override
  Widget build(BuildContext context) {
    return _isProcessing || _cameraController == null || !_cameraController!.value.isInitialized
        ? const LoadingPage()  // Show loading while processing or initializing
        : Scaffold(
      body: Center(
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  @override
  void dispose() {
    _isProcessing = false;
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }
}

class Trash extends StatelessWidget {
  final String result;

  const Trash({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.grey[800],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.delete_outline,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Waste Disposal Notice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Scanned Waste: $result',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please dispose of it properly.',
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const UserScreen(role: 'user')),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
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
              const SizedBox(height: 20), // Add space between buttons
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Navigate to Learn More page or perform an action
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
                    alignment: Alignment.center,
                    child: const Text(
                      "Learn More",
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

class Unknown extends StatelessWidget {
  final String result;

  const Unknown({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.help_outline,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Unknown Disposal Notice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Scanned Waste: $result',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'This waste type is not recognized. Please check and dispose of it responsibly.',
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const UserScreen(role: 'user')),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
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
              const SizedBox(height: 20), // Add space between buttons
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Navigate to Learn More page or perform an action
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
                    alignment: Alignment.center,
                    child: const Text(
                      "Learn More",
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

class Recycle extends StatelessWidget {
  final String result;

  const Recycle({super.key, required this.result});

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
                'Scanned Waste: $result(Recyclable)',
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const UserScreen(role: 'user')),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
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
              const SizedBox(height: 20), // Add space between buttons
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Navigate to Learn More page or perform an action
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
                    alignment: Alignment.center,
                    child: const Text(
                      "Learn More",
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
