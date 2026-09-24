import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';

/// LIVE SCREEN - semua tombol bisa diklik.
class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});
  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final Set<int> reminded = {};

  final schedules = [
    {'title': 'Matematika - Peluang', 'tutor': 'Kak Sinta • Besok 16.00'},
    {'title': 'Kimia - Stoikiometri', 'tutor': 'Kak Raka • Besok 19.00'},
    {'title': 'Biologi - Sistem Saraf', 'tutor': 'Kak Nisa • Jumat 16.00'},
  ];

  void _joinLive(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Gabung Live?'),
        content: const Text(
            'Fisika - Gerak Parabola bersama Kak Bima sedang live dengan 1,2rb penonton (demo).'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Nanti')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Berhasil gabung live (demo) 🎉')),
              );
            },
            child: const Text('Gabung'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Live Class',
            style: AppTextStyles.h2
                .copyWith(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('Notifikasi Live'),
                  content: Text(
                      '• Live Fisika 19.00 malam ini\n• 3 jadwal besok sudah diingatkan'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B35),
                    Color(0xFFE91E63)
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
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
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('SEDANG LIVE',
                                  style: AppTextStyles
                                      .caption
                                      .copyWith(
                                    fontWeight:
                                        FontWeight.w900,
                                    color: Colors.red,
                                    fontSize: 11,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Fisika - Gerak Parabola',
                            style: AppTextStyles.h3.copyWith(
                                color: Colors.white)),
                        Text('Kak Bima • 1,2rb menonton',
                            style: AppTextStyles.caption
                                .copyWith(
                                    color:
                                        Colors.white70)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _joinLive(context),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text('Gabung Sekarang',
                                style: AppTextStyles.button
                                    .copyWith(
                                        fontSize: 12,
                                        color: AppColors
                                            .accentOrange)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.live_tv_outlined,
                      size: 64, color: Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Jadwal Berikutnya',
                style: AppTextStyles.h3),
            const SizedBox(height: 8),
            ...schedules.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final isOn = reminded.contains(i);
              return CustomCard(
                margin:
                    const EdgeInsets.only(bottom: 12),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Detail ${s['title']} (demo)')));
                },
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: const Icon(
                          Icons.videocam_outlined,
                          color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('${s['title']}',
                              style: AppTextStyles.body
                                  .copyWith(
                                      fontWeight:
                                          FontWeight.w800)),
                          Text('${s['tutor']}',
                              style:
                                  AppTextStyles.caption),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isOn) {
                            reminded.remove(i);
                          } else {
                            reminded.add(i);
                          }
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text(isOn
                                    ? 'Pengingat dibatalkan'
                                    : 'Diingatkan 10 menit sebelum mulai ✅')));
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6),
                        decoration: BoxDecoration(
                          color: isOn
                              ? AppColors.accentGreen
                              : AppColors.primaryBlue,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Text(
                            isOn ? 'Aktif ✅' : 'Ingatkan',
                            style: AppTextStyles.caption
                                .copyWith(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w800,
                            )),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
