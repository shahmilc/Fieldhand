import 'package:fieldhand/database/db_function_bridge.dart';
import 'package:fieldhand/objects/animal.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/marquee.dart';
import 'package:fieldhand/widgets/no_scrollbar.dart';
import 'package:fieldhand/widgets/selection_dialogs/selection_dialog_elements.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';

class LinkSelectionDialog extends StatefulWidget {
  final String headerTitle;
  final String objectType;
  final bool parentSelection;
  final bool sireSelection;
  final String currentSelection;
  final bool hideSearch;
  final bool hideDropdown;
  final bool multi;
  final InputDecoration searchDecoration;
  final String origin;
  final bool excludeOrigin;

  LinkSelectionDialog(
      {@required this.headerTitle,
        @required this.hideSearch,
        @required this.hideDropdown,
        @required this.multi,
        @required this.searchDecoration,
        @required this.objectType,
        @required this.parentSelection,
        @required this.sireSelection,
        @required this.currentSelection,
        @required this.origin,
        @required this.excludeOrigin});

  @override
  State<StatefulWidget> createState() => _LinkSelectionDialogState();
}

class _LinkSelectionDialogState extends State<LinkSelectionDialog> {
  ScrollController _controller = ScrollController();
  Set _tableElements = Set();
  Set _setElements = Set();
  List _viewElements = List();
  Map _typeOptions = Map();
  bool _dataLoaded = false;
  bool _scrollLeft = false;
  String showType;
  String searchQuery = "";
  String _selected;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(displayWidth(context) * 0.07))),
    titlePadding: const EdgeInsets.all(0),
    contentPadding: EdgeInsets.only(bottom: 0),
    title: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        verticalSpace(context, 0.02),
        if (!widget.hideSearch)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: displayWidth(context) * 0.05),
            child: Column(
              children: <Widget>[
                cardHeader(context: context, text: widget.headerTitle),
                verticalSpace(context, 0.02),
                searchBar(context: context, filterFunction: _filterElements, searchDecoration: widget.searchDecoration),
                verticalSpace(context, 0.01),
                if (!widget.hideDropdown) dropdownRow()
              ],
            ),
          )
      ],
    ),
    children: [
      Container(
          padding: EdgeInsets.all(0),
          height: displayHeight(context) * 0.4,
          width: displayWidth(context) * 0.7,
          child: _dataLoaded
              ? Stack(
                children: [
                  noResults(context: context, opaque: _viewElements.isEmpty),
                  mainList(controller: _controller, item: _animalTile, itemCount: _viewElements.length)
                ],
              )
              : loadingIndicator(context: context)),
      scrollIndicator(context: context, scrollLeft: _scrollLeft),
      buttonRow(context: context, selection: _selected, disabled: (_selected == null || _selected.trim() == ''))
    ],
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataLoaded = false;
      _selected = widget.currentSelection;
    });
    _getObjects();
    scrollListen();
  }

  void initialScrollIndicator() {
    setState(() {
      if (_controller.position.maxScrollExtent > 0.0) _scrollLeft = true;
    });
  }

  void _getObjects() async {
    if (widget.parentSelection) {
      showType = widget.objectType;
      String querySex = widget.sireSelection? 'Male' : 'Female';
      _tableElements = await queryType(table: Animal.table);
      if (widget.excludeOrigin) _tableElements.removeWhere((element) => element.serial == widget.origin);
      _setElements = _tableElements.where((element) => element.objectType == showType && element.sex == querySex).toSet();
      _viewElements.addAll(_setElements);
    } else {
      showType = 'All';
      _tableElements = await queryAll();
      if (widget.excludeOrigin) _tableElements.removeWhere((element) => element.serial == widget.origin);
      _setElements.addAll(_tableElements);
      _viewElements.addAll(_setElements);
    }
    _buildTypeList();
    setState(() {
      _dataLoaded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => initialScrollIndicator());
  }

  void _changeMasterSet({@required String newValue}) {
    if (widget.parentSelection) {
      showType = newValue;
      String querySex = widget.sireSelection ? 'Male' : 'Female';
      _setElements = showType == 'All' ?
      _tableElements.where((element) => element.sex == querySex).toSet() :
      _tableElements.where((element) =>
      element.objectType == showType && element.sex == querySex).toSet();
      _viewElements.clear();
      _viewElements.addAll(_setElements);
      _filterElements(searchQuery);
    } else {
      showType = newValue;
      _setElements = showType == 'All'?
      _tableElements.where((element) => '${element.runtimeType}' == showType).toSet() :
      _tableElements;
      _viewElements.clear();
      _viewElements.addAll(_setElements);
      _filterElements(searchQuery);
    }
  }

  void _buildTypeList() async {
    if (!widget.hideDropdown) {
      if (widget.parentSelection) {
        Set rawType = await readColumn(
            objectTable: Animal.table, objectColumn: Animal.typeColumn);
        rawType.add(widget.objectType);
        _typeOptions['All'] = 'All'.i18n;
        for (int i = 0; i < rawType.length; i++) {
          String element = rawType.elementAt(i);
          _typeOptions[element] = element.i18n;
        }
      } else {
        _typeOptions = {
          'All' : 'All'.i18n,
          'Animal': 'Animal'.i18n,
          'Machine': 'Machine'.i18n,
          'Field': 'Field'.i18n,
          'Property': 'Property'.i18n,
          'Staff': 'Staff'.i18n
        };
      }
    }
  }

  void _filterElements(String query) {
    query = query.toUpperCase();
    searchQuery = query;
    setState(() {
      _viewElements = _setElements.where((element) => element.identifier.toUpperCase().contains(query)).toList();
    });
  }

  void scrollListen() {
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == 0.0) {
        if (_scrollLeft == true) {
          setState(() {
            _scrollLeft = false;
          });
        }
      } else if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0 && _scrollLeft == false) {
          setState(() {
            _scrollLeft = true;
          });
        } else if (_controller.position.pixels != 0 && _scrollLeft == true) {
          setState(() {
            _scrollLeft = false;
          });
        }
      } else if (_scrollLeft == false) {
        setState(() {
          _scrollLeft = true;
        });
      }
    });
  }

  Widget _animalTile({@required int index}) {
    var item = _viewElements.elementAt(index);
    bool isAnimal = item.runtimeType == Animal;
    bool isCurrent = _selected == item.serial;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.01, horizontal: displayWidth(context) * 0.02),
        height: displayHeight(context) * 0.1,
        width: displayWidth(context) * 0.9,
        child: OutlineButton(
          highlightedBorderColor: primaryRed(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.025),
          ),
          child: Row(
            children: <Widget>[
              imageThumbnail(context: context, size: 0.15, color: secondaryRed(), imagePath: item.thumbLocation),
              horizontalSpace(context, 0.05),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: displayWidth(context) * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          identifierText(identifier: item.displayIdentifier),
                          isAnimal? animalTypeText(sex: item.sex, typeText: item.objectType) : typeText(typeText: item.objectType)
                        ],
                      ),
                    ),
                    SizedBox(
                      child: AnimatedOpacity(
                          opacity: isCurrent? 1.0 : 0.0,
                          duration: Duration(milliseconds: 150),
                          child: Icon(
                            Icons.check,
                            color: primaryRed(),
                            size: displayWidth(context) * 0.07,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              _selected = item.serial;
            });
            },
        ),
      ),
    );
  }

  Widget identifierText({@required String identifier}) {
    return NoScrollbar(
      child: Marquee(
        direction: Axis.horizontal,
        forwardTimeFactor: 1.5,
        pauseDuration: const Duration(milliseconds: 800),
        child: Text(
          identifier,
          style: GoogleFonts.notoSans(
              color: primaryRed(),
              fontSize: displayWidth(context) * 0.045,
              fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget animalTypeText({@required String sex, @required String typeText}) {
    return Text(
      '$sex $typeText',
      style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.035),
      maxLines: 1,
    );
  }
  
  Widget typeText({@required String typeText}) {
    return Text(
      typeText,
      style: GoogleFonts.notoSans(color: Colors.black45, fontSize: displayWidth(context) * 0.035),
      maxLines: 1,
    );
  }

  Widget dropdownRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Show type ".i18n,
          style: GoogleFonts.notoSans(
            color: Colors.black38,
            fontSize: displayWidth(context) * 0.03,
          ),
        ),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: showType,
            items: _typeOptions.keys.map((element) {
              return DropdownMenuItem<String>(
                child: Text(_typeOptions[element], style: GoogleFonts.notoSans(
                  color: showType == element? primaryRed() : Colors.black38,
                  fontSize: displayWidth(context) * 0.03,
                  fontWeight: showType == element? FontWeight.bold : FontWeight.normal),),
              value: element,
            );}).toList(),
            onChanged: (value) => _changeMasterSet(newValue: value),
          ),
        )
      ],
    );
  }
}
