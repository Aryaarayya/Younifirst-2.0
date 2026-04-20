import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:younifirst_app/models/Event_model.dart';
import 'package:younifirst_app/services/event_api_service.dart';
import 'package:younifirst_app/pages/event/TambahEvent_pages.dart';
import 'package:younifirst_app/pages/event/UpdateEvent_pages.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  List<EventModel> events = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final fetchedEvents = await EventApiService.getEvents();
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
      print("Fetch Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Blue Background Top
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFF3D5AFE),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildPopularEventsHeader(),
                  const SizedBox(height: 16),
                  _buildPopularEventsList(),
                  const SizedBox(height: 24),
                  _buildCategoryHeader(),
                  const SizedBox(height: 12),
                  _buildCategoryChips(),
                  const SizedBox(height: 16),
                  _buildEventGrid(),
                  const SizedBox(height: 80), // Padding for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahEventPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFF3D5AFE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(  
                    'assets/images/logo_putih.png',
                    width: 35,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Event",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Icon(Icons.notifications_none,
                        color: Colors.white),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "2",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Temukan events...",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularEventsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Popular Events 🔥",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "LIHAT SEMUA",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularEventsList() {
    if (isLoading) {
      return const SizedBox(
        height: 380,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (errorMessage.isNotEmpty) {
      return SizedBox(
        height: 380,
        child: Center(
            child: Text(errorMessage, style: const TextStyle(color: Colors.white))),
      );
    }

    if (events.isEmpty) {
      return const SizedBox(
        height: 380,
        child: Center(
            child: Text("Belum ada event populer.", 
                       style: TextStyle(color: Colors.white))),
      );
    }

    // Tampilkan 2 atau 3 event di header
    final popularEvents = events.take(3).toList();

    return SizedBox(
      height: 380,
      child: RefreshIndicator(
        onRefresh: fetchEvents,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: popularEvents.length,
          itemBuilder: (context, index) {
            final ev = popularEvents[index];
            return _buildEventCard(
              id: ev.id,
              imageUrl: ev.imageUrl, // Bisa ditambahkan network logic jika url valid
              title: ev.title,
              date: ev.date,
              time: ev.time,
              location: ev.location,
              likes: ev.likesCount,
              onDelete: () => _deleteEvent(ev.id),
            );
          },
        ),
      ),
    );
  }

  Future<void> _deleteEvent(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Event'),
        content: const Text('Apakah Anda yakin ingin menghapus event ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      await EventApiService.deleteEvent(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event berhasil dihapus')),
      );
      fetchEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Widget _buildEventCard({
    required String id,
    required String imageUrl,
    required String title,
    required String date,
    required String time,
    required String location,
    required String likes,
    required VoidCallback onDelete,
  }) {
    // Mengecek apakah image_url berupa http link atau lokal asset
    bool isNetworkImage = imageUrl.toLowerCase().startsWith('http');

    return GestureDetector(
      onTap: () async {
        if (id.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID event tidak valid dari server')));
          return;
        }
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateEventPage(eventId: id),
          ),
        );
        if (result == true) {
          fetchEvents(); // Refresh data if updated
        }
      },
      child: Container(
        width: 260,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300], // Fallback if image fails
              child: isNetworkImage
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    )
                  : Image.asset(
                      'assets/images/Younifirst.png', // default placeholder
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF3D5AFE)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        time.isNotEmpty ? "$date • $time" : date,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF3D5AFE)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite,
                            size: 16,
                            color: likes == "0" ? Colors.grey : Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          likes,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Ikon delete dihapus
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D5AFE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Text("Mulai",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
    );
  }

  Widget _buildCategoryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Pilih berdasarkan Kategori ✨",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "LIHAT SEMUA",
            style: TextStyle(
                color: Color(0xFF3D5AFE),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildChip("Semua", Icons.check_circle, true),
          _buildChip("Kompetisi", Icons.emoji_events_outlined, false),
          _buildChip("Seminar", Icons.mic_none, false),
          _buildChip("Pameran", Icons.palette_outlined, false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3D5AFE) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF3D5AFE) : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF3D5AFE),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF3D5AFE),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventGrid() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
          child: IconButton(
              icon: Icon(Icons.refresh), onPressed: fetchEvents)); 
    }

    if (events.isEmpty) {
      return const Center(child: Text("Tidak ada data."));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final ev = events[index];
          return _buildMiniEventCard(
            id: ev.id,
            imageUrl: ev.imageUrl,
            title: ev.title,
            date: ev.date,
            time: ev.time,
            location: ev.location,
            likes: ev.likesCount,
            liked: int.tryParse(ev.likesCount) != null && int.parse(ev.likesCount) > 0, // dummy logic for liked statis
            onDelete: () => _deleteEvent(ev.id),
          );
        },
      ),
    );
  }

  Widget _buildMiniEventCard({
    required String id,
    required String imageUrl,
    required String title,
    required String date,
    required String time,
    required String location,
    required String likes,
    required bool liked,
    required VoidCallback onDelete,
  }) {
    bool isSkeleton = title == "Loading...";
    bool isNetworkImage = imageUrl.toLowerCase().startsWith('http');

    return GestureDetector(
      onTap: () async {
        if (!isSkeleton) {
          if (id.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID event tidak valid dari server')));
            return;
          }
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateEventPage(eventId: id),
            ),
          );
          if (result == true) {
            fetchEvents(); // Refresh data if updated
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[300],
              child: isSkeleton
                  ? null
                  : (isNetworkImage
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image, color: Colors.grey),
                        )
                      : Image.asset(
                          'assets/images/Younifirst.png', // dummy placeholder
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image, color: Colors.grey),
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isSkeleton
                    ? Container(height: 12, width: 80, color: Colors.grey[300])
                    : Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 10,
                        color: isSkeleton
                            ? Colors.grey[400]
                            : const Color(0xFF3D5AFE)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: isSkeleton
                          ? Container(
                              height: 10,
                              color: Colors.grey[300],
                              margin: EdgeInsets.only(bottom: 2))
                          : Text(
                              time.isNotEmpty ? "$date • $time" : date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 9),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 10,
                        color: isSkeleton
                            ? Colors.grey[400]
                            : const Color(0xFF3D5AFE)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: isSkeleton
                          ? Container(height: 10, color: Colors.grey[300])
                          : Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 9),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite,
                            size: 14,
                            color: isSkeleton
                                ? Colors.grey[400]
                                : (liked ? Colors.red : Colors.grey)),
                        const SizedBox(width: 4),
                        isSkeleton
                            ? Container(
                                height: 10, width: 10, color: Colors.grey[300])
                            : Text(
                                likes,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                      ],
                    ),
                    Row(
                      children: [
                        // Ikon delete dihapus
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSkeleton
                                ? Colors.grey[400]
                                : const Color(0xFF3D5AFE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              if (!isSkeleton)
                                const Text("Mulai",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              if (isSkeleton)
                                Container(
                                    width: 20, height: 8, color: Colors.grey[300]),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 10),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}
