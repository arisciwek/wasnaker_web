import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Localization
|--------------------------------------------------------------------------
| Manage your Flutter application's localization.
|
| Learn more: https://nylo.dev/docs/7.x/localization
|-------------------------------------------------------------------------- */

final class LocalizationConfig {

  /* languageCode
| -------------------------------------------------------------------------
| Define the language code you want to use. E.g. en, es, ar.
| The language code should match the name of the file i.e /lang/es.json
|-------------------------------------------------------------------------- */
  static final String languageCode =
      getEnv('DEFAULT_LOCALE', defaultValue: "en");

  /* localeType
| -------------------------------------------------------------------------
| Define if you want the application to read the locale from the users
| device settings or as you've defined in the [languageCode].
|-------------------------------------------------------------------------- */
  static final LocaleType localeType =
      getEnv('LOCALE_TYPE', defaultValue: 'asDefined') == 'device'
          ? LocaleType.device
          : LocaleType.asDefined;

  /* assetsDirectory
| -------------------------------------------------------------------------
| Asset directory for your languages.
|-------------------------------------------------------------------------- */
  static const String assetsDirectory = 'lang/';

  /* supportedLocales
| -------------------------------------------------------------------------
| List of supported locales in the app. This is used for Flutter's
| MaterialApp.supportedLocales and for locale validation.
|-------------------------------------------------------------------------- */
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    // Add more locales as needed
  ];

  /* fallbackLanguageCode
| -------------------------------------------------------------------------
| Fallback locale when a translation key is not found in the active locale.
|-------------------------------------------------------------------------- */
  static const String fallbackLanguageCode = 'en';

  /* rtlLanguages
| -------------------------------------------------------------------------
| Languages that use right-to-left text direction.
|-------------------------------------------------------------------------- */
  static const List<String> rtlLanguages = ['ar', 'he', 'fa', 'ur'];

  /// Check if a language code uses right-to-left text direction
  static bool isRtl(String languageCode) => rtlLanguages.contains(languageCode);

  /* debugMissingKeys
| -------------------------------------------------------------------------
| When true, logs warnings for missing translation keys.
| Useful for development to catch untranslated strings.
|-------------------------------------------------------------------------- */
  static final bool debugMissingKeys =
      getEnv('DEBUG_TRANSLATIONS', defaultValue: 'false') == 'true';
}
