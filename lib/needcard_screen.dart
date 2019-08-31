
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omka2/backend/check_device.dart';
import 'package:omka2/values/anim/bigcard_icon_anim.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NeedCardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NeedCardScreenState();
  }
}

class _NeedCardScreenState extends State<NeedCardScreen>{
  bool _isNext = false;

  void _goNext(){
    _isNext = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark
    ));
    return Scaffold(
      
      backgroundColor: MyColors.red,
      body: Center(
        child: Container(
          height: Sizes.parentHeight(context)* 0.85,
          width: Sizes.parentWidth(context) * 0.85,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 64),
                  child: Text(
                    'Необходимо добавить карту',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.red,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: SvgPicture.asset(
                    'assets/svg/iconAdd.svg',
                    color: MyColors.red,
                    width: (256.0+128.0),
                    height: (160.0+80),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: CupertinoButton(
                    color: MyColors.red,
                    onPressed: (){
                      Navigator.pushReplacementNamed(context,  '/addCardScreen');
                    },
                    child: Text(
                      'Добавить',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),



      // body: Stack(
      //   children: <Widget>[
      //     Positioned(
      //       top: Sizes.parentHeight(context) * 0.25,
      //       child: Container(
      //         width: Sizes.parentWidth(context),
      //         child: Center(
      //           child: Text(
      //             'Необходимо добавить карту',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //               fontSize: 24.0,
      //               color: MyColors.red,
      //               fontWeight: FontWeight.bold
      //             ),
      //           ),
      //         ),
      //       )
      //     ),
      //     // Иконка карты
      //     !_isNext ? BigCardAnim() : BigCardAnimG(Sizes.parentWidth(context)),
      //     // Кнопка в AddCardScreen
      //     CheckDevice.isIos()
      //     ?
      //     Positioned(
      //       //left: Sizes.parentWidth(context) * 0.5,
      //       bottom: CheckDevice.currentIosDeviceName() == IosDeviceName.iPhoneX
      //       ?
      //       46
      //       :
      //       24,
      //       child: Container(
      //         width: Sizes.parentWidth(context),
      //         child: Center(
      //           child: CupertinoButton(
      //             pressedOpacity: 0.8,
      //             color: MyColors.red,
      //             child: Text(
      //               'Добавить',
      //               style: Theme.of(context).textTheme.button,
      //             ),
      //             onPressed: () {
      //               _goNext();
      //             }
      //           )   
      //         ),
      //       )
      //     )
      //     :
      //     Positioned(
      //       right: Sizes.parentWidth(context) * 0.08,
      //       bottom: Sizes.parentWidth(context) * 0.08,
      //       child: RaisedButton(
      //         color: MyColors.red,
      //         onPressed: (){
      //           _goNext();
      //         },
      //         child: Text(
      //           'Добавить',
      //           style: TextStyle(
      //             fontSize: 14.0,
      //             color: Colors.white
      //           )
      //         )
      //       )
      //     )
      //   ]
      // ) 
    );
  }
}