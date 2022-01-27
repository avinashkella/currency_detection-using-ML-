import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

int total = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({
    Key? key,
    required this.camera,
  });

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller!.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('What\'s Money'))),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller!);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Container(
              height: 160.0,
              width: 160.0,
              child: FittedBox(
                child: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  // Provide an onPressed callback.
                  shape:
                      BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Attempt to take a picture and log where it's been saved.
                      XFile picture = await _controller!.takePicture();
                      // If the picture was taken, display it on a new screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DisplayPictureScreen(picture.path),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen(this.imagePath);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List? op;
  Image? img;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    img = Image.file(File(widget.imagePath));
    classifyImage(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
//    Image img = Image.file(File(widget.imagePath));
//    classifyImage(widget.imagePath, total);

    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Center(child: img)),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${op![0]['label']}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> runTextToSpeech(String outputMoney, int totalMoney) async {
    FlutterTts flutterTts;
    flutterTts = FlutterTts();

    if (outputMoney.contains("10")) {
      String speakString = "ten rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney.contains("20")) {
      String speakString = "Twenty rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney.contains("50")) {
      String speakString = "Fifty rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney.contains("100")) {
      String speakString = "One Hundred rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney.contains("500")) {
      String speakString = "Five Hundred rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney.contains("1000")) {
      String speakString = "One thousand rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
    if (outputMoney.contains("5000")) {
      String speakString = "Five thousand rupees";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    } else {
      String speakString = "No Currency found";
      await flutterTts.setSpeechRate(0.8);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakString);
    }
  }

  classifyImage(String image) async {
    var output = await Tflite.runModelOnImage(
      path: image,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output);
    op = output!;

    if (op != null) {
      if (op![0]["label"].contains("10")) {
        total += 10;
        runTextToSpeech("10 rupees", total);
      }
      if (op![0]["label"].contains("20")) {
        total += 20;
        runTextToSpeech("20 rupees", total);
      }
      if (op![0]["label"].contains("50")) {
        total += 50;
        runTextToSpeech("50 rupees", total);
      }
      if (op![0]["label"].contains("100")) {
        total += 100;
        runTextToSpeech("100 rupees", total);
      }
      if (op![0]["label"].contains("500")) {
        total += 500;
        runTextToSpeech("500 rupees", total);
      }
      if (op![0]["label"].contains("1000")) {
        total += 1000;
        runTextToSpeech("1000 rupees", total);
      }
      if (op![0]["label"].contains("5000")) {
        total += 5000;
        runTextToSpeech("5000 rupees", total);
      }
    } else
      runTextToSpeech("No note found", total);
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt");
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
