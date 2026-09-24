import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/bank_soal_data.dart';
import '../../../data/dummy_data.dart';
import '../../../providers/bank_soal_provider.dart';
import 'subject_detail_screen.dart';

/// Layar utama Bank Soal TKA: statistik + grid 8 mapel.
class BankSoalScreen extends StatelessWidget {
  const BankSoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = context.watch<BankSoalProvider>();
    final materi = DummyData.materiBelajar;

    Color colorFor(String id) {
      final m = materi.firstWhere((e) => e.id == id,
          orElse: () => materi.first);
      return m.backgroundColor;
    }

    IconData iconFor(String id) {
      final m = materi.firstWhere((e) => e.id == id,
          orElse: () => materi.first);
      return m.icon;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bank Soal TKA',
            style: AppTextStyles.h2.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: _stat('${bank.totalAttempts}x',
                          'Latihan')),
                  Expanded(
                      child: _stat(
                          bank.averageScore
                              .toStringAsFixed(0),
                          'Rata-rata')),
                  Expanded(
                      child:
                          _stat('${bank.packs.length}', 'Mapel')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Pilih Mata Pelajaran',
                style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text(
              '40 soal TKA dalam 8 mapel, lengkap dengan pembahasan.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: BankSoalData.packs.length,
              itemBuilder: (context, i) {
                final pack = BankSoalData.packs[i];
                final score = bank.bestScore(pack.subjectId);
                final attempt = bank.attempts(pack.subjectId);
                return CustomCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectDetailScreen(
                            pack: pack),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colorFor(pack.subjectId),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Icon(
                                iconFor(pack.subjectId),
                                color: Colors.white),
                          ),
                          const Spacer(),
                          if (score > 0)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3),
                              decoration: BoxDecoration(
                                color: score >= 80
                                    ? AppColors.premiumTag
                                    : AppColors.freeTag,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Text(
                                score.toStringAsFixed(0),
                                style: AppTextStyles.caption
                                    .copyWith(
                                  fontWeight:
                                      FontWeight.w900,
                                  color: score >= 80
                                      ? AppColors
                                          .premiumTagText
                                      : AppColors
                                          .freeTagText,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(pack.subjectName,
                          style: AppTextStyles.body
                              .copyWith(
                                  fontWeight:
                                      FontWeight.w800)),
                      Text(
                        '${pack.totalQuestions} soal • ${pack.durationMinutes} mnt${attempt > 0 ? ' • ${attempt}x latihan' : ''}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.h1
                .copyWith(color: Colors.white)),
        Text(label,
            style: AppTextStyles.caption
                .copyWith(color: Colors.white70)),
      ],
    );
  }
}
