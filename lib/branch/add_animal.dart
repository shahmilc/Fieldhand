import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/database/database_core.dart';
import 'package:fieldhand/widgets/add_object_elements.dart';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/src/material_rounded_date_picker_style.dart';
import 'package:fieldhand/widgets/selection_dialogs/selection_dialog_functions.dart';
import 'file:///C:/Users/shahm/FlutterProjects/fieldhand/lib/widgets/selection_dialogs/image_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/objects/animal.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/rounded_picker.dart';

class AddAnimal extends StatefulWidget {
  AddAnimal({Key key}) : super(key: key);

  final String routeName = 'AddAnimal';

  @override
  _AddAnimalState createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {
  Animal animal = Animal();

  // Setter wrapper functions for options fields
  ValueSetter setterAnimalType;
  ValueSetter setterSex;
  ValueSetter setterAcquisition;
  ValueSetter setterStatus;

  // Setter wrapper function for image selection
  ValueSetter setterThumbnail;

  //Setter wrapper functions for date fields
  ValueSetter setterBirthDate;

  @override
  void dispose() {
    animal = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeWrapperFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
          body: Builder(
              builder: (innerContext) => addBody(
        context: innerContext,
        header: 'Add Animal'.i18n,
        child: Column(
          children: <Widget>[
            verticalSpace(context, 0.07),
            imageThumbnail(
              context: context, size: 0.45,
              color: secondaryRed(),
              imagePath: animal.thumbLocation,
              editable: true,
              objectSerial: animal.serial,
              defaultImages: Animal.imgList,
              fieldSetter: setterThumbnail,
              handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            inputForm(
                context: context,
                header: 'Name / ID'.i18n,
                hint: 'Enter Name / Identifier',
                icon: Icons.create,
                onChanged: (value) {
                  animal.displayIdentifier = value;
                  animal.identifier = value.toLowerCase();
                  print(animal.displayIdentifier);
                },
                invert: true),
            verticalSpace(context, 0.03),
            optionsInputButton(
                context: innerContext,
                header: 'Type'.i18n,
                hint: 'Select Type'.i18n,
                icon: CustomIcons.horse_head,
                objectTable: Animal.table,
                objectColumn: Animal.typeColumn,
                fieldSetter: setterAnimalType,
                fieldCurrent: animal.animalType,
                defaultValues: Animal.defaultTypes,
                sortAlpha: true,
                handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            optionsInputButton(
                context: context,
                header: 'Sex'.i18n,
                hint: 'Select Sex'.i18n,
                icon: CustomIcons.venus_mars,
                objectTable: Animal.table,
                objectColumn: Animal.sexColumn,
                fieldSetter: setterSex,
                fieldCurrent: animal.sex,
                defaultValues: Animal.defaultSexes,
                handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            optionsInputButton(
                context: context,
                header: 'Acquisition'.i18n,
                hint: 'Select Method'.i18n,
                icon: Icons.transit_enterexit,
                objectTable: Animal.table,
                objectColumn: Animal.sexColumn,
                fieldSetter: setterAcquisition,
                fieldCurrent: animal.acquisition,
                defaultValues: Animal.defaultAcquisitions,
                handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            optionsInputButton(
                context: context,
                header: 'Status'.i18n,
                hint: 'Select Status'.i18n,
                icon: Icons.thumbs_up_down,
                objectTable: Animal.table,
                objectColumn: Animal.statusColumn,
                fieldSetter: setterStatus,
                fieldCurrent: animal.currentStatus,
                defaultValues: Animal.defaultStatuses,
                handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            dateInputButton(context: context,
                header: 'Birth Date'.i18n,
                hint: 'Select Birth Date'.i18n,
                icon: CustomIcons.birthday_cake,
                fieldSetter: setterBirthDate,
                fieldCurrent: animal.birthDate,
                handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            inputForm(
                context: context,
                header: 'Dam'.i18n,
                hint: 'Select Dam'.i18n,
                icon: Icons.view_array,
                invert: true),
            verticalSpace(context, 0.03),
            verticalSpace(context, 0.06),
            generalBlueButton(
                context: context,
                text: "Add".i18n,
                function: () {
                  // navigate(context: context, page: Dashboard(), direction: 'right', fromDrawer: false);
                  _save();
                }),
            verticalSpace(context, 0.06)
          ],
        ),
      ))),
    );
  }

  handleReturn(
      {@required ValueSetter fieldSetter, @required String returnValue}) {
    setState(() {
      if (returnValue != null) fieldSetter(returnValue);
    });
  }

  initializeWrapperFunctions() {
    // Setter wrapper functions for options fields
    setterAnimalType = (selection) => animal.setAnimalType = selection;
    setterSex = (selection) => animal.setSex = selection;
    setterAcquisition = (selection) => animal.setAcquisition = selection;
    setterStatus = (selection) => animal.setStatus = selection;

    // Setter wrapper function for image selection
    setterThumbnail = (selection) => animal.setThumbnail = selection;

    //Setter wrapper functions for date fields
    setterBirthDate = (date) => animal.setBirthDate = date;
  }

  _save() async {
    Animal animal = Animal();
    DatabaseHelper helper = DatabaseHelper.instance;
    int id =
        await helper.insertObject(objectTable: Animal.table, object: animal);
    print('inserted row: $id');
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    String nameId = 'Be2ty2'.toLowerCase();
    Animal animal;
    Map animalData = await helper.queryObject(
        objectTable: Animal.table,
        objectColumns: Animal.columns,
        objectId: nameId.toLowerCase());
    if (animalData.length > 0) {
      animal = Animal.fromMap(animalData);
    } else {
      print('read row $nameId: ${animal.displayIdentifier} ${animal.animalType}');
      print('read row $nameId: empty');
    }
  }

  _getTypes() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var hold = await helper.queryColumn();
    print(hold);
  }

  _delete() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    String rowId = 'hello';
    bool result = await helper.deleteItem('Berty'.toLowerCase());
    if (result)
      print('success');
    else
      print('failed');
  }
}
