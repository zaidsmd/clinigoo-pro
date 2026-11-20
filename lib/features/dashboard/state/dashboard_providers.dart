import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/api_constants.dart';
import '../../../core/auth/state/auth_providers.dart';
import '../domain/document_checklist_item.dart';

final professionalDocumentChecklistProvider =
    FutureProvider.autoDispose<List<DocumentChecklistItem>>((ref) async {
  final dio = ref.watch(apiClientProvider).dio;
  final response = await dio.get(ApiConstants.professionalDossier);
  final data = response.data;

  if (data is Map<String, dynamic>) {
    final rawChecklist = data['document_checklist'];
    if (rawChecklist is List) {
      return rawChecklist
          .whereType<Map<String, dynamic>>()
          .map(DocumentChecklistItem.fromJson)
          .toList();
    }
  }

  return const [];
});
