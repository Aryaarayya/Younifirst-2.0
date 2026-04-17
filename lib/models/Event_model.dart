class EventModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String likesCount;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.likesCount,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      date: json['date'] ?? 'Tanggal tidak diketahui',
      time: json['time'] ?? '',
      location: json['location'] ?? 'Lokasi tidak diketahui',
      imageUrl: json['image_url'] ?? 'assets/images/Younifirst.png', // Default image sementara
      likesCount: json['likes_count']?.toString() ?? '0',
    );
  }
}
