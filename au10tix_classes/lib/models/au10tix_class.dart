import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Au10tixClass {
  final String id;
  final String name;
  final int attendenceMax;
  final String imageUrl;
  final String instructorName;
  final String description;
  final DateTime date;
  DocumentReference? nextEventRef;

  Au10tixClass({
    required this.id,
    required this.name,
    required this.attendenceMax,
    required this.imageUrl,
    required this.instructorName,
    required this.description,
    required this.date,
    this.nextEventRef,
  });

  String get occurance =>
      "${DateFormat('EEEE').format(date)} ${DateFormat('Hm').format(date)}";

  static Au10tixClass parseResult(Map<String, dynamic>? classDoc, String id) {
    return Au10tixClass(
      id: id,
      name: classDoc!['name'],
      attendenceMax: classDoc['attendenceMax'],
      imageUrl: classDoc['imageUrl'],
      instructorName: classDoc['instructorName'],
      description: classDoc['description'],
      date: DateTime.parse(classDoc['firstClass'].toDate().toString()),
      nextEventRef:
          classDoc.containsKey('nextEvent') ? classDoc['nextEvent'] : null,
    );
  }
}
