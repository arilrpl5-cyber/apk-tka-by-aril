import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Card reusable dengan padding, radius & shadow konsisten.
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.onTap,
    this.color,
    this.boxShadow,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? AppColors.cardShadow,
      ),
      child: child,
    );

    if (onTap == null) return container;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: container,
      ),
    );
  }
}
