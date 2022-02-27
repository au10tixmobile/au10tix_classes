import 'package:au10tix_classes/models/au10tix_class.dart';
import 'package:au10tix_classes/models/next_event.dart';
import 'package:au10tix_classes/providers/auth_user.dart';
import 'package:au10tix_classes/widgets/chat/messages.dart';
import 'package:au10tix_classes/widgets/details/next_class_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NextClassDetailsCard extends StatelessWidget {
  final Au10tixClass? au10tixClass;
  NextEvent? _nextEvent;
  AuthUser? _user;

  NextClassDetailsCard({
    Key? key,
    this.au10tixClass,
  }) : super(key: key);
  final fbm = FirebaseMessaging.instance;

  get _eventsStream => FirebaseFirestore.instance
      .collection('events')
      .doc(au10tixClass!.nextEventRef!.path.substring(7))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _eventsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            _updateNextEvent(snapshot.data!);
            _user = Provider.of<AuthUser>(context, listen: false);

            var updateCount =
                _nextEvent?.chatMsgs != null ? _nextEvent?.chatMsgs.length : 0;
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Next class information"),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text("Date"),
                    subtitle:
                        Text(DateFormat('dd/MM/yy').format(_nextEvent!.date!)),
                    leading: const Icon(Icons.calendar_view_day),
                  ),
                  ListTile(
                    title: const Text("Participating"),
                    subtitle: Text(
                        '${_nextEvent!.participants.length}/${au10tixClass!.attendenceMax} (Enrolled/Allowed)'),
                    leading: const Icon(Icons.person),
                  ),
                  updateCount == 0
                      ? const ListTile(
                          title: Text("Updates"),
                          subtitle: Text('No messages'),
                          leading: Icon(Icons.message),
                        )
                      : ExpansionTile(
                          title: const Text('Updates'),
                          subtitle: Text('$updateCount messages'),
                          leading: const Icon(Icons.message),
                          children: [Messages(au10tixClass!.nextEventRef!.id)],
                        ),
                  ListTile(
                    title: const Text("Enrollment status"),
                    subtitle: NextClassStatus(
                        true, _isNotEnrolled(), _isNotWaiting()),
                    leading: const Icon(Icons.add_circle_outline),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _enrollToEvent(context),
                          child: Text(
                            _isNotEnrolled()
                                ? _isNotWaiting()
                                    ? 'Enroll'
                                    : 'Drop'
                                : 'Leave',
                          ),
                        ),
                      ))
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void _updateNextEvent(DocumentSnapshot a) {
    final DateTime date = DateTime.parse(a.data()!['date'].toDate().toString());
    List<DocumentReference> participants = [];

    if (a.data()!.containsKey('participants')) {
      participants = List.from(a.data()!['participants']);
    }
    List<DocumentReference> waitingParticipants = [];
    if (a.data()!.containsKey('waitingParticipants')) {
      waitingParticipants = List.from(a.data()!['waitingParticipants']);
    }
    List<DocumentReference> chatMsgs = [];
    if (a.data()!.containsKey('chatMsgs')) {
      chatMsgs = List.from(a.data()!['chatMsgs']);
    }
    _nextEvent = NextEvent(
        date: date,
        participants: participants,
        waitingParticipants: waitingParticipants,
        chatMsgs: chatMsgs);
  }

  void _enrollToEvent(BuildContext context) async {
    if (!_isOpenForEnrollment() && _isNotEnrolled()) {
      if (_isNotWaiting()) {
        _showDialog(
            context,
            'The class is full',
            'Would you like to join the waiting list?',
            _handleWaitingList,
            true);
      } else {
        _showDialog(
            context,
            'Already in waiting list',
            'Would you like to be removed from the list?',
            _handleWaitingList,
            false);
      }
    } else {
      if (_isNotEnrolled()) {
        _nextEvent!.participants.add(_user!.userRef!);
        if (!_isNotWaiting()) {
          _nextEvent!.waitingParticipants.remove(_user!.userRef!);
          await FirebaseFirestore.instance
              .collection('events')
              .doc(au10tixClass!.nextEventRef!.path.substring(7))
              .update({
            'waitingParticipants': _nextEvent!.waitingParticipants,
          });
        }
      } else {
        _nextEvent!.participants.remove(_user!.userRef!);
      }
      await FirebaseFirestore.instance
          .collection('events')
          .doc(au10tixClass!.nextEventRef!.path.substring(7))
          .update({
        'participants': _nextEvent!.participants,
      });
    }
  }

  bool _isNotEnrolled() => !_nextEvent!.participants.contains(_user!.userRef!);

  bool _isNotWaiting() =>
      !_nextEvent!.waitingParticipants.contains(_user!.userRef!);

  bool _isOpenForEnrollment() =>
      au10tixClass!.attendenceMax > _nextEvent!.participants.length;

  void _showDialog(
    BuildContext context,
    String title,
    String body,
    Function handleWaitingList,
    bool join,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                handleWaitingList(join);
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Yes')),
        ],
      ),
    );
  }

  void _handleWaitingList(bool join) async {
    if (join) {
      _nextEvent!.waitingParticipants.add(_user!.userRef!);
      fbm.subscribeToTopic(au10tixClass!.nextEventRef!.path.substring(7));
    } else {
      _nextEvent!.waitingParticipants.remove(_user!.userRef!);
      fbm.unsubscribeFromTopic(au10tixClass!.nextEventRef!.path.substring(7));
    }
    await FirebaseFirestore.instance
        .collection('events')
        .doc(au10tixClass!.nextEventRef!.path.substring(7))
        .update({
      'waitingParticipants': _nextEvent!.waitingParticipants,
    });
  }
}
