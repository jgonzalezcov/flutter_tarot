import 'package:flutter/material.dart';
import 'package:tarot/src/models/tarot_card.model.dart';

class CardProvider with ChangeNotifier {
  int _cardView = -1;
  final List<TarotCard> _cardSelectView = [];

  int get cardView => _cardView;
  List<TarotCard> get cardSelectView => _cardSelectView;
  int get countCard => _cardSelectView.length;

  void setCard(int numberCard) {
    _cardView = numberCard;
    notifyListeners();
  }

  void addCardToSelect(TarotCard card) {
    _cardSelectView.add(card);
    notifyListeners();
  }

  void clearCardSelectView() {
    _cardSelectView.clear();
    notifyListeners();
  }
}
