import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F24), // Dark futuristic background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F24),
        elevation: 0,
        title: Text(
          'About Orion',
          style: GoogleFonts.orbitron(
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0F24),
              Color(0xFF101A3B),
              Color(0xFF16285E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView( // ✅ agar tidak overflow
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.memory_rounded,
                    size: 80,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 30),

                // Title
                Text(
                  'Welcome to ORION',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  'Your futuristic hardware repair guide.\n\n'
                      'ORION provides comprehensive solutions including:\n\n'
                      '• PCB BITMAP visualization\n'
                      '• SCHEMATIC diagrams\n'
                      '• Repair GUIDELINES for Smartphones, Laptops, and more\n\n'
                      'Empowering technicians and engineers with a sleek, intelligent, and futuristic interface designed to accelerate diagnostics and repair efficiency.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.7,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Version Info
                Text(
                  'ORION SCHEMATIC v1.0',
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.cyanAccent,
                  thickness: 0.5,
                  indent: 60,
                  endIndent: 60,
                ),
                const SizedBox(height: 10),

                // Footer note
                Text(
                  'Developed with passion and precision.\n© 2025 ORION Technologies',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 30), // ✅ Tambahan agar tidak mepet bawah
              ],
            ),
          ),
        ),
      ),
    );
  }
}