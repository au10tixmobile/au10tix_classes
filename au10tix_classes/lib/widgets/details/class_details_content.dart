import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/au10tix_class.dart';
import 'next_class_panel.dart';

class ClassDetailsContent extends StatelessWidget {
  final Au10tixClass au10tixClass;
  ClassDetailsContent(this.au10tixClass);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructor: ${au10tixClass.instructorName}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Participatns: ${au10tixClass.attendenceMax}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Next class: ${DateFormat('EEEE').format(DateTime.now())}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          NextClassPanel(
            date: DateTime.now(),
            partcipantCount: 7,
            maxParticipants: au10tixClass.attendenceMax,
            enrollStatus: true,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Text(
              au10tixClass.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Join Class'),
            ),
          ),
        ],
      ),
    );
  }
}
