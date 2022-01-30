import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '/providers/auth_user.dart';
import '/models/au10tix_class.dart';
import '/models/next_event.dart';

class NextClassPanel extends StatefulWidget {
  final DateTime date;
  final int partcipantCount;
  final int maxParticipants;
  final bool enrollStatus;
  final Au10tixClass? au10tixClass;

  NextClassPanel({
    required this.date,
    required this.partcipantCount,
    required this.maxParticipants,
    required this.enrollStatus,
    this.au10tixClass,
  });

  @override
  State<NextClassPanel> createState() => _NextClassPanelState();
}

class _NextClassPanelState extends State<NextClassPanel> {
  bool getEnrollStatus() {
    return widget.enrollStatus;
  }

  NextEvent? _nextEvent;
  var _isLoading = true;
  AuthUser? _user;

  void _enrollToEvent() async {
    _nextEvent!.participants.add(_user!.userRef!);
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.au10tixClass!.nextEventRef!.path.substring(7))
        .update({
      'participants': _nextEvent!.participants,
    });
  }

  @override
  void didChangeDependencies() async {
    _user = Provider.of<AuthUser>(context, listen: false);
    try {
      var a = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.au10tixClass!.nextEventRef!.path.substring(7))
          .get();

      final DateTime date =
          DateTime.parse(a.data()!['date'].toDate().toString());
      final List<DocumentReference> participants =
          List.from(a.data()!['participants']);
      _nextEvent = NextEvent(date, participants);
    } catch (e) {
      print('aaaaaa');
    }
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[50],
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _nextEvent == null
                ? const Center(
                    child: Text('No Next Class!'),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat('EEEE').format(DateTime.now())} ${DateFormat('dd/MM/yy').format(_nextEvent!.date!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Chip(
                        label: Text(
                          'Enrolled ${_nextEvent!.participants.length}/${widget.maxParticipants}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                ?.color,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      TextButton(
                          onPressed: getEnrollStatus() ? _enrollToEvent : null,
                          child: const Text('Enroll')),
                    ],
                  ),
      ),
    );
  }
}
