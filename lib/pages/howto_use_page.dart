import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HowToUsePage extends StatefulWidget {
  const HowToUsePage({super.key});

  @override
  State<HowToUsePage> createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    const videoUrl = "https://youtu.be/fXWsN_vebU0?si=sAoZnorkkcYZMijT";

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F), // Dark blue premium background
      appBar: AppBar(
        backgroundColor: const Color(0xFF112D4E),
        title: const Text(
          'How To Use ORION SCHEMATIC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== HEADER TEKS ======
              Row(
                children: const [
                  Icon(FontAwesomeIcons.screwdriverWrench,
                      color: Colors.cyanAccent, size: 26),
                  SizedBox(width: 12),
                  Text(
                    "Tutorial Penggunaan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Pelajari cara menggunakan ORION Schematic dengan mudah melalui video tutorial berikut.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 25),

              // ====== VIDEO CARD ======
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF112D4E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Video player
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.redAccent,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.amber,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        children: const [
                          Icon(FontAwesomeIcons.youtube,
                              color: Colors.redAccent, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Panduan Lengkap: Cara Menggunakan ORION SCHEMATIC",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ====== FOOTNOTE ======
              Row(
                children: const [
                  Icon(Icons.info_outline,
                      color: Colors.cyanAccent, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Jika video tidak muncul, pastikan koneksi internet stabil.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
