import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../services/cookies_manager.dart';

class CookiesSettingsScreen extends StatefulWidget {
  const CookiesSettingsScreen({super.key});

  @override
  State<CookiesSettingsScreen> createState() => _CookiesSettingsScreenState();
}

class _CookiesSettingsScreenState extends State<CookiesSettingsScreen> {
  Map<String, dynamic> _cookiesInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCookiesInfo();
  }

  Future<void> _loadCookiesInfo() async {
    setState(() => _isLoading = true);
    final info = await CookiesManager.getCookiesInfo();
    setState(() {
      _cookiesInfo = info;
      _isLoading = false;
    });
  }

  Future<void> _importCookies() async {
    final success = await CookiesManager.importCookies();
    if (success) {
      _showSnackBar('Cookies başarıyla içe aktarıldı', isError: false);
      await _loadCookiesInfo();
    } else {
      _showSnackBar('Cookies içe aktarılamadı', isError: true);
    }
  }

  Future<void> _exportCookies() async {
    final success = await CookiesManager.exportCookies();
    if (success) {
      _showSnackBar('Cookies başarıyla dışa aktarıldı', isError: false);
    } else {
      _showSnackBar('Cookies dışa aktarılamadı', isError: true);
    }
  }

  Future<void> _deleteCookies() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cookies Sil'),
        content: const Text('Cookies dosyasını silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await CookiesManager.deleteCookies();
      if (success) {
        _showSnackBar('Cookies silindi', isError: false);
        await _loadCookiesInfo();
      } else {
        _showSnackBar('Cookies silinemedi', isError: true);
      }
    }
  }

  Future<void> _validateCookies() async {
    final isValid = await CookiesManager.validateCookies();
    if (isValid) {
      _showSnackBar('Cookies dosyası geçerli', isError: false);
    } else {
      _showSnackBar('Cookies dosyası geçersiz veya bulunamadı', isError: true);
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
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cookies Ayarları',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Giriş gerektiren siteler için',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // Status Card
                            GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (_cookiesInfo['exists'] ?? false)
                                              ? const Color(0xFF10B981).withOpacity(0.2)
                                              : const Color(0xFFF59E0B).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          (_cookiesInfo['exists'] ?? false)
                                              ? Icons.check_circle
                                              : Icons.warning,
                                          color: (_cookiesInfo['exists'] ?? false)
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFF59E0B),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Durum',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    'Cookies Dosyası',
                                    (_cookiesInfo['exists'] ?? false) ? 'Mevcut' : 'Yok',
                                    (_cookiesInfo['exists'] ?? false)
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  if (_cookiesInfo['exists'] ?? false) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      'Cookie Sayısı',
                                      '${_cookiesInfo['cookieCount'] ?? 0}',
                                      Colors.blue,
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      'Dosya Boyutu',
                                      '${(_cookiesInfo['size'] ?? 0) / 1024} KB',
                                      Colors.purple,
                                    ),
                                  ],
                                ],
                              ),
                            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                            const SizedBox(height: 24),

                            // Actions Card
                            GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6366F1).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.settings,
                                          color: Color(0xFF6366F1),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'İşlemler',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildActionButton(
                                    icon: Icons.file_upload,
                                    label: 'Cookies İçe Aktar',
                                    description: 'cookies.txt dosyası seç',
                                    color: const Color(0xFF10B981),
                                    onTap: _importCookies,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildActionButton(
                                    icon: Icons.file_download,
                                    label: 'Cookies Dışa Aktar',
                                    description: 'Mevcut cookies\'i kaydet',
                                    color: const Color(0xFF3B82F6),
                                    onTap: _exportCookies,
                                    enabled: _cookiesInfo['exists'] ?? false,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildActionButton(
                                    icon: Icons.verified,
                                    label: 'Cookies Doğrula',
                                    description: 'Format kontrolü yap',
                                    color: const Color(0xFFF59E0B),
                                    onTap: _validateCookies,
                                    enabled: _cookiesInfo['exists'] ?? false,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildActionButton(
                                    icon: Icons.delete,
                                    label: 'Cookies Sil',
                                    description: 'Cookies dosyasını kaldır',
                                    color: const Color(0xFFEF4444),
                                    onTap: _deleteCookies,
                                    enabled: _cookiesInfo['exists'] ?? false,
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

                            const SizedBox(height: 24),

                            // Info Card
                            GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8B5CF6).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.info_outline,
                                          color: Color(0xFF8B5CF6),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Nasıl Kullanılır?',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoText(
                                    '1. Tarayıcınızdan cookies.txt dosyasını dışa aktarın',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoText(
                                    '2. "Cookies İçe Aktar" ile dosyayı seçin',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoText(
                                    '3. Ana ekranda "Çerezleri kullan" seçeneğini aktif edin',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoText(
                                    '4. Giriş gerektiren siteleri indirebilirsiniz',
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                            const SizedBox(height: 24),
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

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled
              ? color.withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? color.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? color : Colors.white.withOpacity(0.3),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: enabled
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white.withOpacity(0.3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: enabled ? color : Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
