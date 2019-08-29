import 'package:flutter/material.dart';


class AnimController {
  static AnimationController bigCardController, bigCardGController, headlineIconController, listCardsController;


  static initBigCardController(TickerProvider provider){
    bigCardController = AnimationController(
      vsync: provider,
      duration: Duration(milliseconds: 700)
    );
  }
  static AnimationController getBigCardController(){
    return bigCardController;
  }
  static void bigCardControllerF(){
    bigCardController.forward();
  }
  static void bigCardControllerR(){
    bigCardController.reverse();
  }

  static initBigCardGController(TickerProvider provider){
    bigCardGController = AnimationController(
      vsync: provider,
      duration: Duration(milliseconds: 500)
    );
  }
  static AnimationController getBigCardGController(){
    return bigCardGController;
  }
  static void bigCardGControllerF(){
    bigCardGController.forward();
  }
  static void bigCardGControllerR(){
    bigCardGController.reverse();
  }

  static initHeadlineIconController(TickerProvider provider){
    headlineIconController = AnimationController(
      lowerBound: 0.0,
      upperBound: 0.5,
      vsync: provider,
      duration: Duration(milliseconds: 150)
    );
  }
  static AnimationController getHeadlineIconController(){
    return headlineIconController;
  }
  static void headlineIconControllerF(){
    headlineIconController.forward();
  }
  static void headlineIconControllerR(){
    headlineIconController.reverse();
  }

  static initListCardsController(TickerProvider provider){
    listCardsController = AnimationController(
      vsync: provider,
      duration: Duration(milliseconds: 250)
    );
  }
  static AnimationController getListCardsController(){
    return listCardsController;
  }
  static void listCardsControllerF(){
    listCardsController.forward();
  }
  static void listCardsControllerR(){
    listCardsController.reverse();
  }
}

class Animations{
  static Animation bigCardAnimation, bigCardGAnimation, listCardsAnimation;

  static Animation getBigCardAnimation(double widthScreen, TickerProvider provider){
    var tween = Tween<double>(begin: -widthScreen-100, end: 0);
    bigCardAnimation = tween.animate(AnimController.getBigCardController());
    return bigCardAnimation;
  }

  static Animation getBigCardGAnimation(double widthScreen, TickerProvider provider){
    var tween = Tween<double>(begin: 0, end: widthScreen * 0.7 + 100);
    bigCardGAnimation = tween.animate(AnimController.getBigCardGController());
    return bigCardGAnimation;
  }

  static Animation getListCardsAnimation(double cardsCount, TickerProvider provider){
    var tween = Tween<double>(begin: cardsCount * -48, end: -1);
    listCardsAnimation = tween.animate(AnimController.getListCardsController());
    return listCardsAnimation;
  }
}