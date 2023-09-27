import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarot/src/provider/card_view.provider.dart';
import 'package:tarot/src/provider/sensor_state.provider.dart';
import 'package:tarot/src/widgets/card_prediction.widget.dart';
import 'package:tarot/src/provider/api_resp.provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SelectCard extends StatefulWidget {
  const SelectCard({Key? key}) : super(key: key);

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  AudioPlayer audioPlayer = AudioPlayer();
  FlutterTts flutterTts = FlutterTts();
  bool isReading = false;
  void _playSound() async {
    await audioPlayer.setVolume(0.2);
    await audioPlayer.play(AssetSource(
      'sounds/fayry.mp3',
    ));
  }

  @override
  void initState() {
    super.initState();
    _configureTts();
    _playSound();
    _initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _speakText(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _configureTts() async {
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setVoice({"name": "es-US-language", "locale": "es-US"});
    await flutterTts.setPitch(0.4);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
  }

  void _initTts() {
    final responseText = context.read<OpenAIProvider>().responseText;
    if (responseText.isNotEmpty) {
      _speakText(responseText);
    }
  }

  List<dynamic> voices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imgs/giro.gif'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  width: double.infinity,
                  padding: const EdgeInsets.all(0.0),
                  child: const Center(
                    child: Text(
                      'EL Oráculo',
                      style: TextStyle(
                        fontFamily: 'Kaushan',
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    context.watch<CardProvider>().cardSelectView.length == 3
                        ? CardPredictionWidget(
                            cardSelect:
                                context.watch<CardProvider>().cardSelectView[0],
                            position: 0,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 10,
                    ),
                    context.watch<CardProvider>().cardSelectView.length == 3
                        ? CardPredictionWidget(
                            cardSelect:
                                context.watch<CardProvider>().cardSelectView[1],
                            position: 1)
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 10,
                    ),
                    context.watch<CardProvider>().cardSelectView.length == 3
                        ? CardPredictionWidget(
                            cardSelect:
                                context.watch<CardProvider>().cardSelectView[2],
                            position: 2,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color:
                        context.watch<OpenAIProvider>().responseText.isNotEmpty
                            ? Colors.red
                            : null,
                    image: context.watch<OpenAIProvider>().responseText.isEmpty
                        ? const DecorationImage(
                            image: AssetImage('assets/imgs/mistico5.gif'),
                            fit: BoxFit.cover,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(top: 0),
                  child: Text(
                    context.watch<OpenAIProvider>().responseText.trim(),
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ),
                if (context.watch<OpenAIProvider>().responseText.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: FractionallySizedBox(
                        widthFactor:
                            0.5, // Esto establece el ancho al 50% del padre
                        child: ElevatedButton(
                          onPressed: () {
                            _speakText(
                                context.read<OpenAIProvider>().responseText);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Color del botón
                          ),
                          child: const Text(
                            'Leer en voz alta',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 8, 94, 11),
        onPressed: () {
          context.read<CardProvider>().clearCardSelectView();
          context.read<OpenAIProvider>().cleanResponseText();
          context.read<CardProvider>().setCard(-1);
          Navigator.of(context).popUntil((route) => route.isFirst);
          final sensorProvider = context.read<SensorStateProvider>();
          sensorProvider.sensoTrue();
        },
        child: const Icon(
          Icons.home,
          color: Colors.white,
        ),
      ),
    );
  }
}
