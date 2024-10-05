import 'package:fuzzywuzzy/fuzzywuzzy.dart';

enum QuestionType { date, location }

class Question {
  final String questionText;
  final String correctAnswer;
  final QuestionType type;
  int index;

  Question(this.questionText, this.correctAnswer, this.type, this.index);
}

// Compare user's input answers with expected answers
/*Map<int, bool> compareAnswers(
    Map<int, String> userAnswers, List<Question> surveyQuestions) {
  Map<int, bool> results = {};

  for (int index in userAnswers.keys) {
    String userAnswer = userAnswers[index]?.trim().toLowerCase() ?? '';
    String correctAnswer =
        surveyQuestions[index].correctAnswer.trim().toLowerCase();

    results[index] = userAnswer == correctAnswer;
  }
  return results;
}*/

// Compare strings using fuzzy ratio
/*bool fuzzyMatch(String userAnswer, String correctAnswer, {int threshold = 80}) {
  int similarity = ratio(
      userAnswer.trim().toLowerCase(), correctAnswer.trim().toLowerCase());
  return similarity >= threshold;
}*/

// Compare string with substrings of another string using fuzzy ratio
bool fuzzySubstringMatch(String userAnswer, String correctAnswer,
    {int threshold = 80}) {
  int similarity = partialRatio(
      userAnswer.trim().toLowerCase(), correctAnswer.trim().toLowerCase());
  return similarity >= threshold;
}

// Compare user's input answers with list of expected answers using fuzzy matching
/*bool fuzzyMatchInList(String userAnswer, List<String> correctAnswers,
    {int threshold = 80}) {
  for (String value in correctAnswers) {
    if (fuzzyMatch(userAnswer, value, threshold: threshold)) {
      return true;
    }
  }
  return false;
}*/

// Compare user's input answers with expected answers using fuzzy matching
/*Map<int, bool> fuzzyCompareAnswers(
    Map<int, String> userAnswers, List<Question> surveyQuestions) {
  Map<int, bool> results = {};

  for (int index in userAnswers.keys) {
    String userAnswer = userAnswers[index]?.trim().toLowerCase() ?? '';
    String correctAnswer =
        surveyQuestions[index].correctAnswer.trim().toLowerCase();
    results[index] = fuzzySubstringMatch(userAnswer, correctAnswer);
  }

  return results;
}*/

// Get results for respective question type
Map<int, bool> getResults(
    Map<int, String> userAnswers, List<Question> surveyQuestions) {
  Map<int, bool> results = {};

  for (int index in userAnswers.keys) {
    String userAnswer = userAnswers[index]?.trim().toLowerCase() ?? '';
    String correctAnswer =
        surveyQuestions[index].correctAnswer.trim().toLowerCase();
    if (surveyQuestions[index].type == QuestionType.date) {
      results[index] = userAnswer == correctAnswer;
    } else if (surveyQuestions[index].type == QuestionType.location) {
      results[index] = fuzzySubstringMatch(userAnswer, correctAnswer);
    }
  }
  return results;
}
