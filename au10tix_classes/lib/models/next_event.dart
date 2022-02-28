import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  String get nextDate {
    return DateFormat('dd/MM/yy').format(date!);
  }

  String get nextDay {
    return DateFormat('EEEE').format(date!);
  }
}
