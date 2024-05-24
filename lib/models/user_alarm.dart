import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';

class UserAlarm {
  int id;
  TimeOfDay time;
  bool repeat_sun = false;
  bool repeat_mon = false;
  bool repeat_tue = false;
  bool repeat_wed = false;
  bool repeat_thu = false;
  bool repeat_fri = false;
  bool repeat_sat = false;

  UserAlarm({
    required this.id,
    required this.time,
  });

  /// Converts an `AlarmSettings` instance to a `UserAlarm` instance.
  factory UserAlarm.fromAlarmSettings(AlarmSettings alarmSettings) {
    return UserAlarm(
      id: alarmSettings.id,
      time: TimeOfDay.fromDateTime(alarmSettings.dateTime),
    );
  }

  /// Converts a `UserAlarm` instance to an `AlarmSettings` instance.
  AlarmSettings toAlarmSettings() {
    final now = DateTime.now();
    final alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return AlarmSettings(
      id: id,
      dateTime: alarmDateTime,
      assetAudioPath: 'assets/audio.mp3', // Example path
      notificationTitle: 'Alarm',
      notificationBody: 'It\'s time!',
      loopAudio: true,
      vibrate: true,
    );
  }
}
