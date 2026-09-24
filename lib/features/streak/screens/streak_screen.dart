import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../providers/app_provider.dart';
import '../widgets/streak_widgets.dart';

/// Layar streak & hadiah harian.
class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().user;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Streak Harian',
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreakWeekCard(streak: user.streak),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _mini('Streak\nsaat ini',
                        '🔥${user.streak} hari')),
                const SizedBox(width: 10),
                Expanded(
                    child: _mini('Terpanjang',
                        '🏆${user.longestStreak} hari')),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        _mini('Total XP', '⭐${user.totalXP}')),
              ],
            ),
            const SizedBox(height: 16),
            Text('Jadwal Bonus Harian',
                style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text('Login 7 hari berturut-turut, bonus hari ke-7 paling besar. Lalu berulang.',
                style: AppTextStyles.caption),
            const SizedBox(height: 8),
            ...List.generate(7, (i) {
              final day = i + 1;
              final bonus =
                  AppProvider.dailyBonusFor(day);
              final reached = user.streak >= day ||
                  (user.streak % 7 >= day && user.streak > 7);
              return CustomCard(
                margin:
                    const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: reached
                            ? AppColors.accentGreen
                            : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Text(reached ? '✅' : 'H$day',
                          style: AppTextStyles.body
                              .copyWith(
                                  fontWeight:
                                      FontWeight.w900)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text('Hari ke-$day',
                            style: AppTextStyles.body
                                .copyWith(
                                    fontWeight:
                                        FontWeight.w700))),
                    Text('+$bonus koin +5 XP',
                        style:
                            AppTextStyles.caption.copyWith(
                                fontWeight:
                                    FontWeight.w800,
                                color: AppColors
                                    .primaryBlue)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _mini(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(value,
              style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
