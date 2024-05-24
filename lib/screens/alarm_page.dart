import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:inbox_alarm/models/user_alarm.dart';
import 'package:inbox_alarm/screens/edit_alarm.dart';
import 'package:inbox_alarm/supabase_service.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<UserAlarm> alarms = [];
  SupabaseService supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: AlarmEditScreen(alarmSettings: settings),
        );
      },
    );

    if (res != null && res == true) loadAlarms();
  }

  void loadAlarms() {
    setState(() {
      final alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
      this.alarms =
          alarms.map((alarm) => UserAlarm.fromAlarmSettings(alarm)).toList();
    });
  }

  Future<void> _loadAlarms() async {
    List<Map<String, dynamic>> alarmData = await supabaseService.getAlarms();
    // alarms = alarmData.map((data) => UserAlarm.fromMap(data)).toList();
    setState(() {});
  }

  void _addAlarm(TimeOfDay time, List<bool> repeatDays) async {
    int id = DateTime.now().millisecondsSinceEpoch;
    final UserAlarm alarm = UserAlarm(id: id, time: time);
    // await supabaseService.insertAlarm(alarm.toMap());

    // AlarmManager.oneShot(
    //   DateTime.now().add(Duration(hours: time.hour, minutes: time.minute)),
    //   alarm.id,
    //   'アラーム',
    //   'アラームが鳴りました',
    //   exact: true,
    // );

    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('アラーム設定')),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => navigateToAlarmScreen(null),
            child: Text('アラームを追加'),
          ),
          ...alarms.map((alarm) => ListTile(
                title: Text('${alarm.time.format(context)}'),
                // subtitle: Text('繰り返し: ${a // larm.repeatDays.toString()}'),
              )),
        ],
      ),
    );
  }
}
