import 'package:intl/intl.dart';

class Questions {
  final String questionText;
  final String correctAnswer;

  Questions(this.questionText, this.correctAnswer);
}

// Dynamically generate survey questions
List<Questions> GenerateSurveyQuestions() {
  DateTime now = DateTime.now();

  String year = DateFormat('yyyy').format(now);
  String month = DateFormat('MMMM').format(now);
  String day = DateFormat('EEEE').format(now);
  String date = DateFormat('d').format(now);

  List<Questions> surveyQuestions = [
    Questions('What year is it?', year),
    Questions('What month is it?', month),
    Questions('What day is it?', day),
    Questions('What date is it?', date),
  ];

  return surveyQuestions;
}

// Compare user's input answers with expected answers
Map<int, bool> compareAnswers(
    Map<int, String> userAnswers, List<Questions> surveyQuestions) {
  Map<int, bool> results = {};

  for (int index in userAnswers.keys) {
    String userAnswer = userAnswers[index]?.trim().toLowerCase() ?? '';
    String correctAnswer =
        surveyQuestions[index].correctAnswer.trim().toLowerCase();

    results[index] = userAnswer == correctAnswer;
  }
  return results;
}
