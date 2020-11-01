class Collection {
  Collection({
    this.collectionId,
    this.wardId,
    this.vehicleId,
    this.startTime,
    this.endTime,
  });

  String collectionId;
  String wardId;
  String vehicleId;
  DateTime startTime;
  DateTime endTime;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        collectionId: json["collection_id"],
        wardId: json["ward_id"],
        vehicleId: json["vehicle_id"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "collection_id": collectionId,
        "ward_id": wardId,
        "vehicle_id": vehicleId,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      };
}
