import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omka2/addcard_screen.dart';
import 'package:omka2/backend/database.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/main_screen.dart';
import 'package:omka2/needcard_screen.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:omka2/values/styles.dart';
import 'package:omka2/values/svg_assets.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:omka2/backend/check_device.dart';
import 'package:omka2/values/sizes.dart';

class OmkaCard{
  OmkaCard({this.name, this.type, this.number, this.balance, this.history});
  final String name;
  final int type;
  final int number;
  final double balance;
  final String history;
}

class OmkaCardProvider{
  static Map _card;
  static String _name;
  static int _type;
  static int _number;
  static num _balance;

  // static num _loadBalance(Map card){
  //   Future.delayed(Duration(seconds: 3));
  //   return card.values.toList()[4];
  // }

  static OmkaCard _getSafeOmkaCard(Map card){
    return OmkaCard(
      name: card.values.toList()[1],
      type: card.values.toList()[2],
      number: card.values.toList()[3],
      balance: card.values.toList()[4],
      history: card.values.toList()[5]
    ); 
  }

  static Future<OmkaCard> getSafeOmkaCard() async{
    return MyDataBase.loadSafeCard(SharedPrefs.getPrefs().getInt(PrefsKey.cardNumber)).then((card) {
      return _getSafeOmkaCard(card);
    });
  }

  static OmkaCard createOmkaCard(Map card){
    return OmkaCard(
      name: card.values.toList()[1],
      type: card.values.toList()[2],
      number: card.values.toList()[3],
      balance: card.values.toList()[4],
      history: card.values.toList()[5]
    );
  }
}

void main() {
  MySvg.initSvg().then((_) =>
    CheckDevice.loadDeviceInfo().then((_) =>
      SharedPrefs.loadPrefs().then((_) =>
        _firstRun()).then((_) =>
          runApp(Application()))));
}
  
_firstRun() async{
  var prefs = SharedPrefs.getPrefs();
  
  MyDataBase.loadDBPath();
  if(prefs.getInt(PrefsKey.firstRun) == null){
    prefs.setInt(PrefsKey.firstRun, 1);
    prefs.setInt(PrefsKey.dbVersion, 1);
    prefs.setInt(PrefsKey.currentListCardIndex, -1);
    prefs.setBool(PrefsKey.isAdvice, true);
    prefs.setBool(PrefsKey.needUpdate, false);

    MyDataBase.createDB();
    
  }
  
}

class Application extends StatelessWidget {
  
  bool _isCards(){
    if(SharedPrefs.getPrefs().getInt(PrefsKey.currentListCardIndex) != -1){
      return true;
    }else return false;
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CheckDevice.isIos() ? Themes.iosThemeData : Themes.androidThemeData,
      routes: {
        "/mainScreen" : (_) => MainScreen(),
        "/needCardScreen" : (_) => NeedCardScreen()
      },
      home: SplashScreen(
        seconds: 3,
        image: Image.asset('assets/images/logo.jpg'),
        photoSize: Sizes.splashLogoSize,
        navigateAfterSeconds: _isCards() ? MainScreen() : NeedCardScreen()
      ),
    );
  }
}

