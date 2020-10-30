import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndDurationText extends StatelessWidget {
  const DateAndDurationText({
    Key key,
    @required this.startDate,
    @required this.endDate,
  }) : super(key: key);

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    final hours = endDate.difference(startDate).inHours;
    final minutes = endDate.difference(startDate).inMinutes % 60;
    final timeString = '$hours:${minutes.toString().padLeft(2, '0')} Std.';
    final startDateString = DateFormat('E, d. MMMM').format(startDate);
    return Text('$startDateString - $timeString');
  }
}
