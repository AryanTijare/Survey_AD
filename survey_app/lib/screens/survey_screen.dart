import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';  // Import audioplayers package
import 'package:survey_app/data/ques_data.dart';
import 'package:survey_app/model/ques_model.dart';
import 'package:survey_app/widgets/drawing_board.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();  // Create an AudioPlayer instance

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

  // Function to play audio for "Repeat After Me"
 // Function to play audio for "Repeat After Me"
Future<void> _playRepeatAfterMeAudio() async {
  String audioPath = 'audio/Repeat_sentence.mp3'; // Path for the audio prompt
  await _audioPlayer.play(AssetSource(audioPath)); // Use isLocal: true for local assets
}

Future<void> _playSequenceOfObjectAudio() async {
  String audioPath = 'audio/Sequence_of_object.mp3'; // Path for the audio prompt
  await _audioPlayer.play(AssetSource(audioPath)); // Use isLocal: true for local assets
}

  // Show the question for a few seconds, then start recording
  void showNextQuestion() {
    if (currentIndex < SQuestions.length) {
      setState(() {
        showQuestion = true;
        questionTimer = SQuestions[currentIndex].id == 'easy' ? 5 : 10;
      });

      // Check if it's the specific audio question
      if (SQuestions[currentIndex].questionText == "Repeat After Me") {
        _playRepeatAfterMeAudio().then((_) {
          Timer(Duration(seconds: questionTimer), () {
            setState(() {
              showQuestion = false;
              startRecording();  // Start recording after the audio prompt
            });
          });
        });
      }
      if (SQuestions[currentIndex].questionText == "Remember the sequence of objects.") {
        _playSequenceOfObjectAudio().then((_) {
          Timer(Duration(seconds: questionTimer), () {
            setState(() {
              showQuestion = false;
              stopRecording();  // Start recording after the audio prompt
            });
          });
        });
      }
       else {
        // For regular questions, display them normally
        Timer(Duration(seconds: questionTimer), () {
          setState(() {
            showQuestion = false;
            startRecording();
          });
        });
      }
    } else {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (ctx) => DrawingQues()));
      print("Survey Completed");
    }
  }

  // Start recording the user's answer
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

  // Stop recording and move to the next question
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
