import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientBackground extends StatefulWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF1A0B2E), // Deep purple
                      Color(0xFF2D1B4E), // Purple
                      Color(0xFF4A2C6D), // Lighter purple
                      Color(0xFF2D1B4E),
                    ]
                  : const [
                      Color(0xFFF5F5F5), // Light gray
                      Color(0xFFE8E8F0), // Light purple tint
                      Color(0xFFD8D8E8), // Slightly darker
                      Color(0xFFE8E8F0),
                    ],
            ),
          ),
          child: Stack(
            children: [
              // Animated gradient orbs
              Positioned(
                top: 50 + math.sin(_controller.value * 2 * math.pi) * 30,
                right: 30 + math.cos(_controller.value * 2 * math.pi) * 20,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              const Color(0xFFFF6B9D).withOpacity(0.4),
                              const Color(0xFFFF6B9D).withOpacity(0.0),
                            ]
                          : [
                              const Color(0xFFFF6B9D).withOpacity(0.15),
                              const Color(0xFFFF6B9D).withOpacity(0.0),
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100 + math.cos(_controller.value * 2 * math.pi + 1) * 40,
                left: 20 + math.sin(_controller.value * 2 * math.pi + 1) * 30,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF8B5CF6).withOpacity(0.4),
                              const Color(0xFF8B5CF6).withOpacity(0.0),
                            ]
                          : [
                              const Color(0xFF8B5CF6).withOpacity(0.15),
                              const Color(0xFF8B5CF6).withOpacity(0.0),
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 200 + math.sin(_controller.value * 2 * math.pi + 2) * 25,
                left: 100 + math.cos(_controller.value * 2 * math.pi + 2) * 25,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF6366F1).withOpacity(0.3),
                              const Color(0xFF6366F1).withOpacity(0.0),
                            ]
                          : [
                              const Color(0xFF6366F1).withOpacity(0.12),
                              const Color(0xFF6366F1).withOpacity(0.0),
                            ],
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}
