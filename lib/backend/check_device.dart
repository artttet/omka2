import 'package:device_info/device_info.dart';
import 'package:omka2/values/sizes.dart';


class IosDeviceName{
  static const String iPhone5 = '5';
  static const String iPhone678 = '6/7/8';
  static const String iPhonePlus = 'Plus';
  static const String iPhoneX = 'X';
}

class CheckDevice{
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static const String ios = 'iOS';
  static const String android = 'Android';
  static String _os;

  static IosDeviceInfo iosInfo;
  static AndroidDeviceInfo  androidInfo;

  static bool isIos(){
    if(_os == ios){
      return true;
    }else {
      return false;
    }
  }

  static loadIosInfo() async {
    try{
      await _deviceInfo.iosInfo.then((info){
        iosInfo = info;
        _os = ios;
        Sizes.setIosSizes();
      });
    }catch(e){}
  }

  static loadAndroidInfo() async {
    try{
      await _deviceInfo.androidInfo.then((info){
        androidInfo = info;
        _os = android;
      });
    }catch(e){}
  }

  static loadDeviceInfo( ) async{
    loadIosInfo();
    loadAndroidInfo();
  }

  static String currentIosDeviceName(){
    var iosName = iosInfo.name;
    print(iosName);
    if(iosName.contains('iPhone 5') || iosName.contains('SE')){
      return IosDeviceName.iPhone5;
    }else if((iosName.contains('iPhone 6') || iosName.contains('iPhone 7') || iosName.contains('iPhone 8')) && !iosName.contains('Plus') ){
      return IosDeviceName.iPhone678;
    }else if(iosName.contains('Plus')){
      return IosDeviceName.iPhonePlus;
    }else if(iosName.contains('X')){
      return IosDeviceName.iPhoneX;
    }
  }

}