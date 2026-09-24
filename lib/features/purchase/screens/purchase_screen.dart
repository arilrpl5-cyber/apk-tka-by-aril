import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/dummy_data.dart';
import '../../home/widgets/promo_banner.dart';
import '../widgets/package_card.dart';

/// PURCHASE / PEMBELIAN SCREEN dengan countdown timer.
class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  late Duration remaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // 4 hari 10 jam 52 menit 58 detik sesuai spek.
    remaining =
        const Duration(days: 4, hours: 10, minutes: 52, seconds: 58);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds <= 0) {
        timer?.cancel();
        return;
      }
      setState(() => remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get countdownText {
    final d = remaining.inDays;
    final h = remaining.inHours % 24;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;
    String two(int n) => n.toString().padLeft(2, '0');
    return '$d:${two(h)}:${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final packages = DummyData.packages;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- HEADER ----------
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.fromLTRB(16, 52, 16, 18),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Paket Saat Ini',
                            style: AppTextStyles.h2),
                      ),
                      const Icon(Icons.shopping_cart_outlined,
                          color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      const Icon(Icons.notifications_outlined,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),

                // ---------- INFO PENTING ----------
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.infoGreyBox,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.body.copyWith(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Info Penting: ',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w800),
                          ),
                          TextSpan(
                              text:
                                  'Pembelian via web '),
                          TextSpan(
                            text:
                                'https://pay.pahamify.com/',
                            style: TextStyle(
                              color:
                                  AppColors.primaryBlue,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ---------- PROMO + COUNTDOWN ----------
                PromoBanner(
                  showCountdown: true,
                  countdownText: countdownText,
                ),
                const SizedBox(height: 16),

                // ---------- KATEGORI PAKET ----------
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(
                      title: 'Kategori Paket'),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final p = packages[index];
                      return PackageCard(
                        package: p,
                        onBuy: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(p.name),
                              content: Text(
                                  '${p.description}\nHarga: ${p.price}\n\nBayar via web:\nhttps://pay.pahamify.com/ (demo)'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(
                                            context),
                                    child: const Text(
                                        'Batal')),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context);
                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                                'Pesanan ${p.name} dibuat (demo). Cek email ya!')));
                                  },
                                  child:
                                      const Text('Bayar'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // ---------- FLOATING BUTTON HIJAU ----------
          Positioned(
            right: 16,
            bottom: 24,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Hubungi CS untuk cara berlangganan')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  borderRadius:
                      BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen
                          .withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Bingung Cara\nBerlangganan?',
                      style:
                          AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
