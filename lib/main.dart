import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'contact.dart';
import 'addcontact.dart';

void main() => runApp(const MyApp());

//void addContact(){}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              color: Colors.blue,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold)),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blue, foregroundColor: Colors.white)),
      home: const ContactList(),
      routes: {
        "/addcontact": (context) => const AddContact(),
      },
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    FlutterContacts.addListener(() => _fetchContacts());
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      setState(() => _permissionDenied = true);
    } else {
      var contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Own Contacts App')),
        body: _body(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/addcontact");
            },
            child: Icon(Icons.contact_page)));
  }

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () {
              FlutterContacts.getContact(_contacts![i].id).then((contact) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ContactPage(contact!)));
              });
            }));
  }
}

/*
FLUTTER DEV CODE
https://pub.dev/packages/flutter_contacts

// See installation notes below regarding AndroidManifest.xml and Info.plist
import 'package:flutter_contacts/flutter_contacts.dart';

// Request contact permission
if (await FlutterContacts.requestPermission()) {
  // Get all contacts (lightly fetched)
  List<Contact> contacts = await FlutterContacts.getContacts();

  // Get all contacts (fully fetched)
  contacts = await FlutterContacts.getContacts(
      withProperties: true, withPhoto: true);

  // Get contact with specific ID (fully fetched)
  Contact contact = await FlutterContacts.getContact(contacts.first.id);

  // Insert new contact
  final newContact = Contact()
    ..name.first = 'John'
    ..name.last = 'Smith'
    ..phones = [Phone('555-123-4567')];
  await newContact.insert();

  // Update contact
  contact.name.first = 'Bob';
  await contact.update();

  // Delete contact
  await contact.delete();

  // Open external contact app to view/edit/pick/insert contacts.
  await FlutterContacts.openExternalView(contact.id);
  await FlutterContacts.openExternalEdit(contact.id);
  final contact = await FlutterContacts.openExternalPick();
  final contact = await FlutterContacts.openExternalInsert();




*/