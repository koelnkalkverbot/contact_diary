import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/contact_details_screen.dart';
import './screens/settings_screen.dart';
import './providers/contact_entries.dart';
import './widgets/contacts_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ContactEntries(),
      child: MaterialApp(
        title: 'Kontakt Tagebuch',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
        routes: {
          ContactDetailsScreen.ROUTE_NAME: (ctx) => ContactDetailsScreen(),
          SettingsScreen.ROUTE_NAME: (ctx) => SettingsScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontakt Tagebuch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.ROUTE_NAME);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ContactDetailsScreen.ROUTE_NAME);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ContactEntries>(context).loadAndSetEntries(),
        builder: (ctx, snapshot) => Consumer<ContactEntries>(
          child: Center(
            child: const Text('Noch keine Kontakte eingetragen.'),
          ),
          builder: (ctx, data, ch) =>
              data.entries.length <= 0 ? ch : ContactsList(data.entries),
        ),
      ),
    );
  }
}
