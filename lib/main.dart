import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orionschematic/data_loader.dart';
import 'package:orionschematic/pages/about_page.dart';
import 'package:orionschematic/pages/catalog_page.dart';
import 'package:orionschematic/pages/others_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orionschematic/pages/home_shell.dart';
import 'package:orionschematic/pages/login_page.dart';
// ignore: avoid_web_libraries_in_flutter



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadAllTypeData();
  runApp(const ORIONApp());
}

class ORIONApp extends StatefulWidget {
  const ORIONApp({super.key});

  @override
  State<ORIONApp> createState() => _ORIONAppState();
}

class _ORIONAppState extends State<ORIONApp> {
  ThemeMode themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseLight = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: Colors.deepOrange,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );

    final baseDark = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: Colors.cyanAccent,
      scaffoldBackgroundColor: const Color(0xFF071021),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );


    return MaterialApp(
      title: 'ORION SCHEMATIC',
      debugShowCheckedModeBanner: false,
      theme: baseLight,
      darkTheme: baseDark,
      themeMode: themeMode,
      home: AuthGate(
        onToggleTheme: toggleTheme,
        themeMode: themeMode,
      ),
    );
  }
}

/* ---------------- AUTH (Login / Register / Persisted State) ---------------- */
class AuthGate extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const AuthGate({
    required this.onToggleTheme,
    required this.themeMode,
    super.key,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool loggedIn = false;
  List<Map<String, String>> _users = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadUsers();
  }

  /* 🔹 Cek apakah user sudah login sebelumnya */
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      loggedIn = isLoggedIn;
    });
  }

  /* 🔹 Muat daftar user dari SharedPreferences */
  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString('users');
    if (usersString != null) {
      final List decoded = jsonDecode(usersString);
      setState(() {
        _users = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    } else {
      // Default admin account kalau belum ada user tersimpan
      _users = [
        {'name': 'Admin', 'email': 'admin@example.com', 'pass': '123456'},
      ];
      _saveUsers();
    }
  }

  /* 🔹 Simpan daftar user ke SharedPreferences */
  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', jsonEncode(_users));
  }

  /* 🔹 Fungsi logout */
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userData');
    setState(() => loggedIn = false);
  }

  /* 🔹 Fungsi login sukses */
  Future<void> _handleLogin() async {
    setState(() => loggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    return loggedIn
        ? HomeShellX(
      onLogout: _logout, // logout sekarang hapus prefs juga
      onToggleTheme: widget.onToggleTheme,
      themeMode: widget.themeMode,
    )
        : LoginPage(
      onLogin: _handleLogin,
      users: _users,
      saveUsers: _saveUsers,
    );
  }
}
