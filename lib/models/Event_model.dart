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
    String parsedDate = 'Tanggal tidak diketahui';
    String parsedTime = '';

    if (json['start_date'] != null) {
      try {
        DateTime dt = DateTime.parse(json['start_date']);
        parsedDate = "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
        parsedTime = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        parsedDate = json['start_date'].toString().split(' ').first;
      }
    } else if (json['date'] != null) {
      parsedDate = json['date'];
    }

    return EventModel(
      id: json['id']?.toString() ?? json['event_id']?.toString() ?? json['id_event']?.toString() ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      date: parsedDate,
      time: json['time'] ?? parsedTime,
      location: json['location'] ?? 'Lokasi tidak diketahui',
      imageUrl: json['image_url'] ?? json['poster'] ?? 'assets/images/Younifirst.png', // Default image sementara
      likesCount: json['likes_count']?.toString() ?? '0',
    );
  }
}
