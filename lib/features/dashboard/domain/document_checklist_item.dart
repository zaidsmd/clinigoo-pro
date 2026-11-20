class DocumentChecklistItem {
  const DocumentChecklistItem({
    required this.professionDocumentId,
    required this.name,
    required this.isRequired,
    required this.formats,
    required this.uploaded,
    this.documentStatus,
    this.rejectionReason,
  });

  final int professionDocumentId;
  final String name;
  final bool isRequired;
  final List<String> formats;
  final bool uploaded;
  final String? documentStatus;
  final String? rejectionReason;

  bool get isValidated =>
      documentStatus == 'validated' || documentStatus == 'approved';

  bool get isPending => uploaded && documentStatus == 'pending';

  bool get isRejected => documentStatus == 'rejected';

  String get statusLabel {
    if (isValidated) return 'Validé';
    if (isRejected) return 'Rejeté';
    if (isPending) return 'En examen';
    return isRequired ? 'Obligatoire' : 'Optionnel';
  }

  String get formatsSummary {
    if (formats.isEmpty) return 'Formats : PDF, JPG, PNG';
    final formatted = formats.map((f) => f.toUpperCase()).join(', ');
    return 'Formats : $formatted';
  }

  factory DocumentChecklistItem.fromJson(Map<String, dynamic> json) {
    final doc = json['document'] as Map<String, dynamic>?;
    final rawFormats = json['formats'];
    final formats = rawFormats is List
        ? rawFormats.map((e) => e.toString()).toList()
        : const <String>['pdf', 'jpg', 'jpeg', 'png'];

    return DocumentChecklistItem(
      professionDocumentId:
          int.tryParse(json['profession_document_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? 'Document',
      isRequired: json['is_required'] == true || json['required'] == true,
      formats: formats,
      uploaded: json['uploaded'] == true || doc != null,
      documentStatus: doc?['status']?.toString(),
      rejectionReason: doc?['rejection_reason']?.toString(),
    );
  }
}
