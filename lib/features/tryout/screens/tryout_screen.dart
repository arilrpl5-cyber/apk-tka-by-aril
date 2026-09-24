import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../data/dummy_data.dart';
import '../../bank_soal/screens/bank_soal_screen.dart';
import '../widgets/tryout_widgets.dart';

/// TRYOUT SCREEN.
class TryoutScreen extends StatefulWidget {
  const TryoutScreen({super.key});

  @override
  State<TryoutScreen> createState() => _TryoutScreenState();
}

class _TryoutScreenState extends State<TryoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tryouts = DummyData.tryoutList;
    final categories = DummyData.tryoutCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER GRADIENT ----------
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.fromLTRB(20, 56, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBlue,
                    AppColors.primaryDark
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Tryout',
                            style: AppTextStyles.h1
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          'Uji kemampuanmu & raih skor terbaik!',
                          style:
                              AppTextStyles.body.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Icon(
                        Icons.smartphone_outlined,
                        color: Colors.white,
                        size: 40),
                  ),
                ],
              ),
            ),

            // ---------- TABS ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(12),
                  boxShadow: AppColors.cardShadow,
                ),
                child: TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  indicatorSize:
                      TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      AppColors.textSecondary,
                  labelStyle:
                      AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Berlangsung'),
                    Tab(text: 'Akan Datang'),
                  ],
                ),
              ),
            ),

            // ---------- LIST TRYOUT ----------
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: Column(
                children: tryouts
                    .map((t) => TryoutListItem(
                          tryout: t,
                          onAction: () =>
                              _onTryoutAction(context, t.title, t.isCompleted, t.diamondCost),
                        ))
                    .toList(),
              ),
            ),

            // ---------- KATEGORI TRYOUT ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 8, 0, 8),
              child: Text('Kategori Tryout',
                  style: AppTextStyles.h3),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final c = categories[index];
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                              content: Text(
                                  '${c.name}: ${c.badgeCount} tryout tersedia (demo)')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const BankSoalScreen()),
                      );
                    },
                    child: TryoutCategoryChip(
                        category: categories[index]),
                  );
                },
              ),
            ),

            // ---------- FOOTER ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomCard(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                              'Kalender Tryout'),
                          content: const Text(
                              '• 12 Okt: Tryout UTBK 2027 #02\n• 19 Okt: Tryout TKA SMA 2026 #02\n• 26 Okt: Tryout TKA SMP (demo)'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context),
                                child:
                                    const Text('Tutup')),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                            Icons.calendar_month_outlined,
                            color:
                                AppColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text('Lihat Kalender Tryout',
                            style: AppTextStyles.body
                                .copyWith(
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  AppColors.primaryBlue,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                      boxShadow:
                          AppColors.cardShadow,
                    ),
                    child: TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        hintText:
                            'Punya Kode untuk Tryout Khusus?',
                        hintStyle: AppTextStyles.body
                            .copyWith(
                                color: AppColors
                                    .textSecondary,
                                fontSize: 13),
                        border: InputBorder.none,
                        suffixIcon: TextButton(
                          onPressed: () {
                            final code = codeController.text
                                .trim();
                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(SnackBar(
                                    content: Text(code
                                            .isEmpty
                                        ? 'Masukkan kode dulu ya'
                                        : 'Kode "$code" tidak valid (demo). Coba: TKA2026')));
                            if (code.toUpperCase() ==
                                'TKA2026') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const BankSoalScreen()),
                              );
                            }
                          },
                          child: Text('Tukar',
                              style: AppTextStyles.body
                                  .copyWith(
                                color: AppColors
                                    .primaryBlue,
                                fontWeight:
                                    FontWeight.w800,
                              )),
                        ),
                      ),
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

  void _onTryoutAction(BuildContext context, String title,
      bool isCompleted, int diamondCost) {
    if (isCompleted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: const Text(
              'Nilai kamu 629. Mau lihat pembahasan atau kerjakan ulang via Bank Soal?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BankSoalScreen()),
                );
              },
              child: const Text('Latihan Lagi'),
            ),
          ],
        ),
      );
      return;
    }
    if (diamondCost > 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(
              'Butuh 💎$diamondCost untuk daftar. Diamond kamu 0 (demo) — latihan gratis dulu yuk!'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nanti')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BankSoalScreen()),
                );
              },
              child: const Text('Bank Soal Gratis'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BankSoalScreen()),
    );
  }
}
