import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

/// Logo TKA Test.
/// Pakai asset `assets/images/logo.png` (gambar yang user berikan).
/// Kalau file belum ada, otomatis fallback ke logo teks agar tidak error.
class AppLogo extends StatelessWidget {
  final double size;
  final double borderRadius;

  const AppLogo({super.key, this.size = 44, this.borderRadius = 12});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback: logo teks TKA biar UI tetap bagus tanpa asset.
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E5BB8), Color(0xFF3B7DD8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TKA',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: size * 0.32,
                    height: 1,
                  ),
                ),
                Text(
                  'Test',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: size * 0.2,
                    height: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Avatar user dengan fallback inisial.
class UserAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = avatarUrl != null && avatarUrl!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.25),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: hasUrl
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initial(),
              )
            : _initial(),
      ),
    );
  }

  Widget _initial() {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return Container(
      color: const Color(0xFF2C5F9E),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.h2.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Progress bar XP (putih/transparent, tinggi 6px).
class XpProgressBar extends StatelessWidget {
  final int current;
  final int max;
  final double height;
  final Color background;
  final Color foreground;

  const XpProgressBar({
    super.key,
    required this.current,
    required this.max,
    this.height = 6,
    this.background = Colors.white24,
    this.foreground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final progress = max <= 0 ? 0.0 : (current / max).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Container(
        height: height,
        color: background,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(color: foreground),
        ),
      ),
    );
  }
}
