import 'package:flutter/material.dart';
//import 'package:survey_app/screens/new_survey.dart';
import 'package:survey_app/screens/survey_screen.dart';
//import 'package:pbl_project/screens.dart/survey_screen.dart';

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
        title: Text('Survey'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) {
              return SurveyScreen();
            }));
            // _speak('Hello');
          },
          child: Text('Start Survey'),
        ),
      ),
    );
  }
}
