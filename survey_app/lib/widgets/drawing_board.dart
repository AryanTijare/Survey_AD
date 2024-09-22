import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<Offset?> points = [];
  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Drawing Board'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveToImage,
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
    );
  }

  Future<void> _saveToImage() async {
    var status = await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      try {
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Get the directory to save the image
        final directory = (await getExternalStorageDirectory())!.path;
        File imgFile = File('$directory/drawing.png');
        await imgFile.writeAsBytes(pngBytes);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Drawing saved as image!')));
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission not granted')));
    }
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
