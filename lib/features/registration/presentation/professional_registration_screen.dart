import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/step_progress.dart';
import '../../auth/widgets/auth_scaffold.dart';
import '../state/registration_controller.dart';
import 'steps/step1_profession_selection.dart';
import 'steps/step2_personal_info.dart';
import 'steps/step3_account_credentials.dart';

class ProfessionalRegistrationScreen extends ConsumerWidget {
  const ProfessionalRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(registrationControllerProvider);
    final controller = ref.read(registrationControllerProvider.notifier);

    return PopScope(
      canPop: draft.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && draft.currentStep > 0) {
          controller.previousStep();
        }
      },
      child: AuthScaffold(
        showBrand: true,
        onBack: () {
          if (draft.currentStep > 0) {
            controller.previousStep();
          } else {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StepProgress(
              totalSteps: 3,
              currentStep: draft.currentStep,
              onStepTapped: (step) => controller.setStep(step),
              labels: const [
                'Profession',
                'Informations\npersonnelles',
                'Compte &\nAccès',
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.04, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(draft.currentStep),
                child: switch (draft.currentStep) {
                  0 => const Step1ProfessionSelection(),
                  1 => const Step2PersonalInfo(),
                  2 => const Step3AccountCredentials(),
                  _ => const Step1ProfessionSelection(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
