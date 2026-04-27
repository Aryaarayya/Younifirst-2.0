import 'package:flutter/material.dart';
import 'package:younifirst_app/services/announcement_api_service.dart';
import 'package:younifirst_app/pages/announcement/Announcement_pages.dart';

/// Widget tombol lonceng notifikasi yang bisa digunakan di AppBar
/// manapun di seluruh aplikasi.
///
/// Contoh penggunaan:
/// ```dart
/// AppBar(
///   actions: [NotificationBell()],
/// )
/// ```
class NotificationBell extends StatefulWidget {
  /// Warna ikon lonceng — default putih (untuk AppBar berwarna)
  final Color iconColor;

  const NotificationBell({Key? key, this.iconColor = Colors.white})
      : super(key: key);

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell>
    with SingleTickerProviderStateMixin {
  int _unreadCount = 0;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    // Animasi shake lonceng
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );

    _fetchUnread();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchUnread() async {
    try {
      final items = await AnnouncementApiService.getAnnouncements();
      if (mounted) {
        final newCount = items.where((e) => e.isNew).length;
        if (newCount > 0 && newCount != _unreadCount) {
          _shakeCtrl.repeat(reverse: true);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) _shakeCtrl.stop();
          });
        }
        setState(() => _unreadCount = newCount);
      }
    } catch (_) {
      // Abaikan error fetch — badge tidak muncul
    }
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AnnouncementPage()),
    );
    // Refresh count setelah kembali dari halaman notifikasi
    _fetchUnread();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Tombol lonceng dengan animasi shake
          AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) => Transform.rotate(
              angle: _shakeAnim.value,
              child: child,
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: widget.iconColor,
                size: 26,
              ),
              onPressed: _openNotifications,
              tooltip: 'Notifikasi',
            ),
          ),

          // Badge angka unread
          if (_unreadCount > 0)
            Positioned(
              right: 6,
              top: 6,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    _unreadCount > 9 ? '9+' : '$_unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
