import 'package:cloud_firestore/cloud_firestore.dart';

class NextEvent {
  DateTime? date;
  String status;
  List<DocumentReference> participants = [];
  List<DocumentReference> waitingParticipants = [];
  List<DocumentReference> chatMsgs = [];
  NextEvent({
    this.date,
    this.status = "Active",
    required this.participants,
    required this.waitingParticipants,
    required this.chatMsgs,
  });
}
