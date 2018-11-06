import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inkino/assets.dart';
import 'package:inkino/utils/app_translations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inkino/utils/application.dart';

class InKinoDrawerHeader extends StatefulWidget {
  const InKinoDrawerHeader();

  @override
  _InKinoDrawerHeaderState createState() => _InKinoDrawerHeaderState();
}

class _InKinoDrawerHeaderState extends State<InKinoDrawerHeader> {
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  static bool englishSelected = false;
  static bool finnishSelected = false;
  static const String flutterUrl = 'https://flutter.io/';
  static const String githubUrl = 'https://github.com/roughike/inKino';
  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  TapGestureRecognizer _flutterTapRecognizer;
  TapGestureRecognizer _githubTapRecognizer;

  @override
  void initState() {
    super.initState();
    _flutterTapRecognizer = TapGestureRecognizer()
      ..onTap = () => _openUrl(flutterUrl);
    _githubTapRecognizer = TapGestureRecognizer()
      ..onTap = () => _openUrl(githubUrl);
    if (!finnishSelected) {
      englishSelected = true;
    }
  }

  @override
  void dispose() {
    _flutterTapRecognizer.dispose();
    _githubTapRecognizer.dispose();
    super.dispose();
  }

  void _openUrl(String url) async {
    // Close the about dialog.
    Navigator.pop(context);

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget _buildAppNameAndVersion(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'inKino',
            style: textTheme.display1.copyWith(color: Colors.white70),
          ),
          Text(
            'v1.0.1', // TODO: figure out a way to get this dynamically
            style: textTheme.body2.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutButton(BuildContext context) {
    var content = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Icon(
          Icons.info_outline,
          color: Colors.white70,
          size: 18.0,
        ),
        const SizedBox(width: 8.0),
        Text(
          AppTranslations.of(context).text("about_button_title"),
          textAlign: TextAlign.end,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.0,
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) => _buildAboutDialog(context),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
    );
  }

  Widget _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      title: Text(AppTranslations.of(context).text("about_dialog_title")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
          const SizedBox(height: 16.0),
          _buildTMDBAttribution(),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(AppTranslations.of(context).text("about_dialog_confirm")),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return RichText(
      text: TextSpan(
        text: AppTranslations.of(context).text("about_text"),
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          TextSpan(text: AppTranslations.of(context).text("about_text_1")),
          TextSpan(
            text: 'Flutter',
            recognizer: _flutterTapRecognizer,
            style: linkStyle,
          ),
          TextSpan(
            text: AppTranslations.of(context).text("about_text_2")
          ),
          TextSpan(
            text: AppTranslations.of(context).text("about_text_3"),
            recognizer: _githubTapRecognizer,
            style: linkStyle,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _buildTMDBAttribution() {
    return Row(
      children: <Widget>[
        Image.asset(
          ImageAssets.poweredByTMDBLogo,
          width: 32.0,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            AppTranslations.of(context).text("about_tmdb"),
            style: const TextStyle(fontSize: 12.0),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageButtons(BuildContext context) {
    var isEnglishSelected = englishSelected ?
        const Text(
          'EN',
          textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold)
    ) : const Text(
          'EN',
          textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.0,
              fontWeight: FontWeight.normal),
        );

    var isFinnishSelected = finnishSelected ?
        const Text(
            'FI',
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold)
        ) : const Text(
          'FI',
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.0,
            fontWeight: FontWeight.normal),
          );

    var content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            application.onLocaleChanged(Locale(languageCodesList[0]));
            englishSelected = true;
            finnishSelected = false;
          },
          child: isEnglishSelected,
        ),
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () {
            application.onLocaleChanged(Locale(languageCodesList[1]));
            finnishSelected = true;
            englishSelected = false;
          },
          child: isFinnishSelected,
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      constraints: const BoxConstraints.expand(height: 175.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _buildAppNameAndVersion(context),
          _buildAboutButton(context),
          _buildLanguageButtons(context)
        ],
      ),
    );
  }
}
