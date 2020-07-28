import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/cupertino.dart';
import 'country_code.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/database/globals.dart' as globals;

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle textStyle;
  final WidgetBuilder emptySearchBuilder;
  final bool showFlag;
  final double flagWidth;
  final Size size;
  final bool hideSearch;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.showFlag,
    this.flagWidth = 32,
    this.size,
    this.hideSearch = false,
  })  : assert(searchDecoration != null, 'searchDecoration must not be null!'),
        this.searchDecoration =
            searchDecoration.copyWith(prefixIcon: Icon(Icons.search, color: Colors.white,)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  List<CountryCode> filteredElements;

  @override
  void dispose() {
    globals.isDialogOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(displayWidth(context) * 0.07))
    ),
        titlePadding: const EdgeInsets.all(0),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.all(0),
              iconSize: displayWidth(context) * 0.05,
              icon: Icon(
                Icons.close,
                color: primaryRed(),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            if (!widget.hideSearch)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.05),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: displayHeight(context) * 0.067,
                  width: displayWidth(context) * 0.75,
                  decoration: roundedShadowDecoration(context: context, color: secondaryRed(), size: 0.015),
                  child: TextField(
                    cursorColor: Colors.white,
                    style: widget.searchStyle,
                    decoration: widget.searchDecoration,
                    onChanged: _filterElements,
                  ),
                ),
              ),
          ],
        ),
        children: [
          Container(
            width: widget.size?.width ?? MediaQuery.of(context).size.width,
            height:
                widget.size?.height ?? MediaQuery.of(context).size.height * 0.7,
            //decoration: roundedShadowDecoration(context: context, color: Colors.white, size: null),
            child: Scrollbar(
              child: ListView(
                children: [
                  widget.favoriteElements.isEmpty
                      ? const DecoratedBox(decoration: BoxDecoration())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.favoriteElements.map(
                              (f) => Center(
                                child: MaterialButton(
                                  child: _buildOption(f),
                                  onPressed: () {
                                    _selectItem(f);
                                  },
                                ),
                              ),
                            ),
                            Divider(color: primaryRed(),),
                          ],
                        ),
                  if (filteredElements.isEmpty)
                    _buildEmptySearchWidget(context)
                  else
                    ...filteredElements.map(
                      (e) => Center(
                        child: MaterialButton(
                          key: Key(e.toLongString()),
                          child: _buildOption(e),
                          onPressed: () {
                            _selectItem(e);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildOption(CountryCode e) {
    return Container(
      width: displayWidth(context) * 0.6,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          if (widget.showFlag)
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(right: displayWidth(context) * 0.04),
                child: Image.asset(
                  e.flagUri,
                  width: widget.flagWidth,
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Text(
              widget.showCountryOnly
                  ? e.toCountryStringOnly()
                  : e.toLongString(),
              overflow: TextOverflow.fade,
              style: widget.textStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }

    return Center(
      child: Text('No country found'),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    globals.isDialogOpen = true;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
