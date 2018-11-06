import 'dart:ui';

class Application {

  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  final List<String> supportedLanguagesCodes = [
    "en",
    "fi",
  ];

  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);