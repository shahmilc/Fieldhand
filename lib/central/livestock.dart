import 'package:fieldhand/branch/animal_entry.dart';
import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/database/db_function_bridge.dart';
import 'package:fieldhand/objects/animal.dart';
import 'package:fieldhand/widgets/central_sliver_app_bar.dart';
import 'package:fieldhand/widgets/drawer.dart';
import 'package:fieldhand/widgets/marquee.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/translations/dashboard.i18n.dart';

class Livestock extends StatefulWidget {
  Livestock({Key key}) : super(key: key);

  final String routeName = 'Livestock';

  @override
  _LivestockState createState() => _LivestockState();
}

class _LivestockState extends State<Livestock> {

  bool dataLoaded = false;
  Set _animals = Set();
  List _displayAnimals = List();
  Map _animalStatuses = Map();


  @override
  void initState() {
    super.initState();
    setup();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
          drawer: SideDrawer(),
          body: CustomScrollView(
            slivers: <Widget>[
              CentralSliverAppBar(headerText: 'Livestock'.i18n, onSearch: (value) => _filterElements(value)),
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                      (context, index) => _animalTile(index: index),
                  // Builds 1000 ListTiles
                  childCount: _displayAnimals.length,
                ),
              )
            ],
          )),
    );
  }

  void setup() {
    setState(() {
      dataLoaded = false;
    });
    getAnimals();
    getStatuses();
    setState(() {
      dataLoaded = true;
    });
  }

  void getStatuses() async {
    var statuses = await readColumn(objectTable: Animal.table, objectColumn: Animal.statusColumn);
    statuses.addAll(Animal.defaultStatuses);
    for (int i = 0; i < statuses.length; i++) {
      String element = statuses.elementAt(i);
      if (Animal.defaultStatuses.contains(element)) {
        _animalStatuses.putIfAbsent(element, () => element.i18n);
      } else {
        _animalStatuses.putIfAbsent(element, () => element);
      }
    }
  }

  getAnimals() async {
    _animals = await queryAll(table: Animal.table);
    setState(() {
      _displayAnimals.addAll(_animals);
    });
  }
  _animalTile({@required int index}) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.01),
        height: displayHeight(context) * 0.15,
        width: displayWidth(context) * 0.9,
        child: RaisedButton(
          //highlightedBorderColor: primaryRed(),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.025),
          ),
          child: Row(
            children: <Widget>[
              imageThumbnail(context: context, size: 0.22, color: secondaryRed(), imagePath: _displayAnimals[index].thumbLocation),
              horizontalSpace(context, 0.05),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: displayWidth(context) * 0.34,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          identifierText(index: index),
                          typeText(index: index)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          statusText(index: index),
                          tasksText(index: index)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPressed: () {_showSheet(index: index);},
        ),
      ),
    );
  }

  _miniAnimalTile({@required int index}) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.01),
        height: displayHeight(context) * 0.1,
        width: displayWidth(context) * 0.9,
        child: OutlineButton(
          highlightedBorderColor: primaryRed(),
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.025),
          ),
          child: Row(
            children: <Widget>[
              imageThumbnail(context: context, size: 0.15, color: secondaryRed(), imagePath: _displayAnimals[index].thumbLocation),
              horizontalSpace(context, 0.05),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        identifierText(index: index),
                        typeText(index: index)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPressed: () {_showSheet(index: index);},
        ),
      ),
    );
  }

  Widget identifierText({@required int index}) {
    return Marquee(
      direction: Axis.horizontal,
      forwardTimeFactor: 1.5,
      pauseDuration: const Duration(milliseconds: 800),
      child: Text(
        _displayAnimals[index].displayIdentifier,
        style: GoogleFonts.notoSans(
            color: primaryRed(),
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
    );
  }

  Widget typeText({@required int index}) {
    return Text(
      '${_displayAnimals[index].sex} ${_displayAnimals[index].objectType}',
      style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.04),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget statusText({@required int index, double fontSizeFactor = 1.0}) {
    String status = _displayAnimals[index].currentStatus;
    return Text(status,
      style: GoogleFonts.notoSans(
          color: (status == 'Healthy')? Colors.green : (status == 'Ill')? Colors.yellow : (status == 'Pregnant')? Colors.pink : (status == 'Sold')? Colors.blue : (status == 'Deceased')? Colors.black : Colors.grey,
          fontSize: displayWidth(context) * 0.036 * fontSizeFactor,
          fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget tasksText({@required int index}) {
    return Text('0 Tasks', maxLines: 1);
  }

  void _showSheet({@required int index}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true, // set this to true
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setSheetState /*You can rename this!*/) {
      return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context,
              ScrollController _scrollController) {
            return Container(
                decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(displayWidth(context) * 0.12))
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(displayWidth(context) * 0.12)),
                    child: Column(
                      children: [
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          buttonPadding: EdgeInsets.zero,
                          children: [
                            sheetButton(text: 'Edit'.i18n,
                                icon: Icons.edit,
                                onPressed: () {
                                  navigate(context: context,
                                      page: AnimalEntry(edit: true,
                                          animal: _displayAnimals[index]),
                                      direction: 'right',
                                      fromDrawer: false);
                                }),
                            sheetButton(text: 'Add Task'.i18n,
                                icon: Icons.add_circle_outline,
                                onPressed: () {}),
                            sheetButton(text: 'Close'.i18n,
                                icon: Icons.close,
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                        verticalSpace(context, 0.03),
                        imageThumbnail(context: context,
                            size: 0.5,
                            color: secondaryRed(),
                            imagePath: _displayAnimals[index].thumbLocation),
                        verticalSpace(context, 0.02),
                        sheetTitleText(index: index),
                        verticalSpace(context, 0.01),
                        statusDropdown(index: index, onChanged: (value) => setSheetState((){_displayAnimals[index].currentStatus = value; setState(() {});})),
                        verticalSpace(context, 0.03),
                        textDivider(context: context,
                            text: 'Details'.i18n,
                            color: Colors.black38,
                            scaleFactor: 1.2),
                        verticalSpace(context, 0.02),
                        sheetInformationRow(index: index,
                            label: 'Type'.i18n,
                            data: _displayAnimals[index].objectType),
                        sheetInformationRow(index: index,
                            label: 'Sex'.i18n,
                            data: _displayAnimals[index].sex),
                        sheetInformationRow(index: index,
                            label: 'Birth Date'.i18n,
                            data: convertDate(_displayAnimals[index].birthDate)),
                        sheetInformationRow(index: index,
                            label: 'Death Date'.i18n,
                            data: convertDate(_displayAnimals[index].deathDate)),
                        sheetInformationRow(index: index,
                            label: 'Sold Date'.i18n,
                            data: convertDate(_displayAnimals[index].soldDate)),
                        /**sheetInformationRow(index: index,
                            label: 'Due Date'.i18n,
                            data: convertDate(_displayAnimals[index].dueDate)),**/
                        sheetInformationRow(index: index,
                            label: 'Acquisition'.i18n,
                            data: _displayAnimals[index].acquisition),
                        sheetInformationRow(index: index,
                            label: 'Purchase Date'.i18n,
                            data: convertDate(_displayAnimals[index].purchaseDate)),
                        verticalSpace(context, 0.02),
                        textDivider(context: context,
                            text: 'Pedigree'.i18n,
                            color: Colors.black38,
                            scaleFactor: 1.2,
                            enabled: (_displayAnimals[index].sire != null || _displayAnimals[index].dam != null || _displayAnimals[index].breed != null || hasOffspring(serial: _displayAnimals[index].serial)),
                            padding: true),
                        sheetInformationRow(index: index,
                            label: 'Breed'.i18n,
                            data: _displayAnimals[index].breed),
                        linkSingle(index: index, label: 'Dam', serial: _displayAnimals[index].dam),
                        linkSingle(index: index, label: 'Sire', serial: _displayAnimals[index].sire),
                        linkMultiple(index: index, label: 'Offspring'),
                        verticalSpace(context, 0.05),
                        deleteButton(context: context,
                            text: 'Delete'.i18n,
                            function: () {}),
                        verticalSpace(context, 0.05),
                      ],
                    ),
                  ),
                )
            );
          }
      );
    });
        });
  }

  Widget statusDropdown({@required int index, @required Function onChanged}) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<String>(
        value: _displayAnimals[index].currentStatus,
        items: _animalStatuses.keys.map((element) {
          return DropdownMenuItem<String>(
            child: Text(_animalStatuses[element], style: GoogleFonts.notoSans(
                color: (_animalStatuses[element] == 'Healthy')? Colors.green : (_animalStatuses[element] == 'Ill')? Colors.yellow : (_animalStatuses[element] == 'Pregnant')? Colors.pink : (_animalStatuses[element] == 'Sold')? Colors.blue : (_animalStatuses[element] == 'Deceased')? Colors.black : Colors.grey,
                fontSize: displayWidth(context) * 0.035,
                fontWeight: element == _displayAnimals[index].currentStatus? FontWeight.bold : FontWeight.normal),),
            value: element,
          );}).toList(),
        onChanged: onChanged
      ),
    );
  }

  Widget sheetInformationRow({@required int index, @required String label, @required String data, bool showStatus = false}) {
    return data != null? Padding(
      padding: EdgeInsets.only(top: displayHeight(context) * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: displayWidth(context) * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("$label:   ", style: GoogleFonts.notoSans(color: Colors.black26, fontSize: displayWidth(context) * 0.044),),
              ],
            ),
          ),
          Flexible(
            child: SizedBox(
              width: displayWidth(context) * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?? 'None',
                    style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.042),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ) : Container();
  }
  
  Widget linkSingle({@required int index, @required String label, @required String serial}) {
    return serial != null? Padding(
      padding: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.notoSans(color: Colors.black26, fontSize: displayWidth(context) * 0.044)),
          _miniAnimalTile(index: _displayAnimals.indexWhere((element) => element.serial == serial))
        ],
      ),
    ) : Container();
  }

  Widget linkMultiple({@required int index, @required String label}) {
    List<Widget> links = List<Widget>();
    _displayAnimals.where((element) => (element.sire == _displayAnimals[index].serial) || (element.dam == _displayAnimals[index].serial)).toList().forEach((element) => links.add(_miniAnimalTile(index: _displayAnimals.indexOf(element))));
    return links.isNotEmpty? Padding(
      padding: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: links.length <= 5,
          trailing: Padding(
            padding: EdgeInsets.only(right: displayWidth(context) * 0.1),
            child: Icon(Icons.keyboard_arrow_down),
          ),
          tilePadding: EdgeInsets.only(left: displayWidth(context) * 0.2),
          title: Center(child: Text(label, style: GoogleFonts.notoSans(color: Colors.black26, fontSize: displayWidth(context) * 0.044))),
            children: links
        ),
      ),
    ) : Container();
  }

  bool hasOffspring({@required String serial}) {
    return _displayAnimals.firstWhere((element) => element.dam == serial || element.sire == serial, orElse: () => null) != null;
  }

  Widget sheetButton({@required String text, @required IconData icon, @required Function onPressed}) {
    return SizedBox(
      width: displayWidth(context) / 3,
      height: displayHeight(context) * 0.09,
      child: FlatButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: secondaryRed(), size: displayWidth(context) * 0.06,),
            Text(text, style: GoogleFonts.notoSans(color: secondaryRed(), fontSize: displayWidth(context) * 0.032, fontWeight: FontWeight.bold),)
          ],
        ),
        onPressed: onPressed,
        splashColor: Colors.black12,
      ),
    );
  }

  Widget sheetTitleText({@required int index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.1),
      child: Text(_displayAnimals[index].displayIdentifier,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(color: primaryRed(),
            fontSize: displayWidth(context) * 0.06,
            fontWeight: FontWeight.bold),
        maxLines: 2,),
    );
  }

  Widget deleteButton({@required BuildContext context, @required String text, void Function() function}) {
    return Container(
      width: displayWidth(context) * 0.75,
      height: displayHeight(context) * 0.07,
      child: RaisedButton(
        elevation: 5,
        color: primaryRed(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.015),
        ),
        child: Text(
          text,
          style: GoogleFonts.notoSans(
              textStyle: TextStyle(color: Colors.white),
              fontSize: displayWidth(context) * 0.05,
              fontWeight: FontWeight.w800,
              letterSpacing: displayWidth(context) * 0.005),
        ),
        onPressed: function,
      ),
    );
  }


  void _filterElements(String query) {
    query = query.toUpperCase();
    setState(() {
      _displayAnimals = _animals.where((searchAnimal) => searchAnimal.identifier.toUpperCase().contains(query)).toList();
    });
  }

}
