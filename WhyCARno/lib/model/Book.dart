import 'dart:convert';

class Book {
  String longitude;
  String latitude;
  String video_Url;

  String video_runtime;
  String date_time;

  Book({
    required this.longitude,
    required this.latitude,
    required this.video_Url,
    required this.video_runtime,
    required this.date_time,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumnInfo = json['volumeInfo'];
    final longitude = volumnInfo['title'] ?? '';

    final latitude = volumnInfo['title'] ?? '';

    final imageLinks = volumnInfo['imageLinks'] ?? '';
    final video_Url = imageLinks['thumbnail'] ?? '';
    final video_runtime = volumnInfo['title'] ?? '';

    final date_time = volumnInfo['title'] ?? '';

    print("videoUrl $video_Url");

    return Book(
      longitude: longitude,
      latitude: latitude,
      video_Url: video_Url,
      video_runtime: video_runtime,
      date_time: date_time,
    );
  }

  static fromMap(Map<dynamic, dynamic> bookvalue) {
    var longitude = bookvalue["longitude"];
    var latitude = bookvalue["latitude"];

    var video_Url = bookvalue["video_Url"];
    var video_runtime = bookvalue["video_runtime"];
    var date_time = bookvalue["date_time"];

    return Book(
      longitude: longitude,
      latitude: latitude,
      video_Url: video_Url,
      video_runtime: video_runtime,
      date_time: date_time,
    );
  }
}
