import 'dart:convert';

import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/translations/animal.i18n.dart';

/// Livestock Table Columns

final String tableLivestock = 'livestock_table';
final String columnId = 'name_id';
final String columnDisplayId = 'display_name_id';
final String columnThumb = 'thumb_location';
final String columnType = 'type';
final String columnSex = 'sex';
final String columnAcquisition = 'acquisition';
final String columnStatus = 'current_status';
final String columnBirth = 'birth_date';
final String columnDeath = 'death_date';
final String columnPurchase = 'purchase_date';
final String columnSold = 'sold_date';
final String columnDue = 'due_date';
final String columnDam = 'dam';
final String columnSire = 'sire';
final String columnBreed = 'breed';
final String columnTasks = 'tasks';
final String columnNotes = 'notes';
final String columnEditDate = 'edit_date';
final String columnEditUser = 'edit_user';
final String columnSerial = 'serial_number';

/// data model class
class Animal {

  static final String _tableName = tableLivestock;

  static final List<String> _tableColumns = [
    columnId,
    columnDisplayId,
    columnThumb,
    columnType,
    columnSex,
    columnAcquisition,
    columnStatus,
    columnBirth,
    columnDeath,
    columnPurchase,
    columnSold,
    columnDue,
    columnDam,
    columnSire,
    columnBreed,
    columnTasks,
    columnNotes,
    columnEditDate,
    columnEditUser,
    columnSerial
  ];

  static final List<String> imgList = [
    'assets/img/objectImages/default.png',
    'assets/img/objectImages/animals/preset/pig.png',
    'assets/img/objectImages/animals/preset/cow.png',
    'assets/img/objectImages/animals/preset/horse.png',
    'assets/img/objectImages/animals/preset/buffalo.png',
    'assets/img/objectImages/animals/preset/sheep.png',
    'assets/img/objectImages/animals/preset/goat.png',
    'assets/img/objectImages/animals/preset/ox.png',
    'assets/img/objectImages/animals/preset/chicken.png',
    'assets/img/objectImages/animals/preset/duck.png',
    'assets/img/objectImages/animals/preset/turkey.png',
    'assets/img/objectImages/animals/preset/dog.png',
    'assets/img/objectImages/animals/preset/cat.png',
    'assets/img/objectImages/animals/preset/rabbit.png',
    'assets/img/objectImages/animals/preset/rodent.png'
  ];

  static final List<String> defaultTypes = ['Cow', 'Horse', 'Pig', 'Chicken', 'Sheep', 'Ox', 'Goat', 'Buffalo', 'Turkey', 'Duck', 'Rabbit', 'Rodent'];
  static final List<String> defaultSexes = ['Male', 'Female'];
  static final List<String> defaultAcquisitions =['Farm born', 'Purchased'];
  static final List<String> defaultStatuses = ['Healthy', 'Ill', 'Pregnant', 'Deceased', 'Sold'];

  String identifier;
  String displayIdentifier;
  String thumbLocation = imgList[0];
  String objectType;
  String sex;
  String acquisition;
  String currentStatus;
  String birthDate;
  String deathDate;
  String purchaseDate;
  String soldDate;
  String dueDate;
  String dam;
  String sire;
  String breed;
  String tasks;
  String notes;
  DateTime editDate;
  String editUser;
  String serial = generateObjectSerial();

  Animal();

  /// convenience constructor to create a object
  Animal.fromMap(Map<String, dynamic> map) {
    identifier = map[columnId];
    displayIdentifier = map[columnDisplayId];
    thumbLocation = map[columnThumb];
    objectType = map[columnType];
    sex = map[columnSex];
    acquisition = map[columnAcquisition];
    currentStatus = map[columnStatus];
    birthDate = map[columnBirth];
    deathDate = map[columnDeath];
    purchaseDate = map[columnPurchase];
    soldDate = map[columnSold];
    dueDate = map[columnDue];
    dam = map[columnDam];
    sire = map[columnSire];
    breed = map[columnBreed];
    tasks = map[columnTasks];
    notes = map[columnNotes];
    editDate = map[columnEditDate];
    editUser = map[columnEditUser];
    serial = map[columnSerial];
  }

  /// convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: identifier,
      columnDisplayId: displayIdentifier,
      columnThumb: thumbLocation,
      columnType: objectType,
      columnSex: sex,
      columnAcquisition: acquisition,
      columnStatus: currentStatus,
      columnBirth: birthDate,
      columnDeath: deathDate,
      columnPurchase: purchaseDate,
      columnSold: soldDate,
      columnDue: dueDate,
      columnDam: dam,
      columnSire: sire,
      columnBreed: breed,
      columnTasks: tasks,
      columnNotes: notes,
      columnEditDate: editDate,
      columnEditUser: editUser,
      columnSerial: serial,
    };
    if (identifier != null) {
      map[columnId] = identifier;
    }
    return map;
  }

  /// General getters
  static String get table => _tableName;
  static List<String> get columns => _tableColumns;

  /// Getters for options fields
  static String get typeColumn => columnType;
  static String get sexColumn => columnSex;
  static String get acquisitionColumn => columnAcquisition;
  static String get statusColumn => columnStatus;
  static String get breedColumn => columnBreed;

  /// Setters for options fields
  set setObjectType(String value) => this.objectType = value;
  set setSex(String value) => this.sex = value;
  set setAcquisition(String value) => this.acquisition = value;
  set setStatus(String value) => this.currentStatus = value;
  set setBreed(String value) => this.breed = value;
  set setThumbnail(String value) => this.thumbLocation = value;

  /// Setters for date fields
  set setBirthDate(String value) => this.birthDate = value;
  set setDeathDate(String value) => this.deathDate = value;
  set setPurchaseDate(String value) => this.purchaseDate = value;
  set setSoldDate (String value) => this.soldDate = value;
  set setDueDate(String value) => this.dueDate = value;

  /// Setters for links
  set setDam(String value) => this.dam = value;
  set setSire(String value) => this.sire = value;

}