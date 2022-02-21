// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../../models/au10tix_class.dart';
import './next_class_panel.dart';
import '../chat/messages.dart';

class ClassDetailsContent extends StatelessWidget {
  final Au10tixClass au10tixClass;
  const ClassDetailsContent(this.au10tixClass);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClassDetailsDetail(
              title: 'Instructor', detail: au10tixClass.instructorName),
          const SizedBox(height: 10),
          ClassDetailsDetail(
              title: 'Occurs Every', detail: au10tixClass.getOccurance()),
          const SizedBox(height: 10),
          ClassDetailsDetail(
              title: 'Total Participatns',
              detail: au10tixClass.attendenceMax.toString()),
          const SizedBox(height: 20),
          NextClassPanel(au10tixClass),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Text(
              au10tixClass.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class ClassDetailsDetail extends StatelessWidget {
  const ClassDetailsDetail({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title + ': ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
