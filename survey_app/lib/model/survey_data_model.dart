// lib/model/survey_data_model.dart
import 'dart:convert';

class SurveyData {
  final String question;
  final String answer;
  final int score;

  SurveyData({
    required this.question,
    required this.answer,
    required this.score,
  });

  // Convert a SurveyData instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'score': score,
    };
  }

  // Convert a map to a SurveyData instance.
  factory SurveyData.fromMap(Map<String, dynamic> map) {
    return SurveyData(
      question: map['question'],
      answer: map['answer'],
      score: map['score'],
    );
  }

  // Convert the SurveyData instance to a JSON string.
  String toJson() => json.encode(toMap());

  // Create a SurveyData instance from a JSON string.
  factory SurveyData.fromJson(String source) => SurveyData.fromMap(json.decode(source));
}
