import 'package:fieldhand/central/livestock.dart';
import 'package:fieldhand/database/db_function_bridge.dart';
import 'package:fieldhand/objects/task.dart';
import 'package:fieldhand/widgets/add_object_elements.dart';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/selection_dialogs/selection_dialog_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:google_fonts/google_fonts.dart';


class TaskEntry extends StatefulWidget {

  TaskEntry({@required this.edit, this.task, this.currentObject});

  final String routeName = 'TaskEntry';
  final bool edit;
  final Task task;
  final String currentObject;

  @override
  _TaskEntryState createState() => _TaskEntryState();
}

class _TaskEntryState extends State<TaskEntry> {
  String originalId;
  Task task;
  Map links = Map<String, List<String>>();

  bool saveSafe = false;
  bool hasDeadline = false;
  String saveError;

  TextEditingController identifierController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  /// Setter wrapper functions for options fields
  ValueSetter setterObjectType, setterPriority;

  /// Setter wrapper functions for date fields
  ValueSetter setterDeadline;

  /// Setter wrapper functions for links
  ValueSetter setterSubjects, setterStaff;

  void initializeWrapperFunctions() {
    setterPriority = (selection) => setState((){task.setPriority = selection; saveCheck();});
    setterObjectType = (selection) => setState((){task.objectType = selection; saveCheck();});
    setterDeadline = (date) => setState((){task.deadline = date; saveCheck();});
    setterSubjects = (selection) {
      print(selection);
      print(selection.runtimeType);
      task.subjects = selection.toSet();
      print("RUN TYPE: ");
      print(task.subjects.runtimeType);
      findLinks();
      saveCheck();
    };
  }

  void findLinks() async {
    if (task.subjects != null) {
      links['subjectsId'] = List<String>();
      task.subjects.forEach((element) async {
        links['subjectsId'].add(getIdentifier(object: await queryAllSerial(serial: element)));
      });
    } else if (widget.currentObject != null) {
      links['subjectsId'].add(await queryAllSerial(serial: widget.currentObject));
    }

    if (task.staff != null) {
      links['staffId'].addAll(task.staff.forEach((element) async {
        await queryAllSerial(serial: element);
      }));
    } else if (widget.currentObject != null) {
      links['staffId'].add(await queryAllSerial(serial: widget.currentObject));
    }
    setState(() {});
    print(links['subjectsId']);
  }

  String getIdentifier({@required object}) {
    setState(() {});
    return object.displayIdentifier;
  }

  @override
  void dispose() {
    task = null;
    identifierController?.dispose();
    notesController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    originalId = widget.task?.identifier;
    task = widget.task != null? Task.fromMap(widget.task.toMap()) : Task();
    if (task.identifier != null) identifierController.text = task.identifier;
    if (task.notes != null) notesController.text = task.notes;
    initializeWrapperFunctions();
    findLinks();
    saveCheck();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
          body: addBody(
            context: context,
            header: widget.edit? 'Edit Task'.i18n : 'Create Task'.i18n,
            child: Column(
              children: <Widget>[
                verticalSpace(context, 0.07),
                inputForm(
                    context: context,
                    editingController: identifierController,
                    header: 'Label / ID (required)'.i18n,
                    hint: 'Enter Label / Identifier'.i18n,
                    icon: Icons.create,
                    onChanged: (value) {
                      task.identifier = value;
                      saveCheck();
                    },
                    invert: true),
                verticalSpace(context, 0.03),
                optionInputButton(
                    context: context,
                    header: 'Type (required)'.i18n,
                    hint: 'Select Type'.i18n,
                    icon: Icons.view_carousel,
                    objectTable: Task.table,
                    objectColumn: Task.typeColumn,
                    fieldCurrent: task.objectType,
                    fieldSetter: setterObjectType,
                    defaultValues: Task.defaultTypes,
                    sortAlpha: true),
                verticalSpace(context, 0.03),
                selectionChips(
                    context: context,
                    header: 'Priority (required)'.i18n,
                    options: Task.defaultPriorities,
                    fieldCurrent: task.priority,
                    fieldSetter: setterPriority),
                checkBoxSelection(
                    context: context,
                    label: 'Set Deadline'.i18n,
                    selection: hasDeadline,
                    onChanged: (bool newValue) {
                      setState(() {
                      hasDeadline = newValue;});},
                ),
                dateInputButton(context: context,
                    header: 'Deadline'.i18n,
                    hint: 'Select Deadline'.i18n,
                    icon: Icons.schedule,
                    fieldSetter: setterDeadline,
                    fieldCurrent: task.deadline,
                    disabled: !hasDeadline,
                    disabledHint: 'No Deadline'.i18n,
                    future: true,
                    bottomSpace: true),
                multiLinkInputButton(
                    context: context,
                    header: 'Subjects'.i18n,
                    hint: 'Select Subjects',
                    icon: Icons.art_track,
                    objectType: task.objectType,
                    fieldSetter: setterSubjects,
                    fieldCurrent: task.subjects,
                    currentId: links['subjectsId'],
                    origin: task.serial),
                verticalSpace(context, 0.03),
                multiLinkInputButton(
                    context: context,
                    header: 'Assign Staff'.i18n,
                    hint: 'Select Staff',
                    icon: CustomIcons.users,
                    objectType: task.objectType,
                    fieldSetter: setterStaff,
                    fieldCurrent: task.staff,
                    currentId: links['staffId'],
                    origin: task.serial),
                verticalSpace(context, 0.03),
                textArea(
                    editingController: notesController,
                    context: context,
                    header: 'Notes'.i18n,
                    hint: 'Enter Additional Notes'.i18n,
                    icon: Icons.note,
                    invert: true,
                    onChanged: (value) => task.notes = value),
                verticalSpace(context, 0.06),
                generalBlueButton(
                    context: context,
                    text: widget.edit? "Save".i18n : "Create".i18n,
                    disabled: !saveSafe,
                    function: () {
                      if (saveSafe) {
                        if (widget.edit == false) {
                          save(objectTable: Task.table, object: task);
                        } else {
                          update(objectTable: Task.table, object: task);
                        }
                        navigate(context: context,
                            page: Livestock(),
                            direction: 'right',
                            fromDrawer: false,
                            pop: true);
                      }
                    }),
                verticalSpace(context, 0.01),
                if (saveError != null && saveError != "") Text(saveError, style: GoogleFonts.notoSans(color: Colors.white, fontSize: displayWidth(context) * 0.03),),
                verticalSpace(context, 0.05),
              ],
            ),
          )),
    );
  }

  /// Ensure id, type, and priority are not null
  void saveCheck() async {
    if (task.identifier != null && task.identifier.trim() != '' && task.objectType != null && task.priority != null) {
      setState(() {
        saveSafe = true;
        saveError = "";
      });
    } else {
      setState(() {
        saveSafe = false;
        saveError = "Please fill required fields".i18n;
      });
    }
  }

  /// if no deadline required, then clear [task.deadline]
  void clearDependentFields() {
    if (!hasDeadline) task.deadline = null;
  }

}
