import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NextClassPanel extends StatelessWidget {
  final DateTime date;
  final int partcipantCount;
  final int maxParticipants;
  final bool enrollStatus;

  const NextClassPanel({
    required this.date,
    required this.partcipantCount,
    required this.maxParticipants,
    required this.enrollStatus,
  });

  bool getEnrollStatus() {
    return enrollStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[50],
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd/MM/yy HH:mm').format(date),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Chip(
              label: Text(
                'Enrolled $partcipantCount/$maxParticipants',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            TextButton(
                onPressed: getEnrollStatus() ? () {} : null,
                child: Text('Enroll')),
          ],
        ),
      ),
    );
  }
}
