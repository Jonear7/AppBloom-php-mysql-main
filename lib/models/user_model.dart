class UserData {
  final String username;
  final String email;
  final String phone;

  UserData({
    required this.username,
    required this.email,
    required this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
