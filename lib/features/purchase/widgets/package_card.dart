import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../models/models.dart';

/// Card paket pembelian: icon bulat di atas, title, desc 2 baris, tombol Beli.
class PackageCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback? onBuy;

  const PackageCard({super.key, required this.package, this.onBuy});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: package.iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(package.icon,
                color: AppColors.primaryDark, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            package.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            package.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            package.price,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Beli',
            onPressed: onBuy ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Beli ${package.name} — via web pay.pahamify.com')),
                  );
                },
            height: 36,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
