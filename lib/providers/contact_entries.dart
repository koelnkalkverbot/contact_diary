import 'package:contact_diary/helpers/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/contact_entry.dart';

class ContactEntries with ChangeNotifier {
  List<ContactEntry> _entries = [];

  List<ContactEntry> get entries {
    return [..._entries];
  }

  ContactEntry findById(final String id) {
    return entries.firstWhere((element) => id == element.id);
  }

  Future<void> loadAndSetEntries() async {
    final data = await DBHelper.getData();
    _entries = data
        .map((item) => ContactEntry(
              id: item['id'],
              description: item['description'],
              amountOfPeople: item['amount_of_people'],
              maskWorn: item['mask_worn'] == 1,
              distanceKept: item['distance_kept'] == 1,
              location: item['location'],
              startDate:
                  DateTime.fromMillisecondsSinceEpoch(item['start_date']),
              endDate: DateTime.fromMillisecondsSinceEpoch(item['end_date']),
            ))
        .toList();
    _entries.sort((item1, item2) => item2.startDate.compareTo(item1.startDate));
    notifyListeners();
  }

  void addEntry(final ContactEntry entry) {
    final newEntry = new ContactEntry(
        id: DateTime.now().toString(),
        description: entry.description,
        amountOfPeople: entry.amountOfPeople,
        maskWorn: entry.maskWorn,
        distanceKept: entry.distanceKept,
        location: entry.location,
        startDate: entry.startDate,
        endDate: entry.endDate);
    _entries.add(newEntry);
    notifyListeners();
    DBHelper.insertData({
      'id': newEntry.id,
      'description': newEntry.description,
      'amount_of_people': newEntry.amountOfPeople,
      'mask_worn': newEntry.maskWorn ? 1 : 0,
      'distance_kept': newEntry.distanceKept ? 1 : 0,
      'location': newEntry.location,
      'start_date': newEntry.startDate.millisecondsSinceEpoch,
      'end_date': newEntry.endDate.millisecondsSinceEpoch,
    });
  }

  void updateEntry(final ContactEntry updatedEntry) {
    int index = _entries.indexWhere((entry) => entry.id == updatedEntry.id);
    _entries[index] = updatedEntry;
    notifyListeners();
    DBHelper.updateData({
      'id': updatedEntry.id,
      'description': updatedEntry.description,
      'amount_of_people': updatedEntry.amountOfPeople,
      'mask_worn': updatedEntry.maskWorn ? 1 : 0,
      'distance_kept': updatedEntry.distanceKept ? 1 : 0,
      'location': updatedEntry.location,
      'start_date': updatedEntry.startDate.millisecondsSinceEpoch,
      'end_date': updatedEntry.endDate.millisecondsSinceEpoch,
    });
  }

  void deleteEntry(final String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    DBHelper.deleteItem(id);
  }
}
