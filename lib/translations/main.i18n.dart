import "package:i18n_extension/i18n_extension.dart";

extension Localization on String {
  static var _t = Translations("en") +
      {
        "en": "Hello, how are you?",
        "fr": "Salut, comment ca va?",
        "es": "¿Hola! Cómo estás?",
        "pt": "Olá, como vai você?",
        "ru": "Привет, как ты?",
        "de": "Hallo, wie geht es dir?",
        "ar": "مرحبا كيف حالك؟",
        "hi": "नमस्ते आप कैसे हैं?",
        "bn": "হ্যালো, আপনি কেমন আছেন?",
      } +
      {
        "en": "Select a language",
        "fr": "Sélectionnez une langue",
        "es": "Selecciona un idioma",
        "pt": "Selecione um idioma",
        "ru": "Выбрать язык",
        "de": "Wähle eine Sprache",
        "ar": "اختر لغة",
        "hi": "भाषा चुनें",
        "bn": "একটি ভাষা নির্বাচন করুন",
      } +
      {
        "en": "Language",
        "fr": "Langue",
        "es": "Idioma",
        "pt": "Língua",
        "ru": "язык",
        "de": "Sprache",
        "ar": "لغة",
        "hi": "भाषा",
        "bn": "ভাষা",
      } +
      {
        "en": "Next",
        "fr": "Prochain",
        "es": "Próximo",
        "pt": "Próximo",
        "ru": "следующий",
        "de": "Nächster",
        "ar": "التالى",
        "hi": "आगे",
        "bn": "পরবর্তী",
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
