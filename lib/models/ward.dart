class Ward {
  Ward({
    this.wardId,
    this.wardName,
    this.latitude,
    this.longitude,
  });

  String wardId;
  String wardName;
  List latitude;
  List longitude;

  factory Ward.fromJson(Map<String, dynamic> json) => Ward(
        wardId: json["ward_id"],
        wardName: json["ward_name"],
        latitude: json["latitude"] == null
            ? []
            : json["latitude"].toString().split(","),
        longitude: json["longitude"] == null
            ? []
            : json["longitude"].toString().split(","),
      );

  Map<String, dynamic> toJson() => {
        "ward_id": wardId,
        "ward_name": wardName,
        "latitude": latitude,
        "longitude": longitude,
      };
}
