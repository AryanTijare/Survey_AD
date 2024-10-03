import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../model/ques_model.dart';
import 'home_screen.dart';
import 'survey_end_screen.dart';
import '../widgets/tts_widget.dart';
import '../widgets/stt_widget.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int _currentQuestionIndex = 0;
  List<Questions> _surveyQuestions = GenerateSurveyQuestions();
  bool _isTtsActive = true;
  String _currentAnswer = '';
  Map<int, String> _answers = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // Move to the next question or compare answers and go to end screen
  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _surveyQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isTtsActive = true;
      });
    } else {
      Map<int, bool> comparisonResults =
          compareAnswers(_answers, _surveyQuestions);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => SurveyEndScreen(
              questions: _surveyQuestions,
              result: comparisonResults,
              userAnswers: _answers)));
    }
  }

  // When TTS completes, switch to STT
  void _onTtsComplete() {
    setState(() {
      _isTtsActive = false;
    });
  }

  // When STT completes, store the result and move to the next question
  void _onSttComplete(String recognizedText) {
    setState(() {
      _currentAnswer = recognizedText;
      _answers[_currentQuestionIndex] = recognizedText;
    });
    Future.delayed(const Duration(seconds: 2), () => _moveToNextQuestion());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isTtsActive
                  // Display the current question with TTS Widget
                  ? TTSWidget(
                      text:
                          _surveyQuestions[_currentQuestionIndex].questionText,
                      onTtsComplete:
                          _onTtsComplete, // Move to STT after TSS is complete
                    )
                  // Recognize speech and display it
                  : STTWidget(
                      onSttComplete: () => _onSttComplete(
                          _currentAnswer), // Move to next question after STT
                      onResult: (text) {
                        setState(() {
                          _currentAnswer =
                              text; // Update state with recognized text
                        });
                      },
                    ),
              const SizedBox(height: 40),
              // Display the current question number
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_surveyQuestions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom button to quit the survey
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const HomeScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Quit Survey',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
