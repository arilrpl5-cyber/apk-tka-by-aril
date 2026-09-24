import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../providers/app_provider.dart';
import '../../bank_soal/screens/bank_soal_screen.dart';
import '../../info/screens/info_screens.dart';
import '../../materi/screens/bookmark_download_screens.dart';
import '../../materi/screens/materi_detail_screen.dart';
import '../../points/screens/point_history_screen.dart';
import '../../streak/screens/streak_screen.dart';
import '../../streak/widgets/streak_widgets.dart';
import '../widgets/promo_banner.dart';
import '../widgets/fitur_grid.dart';
import '../widgets/materi_grid.dart';

/// HOME / BELAJAR SCREEN — semua tombol bisa diklik.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goBankSoal(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const BankSoalScreen()));
  }

  void _onFitur(BuildContext context, String id) {
    switch (id) {
      case 'pegasus':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PegasusScreen()));
        break;
      case 'bank-soal':
        _goBankSoal(context);
        break;
      case 'tryout':
        context.read<AppProvider>().changeTab(2);
        break;
      case 'sikat-soal':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SikatSoalScreen()));
        break;
      default:
        _goBankSoal(context);
    }
  }

  void _showNotif(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Notifikasi'),
        content: const Text(
            '• Tryout TKA SMA 2026 #01 bisa dikerjakan\n• Promo 60% berakhir 4 hari lagi\n• Live Fisika malam ini 19.00'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentPink,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const TanyaMipiScreen()),
          );
        },
        icon: const Text('💡', style: TextStyle(fontSize: 20)),
        label: Text('Tanya MIPI',
            style: AppTextStyles.button
                .copyWith(color: Colors.white, fontSize: 13)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER BIRU ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.read<AppProvider>().changeTab(4),
                        child: UserAvatar(
                            name: user.name, size: 48),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level ${user.level}',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            XpProgressBar(
                              current: user.currentXP,
                              max: user.maxXP,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'XP ${user.currentXP}/${user.maxXP}',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => context
                            .read<AppProvider>()
                            .changeTab(4),
                        child: _currencyChip(
                            Icons.diamond, '${user.diamonds}'),
                      ),
                      const SizedBox(width: 6),
                      StreakChip(
                        streak: user.streak,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const StreakScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => context
                            .read<AppProvider>()
                            .changeTab(4),
                        child: _currencyChip(
                            Icons.monetization_on, '${user.coins}'),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => _showNotif(context),
                        icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 26),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------- PROMO BANNER (tap -> Pembelian) ----------
            GestureDetector(
              onTap: () =>
                  context.read<AppProvider>().changeTab(3),
              child: const PromoBanner(),
            ),
            const SizedBox(height: 16),

            // ---------- FITUR BELAJAR ----------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Fitur Belajar'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: FiturBelajarGrid(
                onTapItem: (id) => _onFitur(context, id),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- BANK SOAL TKA BANNER ----------
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: CustomCard(
                color: AppColors.primaryBlue,
                onTap: () => _goBankSoal(context),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow,
                              borderRadius:
                                  BorderRadius.circular(6),
                            ),
                            child: Text('40 SOAL • 8 MAPEL',
                                style: AppTextStyles.caption
                                    .copyWith(
                                        fontWeight:
                                            FontWeight.w900,
                                        fontSize: 10)),
                          ),
                          const SizedBox(height: 6),
                          Text('Bank Soal TKA',
                              style: AppTextStyles.h3
                                  .copyWith(
                                      color: Colors.white)),
                          Text(
                            'Latihan + pembahasan tiap soal',
                            style: AppTextStyles.caption
                                .copyWith(
                                    color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text('Kerjakan Sekarang',
                                style: AppTextStyles.button
                                    .copyWith(
                                        fontSize: 12,
                                        color: AppColors
                                            .primaryBlue)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.quiz_outlined,
                        size: 64, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- STREAK + POIN (tap untuk buka) ----------
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const StreakScreen()),
                        );
                      },
                      padding:
                          const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Text('🔥',
                              style: TextStyle(
                                  fontSize: 26)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                    '${user.streak} hari',
                                    style: AppTextStyles
                                        .body
                                        .copyWith(
                                            fontWeight:
                                                FontWeight
                                                    .w900)),
                                Text('Streak login',
                                    style: AppTextStyles
                                        .caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const PointHistoryScreen()),
                        );
                      },
                      padding:
                          const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Text('⭐',
                              style: TextStyle(
                                  fontSize: 26)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text('${user.totalXP} XP',
                                    style: AppTextStyles
                                        .body
                                        .copyWith(
                                            fontWeight:
                                                FontWeight
                                                    .w900)),
                                Text('Riwayat poin',
                                    style: AppTextStyles
                                        .caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------- MATERI BELAJAR ----------
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: MateriSection(
                onTapMateri: (m) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MateriDetailScreen(material: m),
                    ),
                  );
                },
                onBookmark: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const BookmarkScreen()),
                  );
                },
                onDownload: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const DownloadScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ---------- BOTTOM FEATURES ----------
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCard(
                    onTap: () => context
                        .read<AppProvider>()
                        .changeTab(2),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Icon(
                              Icons.emoji_events_outlined,
                              color: AppColors.primaryBlue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('Tryout Pahamify',
                                  style: AppTextStyles.body.copyWith(
                                      fontWeight:
                                          FontWeight.w800)),
                              Text(
                                'Uji kemampuanmu sebelum ujian asli',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const InfoKuliahScreen()),
                            );
                          },
                          child: Column(
                            children: [
                              const Icon(
                                  Icons.school_outlined,
                                  color: AppColors.primaryBlue,
                                  size: 32),
                              const SizedBox(height: 6),
                              Text('Info Kuliah',
                                  style: AppTextStyles.body.copyWith(
                                      fontWeight:
                                          FontWeight.w700,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const TanyaMipiScreen()),
                            );
                          },
                          child: Column(
                            children: [
                              const Icon(Icons.forum_outlined,
                                  color: AppColors.accentPink,
                                  size: 32),
                              const SizedBox(height: 6),
                              Text('Tanya MIPI',
                                  style: AppTextStyles.body.copyWith(
                                      fontWeight:
                                          FontWeight.w700,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SectionHeader(title: 'Ujian Mandiri'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 84,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _mandiriCard(context, 'SIMAK UI',
                            Icons.account_balance),
                        _mandiriCard(context, 'UTUL UGM',
                            Icons.school),
                        _mandiriCard(context, 'SMUP UNPAD',
                            Icons.book),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currencyChip(IconData icon, String value) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mandiriCard(
      BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  UjianMandiriScreen(title: title)),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accentPurple
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: AppColors.accentPurple),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text('Lihat paket',
                      style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
