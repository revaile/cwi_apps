import 'package:appwrite/models.dart';
import '../services/appwrite_client.dart';

class AuthService {
  final _account = AppwriteService.account;

  Future<User> login(String email, String password) async {
    await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
    return await _account.get();
  }

  Future<void> logout() async {
    await _account.deleteSessions(); // hapus semua session
  }

  Future<User> getUser() async {
    return await _account.get();
  }

  Future<void> updateName(String name) async {
    await _account.updateName(name: name);
  }

  // email hanya bisa diupdate jika user tahu CURRENT password
  Future<void> updateEmail(String email, String currentPassword) async {
    await _account.updateEmail(
      email: email,
      password: currentPassword,
    );
  }

  // kalau nanti mau dipakai
  Future<void> updatePassword(String newPassword) async {
    await _account.updatePassword(password: newPassword);
  }
}
