import 'package:cloud_firestore/cloud_firestore.dart';

class NextEvent {
  DateTime? date;
  String status;
  List<DocumentReference> participants = [];
  List<DocumentReference> waitingParticipants = [];
  NextEvent({
    this.date,
    this.status = "Active",
    required this.participants,
    required this.waitingParticipants,
  });
}
