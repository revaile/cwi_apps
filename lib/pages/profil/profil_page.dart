import 'package:appwrite/models.dart' hide Row;
import 'package:cwi_apps/models/user_model.dart';
import 'package:cwi_apps/services/auth_service.dart';
import 'package:cwi_apps/services/user_services.dart';
import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final userService = UserServices();

    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          UserServices().getUserProfile(), // <-- UserModel (DB)
          AuthService().getUser(), // <-- User (Auth)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Gagal memuat data user"));
          }

          final results = snapshot.data!;
          final user = results[0] as UserModel; // DB
          final authUser = results[1] as User; // Auth
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== HEADER CARD =====
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi,', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text(
                              authUser.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Admin',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'No. Karyawan',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            user.noKaryawan.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== FORM CARD =====
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _ProfileField(label: 'Nama', value: authUser.name),
                      _ProfileField(
                        label: 'No. Karyawan',
                        value: user.noKaryawan.toString(),
                      ),
                      _ProfileField(
                        label: 'No. Telepon',
                        value: user.noTelepon.toString(),
                      ),
                      _ProfileField(label: 'Username', value: user.username),
                      _ProfileField(label: 'Email', value: authUser.email),
                      _ProfileField(
                        label: 'Password',
                        value: '**************',
                        isPassword: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ===== BUTTONS =====
                BtnWidget(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/edit-profil',
                      arguments: {"profile": user, "auth": authUser},
                    );

                    if (result == true) {
                      setState(() {
                        Navigator.pop(context, true); // ⬅️ KIRIM KE HOME
                      }); // 🔥 REBUILD FutureBuilder
                    }
                  },
                  width: 350,
                  height: 40,
                  text: "Edit",
                  bgcolor: Colors.blue,
                  textstyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  isUpercase: true,
                ),

                const SizedBox(height: 12),
                BtnWidget(
                  onTap: () async {
                    await auth.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  width: 350,
                  height: 40,
                  text: "Logout",
                  bgcolor: Colors.red,
                  textstyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  isUpercase: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;

  const _ProfileField({
    required this.label,
    required this.value,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isPassword)
                const Icon(Icons.visibility_off, size: 18, color: Colors.grey),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
