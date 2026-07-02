import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.secondary,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.danger => AppColors.error,
    };

    final foregroundColor = switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => Colors.white,
      AppButtonVariant.outline => AppColors.primary,
      AppButtonVariant.ghost => isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      AppButtonVariant.danger => Colors.white,
    };

    final border = (variant == AppButtonVariant.outline)
        ? Border.all(color: AppColors.primary, width: 1.5)
        : null;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foregroundColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize ?? 15,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
            ],
          );

    return AnimatedScale(
      scale: onPressed == null ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        width: isFullWidth ? double.infinity : null,
        height: height ?? 52,
        decoration: BoxDecoration(
          color: onPressed == null
              ? backgroundColor.withValues(alpha: 0.5)
              : backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: border,
          boxShadow: variant == AppButtonVariant.primary && onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: child,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.backgroundColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ??
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(size / 3),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(size / 3),
            child: Icon(
              icon,
              size: size * 0.5,
              color: color ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
