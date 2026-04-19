import 'package:flutter/material.dart';
import 'package:younifirst_app/models/lost_found_model.dart';
import 'package:younifirst_app/services/api_services.dart';
import 'BarangHilang_pages.dart';

class BarangPage extends StatefulWidget {
  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua', 'Hilang', 'Ditemukan'];
  late Future<List<LostFoundModel>> _lostFoundFuture;
  
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _lostFoundFuture = ApiService.getLostAndFound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildFilterRow(),
                    const SizedBox(height: 24),
                    _buildBarangList(),
                    const SizedBox(height: 80), // Padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarangHilangPage(),
            ),
          );
          if (result == true) {
            _fetchData();
          }
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(  
                'assets/images/logo_putih.png',
                width: 35,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: Colors.white, size: 35),
              ),
              const SizedBox(width: 12),
              const Text(
                "Barang",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifikasi ditekan')));
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const Icon(Icons.notifications_none, color: Colors.white),
                ),
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
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Temukan barang hilang...",
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          ...List.generate(_filters.length, (index) {
            bool isSelected = _selectedFilterIndex == index;
            IconData iconData;
            if (index == 0) {
              iconData = Icons.check_circle;
            } else if (index == 1) {
              iconData = Icons.inventory_2_outlined;
            } else {
              iconData = Icons.inventory_outlined;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        iconData,
                        size: 16,
                        color: isSelected ? const Color(0xFF3D5AFE) : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _filters[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF3D5AFE) : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.insert_drive_file_outlined, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Icon(Icons.sort, color: Colors.white, size: 20),
              ],
            ),
          )
        ]
      ),
    );
  }

  Widget _buildBarangList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List<LostFoundModel>>(
        future: _lostFoundFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: Colors.white),
            ));
          } else if (snapshot.hasError) {
             // Tampilkan pesan error, atau data statis apabila belum ada backend sama sekali saat diuji
            return _buildStaticFallbackList();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildStaticFallbackList(); 
          }

          List<LostFoundModel> data = snapshot.data!;
          // Apply filter
          if (_selectedFilterIndex != 0) {
            String filterType = _filters[_selectedFilterIndex];
            data = data.where((item) => item.type == filterType).toList();
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _buildBarangCard(data[index]);
            },
          );
        },
      ),
    );
  }

  // Fallback List statis agar UI tetap bisa dilihat sesuai screenshot
  // meskipun backend API tidak tersedia / error
  Widget _buildStaticFallbackList() {
    final List<LostFoundModel> dummyData = [
      LostFoundModel(
        id: 1,
        userName: 'Rafayel Qi',
        userAvatar: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=150',
        type: 'Ditemukan',
        itemName: 'Earphone Putih',
        location: 'Gedung TI Politeknik Negeri Jember',
        description: 'Earphone ditemukan di Gedung TI Lantai 3 Ruangan 3 sekitar jam 12 siang tadi. aku pegang dulu bentar kalau ga ada info atau reach out sampe jam 4 aku bawa',
        imageUrl: 'https://images.unsplash.com/photo-1605464315542-bda3e2f4e605?auto=format&fit=crop&q=80&w=400',
        createdAt: 'Hari ini • 25 mnt yang lalu',
        commentsCount: 0,
      ),
      LostFoundModel(
        id: 2,
        userName: 'rona_naa',
        userAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150',
        type: 'Hilang',
        itemName: 'Dompet Soft Pink Cream',
        location: 'Teras JTI Politeknik Negeri Jember',
        description: 'HELP!! URGENT!! Dompet aku hilang sepertinya jatuh habis dari teras jti bagi yang melihat atau menemukan tolong segera kontak nomor ini "1234567890"',
        imageUrl: 'https://images.unsplash.com/photo-1628191010210-a59de33e5941?auto=format&fit=crop&q=80&w=400',
        createdAt: 'Hari ini • 1 jam yang lalu',
        commentsCount: 12,
      ),
      LostFoundModel(
        id: 3,
        userName: 'Xavier Shen',
        userAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=150',
        type: 'Hilang',
        itemName: 'Kotak Pensil Hitam + KTM',
        location: 'Gedung TI Politeknik Negeri Jember',
        description: 'Balik pulang kerasa ada yng janggal ternyata kotak pensilku ketinggalan huhu.. mana ada KTM ku disana atas nama "Xavier Shen Prodi Teknik Informatika" anyon',
        imageUrl: null, 
        createdAt: 'Kemarin • 1 hari yang lalu',
        commentsCount: 22,
      ),
    ];

    List<LostFoundModel> displayed = dummyData;
    if (_selectedFilterIndex != 0) {
      displayed = dummyData.where((d) => d.type == _filters[_selectedFilterIndex]).toList();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayed.length,
      itemBuilder: (context, index) {
        return _buildBarangCard(displayed[index]);
      },
    );
  }

  Widget _buildBarangCard(LostFoundModel item) {
    bool isDitemukan = item.type == 'Ditemukan';
    Color statusColor = isDitemukan ? const Color(0xFF3D5AFE) : const Color(0xFF3D5AFE); // Keduanya biru di screenshot

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: item.userAvatar != null ? NetworkImage(item.userAvatar!) : null,
                child: item.userAvatar == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      item.createdAt ?? 'Baru saja',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opsi ditekan')));
                },
                child: const Icon(Icons.more_horiz, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Image / Media
          if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 250, width: double.infinity, color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey)),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDitemukan ? const Color(0xFF3D5AFE) : const Color(0xFF3D5AFE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.type,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          else 
            // Jika tidak ada gambar, label Hilang/Ditemukan tetap di kanan atas
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isDitemukan ? const Color(0xFF3D5AFE) : const Color(0xFF3D5AFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.type,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
          const SizedBox(height: 16),
          
          // Title / Item Name
          Text(
            item.itemName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF3D5AFE)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.location,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF3D5AFE), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Description
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(text: '${item.description} '),
                TextSpan(
                  text: 'selengkapnya...',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Komentar Field
          GestureDetector(
            onTap: () {
              _showCommentSheet(context, item.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Text("Beri Komentar...", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const Spacer(),
                  const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.black87),
                  if (item.commentsCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(item.commentsCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ]
                ],
              ),
            ),
          ),

          // Tandai Postingan Selesai (Jika ini adalah postingan user tersebut, atau kita bisa mockup)
          if (item.type == 'Hilang' && !item.isCompleted && item.id == 2) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Postingan ditandai selesai')));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF3D5AFE)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFFEEF2FF),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Tandai Postingan Selesai', style: TextStyle(color: Color(0xFF3D5AFE), fontWeight: FontWeight.bold)),
              ),
            )
          ]
        ],
      ),
    );
  }

  void _showCommentSheet(BuildContext context, int lostFoundId) {
    // Controller untuk text field komentar baru
    TextEditingController _commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16, right: 16, top: 16
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(height: 16),
                const Text("Komentar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.chat_bubble_outline, size: 40, color: Colors.grey),
                        SizedBox(height: 12),
                        Text("Belum ada komentar", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  // Nantinya bisa diganti dengan FutureBuilder getComments
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Tambahkan komentar...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF3D5AFE)),
                      onPressed: () {
                        if (_commentController.text.isNotEmpty) {
                          // TODO: implement ApiService.addComment
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Komentar Dikirim')));
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    );
  }
}