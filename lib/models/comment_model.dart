class CommentModel {
  final int id;
  final int lostFoundId;
  final int userId;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final String? userName; // Optional: untuk menampilkan nama user
  final String? userAvatar; // Optional: untuk menampilkan foto profil user

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
      id: json['id'] ?? 0,
      lostFoundId: json['lost_found_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userName: json['user_name'] ?? json['user']?['name'],
      userAvatar: json['user_avatar'] ?? json['user']?['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lost_found_id': lostFoundId,
      'user_id': userId,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_name': userName,
      'user_avatar': userAvatar,
    };
  }
}