import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omka2/addcard_screen.dart';
import 'package:omka2/backend/check_device.dart';
import 'package:omka2/backend/database.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/main.dart';
import 'package:omka2/values/anim/animations.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:omka2/values/sizes.dart';
import 'package:omka2/values/svg_assets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rounded_modal/rounded_modal.dart';

class ListCardsWidget extends StatefulWidget{
  ListCardsWidget({this.updateMainCard, this.deactivateList});
  final Function updateMainCard;

  final Function deactivateList;

  @override
  State<StatefulWidget> createState() {
    return ListCardsWidgetState(updateMainCard: updateMainCard, deactivateList: deactivateList);
  }
}

class ListCardsWidgetState extends State<ListCardsWidget> with SingleTickerProviderStateMixin{
  ListCardsWidgetState({this.updateMainCard, this.deactivateList});

  final Function updateMainCard;

  final Function deactivateList;

  @override
  void initState(){
    super.initState();
    AnimController.initListCardsController(this);
    MyDataBase.updateList();
  }



  showDeleteDialog(Map card, int index){
    List CardValues(int index){
      return MyDataBase.getListCards().reversed.toList()[index].values.toList();
    }
  
    showDialog(
      context: context,
      builder: (BuildContext context){
        var prefs = SharedPrefs.getPrefs();
        var currentIndexKey = PrefsKey.currentListCardIndex;
        var currentIndex = prefs.getInt(currentIndexKey);
        up(){
          updateMainCard();
          Navigator.pop(context);
        }
        delete(){
           if(index > 1 && index != currentIndex){
                    prefs.setInt(currentIndexKey, currentIndex);
                    prefs.setString(PrefsKey.cardName, CardValues(currentIndex)[1]);
                    prefs.setInt(PrefsKey.cardType, CardValues(currentIndex)[2]);
                    prefs.setInt(PrefsKey.cardNumber, CardValues(currentIndex)[3]);
                  } else{
                    prefs.setInt(currentIndexKey, 0);
                    prefs.setString(PrefsKey.cardName, CardValues(0)[1]);
                    prefs.setInt(PrefsKey.cardType, CardValues(0)[2]);
                    prefs.setInt(PrefsKey.cardNumber, CardValues(0)[3]);
                  }

                  if(index == 0){
                    if(MyDataBase.getListCards().length > 2){
                      prefs.setInt(currentIndexKey, 0);
                      prefs.setString(PrefsKey.cardName, CardValues(1)[1]);
                      prefs.setInt(PrefsKey.cardType, CardValues(1)[2]);  
                      prefs.setInt(PrefsKey.cardNumber, CardValues(1)[3]);  
                    }else prefs.setInt(currentIndexKey, -1);
                  }

                  if(MyDataBase.getListCards().length == 2){
                    prefs.setBool(PrefsKey.needUpdate, true);
                    MyDataBase.deleteCard(card);
                    Navigator.pushNamedAndRemoveUntil(context, '/needCardScreen', (_) => false);
                  }else{
                    prefs.setBool(PrefsKey.needUpdate, true);
                    print('needWork!!!');
                    
                    
                    MyDataBase.deleteCard(card).then((_)=>up());
          }
        }
        
        return CheckDevice.isIos()
          ? CupertinoAlertDialog(
            title: Text('Вы действительно хотите удалить карту?', style: TextStyle(color: MyColors.red),),
            
            actions: <Widget>[
              CupertinoButton(
                child: Text('Отменить', style: TextStyle(color: MyColors.red)),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              CupertinoButton(
                child: Text('Удалить', style: TextStyle(color: MyColors.red, fontWeight: FontWeight.bold),),
                onPressed: (){
                  delete();
                },
              )
            ],
          ) 
          : AlertDialog(
            title: Text('Вы хотите удалить карту?', style: TextStyle(color: Colors.black),),
            actions: <Widget>[
              RaisedButton(
                child: Text('Отменить', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('Удалить', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  
                  delete();
                 
                  
                },
              )
            ],
          );

      }
    );
  }


  updateList(){
    setState(() {
      
    });
  }
  

  @override
  Widget build(BuildContext context) {
    print('LISTCARDSBUILD');
    List<Map> listCards = List();
    var needUpdate = SharedPrefs.getPrefs().getBool(PrefsKey.needUpdate);
    
    if(needUpdate){
      MyDataBase.updateList();
      
      SharedPrefs.getPrefs().setBool(PrefsKey.needUpdate, false);
    }

    if(MyDataBase.getListCards() != null){
      listCards = MyDataBase.getListCards().reversed.toList();
    }
    
    double cardsCount = listCards.length.toDouble();

    var animation = Animations.getListCardsAnimation(cardsCount, this);
    animation.addListener((){
      setState(() {});
    });

    return Stack(
      children: <Widget>[
        Positioned(
          height: cardsCount * 48,
          width: Sizes.parentWidth(context),
          top:animation.value,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listCards.length,
            itemBuilder: (BuildContext context, int index) => 
              CardFromList(listCards[index], index, updateMainCard, deactivateList, this.showDeleteDialog),
          ),
        )
      ],
    );
  }
}

class CardFromList extends StatelessWidget{
  CardFromList(this.card, this.index, this.updateMainCard, this.deactivateList, this.showDeleteDialog);
  final Map card;

  final int index;

  final Function updateMainCard; 

  final Function deactivateList;

  final Function showDeleteDialog;  

  @override
  Widget build(BuildContext context) {
    
    bool isVisibleIcon = true;
    bool isVisibleCheckIcon;

    OmkaCard omkaCard = OmkaCardProvider.createOmkaCard(card);
  
    int currentCardIndex = SharedPrefs.getPrefs().getInt(PrefsKey.currentListCardIndex);

    if(currentCardIndex == index){
      isVisibleCheckIcon = true;
    }else isVisibleCheckIcon = false;

    double cardNamePadding = 12.0;

    String cardName = omkaCard.name;

    if(cardName.contains('Добавить')){
      isVisibleIcon = false;
      cardNamePadding = 7.0;
    }

    var itemColor = Color.fromARGB(240, MyColors.red.red, MyColors.red.green, MyColors.red.blue);
    return InkWell(
      onTap: (){
        if(index != 5 && !cardName.contains('Добавить')){
          SharedPrefs.getPrefs().setInt(PrefsKey.currentListCardIndex, index);
          SharedPrefs.getPrefs().setString(PrefsKey.cardName, cardName);
          SharedPrefs.getPrefs().setInt(PrefsKey.cardNumber, omkaCard.number);
          
          updateMainCard();
        }

        if(index !=5 && cardName.contains('Добавить')){
          deactivateList();

          Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddCardScreen(updateMainCard)));
        }
      },
      onLongPress: (){
        if(!cardName.contains('Добавить')) showDeleteDialog(card, index);
      },
      child: Container(
        height: 48,
        width: Sizes.parentWidth(context),
        decoration: BoxDecoration(
          color: itemColor,
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 0.15
            )
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Visibility(
                visible: isVisibleIcon,
                child: Icon(
                  Icons.credit_card,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: cardNamePadding),
                child: Text(
                  cardName,
                  style: TextStyle(
                    color: index == 5 ? Color.fromARGB(200, 255, 255, 255) : Colors.white,
                    fontSize: 16.0,
                    fontFamily: CheckDevice.isIos() ? 'SFProText-Regular' : 'ProductSans-Regular'
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Visibility(
                visible: isVisibleCheckIcon,
                child: Icon(
                  Icons.check_circle, color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MainCard extends StatelessWidget{
  MainCard({this.type, this.number});
  final int type;
  final int number;

  @override
  Widget build(BuildContext context) {
    var color, logo, owner;
    
    switch (type){
      case 1: {
        color = MyColors.cGreen;
        logo = MySvg.logoOmkaGreen;
        owner = 'Гражданина';
      }
      break;
      case 2: {
        color = MyColors.cBlue;
        logo = MySvg.logoOmkaBlue;
        owner = 'Пенсионера'; 
      }
      break;
      case 3: {
        color = MyColors.cOrange;
        logo = MySvg.logoOmkaOrange;
        owner = 'Школьника';
      }
      break;
      case 4: {
        color = MyColors.cRed;
        logo = MySvg.logoOmkaRed;
        owner = 'Студента';
      }
      break;
    }
    
    return Container(
      margin: EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 32.0),
      height: Sizes.parentWidth(context) * 0.8 * 0.625,
      width: Sizes.parentWidth(context) * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.0, color: Color(0xBDBDBDBD)),
        borderRadius: BorderRadius.all(Radius.circular(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
            spreadRadius: 1.0
          )
        ]
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: Sizes.parentWidth(context) * 0.8 * 0.625 * 0.18,
              width: Sizes.parentWidth(context) * 0.8 * 0.5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomRight: Radius.circular(14)
                )
              ),
              child: Center(
                child: Text(
                  owner,
                  style: Theme.of(context).textTheme.title
                )
              )
            )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              padding: EdgeInsets.only(top: 16.0, left: 12.0),
              width: Sizes.parentWidth(context) * 0.8 * 0.8,
              height: Sizes.parentWidth(context) * 0.8*0.625,
              child: logo
            )
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Container(
              width: Sizes.parentWidth(context) * 0.8 * 0.365,
              height: Sizes.parentWidth(context) * 0.8 * 0.625 * 0.18,
              child: Center(
                child: Text(
                  '000 ${number.toString().substring(0,3)} ${number.toString().substring(3,6)}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: CheckDevice.isIos() ? 'SFProText-Regular' : 'ProductSans-Regular'
                  ),
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}

class MainBottomSheet extends StatelessWidget{
  MainBottomSheet({this.color});

  final Color color;

  _launchUrl(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }
  }

  var _context;

  _showCircleBottomSheet() {
    showRoundedModalBottomSheet(
      context: _context,
      radius: Sizes.bottomSheetRadius,
      color: Colors.white,
      builder: (BuildContext builder) {
        return Column(
          children: <Widget>[
            Container(
              height: Sizes.bottomSheetHeightOpen,
              width: Sizes.parentWidth(_context),
              decoration: BoxDecoration(
                color: MyColors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Sizes.bottomSheetRadius),
                  topLeft: Radius.circular(Sizes.bottomSheetRadius)
                )
              ),
              child: Center(
                child: Text(
                  'Пополнить карту',
                  style: Theme.of(_context).textTheme.subtitle,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _launchUrl('https://node3.online.sberbank.ru/PhizIC/private/payments/servicesPayments/edit.do?categoryId=&serviceId=500010020&recipient=500514171&fromResource=');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 6),
                            blurRadius: 20
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/sberbank.jpg', width: 75, height: 75,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Сбербанк'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return AnimatedContainer(
        height: Sizes.bottomSheetHeight,
        width: Sizes.parentWidth(context),
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          color: MyColors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, -5.0),
              blurRadius: 5.0,
              spreadRadius: -3.5
            )
          ],
          borderRadius: BorderRadius.only(
          topRight: Radius.circular(Sizes.bottomSheetRadius),
          topLeft: Radius.circular(Sizes.bottomSheetRadius)
          )
        ),
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        onPressed: _showCircleBottomSheet,
      ),
    );
  }


}


