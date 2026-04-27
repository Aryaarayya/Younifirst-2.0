class CommentModel {
  final String id;
  final String lostFoundId;
  final String userId;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final String? userName;
  final String? userAvatar;
  
  // Custom fields for UI nesting
  String? parentId;
  String commentTextOnly;
  List<CommentModel> replies = [];

  CommentModel({
    required this.id,
    required this.lostFoundId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
    this.parentId,
    this.commentTextOnly = '',
    List<CommentModel>? replies,
  }) : this.replies = replies ?? [] {
    // Parse parentId from comment if it follows pattern [re:ID]
    if (comment.startsWith('[re:')) {
      int endIdx = comment.indexOf(']');
      if (endIdx != -1) {
        parentId = comment.substring(4, endIdx);
        commentTextOnly = comment.substring(endIdx + 1).trim();
      } else {
        commentTextOnly = comment;
      }
    } else {
      commentTextOnly = comment;
    }
  }

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