class Availability {
  final String id;
  final String serviceID;
  final String date;
  final String startTime;
  final String endTime;

  Availability({required this.id, required this.serviceID, required this.date, required this.startTime, required this.endTime});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['_id'],
      serviceID: json['serviceID'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}