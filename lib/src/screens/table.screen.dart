import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:tarot/src/data/card.data.dart';
import 'package:tarot/src/models/tarot_card.model.dart';
import 'package:tarot/src/provider/sensor_state.provider.dart';
import 'package:tarot/src/widgets/card_select.widget.dart';
import 'package:tarot/src/widgets/card_tarot.widget.dart';
import 'package:tarot/src/widgets/circle_avatar.widget.dart';
import 'package:tarot/src/provider/card_view.provider.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class TableScreen extends StatefulWidget {
  const TableScreen({Key? key}) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with SingleTickerProviderStateMixin {
  List<TarotCard> cardSelect = [];
  StreamSubscription? accelerometerSubscription;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late AudioPlayer _audioPlayer;

  bool shake = false;

  @override
  void initState() {
    // Iniciar la suscripción al acelerómetro
    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // Aquí puedes manejar los eventos del acelerómetro si es necesario en esta pantalla
    });

    super.initState();
    final random = Random();
    tarotDeck.shuffle(random);
    _audioPlayer = AudioPlayer();
    _loadAndPlayAudio();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          context.read<CardProvider>().setCard(0);
        });
      }
    });
  }

  void _startAnimation() {
    _controller.forward();
  }

  void _loadAndPlayAudio() async {
    await _audioPlayer.play(AssetSource('sounds/seleccion2.mp3'));
  }

  int shakeCounter = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/fondo4.jpg'),
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
                    const MyCircleAvatar(
                      size: 120,
                      img: 'assets/imgs/medita.gif',
                      borderImage: 'assets/imgs/circle.gif',
                      borderWidth: 40,
                    ),
                    GridView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.79,
                        mainAxisSpacing: 0.01,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: tarotDeck.length,
                      itemBuilder: (context, index) {
                        final tarotCard = tarotDeck[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Center(
                            child: CardTarotWidget(
                              dataCard: tarotCard,
                              cardSelect: cardSelect,
                              updateCardSelect: (card) {
                                setState(() {
                                  if (!cardSelect.contains(card)) {
                                    context
                                        .read<CardProvider>()
                                        .addCardToSelect(card);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    Builder(builder: (context) {
                      if (context.watch<CardProvider>().countCard == 3) {
                        _startAnimation();
                        return AnimatedBuilder(
                          animation: _opacityAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _opacityAnimation.value,
                              child: Image.asset(
                                'assets/imgs/giro.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    Builder(builder: (context) {
                      if (context.watch<CardProvider>().cardView != -1) {
                        return CardSelectWidget(
                            cardSelect:
                                context.watch<CardProvider>().cardSelectView[
                                    context.watch<CardProvider>().cardView]);
                      }
                      {
                        return const SizedBox.shrink();
                      }
                    }),
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
          context.read<CardProvider>().clearCardSelectView();
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

  @override
  void dispose() {
    _controller.dispose(); // Libera el AnimationController
    _audioPlayer.dispose();
    accelerometerSubscription?.cancel(); // Cancelar la suscripción aquí
    super.dispose();
  }
}
