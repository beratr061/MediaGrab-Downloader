import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../models/download_option.dart';
import '../services/download_service.dart';
import '../services/permission_service.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import 'cookies_settings_screen.dart';
import 'settings_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final bool showBottomNav;
  
  const HomeScreen({super.key, this.showBottomNav = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final DownloadService _downloadService = DownloadService();
  final PermissionService _permissionService = PermissionService();
  
  DownloadOption _selectedOption = DownloadOption.videoAudio;
  bool _useCookies = true; // Her zaman aktif
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _ytDlpVersion;
  StreamSubscription? _downloadSubscription;

  @override
  void initState() {
    super.initState();
    _checkYtDlp();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _downloadSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkYtDlp() async {
    final version = await _downloadService.getYtDlpVersion();
    if (mounted) {
      setState(() {
        _ytDlpVersion = version;
      });
    }
  }

  Future<void> _startDownload() async {
    if (_urlController.text.isEmpty) {
      _showSnackBar('Lütfen bir URL girin', isError: true);
      return;
    }

    if (_ytDlpVersion == null) {
      _showSnackBar('yt-dlp yüklü değil', isError: true);
      return;
    }

    final hasPermission = await _permissionService.requestStoragePermission();
    if (!hasPermission) {
      _showSnackBar('Depolama izni gerekli', isError: true);
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      _downloadSubscription = _downloadService
          .downloadVideo(
            url: _urlController.text.trim(),
            option: _selectedOption,
            useCookies: _useCookies,
          )
          .listen(
            (progress) {
              setState(() {
                _downloadProgress = progress;
              });
            },
            onDone: () {
              setState(() {
                _isDownloading = false;
                _downloadProgress = 0.0;
              });
              _showSnackBar('İndirme tamamlandı!', isError: false);
              _urlController.clear();
            },
            onError: (error) {
              setState(() {
                _isDownloading = false;
                _downloadProgress = 0.0;
              });
              _showSnackBar('Hata: ${error.toString()}', isError: true);
            },
          );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
      _showSnackBar('Hata: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: const Color(0xFFFF6B9D),
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Vid',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text: 'Down',
                                style: TextStyle(
                                  color: Color(0xFFFF6B9D),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                    // Theme & Menu
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                          },
                          icon: Icon(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Hero Title
                      _buildHeroSection(isDark),
                      
                      const SizedBox(height: 40),
                      
                      // URL Input
                      _buildModernUrlInput(isDark),
                      
                      const SizedBox(height: 20),
                      
                      // Download Button
                      _buildModernDownloadButton(isDark),
                      
                      const SizedBox(height: 32),
                      
                      // Supported Platforms
                      Text(
                        'Desteklenen Platformlar:',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPlatformIcons(isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Format Options (Compact) - Sadece format seçimi
                      if (_urlController.text.isNotEmpty)
                        _buildCompactFormatOptions(isDark),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B9D).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B9D),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.freeSocialMedia,
                style: const TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.yourUltimate,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.w300,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.downloader,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 42,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.description,
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54,
            fontSize: 14,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildModernUrlInput(bool isDark) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _urlController,
        enabled: !_isDownloading,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: l10n.insertLink,
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.link_rounded,
            color: isDark ? Colors.white54 : Colors.black45,
            size: 22,
          ),
          suffixIcon: _urlController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  onPressed: () {
                    setState(() {
                      _urlController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildModernDownloadButton(bool isDark) {
    return InkWell(
      onTap: _isDownloading ? null : _startDownload,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: _isDownloading
              ? LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                )
              : const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: (_isDownloading ? Colors.grey : const Color(0xFFFF6B9D)).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _isDownloading
            ? Column(
                children: [
                  const Text(
                    'İndiriliyor...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _downloadProgress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Text(
                'İndir',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildPlatformIcons(bool isDark) {
    final platforms = [
      {'icon': Icons.facebook, 'name': 'Facebook'},
      {'icon': Icons.video_library, 'name': 'Instagram'},
      {'icon': Icons.play_circle, 'name': 'YouTube'},
      {'icon': Icons.music_note, 'name': 'TikTok'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: platforms.map((platform) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Icon(
              platform['icon'] as IconData,
              color: isDark ? Colors.white60 : Colors.black54,
              size: 24,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 700.ms, duration: 600.ms);
  }

  Widget _buildCompactFormatOptions(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Format Seçenekleri',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFormatChip('Video + Ses', DownloadOption.videoAudio, isDark),
              _buildFormatChip('MP3', DownloadOption.audioMp3, isDark),
              _buildFormatChip('Ses', DownloadOption.audioOriginal, isDark),
              _buildFormatChip('Sadece Video', DownloadOption.videoOnly, isDark),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildFormatChip(String label, DownloadOption option, bool isDark) {
    final isSelected = _selectedOption == option;
    return InkWell(
      onTap: _isDownloading ? null : () {
        setState(() {
          _selectedOption = option;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB3)],
                )
              : null,
          color: isSelected ? null : (isDark ? Colors.white.withOpacity(0.08) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1A0B2E) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFF8B5CF6)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hello 👋',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Guest User',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: isDark ? Colors.white10 : Colors.black12),
            // Menu Items
            _buildDrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.download_outlined,
              title: 'Downloads',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.description_outlined,
              title: 'Terms',
              isDark: isDark,
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy',
              isDark: isDark,
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'About',
              isDark: isDark,
              onTap: () {},
            ),
            const Spacer(),
            Divider(color: isDark ? Colors.white10 : Colors.black12),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Colors.white70 : Colors.black54,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
