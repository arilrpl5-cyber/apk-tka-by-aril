import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/bank_soal_data.dart';
import '../../../data/chapter_content_data.dart';
import '../../../models/chapter_model.dart';
import '../../../models/material_model.dart';
import '../../../providers/app_provider.dart';
import '../../bank_soal/screens/subject_detail_screen.dart';

/// Detail bab: rangkuman + poin penting + contoh + tips + tandai selesai.
/// SEMUA bisa dibuka, selesai → dapat XP & koin tercatat di riwayat.
class ChapterDetailScreen extends StatefulWidget {
  final ChapterModel chapter;
  final MaterialModel? material;

  const ChapterDetailScreen(
      {super.key, required this.chapter, this.material});

  @override
  State<ChapterDetailScreen> createState() =>
      _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  bool _videoWatched = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final content =
        ChapterData.contentOf(widget.chapter.id);
    final done = app.isChapterDone(widget.chapter.id);
    final bookmarked = app.isBookmarked(widget.chapter.id);
    final downloaded = app.isDownloaded(widget.chapter.id);
    final bg = widget.material?.backgroundColor ??
        AppColors.primaryBlue;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bab ${widget.chapter.index}: ${widget.chapter.title}',
            style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AppProvider>()
                  .toggleBookmark(widget.chapter.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(bookmarked
                        ? 'Bookmark dihapus'
                        : 'Disimpan ke Bookmark ✅')),
              );
            },
            icon: Icon(
                bookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              context
                  .read<AppProvider>()
                  .toggleDownload(widget.chapter.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(downloaded
                        ? 'Download dihapus'
                        : 'Bab didownload, bisa dibuka offline ✅')),
              );
            },
            icon: Icon(
                downloaded
                    ? Icons.download_done
                    : Icons.download_outlined,
                color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bab
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bg.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Text('${widget.chapter.index}',
                        style: AppTextStyles.h2
                            .copyWith(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(widget.chapter.title,
                            style: AppTextStyles.h3),
                        Text(
                          '${widget.chapter.subjectName} • ${widget.chapter.durationMinutes} mnt • +${widget.chapter.xpReward} XP',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  if (done)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Text('Selesai ✅',
                          style: AppTextStyles.caption
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.w800)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Video
            CustomCard(
              onTap: _playVideo,
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(
                        _videoWatched
                            ? Icons.check_circle
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                            _videoWatched
                                ? 'Video selesai ditonton ✅ (+5 XP)'
                                : 'Tonton Video Pembahasan',
                            style: AppTextStyles.body
                                .copyWith(
                                    fontWeight:
                                        FontWeight.w800)),
                        Text(
                          _videoWatched
                              ? 'Kamu bisa tonton ulang kapan saja'
                              : '${widget.chapter.durationMinutes} menit • tap untuk putar (demo +XP)',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Rangkuman
            Text('Rangkuman', style: AppTextStyles.h3),
            const SizedBox(height: 6),
            CustomCard(
              child: Text(content.summary,
                  style: AppTextStyles.body
                      .copyWith(height: 1.5)),
            ),
            const SizedBox(height: 12),

            // Poin penting
            Text('Poin Penting',
                style: AppTextStyles.h3),
            const SizedBox(height: 6),
            ...content.keyPoints.map((p) => CustomCard(
                  margin:
                      const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.accentGreen,
                          size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(p,
                              style: AppTextStyles.body
                                  .copyWith(
                                      fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 12),

            // Contoh
            Text('Contoh Soal',
                style: AppTextStyles.h3),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Text(content.example,
                  style: AppTextStyles.body.copyWith(
                      fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 12),

            // Tips
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb,
                      color: AppColors.coinGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Tips Ujian',
                            style: AppTextStyles.body
                                .copyWith(
                                    fontWeight:
                                        FontWeight.w900)),
                        Text(content.tip,
                            style: AppTextStyles.body
                                .copyWith(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Aksi
            if (!done)
              CustomButton(
                text:
                    'Tandai Selesai (+${widget.chapter.xpReward} XP +10 koin)',
                width: double.infinity,
                icon: const Icon(Icons.check,
                    color: Colors.white, size: 18),
                onPressed: () => _finish(context),
              )
            else
              CustomButton(
                text: 'Sudah Selesai ✅ — Ulangi Tetap Bisa',
                width: double.infinity,
                outlined: true,
                onPressed: () => _finish(context,
                    repeat: true),
              ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Latihan Soal ${widget.chapter.subjectName}',
              width: double.infinity,
              color: AppColors.accentGreen,
              icon: const Icon(Icons.quiz_outlined,
                  color: Colors.white, size: 18),
              onPressed: () {
                final pack = BankSoalData.packs
                    .firstWhere(
                        (p) =>
                            p.subjectId ==
                            widget.chapter.subjectId,
                        orElse: () =>
                            BankSoalData.packs.first);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          SubjectDetailScreen(
                              pack: pack)),
                );
              },
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  void _playVideo() {
    if (_videoWatched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Memutar ulang video (demo)')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            'Video: ${widget.chapter.title}'),
        content: const Text(
            'Video demo 10 detik... (bayangkan videonya berputar 🙂)'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(
                  () => _videoWatched = true);
              final r = context
                  .read<AppProvider>()
                  .earn(
                      xp: 5,
                      source:
                          'Nonton: ${widget.chapter.title}');
              _maybeLevelDialog(r.leveledUp,
                  r.newLevel);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                      content: Text(
                          'Video selesai! +5 XP ✅')));
            },
            child: const Text(
                'Tandai Sudah Nonton'),
          ),
        ],
      ),
    );
  }

  void _finish(BuildContext context,
      {bool repeat = false}) {
    if (repeat) {
      final r = context.read<AppProvider>().earn(
          xp: 5,
          coins: 2,
          source:
              'Review: ${widget.chapter.title}');
      _maybeLevelDialog(r.leveledUp, r.newLevel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Review dicatat! +5 XP +2 koin ✅')),
      );
      return;
    }
    final r = context
        .read<AppProvider>()
        .completeChapter(
          widget.chapter.id,
          '${widget.chapter.subjectName} — ${widget.chapter.title}',
          xp: widget.chapter.xpReward,
          coins: 10,
        );
    _maybeLevelDialog(r.leveledUp, r.newLevel);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Bab selesai! +${widget.chapter.xpReward} XP +10 koin ✅')),
    );
  }

  void _maybeLevelDialog(bool up, int level) {
    if (up) {
      Future.microtask(() {
        if (!mounted) return;
        final msg = context
            .read<AppProvider>()
            .takePendingLevelUp();
        if (msg != null && mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Naik Level! 🎉'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text('Mantap!')),
              ],
            ),
          );
        }
      });
    }
  }
}
