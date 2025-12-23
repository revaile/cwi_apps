import 'package:appwrite/models.dart';
import 'package:cwi_apps/models/user_model.dart';
import 'package:cwi_apps/services/auth_service.dart';
import 'package:cwi_apps/services/user_services.dart';
import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:flutter/material.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final userService = UserServices();
  final auth = AuthService();

  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final noKarC = TextEditingController();
  final phoneC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  late UserModel profile;
  late User authUser;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    profile = args["profile"] as UserModel;
    authUser = args["auth"] as User;

    // Prefill
    nameC.text = authUser.name;
    emailC.text = authUser.email;
    usernameC.text = profile.username;
    noKarC.text = profile.noKaryawan.toString();
    phoneC.text = profile.noTelepon.toString();

    _initialized = true;
  }

  bool _obscurePassword = true;

  Future<void> save() async {
    try {
      final authUser = await auth.getUser();

      // Update Auth
      await auth.updateName(nameC.text);
      // Update Name
      // Update email hanya kalau benar-benar berubah
      if (emailC.text != authUser.email) {
        if (passwordC.text.isEmpty) {
          throw "Masukkan password saat ini untuk mengganti email";
        }

        await auth.updateEmail(emailC.text, passwordC.text);
      }

      // if (passwordC.text.isNotEmpty) {
      //   await auth.updatePassword(passwordC.text);
      // }

      // Update DB
      await userService.updateUserProfile(
        UserModel(
          id: authUser.$id,
          username: usernameC.text,
          noKaryawan: int.tryParse(noKarC.text) ?? 0,
          noTelepon: int.tryParse(phoneC.text) ?? 0,
        ),
      );

      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil update profil")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal update: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Edit Profil"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              buildField("Nama", nameC),
              buildField(
                "No. Karyawan",
                noKarC,
                keyboardType: TextInputType.number,
              ),
              buildField(
                "No. Telepon",
                phoneC,
                keyboardType: TextInputType.phone,
              ),
              buildField("Username", usernameC),
              buildField(
                "Email",
                emailC,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              BtnWidget(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Konfirmasi"),
                        content: const Text(
                          "Apakah kamu yakin ingin mengubah profil?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // tutup dialog
                            },
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context, true); // tutup dialog dulu
                              await save(); // lalu jalankan save
                            },
                            child: const Text("Ya, Ubah"),
                          ),
                        ],
                      );
                    },
                  );
                },
                width: 350,
                height: 40,
                text: "Save",
                bgcolor: Colors.blue,
                textstyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                isUpercase: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          TextField(
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: '************',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
