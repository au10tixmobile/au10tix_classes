import 'package:flutter/material.dart';

class NextClassStatus extends StatelessWidget {
  final bool hasData;
  final bool isNotEnrolled, isNotWaiting;

  NextClassStatus(this.hasData, this.isNotEnrolled, this.isNotWaiting);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Text(
        'Next class: ',
        style: TextStyle(fontSize: 16),
      ),
      !hasData
          ? const Text(
              'Next class: ',
              style: TextStyle(fontSize: 16),
            )
          : isNotEnrolled
              ? Text(
                  isNotWaiting
                      ? 'You are not enrolled'
                      : 'You are in the waiting list',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).errorColor),
                )
              : Text(
                  'You are enrolled',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
    ]);
  }
}
