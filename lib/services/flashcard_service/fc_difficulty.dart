DateTime calculateDateToShowFc({required int cardDifficulty}) {
  //Cards might have higher/lower difficulty than 10/1. If so, set it to max/min
  if (cardDifficulty >= 10) cardDifficulty = 10;
  if (cardDifficulty <= 1) cardDifficulty = 1;

  final dateToDisplay = DateTime.now();

  switch (cardDifficulty) {
    case 10:
      break; //If the card is very difficult, display it instantly.
    case 9:
      dateToDisplay.add(const Duration(seconds: 30));
      break;
    case 8:
      dateToDisplay.add(const Duration(minutes: 1, seconds: 30));
      break;
    case 7:
      dateToDisplay.add(const Duration(minutes: 5));
      break;
    case 6:
      dateToDisplay.add(const Duration(minutes: 15));
      break;
    case 5:
      dateToDisplay.add(const Duration(hours: 1));
      break;
    case 4:
      dateToDisplay.add(const Duration(hours: 3));
      break;
    case 3:
      dateToDisplay.add(const Duration(days: 1));
      break;
    case 2:
      dateToDisplay.add(const Duration(days: 7));
      break;
    case 1:
      dateToDisplay.add(const Duration(days: 30));
      break;

    default:
      throw ArgumentError();
  }

  return dateToDisplay;
}
