import 'package:flutter/material.dart';
import 'package:survey_app/widgets/drawing_board.dart'; // Update this to your actual path

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  bool showFigure = true;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DrawingBoard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redraw the Figure'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showFigure)
            Column(
              children: [
                Text("Redraw the figure shown below:"),
                SizedBox(height: 20),
                // Replace this with your actual image asset
                Image.asset('assets/your_figure.jpeg', height: 300), // Update the image path
              ],
            ),
        ],
      ),
    );
  }
}
