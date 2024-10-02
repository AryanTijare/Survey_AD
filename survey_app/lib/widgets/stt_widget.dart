import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class STTWidget extends StatefulWidget {
  final VoidCallback? onSttComplete;
  final Function(String) onResult;

  const STTWidget({Key? key, this.onSttComplete, required this.onResult}) : super(key: key);

  @override
  _STTWidgetState createState() => _STTWidgetState();
}

class _STTWidgetState extends State<STTWidget> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = '';
  bool _isListening = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  // Initialize the Speech-to-Text engine
  Future<void> _initializeSpeech() async {
    _speechAvailable = await _speech.initialize();
    if (_speechAvailable) {
      _startListening();  // Start listening immediately after initialization
    } else {
      setState(() {
        _recognizedText = "Speech recognition not available.";
      });
    }
  }

  // Start listening and handle the speech results
  Future<void> _startListening() async {
    //print("Starting to listen...");
    if (_speechAvailable) {
      setState(() {
        _isListening = true;
        _recognizedText = '';  // Clear the text when starting to listen
      });

      _speech.listen(
        onResult: (result) {
          print('Partial result: ${result.recognizedWords}');  
          setState(() {
            _recognizedText = result.recognizedWords;  // Update the recognized text
            print("Recognized: $_recognizedText");
          });
          widget.onResult(_recognizedText);  // Send the result back to the parent widget
        },
        listenFor: const Duration(seconds: 10),  // Listen for 10 seconds
        /*onSoundLevelChange: (level) {
          print('Sound level: $level');  // Print the sound level
        },*/
        cancelOnError: true,
        partialResults: true,  // Show partial results as they are recognized
        localeId: "en_US",
      );

      // Stop listening after 10 seconds
      await Future.delayed(const Duration(seconds: 10));
      _stopListening();
    }
  }

  // Stop listening and call the completion callback
  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });

    // Trigger the completion callback
    if (widget.onSttComplete != null) {
      widget.onSttComplete!();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isListening)
            const CircularProgressIndicator(),  // Show a loading indicator while listening
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _isListening ? 'Listening...' : 'You said: $_recognizedText',  // Display recognized text
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isListening ? _stopListening : null,  // Stop button when listening
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            ),
            child: const Text(
              'Stop Recording',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
