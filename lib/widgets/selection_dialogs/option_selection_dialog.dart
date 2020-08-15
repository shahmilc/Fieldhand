import 'package:fieldhand/database/db_function_bridge.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/extentions/string_extensions.dart';
import 'package:fieldhand/translations/options_dialog.i18n.dart';
import 'package:fieldhand/translations/animal.i18n.dart';

class OptionSelectionDialog extends StatefulWidget {
  final String headerTitle;
  final String objectTable;
  final String objectColumns;
  final String currentSelection;
  final List<String> defaultOptions;
  final bool hideSearch;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final bool sortAlpha;

  OptionSelectionDialog(
      {@required this.headerTitle,
      this.hideSearch,
      this.searchDecoration,
      this.searchStyle,
      this.sortAlpha = false,
      @required this.objectTable,
      @required this.objectColumns,
      @required this.defaultOptions,
      @required this.currentSelection});

  @override
  State<StatefulWidget> createState() => _OptionSelectionDialogState();
}

class _OptionSelectionDialogState extends State<OptionSelectionDialog> {

  ScrollController _controller = ScrollController();
  Set _setElements = Set();
  Map _translatedSetElements = Map();
  List _viewElements = List();
  bool _dataLoaded = false;
  bool _scrollLeft = false;
  String _selected;
  String _custom;
  bool _newOption = false;

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
                    searchBar(),
                    verticalSpace(context, 0.02),
                  ],
                ),
              ),
          ],
        ),
        children: [
          Container(
              padding: EdgeInsets.all(0),
              height: displayHeight(context) * 0.4,
              width: displayWidth(context) * 0.7,
              child: _dataLoaded
                  ? Scrollbar(
                      child: Container(
                        child: ListView.builder(
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == _viewElements.length) return _newTile();
                            return _optionTile(index: index);
                          },
                          itemCount: _viewElements.length + 1,
                        ),
                      ),
                    )
                  : loadingIndicator(context: context)),
          _scrollIndicator(),
          _buttonRow()
        ],
      );

  @override
  void initState() {
    super.initState();
    setState(() {
      _dataLoaded = false;
      _selected = widget.currentSelection;
    });
    _getSet();
    _scrollListen();
  }

  void initialScrollIndicator() {
    setState(() {
      if (_controller.position.maxScrollExtent > 0.0) _scrollLeft = true;
    });
  }

  /// Populates set with default types and unique types from database
  void _getSet() async {
    _setElements = await readColumn(objectTable: widget.objectTable, objectColumn: widget.objectColumns);
    _setElements.addAll(widget.defaultOptions);
    if (widget.currentSelection != null) _setElements.add(widget.currentSelection);
    _viewElements.addAll(_setElements);
    if (widget.sortAlpha) _viewElements.sort();
    _isNew();
    _translateSet();
    setState(() {
      _dataLoaded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => initialScrollIndicator());
  }

  /// Translates all default types to locale language
  void _translateSet() {
    for (int i = 0; i < _setElements.length; i++) {
      String element = _setElements.elementAt(i);
      if (widget.defaultOptions.contains(element)) {
        _translatedSetElements.putIfAbsent(element, () => element.i18n);
      } else {
        _translatedSetElements.putIfAbsent(element, () => element);
      }
    }
  }

  void _isNew() {
    setState(() {
      _newOption = (!_setElements.contains(_selected) && _selected != null);
    });
  }

  /// Filter elements based on search query
  void _filterElements(String query) {
    query = query.toUpperCase();
    setState(() {
      _viewElements = _setElements.where((element) => _translatedSetElements[element].toUpperCase().contains(query)).toList();
    });
  }

  /// Listens to scroll container, shows scroll down indicator if list can still be scrolled
  void _scrollListen() {
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

  Widget _optionTile({@required int index}) {
    String item = _viewElements.elementAt(index);
    return MaterialButton(
      height: displayHeight(context) * 0.07,
      color: _selected == item ? secondaryRed() : Colors.white,
      elevation: 0,
      child: Row(
        children: <Widget>[
          Opacity(
              opacity: 0.0,
              child: Icon(
                Icons.arrow_right,
                size: displayWidth(context) * 0.07,
              )),
          Spacer(),
          Text(item.i18n,
              style: GoogleFonts.notoSans(
                  color: _selected == item ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.normal,
                  fontSize: displayWidth(context) * 0.05)),
          Spacer(),
          AnimatedOpacity(
              opacity: _selected == item ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: displayWidth(context) * 0.07,
              ))
        ],
      ),
      onPressed: () {
        print(item);
        _selected = item;
        _isNew();
      },
    );
  }

  Widget _newTile() {
    return MaterialButton(
      height: displayHeight(context) * 0.07,
      color: _newOption ? secondaryRed() : Colors.white,
      elevation: 0,
      child: Row(
        children: <Widget>[
          Opacity(
              opacity: 0.0,
              child: Icon(
                Icons.arrow_right,
                size: displayWidth(context) * 0.07,
              )),
          Spacer(),
          Container(
            height: displayHeight(context) * 0.067,
            width: displayWidth(context) * 0.55,
            child: TextField(
              onChanged: (value) {
                _selected = value;
                _custom = value;
                _isNew();
              },
              onTap: () {
                if ((_setElements.contains(_selected) || _selected == null) && _custom == null) {
                  _selected = '';
                } else if ((_setElements.contains(_selected) || _selected == null) && _custom != null) {
                  _selected = _custom;
                }
                _isNew();
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              textAlign: TextAlign.center,
              cursorColor: Colors.white,
              style: GoogleFonts.notoSans(
                  color: _newOption ? Colors.white : Colors.black54,
                  fontSize: displayWidth(context) * 0.05),
              decoration: InputDecoration(
                hintText: 'Enter New',
                hintStyle: GoogleFonts.notoSans(
                    color: _newOption ? Colors.white : Colors.black54,
                    fontSize: displayWidth(context) * 0.035),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: _newOption ? Colors.white : primaryRed()),
                ),
              ),
            ),
          ),
          Spacer(),
          AnimatedOpacity(
              opacity: _newOption ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: displayWidth(context) * 0.07,
              ))
        ],
      ),
      onPressed: () {
        _selected = 'new';
        _isNew();
      },
    );
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MaterialButton(
          child: Text(
            "Cancel".i18n,
            style: GoogleFonts.notoSans(
                color: Colors.grey,
                fontSize: displayWidth(context) * 0.04),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text(
            "Select".i18n,
            style: GoogleFonts.notoSans(
                color: (_selected == null || _selected.trim() == '')
                    ? primaryFaded()
                    : primaryRed(),
                fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.04),
          ),
          onPressed: (_selected == null || _selected.trim() == '')
              ? null
              : () {
            Navigator.pop(context, _selected.trim().capitalize());
          },
        ),
      ],
    );
  }

  Widget _scrollIndicator() {
    return Container(
        padding: EdgeInsets.only(top: displayHeight(context) * 0.01),
        height: displayHeight(context) * 0.02,
        child: AnimatedOpacity(
          opacity: _scrollLeft ? 1.0 : 0.0,
          duration: Duration(milliseconds: 250),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: primaryRed(),
          ),
        ));
  }

  Widget searchBar() {
    return Container(
      alignment: Alignment.centerLeft,
      height: displayHeight(context) * 0.067,
      width: displayWidth(context) * 0.75,
      decoration: roundedShadowDecoration(
          context: context, color: secondaryRed(), size: 0.015),
      child: TextField(
        onChanged: (value) => _filterElements(value),
        cursorColor: Colors.white,
        style: widget.searchStyle,
        decoration: widget.searchDecoration,
      ),
    );
  }
}
