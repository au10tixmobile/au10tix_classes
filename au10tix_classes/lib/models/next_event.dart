import 'package:cloud_firestore/cloud_firestore.dart';

class NextEvent {
  DateTime? date;
  List<DocumentReference> participants = [];

  NextEvent(this.date, this.participants);
}
