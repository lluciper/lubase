enum Language {
  vi,
  en,
}

extension LanguageExtension on Language {
  String get value {
    switch (this) {
      case Language.vi:
        return 'vi';
      case Language.en:
        return 'en';
      }
  }
}
