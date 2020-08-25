import 'package:fieldhand/central/livestock.dart';
import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/database/database_core.dart';
import 'package:fieldhand/database/db_function_bridge.dart';
import 'package:fieldhand/widgets/add_object_elements.dart';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/selection_dialogs/link_selection_dialog.dart';
import 'package:fieldhand/widgets/selection_dialogs/selection_dialog_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/objects/animal.dart';
import 'package:google_fonts/google_fonts.dart';


class AnimalEntry extends StatefulWidget {

  AnimalEntry({@required this.edit, this.animal});

  final String routeName = 'AnimalEntry';
  final bool edit;
  final Animal animal;

  @override
  _AnimalEntryState createState() => _AnimalEntryState();
}

class _AnimalEntryState extends State<AnimalEntry> {
  String originalId;
  Animal animal;
  Map links = Map<String, String>();

  bool saveSafe = false;
  String saveError;

  TextEditingController identifierController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  /// Setter wrapper functions for options fields
  ValueSetter setterAnimalType, setterSex, setterAcquisition, setterStatus, setterBreed;

  /// Setter wrapper function for image selection
  ValueSetter setterThumbnail;

  /// Setter wrapper functions for date fields
  ValueSetter setterBirthDate, setterDeathDate, setterPurchaseDate, setterSoldDate, setterDueDate;

  // Setter wrapper functions for links
  ValueSetter setterDam, setterSire;

  void initializeWrapperFunctions() {

    /// Setter wrapper functions for options fields
    setterAnimalType = (selection) {
      /// If selected type is a default type, and selected image is a default image, set type to corresponding image
      if (Animal.defaultTypes.contains(selection) && Animal.imgList.contains(animal.thumbLocation)) {
        String matchingImagePath = Animal.imgList.where((String imagePath) => getImageName(imagePath) == selection).first;
        setterThumbnail(matchingImagePath);
      }
      setState(() {animal.setObjectType = selection;});
    };

    setterSex = (selection) => setState((){animal.setSex = selection;});
    setterAcquisition = (selection) => setState((){animal.setAcquisition = selection;});
    setterStatus = (selection) => setState((){animal.setStatus = selection;});
    setterBreed = (selection) => setState((){animal.setBreed = selection;});

    /// Setter wrapper function for image selection
    setterThumbnail = (imagePath) => setState((){animal.setThumbnail = imagePath;});

    /// Setter wrapper functions for date fields
    setterBirthDate = (date) => setState((){animal.setBirthDate = date;});
    setterDeathDate = (date) => setState((){animal.setDeathDate = date;});
    setterPurchaseDate = (date) => setState((){animal.setPurchaseDate = date;});
    setterSoldDate = (date) => setState((){animal.soldDate = date;});
    setterDueDate = (date) => setState((){animal.dueDate = date;});

    /// Setter wrapper functions for links
    setterDam = (selection) {
      animal.setDam = selection;
      findLinks();
    };
    setterSire = (selection) {
      animal.setSire = selection;
      findLinks();
    };
  }

  void findLinks() async {
    if (animal.sire != null) {
      links['sireId'] = (await querySerial(table: Animal.table, serial: animal.sire)).displayIdentifier;
    }
    if (animal.dam != null) {
      links['damId'] = (await querySerial(table: Animal.table, serial: animal.dam)).displayIdentifier;
    }
    setState(() {});
  }

  @override
  void dispose() {
    animal = null;
    identifierController?.dispose();
    notesController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    originalId = widget.animal?.identifier;
    animal = widget.animal != null? Animal.fromMap(widget.animal.toMap()) : Animal();
    if (animal.displayIdentifier != null) identifierController.text = animal.displayIdentifier;
    if (animal.notes != null) notesController.text = animal.notes;
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
        header: widget.edit? 'Edit Animal'.i18n : 'Add Animal'.i18n,
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
              readBytes: true),
            verticalSpace(context, 0.03),
            inputForm(
                context: context,
                editingController: identifierController,
                header: 'Name / ID (required)'.i18n,
                hint: 'Enter Name / Identifier'.i18n,
                icon: Icons.create,
                onChanged: (value) {
                  animal.displayIdentifier = value;
                  animal.identifier = value.toLowerCase();
                  saveCheck();
                },
                invert: true),
            verticalSpace(context, 0.03),
            optionInputButton(
                context: context,
                header: 'Type (required)'.i18n,
                hint: 'Select Type'.i18n,
                icon: CustomIcons.horse_head,
                objectTable: Animal.table,
                objectColumn: Animal.typeColumn,
                fieldSetter: setterAnimalType,
                fieldCurrent: animal.objectType,
                defaultValues: Animal.defaultTypes,
                sortAlpha: true),
            verticalSpace(context, 0.03),
            optionInputButton(
                context: context,
                header: 'Sex (required)'.i18n,
                hint: 'Select Sex'.i18n,
                icon: CustomIcons.venus_mars,
                objectTable: Animal.table,
                objectColumn: Animal.sexColumn,
                fieldSetter: setterSex,
                fieldCurrent: animal.sex,
                defaultValues: Animal.defaultSexes),
            verticalSpace(context, 0.03),
            optionInputButton(
                context: context,
                header: 'Status (required)'.i18n,
                hint: 'Select Status'.i18n,
                icon: Icons.thumbs_up_down,
                objectTable: Animal.table,
                objectColumn: Animal.statusColumn,
                fieldSetter: setterStatus,
                fieldCurrent: animal.currentStatus,
                defaultValues: Animal.defaultStatuses),
            verticalSpace(context, 0.03),
            if (animal.currentStatus == 'Deceased')
              dateInputButton(context: context,
                  header: 'Death Date'.i18n,
                  hint: 'Select Death Date'.i18n,
                  icon: CustomIcons.skull,
                  fieldSetter: setterDeathDate,
                  fieldCurrent: animal.deathDate,
                  bottomSpace: true),
            /**if (animal.currentStatus == 'Pregnant')
              dateInputButton(context: context,
                  header: 'Due Date'.i18n,
                  hint: 'Select Due Date'.i18n,
                  icon: Icons.today,
                  fieldSetter: setterDueDate,
                  fieldCurrent: animal.dueDate,
                  handleReturn: handleReturn,
                  bottomSpace: true),**/
            if (animal.currentStatus == 'Sold')
              dateInputButton(context: context,
                  header: 'Sold Date'.i18n,
                  hint: 'Select Sold Date'.i18n,
                  icon: CustomIcons.file_invoice_dollar,
                  fieldSetter: setterSoldDate,
                  fieldCurrent: animal.soldDate,
                  bottomSpace: true),
            dateInputButton(context: context,
                header: 'Birth Date'.i18n,
                hint: 'Select Birth Date'.i18n,
                icon: CustomIcons.birthday_cake,
                fieldSetter: setterBirthDate,
                fieldCurrent: animal.birthDate),
            verticalSpace(context, 0.03),
            optionInputButton(
                context: context,
                header: 'Acquisition'.i18n,
                hint: 'Select Method'.i18n,
                icon: Icons.transit_enterexit,
                objectTable: Animal.table,
                objectColumn: Animal.acquisitionColumn,
                fieldSetter: setterAcquisition,
                fieldCurrent: animal.acquisition,
                defaultValues: Animal.defaultAcquisitions),
            verticalSpace(context, 0.03),
            if (animal.acquisition == 'Purchased')
              dateInputButton(context: context,
                  header: 'Purchase Date'.i18n,
                  hint: 'Select Purchase Date'.i18n,
                  icon: CustomIcons.dollar_sign,
                  fieldSetter: setterPurchaseDate,
                  fieldCurrent: animal.purchaseDate,
                  bottomSpace: true),
            optionInputButton(
                context: context,
                header: 'Breed'.i18n,
                hint: 'Select Breed'.i18n,
                icon: CustomIcons.pets,
                objectTable: Animal.table,
                objectColumn: Animal.breedColumn,
                fieldSetter: setterStatus,
                fieldCurrent: animal.breed,
                defaultValues: null),
            verticalSpace(context, 0.03),
            linkInputButton(
                context: context,
                header: 'Dam'.i18n,
                hint: 'Select Dam'.i18n,
                icon: CustomIcons.venus,
                objectType: animal.objectType,
                parentSelection: true,
                sireSelection: false,
                fieldSetter: setterDam,
                fieldCurrent: animal.dam,
                currentId: links['damId'],
                disabled: animal.objectType == null,
                disabledText: 'Type required'.i18n),
            verticalSpace(context, 0.03),
            linkInputButton(
                context: context,
                header: 'Sire'.i18n,
                hint: 'Select Sire',
                icon: CustomIcons.mars,
                objectType: animal.objectType,
                parentSelection: true,
                sireSelection: true,
                fieldSetter: setterSire,
                fieldCurrent: animal.sire,
                currentId: links['sireId'],
                disabled: animal.objectType == null,
                disabledText: 'Type required'.i18n),
            verticalSpace(context, 0.03),
            textArea(
                editingController: notesController,
                context: context,
                header: 'Notes'.i18n,
                hint: 'Enter Additional Notes'.i18n,
                icon: Icons.note,
                invert: true,
                onChanged: (value) => animal.notes = value),
            verticalSpace(context, 0.06),
            generalBlueButton(
                context: context,
                text: widget.edit? "Save".i18n : "Add".i18n,
                disabled: !saveSafe,
                function: () {
                  if (saveSafe) {
                    clearDependentFields();
                    if (widget.edit == false) {
                      save(objectTable: Animal.table, object: animal);
                    } else {
                      update(objectTable: Animal.table, object: animal);
                    }
                    navigate(context: context,
                        page: Livestock(),
                        direction: 'right',
                        fromDrawer: false,
                        replace: true);
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

  /// Ensure id, type, and sex are not null, and that the id doesn't already exist
  void saveCheck() async {
    if (animal.identifier != null && animal.identifier.trim() != '' && animal.objectType != null && animal.sex != null && animal.currentStatus != null) {
      if (animal.identifier != originalId && await checkId(id: animal.identifier, table: Animal.table)) {
        setState(() {
          saveSafe = false;
          saveError = "${identifierController.text} already exists";
        });
      } else {
        setState(() {
          saveSafe = true;
          saveError = "";
        });
      }
    } else {
      setState(() {
        saveSafe = false;
        saveError = "Please fill required fields".i18n;
      });
    }
  }

  /// i.e. if status is not 'pregnant', then clear [animal.dueDate]
  void clearDependentFields() {
    if (animal.currentStatus != 'Pregnant') animal.dueDate = null;
    if (animal.currentStatus != 'Deceased') animal.deathDate = null;
    if (animal.currentStatus != 'Sold') animal.soldDate = null;
    if (animal.acquisition != 'Purchased') animal.purchaseDate = null;
  }
  
}
