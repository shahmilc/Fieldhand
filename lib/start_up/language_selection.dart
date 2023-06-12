import 'package:fieldhand/database/local_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:fieldhand/translations/main.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/start_up/login.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/computation/navigation.dart';

class LanguageSelection extends StatefulWidget {
  LanguageSelection({Key key}) : super(key: key);

  final String routeName = "main";

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  Map<String, String> locales = {
    'English': 'en',
    'Français': 'fr',
    'Español': 'es',
    'Português': 'pt',
    'pусский': 'ru',
    'Deutsche': 'de',
    'عربى': 'ar',
    'हिन्दी': 'hi',
    'বাংলা': 'bn'
  };
  Map<String, String> initialLocales = {
    'en': 'English',
    'fr': 'Français',
    'es': 'Español',
    'pt': 'Português',
    'ru': 'pусский',
    'de': 'Deutsche',
    'ar': 'عربى',
    'hi': 'हिन्दी',
    'bn': 'বাংলা',
  };
  String _selectedLanguage;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    setInitialLocale();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
        backgroundColor: primaryRed(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: displayWidth(context) * 0.85,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(displayWidth(context) * 0.08),
                  ),
                  child: Wrap(
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            verticalSpace(context, 0.02),
                            headerText(
                                context: context,
                                text: "Select a language".i18n),
                            Container(
                              color: Colors.transparent,
                              height: displayHeight(context) * 0.6,
                              width: displayWidth(context) * 0.7,
                              child: Column(
                                children: <Widget>[
                                  verticalSpace(context, 0.03),
                                  Expanded(
                                    child: ListView(
                                      padding: EdgeInsets.all(0),
                                      children: <Widget>[
                                        languageButton('English'),
                                        languageButton('Français'),
                                        languageButton('Español'),
                                        languageButton('Português'),
                                        languageButton('pусский'),
                                        languageButton('Deutsche'),
                                        languageButton('عربى'),
                                        languageButton('हिन्दी'),
                                        languageButton('বাংলা'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      height: displayHeight(context) * 0.03,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: primaryRed(),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(context, 0.02),
              generalBlueButton(
                  context: context,
                  text: "Next".i18n,
                  function: () {
                    storeData(key: 'welcomed', value: true);
                    navigate(
                        context: context,
                        page: Login(),
                        direction: 'right',
                        fromDrawer: false);
                  })
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  changeLanguage(String newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
      I18n.of(context).locale = Locale(locales[_selectedLanguage]);
    });
  }

  setInitialLocale() {
    String systemLocale = I18n.locale.toString();
    if (!initialLocales.containsKey(systemLocale)) systemLocale = 'en';
    _selectedLanguage = initialLocales[systemLocale];
    Future.delayed(Duration.zero, () {
      I18n.of(context).locale = Locale(locales[_selectedLanguage]);
    });
  }

  Widget languageButton(String language) {
    return Container(
      width: displayWidth(context) * 0.7,
      height: displayWidth(context) * 0.12,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: _selectedLanguage == language ?
            MaterialStateProperty.all<Color>(Colors.white) : MaterialStateProperty.all<Color>(secondaryRed()),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(side: BorderSide(color: Color(0xFFFF6159))))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
                opacity: 0.0,
                child: Icon(
                  Icons.arrow_right,
                  size: displayWidth(context) * 0.07,
                )),
            Spacer(),
            Text(
              language,
              style: GoogleFonts.notoSans(
                  textStyle: TextStyle(
                      color: _selectedLanguage == language
                          ? primaryRed()
                          : Colors.white),
                  fontSize: displayWidth(context) * 0.05,
                  fontWeight: FontWeight.w800),
            ),
            Spacer(),
            AnimatedOpacity(
                opacity: _selectedLanguage == language ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                child: Icon(
                  Icons.check,
                  color: primaryRed(),
                  size: displayWidth(context) * 0.07,
                ))
          ],
        ),
        onPressed: () {
          changeLanguage(language);
        },
      ),
    );
  }
}
