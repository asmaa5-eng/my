class User {
  String name;
  String email;
  String password;
  int companyId;
  int organizationLevelId;
  int managerId;
  double latitude;
  double longitude;
  String image;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.companyId,
    required this.organizationLevelId,
    required this.managerId,
    required this.latitude,
    required this.longitude,
    required this.image,
  });

  // --- copyWith لتحديث جزئي آمن ---
  User copyWith({
    String? name,
    String? email,
    String? password,
    int? companyId,
    int? organizationLevelId,
    int? managerId,
    double? latitude,
    double? longitude,
    String? image,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      companyId: companyId ?? this.companyId,
      organizationLevelId: organizationLevelId ?? this.organizationLevelId,
      managerId: managerId ?? this.managerId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      image: image ?? this.image,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      companyId: (json['company_id'] as num?)?.toInt() ?? 0,
      organizationLevelId:
          (json['organization_level_id'] as num?)?.toInt() ?? 0,
      managerId: (json['manager_id'] as num?)?.toInt() ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'company_id': companyId,
      'organization_level_id': organizationLevelId,
      'manager_id': managerId,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
    };
  }
}
