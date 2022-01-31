import 'package:flutter/material.dart';

class NextClassStatus extends StatelessWidget {
  final bool hasData;
  final bool isNotEnrolled;

  NextClassStatus(bool this.hasData, bool this.isNotEnrolled);

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
                  'You are not enrolled',
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
