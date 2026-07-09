import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.isLoading) _shimmerController.repeat();
  }

  @override
  void didUpdateWidget(AppButton old) {
    super.didUpdateWidget(old);
    if (widget.isLoading && !old.isLoading) {
      _shimmerController.repeat();
    } else if (!widget.isLoading && old.isLoading) {
      _shimmerController
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = switch (widget.variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.secondary,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.danger => AppColors.error,
    };

    final foregroundColor = switch (widget.variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => Colors.white,
      AppButtonVariant.outline => AppColors.primary,
      AppButtonVariant.ghost => isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      AppButtonVariant.danger => Colors.white,
    };

    final border = (widget.variant == AppButtonVariant.outline)
        ? Border.all(color: AppColors.primary, width: 1.5)
        : null;

    final isDisabled = widget.onPressed == null && !widget.isLoading;

    Widget content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      child: widget.isLoading
          ? _LoadingContent(
              key: const ValueKey('loading'),
              foregroundColor: foregroundColor,
              label: widget.label,
            )
          : _IdleContent(
              key: const ValueKey('idle'),
              icon: widget.icon,
              label: widget.label,
              foregroundColor: foregroundColor,
              fontSize: widget.fontSize,
              isFullWidth: widget.isFullWidth,
            ),
    );

    Widget button = AnimatedScale(
      scale: isDisabled ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: widget.height ?? 52,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: border,
            boxShadow: widget.variant == AppButtonVariant.primary && !isDisabled && !widget.isLoading
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Shimmer sweep while loading
              if (widget.isLoading)
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context2, child2) {
                    return Positioned.fill(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        alignment: Alignment(
                          -1.5 + _shimmerController.value * 4.0,
                          0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.12),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              // Button content + ripple
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(14),
                  splashColor: Colors.white.withValues(alpha: 0.15),
                  highlightColor: Colors.white.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: content,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return button.animate().fadeIn(duration: 200.ms);
  }
}

class _IdleContent extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color foregroundColor;
  final double? fontSize;
  final bool isFullWidth;

  const _IdleContent({
    super.key,
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.fontSize,
    required this.isFullWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize ?? 15,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final Color foregroundColor;
  final String label;

  const _LoadingContent({
    super.key,
    required this.foregroundColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            strokeCap: StrokeCap.round,
            valueColor: AlwaysStoppedAnimation(foregroundColor),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: foregroundColor.withValues(alpha: 0.65),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

// ─── Icon button ─────────────────────────────────────────────────────────────

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
