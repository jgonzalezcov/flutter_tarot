import 'package:flutter/material.dart';
import 'package:tarot/src/models/tarot_card.model.dart';
import 'package:tarot/src/provider/card_view.provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tarot/src/provider/api_resp.provider.dart';
import 'package:tarot/src/provider/type_read.provider.dart';

class CardSelectWidget extends StatefulWidget {
  const CardSelectWidget({
    Key? key,
    required this.cardSelect,
  }) : super(key: key);
  final TarotCard cardSelect;

  @override
  State<CardSelectWidget> createState() => _CardSelectWidgetState();
}

class _CardSelectWidgetState extends State<CardSelectWidget> {
  double _opacity = 0.0;
  String nameButon = 'Ir a la carta del presente';
  String carsignification = 'Pasado';
  @override
  void initState() {
    super.initState();
    _startOpacityAnimation();
  }

  void _startOpacityAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  AudioPlayer audioPlayer = AudioPlayer();

  void _playSound() async {
    await audioPlayer.play(AssetSource(
      'sounds/carta.mp3',
    ));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _cardSelect() {
    if (Provider.of<CardProvider>(context, listen: false).cardView == 0) {
      context.read<CardProvider>().setCard(1);
      nameButon = 'Ir a la carta del futuro';
      carsignification = 'Presente';
      _playSound();
    } else if (Provider.of<CardProvider>(context, listen: false).cardView ==
        1) {
      context.read<CardProvider>().setCard(2);
      nameButon = 'Ir a tu predicción';
      carsignification = 'Futuro';
      _playSound();
    } else if (Provider.of<CardProvider>(context, listen: false).cardView ==
        2) {
      context.read<CardProvider>().setCard(-1);
      _performAPIRequest();
      Navigator.of(context).pushNamed('select');
    }
  }

  void _performAPIRequest() async {
    final openAIProvider = Provider.of<OpenAIProvider>(context, listen: false);
    await openAIProvider.sendQuestion(
        context.read<CardProvider>().cardSelectView[0].name,
        context.read<CardProvider>().cardSelectView[1].name,
        context.read<CardProvider>().cardSelectView[2].name,
        context.read<TypeReadProvider>().questionext,
        'Amor');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 3),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 50,
                left: 50,
              ),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/imgs/aura2.gif'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          color: Color.fromARGB(255, 237, 175, 41)),
                      child: Text(
                        carsignification,
                        style: const TextStyle(
                          fontFamily: 'Kaushan',
                          color: Colors.white,
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 270,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          widget.cardSelect.imagePath,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 37, 183, 39)),
                      child: Text(
                        widget.cardSelect.name,
                        style: const TextStyle(
                          fontFamily: 'Kaushan',
                          color: Colors.white,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                          color: Color.fromARGB(255, 37, 183, 39)),
                      child: Text(
                        widget.cardSelect.generalMeaning,
                        style: const TextStyle(
                          fontFamily: 'Kaushan',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 45, left: 45, top: 20),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cardSelect();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 15, 69, 130)),
                  ),
                  child: Text(
                    nameButon,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kaushan',
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
