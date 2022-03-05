import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DatabaseHandler {


  // Initialises the Database and creates a Table if table not yet created
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'budgetList'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE budget(id INTEGER PRIMARY KEY, Catagory TEXT, item TEXT, unitprice FLOAT, quantity INTEGER, itemcosts FLOAT)'
        );

        await database.execute(
          'CREATE TABLE catagory(id INTEGER PRIMARY KEY, Catagory TEXT)',
        );

        await database.execute(
          '''INSERT INTO catagory(
            id,
            Catagory
        )
        VALUES
          (
            1,
            'Utilities'
            
        ),
        (
      2,
            'Food'
        ),
        (
      3,
            'Savings'
        );
        ''',
        );



      },
      version: 2,
    );
  }


  // Insert catagroy into the table
  Future<void> insertcatagory(catagory catagory) async {
    final db = await initializeDB();
    await db.insert(
      'catagory',
      catagory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  //insert item into the  list
  Future<void> insertitem(item item) async {
    final db = await initializeDB();
    await db.insert(
      'budget',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<catagory>> catagories() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('select id,  catagory from catagory');
    print(queryResult);
    return queryResult.map((e) => catagory.fromMap(e)).toList();
  }

  Future<List<item>> items(String cata) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult ;
    if (cata != " "){
      queryResult = await db.rawQuery('select * from budget where catagory = "$cata"');
      print(queryResult);
    }
    else {
      queryResult = await db.rawQuery('select * from budget');
      print(queryResult);
    }

    print(queryResult);
    return queryResult.map((e) => item.fromMap(e)).toList();
  }


  Future<void> deletetcatagory(int id) async {
    final db = await initializeDB();
    await db.delete(
      'catagory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> deletetItem(int id) async {
    final db = await initializeDB();
    await db.delete(
      'budget',
      where: 'id = ?',
      whereArgs: [id],
    ).then((value){
      print("item $id deleted");
    });

  }


  Future<void> updateItem(String Item, double cost, int Quantity,double total, int id)async{


    Map<String, dynamic> values = {
      "item": Item,
      "unitprice": cost,
      "quantity": Quantity,
      "itemcosts": total
    };

    print(values);
    final db = await  initializeDB();
    await db.update("budget", values, where: 'id =?', whereArgs: [id]);


  }
}
