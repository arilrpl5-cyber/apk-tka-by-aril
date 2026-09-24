import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/chapter_content_data.dart';
import '../../../providers/app_provider.dart';
import 'chapter_detail_screen.dart';

/// Daftar bab yang dibookmark. Tap untuk buka, swipe-icon untuk hapus.
class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final ids = app.bookmarks.toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bookmark',
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
      ),
      body: ids.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_border,
                      size: 56,
                      color: AppColors.textSecondary),
                  const SizedBox(height: 8),
                  Text('Belum ada bookmark',
                      style: AppTextStyles.h3),
                  Text('Buka bab materi lalu tap ikon 🔖',
                      style: AppTextStyles.caption),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ids.length,
              itemBuilder: (_, i) {
                final id = ids[i];
                final ch = ChapterData.all.firstWhere(
                    (c) => c.id == id,
                    orElse: () => ChapterData.all.first);
                final done = app.isChapterDone(id);
                return CustomCard(
                  margin:
                      const EdgeInsets.only(bottom: 10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChapterDetailScreen(
                                  chapter: ch)),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${ch.subjectName} • Bab ${ch.index}',
                                style:
                                    AppTextStyles.caption),
                            Text(ch.title,
                                style: AppTextStyles.body
                                    .copyWith(
                                        fontWeight:
                                            FontWeight
                                                .w800)),
                            if (done)
                              Text('Selesai ✅',
                                  style: AppTextStyles
                                      .caption
                                      .copyWith(
                                          color: AppColors
                                              .accentGreen,
                                          fontWeight:
                                              FontWeight
                                                  .w700)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context
                            .read<AppProvider>()
                            .toggleBookmark(id),
                        icon: const Icon(
                            Icons.bookmark,
                            color:
                                AppColors.primaryBlue),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// Download Manager: bab yang tersedia offline.
class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final ids = app.downloads.toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Download Manager',
            style: AppTextStyles.h3.copyWith(color: Colors.white)),
      ),
      body: ids.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.download_outlined,
                      size: 56,
                      color: AppColors.textSecondary),
                  const SizedBox(height: 8),
                  Text('Belum ada download',
                      style: AppTextStyles.h3),
                  Text(
                      'Buka bab materi lalu tap ikon ⬇ untuk offline',
                      style: AppTextStyles.caption),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ids.length,
              itemBuilder: (_, i) {
                final id = ids[i];
                final ch = ChapterData.all.firstWhere(
                    (c) => c.id == id,
                    orElse: () => ChapterData.all.first);
                return CustomCard(
                  margin:
                      const EdgeInsets.only(bottom: 10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChapterDetailScreen(
                                  chapter: ch)),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                          Icons
                              .download_done_outlined,
                          color:
                              AppColors.accentGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${ch.subjectName} • Bab ${ch.index}',
                                style:
                                    AppTextStyles.caption),
                            Text(ch.title,
                                style: AppTextStyles.body
                                    .copyWith(
                                        fontWeight:
                                            FontWeight
                                                .w800)),
                            Text('Tersedia offline ✅',
                                style: AppTextStyles
                                    .caption
                                    .copyWith(
                                        color: AppColors
                                            .accentGreen)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context
                            .read<AppProvider>()
                            .toggleDownload(id),
                        icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
