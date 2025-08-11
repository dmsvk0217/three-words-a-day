import 'package:flutter/material.dart';

String hhmm(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

TimeOfDay toTimeOfDay(int hour, int minute) =>
    TimeOfDay(hour: hour, minute: minute);

extension TimeOfDayX on TimeOfDay {
  String get hhmm =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
