import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_date_picker_field.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_phone_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../state/registration_controller.dart';

const List<String> kMoroccanCities = [
  'Casablanca',
  'Rabat',
  'Marrakech',
  'Tanger',
  'Fès',
  'Agadir',
  'Meknès',
  'Oujda',
  'Kénitra',
  'Tétouan',
  'Salé',
  'Mohammédia',
  'El Jadida',
  'Nador',
  'Safi',
  'Béni Mellal',
  'Khémisset',
  'Taourirt',
  'Berkane',
  'Autre',
];

class Step2PersonalInfo extends ConsumerStatefulWidget {
  const Step2PersonalInfo({super.key});

  @override
  ConsumerState<Step2PersonalInfo> createState() => _Step2PersonalInfoState();
}

class _Step2PersonalInfoState extends ConsumerState<Step2PersonalInfo> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _cinController;
  late final TextEditingController _phoneController;

  late String _gender;
  DateTime? _birthDate;
  late String _city;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(registrationControllerProvider);
    _firstNameController = TextEditingController(text: draft.firstName);
    _lastNameController = TextEditingController(text: draft.lastName);
    _cinController = TextEditingController(text: draft.cinNumber);
    _phoneController = TextEditingController(text: draft.phone);
    _gender = draft.gender;
    _birthDate = draft.birthDate;
    _city = draft.city.isNotEmpty ? draft.city : 'Casablanca';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cinController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveDraft() {
    ref.read(registrationControllerProvider.notifier).updatePersonalInfo(
          gender: _gender,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          cinNumber: _cinController.text.trim().toUpperCase(),
          birthDate: _birthDate,
          city: _city,
          phone: Validators.normalizePhone(_phoneController.text.trim()),
        );
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner votre date de naissance'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    _saveDraft();
    ref.read(registrationControllerProvider.notifier).nextStep();
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
                        Icons.person_pin_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Étape 2 sur 3',
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
              'Informations personnelles',
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
              'Renseignez vos coordonnées d’identité telles qu’elles figurent sur votre CIN.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF64748B),
                height: 1.4,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),

            // Selected profession banner with quick edit action
            if (draft.selectedProfession != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: draft.selectedProfession!.colorLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        draft.selectedProfession!.iconData,
                        size: 22,
                        color: draft.selectedProfession!.color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Métier sélectionné',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: const Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            draft.selectedProfession!.name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _saveDraft();
                        ref
                            .read(registrationControllerProvider.notifier)
                            .setStep(0);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 15),
                      label: const Text('Modifier'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Civilité / Genre
            Text(
              'Civilité',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _GenderOption(
                    label: 'Homme',
                    icon: Icons.male_rounded,
                    isSelected: _gender == 'M',
                    onTap: () => setState(() => _gender = 'M'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _GenderOption(
                    label: 'Femme',
                    icon: Icons.female_rounded,
                    isSelected: _gender == 'F',
                    onTap: () => setState(() => _gender = 'F'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Prénom & Nom
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _firstNameController,
                    label: 'Prénom',
                    hint: 'Mohamed',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.requiredField(v, 'prénom'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _lastNameController,
                    label: 'Nom',
                    hint: 'Alami',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.requiredField(v, 'nom'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Numéro CIN
            AppTextField(
              controller: _cinController,
              label: 'Numéro CIN (Carte d’identité nationale)',
              hint: 'ex: AB123456',
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              prefixIcon:
                  const Icon(Icons.badge_outlined, color: AppColors.primary),
              validator: Validators.cinNumber,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Date de naissance
            AppDatePickerField(
              label: 'Date de naissance',
              selectedDate: _birthDate,
              onDateSelected: (date) {
                setState(() => _birthDate = date);
              },
              validator: Validators.birthDate,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Ville
            AppDropdownField<String>(
              label: 'Ville principale d’exercice',
              value: _city,
              hint: 'Sélectionnez votre ville',
              prefixIcon: const Icon(Icons.location_city_rounded,
                  color: AppColors.primary),
              items: kMoroccanCities
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _city = val);
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Téléphone
            AppPhoneField(
              controller: _phoneController,
              label: 'Numéro de téléphone portable',
              hint: '6 12 34 56 78',
              validator: Validators.phone,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Navigation buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppButton(
                    label: 'Retour',
                    variant: AppButtonVariant.outlined,
                    onPressed: () {
                      _saveDraft();
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
                    label: 'Continuer',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _onContinue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer.withValues(alpha: 0.45)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.primaryDark
                    : const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.textPrimary,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
