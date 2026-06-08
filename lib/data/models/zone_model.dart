class ZoneModel {
  final String id;
  final String zoneName;
  final List<String> areas;
  final bool isActive;

  ZoneModel({
    required this.id,
    required this.zoneName,
    required this.areas,
    required this.isActive,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['_id'] ?? '',
      zoneName: json['zone'] ?? '',
      areas: List<String>.from(json['areas'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }
}