import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/bank_soal_data.dart';
import '../../../data/chapter_content_data.dart';
import '../../../models/models.dart';
import '../../../providers/app_provider.dart';
import '../../bank_soal/screens/subject_detail_screen.dart';
import 'chapter_detail_screen.dart';

/// Detail materi per mapel: daftar bab (SEMUA bisa dibuka) + progres + latihan.
class MateriDetailScreen extends StatelessWidget {
  final MaterialModel material;

  const MateriDetailScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final chapters =
        ChapterData.chaptersOf(material.id, material.name);
    final doneCount =
        chapters.where((c) => app.isChapterDone(c.id)).length;
    final pack = BankSoalData.packs.firstWhere(
      (p) => p.subjectId == material.id,
      orElse: () => BankSoalData.packs.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(material.name,
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: material.backgroundColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: material.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Icon(material.icon,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(material.name,
                                style: AppTextStyles.h3),
                            Text(
                                '$doneCount/${chapters.length} bab selesai • Video + Rangkuman + Latihan',
                                style:
                                    AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: chapters.isEmpty
                          ? 0
                          : doneCount / chapters.length,
                      minHeight: 8,
                      backgroundColor: Colors.white,
                      valueColor:
                          const AlwaysStoppedAnimation(
                              AppColors.accentGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Daftar Bab — tap untuk buka',
                style: AppTextStyles.h3),
            const SizedBox(height: 8),
            ...chapters.map((c) {
              final done = app.isChapterDone(c.id);
              final bookmarked = app.isBookmarked(c.id);
              return CustomCard(
                margin:
                    const EdgeInsets.only(bottom: 10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChapterDetailScreen(
                              chapter: c,
                              material: material),
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
                        color: done
                            ? AppColors.accentGreen
                            : AppColors.primaryLight,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: done
                          ? const Icon(Icons.check,
                              color: Colors.white,
                              size: 20)
                          : Text('${c.index}',
                              style: AppTextStyles.body
                                  .copyWith(
                                      fontWeight:
                                          FontWeight.w800,
                                      color: AppColors
                                          .primaryBlue)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(c.title,
                              style: AppTextStyles.body
                                  .copyWith(
                                      fontWeight:
                                          FontWeight.w700)),
                          Text(
                            done
                                ? 'Selesai ✅ • +${c.xpReward} XP didapat'
                                : '${c.durationMinutes} mnt • +${c.xpReward} XP',
                            style:
                                AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    if (bookmarked)
                      const Icon(Icons.bookmark,
                          color: AppColors.primaryBlue,
                          size: 20),
                    const SizedBox(width: 4),
                    const Icon(
                        Icons.play_circle_outline,
                        color: AppColors.primaryBlue),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Latihan Soal ${material.name}',
              width: double.infinity,
              icon: const Icon(Icons.quiz_outlined,
                  color: Colors.white, size: 18),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SubjectDetailScreen(pack: pack),
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
}
