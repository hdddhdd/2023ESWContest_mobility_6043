class Media_whycarno{

  String longitude;
  String video_Url;
  Media_whycarno({
    required this.longitude,
    required this.video_Url
  });

  factory Media_whycarno.fromJson(Map<String, dynamic> json){
    final volumnInfo = json['volumeInfo'];
    final longitude = volumnInfo['title'] ?? '';
    final imageLinks = volumnInfo['imageLinks'] ?? '';
    final video_Url = imageLinks['thumbnail'] ?? '';
    print("video_Url $video_Url");
    return Media_whycarno(longitude: longitude, video_Url: video_Url);
  }

  static fromMap(Map<dynamic, dynamic> mediavalue){
    var longitude = mediavalue["name"] ?? '';
    var video_Url = mediavalue["video_Url"] ?? '';

    return Media_whycarno(longitude: longitude, video_Url: video_Url);
  }

}