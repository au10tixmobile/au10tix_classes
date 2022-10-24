import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../models/au10tix_class.dart';
import '../../models/next_event.dart';
import '../../providers/auth_user.dart';
import './dialog_helper.dart';

class NextClassHelper {
  static bool isNotEnrolled(NextEvent nextEvent, AuthUser user) =>
      !nextEvent.participants.contains(user.userRef!);
  static bool isOpenForEnrollment(
          Au10tixClass au10tixClass, NextEvent nextEvent) =>
      au10tixClass.attendenceMax > nextEvent.participants.length;
  static bool isNotWaiting(NextEvent nextEvent, AuthUser user) =>
      !nextEvent.waitingParticipants.contains(user.userRef!);

  static Future<void> handleWaitingList(
    bool addToWaiting,
    Au10tixClass au10tixClass,
    NextEvent nextEvent,
    AuthUser user,
  ) async {
    final fbm = FirebaseMessaging.instance;

    if (addToWaiting) {
      nextEvent.waitingParticipants.add(user.userRef!);
      fbm.subscribeToTopic(
          au10tixClass.nextEventRef!.path.substring(7) + "_waiting");
      fbm.subscribeToTopic(au10tixClass.nextEventRef!.path.substring(7));
    } else {
      nextEvent.waitingParticipants.remove(user.userRef!);
      fbm.unsubscribeFromTopic(
          au10tixClass.nextEventRef!.path.substring(7) + "_waiting");
      fbm.unsubscribeFromTopic(au10tixClass.nextEventRef!.path.substring(7));
    }

    await FirebaseFirestore.instance
        .collection('events')
        .doc(au10tixClass.nextEventRef!.path.substring(7))
        .update({
      'waitingParticipants': nextEvent.waitingParticipants,
    });
  }

  static NextEvent updateNextEvent(DocumentSnapshot a) {
    final data = a.data() as Map<String, dynamic>;
    final DateTime date = DateTime.parse(data['date'].toDate().toString());
    List<DocumentReference> participants = [];

    if (data.containsKey('participants')) {
      participants = List.from(data['participants']);
    }
    List<DocumentReference> waitingParticipants = [];
    if (data.containsKey('waitingParticipants')) {
      waitingParticipants = List.from(data['waitingParticipants']);
    }
    List<DocumentReference> chatMsgs = [];
    if (data.containsKey('chatMsgs')) {
      chatMsgs = List.from(data['chatMsgs']);
    }
    return NextEvent(
        date: date,
        participants: participants,
        waitingParticipants: waitingParticipants,
        chatMsgs: chatMsgs);
  }

  static Future<void> enrollToEvent(
    BuildContext context,
    Au10tixClass au10tixClass,
    NextEvent nextEvent,
    AuthUser user,
    Function handleWaitingList,
  ) async {
    final fbm = FirebaseMessaging.instance;
    if (!isOpenForEnrollment(au10tixClass, nextEvent) &&
        isNotEnrolled(nextEvent, user)) {
      if (isNotWaiting(nextEvent, user)) {
        DialogHelper.showEnrollDialog(
            context,
            'The class is full',
            'Would you like to join the waiting list?',
            handleWaitingList,
            true);
      } else {
        DialogHelper.showEnrollDialog(
            context,
            'Already in waiting list',
            'Would you like to be removed from the list?',
            handleWaitingList,
            false);
      }
    } else {
      if (isNotEnrolled(nextEvent, user)) {
        fbm.subscribeToTopic(au10tixClass.nextEventRef!.path.substring(7));
        nextEvent.participants.add(user.userRef!);
        if (!isNotWaiting(nextEvent, user)) {
          nextEvent.waitingParticipants.remove(user.userRef!);
          await FirebaseFirestore.instance
              .collection('events')
              .doc(au10tixClass.nextEventRef!.path.substring(7))
              .update({
            'waitingParticipants': nextEvent.waitingParticipants,
          });
        }
      } else {
        nextEvent.participants.remove(user.userRef!);
        fbm.unsubscribeFromTopic(au10tixClass.nextEventRef!.path.substring(7));
      }
      await FirebaseFirestore.instance
          .collection('events')
          .doc(au10tixClass.nextEventRef!.path.substring(7))
          .update({
        'participants': nextEvent.participants,
      });
    }
  }

  static Stream<NextEvent> getNextEvent(Au10tixClass au10tixClass) async* {
    yield* FirebaseFirestore.instance
        .collection('events')
        .doc(au10tixClass.nextEventRef!.path.substring(7))
        .snapshots()
        .asyncMap((event) => NextClassHelper.updateNextEvent(event));
  }
}
