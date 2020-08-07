import 'package:fieldhand/branch/add_animal.dart';
import 'package:fieldhand/computation/navigation.dart';
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
import 'package:fieldhand/computation/transitions.dart';
import 'package:fieldhand/database/globals.dart' as globals;
import 'package:fieldhand/database/database_core.dart';

class Livestock extends StatefulWidget {
  Livestock({Key key}) : super(key: key);

  final String routeName = 'Livestock';

  @override
  _LivestockState createState() => _LivestockState();
}

class _LivestockState extends State<Livestock> {

  List<Animal> _animals = List<Animal>();
  List<Animal> _displayAnimals = List<Animal>();

  @override
  void initState() {
    super.initState();
    getAnimals();
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

  getAnimals() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    _animals = await helper.queryAll();
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
        child: OutlineButton(
          highlightedBorderColor: primaryRed(),
          color: Colors.grey[50],
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

  Widget identifierText({@required int index}) {
    return Marquee(
      direction: Axis.horizontal,
      forwardTimeFactor: 1.5,
      pauseDuration: const Duration(milliseconds: 800),
      child: Text(
        _displayAnimals[index].displayIdentifier,
        style: GoogleFonts.notoSans(
            color: primaryRed(),
            fontSize: displayWidth(context) * 0.053,
            fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
    );
  }

  Widget typeText({@required int index}) {
    return Text(
      '${_displayAnimals[index].sex} ${_displayAnimals[index].animalType}',
      style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.045),
      maxLines: 1,
    );
  }

  Widget statusText({@required int index, double fontSizeFactor = 1.0}) {
    String status = _displayAnimals[index].currentStatus;
    return Text(status,
      style: GoogleFonts.notoSans(
          color: (status == 'Healthy')? Colors.green : (status == 'Ill')? Colors.yellow : (status == 'Pregnant')? Colors.pink : (status == 'Sold')? Colors.blue : Colors.black,
          fontSize: displayWidth(context) * 0.036 * fontSizeFactor,
          fontWeight: FontWeight.bold),
      maxLines: 1,
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
          return DraggableScrollableSheet(
            expand: false,
              builder: (BuildContext context,
                  ScrollController _scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(displayWidth(context) * 0.12))
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(displayWidth(context) * 0.12)),
                      child: Column(
                        children: [
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            buttonPadding: EdgeInsets.zero,
                            children: [
                              sheetButton(text: 'Edit'.i18n, icon: Icons.edit, onPressed: () {}),
                              sheetButton(text: 'Add Task'.i18n, icon: Icons.add_circle_outline, onPressed: () {}),
                              sheetButton(text: 'Close'.i18n, icon: Icons.close, onPressed: () {Navigator.pop(context);}),
                            ],
                          ),
                          verticalSpace(context, 0.05),
                          imageThumbnail(context: context, size: 0.5, color: secondaryRed(), imagePath: _displayAnimals[index].thumbLocation),
                          verticalSpace(context, 0.02),
                          titleText(index: index),
                          verticalSpace(context, 0.03),
                          textDivider(context: context, text: 'Details'.i18n, color: Colors.black38, scaleFactor: 1.2),
                          verticalSpace(context, 0.03),
                          Row(
                            children: [
                              SizedBox(
                                width: displayWidth(context) * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    labelText(text: "Type".i18n),
                                    verticalSpace(context, 0.01),
                                    labelText(text: "Sex".i18n),
                                    verticalSpace(context, 0.01),
                                    labelText(text: "Status".i18n)
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: displayWidth(context) * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _displayAnimals[index].animalType,
                                      style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.045),
                                      maxLines: 1,
                                    ),
                                    verticalSpace(context, 0.01),
                                    Text(
                                      _displayAnimals[index].sex,
                                      style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.045),
                                      maxLines: 1,
                                    ),
                                    verticalSpace(context, 0.01),
                                    statusText(index: index, fontSizeFactor: 1.3),
                                  ],
                                ),
                              )
                            ],
                          ),
                          verticalSpace(context, 0.05),
                          deleteButton(context: context, text: 'Delete'.i18n, function: () {}),
                          verticalSpace(context, 0.05),
                        ],
                      ),
                    ),
                  )
                );
              }
          );
        });
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

  Widget titleText({@required int index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.1),
      child: Text(_displayAnimals[index].displayIdentifier,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSans(color: primaryRed(),
            fontSize: displayWidth(context) * 0.055,
            fontWeight: FontWeight.bold),
        maxLines: 2,),
    );
  }

  Widget labelText({@required String text}) {
    return Text("$text:   ", style: GoogleFonts.notoSans(color: Colors.black26, fontSize: displayWidth(context) * 0.045),);
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: displayWidth(context) * 0.07,),
            horizontalSpace(context, 0.03),
            Text(
              text,
              style: GoogleFonts.notoSans(
                  textStyle: TextStyle(color: Colors.white),
                  fontSize: displayWidth(context) * 0.05,
                  fontWeight: FontWeight.w800,
                  letterSpacing: displayWidth(context) * 0.005),
            )
          ],
        ),
        onPressed: function,
      ),
    );
  }


  void _filterElements(String query) {
    query = query.toUpperCase();
    setState(() {
      _displayAnimals = _animals.where((Animal searchAnimal) => searchAnimal.identifier.toUpperCase().contains(query)).toList();
    });
  }

}
