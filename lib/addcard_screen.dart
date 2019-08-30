import 'package:flutter/material.dart';
import 'package:omka2/backend/database.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:omka2/values/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';

class AddCardScreen extends StatefulWidget{
 AddCardScreen(this.updateMainCard);

  final Function updateMainCard;

  @override
  State<StatefulWidget> createState() {
    return _AddCardScreenState(updateMainCard);
  }
}

class _AddCardScreenState extends State<AddCardScreen>{
  _AddCardScreenState(this.updateMainCard);

  final Function updateMainCard;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();

  int cardNum;
  String cardBalance;
  int cardType;
  String cardHistory;
  bool isFirstScanning = true;

  var prefs = SharedPrefs.getPrefs();
  test(){
    updateMainCard();
    Navigator.pop(context);
  }
  addCard(){    
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
      if(updateMainCard != null)MyDataBase.addCard(item).then((_)=>test());
      
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizes.appBarHeight),
        child: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check), color: MyColors.red, onPressed: (){
              if(_nameController.text != null && cardNum != null && _nameController.text != ''){
                addCard();
              }else{
                showSnackBar('Не все данные введены');
              }
            },)
          ],
          brightness: Brightness.light,
          title: Text(
            'Добавить карту',
            style: Theme.of(context).textTheme.headline
          ),
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
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
                hintText: 'Введите имя карты',
              ),
            ),
          ),
          getCardNumFunctions()
        ]
      ),
    );
  }

  Widget getCardNumFunctions(){
    if(isFirstScanning){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Text('Номер: '),
              FlatButton(
                onPressed: (){
                  barcodeScanning();
                },
                child: Text('Просканировать'),
                textColor: Colors.blue,
            )
          ],
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Text('Номер: '),
            cardNum != null ?
            Text('000$cardNum', style: TextStyle(color: Colors.blue))
            :
            CircularProgressIndicator(),
            IconButton(icon: Icon(Icons.refresh), onPressed: (){
              barcodeScanning();
              setState(() {
                cardNum = null;
              });
            },)
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
}