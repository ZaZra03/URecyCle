import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State createState() =>
      _ScanState();
}

class _ScanState
    extends State<Scan> {
  String? classificationResult;
  Duration? classificationInferenceTime;
  File? _image;
  ClassificationModel? _imageModel;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    String pathImageModel = "assets/models/model(1).pt";
    try {
      _imageModel = await PytorchLite.loadClassificationModel(
        pathImageModel, 224, 224, // Adjust as needed
        labelPath: "assets/labels/model.txt",
      );
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future runModels() async {
    setState(() => _isLoading = true);

    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      setState(() => _isLoading = false);
      return;
    }

    File image = File(pickedImage.path);
    Uint8List imageBytes = await image.readAsBytes(); // Read bytes once

    // Run both models concurrently
    final results = await Future.wait([
          () async {
        Stopwatch stopwatch = Stopwatch()..start();
        try {
          return await _imageModel?.getImagePrediction(imageBytes);
        } catch (e) {
          print("Error during classification: $e");
          return null; // or handle the error as needed
        } finally {
          classificationInferenceTime = stopwatch.elapsed;
        }
      }(),
    ]);

    classificationResult = results[0] as String?;

    setState(() {
      _image = image;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run Models')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading indicator
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) ...[
              const SizedBox(height: 20),
              Text(
                "Classification Result: ${classificationResult ?? "N/A"}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Classification Time: ${classificationInferenceTime?.inMilliseconds ?? "N/A"} ms",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: runModels,
              child: const Text('Take Photo & Run Models'),
            ),
          ],
        ),
      ),
    );
  }
}