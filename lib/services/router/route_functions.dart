

import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';


void goRouterToLogin(BuildContext context,[Object? extra]){   //object extra not required
  log("Going to: Login");
  context.go("/login",extra: extra);
}


void goRouterToMain(BuildContext context,[Object? extra]){
  log("Going to: Main");
  context.go("/Main",extra: extra);
}


void goRouterToIntro(BuildContext context,[Object? extra]){
  log("Going to: Intro");
  context.go("/intro",extra: extra);
}


void goRouterToEmailVerification(BuildContext context,[Object? extra]) {
  log("Going to: Email Verification");
  context.go('/email_verification_page',extra:extra);
}


void goRouterToToDo(BuildContext context,[Object? extra]) {
  log("Going to: ToDo");
  context.go('/ToDo', extra: extra);
}


void goRouterToFlashCards(BuildContext context,[Object? extra]){
  log("Going to: FlashCards");
  context.go('/Flashcards', extra:extra);
}



void goRouterToAchievements(BuildContext context,[Object? extra]){
  log("Going to: Achievements");
  context.go('/Achievements', extra:extra);
}




void goRouterToAccount(BuildContext context,[Object? extra]){
  log("Going to: Account");
  context.go('/Account', extra:extra);
}




