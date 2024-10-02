import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package
import 'package:survey_app/data/ques_data.dart';
import 'package:survey_app/model/ques_model.dart';
import 'package:survey_app/screens/home_screen.dart';
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
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Create an AudioPlayer instance

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
  Future<void> _playRepeatAfterMeAudio() async {
    String audioPath = 'audio/Repeat_sentence.mp3'; // Path for the audio prompt
    await _audioPlayer
        .play(AssetSource(audioPath)); // Use isLocal: true for local assets
  }

  Future<void> _playSequenceOfObjectAudio() async {
    String audioPath =
        'audio/Sequence_of_object.mp3'; // Path for the audio prompt
    await _audioPlayer
        .play(AssetSource(audioPath)); // Use isLocal: true for local assets
  }

  // Show the question for a few seconds, then start recording
  void showNextQuestion() {
    if (currentIndex < SQuestions.length) {
      setState(() {
        showQuestion = true;
        questionTimer = SQuestions[currentIndex].id == 'easy' ? 5 : 10;
      });

      // Check if it's the specific audio question
      if (SQuestions[currentIndex].questionText == "Listen to the commands") {
        _playRepeatAfterMeAudio().then((_) {
          Timer.periodic(Duration(seconds: 1), (Timer timer) {
            if (questionTimer == 0) {
              timer.cancel();
              setState(() {
                showQuestion = false;
                startRecording(); // Start recording after the audio prompt
              });
            }
            setState(() {
              if (questionTimer > 0) {
                questionTimer = questionTimer - 1;
              }
            });
          });
          // Timer(Duration(seconds: questionTimer + 2), () {
          //   setState(() {
          //     showQuestion = false;
          //     startRecording();  // Start recording after the audio prompt
          //   });
          // });
        });
      } else if (SQuestions[currentIndex].questionText ==
          "Redraw the figure shown below") {
        Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (questionTimer == 0) {
            timer.cancel();
            setState(() {
              showQuestion = false;
            });
            // Navigate to the drawing board after 5 seconds
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DrawingBoard()),
            );
          }
          setState(() {
            if (questionTimer > 0) {
              questionTimer = questionTimer - 1;
            }
          });
        });
        // Timer(Duration(seconds: questionTimer), () {
        //   setState(() {
        //     showQuestion = false;
        //     // Navigate to the drawing board after 5 seconds
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => DrawingBoard()),
        //     );
        //   });
        // });
      } else {
        // For regular questions, display them normally
        Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (questionTimer == 0) {
            timer.cancel();
            setState(() {
              showQuestion = false;
              startRecording();
            });
          }
          setState(() {
            if (questionTimer > 0) {
              questionTimer = questionTimer - 1;
            }
          });
        });
        // Timer(Duration(seconds: questionTimer), () {
        //   setState(() {
        //     showQuestion = false;
        //     startRecording();
        //   });
        // });
      }
    } else {
      print("Survey Completed");
    }
  }

  // Start recording the user's answer
  void startRecording() async {
    String appDir = (await getExternalStorageDirectory())!.path;
    audioFilePath = '$appDir/Question_${currentIndex}.aac';

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
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(builder: (context) {
                        return Text(
                          currentIndex < SQuestions.length
                              ? "${SQuestions[currentIndex].questionText}     ${questionTimer.toString()}"
                              : 'None',
                        );
                      }),
                      // Display the figure if the question is about redrawing
                      if (SQuestions[currentIndex].questionText ==
                          "Redraw the figure shown below")
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/figure.jpeg', // Update with your image path
                            height: 200, // Set your desired height
                          ),
                        ),
                    ],
                  )
                : Text("Recording....${answerTimer.toString()}"),
          ),
          ElevatedButton(
            child: Text("Quit Survey"),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
                return const HomeScreen();
                }));
            },
          )
        ],
      ),
    );
    return content;
  }
}
