import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/app_provider.dart';

/// Chip streak api 🔥 + jumlah hari.
class StreakChip extends StatelessWidget {
  final int streak;
  final VoidCallback? onTap;

  const StreakChip({super.key, required this.streak, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: streak > 0
              ? AppColors.accentOrange
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔥',
                style:
                    AppTextStyles.caption.copyWith(fontSize: 13)),
            const SizedBox(width: 3),
            Text(
              '$streak',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu streak 7 hari (H-6 .. hari ini).
class StreakWeekCard extends StatelessWidget {
  final int streak;

  const StreakWeekCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // Streak aktif = hari ini sudah login → N hari terakhir aktif.
    // Tampilkan 7 hari terakhir, yang aktif = min(streak, 7) hari terakhir.
    final activeCount = streak.clamp(0, 7);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFE91E63)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('$streak hari beruntun!',
                        style: AppTextStyles.h3.copyWith(
                            color: Colors.white)),
                    Text(
                      streak <= 1
                          ? 'Login tiap hari biar streak naik & bonus makin besar'
                          : 'Pertahankan! Bonus harian makin besar',
                      style: AppTextStyles.caption.copyWith(
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final day = today.subtract(
                  Duration(days: 6 - i));
              final isActive = i >= 7 - activeCount;
              const names = [
                'S',
                'S',
                'R',
                'K',
                'J',
                'S',
                'M'
              ];
              final wd = names[day.weekday % 7];
              final bonus =
                  AppProvider.dailyBonusFor(
                      (streak - (6 - i)).clamp(1, 7));
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white
                              .withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Text(isActive ? '🔥' : wd,
                        style: AppTextStyles.body.copyWith(
                            fontWeight:
                                FontWeight.w900)),
                  ),
                  const SizedBox(height: 4),
                  Text('${day.day}',
                      style:
                          AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w700)),
                  Text('+$bonus',
                      style:
                          AppTextStyles.caption.copyWith(
                              color: Colors.white70,
                              fontSize: 10)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Dialog check-in harian. Dipanggil sekali saat hari baru.
class DailyCheckinDialog extends StatelessWidget {
  final int streak;
  final int bonus;

  const DailyCheckinDialog(
      {super.key, required this.streak, required this.bonus});

  static Future<void> show(
      BuildContext context, int streak) {
    final bonus = AppProvider.dailyBonusFor(streak);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          DailyCheckinDialog(streak: streak, bonus: bonus),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text('Login Hari ke-$streak!',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Streak 🔥$streak • Bonus +$bonus koin +5 XP masuk otomatis',
              style: AppTextStyles.body,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          StreakWeekCard(streak: streak),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Klaim & Belajar!'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog naik level terpusat.
class LevelUpDialog extends StatelessWidget {
  final String message;
  const LevelUpDialog({super.key, required this.message});

  static Future<void> showIfNeeded(BuildContext context) async {
    // Dipanggil setelah earn(); baca pesan pending dari provider.
    // Import provider di file pemanggil untuk hindari cycle.
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Naik Level! 🎉'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mantap!')),
      ],
    );
  }
}
