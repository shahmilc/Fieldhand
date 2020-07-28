import 'package:fieldhand/database/database_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/objects/animal.dart';

Future<Object> readObject({@required String objectId, @required String objectType}) async {
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

Future<Set> readColumn({@required String objectTable, @required String objectColumn}) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  Set uniqueColumnItems = Set();
  List<Map> rawData = List<Map>();
  rawData = await helper.queryColumn(objectTable: objectTable, objectColumn: objectColumn);
  // rawData format: [{'columnName': 'columnUniqueData1'}, {'columnName': 'columnUniqueData2'} ... ]
  rawData.forEach((map) => map.forEach((key, value) => uniqueColumnItems.add(value)));
  return uniqueColumnItems;
}