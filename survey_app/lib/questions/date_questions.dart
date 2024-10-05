import 'package:intl/intl.dart';
import 'questions.dart';

// Dynamically generate date survey questions
List<Question> generateDateQuestions() {
  DateTime now = DateTime.now();

  String year = DateFormat('yyyy').format(now);
  String month = DateFormat('MMMM').format(now);
  String day = DateFormat('EEEE').format(now);
  String date = DateFormat('d').format(now);

  List<Question> dateQuestions = [
    Question('What year is it?', year, QuestionType.date, 0),
    Question('What month is it?', month, QuestionType.date, 1),
    Question('What day is it?', day, QuestionType.date, 2),
    Question('What date is it?', date, QuestionType.date, 3),
  ];

  return dateQuestions;
}
