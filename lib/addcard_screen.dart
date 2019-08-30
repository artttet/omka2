import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omka2/backend/check_device.dart';
import 'package:omka2/backend/database.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:omka2/values/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:omka2/values/svg_assets.dart';

class AddCardScreen extends StatefulWidget{
 AddCardScreen(this.updateMainCard);

  final Function updateMainCard;

  @override
  State<StatefulWidget> createState() {
    return _AddCardScreenState();
  }
}

class _AddCardScreenState extends State<AddCardScreen>{
  String cardBalance;
  String cardHistory;
  int cardNum;
  int cardType;
  bool isFirstScanning = true;
  var prefs = SharedPrefs.getPrefs();

  TextEditingController _nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  up(){
    widget.updateMainCard();
    Navigator.pop(context);
  }

  _addCard(){    
    Map<String, dynamic> item = {'name' : _nameController.text, 'type' : cardType,'number' : cardNum,'balance' : cardBalance, 'history': cardHistory};
 
    prefs.setString('cardName', _nameController.text);
    prefs.setInt('cardNumber', cardNum);

    prefs.setBool(PrefsKey.needUpdate, true);
 
    if(prefs.getInt(PrefsKey.currentListCardIndex) == -1){
      MyDataBase.addCard(item);
      prefs.setInt(PrefsKey.currentListCardIndex, 0);
      Navigator.pushReplacementNamed(context, '/mainScreen');
    }else {
      prefs.setInt(PrefsKey.currentListCardIndex, 0);
      if(widget.updateMainCard != null)MyDataBase.addCard(item).then((_)=>up());
      
    }
  }

  Widget getCardNumFunctions(){
    if(isFirstScanning){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: <Widget>[
              FlatButton(
                onPressed: (){
                  barcodeScanning();
                },
                child: Text('Сканировать карту'),
                textColor: Colors.blue,
            )
          ],
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: <Widget>[
            cardNum != null
            ?
            Text(
              '000 ${cardNum.toString().substring(0,3)} ${cardNum.toString().substring(3,6)}',
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)
            )
            :
            Container(
              width: 96,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
            )      
          ],
        ),
      );
    }
  }

  Future barcodeScanning() async {
    try {
      var checkNumbers = MyDataBase.checkNumbers();
      print(checkNumbers);
      setState(() {
       isFirstScanning = false; 
      });
      String barcode = await BarcodeScanner.scan();
      int number = int.tryParse(barcode.substring(9, 18));
      if(number != null){
        final response = await http.get('http://8360aea6.ngrok.io/index.php?num=$number');
        if(response.statusCode == 200){
          List<String> infos = response.body.split(', ');
          if(infos[0] != '-1'){
            print(number);
            setState(() {
              cardNum = number;
              cardBalance = infos[1].replaceAll(' т.е.', '').replaceAll('Остаток на карте: ', '');
              cardType = int.parse(infos[0]);
              cardHistory = infos[2];
            });
          }else{
            showSnackBar('Неверно сканированный номер карты');
            setState(() {
              isFirstScanning = true;
            });
          }
        }else{
          showSnackBar('Сервер в данный момент недоступен');
          setState(() {
            isFirstScanning = true;
          });
        }
      }
    } catch (e) {
      showSnackBar('Попробуйте повторить попытку');
      setState(() {
       isFirstScanning = true; 
      });
      print(e);
    }
  }

  showSnackBar(String value){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        )
      )
    );
  }

  Widget cardNameField(){
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        
        labelText: 'Имя',
        border: OutlineInputBorder(),
        hintText: 'Введите имя карты',
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    var color;
    var owner;
    if(cardNum!= null){
      switch (cardType){
        case 1: {
          color = MyColors.cGreen;
          owner = 'Гражданина';
        }
        break;
        case 2: {
          color = MyColors.cBlue;
          owner = 'Пенсионера'; 
        }
        break;
        case 3: {
          color = MyColors.cOrange;
          owner = 'Школьника';
        }
        break;
        case 4: {
          color = MyColors.cRed;
          owner = 'Студента';
        }
        break;
      }
    }
    
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizes.appBarHeight),
        child: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Visibility(
            visible: SharedPrefs.getPrefs().getInt(PrefsKey.currentListCardIndex) == -1 ? false : true,
            child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.red,
              ),
              onPressed: (){
                Navigator.pop(context);
                }
            ),
          ),
          title: Text(
            'Добавить карту',
            style: Theme.of(context).textTheme.headline
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              color: MyColors.red,
              onPressed: (){
                if(_nameController.text != null && cardNum != null && _nameController.text != ''){
                  _addCard();
                }else{
                  showSnackBar('Не все данные введены');
                }
              }
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: cardNameField()
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
              width: Sizes.parentWidth(context)*0.9,
              height: Sizes.parentWidth(context) * 0.9*  0.625,
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
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: 16.0, left: 12.0),
                      width: Sizes.parentWidth(context) * 0.9 ,
                      height: Sizes.parentWidth(context) * 0.9*0.625,
                      child: MySvg.logoOmkaAdd,
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    left: Sizes.parentWidth(context) * 0.9 * 0.2,
                    child: getCardNumFunctions(),
                  ),
                  cardNum != null ? Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height: Sizes.parentWidth(context) * 0.9 * 0.625 * 0.18,
                      width: Sizes.parentWidth(context) * 0.9 * 0.5,
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
                  ) : Center(),
                ],
              ),
            ),
          ),
          Spacer(),
          !isFirstScanning
          ?
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                backgroundColor: MyColors.red,
                child: Icon(Icons.refresh, color: Colors.white,),
                onPressed: (){
                  barcodeScanning();
                  setState(() {
                    cardNum = null;
                  });
                },
              ),
            ),
          )
          : 
          Center(),
        ],
      )
    );
  }
}