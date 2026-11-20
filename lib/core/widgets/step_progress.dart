import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class StepProgress extends StatelessWidget {
  const StepProgress({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.labels,
    this.onStepTapped,
  });

  final int totalSteps;
  final int currentStep;
  final List<String> labels;
  final ValueChanged<int>? onStepTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < totalSteps; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 21),
                  child: Container(
                    height: 1.5,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: i <= currentStep
                        ? AppColors.primary
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
            GestureDetector(
              onTap: (onStepTapped != null && i < currentStep)
                  ? () => onStepTapped!(i)
                  : null,
              child: SizedBox(
                width: 90,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepCircle(
                      index: i + 1,
                      isActive: i == currentStep,
                      isCompleted: i < currentStep,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 11.5,
                        height: 1.25,
                        fontWeight: i == currentStep
                            ? FontWeight.w700
                            : (i < currentStep ? FontWeight.w600 : FontWeight.w500),
                        color: i == currentStep
                            ? AppColors.primary
                            : (i < currentStep
                                ? AppColors.textPrimary
                                : const Color(0xFF94A3B8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.isActive,
    required this.isCompleted,
  });

  final int index;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
      );
    }

    if (isActive) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$index',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$index',
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}
