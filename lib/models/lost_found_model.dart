class LostFoundModel {
  final int id;
  final int? userId;
  final String userName;
  final String? userAvatar;
  final String type; // "Hilang" or "Ditemukan"
  final String itemName;
  final String location;
  final String description;
  final String? imageUrl;
  final String? createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isCompleted;

  LostFoundModel({
    required this.id,
    this.userId,
    required this.userName,
    this.userAvatar,
    required this.type,
    required this.itemName,
    required this.location,
    required this.description,
    this.imageUrl,
    this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isCompleted = false,
  });

  factory LostFoundModel.fromJson(Map<String, dynamic> json) {
    return LostFoundModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      userName: json['user']?['name'] ?? json['user_name'] ?? 'Unknown User',
      userAvatar: json['user']?['profile_picture'] ?? json['user_avatar'],
      type: json['type'] ?? 'Hilang',
      itemName: json['item_name'] ?? json['title'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['image'],
      createdAt: json['created_at'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'item_name': itemName,
      'location': location,
      'description': description,
      'image_url': imageUrl,
      'likes_count': likesCount,
      'comments_count': commentsCount,
    };
  }
}

class CommentModel {
  final int id;
  final int? userId;
  final String userName;
  final String? userAvatar;
  final String comment;
  final String? createdAt;

  CommentModel({
    required this.id,
    this.userId,
    required this.userName,
    this.userAvatar,
    required this.comment,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      userName: json['user']?['name'] ?? json['user_name'] ?? 'Unknown User',
      userAvatar: json['user']?['profile_picture'] ?? json['user_avatar'],
      comment: json['comment'] ?? json['body'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
