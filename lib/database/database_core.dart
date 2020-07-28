import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fieldhand/objects/animal.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "FieldhandDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE IF NOT EXISTS $tableLivestock (
                $columnId TEXT PRIMARY KEY,
                $columnDisplayId TEXT,
                $columnThumb TEXT,
                $columnType TEXT NOT NULL,
                $columnSex TEXT NOT NULL,
                $columnAcquisition TEXT,
                $columnStatus TEXT,
                $columnBirth TEXT,
                $columnDeath TEXT,
                $columnPurchase TEXT,
                $columnSold TEXT,
                $columnDue TEXT,
                $columnDam TEXT,
                $columnSire TEXT,
                $columnBreed TEXT,
                $columnTasks TEXT,
                $columnNotes TEXT,
                $columnEditDate TEXT,
                $columnEditUser TEXT,
                $columnSerial TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insertObject({@required String objectTable, @required object}) async {
    Database db = await database;
    try {
      int id = await db.insert(objectTable, object.toMap());
      return id;
    } catch (e) {
      return 0;
    }
  }

  Future<Map> queryObject({@required String objectTable, @required List<String> objectColumns, @required String objectId}) async {
    Database db = await database;
    List<Map> maps = await db.query(objectTable,
        columns: objectColumns,
        where: '$columnId = ?',
        whereArgs: [objectId]);
    if (maps.length > 0) {
      return maps.first; // Return raw data, call Animal.fromMap(rawData) to get object
    }
    return null;
  }

  Future<List> queryColumn({@required String objectTable, @required String objectColumn}) async {
    Database db = await database;
    List<Map> rawData = await db.rawQuery('SELECT DISTINCT $objectColumn FROM $objectTable');
    return rawData;
  }

  Future<bool> deleteItem(String id) async {
    Database db = await database;
    try {
      await db.delete(tableLivestock, where: '$columnId = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List> queryAll() async {
    Database db = await database;
    List<Animal> animals = List<Animal>();
    List<Map> list = await db.rawQuery('SELECT * FROM $tableLivestock');
    list.forEach((element) {animals.add(Animal.fromMap(element)); });
    return animals;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
