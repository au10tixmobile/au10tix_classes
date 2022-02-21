import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/providers/auth_user.dart';
import '/models/au10tix_class.dart';
import '/models/next_event.dart';
import '/widgets/details/next_class_status.dart';

class NextClassPanel extends StatefulWidget {
  final Au10tixClass? au10tixClass;

  const NextClassPanel(this.au10tixClass);

  @override
  State<NextClassPanel> createState() => _NextClassPanelState();
}

class _NextClassPanelState extends State<NextClassPanel> {
  NextEvent? _nextEvent;
  AuthUser? _user;

  bool _isNotEnrolled() => !_nextEvent!.participants.contains(_user!.userRef!);

  bool _isNotWaiting() =>
      !_nextEvent!.waitingParticipants.contains(_user!.userRef!);

  bool _isOpenForEnrollment() =>
      widget.au10tixClass!.attendenceMax > _nextEvent!.participants.length;

  void _showDialog(
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
      fbm.subscribeToTopic(
          widget.au10tixClass!.nextEventRef!.path.substring(7));
    } else {
      _nextEvent!.waitingParticipants.remove(_user!.userRef!);
      fbm.unsubscribeFromTopic(
          widget.au10tixClass!.nextEventRef!.path.substring(7));
    }
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.au10tixClass!.nextEventRef!.path.substring(7))
        .update({
      'waitingParticipants': _nextEvent!.waitingParticipants,
    });
  }

  void _enrollToEvent() async {
    if (!_isOpenForEnrollment() && _isNotEnrolled()) {
      if (_isNotWaiting()) {
        _showDialog(
            'The class is full',
            'Would you like to join the waiting list?',
            _handleWaitingList,
            true);
      } else {
        _showDialog(
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
              .doc(widget.au10tixClass!.nextEventRef!.path.substring(7))
              .update({
            'waitingParticipants': _nextEvent!.waitingParticipants,
          });
        }
      } else {
        _nextEvent!.participants.remove(_user!.userRef!);
      }
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.au10tixClass!.nextEventRef!.path.substring(7))
          .update({
        'participants': _nextEvent!.participants,
      });
    }
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
    _nextEvent = NextEvent(
        date: date,
        participants: participants,
        waitingParticipants: waitingParticipants);
  }

  final fbm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print('AAAAAAAAA - ${message.toString()}');
      return;
    });
  }

  @override
  void didChangeDependencies() async {
    _user = Provider.of<AuthUser>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.au10tixClass!.nextEventRef!.path.substring(7))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            _updateNextEvent(snapshot.data!);
            return Column(
              children: [
                NextClassStatus(
                    snapshot.hasData, _isNotEnrolled(), _isNotWaiting()),
                const SizedBox(height: 5),
                Card(
                  color: Colors.orange[50],
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: !snapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                DateFormat('dd/MM/yy')
                                    .format(_nextEvent!.date!),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Chip(
                                label: Text(
                                  'Enrolled ${_nextEvent!.participants.length}/${widget.au10tixClass!.attendenceMax}',
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
                                onPressed: _enrollToEvent,
                                child: Text(
                                  _isNotEnrolled()
                                      ? _isNotWaiting()
                                          ? 'Enroll'
                                          : 'Drop'
                                      : 'Leave',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
