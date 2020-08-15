import 'package:fieldhand/database/database_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/objects/animal.dart';

Future<Object> readObject({@required String objectId, @required String objectType, @required Function function}) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  String objectTable;
  List<String> objectColumns = List<String>();
  Map rawTableData = Map();

  if (objectType == 'Animal') {
    Animal animal;
    objectTable = Animal.table;
    objectColumns = Animal.columns;
    rawTableData = await helper.queryObject(
        objectTable: objectTable,
        objectColumns: objectColumns,
        objectId: objectId.toLowerCase());
    if (rawTableData.length > 0) animal = Animal.fromMap(rawTableData);
    return animal;
  } else {
    debugPrint("⚠️ERROR: INVALID TYPE $objectType");
  }
}

/// Returns all unique data in a column
Future<Set> readColumn({@required String objectTable, @required String objectColumn}) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  Set uniqueColumnItems = Set();
  List<Map> rawData = List<Map>();
  rawData = await helper.queryColumn(objectTable: objectTable, objectColumn: objectColumn);
  /// rawData format: [{'columnName': 'columnUniqueData1'}, {'columnName': 'columnUniqueData2'} ... ]
  rawData.forEach((map) => map.forEach((key, value) {if (value != null) uniqueColumnItems.add(value);}));
  return uniqueColumnItems;
}

save({@required String objectTable, object}) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  int id = await helper.insertObject(objectTable: Animal.table, object: object);
  print('inserted row: $id');
}

/// Returns all objects in a table
Future<Set> queryAll({@required String table}) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  List rawData = List();
  Set objectSet = Set();
  rawData = await helper.queryAll(table: table);

  if (table == Animal.table) {
    rawData.forEach((map) => objectSet.add(Animal.fromMap(map)));
  }

  return objectSet;

}

