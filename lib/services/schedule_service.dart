import 'dart:convert';

import 'package:gms_user/models/schedule.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  Future<List<Schedule>> getSchedule() async {
    List<Schedule> schedules = [];

    final response = await http
        .get("https://xtoinfinity.tech/GCUdupi/user/gms_php/getSchedule.php");

    final jsonResponse = json.decode(response.body);
    final allData = jsonResponse['data'];
    allData.map((e) => schedules.add(Schedule.fromJson(e))).toList();

    return schedules;
  }
}
