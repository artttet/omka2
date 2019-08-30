import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omka2/values/sizes.dart';

class MySvg{
  static SvgPicture logoOmkaOrange, logoOmkaRed, logoOmkaBlue, logoOmkaGreen,logoOmkaAdd;
  static initSvg() async{
    logoOmkaOrange = SvgPicture.asset('assets/svg/logo_omka_orange.svg');
    logoOmkaRed = SvgPicture.asset('assets/svg/logo_omka_red.svg');
    logoOmkaBlue = SvgPicture.asset('assets/svg/logo_omka_blue.svg');
    logoOmkaGreen = SvgPicture.asset('assets/svg/logo_omka_green.svg');
    logoOmkaAdd = SvgPicture.asset('assets/svg/logo_omka_add.svg');
  }
}