import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/auth/models/auth_user.dart';
import '../../../core/auth/state/auth_controller.dart';
import '../../../core/auth/state/auth_providers.dart';
import '../../../core/utils/date_time_utils.dart';
import '../domain/document_checklist_item.dart';
import '../state/dashboard_providers.dart';

class ProfessionalDashboardScreen extends ConsumerWidget {
  const ProfessionalDashboardScreen({
    super.key,
    this.onLaunchWebLogin,
  });

  final Future<bool> Function(Uri uri)? onLaunchWebLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState is Authenticated ? authState.user : null;
    final checklistAsync = ref.watch(professionalDocumentChecklistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/svg/logo-long.svg',
          height: 80,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => Image.asset(
            'assets/images/logo.png',
            height: 36,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'Déconnexion',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeader(user),
              const SizedBox(height: AppSpacing.lg),
              _buildVerificationCard(context, user, checklistAsync),
              const SizedBox(height: AppSpacing.lg),
              _buildDetailsCard(user),
              const SizedBox(height: AppSpacing.lg),
              _buildActionsSection(context, user, checklistAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthUser? user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              (user?.firstName.isNotEmpty == true ? user!.firstName[0] : 'P')
                  .toUpperCase(),
              style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null && user.fullName.isNotEmpty
                      ? user.fullName
                      : 'Professionnel de santé',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user?.professionName ?? 'Professionnel de santé',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (user?.cinNumber != null && user!.cinNumber!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'CIN : ${user.cinNumber}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard(
    BuildContext context,
    AuthUser? user,
    AsyncValue<List<DocumentChecklistItem>> checklistAsync,
  ) {
    if (user?.isValidated == true) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.successContainer.withValues(alpha: 0.5),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.verified_rounded,
              color: AppColors.onSuccessContainer,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compte vérifié & actif',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSuccessContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Votre compte est validé. Vous pouvez recevoir des demandes de soins.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSuccessContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (user?.isPending == true) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warningContainer.withValues(alpha: 0.5),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.pending_actions_rounded,
              color: AppColors.onWarningContainer,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dossier en cours d’examen',
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onWarningContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Vos pièces ont été transmises et sont en cours de validation par notre service médical.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onWarningContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (user?.isRejected == true) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.errorContainer.withValues(alpha: 0.5),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.onErrorContainer,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dossier à corriger',
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Certaines pièces justificatives nécessitent une correction pour valider votre compte.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showDocumentsSheet(context, user),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Mettre à jour mes pièces'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Default: isDraft (account created, documents not yet submitted)
    final requiredNames = checklistAsync.valueOrNull
            ?.where((doc) => doc.isRequired && !doc.uploaded)
            .map((doc) => doc.name)
            .toList() ??
        const <String>[];
    final requiredSummary = requiredNames.isNotEmpty
        ? ' (${requiredNames.join(', ')})'
        : '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.assignment_late_outlined,
                color: AppColors.primaryDark,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dossier incomplet — Pièces requises',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Votre profil est créé ! Pour activer votre compte et recevoir des demandes de soins, veuillez importer vos pièces justificatives$requiredSummary.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _showDocumentsSheet(context, user),
              icon: const Icon(Icons.upload_file_rounded, size: 18),
              label: const Text('Fournir mes pièces'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                textStyle: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(AuthUser? user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mes coordonnées', style: AppTextStyles.h4),
          const Divider(height: 24),
          _buildInfoItem(Icons.email_outlined, 'Email', user?.email ?? '-'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(
            Icons.phone_outlined,
            'Téléphone',
            user?.phone != null
                ? '+212 ${user!.phone!.startsWith('0') ? user!.phone!.substring(1) : user!.phone}'
                : '-',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(
            Icons.location_on_outlined,
            'Ville',
            user?.city ?? '-',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem(
            Icons.cake_outlined,
            'Date de naissance',
            user?.birthDate != null
                ? DateTimeUtils.formatDate(user!.birthDate!)
                : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    AuthUser? user,
    AsyncValue<List<DocumentChecklistItem>> checklistAsync,
  ) {
    final requiredCount = checklistAsync.valueOrNull
        ?.where((doc) => doc.isRequired)
        .length;
    final docsSubtitle = requiredCount != null && requiredCount > 0
        ? '$requiredCount pièce${requiredCount > 1 ? 's' : ''} requise${requiredCount > 1 ? 's' : ''}'
        : 'Pièces justificatives';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions rapides', style: AppTextStyles.h4),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.calendar_month_rounded,
                title: 'Disponibilité',
                subtitle: 'Planning soins',
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionCard(
                icon: Icons.description_outlined,
                title: 'Documents',
                subtitle: docsSubtitle,
                onTap: () => _showDocumentsSheet(context, user),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDocumentsSheet(BuildContext context, AuthUser? user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(
                  Icons.folder_shared_outlined,
                  color: AppColors.primary,
                  size: 26,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Pièces justificatives requises',
                    style: AppTextStyles.h4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Pour exercer sur Clinigoo et garantir la sécurité des patients, nous vérifions chaque professionnel de santé.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Consumer(
              builder: (context, ref, _) {
                final checklistAsync =
                    ref.watch(professionalDocumentChecklistProvider);

                return checklistAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer.withValues(alpha: 0.4),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.onErrorContainer,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Impossible de charger la liste des pièces requises.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onErrorContainer,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(professionalDocumentChecklistProvider),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                  data: (docs) {
                    if (docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.sm,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Aucune pièce justificative configurée pour votre profession.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        for (var i = 0; i < docs.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpacing.sm),
                          _buildDocItem(
                            icon: docs[i].isValidated
                                ? Icons.verified_outlined
                                : (docs[i].isRejected
                                    ? Icons.error_outline_rounded
                                    : Icons.description_outlined),
                            title: docs[i].name,
                            subtitle: docs[i].isRejected &&
                                    docs[i].rejectionReason != null &&
                                    docs[i].rejectionReason!.isNotEmpty
                                ? 'Rejeté : ${docs[i].rejectionReason}'
                                : docs[i].formatsSummary,
                            status: docs[i].statusLabel,
                            isDone: docs[i].isValidated,
                            isRejected: docs[i].isRejected,
                            isRequired: docs[i].isRequired,
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                borderRadius: AppRadius.sm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Validation médicale effectuée sous 24h à 48h ouvrées après transmission des pièces.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (user?.isValidated != true && user?.isPending != true)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _openWebLogin(context);
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Importer mes pièces'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                  ),
                ),
              )
            else
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.md,
                  ),
                ),
                child: const Text('Fermer'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWebLogin(BuildContext context) async {
    final uri = AppConfig.webLoginUri;
    var launched = false;
    try {
      launched = onLaunchWebLogin != null
          ? await onLaunchWebLogin!(uri)
          : await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Impossible d’ouvrir la page de connexion web ($uri).',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildDocItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required bool isDone,
    bool isRejected = false,
    bool isRequired = false,
  }) {
    final badgeBg = isDone
        ? AppColors.successContainer
        : isRejected
            ? AppColors.errorContainer
            : status == 'En examen'
                ? AppColors.warningContainer
                : isRequired
                    ? AppColors.errorContainer.withValues(alpha: 0.6)
                    : AppColors.border.withValues(alpha: 0.5);

    final badgeFg = isDone
        ? AppColors.onSuccessContainer
        : isRejected
            ? AppColors.onErrorContainer
            : status == 'En examen'
                ? AppColors.onWarningContainer
                : isRequired
                    ? AppColors.onErrorContainer
                    : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.sm,
        border: Border.all(
          color: isRejected ? AppColors.error.withValues(alpha: 0.5) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isRejected ? AppColors.error : AppColors.primaryDark,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isRejected ? AppColors.error : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: badgeFg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppRadius.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.md,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(icon, color: AppColors.primaryDark, size: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.labelMedium
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
