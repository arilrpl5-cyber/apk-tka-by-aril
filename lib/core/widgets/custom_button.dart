import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Button reusable (filled / outlined).
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final bool outlined;
  final Widget? icon;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height = 44,
    this.borderRadius = 8,
    this.outlined = false,
    this.icon,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primaryBlue;
    final fg = textColor ?? Colors.white;

    final style = AppTextStyles.button.copyWith(
      color: outlined ? bg : fg,
      fontSize: fontSize,
    );

    if (outlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: bg,
            side: BorderSide(color: bg, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _label(style),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _label(style),
      ),
    );
  }

  Widget _label(TextStyle style) {
    if (icon == null) return Text(text, style: style);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon!, const SizedBox(width: 6), Text(text, style: style)],
    );
  }
}
