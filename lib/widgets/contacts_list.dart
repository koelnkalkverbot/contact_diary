import 'package:contact_diary/models/contact_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/contact_details_screen.dart';
import '../providers/contact_entries.dart';
import 'date_and_duration_text.dart';

class ContactsList extends StatelessWidget {
  const ContactsList(this.entries);

  final List<ContactEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
      itemCount: entries.length,
      itemBuilder: (ctx, idx) {
        return ListTile(
          title: Text(
            entries[idx].description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
          subtitle: DateAndDurationText(
            startDate: entries[idx].startDate,
            endDate: entries[idx].endDate,
          ),
          trailing: GestureDetector(
            child: Icon(Icons.delete),
            onTap: () {
              showDeleteEntryDialog(context, entries[idx].id);
            },
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              ContactDetailsScreen.ROUTE_NAME,
              arguments: entries[idx].id,
            );
          },
        );
      },
    );
  }

  void showDeleteEntryDialog(BuildContext context, String entryId) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Eintrag löschen"),
              content:
                  new Text("Möchtest Du diesen Eintrag wirklich entfernen?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Nein'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Ja'),
                  onPressed: () {
                    Provider.of<ContactEntries>(context, listen: false)
                        .deleteEntry(entryId);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
