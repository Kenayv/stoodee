class Flashcard {
  String _frontText;
  String _backText;

  Flashcard({required String frontText, required String backText})
      : _backText = backText,
        _frontText = frontText;

  void editCard({required String frontText, required String backText}) {
    _frontText = frontText;
    _backText = backText;
  }

  String get frontText => _frontText;
  String get backText => _backText;
}
