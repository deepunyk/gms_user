class Schedule {
  Schedule({
    this.scheduleId,
    this.day,
    this.type,
  });

  String scheduleId;
  String day;
  String type;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        scheduleId: json["schedule_id"],
        day: json["day"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "schedule_id": scheduleId,
        "day": day,
        "type": type,
      };
}
