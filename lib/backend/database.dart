import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/values/prefs_keys.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class MyDataBase{
  static const _dbTable = 'Cards';
  static List<Map> _listCards;
  static Database _dataBase;
  static String _dbPath;
  static int _dbVersion = SharedPrefs.getPrefs().getInt(PrefsKey.dbVersion);
  static Map _safeCard;

  static loadDBPath() async {
    var dbPath = await getDatabasesPath();   
    _dbPath = join(dbPath, 'CardsDB.db');
  }

  static _createDB() async{
    _dataBase = await openDatabase(_dbPath, version: 1,
      onCreate: (Database _db, int version) async{
        await _db.execute(
          'CREATE TABLE Cards (id INTEGER PRIMARY KEY, name TEXT, type INTEGER , number INTEGER , balance REAL, history TEXT)'
        );
        _db.insert('Cards', {'id' : 0, 'name':'Добавить', 'type': 3, 'number':111, 'balance': 222.0, 'history': 'Nothing'});
      }
    );
    _dataBase.close();
  }

  static createDB() async {
    loadDBPath().then((_) => _createDB());
  } 

  static Future<Map>loadSafeCard(int number) async {
    var dataBase = await openDatabase(_dbPath, version: _dbVersion);
    print('loadSafeDB');
    var card = await dataBase.query(
      _dbTable,
      where: "number = ?",
      whereArgs: [number]
    );
    dataBase.close();
    print(_listCards);
    return card[0];
    
  }

  static addCard(Map card) async {
    var dataBase = await openDatabase(_dbPath, version: _dbVersion);
    await dataBase.insert(_dbTable, card);
    print('AddCardDB');
    dataBase.close();
    //Future.delayed(Duration(milliseconds: 500));
  }

  static deleteCard(Map card) async {
    var dataBase = await openDatabase(_dbPath, version: _dbVersion);
    await dataBase.delete(
      _dbTable,
      where: "number = ?",
      whereArgs: [card.values.toList()[3]]
    );
    print('DELETED CARSD');
    dataBase.close();
  }

  static updateList() async{
    var dataBase = await openDatabase(_dbPath, version: _dbVersion);
    print('UPDATED LIST');
    _listCards = await dataBase.rawQuery('SELECT * FROM $_dbTable');
    dataBase.close();
  }

  static checkNumbers() async{
    var dataBase = await openDatabase(_dbPath, version: _dbVersion);
    List<Map> data = await dataBase.rawQuery('SELECT number FROM $_dbTable');
    return data;
  }

  static updateCards(int number) async{
    print('number ------ $number');
    var url = "http://192.168.43.12/index.php?num=$number";
    final response = await http.get(url);
    if(response.statusCode == 200){
      List<String> body = response.body.split(', ');
      num _balanceCard = num.parse(body[1].replaceAll(' т.е.', '').replaceAll('Остаток на карте: ', ''));
      String _historyCard = body[2];
      var dataBase = await openDatabase(_dbPath, version: _dbVersion);
      await dataBase.update(
        _dbTable, {'balance': _balanceCard, 'history': _historyCard}, where: 'number = ?', whereArgs: [number]
      );
      dataBase.close();
    }
  }

  static List<Map> getListCards(){
    return _listCards;
  }


}