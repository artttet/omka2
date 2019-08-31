import 'package:flutter/material.dart';
import 'package:omka2/addcard_screen.dart';
import 'package:omka2/values/anim/animations.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';




class BigCardAnim extends StatefulWidget{
  @override
  State<StatefulWidget> createState() { 
    return _BigCardAnimState();
  }  
}

class _BigCardAnimState extends State<BigCardAnim> with TickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    AnimController.initBigCardController(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => AnimController.bigCardControllerF());
  }

  @override
  Widget build(BuildContext context) {
    var _animation = Animations.getBigCardAnimation(Sizes.parentWidth(context), this);
    _animation.addListener(() {
      setState(() {});
    });
    return Positioned(
      top: Sizes.parentHeight(context) * 0.38,
      left: _animation.value,
      child: Container(
        width: Sizes.parentWidth(context),
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/iconAdd.svg',
            color: MyColors.red
          )
        )
      )
    );
  }  
}

class BigCardAnimG extends StatefulWidget{
  BigCardAnimG(this.widthScreen);
  
  final double widthScreen;

  @override
  State<StatefulWidget> createState() { 
    return _BigCardAnimStateG(widthScreen);
  }  
}

class _BigCardAnimStateG extends State<BigCardAnimG> with TickerProviderStateMixin{
  _BigCardAnimStateG(this.widthScreen);

  final double widthScreen;

  
  
  var _animation;
  @override
  void initState(){
    super.initState();
    AnimController.initBigCardGController(this);
    _animation = Animations.getBigCardGAnimation(widthScreen, this);
    _animation.addListener(() {
      setState(() {});
    });
    _animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        Navigator.pushReplacementNamed(context,  '/addCardScreen');
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) => AnimController.bigCardGControllerF());
  }

  @override
  Widget build(BuildContext context) {
    

    return Positioned(
      top: Sizes.parentHeight(context) * 0.38,
      left: _animation.value,
      child: Container(
        width: Sizes.parentWidth(context),
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/iconAdd.svg',
            color: MyColors.red
          )
        )
      )
    );
  }  
}

