class TeamModel {
  final String id;
  final String name;
  final String lombaName;
  final int maxMembers;
  final String description;
  final String status;
  final int joinedMembers;
  final String createdBy;

  TeamModel({
    required this.id,
    required this.name,
    required this.lombaName,
    required this.maxMembers,
    required this.description,
    required this.status,
    required this.joinedMembers,
    required this.createdBy,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['team_id']?.toString() ?? '',
      name: json['team_name'] ?? 'Tanpa Nama Tim',
      lombaName: json['competition_name'] ?? 'Tanpa Nama Lomba',
      maxMembers: json['max_member'] != null ? int.tryParse(json['max_member'].toString()) ?? 0 : 0,
      description: json['description'] ?? '',
      status: json['status']?.toString() ?? 'Open',
      joinedMembers: json['current_member_count'] != null ? int.tryParse(json['current_member_count'].toString()) ?? 0 : 0,
      createdBy: json['created_by']?.toString() ?? '',
    );
  }
}
