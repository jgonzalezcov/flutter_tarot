class TarotCard {
  final int arcanNumber;
  final String name;
  final String imagePath;
  final String imagePathBack;
  final String generalMeaning;
  final String loveMeaning;
  final String moneyMeaning;
  final String healthMeaning;
  bool isFaceUp;

  TarotCard(
    this.arcanNumber,
    this.name,
    this.imagePath,
    this.imagePathBack,
    this.generalMeaning,
    this.loveMeaning,
    this.moneyMeaning,
    this.healthMeaning,
    this.isFaceUp,
  );
}
