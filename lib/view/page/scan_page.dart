import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import 'package:urecycle_app/services/transaction_service.dart';
import 'package:urecycle_app/view/widget/loading_widget.dart';
import '../../provider/user_provider.dart';
import '../screen/user_screen/user_screen.dart';
import '../screen/user_screen/waste_screen/cardboard_screen.dart';
import '../screen/user_screen/waste_screen/electronics_screen.dart';
import '../screen/user_screen/waste_screen/glass_screen.dart';
import '../screen/user_screen/waste_screen/metal_screen.dart';
import '../screen/user_screen/waste_screen/paper_screen.dart';
import '../screen/user_screen/waste_screen/plastic_screen.dart';
import '../screen/user_screen/waste_screen/trash_screen.dart';
import '../screen/user_screen/waste_screen/unknown_screen.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  late String _classificationResult;
  ImageLabeler? _imageLabeler;

  final Map<String, String> categoryMapping = {
    'Aluminum Cans': 'Metal',
    'Cardboard Boxes': 'Cardboard',
    'Disposable Plastic Cutlery': 'Plastic',
    'Glass Containers': 'Glass',
    'Organic Waste': 'Trash',
    'Paper': 'Paper',
    'Paper Cups': 'Paper',
    'Plastic Bags': 'Plastic',
    'Plastic Bottles': 'Plastic',
    'Plastic Cups': 'Plastic',
    'Plastic Food Containers': 'Plastic',
    'Plastic Straws': 'Plastic',
    'Styrofoam': 'Trash',
  };

  final Map<String, int> pointsMapping = {
    'Aluminum Cans': 15,
    'Cardboard Boxes': 10,
    'Disposable Plastic Cutlery': 3,
    'Glass Containers': 20,
    'Organic Waste': 0,
    'Paper': 8,
    'Paper Cups': 5,
    'Plastic Bags': 2,
    'Plastic Bottles': 10,
    'Plastic Cups': 5,
    'Plastic Food Containers': 8,
    'Plastic Straws': 1,
    'Styrofoam': 0,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserProvider();
      _pickImageAndProcess(ImageSource.camera);
    });
  }

  void _initializeUserProvider() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user == null || userProvider.lbUser == null) {
      userProvider.fetchUserData();
    }
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(p.dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<void> _pickImageAndProcess(ImageSource source) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        print('No image selected.');
        setState(() {
          _classificationResult = 'No image selected.';
        });
        return;
      }

      // Set up model path and options
      final modelPath = await getModelPath('assets/models/quantized_model_uint8.tflite');
      final options = LocalLabelerOptions(
        confidenceThreshold: 0.5,
        modelPath: modelPath,
      );
      _imageLabeler = ImageLabeler(options: options);

      final inputImage = InputImage.fromFilePath(pickedFile.path);

      await _imageLabeler!.processImage(inputImage).then((labels) async {
        if (labels.isNotEmpty) {
          final topLabel = labels.first;
          final maxScore = topLabel.confidence;
          final label = topLabel.label;
          final confidencePercentage = (maxScore * 100).toStringAsFixed(2);
          print("Object detected is $label");
          print("Max Score is $maxScore");

          if (maxScore <= 0.45) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Unknown(result: 'Unknown')),
            );
          } else {
            setState(() {
              _classificationResult = label.trim();
            });

            if (user != null && _classificationResult.isNotEmpty) {
              final category = categoryMapping[_classificationResult] ?? _classificationResult;
              final points = pointsMapping[_classificationResult] ?? 0;

              if (_classificationResult == 'Electronics') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Electronics(result: _classificationResult, confidencePercentage: confidencePercentage,)),
                );
              } else if (category != 'Trash') {
                await LeaderboardService().addPointsToUser(user.studentNumber, points);
                await TransactionService().createTransaction(user.studentNumber, category, points);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Recycle(result: _classificationResult, confidencePercentage: confidencePercentage, points: points, category: category,)),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Trash(result: _classificationResult, confidencePercentage: confidencePercentage,)),
                );
              }
            }
          }
          await userProvider.fetchUserData();
          await userProvider.fetchTransactions();
          await userProvider.fetchTotalDisposals();
        }
      }).catchError((e) {
        print('Error processing image: $e');
        setState(() {
          _classificationResult = 'Error occurred while processing.';
        });
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _classificationResult = 'Error occurred while processing.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage();
  }

  @override
  void dispose() {
    _imageLabeler?.close();
    super.dispose();
  }
}

class Trash extends StatelessWidget {
  final String result;
  final String confidencePercentage;

  const Trash({super.key, required this.result, required this.confidencePercentage});

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
              Text(
                'Confidence: $confidencePercentage%',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TrashScreen()),
                    );
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

class Electronics extends StatelessWidget {
  final String result;
  final String confidencePercentage;

  const Electronics({super.key, required this.result, required this.confidencePercentage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color(0xFF2E3B55),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.devices_other_outlined,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Electronic Waste Disposal Notice',
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
              Text(
                'Confidence: $confidencePercentage%',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please dispose of electronic waste responsibly.',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ElectronicsScreen()),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UnknownScreen()),
                    );
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
  final String category;
  final String confidencePercentage;
  final int points;

  const Recycle({
    super.key,
    required this.result,
    required this.category,
    required this.confidencePercentage,
    required this.points,
  });

  void navigateToScreen(BuildContext context, String category) {
    final screenMapping = {
      'Cardboard': const CardboardScreen(),
      'Glass': const GlassScreen(),
      'Metal': const MetalScreen(),
      'Paper': const PaperScreen(),
      'Plastic': const PlasticScreen(),
    };

    final screen = screenMapping[category];
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      print("No screen available for category: $category");
    }
  }

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
                'Scanned Waste: $result (Recyclable)',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Confidence: $confidencePercentage%',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'You have received $points points!',
                style: const TextStyle(
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
                    navigateToScreen(context, category);
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

