// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/class/classes.dart';
import '../../models/au10tix_class.dart';
import '../../screens/class_details_screen.dart';

class ClassesScreen extends StatefulWidget {
  static const routeName = '/classes_screen';

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  void onPNReceived(String id) async {
    var classDoc = await FirebaseFirestore.instance
        .collection('classes')
        .doc(id)
        // .where('name', isEqualTo: id)
        .get()
        .then((value) => value.data());
    final au10Class = Au10tixClass.parseResult(classDoc, id);
    Navigator.pushNamed(
      context,
      ClassDetailsScreen.routeName,
      arguments: au10Class,
    );
  }

  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("bbbbb $message");
      if (message.data.keys.isNotEmpty) {
        print(message.data.toString());
        onPNReceived(message.data['classId']);
      }
      return;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Au10tix Classes'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('Logout')
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Classes(),
    );
  }
}
