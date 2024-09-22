import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:survey_app/data/ques_data.dart';
import 'package:survey_app/model/ques_model.dart';
import 'package:survey_app/widgets/drawing_board.dart';
//import 'package:permission_handler/permission_handler.dfart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentIndex = 0;
  bool showQuestion = true;
  bool isRecording = false;
  int questionTimer = 5;
  int answerTimer = 10;

  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String audioFilePath = "";

  @override
  void initState() {
    super.initState();

    _recorder = FlutterSoundRecorder();
    openRecorder();
    showNextQuestion();
  }

  // Request permission and initialize the recorder
  Future<void> openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    await _recorder.openRecorder();
  }

  // Show the question for 5 seconds, then start recording
  void showNextQuestion() {
    if (currentIndex < SQuestions.length) {
      setState(() {
        showQuestion = true;
        questionTimer = SQuestions[currentIndex].id == 'easy' ? 5 : 10;
      });

      // Show the question for 5 seconds
      Timer(Duration(seconds: 5), () {
        setState(() {
          showQuestion = false;

          startRecording();
        });
      });
    } else if (currentIndex >= SQuestions.length) {
      //isRecording = false;
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          answerTimer--;
        });
        if (answerTimer == 0) {
          stopRecording();
          timer.cancel();
        }
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => DrawingQues()));
      print("Survey Completed");
    }
  }

  void startRecording() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    audioFilePath = '${appDir.path}/audio_${currentIndex}.aac';

    setState(() {
      isRecording = true;
      answerTimer = SQuestions[currentIndex].id == 'easy' ? 10 : 20;
    });

    await _recorder.startRecorder(toFile: audioFilePath);

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        answerTimer--;
      });
      if (answerTimer == 0) {
        stopRecording();
        timer.cancel();
      }
    });
  }

  void stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      isRecording = false;
    });

    print("Audio recorded for question ${currentIndex}: $audioFilePath");

    // Move to the next question

    currentIndex++;
    showNextQuestion();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //var timeDuration = 8;
    if (currentIndex > SQuestions.length) {}
    Widget content = Scaffold(
        appBar: AppBar(
          title: Text("Test Questions"),
        ),
        body: Column(
          children: [
            Center(
              child: !isRecording
                  ? Text(currentIndex < SQuestions.length
                      ? "${SQuestions[currentIndex].questionText}     ${questionTimer.toString()}"
                      : 'None')
                  : Text("Recording....${answerTimer.toString()}"),
            ),
          ],
        ));
    return content;
  }
}

class DrawingQues extends StatefulWidget {
  const DrawingQues({super.key});

  @override
  State<DrawingQues> createState() => _DrawingQuesState();
}

class _DrawingQuesState extends State<DrawingQues> {
  @override
  void initState() {
    // TODO: implement initState
    showQuestion();
    super.initState();
  }

  var time = 5;

  Widget content = Scaffold(
      body: Center(
          child: Column(children: [
    Center(
      child: Column(
        children: [
          Text('Look at the image given and draw the same.'),
          Image.asset('assets/figure.jpeg'),
        ],
      ),
    )
  ])));

  Future<void> showQuestion() async {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        time--;
      });
      if (time == 0) {
        timer.cancel();
        content = DrawingBoard();
      }
    });
  }

  Widget build(BuildContext context) {
    return content;
  }
}
