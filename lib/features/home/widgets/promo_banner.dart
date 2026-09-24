import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/dummy_data.dart';
import '../../../providers/app_provider.dart';

/// Carousel banner promo kuning "#CuriStartBiarSmart UTBK 2027".
/// Dipakai di Home & Purchase (purchase tambah countdown via param).
class PromoBanner extends StatelessWidget {
  final bool showCountdown;
  final String countdownText;

  const PromoBanner({
    super.key,
    this.showCountdown = false,
    this.countdownText = '4:10:52:58',
  });

  @override
  Widget build(BuildContext context) {
    final promoIndex = context.watch<AppProvider>().promoIndex;
    final items = DummyData.promoTitles;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (context, index, realIndex) {
            return _bannerCard(context, items[index], index);
          },
          options: CarouselOptions(
            height: 150,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              context.read<AppProvider>().setPromoIndex(index);
            },
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          activeIndex: promoIndex,
          count: items.length,
          effect: const ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: AppColors.primaryBlue,
            dotColor: Color(0xFFD1D5DB),
            expansionFactor: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _bannerCard(BuildContext context, String title, int index) {
    // Variasi warna banner biar carousel hidup.
    final bgColors = [
      AppColors.accentYellow,
      const Color(0xFFBBDEFB),
      const Color(0xFFFFCCBC),
    ];
    final bg = bgColors[index % bgColors.length];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          // --- Teks kiri ---
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PROMO TERBATAS',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                if (showCountdown)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          countdownText,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Ambil Promo',
                      style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // --- Ilustrasi kanan (placeholder icon besar) ---
          Expanded(
            flex: 2,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school,
                size: 64,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
