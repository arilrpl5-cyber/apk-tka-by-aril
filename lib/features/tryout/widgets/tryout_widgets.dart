import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../models/models.dart';

/// Card satu item tryout (title, subtitle, tag free/premium, skor/status, aksi).
class TryoutListItem extends StatelessWidget {
  final TryoutModel tryout;
  final VoidCallback? onAction;

  const TryoutListItem({super.key, required this.tryout, this.onAction});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kiri
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.assignment_outlined,
                color: AppColors.primaryBlue, size: 28),
          ),
          const SizedBox(width: 12),
          // Teks tengah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tryout.title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _tag(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(tryout.subtitle, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (tryout.score != null)
                      Text(
                        'Nilai: ${tryout.score}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    if (tryout.score != null)
                      const SizedBox(width: 8),
                    _statusBadge(),
                  ],
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    _actionLabel(),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _actionLabel() {
    if (tryout.isCompleted) return 'Lanjutkan';
    if (tryout.diamondCost > 0) return '💎${tryout.diamondCost} Daftar';
    return 'Kerjakan';
  }

  Widget _tag() {
    if (tryout.isFree) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.freeTag,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'free',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.freeTagText,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      );
    }
    if (tryout.isPremium) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.premiumTag,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'premium',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.premiumTagText,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _statusBadge() {
    final isExpired = tryout.status.toLowerCase().contains('habis');
    final isAvailable =
        tryout.status.toLowerCase().contains('bisa');
    final color = isExpired
        ? Colors.red
        : isAvailable
            ? AppColors.accentGreen
            : AppColors.textSecondary;
    return Text(
      tryout.status,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Chip kategori tryout horizontal dengan badge angka merah.
class TryoutCategoryChip extends StatelessWidget {
  final TryoutCategoryModel category;

  const TryoutCategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: category.backgroundColor
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(category.icon,
                      color: AppColors.textPrimary, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (category.badgeCount > 0)
            Positioned(
              right: -4,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.badgeRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.badgeCount}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
