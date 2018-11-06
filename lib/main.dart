import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inkino/redux/app/app_state.dart';
import 'package:inkino/redux/common_actions.dart';
import 'package:inkino/redux/store.dart';
import 'package:inkino/ui/main_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inkino/utils/app_translations_delegate.dart';
import 'package:inkino/utils/application.dart';

Future<Null> main() async {
  // ignore: deprecated_member_use
  //MaterialPageRoute.debugEnableFadingRoutes = true;

  var store = await createStore();
  runApp(InKinoApp(store));
}

class InKinoApp extends StatefulWidget {
  InKinoApp(this.store);
  final Store<AppState> store;

  @override
  _InKinoAppState createState() => _InKinoAppState();
}

class _InKinoAppState extends State<InKinoApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    widget.store.dispatch(InitAction());
    _newLocaleDelegate = const AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        title: 'inKino',
        theme: ThemeData(
          primaryColor: const Color(0xFF1C306D),
          accentColor: const Color(0xFFFFAD32),
        ),
        localizationsDelegates: [
          _newLocaleDelegate,
          const AppTranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: application.supportedLocales(),
        home: const MainPage(),
      ),
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
