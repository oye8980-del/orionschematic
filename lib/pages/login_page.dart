import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orionschematic/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;
  final List<Map<String, String>> users;
  final Future<void> Function() saveUsers;

  const LoginPage({
    required this.onLogin,
    required this.users,
    required this.saveUsers,
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  /// 🔐 Obfuscate password (harus sama dengan RegisterPage)
  String _obfuscatePassword(String pass) {
    const salt = 'orion_demo_salt';
    return base64Encode(utf8.encode('$salt:$pass'));
  }

  /// 🔹 Saat login ditekan
  void _tryLogin() async {
    final e = _email.text.trim();
    final p = _pass.text;

    if (e.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email & Password wajib diisi')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _loading = false);

    // 🔹 Ambil user terbaru dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString('users');
    List<Map<String, dynamic>> allUsers = [];

    if (usersData != null) {
      allUsers = List<Map<String, dynamic>>.from(jsonDecode(usersData));
    }

    // 🔹 Hash password input
    final hashed = _obfuscatePassword(p);

    // 🔹 Cek user berdasarkan email dan password
    final user = allUsers.firstWhere(
          (u) => u['email'] == e && u['pass'] == hashed,
      orElse: () => {},
    );

    if (user.isNotEmpty) {

      // 🔹 Simpan user aktif
      await prefs.setString('userData', jsonEncode(user));
      await prefs.setBool('isLoggedIn', true);

      widget.onLogin(); // lanjut ke halaman berikutnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau Password salah ❌')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [const Color(0xFF041021), const Color(0xFF072033)]
                : [const Color(0xFFFFF7ED), const Color(0xFFFCECE4)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
              child: Column(
                children: [
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF010505), Color(0xFF0E0450)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'ORION SCHEMATIC',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tech Futuristic',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 22),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _pass,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🔹 Tombol Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _tryLogin,
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text('Login'),
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Belum punya akun? "),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegisterPage(
                                      users: widget.users,
                                      saveUsers: widget.saveUsers,
                                    ),
                                  ),
                                ),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
