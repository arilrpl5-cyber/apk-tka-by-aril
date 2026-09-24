import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../providers/app_provider.dart';

/// Riwayat perolehan poin (XP & koin).
class PointHistoryScreen extends StatelessWidget {
  const PointHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppProvider>().history;
    final fmt = DateFormat('d MMM HH:mm', 'id_ID');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Riwayat Poin',
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history,
                      size: 56,
                      color: AppColors.textSecondary),
                  const SizedBox(height: 8),
                  Text('Belum ada poin',
                      style: AppTextStyles.h3),
                  Text(
                      'Kerjakan bab / quiz untuk dapat XP & koin',
                      style: AppTextStyles.caption),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (_, i) {
                final e = history[i];
                String dateStr;
                try {
                  dateStr = fmt.format(e.date);
                } catch (_) {
                  dateStr =
                      '${e.date.day}/${e.date.month} ${e.date.hour}:${e.date.minute.toString().padLeft(2, '0')}';
                }
                return CustomCard(
                  margin:
                      const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: e.xp > 0
                              ? AppColors.primaryLight
                              : const Color(0xFFFFF9C4),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                            e.xp > 0 ? '⭐' : '🪙',
                            style: const TextStyle(
                                fontSize: 20)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(e.title,
                                style: AppTextStyles.body
                                    .copyWith(
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                        fontSize: 13)),
                            Text(dateStr,
                                style:
                                    AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          if (e.xp > 0)
                            Text('+${e.xp} XP',
                                style: AppTextStyles
                                    .caption
                                    .copyWith(
                                        color: AppColors
                                            .primaryBlue,
                                        fontWeight:
                                            FontWeight
                                                .w900)),
                          if (e.coins != 0)
                            Text(
                                '${e.coins > 0 ? '+' : ''}${e.coins} koin',
                                style: AppTextStyles
                                    .caption
                                    .copyWith(
                                        color: AppColors
                                            .coinGold,
                                        fontWeight:
                                            FontWeight
                                                .w800)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
