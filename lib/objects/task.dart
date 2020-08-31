import 'package:fieldhand/computation/general_functions.dart';

/// Task Table Columns

final String tableTask = 'task_table';
final String columnId = 'name_id';
final String columnActive = 'active';
final String columnType = 'type';
final String columnPriority = 'priority';
final String columnDeadline = 'deadline';
final String columnSubjects = 'subjects';
final String columnStaff = 'staff';
final String columnNotes = 'notes';
final String columnEditDate = 'edit_date';
final String columnEditUser = 'edit_user';
final String columnSerial = 'serial_number';

/// data model class
class Task {

  static final String _tableName = tableTask;

  static final List<String> _tableColumns = [
    columnId,
    columnActive,
    columnType,
    columnPriority,
    columnDeadline,
    columnSubjects,
    columnStaff,
    columnNotes,
    columnEditDate,
    columnEditUser,
    columnSerial
  ];

  static final List<String> defaultTypes = ['Vaccination', 'Maintenance', 'Medical', 'Harvest', 'Plant', 'Fertilize', 'Shear', 'Wash', 'Milk', 'Transport', 'Collect', 'Purchase'];
  static final List<String> defaultPriorities = ['Low', 'Medium', 'High'];

  String identifier;
  bool active = true;
  String objectType;
  int priority;
  String deadline;
  String subjects;
  String staff;
  String notes;
  DateTime editDate;
  String editUser;
  String serial = generateObjectSerial();

  Task();

  /// convenience constructor to create a object
  Task.fromMap(Map<String, dynamic> map) {
    identifier = map[columnId];
    active = map[columnActive] == 1;
    objectType = map[columnType];
    priority = map[columnPriority];
    deadline = map[columnDeadline];
    subjects = map[columnSubjects];
    staff = map[columnStaff];
    notes = map[columnNotes];
    editDate = map[columnEditDate];
    editUser = map[columnEditUser];
    serial = map[columnSerial];
  }

  /// convenience method to create a Map from this object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: identifier,
      columnActive: active? 1 : 0,
      columnType: objectType,
      columnPriority: priority,
      columnSubjects: subjects,
      columnStaff: staff,
      columnNotes: notes,
      columnEditDate: editDate,
      columnEditUser: editUser,
      columnSerial: serial,
    };
    return map;
  }

  /// General getters
  static String get table => _tableName;
  static List<String> get columns => _tableColumns;

  /// Getters for options fields
  static String get typeColumn => columnType;

  /// Setters for options fields
  set setObjectType(String value) => this.objectType = value;
  set setPriority(int value) => this.priority = value;

  /// Setters for date fields
  set setDeadline(String value) => this.deadline = value;

  /// Setters for links
  set setSubjects(String value) => this.subjects = value;

}