import "package:i18n_extension/i18n_extension.dart";

extension Localization on String {
  static var _t = Translations("en") +
      {
        "en": "",
        "fr": "",
        "es": "",
        "pt": "",
        "ru": "",
        "de": "",
        "ar": "",
        "hi": "",
        "bn": "",
      } +
      {
        "en": "",
        "fr": "",
        "es": "",
        "pt": "",
        "ru": "",
        "de": "",
        "ar": "",
        "hi": "",
        "bn": "",
      };
  String get i18n => localize(this, _t);
}
