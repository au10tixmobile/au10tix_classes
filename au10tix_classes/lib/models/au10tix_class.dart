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

  String getOccurance() =>
      "${DateFormat('EEEE').format(date)} ${DateFormat('Hm').format(date)}";
}
