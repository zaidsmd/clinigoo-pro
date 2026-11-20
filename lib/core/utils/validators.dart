abstract final class Validators {
  static String? requiredField(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'Le champ $fieldName est requis'
          : 'Ce champ est requis';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre adresse email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Veuillez saisir une adresse email valide';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir un mot de passe';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit comporter au moins 8 caractères';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? cinNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro CIN est requis';
    }
    final cinRegex = RegExp(r'^[A-Za-z]{1,2}\d{5,7}$');
    if (!cinRegex.hasMatch(value.trim())) {
      return 'Format CIN invalide (ex: AB123456)';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    // Accepts Moroccan numbers:
    // With prefix: +212612345678, 00212612345678
    // With leading zero: 0612345678, 0712345678, 0512345678 (10 digits)
    // Without leading zero (prefixed with +212): 612345678, 712345678, 512345678 (9 digits starting with 5, 6, 7)
    final phoneRegex = RegExp(r'^(?:(?:\+212|00212)|0)?[5-7]\d{8}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Numéro de téléphone marocain invalide (ex: 612345678 ou 0612345678)';
    }
    return null;
  }

  /// Normalizes a Moroccan phone input to standard local format starting with '0' (e.g. '0612345678')
  static String normalizePhone(String value) {
    var cleaned = value.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    if (cleaned.startsWith('+212')) {
      cleaned = cleaned.substring(4);
    } else if (cleaned.startsWith('00212')) {
      cleaned = cleaned.substring(5);
    }
    if (!cleaned.startsWith('0') && cleaned.isNotEmpty) {
      cleaned = '0$cleaned';
    }
    return cleaned;
  }

  static String? birthDate(DateTime? value) {
    if (value == null) {
      return 'La date de naissance est requise';
    }
    final now = DateTime.now();
    var age = now.year - value.year;
    if (now.month < value.month ||
        (now.month == value.month && now.day < value.day)) {
      age--;
    }
    if (age < 18) {
      return 'Vous devez avoir au moins 18 ans pour vous inscrire';
    }
    if (age > 100) {
      return 'Date de naissance invalide';
    }
    return null;
  }
}
