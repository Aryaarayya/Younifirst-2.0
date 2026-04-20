import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Blue Background Top
            Container(
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFF3D5AFE),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                  
                  // White panel containing feeds
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6), // Match background of feed (slightly grayish or white)
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildFeedCard(
                          username: 'rona_naa',
                          timeAgo: 'Hari ini • 1 jam yang lalu',
                          userImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=150',
                          postImage: 'assets/images/Younifirst.png', // Fallback, we'll use network image if possible or simple icon
                          imageNetwork: 'https://images.unsplash.com/photo-1628151015968-3e4407887e22?q=80&w=600&auto=format&fit=crop', // dompet
                          badgeText: 'Hilang',
                          title: 'Dompet Soft Pink Cream',
                          location: 'Teras JTI Politeknik Negeri Jember',
                          description: 'HELP!! URGENT!! Dompet aku hilang sepertinya jatuh habis dari teras jti bagi yang melihat atau menemukan tolong segera kontak nomor ini "1234567890" selengkapnya...',
                          comments: 22,
                        ),

                        // Popular Events
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Popular Events 🔥",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "LIHAT SEMUA",
                                style: TextStyle(
                                  color: Color(0xFF3D5AFE),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPopularEventsList(),
                        const SizedBox(height: 20),

                        _buildFeedCard(
                          username: 'Xavier Shen',
                          timeAgo: 'Kemarin • 1 hari yang lalu',
                          userImage: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=150',
                          postImage: '', 
                          badgeText: 'Hilang',
                          title: 'Kotak Pensil Hitam + KTM',
                          location: 'Gedung TI Politeknik Negeri Jember',
                          description: 'Balik pulang kerasa ada yng janggal ternyata kotak pensilku ketinggalan huhu.. mana ada KTM ku disana atas nama "Xavier Shen Prodi Teknik Informatika" anyon selengkapnya...',
                          comments: 10,
                          hasImage: false,
                        ),

                        _buildFeedCard(
                          username: 'Rafayel Qi',
                          timeAgo: 'Hari ini • 25 mnt yang lalu',
                          userImage: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=150',
                          postImage: '',
                          imageNetwork: 'https://images.unsplash.com/photo-1606220588913-b3aecb3b0dfb?q=80&w=600&auto=format&fit=crop', // earphone
                          badgeText: 'Ditemukan',
                          title: 'Earphone Putih',
                          location: 'Gedung TI Politeknik Negeri Jember',
                          description: 'Earphone ditemukan di Gedung TI Lantai 3 Ruangan 3.1 sekitar jam 12 siang tadi. aku pegang dulu bentar kalau ga ada info atau reach out sampe jam 4 aka wa selengkapnya...',
                          comments: 12,
                          isMyPost: true,
                        ),

                        // Cari Tim Sesuai Untukmu
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Cari Tim Sesuai Untukmu🔥",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "LIHAT SEMUA",
                                style: TextStyle(
                                  color: Color(0xFF3D5AFE),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCariTimList(),
                        const SizedBox(height: 100), // padding bottom
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=150', // Profil dummy
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Selamat datang kembali👋",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Rafayel Qi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
                child: const Icon(Icons.notifications_none, color: Colors.white),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
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
                  hintText: "Mulai cari...",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(CupertinoIcons.search, color: Colors.white),
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
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Color(0xFF3D5AFE), size: 16),
                SizedBox(width: 6),
                Text(
                  "Untuk Anda",
                  style: TextStyle(
                    color: Color(0xFF3D5AFE),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.new_releases_outlined, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  "Postingan Terbaru",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard({
    required String username,
    required String timeAgo,
    required String userImage,
    required String postImage,
    String? imageNetwork,
    required String badgeText,
    required String title,
    required String location,
    required String description,
    required int comments,
    bool isMyPost = false,
    bool hasImage = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      padding: const EdgeInsets.all(16),
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
          // Header user info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      userImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),

          // Post image if hasImage
          if (hasImage) 
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageNetwork != null
                      ? Image.network(
                          imageNetwork,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          postImage.isNotEmpty ? postImage : 'assets/images/Younifirst.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.image, size: 50, color: Colors.grey)),
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D5AFE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          
          if(!hasImage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D5AFE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

          if (hasImage) const SizedBox(height: 12),
          if (hasImage)
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF3D5AFE)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Color(0xFF3D5AFE), fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),

          Row(
            children: [
              const Expanded(
                child: Text(
                  "Beri Komentar...",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const Icon(CupertinoIcons.chat_bubble, size: 20, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                "\$comments",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),

          if (isMyPost) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8EAFF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF3D5AFE)),
                  ),
                ),
                child: const Text(
                  "Tandai Postingan Selesai",
                  style: TextStyle(
                    color: Color(0xFF3D5AFE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildPopularEventsList() {
    return SizedBox(
      height: 265, // Diubah menjadi lebih tinggi 15 pixel agar tak terpotong container
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildMiniEventCard(
            imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=600&auto=format&fit=crop',
            title: "Seminar - Understanding Art'...",
            date: "22 April 2026",
            time: "09:00 - 10:00 WIB",
            location: "Auditorium Politeknik Negeri Jember",
            likes: "10",
          ),
          _buildMiniEventCard(
            imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=600&auto=format&fit=crop',
            title: "ARIRANG",
            date: "18 April 2026 - 28 April 2026",
            time: "",
            location: "Lapangan Hijau A3",
            likes: "28",
            liked: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniEventCard({
    required String imageUrl,
    required String title,
    required String date,
    required String time,
    required String location,
    required String likes,
    bool liked = false,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
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
          // Image logic
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Color(0xFF3D5AFE)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        time.isNotEmpty ? "$date • $time" : date,
                        style: const TextStyle(color: Colors.black54, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF3D5AFE)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54, fontSize: 10),
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
                        Icon(Icons.favorite, size: 16, color: liked ? Colors.red : Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          likes,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D5AFE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Text("Mulai", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 12),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCariTimList() {
    return Column(
      children: [
        _buildTeamCard("Cocomelon", "GEMASTIK 2026", "Mencari anggota untuk pengembangan perangkat lunak. Dibutuhkan UI/UX des...", "2/4"),
        _buildTeamCard("Creative Minds", "National UI/UX Design Competition", "Tim kreatif untuk kompetisi UI/UX nasional. Kami berfokus pada desain u...", "2/3"),
        _buildTeamCard("Creative Minds", "National UI/UX Design Competition", "Tim kreatif untuk kompetisi UI/UX nasional. Kami berfokus pada desain u...", "1/3"),
      ],
    );
  }

  Widget _buildTeamCard(String title, String event, String desc, String members) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people_outline, color: Color(0xFF3D5AFE)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.arrow_forward, size: 10, color: Color(0xFF3D5AFE)),
                    const SizedBox(width: 4),
                    Text(
                      event,
                      style: const TextStyle(color: Color(0xFF3D5AFE), fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Open",
                  style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  members,
                  style: const TextStyle(color: Color(0xFF3D5AFE), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}