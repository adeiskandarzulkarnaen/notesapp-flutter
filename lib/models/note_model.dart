
class NoteModel {
  final String id;
  final String title;
  final List<String> tags;
  final String body;
  final String owner;
  final String createdAt;
  final String updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    this.tags = const [],
    required this.body,
    required this.owner,
    required this.createdAt,
    required this.updatedAt
  });


  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json["title"],
      // tags: json["tags"],
      tags: List<String>.from(json['tags']),
      body: json["body"],
      owner: json["owner"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]
    );
  }
}