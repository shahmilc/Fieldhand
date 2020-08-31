import 'dart:io';
import 'package:fieldhand/objects/task.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fieldhand/objects/animal.dart' as animal;
import 'package:fieldhand/objects/task.dart' as task;

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
              CREATE TABLE IF NOT EXISTS ${animal.tableLivestock} (
                ${animal.columnSerial} TEXT NOT NULL PRIMARY KEY,
                ${animal.columnId} TEXT NOT NULL,
                ${animal.columnDisplayId} TEXT,
                ${animal.columnThumb} TEXT,
                ${animal.columnType} TEXT NOT NULL,
                ${animal.columnSex} TEXT NOT NULL,
                ${animal.columnAcquisition} TEXT,
                ${animal.columnStatus} TEXT,
                ${animal.columnBirth} TEXT,
                ${animal.columnDeath} TEXT,
                ${animal.columnPurchase} TEXT,
                ${animal.columnSold} TEXT,
                ${animal.columnDue} TEXT,
                ${animal.columnDam} TEXT,
                ${animal.columnSire} TEXT,
                ${animal.columnBreed} TEXT,
                ${animal.columnTasks} TEXT,
                ${animal.columnNotes} TEXT,
                ${animal.columnEditDate} TEXT,
                ${animal.columnEditUser} TEXT
              )
              ''');
    await db.execute('''
              CREATE TABLE IF NOT EXISTS ${task.tableTask} (
                ${task.columnSerial} TEXT NOT NULL PRIMARY KEY,
                ${task.columnId} TEXT NOT NULL,
                ${task.columnActive} INTEGER NOT NULL,
                ${task.columnType} TEXT NOT NULL,
                ${task.columnPriority} INTEGER NOT NULL,
                ${task.columnDeadline} TEXT,
                ${task.columnSubjects} TEXT,
                ${task.columnStaff} TEXT,
                ${task.columnNotes} TEXT,
                ${task.columnEditDate} TEXT,
                ${task.columnEditUser} TEXT
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

  Future<int> updateObject({@required String objectTable, @required object}) async {
    Database db = await database;
    try {
      int updateCount = await db.update(
          objectTable,
          object.toMap(),
          where: '$columnSerial = ?',
          whereArgs: [object.serial]);
      return updateCount;
    } catch (e) {
      return 0;
    }
  }

  Future<Map> queryObjectId({@required String objectTable, @required List<String> objectColumns, @required String objectId}) async {
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

  Future<Map> queryObjectSerial({@required String objectTable, @required List<String> objectColumns, @required String objectSerial}) async {
    Database db = await database;
    List<Map> maps = await db.query(objectTable,
        columns: objectColumns,
        where: '$columnSerial = ?',
        whereArgs: [objectSerial]);
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
      await db.delete(animal.tableLivestock, where: '$columnId = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List> queryAll({@required String table}) async {
    Database db = await database;
    List rawData = List();
    rawData = await db.rawQuery('SELECT * FROM $table');
    return rawData;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
