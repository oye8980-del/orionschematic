import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orionschematic/pages/login_page.dart';
import 'package:orionschematic/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String? userName;
  String? userEmail;
  String? _storedObfuscatedPass; // simpan obfuscated pass asli

  // **Baru**: simpan image sebagai base64 string
  String? _profileImageBase64;
  Uint8List? _profileImageBytes; // untuk ditampilkan langsung

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Opsi B: default terlihat, tapi bisa ditoggle
  bool _obscurePass = false;
  bool _loading = false;

  late final AnimationController _glowCtrl;

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // Email regex (lebih fleksibel)
  final RegExp _emailReg =
  RegExp(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$");

  // Password regex: min 8, at least one uppercase, one digit, one special char
  final RegExp _passReg = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)'
      r'(?=.*[!@#\$%\^&*(),.?":{}|<>]).{8,}$'
  );


  @override
  void initState() {
    super.initState();
    _loadUserData();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // 🔐 Obfuscate password (harus sama dengan Register & Login)
  String _obfuscatePassword(String pass) {
    const salt = 'orion_demo_salt';
    return base64Encode(utf8.encode('$salt:$pass'));
  }

  // 🔓 De-obfuscate (kembalikan plain password dari obfuscated)
  String _deobfuscatePassword(String ob) {
    try {
      final decoded = utf8.decode(base64Decode(ob));
      final parts = decoded.split(':');
      if (parts.length >= 2) {
        return parts.sublist(1).join(':');
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  // Fungsi untuk memuat data user tersimpan (termasuk foto)
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('userData');

    if (data != null) {
      final user = jsonDecode(data);
      setState(() {
        userName = user['name'];
        userEmail = user['email'];
        _storedObfuscatedPass = user['pass'];
        _profileImageBase64 = user['profileImage']; // mungkin null
        _nameController.text = userName ?? '';
        _emailController.text = userEmail ?? '';
        _passController.text =
        (_storedObfuscatedPass != null && _storedObfuscatedPass!.isNotEmpty)
            ? _deobfuscatePassword(_storedObfuscatedPass!)
            : '';

        if (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty) {
          try {
            _profileImageBytes = base64Decode(_profileImageBase64!);
          } catch (_) {
            _profileImageBytes = null;
          }
        } else {
          _profileImageBytes = null;
        }
      });
    } else {
      // jika tidak ada userData, coba load minimal fields (opsional)
      setState(() {
        _profileImageBytes = null;
      });
    }
  }

  // 🎨 Tema utama
  final Color kDarkBg = const Color(0xFF0E0E12);
  final Color kBlue = const Color(0xFF1565C0);
  final Color kBlueDark = const Color(0xFF0D47A1);
  final Color kText = Colors.white70;

  // 🔹 Dialog konfirmasi umum
  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required IconData icon,
    required String confirmText,
    Color? color,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kDarkBg,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(icon, color: color ?? kBlue, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: kText, fontSize: 14.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
            const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? kBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ??
        false;
  }

  // 🔹 Validasi sederhana input profil (sudah include password opsional)
  String? _validateInputs({
    required String name,
    required String email,
    String? password,
  }) {
    if (name.trim().isEmpty) return 'Nama wajib diisi';
    if (email.trim().isEmpty) return 'Email wajib diisi';
    if (!_emailReg.hasMatch(email.trim())) return 'Format email tidak valid';

    if (password != null && password.trim().isNotEmpty) {
      if (!_passReg.hasMatch(password)) {
        return 'Password harus minimal 8 karakter, berisi huruf besar, angka, dan karakter khusus';
      }
    }

    return null;
  }

  // 🔹 Simpan / Update Profil (termasuk field foto jika ada)
  Future<void> _saveUserData() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final newPassPlain = _passController.text;

    // gunakan password pada validasi (hanya jika diisi)
    final err = _validateInputs(name: name, email: email, password: newPassPlain);
    if (err != null) {
      _showCustomSnackBar(
        message: err,
        icon: Icons.error_outline,
        color: Colors.redAccent,
      );
      return;
    }

    final shouldSave = await _showConfirmDialog(
      title: 'Konfirmasi Perubahan',
      message: 'Apakah kamu yakin ingin menyimpan perubahan profil?',
      icon: Icons.edit_outlined,
      confirmText: 'Simpan',
      color: kBlue,
    );

    if (!shouldSave) return;

    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString('users');

    // prepare updated user map
    String passToSaveObfuscated;
    if (newPassPlain.trim().isEmpty) {
      passToSaveObfuscated = _storedObfuscatedPass ?? '';
    } else {
      passToSaveObfuscated = _obfuscatePassword(newPassPlain);
    }

    final updatedUser = {
      'name': name,
      'email': email,
      'pass': passToSaveObfuscated,
      'profileImage': _profileImageBase64 ?? '',
    };

    // update users list di SharedPreferences
    if (usersData != null) {
      final List<dynamic> usersList = jsonDecode(usersData);

      final originalEmail = userEmail ?? '';
      final index = usersList.indexWhere((u) => u['email'] == originalEmail);

      if (index != -1) {
        final duplicateIndex = usersList.indexWhere(
                (u) => u['email'] == email && u['email'] != originalEmail);
        if (duplicateIndex != -1) {
          setState(() => _loading = false);
          _showCustomSnackBar(
            message: 'Email sudah digunakan user lain',
            icon: Icons.error_outline,
            color: Colors.redAccent,
          );
          return;
        }

        usersList[index] = updatedUser;
        await prefs.setString('users', jsonEncode(usersList));
      } else {
        usersList.add(updatedUser);
        await prefs.setString('users', jsonEncode(usersList));
      }
    } else {
      final usersList = [updatedUser];
      await prefs.setString('users', jsonEncode(usersList));
    }

    // update userData (active user)
    await prefs.setString('userData', jsonEncode(updatedUser));
    await prefs.setBool('isLoggedIn', true);

    // update local state
    setState(() {
      userName = updatedUser['name'];
      userEmail = updatedUser['email'];
      _storedObfuscatedPass = updatedUser['pass'];
      _loading = false;
      // tampilkan plaintext lokal (agar user bisa lihat / edit lagi)
      _passController.text = _deobfuscatePassword(_storedObfuscatedPass ?? '');
    });

    if (mounted) {
      _showCustomSnackBar(
        message: 'Profil berhasil diperbarui 🎉',
        icon: Icons.check_circle_outline,
        color: kBlueDark,
      );
    }
  }

  // 🔹 Logout Akun
  Future<void> _logout() async {
    final shouldLogout = await _showConfirmDialog(
      title: 'Konfirmasi Logout',
      message: 'Apakah kamu yakin ingin keluar dari akun ini?',
      icon: Icons.logout_rounded,
      confirmText: 'Logout',
      color: Colors.redAccent,
    );

    if (!shouldLogout) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.setBool('isLoggedIn', false);

    if (mounted) {
      _showCustomSnackBar(
        message: 'Berhasil logout 👋',
        icon: Icons.logout,
        color: kBlueDark,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const ORIONApp()),
            (route) => false,
      );
    }
  }

  // ----------------- FITUR FOTO PROFIL -----------------

  // GANTI: pick image dari source (camera/gallery)
  Future<void> _pickProfileImage({required ImageSource source}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1200,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      final base64Str = base64Encode(bytes);

      // Simpan langsung ke prefs pada userData
      final prefs = await SharedPreferences.getInstance();
      final dataStr = prefs.getString('userData');
      Map<String, dynamic> userMap = {};
      if (dataStr != null) {
        try {
          userMap = jsonDecode(dataStr);
        } catch (_) {
          userMap = {};
        }
      }

      // ensure we at least preserve email/name if available
      userMap['profileImage'] = base64Str;
      if (!userMap.containsKey('email') && userEmail != null) {
        userMap['email'] = userEmail;
      }
      if (!userMap.containsKey('name') && userName != null) {
        userMap['name'] = userName;
      }

      await prefs.setString('userData', jsonEncode(userMap));

      // juga update users list jika perlu (cari dan update berdasarkan email)
      final usersStr = prefs.getString('users');
      if (usersStr != null) {
        try {
          final List<dynamic> usersList = jsonDecode(usersStr);
          final idx = usersList.indexWhere(
                  (u) => u['email'] == (userMap['email'] ?? userEmail));
          if (idx != -1) {
            usersList[idx]['profileImage'] = base64Str;
            await prefs.setString('users', jsonEncode(usersList));
          }
        } catch (_) {}
      }

      setState(() {
        _profileImageBase64 = base64Str;
        _profileImageBytes = bytes;
      });

      _showCustomSnackBar(
        message: 'Foto profil diperbarui',
        icon: Icons.photo_camera,
        color: kBlue,
      );
    } catch (e) {
      _showCustomSnackBar(
        message: 'Gagal mengambil gambar: ${e.toString()}',
        icon: Icons.error_outline,
        color: Colors.redAccent,
      );
    }
  }

  // pilihan modal: kamera / galeri
  void _chooseImageSource() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF071025),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                const Icon(Icons.camera_alt_outlined, color: Colors.white),
                title:
                const Text('Ambil dari Kamera', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickProfileImage(source: ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
                title: const Text('Pilih dari Galeri', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickProfileImage(source: ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Hapus foto profil (set kosong)
  Future<void> _removeProfileImage() async {
    final ok = await _showConfirmDialog(
      title: 'Hapus Foto',
      message: 'Yakin ingin menghapus foto profil?',
      icon: Icons.delete_outline,
      confirmText: 'Hapus',
      color: Colors.redAccent,
    );
    if (!ok) return;

    final prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString('userData');
    Map<String, dynamic> userMap = {};
    if (dataStr != null) {
      try {
        userMap = jsonDecode(dataStr);
      } catch (_) {}
    }
    userMap['profileImage'] = '';
    await prefs.setString('userData', jsonEncode(userMap));

    final usersStr = prefs.getString('users');
    if (usersStr != null) {
      try {
        final List<dynamic> usersList = jsonDecode(usersStr);
        final idx = usersList.indexWhere(
                (u) => u['email'] == (userMap['email'] ?? userEmail));
        if (idx != -1) {
          usersList[idx]['profileImage'] = '';
          await prefs.setString('users', jsonEncode(usersList));
        }
      } catch (_) {}
    }

    setState(() {
      _profileImageBase64 = null;
      _profileImageBytes = null;
    });

    _showCustomSnackBar(
      message: 'Foto profil dihapus',
      icon: Icons.delete_outline,
      color: Colors.redAccent,
    );
  }

  // 🔹 SnackBar Custom
  void _showCustomSnackBar({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050913),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 16),
            _NeonDot(),
            const SizedBox(width: 10),
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;
          final contentWidth = isDesktop ? 700.0 : double.infinity;
          final horizontalPadding = isDesktop ? 60.0 : 20.0;

          return Stack(
            children: [
              const _NeonGrid(),
              Positioned(
                top: -80,
                left: -60,
                child: _GlowBlob(
                  color: const Color(0xFF00E5FF).withOpacity(0.18),
                  size: 260,
                ),
              ),
              Positioned(
                bottom: -100,
                right: -60,
                child: _GlowBlob(
                  color: const Color(0xFF7C4DFF).withOpacity(0.18),
                  size: 300,
                ),
              ),
              SingleChildScrollView(
                padding:
                EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 6),
                        _buildAvatar(), // pindahin stack avatar ke fungsi tersendiri
                        const SizedBox(height: 18),
                        Text(
                          userName ?? 'Guest User',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _NeonPill(text: userEmail ?? 'guest@example.com'),
                        const SizedBox(height: 28),
                        _NeonDivider(label: 'Edit Information'),
                        const SizedBox(height: 16),
                        _NeonCard(
                          child: isDesktop
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _neonTextField(
                                  icon: Icons.person_outline,
                                  label: 'Nama Lengkap',
                                  controller: _nameController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _neonTextField(
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _neonTextField(
                                  icon: Icons.lock_outline,
                                  label: 'Password (lihat / sembunyikan)',
                                  controller: _passController,
                                  obscure: true,
                                  obscureFlag: _obscurePass,
                                  onToggleObscure: () =>
                                      setState(() => _obscurePass = !_obscurePass),
                                ),
                              ),
                            ],
                          )
                              : Column(
                            children: [
                              _neonTextField(
                                icon: Icons.person_outline,
                                label: 'Nama Lengkap',
                                controller: _nameController,
                              ),
                              const SizedBox(height: 12),
                              _neonTextField(
                                icon: Icons.email_outlined,
                                label: 'Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              _neonTextField(
                                icon: Icons.lock_outline,
                                label: 'Password (lihat / sembunyikan)',
                                controller: _passController,
                                obscure: true,
                                obscureFlag: _obscurePass,
                                onToggleObscure: () =>
                                    setState(() => _obscurePass = !_obscurePass),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: _NeonButton(
                                text: _loading ? 'Menyimpan...' : 'Simpan Perubahan',
                                icon:
                                _loading ? Icons.hourglass_top_rounded : Icons.save_rounded,
                                onPressed: _loading ? null : _saveUserData,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _NeonButton(
                                text: 'Logout',
                                icon: Icons.logout_rounded,
                                onPressed: _logout,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Opacity(
                          opacity: 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.shield_moon_outlined, size: 16, color: Colors.white70),
                              SizedBox(width: 6),
                              Text(
                                'Data tersimpan hanya di perangkat ini',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: AnimatedBuilder(
        animation: _glowCtrl,
        builder: (context, _) {
          final t = _glowCtrl.value;
          final blur = 18 + 14 * t;
          final spread = 1 + 2 * t;

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFF0A1430), Color(0xFF0A0F20)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.35),
                      blurRadius: blur,
                      spreadRadius: spread,
                    ),
                    BoxShadow(
                      color: const Color(0xFF7C4DFF).withOpacity(0.25),
                      blurRadius: blur * 0.8,
                      spreadRadius: spread * 0.6,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: _SweepRingPainter(progress: t),
                  child: Center(
                    child: ClipOval(
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: _profileImageBytes != null
                            ? Image.memory(
                          _profileImageBytes!,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.person_rounded,
                            color: Colors.white, size: 74),
                      ),
                    ),
                  ),
                ),
              ),
              // tombol edit kecil di pojok kanan bawah avatar
              Positioned(
                bottom: 4,
                right: 4,
                child: Row(
                  children: [
                    if (_profileImageBytes != null)
                      GestureDetector(
                        onTap: _removeProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E1A33),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _chooseImageSource,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1A33),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _neonTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    bool obscureFlag = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1425).withOpacity(0.58),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF081021),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscure ? obscureFlag : false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                isDense: true,
                labelText: label,
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.65)),
                border: InputBorder.none,
              ),
            ),
          ),
          if (obscure)
            IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscureFlag ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}

/// ---------- NEON UI HELPERS ----------

class _NeonButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const _NeonButton({
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: onPressed == null ? 0.7 : 1,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E1A33),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFF00E5FF), width: 1),
          ),
          elevation: 18,
          shadowColor: const Color(0xFF00E5FF).withOpacity(0.55),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _NeonDivider extends StatelessWidget {
  final String label;
  const _NeonDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _GradientLine()),
        SizedBox(width: 12),
        Text(
          'EDIT INFORMATION',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 12),
        Expanded(child: _GradientLine()),
      ],
    );
  }
}

class _GradientLine extends StatelessWidget {
  const _GradientLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
        ),
      ),
    );
  }
}

class _NeonCard extends StatelessWidget {
  final Widget child;
  const _NeonCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1224).withOpacity(0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withOpacity(0.2),
            blurRadius: 18,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.16),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NeonPill extends StatelessWidget {
  final String text;
  const _NeonPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00E5FF), Color(0xFF7C4DFF)],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _NeonGrid extends StatelessWidget {
  const _NeonGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter(), size: Size.infinite);
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0E1930)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)],
      ),
    );
  }
}

class _NeonDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF00E5FF),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.7),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _SweepRingPainter extends CustomPainter {
  final double progress;
  _SweepRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = 4.0;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withOpacity(0.08);
    canvas.drawCircle(rect.center, size.width / 2 - stroke, base);

    final sweep = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..shader = SweepGradient(
        colors: const [
          Color(0x0000E5FF),
          Color(0xFF00E5FF),
          Color(0xFF7C4DFF),
          Color(0x0000E5FF),
        ],
        stops: const [0.0, 0.2, 0.6, 1.0],
        startAngle: 0.0,
        endAngle: 6.283,
        transform: GradientRotation(progress * 6.283),
      ).createShader(rect);
    canvas.drawArc(
      Rect.fromLTWH(stroke, stroke, size.width - stroke * 2, size.height - stroke * 2),
      -1.57,
      6.283,
      false,
      sweep,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
