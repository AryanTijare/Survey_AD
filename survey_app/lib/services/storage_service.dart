// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../model/survey_data_model.dart';

class StorageService {
  // Save survey data
  Future<void> saveSurveyData(SurveyData surveyData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingData = prefs.getStringList('survey_data') ?? [];
    
    existingData.add(surveyData.toJson());
    
    
    await prefs.setStringList('survey_data', existingData);
    print("Stored");  
  }

  // Load survey data
  Future<List<SurveyData>> loadSurveyData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingData = prefs.getStringList('survey_data') ?? [];

    return existingData.map((jsonString) => SurveyData.fromJson(jsonString)).toList();
  }
}
