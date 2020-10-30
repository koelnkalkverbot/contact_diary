import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../icons/custom_icons.dart';
import '../models/contact_entry.dart';
import '../providers/contact_entries.dart';

class ContactDetailsScreen extends StatefulWidget {
  static const ROUTE_NAME = 'contactDetail';

  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isInit = false;

  var _editedContactEntry = ContactEntry(
    id: null,
    description: '',
    maskWorn: false,
    distanceKept: false,
    amountOfPeople: 0,
    location: ContactEntry.LOCATION_INSIDE,
    startDate: roundDown(DateTime.now()),
    endDate: roundDown(DateTime.now()).add(Duration(minutes: 10)),
  );

  Future _showNumberPickerDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 1000,
          initialIntegerValue: 0,
        );
      },
    ).then((value) {
      setState(() {
        unfocus();
        _editedContactEntry.amountOfPeople = value;
      });
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      final entryId = ModalRoute.of(context).settings.arguments as String;
      _setupScreen(entryId);
      _isInit = true;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Eintrag bearbeiten"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveEntry();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _descriptionController,
                onChanged: (value) {
                  _editedContactEntry.description = _descriptionController.text;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SwitchListTile(
                title: const Text('Mund-Nasen-Schutz getragen?'),
                value: _editedContactEntry.maskWorn,
                onChanged: (bool value) {
                  setState(() {
                    unfocus();
                    _editedContactEntry.maskWorn = value;
                  });
                },
                secondary: const Icon(
                  CustomIcons.mask,
                  size: 32,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SwitchListTile(
                title: const Text('Abstand gehalten?'),
                value: _editedContactEntry.distanceKept,
                onChanged: (bool value) {
                  setState(() {
                    unfocus();
                    _editedContactEntry.distanceKept = value;
                  });
                },
                secondary: const Icon(CustomIcons.distance),
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.grey, size: 28),
                title: Text('Anzahl Personen'),
                trailing: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _editedContactEntry.amountOfPeople.toString(),
                    style: TextStyle(
                        fontSize: 19, color: Theme.of(context).accentColor),
                  ),
                ),
                onTap: () {
                  _showNumberPickerDialog();
                },
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.grey, size: 28),
                title: Wrap(children: [
                  DropdownButton<String>(
                    value: _editedContactEntry.location,
                    onChanged: (String newValue) {
                      setState(() {
                        unfocus();
                        _editedContactEntry.location = newValue;
                      });
                    },
                    items: <String>[
                      ContactEntry.LOCATION_INSIDE,
                      ContactEntry.LOCATION_OUTSIDE,
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ]),
                onTap: () {},
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                leading:
                    Icon(Icons.arrow_forward, color: Colors.grey, size: 28),
                title: Text(DateFormat('dd.MM.yyyy, HH:mm')
                        .format(_editedContactEntry.startDate) +
                    ' Uhr'),
                onTap: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      _editedContactEntry.startDate = date;
                    });
                    unfocus();
                  },
                      currentTime: _editedContactEntry.startDate,
                      locale: LocaleType.de);
                },
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                leading: Icon(Icons.arrow_back, color: Colors.grey, size: 28),
                title: Text(DateFormat('dd.MM.yyyy, HH:mm')
                        .format(_editedContactEntry.endDate) +
                    ' Uhr'),
                onTap: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      _editedContactEntry.endDate = date;
                    });
                  },
                      currentTime: _editedContactEntry.endDate,
                      locale: LocaleType.de);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setupScreen(final String entryId) {
    if (entryId != null) {
      _editedContactEntry =
          Provider.of<ContactEntries>(context, listen: false).findById(entryId);
      _descriptionController.text = _editedContactEntry.description;
    }
  }

  void _saveEntry() {
    if (_editedContactEntry.description.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Bitte gib eine Beschreibung ein'),
          duration: new Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_editedContactEntry.id != null) {
      Provider.of<ContactEntries>(context, listen: false)
          .updateEntry(_editedContactEntry);
    } else {
      Provider.of<ContactEntries>(context, listen: false)
          .addEntry(_editedContactEntry);
    }
    Navigator.of(context).pop();
  }

  void unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static DateTime roundDown(DateTime dateTime) {
    return DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch -
        dateTime.millisecond -
        (dateTime.second * 1000));
  }
}
