DateTime calculateDateToShowFc({required int cardDifficulty}) {
  //Cards might have higher/lower difficulty than 10/1. If so, set it to max/min
  if (cardDifficulty >= 10) cardDifficulty = 10;
  if (cardDifficulty <= 1) cardDifficulty = 1;

  final dateToDisplay = DateTime.now();
  switch (cardDifficulty) {
    case 10:
      return dateToDisplay;
    case 9:
      return dateToDisplay.add(const Duration(seconds: 30));
    case 8:
      return dateToDisplay.add(const Duration(minutes: 1, seconds: 30));
    case 7:
      return dateToDisplay.add(const Duration(minutes: 5));
    case 6:
      return dateToDisplay.add(const Duration(minutes: 15));
    case 5:
      return dateToDisplay.add(const Duration(hours: 1));
    case 4:
      return dateToDisplay.add(const Duration(hours: 3));
    case 3:
      return dateToDisplay.add(const Duration(days: 1));
    case 2:
      return dateToDisplay.add(const Duration(days: 7));
    case 1:
      return dateToDisplay.add(const Duration(days: 30));

    default:
      throw ArgumentError();
  }
}
