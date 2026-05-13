import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  static const _key = 'app_locale';
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs) : super(_load(_prefs));

  static Locale _load(SharedPreferences prefs) {
    final code = prefs.getString(_key);
    return Locale(code ?? 'ar');
  }

  Future<void> setLocale(Locale locale) async {
    value = locale;
    await _prefs.setString(_key, locale.languageCode);
  }

  bool get isArabic => value.languageCode == 'ar';
}
