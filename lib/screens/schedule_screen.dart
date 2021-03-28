import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gms_core/models/schedule.dart';
import 'package:gms_core/services/schedule_service.dart';
import 'package:gms_user/widgets/custom_loading_button.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Schedule> schedules = [];
  bool isLoad = true;

  getSchedules() async {
    ScheduleService scheduleService = ScheduleService();
    schedules = await scheduleService.getSchedule();
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? CustomLoading()
        : SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Text(
                    "SCHEDULE",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: Get.width * 0.04),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.08, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${schedules[index].day}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${schedules[index].type}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: schedules.length,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
