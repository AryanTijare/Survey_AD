import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
//import 'package:permission_handler/permission_handler.dfart';

class MyAudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<MyAudioRecorder> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _recorderIsInitialized = false;
  var _filePath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    // Open the recorder
    await _recorder.openRecorder();
    setState(() {
      _recorderIsInitialized = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_recorderIsInitialized) {
      throw Exception("Recorder is not initialized");
    }

    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      _filePath = '${appDocDir.path}/audio_example.aac';
      //String path = 'audio_example.aac'; // Path to save the recorded file
      await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);
      setState(() {
        _isRecording = true;
        _filePath = _filePath;
      });
    } catch (e) {
      print("Error while starting the recorder: $e");
    }
  }

  // Stop recording
  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording saved at $_filePath')),
      );
    } catch (e) {
      print("Error while stopping the recorder: $e");
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          children: [
            TextButton.icon(
              onPressed: () async {
                _startRecording();
              },
              label: Text('Start'),
              icon: Icon(Icons.start),
            ),
            TextButton.icon(
              onPressed: () {
                _stopRecording();
              },
              label: Text('Stop'),
              icon: Icon(Icons.stop),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isRecording
                        ? 'Recording...'
                        : 'Press the button to record',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   //AudioRecorder _recorder = AudioRecorder();
//   bool _isRecording = false;
//   var _path;
//   @override
//   void initState() {
//     _recorder = FlutterSoundRecorder();
//     innitRecorder();
//     super.initState();
//   }

//   Future<void> innitRecorder() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permission not granted');
//     }
//     await _recorder.startRecorder();
//   }

//   Future<void> _startRecording() async {
//     Directory tempDir = await getTemporaryDirectory();
//     _path = '${tempDir.path}/audio_example.aac';
//     await _recorder.startRecorder(
//       toFile: _path,
//       codec: Codec.aacADTS, // AAC is a commonly supported audio format
//     );
//     setState(() {
//       _isRecording = true;
//     });
//   }

//   Future<void> _stopRecordingAndUpload() async {
//     await _recorder.stopRecorder();
//     setState(() {
//       _isRecording = false;
//     });

//     // Now upload the file to Firebase Storage
//     File audioFile = File(_path);
//     if (audioFile.existsSync()) {}
//   }

//   void dispose() {
//     _recorder.closeRecorder();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
   