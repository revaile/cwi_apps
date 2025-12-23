class UserModel {
  final String id;
  final String username;
  final int noKaryawan;
  final int noTelepon;

  UserModel({
    required this.id,
    required this.username,
    required this.noKaryawan,
    required this.noTelepon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['\$id'],
      username: json['username'] ?? '',
      noKaryawan: json['no_karyawan'] ?? 0,
      noTelepon: json['no_telepon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'no_karyawan': noKaryawan,
      'no_telepon': noTelepon,
    };
  }
}
