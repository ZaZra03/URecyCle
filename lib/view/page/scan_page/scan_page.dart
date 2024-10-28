import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String? classificationResult;
  Duration? classificationInferenceTime;
  File? _image;
  ClassificationModel? _imageModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    const pathImageModel = "assets/models/best_skipped_model.pt";
    try {
      _imageModel = await PytorchLite.loadClassificationModel(
        pathImageModel, 224, 224, 6,
        labelPath: "assets/labels/model.txt",
      );
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> runModels(ImageSource source) async {
    setState(() => _isLoading = true);

    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) {
      setState(() => _isLoading = false);
      return;
    }

    final File image = File(pickedImage.path);
    final Uint8List imageBytes = await image.readAsBytes();

    try {
      final stopwatch = Stopwatch()..start();
      List<double?>? predictionList = await _imageModel!.getImagePredictionList(
        imageBytes,
        preProcessingMethod: PreProcessingMethod.imageLib,
      );
      classificationInferenceTime = stopwatch.elapsed;

      // Assuming you want the highest prediction as the result
      int maxIndex = predictionList.indexWhere((e) => e == predictionList.reduce((a, b) => a! > b! ? a : b));
      classificationResult = maxIndex >= 0 ? "Class $maxIndex" : "N/A";

      setState(() {
        _image = image;
        classificationResult = classificationResult;
      });
    } catch (e) {
      print("Error during classification: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run Models')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null) ...[
                const SizedBox(height: 20),
                Image.file(_image!),
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
                onPressed: () => runModels(ImageSource.camera),
                child: const Text('Take Photo & Run Models'),
              ),
              ElevatedButton(
                onPressed: () => runModels(ImageSource.gallery),
                child: const Text('Pick from Gallery & Run Models'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
