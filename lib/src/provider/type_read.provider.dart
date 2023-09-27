import 'package:flutter/material.dart';

class TypeReadProvider with ChangeNotifier {
  String _type = 'Amor';
  String _question = '';

  String get typeView => _type;
  String get questionext => _question;
  void setType(String buton) {
    _type = buton;
    notifyListeners();
  }

  void setQuestion(String textQuestion) {
    _question = textQuestion;
    notifyListeners();
  }
}
