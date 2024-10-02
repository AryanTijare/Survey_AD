import 'package:flutter/material.dart';
import 'package:survey_app/screens/survey_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alzheimer\'s Disease Survey'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const SurveyScreen()),
            );
            // _speak('Hello');
          },
          child: const Text('New Survey'),
        ),
        /*child: ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) {
              return const SurveyScreen();
            }));
            // _speak('Hello');
          },
          child: const Text('Check Previous Surveys'),
        ),*/
      ),
    );
  }
}
