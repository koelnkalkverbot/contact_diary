import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static const String PREF_AUTO_DELETE_DATA = 'autoDeleteDate';
  static const String PREF_REMINDER = 'reminder';

  static Future<SharedPreferences> instance() async {
    return SharedPreferences.getInstance();
  }

  static Future<void> setAutoDeleteDataEnabled(bool value) async {
    final prefs = await PrefsHelper.instance();
    prefs.setBool(PREF_AUTO_DELETE_DATA, value);
  }

  static Future<bool> isAutoDeleteDataEnabled() async {
    final prefs = await PrefsHelper.instance();
    return prefs.getBool(
          PREF_AUTO_DELETE_DATA,
        ) ??
        false;
  }

  static Future<void> setReminderEnabled(bool value) async {
    final prefs = await PrefsHelper.instance();
    prefs.setBool(PREF_REMINDER, value);
  }

  static Future<bool> isReminderEnabled() async {
    final prefs = await PrefsHelper.instance();
    return prefs.getBool(
          PREF_REMINDER,
        ) ??
        false;
  }

  static Future<void> setReminderTime(String time) async {
    final prefs = await PrefsHelper.instance();
    prefs.setString(PREF_REMINDER, time);
  }

  static Future<String> getReminderTime() async {
    final prefs = await PrefsHelper.instance();
    return prefs.getString(
          PREF_REMINDER,
        ) ??
        '20:00';
  }
}
