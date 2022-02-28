// ignore_for_file: must_be_immutable

import 'package:au10tix_classes/helpers/next_class_helper.dart';
import 'package:au10tix_classes/models/au10tix_class.dart';
import 'package:au10tix_classes/models/next_event.dart';
import 'package:au10tix_classes/providers/auth_user.dart';
import 'package:au10tix_classes/widgets/chat/messages.dart';
import 'package:au10tix_classes/widgets/details/next_class_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            _nextEvent = NextClassHelper.updateNextEvent(snapshot.data!);
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
                        onPressed: () => NextClassHelper.enrollToEvent(
                            context,
                            au10tixClass!,
                            _nextEvent!,
                            _user!,
                            _handleWaitingList),
                        child: Text(
                          _isNotEnrolled()
                              ? _isNotWaiting()
                                  ? 'Enroll'
                                  : 'Drop'
                              : 'Leave',
                        ),
                      ),
                    ),
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

  bool _isNotEnrolled() => !_nextEvent!.participants.contains(_user!.userRef!);

  bool _isNotWaiting() =>
      !_nextEvent!.waitingParticipants.contains(_user!.userRef!);

  void _handleWaitingList(bool join) async {
    NextClassHelper.handleWaitingList(join, au10tixClass!, _nextEvent!, _user!);
  }
}
