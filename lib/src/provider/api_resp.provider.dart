import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIProvider with ChangeNotifier {
  String responseText = '';

  Future<void> sendQuestion(String card1, String card2, String card3,
      String question, String typequestion) async {
    OpenAI.apiKey = dotenv.env['API_KEY'] ?? '';

    final completion = await OpenAI.instance.completion.create(
      model: "text-davinci-003",
      prompt:
          "necesito una respuesta como que tu fueras un tarotista que le estas respondindo ya que tengo una app de tarot,donde al principio comomiences diciendo A tu pregunta ¿$question? con las cartas seleccionadas ....(aca sigues tu).  Donde tengo tres cartas del tarot en el pasado la $card1, en el presente el $card2 y en el futuro $card3.  Que respuesta darias si te preguntan ¿$question?",
      maxTokens: 250,
      temperature: 0.5,
    );

    responseText = completion.choices[0].text;

    notifyListeners();
  }

  void cleanResponseText() {
    responseText = '';
    notifyListeners();
  }
}
