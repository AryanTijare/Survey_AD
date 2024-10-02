class Questions {
  final String questionText;
  final String correctAnswer;

  Questions(this.questionText, this.correctAnswer);
}

List<Questions> surveyQuestions = [
  Questions('What year is it?', '2024'),
  Questions('What month is it?', 'October'),
  Questions('What day is it?', 'Wednesday'),
  Questions('What date is it?', '2'),
];
