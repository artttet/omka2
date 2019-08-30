import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omka2/backend/check_device.dart';
import 'package:omka2/backend/database.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/frontend/mainscreen_widgets.dart';
import 'package:omka2/main.dart';
import 'package:omka2/values/anim/animations.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:omka2/values/sizes.dart';

class MainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  } 
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  OmkaCard _card;

  bool isGreyBackground, isBuildetCard, isListActivated;

  loadData() async{
    MyDataBase.updateCards(SharedPrefs.getPrefs().getInt(PrefsKey.cardNumber)).then((_) =>{
      OmkaCardProvider.getSafeOmkaCard().then(
        (card){
          setState(() {
          _card = card; 
          });
      })
    });
  }

  @override
  void initState(){
    super.initState();
    AnimController.initHeadlineIconController(this);
    AnimController.initListCardsController(this); 
    isGreyBackground = false;
    isBuildetCard = false;
    isListActivated = false;
    loadData();
  }
  
  activateListCards(){
    isListActivated = true;
    setState(() {
      isGreyBackground = true;  
    }); 
    AnimController.listCardsControllerF();
    AnimController.headlineIconControllerF();
    
  }

  deactivateListCards(){
    setState(() {
      isGreyBackground = false;  
    });
    isListActivated = false;
    AnimController.listCardsControllerR();
    AnimController.headlineIconControllerR();
  }

  _showIosAction<String>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  updateData() async {
    deactivateListCards();
    print('UPDATED');
    MyDataBase.updateCards(SharedPrefs.getPrefs().getInt(PrefsKey.cardNumber)).then({
      OmkaCardProvider.getSafeOmkaCard().then(
        (card){
          setState(() {
          _card = card; 
          });
        })
    });
    }

  @override
  Widget build(BuildContext context) {
    String _cardName;
    List<String> _cardHistory;
    int _cardType, _cardNumber;
    num _cardBalance;

    Color _primaryColor;
    
    final List<String> _menuItems = ['Настройки', 'О приложении'];

    _cardName = SharedPrefs.getPrefs().getString(PrefsKey.cardName);
     
    if(_card!=null){
      _cardType = _card.type;
      _cardNumber = _card.number;
      _cardBalance = _card.balance;
      _cardHistory = _card.history.split(': ');
      _cardHistory[0] = _cardHistory[0].replaceFirst('д', 'Д');
    }
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizes.appBarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 12,
          brightness: Brightness.light,
          centerTitle: true,
          title: GestureDetector(
            onTap: (){
              print(MyDataBase.getListCards());
              if(!isListActivated){
                activateListCards();
              }else if(isListActivated){
                deactivateListCards();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[ 
                Text(
                  _cardName,
                  style: Theme.of(context).textTheme.headline
                ),
                RotationTransition(
                  turns: AnimController.getHeadlineIconController(),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: MyColors.red,
                  ),
                ),
              ],
            ),
          ),
      actions: CheckDevice.isIos()
        ? <Widget> [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                MyDataBase.updateCards(_cardNumber);
                Future.delayed(Duration(seconds: 5), (){
                  updateData();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.more_horiz, color: MyColors.red,),
              onPressed: (){ 
                _showIosAction<String>(
                  context: context,
                  child: CupertinoActionSheet(
                    cancelButton: CupertinoActionSheetAction(
                      child: Text('Отменить', style: TextStyle(color: MyColors.red)),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                    ),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text('Настройки',style: TextStyle(color: MyColors.red)),
                        onPressed: (){
                          Navigator.pop(context, 'Cancel');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => null));
                        }
                      ),
                      CupertinoActionSheetAction(
                        child: Text('О приложении', style: TextStyle(color: MyColors.red) ),
                        onPressed: (){
                          Navigator.pop(context, 'Cancel');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => null));
                        }
                      )
                    ],
                  )
                );
              },
            )
          ]
        :
          <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                MyDataBase.updateCards(_cardNumber);
                Future.delayed(Duration(seconds: 5), (){
                  updateData();
                });
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: MyColors.red,),
              onSelected: (value){
                switch (value){
                  case 'Настройки':
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => TestWidget()));
                  break;
                  case 'О приложении':
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => null));
                  break;
                }
              },
              itemBuilder: (BuildContext context)  {
                return _menuItems.map((value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: MyColors.red),),
                  );
                }).toList();
              },
            )
          ]
        )
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: _card == null
                ? Container(
                    margin: EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 32.0),
                    height: Sizes.parentWidth(context) * 0.8 * 0.625,
                    width: Sizes.parentWidth(context) * 0.8, 
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : MainCard(
                    type: _cardType,
                    number: _cardNumber,
                  )
              ),
              Container(
                height: 50,
                width: Sizes.parentWidth(context) + 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.25, color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, -5.0),
                      blurRadius: 5.0,
                      spreadRadius: -5.0
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      Text('Баланс:', style: Theme.of(context).textTheme.body1),
                      _card!=null ? Text('$_cardBalance\u20bd', style: Theme.of(context).textTheme.body2)
                      :Container(
                        width: 32.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      ) 
                    ]
                  )
                )
              ),
              // InkWell(
              //   onTap: (){
              //     print('hello');
              //   },
              //   child: Container(
              //     height: 50.0,
              //     width: Sizes.parentWidth(context),
              //     decoration: BoxDecoration(
              //       border: Border(bottom: BorderSide(width: 0.25, color: Colors.grey))
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 16.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           Text(_cardHistory[0], style: Theme.of(context).textTheme.body1),
              //           Text(_cardHistory[1], style: Theme.of(context).textTheme.body1)
              //           //Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.black)
              //         ]
              //       )
              //     )
              //   )
              // ),
              
              ListTile(
                title: Text('Дата последней транзакции:', style: Theme.of(context).textTheme.body1,),
                subtitle: _card != null ? Text(_cardHistory[1])
                : Container(
                  margin: EdgeInsets.only(right: Sizes.parentWidth(context)*0.7),
                  height: 6.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                ),
              ),
              Spacer(),
              MainBottomSheet(
                color: _primaryColor,
              )             
            ],
          ),
          Visibility(
              visible: isGreyBackground,
              child: GestureDetector(
                onTap: (){
                  if(isListActivated){
                    deactivateListCards();
                  }
                },
                child: Container(
                  height: Sizes.parentHeight(context),
                  width: Sizes.parentWidth(context),
                  decoration: BoxDecoration(color: Color.fromARGB(100, 0, 0, 0)),
                ),
              ),
            ),
            _card!=null ? ListCardsWidget(updateMainCard: this.updateData, deactivateList: this.deactivateListCards) : Center()
        ]
      )
    );
  }

  
}
