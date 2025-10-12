import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/binary_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB3)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ).animate().scale(delay: 100.ms, duration: 600.ms),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.settings,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                            ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
                            Text(
                              'Customize your experience',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Settings List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    
                    // Theme Setting
                    _buildSettingCard(
                      context: context,
                      isDark: isDark,
                      icon: themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      title: l10n.theme,
                      subtitle: themeProvider.isDarkMode ? l10n.darkModeActive : l10n.lightModeActive,
                      child: Row(
                        children: [
                          _buildThemeOption(
                            context: context,
                            icon: Icons.light_mode_rounded,
                            label: l10n.lightMode,
                            isSelected: !themeProvider.isDarkMode,
                            onTap: () {
                              if (themeProvider.isDarkMode) {
                                themeProvider.toggleTheme();
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildThemeOption(
                            context: context,
                            icon: Icons.dark_mode_rounded,
                            label: l10n.darkMode,
                            isSelected: themeProvider.isDarkMode,
                            onTap: () {
                              if (!themeProvider.isDarkMode) {
                                themeProvider.toggleTheme();
                              }
                            },
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

                    const SizedBox(height: 20),

                    // Language Setting
                    _buildSettingCard(
                      context: context,
                      isDark: isDark,
                      icon: Icons.language_rounded,
                      title: l10n.language,
                      subtitle: l10n.chooseLanguage,
                      child: Column(
                        children: LocaleProvider.supportedLocales.map((locale) {
                          final isSelected = localeProvider.locale == locale;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () => localeProvider.setLocale(locale),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : Theme.of(context).colorScheme.surface.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : Theme.of(context).colorScheme.outline.withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF6366F1).withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.circle_outlined,
                                      color: isSelected
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      LocaleProvider.languageNames[locale.languageCode] ?? '',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Theme.of(context).colorScheme.onSurface,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

                    const SizedBox(height: 20),

                    // Binary Status
                    _BinaryStatusCard().animate().fadeIn(delay: 700.ms, duration: 600.ms),

                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                : null,
            color: isSelected ? null : Theme.of(context).colorScheme.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outline.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BinaryStatusCard extends StatefulWidget {
  const _BinaryStatusCard();

  @override
  State<_BinaryStatusCard> createState() => _BinaryStatusCardState();
}

class _BinaryStatusCardState extends State<_BinaryStatusCard> {
  String? _ytdlpVersion;
  String? _ffmpegVersion;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBinaries();
  }

  Future<void> _checkBinaries() async {
    setState(() => _isLoading = true);
    
    try {
      final ytdlpVer = await BinaryManager.getYtDlpVersion();
      final ffmpegVer = await BinaryManager.getFFmpegVersion();
      
      setState(() {
        _ytdlpVersion = ytdlpVer;
        _ffmpegVersion = ffmpegVer;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _ytdlpVersion = null;
        _ffmpegVersion = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.terminal_rounded,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Binary Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Embedded tools status',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ),
              if (!_isLoading)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _checkBinaries,
                  tooltip: 'Refresh',
                ),
            ],
          ),
          const SizedBox(height: 20),
          
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            _buildBinaryStatus(
              context: context,
              name: 'yt-dlp',
              version: _ytdlpVersion,
              icon: Icons.download_rounded,
            ),
            const SizedBox(height: 12),
            _buildBinaryStatus(
              context: context,
              name: 'FFmpeg',
              version: _ffmpegVersion,
              icon: Icons.video_library_rounded,
            ),
            const SizedBox(height: 12),
            _buildBinaryStatus(
              context: context,
              name: 'FFprobe',
              version: _ffmpegVersion != null ? 'OK' : null,
              icon: Icons.info_rounded,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBinaryStatus({
    required BuildContext context,
    required String name,
    required String? version,
    required IconData icon,
  }) {
    final isAvailable = version != null;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable
            ? const Color(0xFF10B981).withOpacity(0.1)
            : const Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFEF4444).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (version != null)
                  Text(
                    version,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            isAvailable ? Icons.check_circle_rounded : Icons.error_rounded,
            color: isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            size: 20,
          ),
        ],
      ),
    );
  }
}
