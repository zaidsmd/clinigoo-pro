import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/profession.dart';
import '../../domain/static_professions.dart';
import '../../state/registration_controller.dart';

class Step1ProfessionSelection extends ConsumerStatefulWidget {
  const Step1ProfessionSelection({super.key});

  @override
  ConsumerState<Step1ProfessionSelection> createState() =>
      _Step1ProfessionSelectionState();
}

class _Step1ProfessionSelectionState
    extends ConsumerState<Step1ProfessionSelection> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(registrationControllerProvider);
    final controller = ref.read(registrationControllerProvider.notifier);

    final filteredProfessions = kStaticProfessions.where((p) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();

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
                      Icons.medical_services_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Étape 1 sur 3',
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

          // Main Title matching screenshot
          Text(
            'Quelle est votre profession de santé ?',
            style: AppTextStyles.h2.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle matching screenshot
          Text(
            'Cliquez sur votre métier pour continuer vers vos informations personnelles.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF64748B),
              height: 1.4,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 16),

          // Optional Search bar
          Container(
            height: 44,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Rechercher par mot-clé...',
                hintStyle:
                    AppTextStyles.bodySmall.copyWith(color: const Color(0xFF94A3B8)),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),

          // Professions List
          if (filteredProfessions.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aucun résultat',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aucune profession ne correspond à "$_searchQuery".',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProfessions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final profession = filteredProfessions[index];
                final isSelected = draft.selectedProfession?.id == profession.id;

                return _ProfessionCard(
                  profession: profession,
                  isSelected: isSelected,
                  onTap: () {
                    controller.selectProfession(profession);
                    controller.nextStep();
                  },
                );
              },
            ),
          if (draft.selectedProfession != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Continuer',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => controller.nextStep(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfessionCard extends StatelessWidget {
  const _ProfessionCard({
    required this.profession,
    required this.isSelected,
    required this.onTap,
  });

  final Profession profession;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? profession.color : const Color(0xFFE2E8F0),
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? profession.color.withValues(alpha: 0.16)
                    : const Color(0x060B1C30),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Icon container + Category pill + Circular arrow
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: profession.colorLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      profession.iconData,
                      color: profession.color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: profession.colorLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      profession.category,
                      style: TextStyle(
                        color: profession.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? profession.color
                            : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      color: isSelected
                          ? profession.colorLight
                          : Colors.transparent,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: isSelected
                          ? profession.color
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                profession.name,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                profession.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF64748B),
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),

              // Divider
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              // Bottom row matching screenshot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: isSelected
                            ? profession.color
                            : const Color(0xFFCBD5E1),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Choisir ce métier',
                        style: TextStyle(
                          color: isSelected
                              ? profession.color
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Continuer',
                        style: TextStyle(
                          color: isSelected
                              ? profession.color
                              : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: isSelected
                            ? profession.color
                            : const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
