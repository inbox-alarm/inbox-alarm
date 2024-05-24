import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:inbox_alarm/models/user_alarm.dart';
import 'package:inbox_alarm/supabase_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SkipAlarmPage extends StatefulWidget {
  const SkipAlarmPage({super.key});

  @override
  _SkipAlarmPageState createState() => _SkipAlarmPageState();
}

class _SkipAlarmPageState extends State<SkipAlarmPage> {
  List<UserAlarm> alarms = [];
  SupabaseService supabaseService = SupabaseService();
  List<DateTime> holidays = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
    _fetchHolidays();
  }

  Future<void> _loadAlarms() async {
    List<Map<String, dynamic>> alarmData = await supabaseService.getAlarms();
    // alarms = alarmData.map((data) => UserAlarm.fromMap(data)).toList();
    setState(() {});
  }

  Future<void> _fetchHolidays() async {
    final response = await http.get(Uri.parse(
        'https://holidayapi.com/v1/holidays?country=US&year=${DateTime.now().year}&key=YOUR_API_KEY'));
    if (response.statusCode == 200) {
      List<DateTime> fetchedHolidays = [];
      final data = json.decode(response.body);
      // for (final holiday in data['holidays']) {
      //   fetchedHolidays.add(DateTime.parse(holiday['date']));
      // }
      setState(() {
        holidays = fetchedHolidays;
      });
    }
  }

  void _skipNextAlarm(int alarmId) async {
    await supabaseService.updateAlarm(alarmId, {'skip': true});
    // AlarmManager.cancel(alarmId);
    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('次のアラーム')),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          UserAlarm alarm = alarms[index];
          bool isHoliday = holidays.any((holiday) =>
              holiday.day == alarm.time.hour &&
              holiday.month == alarm.time.minute);

          return Dismissible(
            key: Key(alarm.id.toString()),
            onDismissed: (direction) {
              _skipNextAlarm(alarm.id);
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text('${alarm.time.format(context)}'),
              // subtitle: Text('繰り返し: ${alarm.repeatDays.toString()}'),
              tileColor: isHoliday ? Colors.yellow : null,
            ),
          );
        },
      ),
    );
  }
}
