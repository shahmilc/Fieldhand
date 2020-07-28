import 'package:fieldhand/computation/general_functions.dart';
import 'package:i18n_extension/default.i18n.dart';

// Livestock Table Columns

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

// data model class
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

  static final List<String> defaultTypes = ['Cow'.i18n, 'Horse'.i18n, 'Pig'.i18n, 'Chicken'.i18n, 'Sheep'.i18n, 'Ox'.i18n, 'Goat'.i18n, 'Buffalo'.i18n, 'Turkey'.i18n, 'Duck'.i18n, 'Rabbit'.i18n, 'Rodent'.i18n];
  static final List<String> defaultSexes = ['Male'.i18n, 'Female'.i18n];
  static final List<String> defaultAcquisitions =['Farm born'.i18n, 'Purchased'.i18n];
  static final List<String> defaultStatuses = ['Healthy'.i18n, 'Ill'.i18n, 'Pregnant'.i18n, 'Deceased'.i18n, 'Sold'.i18n];

  String identifier;
  String displayIdentifier;
  String thumbLocation = imgList[0];
  String animalType;
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
  List tasks;
  String notes;
  DateTime editDate;
  String editUser;
  String serial = generateObjectSerial();

  Animal();

  // convenience constructor to create a object
  Animal.fromMap(Map<String, dynamic> map) {
    identifier = map[columnId];
    displayIdentifier = map[columnDisplayId];
    thumbLocation = map[columnThumb];
    animalType = map[columnType];
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

  // convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: identifier,
      columnDisplayId: displayIdentifier,
      columnThumb: thumbLocation,
      columnType: animalType,
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

  // General getters
  static String get table => _tableName;

  static List<String> get columns => _tableColumns;

  // Getters for options fields
  static String get typeColumn => columnType;

  static String get sexColumn => columnSex;

  static String get acquisitionColumn => columnAcquisition;

  static String get statusColumn => columnStatus;

  // Setters for options fields
  set setAnimalType(String value) => this.animalType = value;

  set setSex(String value) => this.sex = value;

  set setAcquisition(String value) => this.acquisition = value;

  set setStatus(String value) => this.currentStatus = value;

  // Setters for date fields
  set setBirthDate(String value) => this.birthDate = value;

}