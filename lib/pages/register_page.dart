import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Improved Register Page
/// - Uses Form + TextFormField with validators
/// - Enforces proper email format (and optional domain whitelist)
/// - Adds Confirm Password and password-strength rules
/// - Shows inline validation feedback and disables submit until valid
/// - Saves users to SharedPreferences (demo only - see comments about security)

class RegisterPage extends StatefulWidget {
  /// Current users list (each user is a map with name,email,pass)
  final List<Map<String, String>> users;

  /// Callback to persist users in the parent scope (keeps original architecture)
  final Future<void> Function() saveUsers;

  /// Optional: if provided, only emails belonging to these domains are allowed.
  /// Example: ['gmail.com'] to only accept Gmail addresses, or ['mycompany.com']
  final List<String>? allowedDomains;

  const RegisterPage({
    required this.users,
    required this.saveUsers,
    this.allowedDomains,
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  // Simple email regex (good practical coverage). Don't replace with overly permissive checks.
  final RegExp _emailReg = RegExp(
      r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
  );


  // Password rules
  bool _hasMinLength(String s) => s.length >= 8;
  bool _hasUpper(String s) => s.contains(RegExp(r'[A-Z]'));
  bool _hasLower(String s) => s.contains(RegExp(r'[a-z]'));
  bool _hasDigit(String s) => s.contains(RegExp(r'\d'));
  bool _hasSpecial(String s) => s.contains(RegExp(r'[!@#\$%\^&*(),.?":{}|<>]'));

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
    if (v.trim().length < 3) return 'Nama terlalu pendek (min 3 huruf)';
    return null;
  }

  String? _validateEmail(String? v) {
    final email = v?.trim() ?? '';

    if (email.isEmpty) return 'Email wajib diisi';

    // regex email baru
    if (!_emailReg.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    // domain check
    if (widget.allowedDomains != null && widget.allowedDomains!.isNotEmpty) {
      final domain = email.split('@').last.toLowerCase();
      final allowed = widget.allowedDomains!
          .map((d) => d.toLowerCase())
          .toList();

      if (!allowed.contains(domain)) {
        return 'Hanya email dengan domain: ${allowed.join(', ')} yang diperbolehkan';
      }
    }

    // cek email duplikat
    final exists = widget.users.any(
            (u) => (u['email'] ?? '').toLowerCase() == email.toLowerCase());
    if (exists) return 'Email sudah terdaftar';

    return null;
  }


  String? _validatePassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return 'Password wajib diisi';
    if (!_hasMinLength(s)) return 'Minimal 8 karakter';
    if (!_hasUpper(s)) return 'Harus punya huruf kapital';
    if (!_hasLower(s)) return 'Harus punya huruf kecil';
    if (!_hasDigit(s)) return 'Harus punya angka';
    if (!_hasSpecial(s)) return 'Harus punya karakter spesial (contoh: !@#\$%)';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
    if (v != _pass.text) return 'Password tidak sama';
    return null;
  }

  /// Very lightweight obfuscation for demo only. **Do not** use this for real production.
  /// In production: send password to a backend and store a salted hash (bcrypt/PBKDF2/Argon2) server-side.
  String _obfuscatePassword(String pass) {
    final salt = 'orion_demo_salt';
    return base64Encode(utf8.encode('$salt:$pass'));
  }

  Future<void> _register() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _pass.text;

    setState(() => _loading = true);

    // simulate small delay
    await Future.delayed(const Duration(milliseconds: 400));

    // add new user
    final newUser = {'name': name, 'email': email, 'pass': _obfuscatePassword(pass)};
    widget.users.add(newUser);

    await widget.saveUsers();

    // keep SharedPreferences in sync for this demo
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', jsonEncode(widget.users));

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎉 Akun $name berhasil dibuat')),
    );

    Navigator.pop(context);
  }

  double _passwordStrengthScore(String pw) {
    var score = 0;
    if (_hasMinLength(pw)) score += 1;
    if (_hasUpper(pw)) score += 1;
    if (_hasLower(pw)) score += 1;
    if (_hasDigit(pw)) score += 1;
    if (_hasSpecial(pw)) score += 1;
    return score / 5.0; // 0.0 - 1.0
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Akun Baru'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: theme.brightness == Brightness.dark
                  ? [const Color(0xFF041021), const Color(0xFF072033)]
                  : [const Color(0xFFFFF7ED), const Color(0xFFFCECE4)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Daftar Akun ORION',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                      helperText: widget.allowedDomains != null && widget.allowedDomains!.isNotEmpty
                          ? 'Hanya domain: ${widget.allowedDomains!.join(', ')}'
                          : 'Gunakan email aktif untuk verifikasi',
                    ),
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _pass,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: _validatePassword,
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 8),

                  // Password strength indicator
                  Builder(builder: (ctx) {
                    final score = _passwordStrengthScore(_pass.text);
                    final percent = (score * 100).round();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(value: score),
                        const SizedBox(height: 6),
                        Text('Kekuatan password: $percent%'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _ruleChip('≥8 chars', _hasMinLength(_pass.text)),
                            _ruleChip('Upper', _hasUpper(_pass.text)),
                            _ruleChip('Lower', _hasLower(_pass.text)),
                            _ruleChip('Digit', _hasDigit(_pass.text)),
                            _ruleChip('Special', _hasSpecial(_pass.text)),
                          ],
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _confirm,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: _validateConfirm,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) _register();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Daftar Sekarang'),
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

  Widget _ruleChip(String label, bool ok) {
    return Chip(
      label: Text(label),
      backgroundColor: ok ? null : Colors.grey.shade200,
      avatar: Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked, size: 18),
    );
  }
}
