import 'package:flutter/material.dart';
import 'package:omka2/backend/database.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/values/colors.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:omka2/values/sizes.dart';

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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();

  var prefs = SharedPrefs.getPrefs();
  test(){
    updateMainCard();
    Navigator.pop(context);
  }
  addCard(){
    Map<String, dynamic> item = {'name' : _nameController.text, 'type' : int.parse(_typeController.text),'number' : int.parse(_numberController.text),'balance' : double.parse(_balanceController.text)};

    
    prefs.setString('cardName', _nameController.text);
    prefs.setInt('cardNumber', int.parse(_numberController.text));
    
    
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
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizes.appBarHeight),
        child: AppBar(
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
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                  hintText: 'Введите имя карты',
                ),
          ),
          TextField(
            controller: _numberController,
            decoration: InputDecoration(
                  hintText: 'Введите номер карты',
                ),
          ),
          TextField(
            controller: _typeController,
            decoration: InputDecoration(
                  hintText: 'Введите тип карты',
                ),
          ),
          TextField(
            controller: _balanceController,
            decoration: InputDecoration(
                  hintText: 'Введите баланс карты',
                ),
          ),
          RaisedButton(
            onPressed: (){
              addCard();
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          )
        ]
      ),
    );
  }
}