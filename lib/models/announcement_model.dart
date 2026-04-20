class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String? file;
  final String createdBy; // ID of the creator
  final String creatorName; // From view
  final String creatorRole; // From view
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.file,
    required this.createdBy,
    required this.creatorName,
    required this.creatorRole,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['announcement_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      file: json['file'],
      createdBy: json['created_by'] ?? '',
      creatorName: json['creator_name'] ?? 'Admin',
      creatorRole: json['creator_role'] ?? 'admin',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'announcement_id': id,
      'title': title,
      'content': content,
      'file': file,
      'created_by': createdBy,
      'creator_name': creatorName,
      'creator_role': creatorRole,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
