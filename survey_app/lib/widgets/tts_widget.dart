import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onTtsComplete;

  const TTSWidget({Key? key, required this.text, this.onTtsComplete})
      : super(key: key);

  @override
  _TTSWidgetState createState() => _TTSWidgetState();
}

class _TTSWidgetState extends State<TTSWidget> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speak();
  }

  // Start speaking
  Future<void> _speak() async {
    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(widget.text);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false; // set state to false when speaking is done
      });
      if (widget.onTtsComplete != null) {
        widget
            .onTtsComplete!(); // call the onTtsComplete callback when TTS is finished
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop(); // Stop TTS when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          _isSpeaking
              ? const CircularProgressIndicator() // show progress while speaking
              : Icon(
                  Icons.mic_rounded,
                  size: 50,
                  color: Colors.blue,
                ),
        ],
      ),
    );
  }
}
