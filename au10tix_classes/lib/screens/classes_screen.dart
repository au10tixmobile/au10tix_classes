import 'package:au10tix_classes/widgets/class/classes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassesScreen extends StatelessWidget {
  // final List<Au10tixClass> _classes = [
  //   Au10tixClass(
  //     id: 0,
  //     name: "Yoga",
  //     attendenceMax: 10,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //     instructorName: 'Judy',
  //     description:
  //         'We are simply pushing the detail page on top the current view screen or better stated: navigating to the detail page. Which will create the page shortly',
  //   ),
  //   Au10tixClass(
  //     id: 1,
  //     name: "Pilates",
  //     attendenceMax: 8,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //     instructorName: 'Judy',
  //     description:
  //         'We are simply pushing the detail page on top the current view screen or better stated: navigating to the detail page. Which will create the page shortly',
  //   ),
  // ];
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
      body: Classes(),
    );
  }
}
