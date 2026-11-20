import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.loadingLabel,
    this.isDisabled = false,
    this.icon,
    this.height = 52,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final String? loadingLabel;
  final bool isDisabled;
  final IconData? icon;
  final double height;
  final bool expand;

  bool get _enabled => !isLoading && !isDisabled && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    variant == AppButtonVariant.primary
                        ? Colors.white
                        : AppColors.primary,
                  ),
                ),
              ),
              if (loadingLabel != null && loadingLabel!.isNotEmpty) ...[
                const SizedBox(width: 10),
                Text(
                  loadingLabel!,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: _textColor),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: _textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );

    final buttonWidget = switch (variant) {
      AppButtonVariant.primary => Opacity(
          opacity: _enabled ? 1.0 : 0.6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primary,
                  Color(0xFF1AC2E6),
                  AppColors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _enabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : const [],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _enabled ? onPressed : null,
                splashColor: Colors.white.withValues(alpha: 0.18),
                highlightColor: Colors.white.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Center(child: content),
                ),
              ),
            ),
          ),
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: _enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            disabledBackgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
            foregroundColor: AppColors.primaryDark,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          child: content,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: _enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _enabled ? AppColors.borderStrong : AppColors.border,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          child: content,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: _enabled ? onPressed : null,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          ),
          child: content,
        ),
    };

    return SizedBox(
      height: height,
      width: expand ? double.infinity : null,
      child: buttonWidget,
    );
  }

  Color get _textColor {
    if (!_enabled && variant != AppButtonVariant.primary) {
      return AppColors.textMuted;
    }
    return switch (variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.secondary => AppColors.primaryDark,
      AppButtonVariant.outlined => AppColors.primaryDark,
      AppButtonVariant.text => AppColors.primary,
    };
  }
}
