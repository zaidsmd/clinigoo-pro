import 'package:flutter/material.dart';

class Profession {
  const Profession({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.iconData,
  });

  final String id;
  final String slug;
  final String name;
  final String description;
  final IconData iconData;

  String get category => switch (slug.toLowerCase()) {
        'medecin_generaliste' || 'doctor' || 'medecin' => 'Médical',
        'pediatre' || 'pediatrician' => 'Médical',
        'infirmiere' || 'infirmier' || 'nurse' => 'Soins',
        'kinesitherapeute' || 'physio' => 'Rééducation',
        'sage_femme' || 'midwife' => 'Maïeutique',
        'aide_soignante' || 'aide_soignant' || 'caregiver' => 'Aide & Soins',
        _ => 'Santé',
      };

  Color get color => switch (slug.toLowerCase()) {
        'medecin_generaliste' || 'doctor' || 'medecin' => const Color(0xFF007BFF), // Royal Blue
        'pediatre' || 'pediatrician' => const Color(0xFF8B5CF6), // Purple
        'infirmiere' || 'infirmier' || 'nurse' => const Color(0xFF00A8CC), // Clinigoo Teal
        'kinesitherapeute' || 'physio' => const Color(0xFF10B981), // Emerald Green
        'sage_femme' || 'midwife' => const Color(0xFFEC4899), // Rose Pink
        'aide_soignante' || 'aide_soignant' || 'caregiver' => const Color(0xFFF59E0B), // Warm Amber
        _ => const Color(0xFF00A8CC),
      };

  Color get colorLight => switch (slug.toLowerCase()) {
        'medecin_generaliste' || 'doctor' || 'medecin' => const Color(0xFFEAF5FF),
        'pediatre' || 'pediatrician' => const Color(0xFFF3E8FF),
        'infirmiere' || 'infirmier' || 'nurse' => const Color(0xFFD9F8FF),
        'kinesitherapeute' || 'physio' => const Color(0xFFD1FAE5),
        'sage_femme' || 'midwife' => const Color(0xFFFCE7F3),
        'aide_soignante' || 'aide_soignant' || 'caregiver' => const Color(0xFFFEF3C7),
        _ => const Color(0xFFE0F7FA),
      };

  Color get colorDark => switch (slug.toLowerCase()) {
        'medecin_generaliste' || 'doctor' || 'medecin' => const Color(0xFF0056B3),
        'pediatre' || 'pediatrician' => const Color(0xFF6D28D9),
        'infirmiere' || 'infirmier' || 'nurse' => const Color(0xFF00677E),
        'kinesitherapeute' || 'physio' => const Color(0xFF047857),
        'sage_femme' || 'midwife' => const Color(0xFFBE185D),
        'aide_soignante' || 'aide_soignant' || 'caregiver' => const Color(0xFFB45309),
        _ => const Color(0xFF00677E),
      };

  factory Profession.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final slug = json['slug']?.toString() ?? '';
    final name = json['name']?.toString() ?? '';
    final description = json['description']?.toString() ?? '';

    return Profession(
      id: id,
      slug: slug,
      name: name,
      description: description,
      iconData: _iconFromSlug(slug),
    );
  }

  static IconData _iconFromSlug(String slug) {
    return switch (slug.toLowerCase()) {
      'medecin_generaliste' || 'doctor' || 'medecin' => Icons.medical_services_rounded,
      'infirmiere' || 'infirmier' || 'nurse' => Icons.healing_rounded,
      'kinesitherapeute' || 'physio' => Icons.accessibility_new_rounded,
      'pediatre' || 'pediatrician' => Icons.child_care_rounded,
      'sage_femme' || 'midwife' => Icons.pregnant_woman_rounded,
      'aide_soignante' || 'aide_soignant' || 'caregiver' => Icons.volunteer_activism_rounded,
      _ => Icons.health_and_safety_rounded,
    };
  }
}
