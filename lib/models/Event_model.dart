class EventModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String likesCount;
  final String categoryId;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.likesCount,
 profil
    this.categoryId = '',

    required this.categoryId,
 main
  });

  static String _getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'assets/images/Younifirst.png';
    if (path.startsWith('http')) return path;
    if (path.startsWith('assets/')) return path;

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    if (!cleanPath.startsWith('storage/')) {
      cleanPath = 'storage/$cleanPath';
    }
    return 'https://enlighten-resupply-usable.ngrok-free.dev/$cleanPath';
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
 profil
    // Coba berbagai kemungkinan nama key ID dari backend
    final rawId = json['id'] ?? json['event_id'] ?? json['eventId'] ?? json['_id'];
    final parsedId = rawId?.toString() ?? '';

    if (parsedId.isEmpty) {
      // ignore: avoid_print
      print('⚠️ WARNING: Event ID kosong! Keys tersedia: ${json.keys.toList()}');
    }

    return EventModel(
      id: parsedId,

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
 main
      title: json['title'] ?? 'Tanpa Judul',
      date: parsedDate,
      time: json['time'] ?? parsedTime,
      location: json['location'] ?? 'Lokasi tidak diketahui',
 profil
      imageUrl: _getFullImageUrl(json['poster_url'] ?? json['poster']),

      imageUrl: finalImageUrl,
 main
      likesCount: json['likes_count']?.toString() ?? '0',
      categoryId: json['category_id']?.toString() ?? '',
    );
  }
}
