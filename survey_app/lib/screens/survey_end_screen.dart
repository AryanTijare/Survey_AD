import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../questions/questions.dart';

class SurveyEndScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, bool>
      result; // Holds whether each question was answered correctly
  final Map<int, String> userAnswers;

  const SurveyEndScreen({
    Key? key,
    required this.questions,
    required this.result,
    required this.userAnswers,
  }) : super(key: key);

  // Calculate the score
  int calculateScore() {
    return result.values.where((isCorrect) => isCorrect).length;
  }

  @override
  Widget build(BuildContext context) {
    int totalQuestions = result.length;
    int score = calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Results'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the final score
            Text(
              'Final Score: $score / $totalQuestions',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Display individual question results
            Expanded(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  bool isCorrect = result[index]!;
                  return ListTile(
                    title:
                        Text('Q${index + 1}: ${questions[index].questionText}'),
                    subtitle: Text(
                      'Your answer: ${userAnswers[index]}',
                      style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.red),
                    ),
                    trailing: Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        // Wrap the bottom button in SafeArea
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to home screen
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
      ),
    );
  }
}
