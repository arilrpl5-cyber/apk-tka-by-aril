import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

/// Header section: title di kiri + optional trailing di kanan.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onSeeAll;
  final String? seeAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onSeeAll,
    this.seeAllText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3),
        if (trailing != null)
          trailing!
        else if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              seeAllText ?? 'Lihat Semua',
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
