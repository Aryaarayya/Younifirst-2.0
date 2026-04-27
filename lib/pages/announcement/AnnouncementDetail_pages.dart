import 'package:flutter/material.dart';
import 'package:younifirst_app/models/Announcement_model.dart';
import 'package:younifirst_app/services/announcement_api_service.dart';
import 'package:younifirst_app/pages/announcement/AnnouncementForm_pages.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailPage({Key? key, required this.announcement})
      : super(key: key);

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  late AnnouncementModel _item;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _item = widget.announcement;
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengumuman'),
        content: const Text('Apakah kamu yakin ingin menghapus pengumuman ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _isDeleting = true);

    try {
      await AnnouncementApiService.deleteAnnouncement(_item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pengumuman berhasil dihapus'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _openEdit() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => AnnouncementFormPage(existing: _item)),
    );
    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _item.category ?? 'umum';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // Header biru
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFF1A237E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar custom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Detail Pengumuman',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        onSelected: (val) {
                          if (val == 'edit') _openEdit();
                          if (val == 'delete') _delete();
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ]),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(children: [
                              Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              SizedBox(width: 10),
                              Text('Hapus', style: TextStyle(color: Colors.red)),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Card konten
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 6))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Badge kategori + status
                              Row(
                                children: [
                                  _CategoryBadge(category: category),
                                  const SizedBox(width: 8),
                                  if (_item.status != null)
                                    _StatusBadge(status: _item.status!),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Judul
                              Text(
                                _item.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Info user + waktu
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: const Color(0xFFE8EAFF),
                                    child: Text(
                                      (_item.userNama ?? 'U').substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFF3D5AFE),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _item.userNama ?? 'Pengguna',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          _item.timeAgo,
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              const Divider(color: Colors.black12),
                              const SizedBox(height: 16),

                              // Isi konten
                              Text(
                                _item.content,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay saat delete
          if (_isDeleting)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x88000000),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),

      // Tombol Edit bawah
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isDeleting ? null : _delete,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                  label: const Text('Hapus',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isDeleting ? null : _openEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D5AFE),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                  label: const Text('Edit Pengumuman',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper widgets ────────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> map = {
      'event': {'label': 'Event', 'color': Colors.orange, 'icon': Icons.calendar_today},
      'team': {'label': 'Team', 'color': Colors.green, 'icon': Icons.group},
      'barang': {'label': 'Barang', 'color': Colors.purple, 'icon': Icons.inventory_2_outlined},
      'umum': {'label': 'Umum', 'color': const Color(0xFF3D5AFE), 'icon': Icons.campaign_outlined},
    };
    final info = map[category] ?? map['umum']!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (info['color'] as Color).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info['icon'] as IconData, color: info['color'] as Color, size: 14),
          const SizedBox(width: 6),
          Text(
            info['label'] as String,
            style: TextStyle(
                color: info['color'] as Color,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status == 'confirmed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isConfirmed
            ? Colors.green.withOpacity(0.12)
            : Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isConfirmed ? '✓ Dikonfirmasi' : '⏳ Menunggu',
        style: TextStyle(
          color: isConfirmed ? Colors.green : Colors.orange,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
