import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class PlatformsScreen extends StatelessWidget {
  const PlatformsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final platforms = {
      'Sosyal Medya': [
        {'name': 'YouTube', 'icon': Icons.play_circle_outline, 'color': const Color(0xFFFF0000)},
        {'name': 'TikTok', 'icon': Icons.music_note, 'color': const Color(0xFF000000)},
        {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': const Color(0xFFE4405F)},
        {'name': 'Twitter (X)', 'icon': Icons.tag, 'color': const Color(0xFF1DA1F2)},
        {'name': 'Facebook', 'icon': Icons.facebook, 'color': const Color(0xFF1877F2)},
        {'name': 'Reddit', 'icon': Icons.reddit, 'color': const Color(0xFFFF4500)},
      ],
      'Video & Yayın': [
        {'name': 'Twitch', 'icon': Icons.videocam, 'color': const Color(0xFF9146FF)},
        {'name': 'Kick', 'icon': Icons.sports_esports, 'color': const Color(0xFF53FC18)},
        {'name': 'Vimeo', 'icon': Icons.video_library, 'color': const Color(0xFF1AB7EA)},
        {'name': 'Dailymotion', 'icon': Icons.movie, 'color': const Color(0xFF0066DC)},
      ],
      'Müzik': [
        {'name': 'SoundCloud', 'icon': Icons.cloud, 'color': const Color(0xFFFF5500)},
        {'name': 'Bandcamp', 'icon': Icons.album, 'color': const Color(0xFF629AA9)},
        {'name': 'Spotify', 'icon': Icons.music_note, 'color': const Color(0xFF1DB954)},
      ],
    };

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
                            'Desteklenen Platformlar',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1000+ platform destekleniyor',
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

              // Platforms List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: platforms.length,
                  itemBuilder: (context, index) {
                    final category = platforms.keys.elementAt(index);
                    final items = platforms[category]!;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: items.map((platform) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (platform['color'] as Color).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: (platform['color'] as Color).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        platform['icon'] as IconData,
                                        color: platform['color'] as Color,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        platform['name'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: (200 * index).ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    );
                  },
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(24),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'yt-dlp ile desteklenmektedir',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
