import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../providers/app_provider.dart';
import '../../points/screens/point_history_screen.dart';
import '../../streak/screens/streak_screen.dart';
import '../../streak/widgets/streak_widgets.dart';

/// PROFILE SCREEN.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- HEADER BIRU ----------
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.fromLTRB(16, 52, 16, 20),
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // Avatar 80px + edit
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Ganti foto profil (demo)')));
                        },
                        child: Stack(
                          children: [
                            UserAvatar(
                                name: user.name, size: 80),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.all(5),
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.edit,
                                    size: 14,
                                    color:
                                        AppColors.primaryBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(user.name,
                                style: AppTextStyles.h3.copyWith(
                                    color: Colors.white)),
                            Text(user.kelas,
                                style: AppTextStyles.body.copyWith(
                                    color: Colors.white70,
                                    fontSize: 13)),
                            const SizedBox(height: 8),
                            // Tombol Lengkapi Profil (putih + ! merah)
                            GestureDetector(
                              onTap: () {
                                final nameCtrl =
                                    TextEditingController(
                                        text: user.name);
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AlertDialog(
                                    title: const Text(
                                        'Lengkapi Profil'),
                                    content: TextField(
                                      controller:
                                          nameCtrl,
                                      decoration:
                                          const InputDecoration(
                                        labelText: 'Nama',
                                        border:
                                            OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  context),
                                          child: const Text(
                                              'Batal')),
                                      FilledButton(
                                        onPressed: () {
                                          provider.updateUser(
                                              user.copyWith(
                                                  name: nameCtrl
                                                          .text
                                                          .trim()
                                                          .isEmpty
                                                      ? user
                                                          .name
                                                      : nameCtrl
                                                          .text
                                                          .trim()));
                                          Navigator.pop(
                                              context);
                                          ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('Profil disimpan ✅')));
                                        },
                                        child: const Text(
                                            'Simpan'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('!',
                                        style: AppTextStyles
                                            .caption
                                            .copyWith(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.w900,
                                          fontSize: 11,
                                        )),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Lengkapi Profil',
                                    style: AppTextStyles.body
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Pengaturan (demo)')));
                        },
                        icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Level + XP bar
                  Row(
                    children: [
                      Text('Level ${user.level}',
                          style:
                              AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          )),
                      const Spacer(),
                      Text(
                          'XP ${user.currentXP}/${user.maxXP}',
                          style:
                              AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  XpProgressBar(
                    current: user.currentXP,
                    max: user.maxXP,
                  ),
                  const SizedBox(height: 14),
                  // Free trial box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.isTrialActive
                                ? 'Free Trial Aktif (${user.subscriptionDays} hari lagi)'
                                : 'Free Trial Belum Aktif',
                            style:
                                AppTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomButton(
                          text: user.isTrialActive
                              ? 'Aktif'
                              : 'Aktivasi Sekarang',
                          onPressed: user.isTrialActive
                              ? null
                              : () => provider
                                  .activateTrial(),
                          color: Colors.white,
                          textColor:
                              AppColors.primaryBlue,
                          height: 34,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- STATS 3 KOLOM ----------
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: _statCard(
                    context,
                    title: 'Subscription',
                    value:
                        '${user.subscriptionDays} hari lagi',
                    color: AppColors.accentGreen,
                    icon: Icons.card_membership_outlined,
                    detail:
                        'Paket Free • Upgrade ke Premium untuk buka semua materi & tryout.',
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _statCard(
                    context,
                    title: 'Diamond',
                    value: '${user.diamonds}',
                    color: AppColors.diamondPink,
                    icon: Icons.diamond_outlined,
                    detail:
                        'Diamond dipakai untuk daftar tryout premium. Dapat dari misi & pembelian.',
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _statCard(
                    context,
                    title: 'Koin',
                    value: '${user.coins}',
                    color: AppColors.coinGold,
                    icon: Icons.monetization_on_outlined,
                    detail:
                        'Koin didapat dari latihan soal & tryout. Kumpulkan untuk tukar reward!',
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------- PENGEMBANGAN DIRI ----------
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(
                  title: 'Pengembangan Diri'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: _pengembanganCard(
                          context,
                          Icons.psychology_outlined,
                          'Tes Minat\nBakat',
                          'Jawab 20 pertanyaan untuk tahu jurusan yang cocok untukmu (demo).')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _pengembanganCard(
                          context,
                          Icons.lightbulb_outline,
                          'Tips dan\nMotivasi',
                          '• Belajar 25 menit, istirahat 5 menit\n• Ulangi soal salah 3x\n• Tidur cukup sebelum tryout (demo).')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _pengembanganCard(
                          context,
                          Icons.school_outlined,
                          'Belajar Skill\nBaru',
                          'Skill populer: desain, coding, public speaking (demo).')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---------- BANNER CARA PAKAI ----------
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text('Cara Pakai Materi'),
                      content: Text(
                          '1. Pilih mapel\n2. Tonton video / baca rangkuman\n3. Kerjakan Bank Soal\n4. Cek pembahasan & kumpulkan XP (demo)'),
                    ),
                  );
                },
                child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius:
                      BorderRadius.circular(16),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('Cara Pakai\nMateri Belajar',
                              style: AppTextStyles.h3),
                          const SizedBox(height: 6),
                          Text(
                            'Pelajari cara memaksimalkan belajarmu',
                            style:
                                AppTextStyles.caption,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryBlue,
                              borderRadius:
                                  BorderRadius.circular(
                                      8),
                            ),
                            child: Text('Lihat',
                                style: AppTextStyles
                                    .button
                                    .copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: const Icon(
                          Icons.menu_book_outlined,
                          size: 48,
                          color:
                              AppColors.primaryBlue),
                    ),
                  ],
                ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- STREAK CARD ----------
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: StreakWeekCard(
                  streak: user.streak),
            ),
            const SizedBox(height: 12),

            // ---------- PROGRES BELAJAR ----------
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: CustomCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const PointHistoryScreen()),
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
                              '${provider.completedCount}/40 bab • ${user.totalXP} XP',
                              style: AppTextStyles.body
                                  .copyWith(
                                      fontWeight:
                                          FontWeight
                                              .w900)),
                          Text(
                            'Tap untuk riwayat poin lengkap',
                            style:
                                AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                        Icons.chevron_right,
                        color:
                            AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- MENU LAIN ----------
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: CustomCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _menuTile(context, Icons.local_fire_department_outlined,
                        'Streak Harian',
                        screen: const StreakScreen()),
                    _menuTile(context, Icons.history,
                        'Riwayat Poin',
                        screen:
                            const PointHistoryScreen()),
                    _menuTile(context, Icons.history,
                        'Riwayat Pembelian',
                        msg:
                            'Belum ada pembelian (demo). Cek tab Pembelian untuk promo!'),
                    _menuTile(context, Icons.help_outline,
                        'Bantuan',
                        msg:
                            'CS: halo@tkatest.id • 08.00-22.00 WIB (demo)'),
                    _menuTile(context, Icons.refresh_outlined,
                        'Reset Progres (Demo)',
                        msg: '',
                        onTap: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                  'Reset semua progres?'),
                              content: const Text(
                                  'XP, koin, streak, bab selesai & bookmark akan kembali awal.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            context,
                                            false),
                                    child: const Text(
                                        'Batal')),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                          context, true),
                                  child:
                                      const Text('Reset'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            await context
                                .read<AppProvider>()
                                .resetAll();
                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Progres direset ✅')));
                            }
                          }
                        }),
                    _menuTile(context, Icons.logout,
                        'Keluar',
                        isLast: true,
                        msg: 'Keluar (demo) — kamu tetap login.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required String detail,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text('$value\n\n$detail'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup')),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(title,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Lihat Detail',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pengembanganCard(
      BuildContext context, IconData icon, String label, String msg) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text(label.replaceAll('\n', ' ')), content: Text(msg)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Icon(icon,
                color: AppColors.primaryBlue, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title,
      {bool isLast = false,
      String msg = '',
      Widget? screen,
      Future<void> Function()? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon,
              color: AppColors.primaryBlue),
          title: Text(title,
              style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right,
              color: AppColors.textSecondary),
          onTap: () async {
            if (onTap != null) {
              await onTap();
              return;
            }
            if (screen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => screen),
              );
              return;
            }
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(title),
                content: Text(msg.isEmpty ? '$title (demo)' : msg),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup')),
                ],
              ),
            );
          },
        ),
        if (!isLast)
          const Divider(height: 1, indent: 16),
      ],
    );
  }
}
