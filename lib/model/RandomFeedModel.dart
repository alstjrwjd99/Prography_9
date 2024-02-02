class RandomFeedModel {
  final String id;
  final String imgurl;
  final int width;
  final int height;

  RandomFeedModel({
    required this.id,
    required this.imgurl,
    required this.width,
    required this.height,
  });

  factory RandomFeedModel.fromJson(Map<String, dynamic> json) {
    return RandomFeedModel(
      id: json['id'],
      imgurl: json['urls']['thumb'],
      width: json['width'],
      height: json['height'],
    );
  }
}