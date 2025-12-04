import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:orionschematic/pages/others_page.dart';
import 'package:orionschematic/pages/ic_page.dart';
import 'package:orionschematic/pages/home_page.dart';
import 'package:orionschematic/pages/shop_page.dart';

class HomeShellX extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeShellX({
    required this.onLogout,
    required this.onToggleTheme,
    required this.themeMode,
    super.key,
  });

  @override
  State<HomeShellX> createState() => _HomeShellXState();
}

class _HomeShellXState extends State<HomeShellX> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _drawerOpen = false;
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  final List<IconData> _icons = const [
    Icons.home_rounded,
    Icons.memory_rounded,
    Icons.shopping_bag_rounded,
    Icons.widgets_rounded,
  ];

  final List<String> _labels = const [
    'Home',
    'IC Finder',
    'Shop',
    'Others',
  ];

  late final List<Widget> _pages = [
    HomePageFuturistic(onLogout: widget.onLogout),
    FindICPage(),
    ShopPage(),
    OthersPage(),
  ];

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,

      // callback drawer buka tutup
      onDrawerChanged: (isOpen) {
        setState(() {
          _drawerOpen = isOpen;
        });
      },

      drawer: _buildNeoDrawer(isDark),

      // JANGAN extendBody, ini penyebab niban
      extendBody: false,

      body: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),

      bottomNavigationBar:
      _drawerOpen ? null : _buildFuturisticBottomBar(isDark),
    );
  }

  // FUTURISTIC NAV BAR
  Widget _buildFuturisticBottomBar(bool isDark) {
    return Container(
      height: 78,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? Colors.black54
            : Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.cyanAccent.withOpacity(0.15)
                : Colors.deepOrange.withOpacity(0.25),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_icons.length, (index) {
                final selected = _currentIndex == index;

                final color = selected
                    ? (isDark
                    ? Colors.cyanAccent.withOpacity(0.8)
                    : Colors.deepOrange.withOpacity(0.85))
                    : (isDark ? Colors.white70 : Colors.black54);

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateTo(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: selected
                            ? (isDark
                            ? Colors.cyanAccent.withOpacity(0.04)
                            : Colors.deepOrange.withOpacity(0.05))
                            : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _icons[index],
                            size: selected ? 28 : 22,
                            color: color,
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: selected ? 12 : 11,
                              color: color,
                              fontWeight:
                              selected ? FontWeight.bold : FontWeight.w400,
                            ),
                            child: Text(_labels[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }


  // DRAWER
  Widget _buildNeoDrawer(bool isDark) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF041822), const Color(0xFF0A2433)]
                : [Colors.orange.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                      Colors.cyanAccent.withOpacity(0.15),
                      Colors.transparent
                    ]
                        : [
                      Colors.deepOrangeAccent.withOpacity(0.15),
                      Colors.transparent
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark
                          ? Colors.cyanAccent.withOpacity(0.25)
                          : Colors.deepOrange.withOpacity(0.25),
                      child:
                      const Icon(Icons.person_rounded, size: 38),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Orion Schematic",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          "Futuristic Control Hub",
                          style: TextStyle(
                            fontSize: 13,
                            color:
                            isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              ListTile(
                leading: Icon(Icons.logout_rounded,
                    color:
                    isDark ? Colors.cyanAccent : Colors.deepOrange),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                onTap: widget.onLogout,
              ),

              ListTile(
                leading: Icon(Icons.brightness_6_rounded,
                    color:
                    isDark ? Colors.cyanAccent : Colors.deepOrange),
                title: Text(
                  "Toggle Theme",
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                onTap: widget.onToggleTheme,
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "⚡ Orion Schematic X v3.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}