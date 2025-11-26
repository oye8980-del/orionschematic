import 'package:flutter/material.dart';
import 'package:orionschematic/pages/about_page.dart';
import 'package:orionschematic/pages/brand_page.dart';
import 'package:orionschematic/pages/howto_use_page.dart';
import 'package:orionschematic/pages/banner_detail.dart';
import 'package:orionschematic/pages/folder_detail.dart';
import 'package:orionschematic/pages/pcb_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // ⬅️ untuk jsonDecode
import 'profile_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data_loader.dart';




/* ---------------- HOME PAGE (Futuristic) ---------------- */
class HomePageFuturistic extends StatefulWidget {
  const HomePageFuturistic({super.key, required this.onLogout});

  final VoidCallback onLogout; // pastikan ini ada

  @override
  State<HomePageFuturistic> createState() => _HomePageFuturisticState();
}

class _HomePageFuturisticState extends State<HomePageFuturistic> {
  final List<Map<String, dynamic>> videoList = [
    {
      'title':
          '𝐍𝐄𝐖 𝐁𝐈𝐓𝐌𝐀𝐏 𝐌𝐔𝐋𝐓𝐈𝐋𝐀𝐘𝐄𝐑 – 𝐢𝐏𝐡𝐨𝐧𝐞 𝟏𝟕 𝐏𝐫𝐨',
      'thumbnail': 'assets/videos/image1.png',
      'url': 'https://youtu.be/iYyB9Vc2Jr4?si=mAEDL4HpEsR9NBJK',
    },
    {
      'title': 'GUIDLINES CONTROL LOGIC',
      'thumbnail': 'assets/videos/image2.png',
      'url': 'https://youtu.be/TBDc9oQ2J9s?si=A6W-yYCO9AWqc3uc',
    },
    {
      'title': '30 menit trik swap board semua mesin',
      'thumbnail': 'assets/videos/image3.png',
      'url': 'https://youtu.be/s5yKU9yE7Fg?si=yNRrGLTzm8ORjWlw',
    },
    {
      'title': 'MENCARI PERSAMAAN IC',
      'thumbnail': 'assets/videos/image4.png',
      'url': 'https://youtu.be/xQ7i4DvyETE?si=WKBPQNeyAFio91mt',
    },
  ];
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    if (userData != null) {
      final Map<String, dynamic> user = jsonDecode(userData); // ✅ sekarang aman
      setState(() {
        userName = user['name'];
        userEmail = user['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> listGawai = [
      {
        'jenis': 'Detail Single Chip Pinout',
        'icon': Icons.bolt,
        'brands': [
          {'name': 'Detail Single Chip Pinout', 'logo': 'assets/images/chip.jpeg'},
        ]
      },

      {
        'jenis': 'Document & Datasheet',
        'icon': Icons.description,
        'brands': [
          {'name': 'doc & data', 'logo': 'assets/images/dokumen.jpg'},
        ]
      },

      {
        'jenis': 'Drone & Quadcopter',
        'icon': Icons.flight,
        'brands': [
          {'name': 'DJI', 'logo': 'assets/images/DJI.png'},
        ]
      },

      {

        'jenis': 'Gadget & Wearables',
        'icon': Icons.watch,
        'brands': [
          {'name': 'produk gadget & wearables', 'logo': 'assets/images/gadgetwearables.jpg'},
        ]
      },

      {
        'jenis': 'Graphics Card & Game Console',
        'icon': Icons.sports_esports,
        'brands': [
          {'name': 'Nvidia', 'logo': 'assets/brands/nvidia.jpg'},
          {'name': 'PlayStation', 'logo': 'assets/brands/playstation.jpg'},
        ]
      },

      {
        'jenis': 'Laptop & Notebook',
        'icon': Icons.laptop_mac,
        'brands': [
          {'name': 'Acer', 'logo': 'assets/brands/acer.png'},
          {'name': 'AlienWare', 'logo': 'assets/brands/alienware.png'},
          {'name': 'Apple', 'logo': 'assets/brands/apple.png'},
          {'name': 'Asus', 'logo': 'assets/brands/asus.jpg'},
          {'name': 'Axioo', 'logo': 'assets/brands/axioo.png'},
          {'name': 'BenQ', 'logo': 'assets/brands/benq.png'},
          {'name': 'Compaq', 'logo': 'assets/brands/compaq.png'},
          {'name': 'Dell', 'logo': 'assets/brands/dell.png'},
          {'name': 'Ecs', 'logo': 'assets/brands/ecs.png'},
          {'name': 'Fujitsu', 'logo': 'assets/brands/fujitsu.png'},
          {'name': 'Gigabyte', 'logo': 'assets/brands/gigabyte.png'},
          {'name': 'Huawei', 'logo': 'assets/brands/huawei.jpg'},
          {'name': 'Lenovo', 'logo': 'assets/brands/lenovo.png'},
          {'name': 'Samsung', 'logo': 'assets/brands/samsung.png'},
          {'name': 'Toshiba', 'logo': 'assets/brands/toshiba.png'},
          {'name': 'Vaio', 'logo': 'assets/brands/vaio.png'},
          {'name': 'Xiaomi', 'logo': 'assets/brands/xiaomi.png'},
        ],
      },

      {
        'jenis': 'Smartphone',
        'icon': Icons.phone_android,
        'brands': [
          {'name': 'Alcatel', 'logo': 'assets/brands/alcatel.png'},
          {'name': 'Apple', 'logo': 'assets/brands/apple.png'},
          {'name': 'Asus', 'logo': 'assets/brands/asus.jpg'},
          {'name': 'Black Shark', 'logo': 'assets/brands/blackshark.jpg'},
          {'name': 'Blackberry', 'logo': 'assets/brands/blackberry.jpg'},
          {'name': 'BLU', 'logo': 'assets/brands/blu.jpg'},
          {'name': 'Coolpad', 'logo': 'assets/brands/coolpad.png'},
          {'name': 'Gionee', 'logo': 'assets/brands/gionee.png'},
          {'name': 'Google', 'logo': 'assets/brands/google.jpg'},
          {'name': 'Honor', 'logo': 'assets/brands/honor.jpg'},
          {'name': 'Hotwav', 'logo': 'assets/brands/hotwav.png'},
          {'name': 'Huawei', 'logo': 'assets/brands/huawei.jpg'},
          {'name': 'Infinix', 'logo': 'assets/brands/infinix.png'},
          {'name': 'Infocus', 'logo': 'assets/brands/infocus.png'},
          {'name': 'IQOO', 'logo': 'assets/brands/iqoo.jpg'},
          {'name': 'Itel', 'logo': 'assets/brands/itel.png'},
          {'name': 'JIO', 'logo': 'assets/brands/jio.png'},
          {'name': 'Lava', 'logo': 'assets/brands/lava.jpg'},
          {'name': 'Lenovo', 'logo': 'assets/brands/lenovo.png'},
          {'name': 'LG', 'logo': 'assets/brands/lg.png'},
          {'name': 'Maxtron', 'logo': 'assets/brands/maxtron.jpg'},
          {'name': 'Meizu', 'logo': 'assets/brands/meizu.png'},
          {'name': 'micromax', 'logo': 'assets/brands/micromax.png'},
          {'name': 'Motorola', 'logo': 'assets/brands/motorola.png'},
          {'name': 'Neffos', 'logo': 'assets/brands/neffos.png'},
          {'name': 'Nokia', 'logo': 'assets/brands/nokia.jpg'},
          {'name': 'OnePlus', 'logo': 'assets/brands/oneplus.png'},
          {'name': 'Oppo', 'logo': 'assets/brands/oppo.png'},
          {'name': 'Realme', 'logo': 'assets/brands/realme.png'},
          {'name': 'Samsung', 'logo': 'assets/brands/samsung.png'},
          {'name': 'Sharp', 'logo': 'assets/brands/sharp.png'},
          {'name': 'Sony', 'logo': 'assets/brands/sony.jpg'},
          {'name': 'Tecno', 'logo': 'assets/brands/tecno.jpg'},
          {'name': 'Umidigi', 'logo': 'assets/brands/umidigi.png'},
          {'name': 'Vivo', 'logo': 'assets/brands/vivo.png'},
          {'name': 'Xiaomi', 'logo': 'assets/brands/xiaomi.png'},
          {'name': 'ZTE', 'logo': 'assets/brands/zte.png'},
        ],
      },

      {
        'jenis': 'Tablet & Phablet',
        'icon': Icons.tablet,
        'brands': [
          {'name': 'Apple', 'logo': 'assets/brands/apple.png'},
          {'name': 'Asus', 'logo': 'assets/brands/asus.jpg'},
          {'name': 'Huawei', 'logo': 'assets/brands/huawei.jpg'},  // diperbaiki
          {'name': 'Lenovo', 'logo': 'assets/brands/lenovo.png'},
          {'name': 'LG', 'logo': 'assets/brands/lg.png'},
          {'name': 'Samsung', 'logo': 'assets/brands/samsung.png'},
          {'name': 'Xiaomi', 'logo': 'assets/brands/xiaomi.png'},
        ],
      },
    ];

    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF0A192F),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A192F), Color(0xFF112D4E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 90),
                  const SizedBox(height: 12),
                  const Text(
                    'ORION MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // profil
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),

            // 🔹 Menu Home
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // 🔹 Menu About
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),


            const Divider(color: Colors.white54, thickness: 0.5),

            // Menu exclusive
            Text(
              'Exclusive Item',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _folderTile(context, 'Convert Item\'s', [
              'Convert Bootlogo',
              'Convert Firmware',
              'Tools & Tips',
            ]),
            _folderTile(context, 'EMMC Identity', [
              'Fix EMMC',
              'Read/Write Identity',
            ]),
            _folderTile(context, 'Basic Learning', [
              'Soldering',
              'Multimeter',
              'Component Values',
            ]),
            _folderTile(context, 'Schematic Code / Shortcut Explain', [
              'Schematic A',
              'Shortcuts',
            ]),

            const SizedBox(height: 28),
          ],
        ),
      ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          padding: const EdgeInsets.only(top: 18, left: 16, right: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: theme.brightness == Brightness.dark
                  ? [const Color(0xFF071826), const Color(0xFF081A2A)]
                  : [
                      const Color(0xFFFF6A00).withOpacity(0.95),
                      const Color(0xFFFF3D00).withOpacity(0.95),
                    ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // ✅ sejajarkan secara vertikal
              children: [
                // ✅ Tombol menu
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),

                // ✅ Teks di tengah
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ✅ Logo ORION
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                        child: Image.asset(
                          'assets/images/logo.png', // pastikan path benar di pubspec.yaml
                          height: 55, // 🔥 ukuran logo lebih besar
                        ),
                      ),

                      // ✅ Teks di sebelah logo
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORION SCHEMATIC',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20, // 💪 sedikit lebih besar
                                height: 1.1,
                                letterSpacing: 1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ Ikon notifikasi di kanan
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF0A192F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          '🔔 ORION Notification',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'No new alerts at the moment.\nAll systems are running stable ⚡',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'CLOSE',
                              style: TextStyle(color: Colors.orangeAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            // announcement chip
            const SizedBox(height: 14),

            // Banner Marquee
            SizedBox(
              width: double.infinity,
              child: MarqueeBanner(images: [
                'assets/banner2.jpg',
                'assets/banner3.jpg',
                'assets/banner4.jpg',
              ]),
            ),

            // banner carousel (simple)
            SizedBox(
              height: 150,
              child: PageView(
                controller: PageController(viewportFraction: 0.92),
                children: [
                  _bannerCard(
                    context,
                    'Solution any shot Problem',
                    'Samsung • Xiaomi • Oppo',
                    Icons.phone_android,
                  ),
                  _bannerCard(
                    context,
                    'EMMC Identity & Fix',
                    'Tutorial & Tools',
                    Icons.settings_backup_restore_rounded,
                  ),
                  _bannerCard(
                    context,
                    'Buy & Sell Parts',
                    'Parts, Tools, Accessories',
                    Icons.shopping_bag,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // brands horizontal
            // ============================================
            //  🔹 GAWAI SELECTION SECTION (Home Page)
            // ============================================
            // === Daftar jenis gawai ===
            Text(
              'Pilih Jenis Gawai',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.84,
              ),
              itemCount: listGawai.length,
              itemBuilder: (context, index) {
                final gawai = listGawai[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BrandPage(
                          deviceCategory : gawai['jenis'],
                          brands: gawai['brands'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1F2430),
                          const Color(0xFF151922),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(3, 5),
                        ),
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.05),
                          blurRadius: 24,
                          offset: const Offset(-3, -2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey.withOpacity(0.12),
                            ),
                            child: Icon(
                              gawai['icon'],
                              size: 30,
                              color: Colors.lightBlue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            gawai['jenis'],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                              fontSize: 13.2,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),



            //===============release dan update==============
            const SizedBox(height: 8),
            const _UpdateListSection(),

            // 🔹 Video Tutorial Section
            const SizedBox(height: 20),
            Text(
              'Video Tutorial',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 16 / 10,
              ),
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                final video = videoList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          title: video['title'],
                          url: video['url'],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(video['thumbnail']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          video['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ======= Community =======
            Text(
              'Community and Support',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildSocialButton(
                      gradientColors: [Colors.blueAccent, Colors.cyanAccent],
                      icon: FontAwesomeIcons.facebookF,
                      url: 'https://www.facebook.com/groups/estechschematics',
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildSocialButton(
                      gradientColors: [Colors.greenAccent, Colors.tealAccent],
                      icon: FontAwesomeIcons.whatsapp,
                      url: 'https://wa.me/+6281388001180',
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildSocialButton(
                      gradientColors: [
                        Color(0xFF8A3AB9),
                        Color(0xFFBC2A8D),
                        Color(0xFFF56040),
                        Color(0xFFFFDC80),
                      ],
                      icon: FontAwesomeIcons.instagram,
                      url: 'https://instagram.com/orionschematics',
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildSocialButton(
                      gradientColors: [
                        Color(0xFF25F4EE),
                        Color(0xFFFE2C55),
                      ],
                      icon: FontAwesomeIcons.tiktok,
                      url: 'https://www.tiktok.com/orionschematics',
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildSocialButton(
                      gradientColors: [Colors.redAccent, Colors.red],
                      icon: FontAwesomeIcons.youtube,
                      url: 'https://youtube.com/@orionschematics',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),


            // How to use
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HowToUsePage()),
                ),
                icon: const Icon(Icons.help_outline),
                // ✅ Ganti label tombol
                label: const Text('How To Use ORION SCHEMATIC ?'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // 🔹 fungsi tombol sosial futuristik
  Widget _buildSocialButton({
    required List<Color> gradientColors,
    required IconData icon,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 26)),
      ),
    );
  }

  Widget _bannerCard(
    BuildContext context,
    String title,
    String sub,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BannerDetailPage(title: title, subtitle: sub),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? const LinearGradient(
                  colors: [Color(0xFF052A36), Color(0xFF071826)],
                )
              : const LinearGradient(
                  colors: [Color(0xFFFF9A00), Color(0xFFFF4D00)],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.15),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(sub, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Lihat'))),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
              child: const Text('Lihat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _folderTile(BuildContext context, String title, List<String> items) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.folder, color: Colors.amber),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: items
            .map(
              (it) => ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FolderDetailPage(folder: it),
                  ),
                ),
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: Text(it),
                trailing: const Icon(Icons.chevron_right),
              ),
            )
            .toList(),
      ),
    );
  }
}

class MarqueeBanner extends StatefulWidget {
  final List<String> images;
  const MarqueeBanner({super.key, required this.images});

  @override
  State<MarqueeBanner> createState() => _MarqueeBannerState();
}

class _MarqueeBannerState extends State<MarqueeBanner> {
  final ScrollController _scrollController = ScrollController();
  double totalWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() async {
    while (mounted) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 20),
        curve: Curves.linear,
      );

      if (!mounted) return;

      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          ...widget.images.map((img) => _bannerImage(img)),
          ...widget.images.map((img) => _bannerImage(img)), // looping
        ],
      ),
    );
  }

  Widget _bannerImage(String path) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/* --------------- type page ------------------- */
// ===== RESPONSIVE TYPE PAGE =====
class TypePage extends StatefulWidget {
  final String brandName;
  final String deviceCategory;

  const TypePage({
    required this.brandName,
    required this.deviceCategory,
    super.key,
  });

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  String? _openedType;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceTypes = allTypeData[widget.deviceCategory]?[widget.brandName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            '${widget.brandName} ${widget.deviceCategory}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF0A192F)
            : Colors.deepOrange,
        elevation: 4,
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: deviceTypes.length,
        itemBuilder: (context, index) {
          final typeName = deviceTypes[index];
          final isOpen = _openedType == typeName;

          return Column(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _openedType = isOpen ? null : typeName;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          typeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedCrossFade(
                crossFadeState:
                isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 220),
                firstChild: Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.grid_view_rounded, size: 22),
                        title: const Text('Layout'),
                        minLeadingWidth: 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TypeDetailPage(
                                brandName: widget.brandName,
                                componentName: '$typeName - Layout',
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.bolt_rounded, size: 22),
                        title: const Text('Schematic'),
                        minLeadingWidth: 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TypeDetailPage(
                                brandName: widget.brandName,
                                componentName: '$typeName - Schematic',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* --------------- type brand gawai page ------------- */
class TypeDetailPage extends StatefulWidget {
  final String brandName;
  final String componentName;
  const TypeDetailPage({
    required this.brandName,
    required this.componentName,
    super.key,
  });

  @override
  State<TypeDetailPage> createState() => _TypeDetailPageState();
}

class _TypeDetailPageState extends State<TypeDetailPage> {
  String? selectedCategory;

  final Map<String, Color> categoryColors = {
    'LCD': Colors.cyanAccent,
    'Network': Colors.yellowAccent,
    'SIM Card': Colors.purpleAccent,
    'LCD Light': Colors.tealAccent,
    'Back Camera': Colors.blueAccent,
    'Front Camera': Colors.orangeAccent,
    'Touch Screen': Colors.greenAccent,
    'Audio Circuit': Colors.pinkAccent,
    'Micro USB 2.0': Colors.redAccent,
    'Diode Voltage Drop': Colors.amberAccent,
    'eMMC Pinout for ISP': Colors.deepPurpleAccent,
    'Input Output Voltages': Colors.lightBlueAccent,
    'On Off Volume Keys': Colors.limeAccent,
    'Voltage Parametric': Colors.indigoAccent,
    'WiFi Bluetooth GPS': Colors.deepOrangeAccent,
  };

  final List<String> categories = [
    'LCD',
    'Network',
    'SIM Card',
    'LCD Light',
    'Back Camera',
    'Front Camera',
    'Touch Screen',
    'Audio Circuit',
    'Micro USB 2.0',
    'Diode Voltage Drop',
    'eMMC Pinout for ISP',
    'Input Output Voltages',
    'On Off Volume Keys',
    'Voltage Parametric',
    'WiFi Bluetooth GPS',
  ];

  final Map<String, List<Map<String, dynamic>>> multiSvgMap = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.componentName),
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF0A192F)
            : Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 20.0,
              boundaryMargin: const EdgeInsets.all(200),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    getImageForComponent(widget.componentName),
                    fit: BoxFit.contain,
                  ),
                  if (selectedCategory != null)
                    ..._buildSvgOverlaysForCategory(selectedCategory!),
                ],
              ),
            ),
          ),


          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E1E1E),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedCategory = null;
                      } else {
                        selectedCategory = cat;
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0A192F)
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (categoryColors[cat] ?? Colors.white)
                            : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSvgOverlaysForCategory(String category) {
    final key = category;
    final list = multiSvgMap[key];

    if (list == null || list.isEmpty) {
      final fallback = getSvgForCategory(category);
      return [
        SvgPicture.asset(
          fallback,
          fit: BoxFit.contain,
        ),
      ];
    }

    return list.map((item) {
      final String file = item['file'] as String;
      final Color? color = item['color'] as Color?;
      return SvgPicture.asset(
        file,
        fit: BoxFit.contain,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );
    }).toList();
  }

  String getImageForComponent(String name) {
    switch (name.toLowerCase()) {
      case 'motherboard':
      case 'cpu':
      case 'galaxy s6 - layout':
        return 'assets/images/Guideline/G532F.png';
      default:
        return 'assets/images/Guideline/G532F.png';
    }
  }

  String getSvgForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'wifi bluetooth gps':
        return 'assets/images/Guideline/WiFi Bluetooth GPS.svg';
      case 'voltage parametric':
        return 'assets/images/Guideline/Voltage Parametric.svg';
      case 'on off volume keys':
        return 'assets/images/Guideline/On Off Volume Keys.svg';
      case 'input output voltages':
        return 'assets/images/Guideline/Input Output Voltages.svg';
      case 'emmc pinout for isp':
        return 'assets/images/Guideline/eMMC Pinout for ISP.svg';
      case 'diode voltage drop':
        return 'assets/images/Guideline/Diode Voltage Drop.svg';
      case 'micro usb 2.0':
        return 'assets/images/Guideline/Micro USB 2.0.svg';
      case 'touch screen':
        return 'assets/images/Guideline/Touch Screen.svg';
      case 'front camera':
        return 'assets/images/Guideline/Front Camera.svg';
      case 'back camera':
        return 'assets/images/Guideline/Back Camera.svg';
      case 'network':
        return 'assets/images/Guideline/Network.svg';
      case 'lcd':
        return 'assets/images/Guideline/LCD.svg';
      case 'lcd light':
        return 'assets/images/Guideline/LCD Light.svg';
      case 'audio circuit':
        return 'assets/images/Guideline/Audio Circuit.svg';
      case 'sim card':
        return 'assets/images/Guideline/SIM Card.svg';
      default:
        return 'assets/images/Guideline/Default.svg';
    }
  }
}
// =====================  Bagian Release & Update =====================
class _UpdateListSection extends StatefulWidget {
  const _UpdateListSection({Key? key}) : super(key: key);

  @override
  State<_UpdateListSection> createState() => _UpdateListSectionState();
}

class _UpdateListSectionState extends State<_UpdateListSection> {
  int _expandedIndex = -1;

  final List<Map<String, String>> updates = [
    {
      'date': '04 November 2025',
      'detail':
          '🔧 Perbaikan tampilan halaman login dan sistem logout agar lebih stabil.',
    },
    {
      'date': '03 November 2025',
      'detail':
          '🧠 Penambahan fitur brand list horizontal dan logo image di HomePage.',
    },
    {
      'date': '02 November 2025',
      'detail':
          '💡 Pembaruan UI futuristik dengan efek bayangan lembut dan transisi smooth.',
    },
    {
      'date': '01 November 2025',
      'detail': '🚀 Peluncuran awal versi demo ORION SCHEMATIC!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Release & Updates',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(updates.length, (index) {
            final update = updates[index];
            final isExpanded = _expandedIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? -1 : index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            update['date']!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 2,
                            right: 2,
                            bottom: 6,
                          ),
                          child: Text(
                            update['detail']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}



// ======================================================
// 🎬 ULTRA PREMIUM Video Player Page (Orion Edition)
// ======================================================
class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String url;

  const VideoPlayerPage({
    required this.title,
    required this.url,
    super.key,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.url);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        forceHD: true,
        controlsVisibleAtStart: true,
        enableCaption: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF030B1A);
    const neonCyan = Color(0xFF00E5FF);

    return Scaffold(
      backgroundColor: darkBlue,

      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Orion Tutorial",
          style: TextStyle(
            color: neonCyan,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        centerTitle: true,
      ),

      body: YoutubePlayerBuilder(
        player: YoutubePlayer(controller: _controller),
        builder: (context, player) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF031124), Color(0xFF020C18)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // 🔥 Konten
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // PLAYER CARD
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white.withOpacity(0.04),
                        boxShadow: [
                          BoxShadow(
                            color: neonCyan.withOpacity(0.35),
                            blurRadius: 25,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: neonCyan.withOpacity(0.35),
                          width: 1.4,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: player,
                    ),

                    const SizedBox(height: 32),

                    // ⭐ TITLE
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.3,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ⭐ FULL WIDTH TITLE UNDERLINE (AUTO MATCH TEXT)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final title = widget.title;
                        final tp = TextPainter(
                          text: TextSpan(
                            text: title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.7,
                            ),
                          ),
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        )..layout();

                        final textWidth = tp.width;

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: textWidth, // AUTO MATCH TITLE
                            height: 5,
                            decoration: BoxDecoration(
                              color: neonCyan,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: neonCyan.withOpacity(0.7),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 26),

                    // DESCRIPTION BOX
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.04),
                        border: Border.all(
                          color: neonCyan.withOpacity(0.22),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: neonCyan.withOpacity(0.16),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Text(
                        "This exclusive Orion tutorial video will guide you through "
                            "the most powerful features of the app including IC Finder, "
                            "Board Analysis, File Navigation, and advanced professional tools.\n\n"
                            "Enjoy HD playback with futuristic UI, neon glow visuals, "
                            "and the best interactive learning experience.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.5,
                          height: 1.55,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}



