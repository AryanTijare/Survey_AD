import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:survey_app/screens/survey_complete.dart'; // Make sure to import your SurveyCompletedScreen

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<Offset?> points = [];
  GlobalKey _globalKey = GlobalKey();

  // Clear the drawing points
  void _clearDrawing() {
    setState(() {
      points.clear();
    });
  }

  Future<void> _saveToImage(BuildContext context) async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
      // Request permission
      await Permission.storage.request();
    }

    // Check if permission is granted
    if (!await Permission.manageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
      try {
         // Create a white background canvas
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      
      // Create a new image with a white background
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = Colors.white;

      // Fill the background with white
      canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), paint);

      // Draw the original image on top of the white background
      canvas.drawImage(image, Offset.zero, Paint());

      // End recording and create the new image
      ui.Image newImage = await recorder.endRecording().toImage(image.width, image.height);
      ByteData? byteData = await newImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the directory to save the image
      final directory = (await getExternalStorageDirectory())!.path;
      print(directory);
      File imgFile = File('$directory/drawing.png');
      await imgFile.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Drawing saved as image!')));
      } catch (e) {
        print(e);
      }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Storage permission not granted')));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Drawing Board'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear), // Eraser icon
            onPressed: _clearDrawing,
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              points.add(details.localPosition);
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
            });
          },
          child: CustomPaint(
            painter: MyPainter(points),
            size: Size.infinite,
          ),
        ),
      ),
      bottomNavigationBar: points.isNotEmpty
          ? BottomAppBar(
              child: TextButton(
                onPressed: () {
                  _saveToImage(context); // Save drawing before navigating
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SurveyCompletedScreen(); // Navigate to the completion screen
                    }),
                  );
                },
                child: Text("Next"),
              ),
            )
          : null, // Hide bottom bar if no points drawn
    );
  }
}

class MyPainter extends CustomPainter {
  List<Offset?> points;

  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(ui.PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
