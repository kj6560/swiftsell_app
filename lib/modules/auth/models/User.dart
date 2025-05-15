class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String number;
  String? profilePic;
  int orgId;
  int? role;
  String? createdAt;
  String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.number,
    required this.orgId,
    this.role,
    this.profilePic,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      number: json['number'],
      orgId: json['org_id'],
      role: json['role'],
      profilePic: json['profile_pic'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'number': number,
      'profile_pic':profilePic,
      'org_id': orgId,
      'role':role,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
