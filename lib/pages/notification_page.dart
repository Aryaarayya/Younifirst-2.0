import 'package:flutter/material.dart';
import 'package:younifirst_app/models/notification_model.dart';
import 'package:younifirst_app/models/announcement_model.dart';
import 'package:younifirst_app/services/notification_service.dart';
import 'package:younifirst_app/services/api_services.dart';
import 'package:younifirst_app/pages/barang/BarangDetail_pages.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<dynamic>> _allNotificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadAllNotifications();
  }

  void _loadAllNotifications() {
    setState(() {
      _allNotificationsFuture = _fetchAll();
    });
  }

  Future<List<dynamic>> _fetchAll() async {
    try {
      final localNotifications = await NotificationService.getNotifications();
      final announcements = await ApiService.getAnnouncements();

      List<dynamic> combined = [];
      combined.addAll(localNotifications);
      combined.addAll(announcements);

      // Sort by timestamp/createdAt descending
      combined.sort((a, b) {
        DateTime dateA = (a is NotificationModel) ? a.timestamp : (a as AnnouncementModel).createdAt;
        DateTime dateB = (b is NotificationModel) ? b.timestamp : (b as AnnouncementModel).createdAt;
        return dateB.compareTo(dateA);
      });

      return combined;
    } catch (e) {
      print('Error fetching notifications: $e');
      // If API fails, return local notifications at least
      return await NotificationService.getNotifications();
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mnt lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              // Filter logic if needed
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _allNotificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            List<dynamic> items = snapshot.data!;
            
            // Grouping logic
            List<dynamic> baru = [];
            List<dynamic> hariIni = [];
            List<dynamic> lainnya = [];

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            for (var item in items) {
              DateTime date = (item is NotificationModel) ? item.timestamp : (item as AnnouncementModel).createdAt;
              Duration diff = now.difference(date);
              
              if (diff.inHours < 1) {
                baru.add(item);
              } else if (date.isAfter(today)) {
                hariIni.add(item);
              } else {
                lainnya.add(item);
              }
            }

            return ListView(
              children: [
                if (baru.isNotEmpty) ...[
                  _buildSectionHeader("Baru"),
                  ...baru.map((item) => _buildNotificationTile(item)).toList(),
                ],
                if (hariIni.isNotEmpty) ...[
                  _buildSectionHeader("Hari ini"),
                  ...hariIni.map((item) => _buildNotificationTile(item)).toList(),
                ],
                if (lainnya.isNotEmpty) ...[
                  _buildSectionHeader("Sebelumnya"),
                  ...lainnya.map((item) => _buildNotificationTile(item)).toList(),
                ],
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(dynamic item) {
    String title = "";
    String content = "";
    DateTime date;
    bool isRead = false;
    String? category;

    if (item is NotificationModel) {
      title = item.title;
      content = item.message;
      date = item.timestamp;
      isRead = item.isRead;
    } else {
      AnnouncementModel announcement = item as AnnouncementModel;
      title = announcement.title;
      content = announcement.content;
      date = announcement.createdAt;
      isRead = false; // Announcements don't have local read status yet, treat as new if needed
      category = announcement.creatorName;
    }

    return InkWell(
      onTap: () {
        if (item is NotificationModel) {
          if (!item.isRead) {
            NotificationService.markAsRead(item.id);
            _loadAllNotifications();
          }
          
          if (item.targetId != null && (item.type == 'post' || item.type == 'comment')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarangDetailPage(lostFoundId: item.targetId!),
              ),
            );
          }
        } else if (item is AnnouncementModel) {
          _showAnnouncementDetail(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue dot for unread
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(top: 15, right: 8),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 16),
            
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              child: Icon(
                item is NotificationModel ? Icons.comment : Icons.campaign,
                color: Colors.blue[800],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(date),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            
            // Optional image on right (matching mockup)
            if (item is AnnouncementModel && item.file != null)
               Container(
                 margin: const EdgeInsets.only(left: 8),
                 width: 50,
                 height: 50,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8),
                   color: Colors.grey[200],
                   image: DecorationImage(
                     image: NetworkImage(item.file!), // Assuming URL
                     fit: BoxFit.cover,
                   ),
                 ),
               ),
          ],
        ),
      ),
    );
  }
  void _showAnnouncementDetail(AnnouncementModel announcement) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (announcement.file != null)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    announcement.file!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D5AFE).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "PENGUMUMAN",
                            style: TextStyle(color: Color(0xFF3D5AFE), fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('dd MMM yyyy').format(announcement.createdAt),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      announcement.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      announcement.content,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person, size: 16, color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.creatorName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              announcement.creatorRole,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D5AFE),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("TUTUP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
