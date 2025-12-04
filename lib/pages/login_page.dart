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

  /// Obfuscate password (harus sama dengan RegisterPage)
  String _obfuscatePassword(String pass) {
    const salt = 'orion_demo_salt';
    return base64Encode(utf8.encode('$salt:$pass'));
  }

  /// LOGIN HANDLER
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

    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString('users');
    List<Map<String, dynamic>> allUsers = [];

    if (usersData != null) {
      allUsers = List<Map<String, dynamic>>.from(jsonDecode(usersData));
    }

    final hashed = _obfuscatePassword(p);

    final user = allUsers.firstWhere(
          (u) => u['email'] == e && u['pass'] == hashed,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      await prefs.setString('userData', jsonEncode(user));
      await prefs.setBool('isLoggedIn', true);

      widget.onLogin();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau Password salah ❌')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: isDesktop
                    ? _buildDesktopLayout(theme)
                    : _buildMobileLayout(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          child: Image.asset('assets/images/logo.png'),
        ),
        const SizedBox(height: 18),
        _buildLoginCard(theme),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 230,
                height: 230,
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 1,
          child: _buildLoginCard(theme),
        ),
      ],
    );
  }

  /// LOGIN CARD — UPDATED
  Widget _buildLoginCard(ThemeData theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(
              theme.brightness == Brightness.dark ? 0.6 : 0.88,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                "Welcome!",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Masuk ke akun ORION kamu",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 28),

              // EMAIL
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email',
                  filled: true,
                  fillColor: theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // PASSWORD
              TextField(
                controller: _pass,
                obscureText: _obscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: 'Password',
                  filled: true,
                  fillColor: theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.03),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _tryLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Login'),
                ),
              ),

              const SizedBox(height: 18),

              // REGISTER BUTTON (UPDATED)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegisterPage(
                            users: widget.users,
                            saveUsers: widget.saveUsers,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _email.text = result['email'] ?? '';
                          _pass.text = result['pass'] ?? '';
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Akun berhasil dibuat — silakan login')),
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
