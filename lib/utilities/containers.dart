import 'package:stoodee/services/crud/flashcards_service/flashcard_set.dart';


class SetContainer{
  final FlashcardSet set;
  final String name;


SetContainer({required this.set,required this.name});



  String getName(){
    return this.name;
  }


  FlashcardSet getSet(){
    return this.set;
  }


}