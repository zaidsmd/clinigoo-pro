import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/auth/state/auth_providers.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../state/registration_controller.dart';

class Step3AccountCredentials extends ConsumerStatefulWidget {
  const Step3AccountCredentials({super.key});

  @override
  ConsumerState<Step3AccountCredentials> createState() =>
      _Step3AccountCredentialsState();
}

class _Step3AccountCredentialsState
    extends ConsumerState<Step3AccountCredentials> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _termsAccepted = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(registrationControllerProvider);
    _emailController = TextEditingController(text: draft.email);
    _passwordController = TextEditingController(text: draft.password);
    _confirmPasswordController =
        TextEditingController(text: draft.confirmPassword);
    _termsAccepted = draft.termsAccepted;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_termsAccepted) {
      setState(() {
        _errorMessage =
            'Veuillez accepter les conditions d’utilisation et la charte déontologique pour continuer.';
      });
      return;
    }

    ref.read(registrationControllerProvider.notifier).updateCredentials(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          termsAccepted: _termsAccepted,
        );

    final request = ref.read(registrationControllerProvider).toRequest();
    if (request == null) {
      setState(() {
        _errorMessage =
            'Des informations obligatoires sont manquantes (profession ou date de naissance).';
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authControllerProvider.notifier).register(request);
      if (!mounted) return;
      context.go(AppRoutes.registerSuccess);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Une erreur inattendue est survenue: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(registrationControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060B1C30),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step pill badge
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F8FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Étape 3 sur 3',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Main Title
            Text(
              'Compte & Accès sécurisé',
              style: AppTextStyles.h2.copyWith(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              'Créez vos identifiants pour sécuriser l’accès à votre espace soignant Clinigoo.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF64748B),
                height: 1.4,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),

            // Enhanced Summary Card
            _buildSummaryCard(draft),
            const SizedBox(height: AppSpacing.lg),

            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: AppRadius.sm,
                  border: Border.all(color: AppColors.error),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.errorDark,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.errorDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Email
            AppTextField(
              controller: _emailController,
              label: 'Adresse email professionnelle',
              hint: 'nom.prenom@exemple.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(Icons.mail_outline_rounded,
                  color: AppColors.primary),
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Password
            AppPasswordField(
              controller: _passwordController,
              label: 'Mot de passe sécurisé',
              hint: '8 caractères minimum',
              textInputAction: TextInputAction.next,
              validator: Validators.password,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Confirm Password
            AppPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirmer le mot de passe',
              hint: 'Répétez votre mot de passe',
              textInputAction: TextInputAction.done,
              validator: (val) =>
                  Validators.confirmPassword(val, _passwordController.text),
            ),
            const SizedBox(height: AppSpacing.md),

            // Terms Checkbox Container
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _termsAccepted
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                  width: _termsAccepted ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) =>
                        setState(() => _termsAccepted = val ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text.rich(
                        TextSpan(
                          text: "J'accepte les ",
                          style: AppTextStyles.bodySmall,
                          children: [
                            TextSpan(
                              text: "Conditions Générales d'Utilisation",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' et la '),
                            TextSpan(
                              text: "Charte Déontologique Clinigoo",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text: ' pour les professionnels de santé.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppButton(
                    label: 'Retour',
                    variant: AppButtonVariant.outlined,
                    isDisabled: _isLoading,
                    onPressed: () {
                      ref
                          .read(registrationControllerProvider.notifier)
                          .previousStep();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: "Créer mon compte",
                    icon: Icons.check_circle_rounded,
                    isLoading: _isLoading,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Trust Reassurance
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Données médicales chiffrées & confidentielles',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(RegistrationDraftState draft) {
    final initials = (draft.firstName.isNotEmpty ? draft.firstName[0] : 'P')
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: draft.selectedProfession?.colorLight ?? AppColors.primaryLight,
                child: Text(
                  initials,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: draft.selectedProfession?.color ?? AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${draft.firstName} ${draft.lastName}'.trim().isNotEmpty
                          ? '${draft.firstName} ${draft.lastName}'.trim()
                          : 'Praticien',
                      style: AppTextStyles.h4.copyWith(fontSize: 15),
                    ),
                    Text(
                      draft.selectedProfession?.name ??
                          'Discipline non spécifiée',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: draft.selectedProfession?.color ?? AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.primary,
                tooltip: 'Modifier les informations',
                onPressed: () {
                  ref.read(registrationControllerProvider.notifier).setStep(1);
                },
              ),
            ],
          ),
          const Divider(height: 18, color: Color(0xFFE2E8F0)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  Icons.credit_card_rounded,
                  'CIN',
                  draft.cinNumber.toUpperCase(),
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  Icons.location_city_rounded,
                  'Ville',
                  draft.city,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSummaryItem(
            Icons.phone_outlined,
            'Téléphone',
            draft.phone.isNotEmpty
                ? '+212 ${draft.phone.startsWith('0') ? draft.phone.substring(1) : draft.phone}'
                : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: const Color(0xFF94A3B8),
                fontSize: 10,
              ),
            ),
            Text(
              value.isNotEmpty ? value : '-',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
