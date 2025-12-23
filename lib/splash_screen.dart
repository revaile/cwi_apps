import 'package:flutter/material.dart';
import 'package:cwi_apps/services/appwrite_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // efek splash

    try {
      // 🔐 CEK LOGIN
      await AppwriteService.account.get();

      // ✅ JIKA LOGIN → BERANDA
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/beranda',
        (route) => false,
      );
    } catch (e) {
      // ❌ JIKA BELUM LOGIN → LOGIN PAGE
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F9A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/logo.png'),
              width: 250,
              height: 250,
            ),
            SizedBox(height: 10),
            Text(
              'PT. CATURWANGSA INDAH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
