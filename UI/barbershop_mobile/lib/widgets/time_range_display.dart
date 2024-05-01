import 'package:flutter/material.dart';

class TimeRangeDisplay extends StatelessWidget {
  final String startTime;
  final String endTime;

  const TimeRangeDisplay({
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Start time : $startTime',
          style: const TextStyle(fontSize: 16, color: Colors.green),
        ),
        Text(
          'End time: $endTime',
          style: const TextStyle(fontSize: 16, color: Colors.green),
        ),
      ],
    );
  }
}
