class CommentModel {
  final String id; // Ubah dari int ke String
  final String lostFoundId;
  final String userId;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final String? userName;
  final String? userAvatar;

  CommentModel({
    required this.id,
    required this.lostFoundId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: (json['comment_id'] ?? json['id'] ?? '').toString(),
      lostFoundId: (json['lostfound_id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['update_at'] ?? json['updated_at'] ?? '',
      userName: json['commenter_name'] ?? json['user_name'],
      userAvatar: json['user_avatar'],
    );
  }
}