import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<void> insertAlarm(Map<String, dynamic> alarmData) async {
    try {
      await client.from('user_alarms').insert(alarmData);
    } catch (error) {
      throw error;
    }
  }

  Future<List<Map<String, dynamic>>> getAlarms() async {
    try {
      final response = await client.from('user_alarms').select();
      return response as List<Map<String, dynamic>>;
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateAlarm(int id, Map<String, dynamic> alarmData) async {
    try {
      await client.from('user_alarms').update(alarmData).eq('id', id);
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteAlarm(int id) async {
    try {
      await client.from('user_alarms').delete().eq('id', id);
    } catch (error) {
      throw error;
    }
  }
}
