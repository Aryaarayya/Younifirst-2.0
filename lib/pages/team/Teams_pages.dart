import 'package:flutter/material.dart';
import 'package:younifirst_app/pages/team/Tambahteams_pages.dart';
import 'package:younifirst_app/models/Teams_model.dart';
import 'package:younifirst_app/services/team_api_service.dart';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<TeamModel> teams = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final fetchedTeams = await TeamApiService.getTeams();
      setState(() {
        teams = fetchedTeams;
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
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildTeamList(),
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
              builder: (context) => TambahTeamsPage(),
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
      child: Row(
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
                    "Teams",
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
                    style: TextStyle(color: Colors.white, fontSize: 10),
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
                  hintText: "Temukan team...",
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
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
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
            icon,
            size: 16,
            color: isSelected ? const Color(0xFF3D5AFE) : Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3D5AFE) : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamList() {
    if (isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
            child: Text(errorMessage, style: const TextStyle(color: Colors.red))),
      );
    }

    if (teams.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
            child: Text("Belum ada tim.", 
                       style: TextStyle(color: Colors.black54))),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator(
        onRefresh: fetchTeams,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final t = teams[index];
            // Dummy list members for now
            List<String> dumpMembers = List.generate(t.joinedMembers > 0 ? t.joinedMembers : 1, (i) => i.toString());
            // Safe max members
            int maxMm = t.maxMembers > 0 ? t.maxMembers : 4;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: teamCard(
                title: t.name,
                subtitle: t.lombaName,
                desc: t.description,
                status: t.status,
                isOpen: t.status.toLowerCase() == 'open',
                members: dumpMembers,
                total: "\${t.joinedMembers}/\$maxMm Anggota",
                tags: ["General"], // Backend belum sedia tags, fallback
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔥 CARD TEAM
  Widget teamCard({
    required String title,
    required String subtitle,
    required String desc,
    required String status,
    required bool isOpen,
    required List<String> members,
    required String total,
    required List<String> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER CARD
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isOpen ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 5),
          Text(desc, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          // TAG
          Wrap(
            spacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(color: Color(0xFF3D5AFE), fontSize: 12),
                ),
              );
            }).toList(),
          ),
          const Divider(height: 24),
          // MEMBER + TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: members.map((e) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
              Text(
                total,
                style: const TextStyle(color: Color(0xFF3D5AFE), fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }
}