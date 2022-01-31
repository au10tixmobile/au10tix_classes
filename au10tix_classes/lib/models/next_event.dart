import 'package:cloud_firestore/cloud_firestore.dart';

class NextEvent {
  DateTime? date;
  List<DocumentReference> participants = [];
  List<DocumentReference> waitingParticipants = [];
  NextEvent(this.date, this.participants, this.waitingParticipants);
}
