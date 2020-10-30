import 'package:contact_diary/helpers/prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatefulWidget {
  static const ROUTE_NAME = 'settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoDelete = false;
  bool _dailyReminder = false;
  String _alarmTime = '19:00';
  String _appVersion = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _loadSettings(),
        builder: (ctx, snapshot) => ListView(
          children: [
            SwitchListTile(
              title:
                  const Text('Einträge älter als 14 Tage automatisch löschen'),
              secondary: const Icon(Icons.delete_sweep),
              value: _autoDelete,
              onChanged: (bool value) {
                setState(() {
                  _autoDelete = value;
                  PrefsHelper.setAutoDeleteDataEnabled(value);
                });
              },
            ),
            Divider(
              height: 2,
            ),
            /*SwitchListTile(
              title: const Text('Tägliche erinnerung'),
              secondary: const Icon(Icons.alarm),
              value: _dailyReminder,
              onChanged: (bool value) {
                setState(() {
                  _dailyReminder = value;
                  PrefsHelper.setReminderEnabled(value);
                });
              },
            ),Divider(
              height: 2,
            )*/
            if (_dailyReminder)
              ListTile(
                leading: Icon(Icons.edit),
                onTap: () {
                  DatePicker.showTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      final formattedTimeString =
                          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                      _alarmTime = formattedTimeString;
                      PrefsHelper.setReminderTime(
                          '${date.hour}:${date.minute}');
                    });
                  },
                      currentTime: DateTime.now(),
                      locale: LocaleType.de,
                      showSecondsColumn: false);
                },
                title: Text(
                  'Erinnerung täglich um $_alarmTime Uhr',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            Divider(
              height: 2,
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('Feedback zur App geben'),
              onTap: () {
                _sendFeedbackEmail();
              },
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Über die App'),
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationVersion: _appVersion,
                    applicationLegalese:
                        'Jens Wangenheim\n50937 Köln\nplaystore@jenswangenheim.de\nIcon von flaticon.com/authors/freepik');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSettings() async {
    _autoDelete = await PrefsHelper.isAutoDeleteDataEnabled();
    _dailyReminder = await PrefsHelper.isReminderEnabled();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = 'App Version ${packageInfo.version}';
  }

  void _sendFeedbackEmail() async {
    final Email email = Email(
      subject: 'Feedback zur Kontakt-Tagebuch App',
      recipients: ['playstore@jenswangenheim.de'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  /*void _setDailyReminder() async {
    final now = DateTime.now();
    final int alarmId = 0;
    await AndroidAlarmManager.initialize();
    //await AndroidAlarmManager.oneShotAt(DateTime);
  }

  void printHello() {
    print('Hello');
  }*/
}
