import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import 'package:urecycle_app/services/transaction_service.dart';
import 'package:urecycle_app/view/widget/loading_widget.dart';
import '../../constants.dart';
import '../../provider/user_provider.dart';
import '../screen/user_screen/result_screen/electronics_screen.dart';
import '../screen/user_screen/result_screen/recycle_screen.dart';
import '../screen/user_screen/result_screen/trash_screen.dart';
import '../screen/user_screen/result_screen/unknown_screen.dart';

class Scan extends StatefulWidget {
  final String scannedCategory;

  const Scan({super.key, required this.scannedCategory});

  @override
  State createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  late String _classificationResult;
  ImageLabeler? _imageLabeler;
  final Map<String, String> categoryMapping = Constants.categoryMapping;
  final Map<String, int> pointsMapping = Constants.pointsMapping;

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
        _showNotification('No image selected.', isError: true);
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
          print('The max score is: $maxScore');

          if (maxScore <= 0.75) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Unknown(result: 'Unknown')),
            );
            _showNotification('Scan result: Unknown object.', isError: false);
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
                  MaterialPageRoute(
                    builder: (context) => Electronics(
                      result: _classificationResult,
                      confidencePercentage: confidencePercentage,
                    ),
                  ),
                );
                _showNotification('Scanned successfully! Electronics detected.', isError: false);
              } else if (category == widget.scannedCategory) {
                // If category matches the QR code, award points
                await LeaderboardService().addPointsToUser(user.studentNumber, points);
                await TransactionService().createTransaction(user.studentNumber, category, points);

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('lastScannedNonTrash', true);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recycle(
                      result: _classificationResult,
                      confidencePercentage: confidencePercentage,
                      points: points,
                      category: category,
                    ),
                  ),
                );
                _showNotification(
                  'Scanned successfully! +$points points for $category.',
                  isError: false,
                );
              } else if (category == 'Trash') {
                // If the item is categorized as Trash, navigate to the Trash screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Trash(
                      result: _classificationResult,
                      confidencePercentage: confidencePercentage,
                    ),
                  ),
                );
                _showNotification(
                  'Scanned successfully, but item is categorized as Trash.',
                  isError: false,
                );
              } else {
                // If category does not match the QR code's scanned category, show a notification
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recycle(
                      result: _classificationResult,
                      confidencePercentage: confidencePercentage,
                      points: 0,
                      category: category,
                    ),
                  ),
                );
                _showNotification(
                  'Item does not match the scanned category (${widget.scannedCategory}). No points awarded.',
                  isError: true,
                );
              }
            }
          }
          await userProvider.fetchUserData();
          await userProvider.fetchTransactions();
          await userProvider.fetchTotalDisposals();
        } else {
          _showNotification('No labels detected. Please try again.',
              isError: true);
        }
      }).catchError((e) {
        print('Error processing image: $e');
        setState(() {
          _classificationResult = 'Error occurred while processing.';
        });
        _showNotification('Error processing image. Please try again.',
            isError: true);
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _classificationResult = 'Error occurred while processing.';
      });
      _showNotification('Unexpected error occurred. Please try again.',
          isError: true);
    }
  }

  void _showNotification(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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




