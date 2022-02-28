// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/next_class_helper.dart';
import '../../models/au10tix_class.dart';
import '../../models/next_event.dart';
import '../../providers/auth_user.dart';
import '../../widgets/chat/messages.dart';
import '../../widgets/details/next_class_status.dart';

class NextClassDetailsCard extends StatelessWidget {
  final Au10tixClass? au10tixClass;
  NextEvent? _nextEvent;
  AuthUser? _user;

  NextClassDetailsCard({
    Key? key,
    this.au10tixClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthUser>(context, listen: false);
    return StreamBuilder(
        stream: NextClassHelper.getNextEvent(au10tixClass!),
        builder: (context, AsyncSnapshot<NextEvent> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.data != null) {
            _nextEvent = snapshot.data;

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
                    subtitle: Text(_nextEvent!.nextDate),
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
