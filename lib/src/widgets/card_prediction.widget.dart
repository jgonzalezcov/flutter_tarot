import 'package:flutter/material.dart';
import 'package:tarot/src/models/tarot_card.model.dart';

class CardPredictionWidget extends StatefulWidget {
  const CardPredictionWidget({
    Key? key,
    required this.cardSelect,
    required this.position,
  }) : super(key: key);
  final TarotCard cardSelect;
  final int position;
  @override
  State<CardPredictionWidget> createState() => _CardPredictionWidgetState();
}

class _CardPredictionWidgetState extends State<CardPredictionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12.0),
          ),
          height: 240,
          width: 105,
          child: Column(
            children: [
              const SizedBox(
                height: 2,
              ),
              Text(
                widget.position == 0
                    ? 'Pasado'
                    : widget.position == 1
                        ? 'Presente'
                        : 'Futuro',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                height: 190,
                width: 100,
                child: Image.asset(
                  widget.cardSelect.imagePath,
                  height: double.infinity,
                ),
              ),
              Text(
                widget.cardSelect.name,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
