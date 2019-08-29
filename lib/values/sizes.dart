import 'package:flutter/widgets.dart';
import 'package:omka2/backend/check_device.dart';

class Sizes{
  // MainScreenElements
  static double appBarHeight = 56.0;
  static double bottomSheetHeight = 48.0;
  static double bottomSheetHeightOpen = 32.0;
  static double bottomSheetRadius = 12.0;
  static double splashLogoSize = 100;
  // Fonts
  // static double headlineFontSize = 20.0;
  // static double titleFontSize = 16.0;
  // static double subtitleFontSize = 14.0;
  // static double buttonFontSize = 14.0;
  // static double body1DontSize = 16.0;

  static double parentHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double parentWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  
  static setIosSizes(){
    print(CheckDevice.currentIosDeviceName());
    switch (CheckDevice.currentIosDeviceName()) {
      case IosDeviceName.iPhone5 : {
        appBarHeight = 46.0;
        bottomSheetHeight = 42.0;
        bottomSheetHeightOpen = 38.0;
        bottomSheetRadius = 12.0;
        splashLogoSize = 100.0;
        // headlineFontSize = 20.0;
        // titleFontSize = 16.0;
        // subtitleFontSize = 14.0;
        // buttonFontSize = 14.0;
        // body1DontSize = 16.0;        
        break;
      }
      case IosDeviceName.iPhone678 : {
        appBarHeight = 46.0;
        bottomSheetHeight = 42.0;
        bottomSheetHeightOpen = 38.0;
        bottomSheetRadius = 12.0;
        splashLogoSize = 106.0;
        // headlineFontSize = 20.0;
        // titleFontSize = 16.0;
        // subtitleFontSize = 14.0;
        // buttonFontSize = 14.0;
        // body1DontSize = 16.0;  
        break;
      }
      case IosDeviceName.iPhonePlus : {
        appBarHeight = 56.0;
        bottomSheetHeight = 56.0;
        bottomSheetHeightOpen = 42.0;
        bottomSheetRadius = 18.0;
        splashLogoSize = 128.0;
        // headlineFontSize = 20.0;
        // titleFontSize = 16.0;
        // subtitleFontSize = 14.0;
        // buttonFontSize = 14.0;
        // body1DontSize = 16.0;
        break;
      }
      case IosDeviceName.iPhoneX : {
        appBarHeight = 48.0;
        bottomSheetHeight = 82.0;
        bottomSheetHeightOpen = 42.0;
        bottomSheetRadius = 24.0;
        splashLogoSize = 112.0;
        // headlineFontSize = 20.0;
        // titleFontSize = 16.0;
        // subtitleFontSize = 14.0;
        // buttonFontSize = 14.0;
        // body1DontSize = 16.0;
        break;
      }
    }
  }
  
}

