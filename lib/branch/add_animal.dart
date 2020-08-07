import 'package:fieldhand/central/livestock.dart';
import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/database/database_core.dart';
import 'package:fieldhand/database/db_function_bridge.dart';
import 'package:fieldhand/widgets/add_object_elements.dart';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/selection_dialogs/selection_dialog_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/objects/animal.dart';


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
  ValueSetter setterDeathDate;
  ValueSetter setterPurchaseDate;
  ValueSetter setterSoldDate;
  ValueSetter setterDueDate;

  initializeWrapperFunctions() {

    /// Setter wrapper functions for options fields
    setterAnimalType = (selection) {
      animal.setAnimalType = selection;
      /// If selected type is a default type, and selected image is a default image, set type to corresponding image
      if (Animal.defaultTypes.contains(selection) && Animal.imgList.contains(animal.thumbLocation)) {
        String matchingImagePath = Animal.imgList.where((String imagePath) => getImageName(imagePath) == selection).first;
        setterThumbnail(matchingImagePath);
      }
    };

    setterSex = (selection) => animal.setSex = selection;
    setterAcquisition = (selection) => animal.setAcquisition = selection;
    setterStatus = (selection) => animal.setStatus = selection;

    /// Setter wrapper function for image selection
    setterThumbnail = (imagePath) => animal.setThumbnail = imagePath;

    ///Setter wrapper functions for date fields
    setterBirthDate = (date) => animal.setBirthDate = date;
    setterDeathDate = (date) => animal.setDeathDate = date;
    setterPurchaseDate = (date) => animal.setPurchaseDate = date;
    setterSoldDate = (date) => animal.soldDate = date;
    setterDueDate = (date) => animal.dueDate = date;
  }

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
          body: addBody(
            context: context,
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
                header: 'Name / ID (required)'.i18n,
                hint: 'Enter Name / Identifier'.i18n,
                icon: Icons.create,
                onChanged: (value) {
                  animal.displayIdentifier = value;
                  animal.identifier = value.toLowerCase();
                  print(animal.displayIdentifier);
                },
                invert: true),
            verticalSpace(context, 0.03),
            optionsInputButton(
                context: context,
                header: 'Type (required)'.i18n,
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
                header: 'Sex (required)'.i18n,
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
                header: 'Status (required)'.i18n,
                hint: 'Select Status'.i18n,
                icon: Icons.thumbs_up_down,
                objectTable: Animal.table,
                objectColumn: Animal.statusColumn,
                fieldSetter: setterStatus,
                fieldCurrent: animal.currentStatus,
                defaultValues: Animal.defaultStatuses,
                handleReturn: handleReturn),
            verticalSpace(context, 0.03),
            if (animal.currentStatus == 'Deceased')
              dateInputButton(context: context,
                  header: 'Death Date'.i18n,
                  hint: 'Select Death Date'.i18n,
                  icon: CustomIcons.skull,
                  fieldSetter: setterDeathDate,
                  fieldCurrent: animal.deathDate,
                  handleReturn: handleReturn,
                  bottomSpace: true),
            if (animal.currentStatus == 'Pregnant')
              dateInputButton(context: context,
                  header: 'Due Date'.i18n,
                  hint: 'Select Due Date'.i18n,
                  icon: Icons.today,
                  fieldSetter: setterDueDate,
                  fieldCurrent: animal.dueDate,
                  handleReturn: handleReturn,
                  bottomSpace: true),
            if (animal.currentStatus == 'Sold')
              dateInputButton(context: context,
                  header: 'Sold Date'.i18n,
                  hint: 'Select Sold Date'.i18n,
                  icon: CustomIcons.file_invoice_dollar,
                  fieldSetter: setterSoldDate,
                  fieldCurrent: animal.soldDate,
                  handleReturn: handleReturn,
                  bottomSpace: true),
            dateInputButton(context: context,
                header: 'Birth Date'.i18n,
                hint: 'Select Birth Date'.i18n,
                icon: CustomIcons.birthday_cake,
                fieldSetter: setterBirthDate,
                fieldCurrent: animal.birthDate,
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
            if (animal.acquisition == 'Purchased')
              dateInputButton(context: context,
                  header: 'Purchase Date'.i18n,
                  hint: 'Select Purchase Date'.i18n,
                  icon: CustomIcons.dollar_sign,
                  fieldSetter: setterPurchaseDate,
                  fieldCurrent: animal.purchaseDate,
                  handleReturn: handleReturn,
                  bottomSpace: true),
            inputForm(
                context: context,
                header: 'Dam'.i18n,
                hint: 'Select Dam'.i18n,
                icon: CustomIcons.venus,
                invert: true),
            verticalSpace(context, 0.03),
            inputForm(
                context: context,
                header: 'Sire'.i18n,
                hint: 'Select Sire'.i18n,
                icon: CustomIcons.mars,
                invert: true),
            verticalSpace(context, 0.03),
            textArea(
                context: context,
                header: 'Notes'.i18n,
                hint: 'Enter Additional Notes'.i18n,
                icon: Icons.note,
                invert: true),
            verticalSpace(context, 0.06),
            generalBlueButton(
                context: context,
                text: "Add".i18n,
                function: () {
                  if (saveCheck()) {
                    save(objectTable: Animal.table, object: animal);
                    navigate(context: context,
                        page: Livestock(),
                        direction: 'right',
                        fromDrawer: false,
                        replace: true);
                  }
                }),
            verticalSpace(context, 0.06)
          ],
        ),
      )),
    );
  }

  /// Ensure id, type, and sex are not null
  bool saveCheck() {
    if (animal.identifier != null && animal.animalType != null && animal.sex != null) {
      return true;
    }
    return false;
  }

  /// i.e. if status is not 'pregnant', then clear [animal.dueDate]
  void clearDependentFields() {
    if (animal.currentStatus != 'Pregnant') animal.dueDate = null;
  }

  handleReturn({@required ValueSetter fieldSetter, @required String returnValue}) {
    setState(() {
      if (returnValue != null) fieldSetter(returnValue);
    });
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
