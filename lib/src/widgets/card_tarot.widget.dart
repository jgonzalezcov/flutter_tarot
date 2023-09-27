import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:tarot/src/models/tarot_card.model.dart';

class CardTarotWidget extends StatefulWidget {
  const CardTarotWidget({
    Key? key,
    required this.dataCard,
    required this.cardSelect,
    required this.updateCardSelect,
  }) : super(key: key);
  final TarotCard dataCard;
  final List<TarotCard> cardSelect;
  final Function(TarotCard) updateCardSelect;
  @override
  State<CardTarotWidget> createState() => _CardTarotWidgetState();
}

class _CardTarotWidgetState extends State<CardTarotWidget> {
  bool isBack = true;
  double angle = 0;
  bool isFlipped = false;
  AudioPlayer audioPlayer = AudioPlayer();

  void _playSound() async {
    await audioPlayer.play(AssetSource(
      'sounds/carta.mp3',
    ));
  }

  void _flip() async {
    if (!isFlipped) {
      setState(() {
        angle = (angle + pi) % (2 * pi);
        isFlipped = true;
        _playSound();

        widget.updateCardSelect(widget.dataCard);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _flip,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: angle),
              duration: const Duration(milliseconds: 700),
              builder: (BuildContext context, double val, __) {
                if (val >= (pi / 2)) {
                  isBack = false;
                } else {
                  isBack = true;
                }
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val),
                  child: SizedBox(
                    width: 70,
                    height: 90, // ajustar desborde
                    child: isBack
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: AssetImage(
                                  widget.dataCard.imagePathBack,
                                ),
                              ),
                            ),
                          )
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: AssetImage(widget.dataCard.imagePath),
                                ),
                              ),
                              child: const Center(),
                            ),
                          ),
                  ),
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}
