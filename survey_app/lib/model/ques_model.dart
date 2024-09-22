import 'dart:io';

//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Questions {
  Questions({required this.id, required this.questionText});
  final String id;
  //final ansMode answerMode;
  final String questionText;
}

class AnswerModel {
  final String uid;
  final File ansFile;

  AnswerModel({required this.ansFile, required this.uid});
}

enum ansMode { audio, drawing }
