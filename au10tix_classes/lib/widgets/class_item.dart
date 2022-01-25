import 'package:au10tix_classes/models/au10tix_class.dart';
import 'package:flutter/material.dart';

class ClassItem extends StatelessWidget {
  final Au10tixClass au10tixClass;
  ClassItem(this.au10tixClass);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(au10tixClass.imageUrl),
          ),
          title: Text(au10tixClass.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text('Next class:'),
              Text('Status - Enroll open 7/${au10tixClass.attendenceMax}'),
              Text('Date - 28/9/2022'),
              SizedBox(height: 5),
              Text(
                'You are enrolled in this class',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          trailing:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.arrow_forward_ios_outlined),
          ]),
        ),
      ),
    );
  }
}
