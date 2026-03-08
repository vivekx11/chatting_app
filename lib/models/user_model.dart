class UserModel {
  final String username;
  final String role;

  UserModel({
    required this.username,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String,
      role: json['role'] as String,
    );
  }

  bool get isAdmin => role == 'admin';
}
//
