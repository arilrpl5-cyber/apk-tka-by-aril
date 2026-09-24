import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/bank_soal_data.dart';
import '../../../models/question_model.dart';
import '../../../providers/bank_soal_provider.dart';
import 'quiz_screen.dart';

/// Detail mapel: info paket + daftar soal + tombol mulai.
class SubjectDetailScreen extends StatelessWidget {
  final SubjectPackModel pack;

  const SubjectDetailScreen({super.key, required this.pack});

  @override
  Widget build(BuildContext context) {
    final questions =
        BankSoalData.questionsBySubject(pack.subjectId);
    final best =
        context.watch<BankSoalProvider>().bestScore(pack.subjectId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(pack.subjectName,
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.quiz_outlined,
                        color: AppColors.primaryBlue, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Paket Latihan ${pack.subjectName}',
                            style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w800)),
                        Text(
                          '${questions.length} soal • ${pack.durationMinutes} menit • Skor terbaik: ${best.toStringAsFixed(0)}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Mulai Kerjakan',
              icon: const Icon(Icons.play_arrow,
                  color: Colors.white, size: 18),
              width: double.infinity,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        QuizScreen(pack: pack),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Daftar Soal', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            ...questions.asMap().entries.map((e) {
              final i = e.key;
              final q = e.value;
              return CustomCard(
                margin: const EdgeInsets.only(bottom: 10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                          pack: pack,
                          startIndex: i),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Text('${i + 1}',
                          style: AppTextStyles.body
                              .copyWith(
                                  fontWeight:
                                      FontWeight.w800)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(q.question,
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: AppTextStyles.body
                                  .copyWith(fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(q.difficulty,
                              style: AppTextStyles.caption
                                  .copyWith(
                                      fontSize: 11)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary),
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
}
