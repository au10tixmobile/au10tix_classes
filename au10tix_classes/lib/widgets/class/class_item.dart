import 'package:au10tix_classes/models/au10tix_class.dart';
import 'package:au10tix_classes/screens/class_details_screen.dart';
import 'package:flutter/material.dart';

class ClassItem extends StatelessWidget {
  final Au10tixClass au10tixClass;

  const ClassItem(this.au10tixClass);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ClassDetailsScreen.routeName,
        arguments: au10tixClass,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: au10tixClass.id,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(au10tixClass.imageUrl),
                  ),
                ),
              ],
            ),
            title: Text(au10tixClass.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const Text('Next class:'),
                Text('Status - Enroll open 7/${au10tixClass.attendenceMax}'),
                const Text('Date - 28/9/2022'),
                const SizedBox(height: 5),
                Text(
                  'You are enrolled in this class',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_forward_ios),
                ]),
          ),
        ),
      ),
    );
  }
}
