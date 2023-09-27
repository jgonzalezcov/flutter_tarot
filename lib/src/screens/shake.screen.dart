import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tarot/src/provider/card_view.provider.dart';
import 'package:tarot/src/provider/sensor_state.provider.dart';

class ShakeScreen extends StatefulWidget {
  const ShakeScreen({Key? key}) : super(key: key);

  @override
  State<ShakeScreen> createState() => _ShakeScreenState();
}

class _ShakeScreenState extends State<ShakeScreen> {
  late AudioPlayer _audioPlayer;
  late SensorStateProvider sensorProvider;

  final double shakeThreshold = 15.0; // Sensibilidad de detección de movimiento
  Timer? _shakeTimer;
  bool shake = false;
  final AudioPlayer _soundPlayer = AudioPlayer();
  late StreamSubscription<AccelerometerEvent> accelerometerSubscription;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _loadAndPlayAudio();

    sensorProvider = Provider.of<SensorStateProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ModalRoute.of(context)!.isCurrent) {
      accelerometerSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) {
        if (sensorProvider.sensorView &&
            (event.x.abs() > shakeThreshold ||
                event.y.abs() > shakeThreshold ||
                event.z.abs() > shakeThreshold)) {
          if (!shake && (_shakeTimer == null || !_shakeTimer!.isActive)) {
            setState(() {
              shake = true;
            });
            _shakeTimer = Timer(const Duration(seconds: 13), () {
              if (mounted) {
                setState(() {
                  shake = false;
                  _stopSound();

                  final cardProvider = context.read<CardProvider>();
                  cardProvider.clearCardSelectView();
                  cardProvider.setCard(-1);
                  Navigator.of(context).pushNamed('table');
                  sensorProvider.sensoFalse();
                });
              }
            });
            _playSound();
          }
        }
      });
    }
  }

  void _loadAndPlayAudio() async {
    await _audioPlayer.play(AssetSource('sounds/agita.mp3'));
  }

  void _playSound() async {
    await _soundPlayer.play(AssetSource(('sounds/revolver3.mp3')));
  }

  void _stopSound() {
    _soundPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/hand_shake.gif'),
            fit: BoxFit.cover,
          ),
        ),
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
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
              Expanded(
                child: Stack(
                  children: [
                    shake
                        ? Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black, // Color de fondo negro
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/imgs/revolviendo.gif'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 8, 94, 11),
        onPressed: () {
          sensorProvider.sensoTrue();
          context.read<CardProvider>().clearCardSelectView();
          context.read<CardProvider>().setCard(-1);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: const Icon(
          Icons.home,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _soundPlayer.dispose();
    accelerometerSubscription.cancel();
    super.dispose();
  }
}
