import 'package:fieldhand/computation/screen_router.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/start_up/farm/farm_selection.dart';
import 'package:fieldhand/start_up/language_selection.dart';
import 'package:fieldhand/start_up/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Fieldhand());
}

class Fieldhand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(accentColor: secondaryRed()),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // English
          const Locale('fr'), // French
          const Locale('es'), // Spanish
          const Locale('pt'), // Portuguese
          const Locale('ru'), // Russian
          const Locale('de'), // German
          const Locale('ar'), // Arabic
          const Locale('hi'), // Hindi
          const Locale('bn'), // Bengali
        ],
        home: I18n(
          // Usually you should not provide an initialLocale,
          // and just let it use the system locale.
          // initialLocale: Locale("pt", "BR"),
          //
          child: LoadingScreen(),
        ),
      );
}