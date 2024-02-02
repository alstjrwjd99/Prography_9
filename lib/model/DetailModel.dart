class PhotoDetailModel {
  final String id;
  final String userName;
  final String slug;
  final String imgurl;
  final String description;
  final int width;
  final int height;
  final List<String> tags;

  PhotoDetailModel({
    required this.id,
    required this.userName,
    required this.slug,
    required this.imgurl,
    required this.description,
    required this.width,
    required this.height,
    required this.tags,
  });

  factory PhotoDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> tagTitles = [];
    if (json['tags'] is List<dynamic>) {
      tagTitles = (json['tags'] as List<dynamic>)
          .map((tag) => tag['title'].toString())
          .toList();
    }

    return PhotoDetailModel(
      id: json['id'].toString(),
      userName: json['user']['username'].toString(),
      slug: json['slug'].toString(),
      imgurl: json['urls']['thumb'].toString(),
      description: json['description']?.toString() ?? "no description",
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      tags: tagTitles,
    );
  }
}
