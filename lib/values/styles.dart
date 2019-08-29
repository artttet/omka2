import 'package:flutter/material.dart';
import 'package:omka2/values/colors.dart';

class Themes{
  static ThemeData androidThemeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: MyColors.red,
    primaryIconTheme: IconThemeData(
      color: MyColors.red
    ),
    fontFamily: 'ProductSans-Regular',
    primarySwatch: Colors.red,
    textTheme: TextTheme(
      headline: TextStyle(
        fontFamily: 'ProductSans-Medium',
        fontSize: 20.0,
        color: MyColors.red,
        letterSpacing: 0.15,
      ),
      title: TextStyle(
        fontFamily: 'ProductSans-Medium',
        fontSize: 18.0,
        color: Colors.white,
        letterSpacing: 0.15
      ),
      subtitle: TextStyle(
        fontFamily: 'ProductSans-Regular',
        fontSize: 14.0,
        color: Colors.white,
        letterSpacing: 0.1
      ),
      body1: TextStyle(
        fontFamily: 'ProductSans-Regular',
        fontSize: 16.0,
        color: Colors.black,
        letterSpacing: 0.2
      ),
      body2: TextStyle(
        fontFamily: 'ProductSans-Regular',
        fontSize: 16.0,
        color: Colors.green,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold
      ),
      button: TextStyle(
        fontFamily: 'ProductSans-Medium',
        fontSize: 14.0,
        color: Colors.white,
        letterSpacing: 1.25
      )
    )
  );

  static ThemeData iosThemeData = ThemeData(
    primaryColor: Colors.red,
    primarySwatch: Colors.red,
    fontFamily: 'SFProText-Regular',
    textTheme: TextTheme(
      headline: TextStyle(
        fontFamily: 'SFProText-Semibold',
        fontSize: 17.0,
        color: MyColors.red
      ),
      // Также DefaultAction
      title: TextStyle(
        fontFamily: 'SFProText-Medium',
        fontSize: 17.0,
        color: Colors.white
      ),
      subtitle: TextStyle(
        fontFamily: 'SFProText-Regular',
        fontSize: 13.0,
        color: Colors.white
      ),
      // Также Action
      body1: TextStyle(
        fontFamily: 'SFProText-Regular',
        fontSize: 17.0,
        color: Colors.black
      ),
      body2: TextStyle(
        fontFamily: 'SFProText-Regular',
        fontSize: 17.0,
        color: Colors.green,
        fontWeight: FontWeight.bold
      ),
      button: TextStyle(
        fontFamily: 'SFProText-Semibold',
        fontSize: 17.0,
        color: Colors.white
      )
    )
  );
}