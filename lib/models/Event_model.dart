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

    String rawImage = json['image_url'] ?? json['poster'] ?? 'assets/images/icon_login.png';
    String finalImageUrl = rawImage;
    if (!rawImage.startsWith('http') && !rawImage.startsWith('assets/')) {
      // Remove leading slash if any
      String path = rawImage.startsWith('/') ? rawImage.substring(1) : rawImage;
      
      // Jika path belum ada 'storage/', tambahkan
      if (!path.startsWith('storage/')) {
        path = 'storage/$path';
      }
      
      finalImageUrl = 'https://unelusive-lylah-goodheartedly.ngrok-free.dev/$path';
    }

    return EventModel(
      id: json['id']?.toString() ?? json['event_id']?.toString() ?? json['id_event']?.toString() ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      date: parsedDate,
      time: json['time'] ?? parsedTime,
      location: json['location'] ?? 'Lokasi tidak diketahui',
      imageUrl: finalImageUrl,
      likesCount: json['likes_count']?.toString() ?? '0',
    );
  }
}
