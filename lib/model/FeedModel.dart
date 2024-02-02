class FeedInfo {
  final String id;
  final String imgurl; // Consider changing this to hold the "thumb" URL
  final String description;
  final int width;
  final int height;

  FeedInfo({
    required this.id,
    required this.imgurl,
    required this.description,
    required this.width,
    required this.height,
  });

  factory FeedInfo.fromJson(Map<String, dynamic> json) {
    String thumbUrl = json['urls']['thumb'];
    return FeedInfo(
      id: json['id'],
      imgurl: thumbUrl,
      description: json['description'] ?? "no description",
      width: json['width'],
      height: json['height'],
    );
  }
}
