class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.gender,
    this.cinNumber,
    this.city,
    this.birthDate,
    this.professionName,
    this.status,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? gender;
  final String? cinNumber;
  final String? city;
  final DateTime? birthDate;
  final String? professionName;
  final String? status;

  String get fullName => '$firstName $lastName'.trim();
  bool get isDraft => status == null || status == 'draft';
  bool get isPending => status == 'pending' || status == 'pending_changes';
  bool get isValidated => status == 'validated' || status == 'active';
  bool get isRejected => status == 'rejected';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final proProfile = json['professional_profile'] as Map<String, dynamic>? ??
        json['professionalProfile'] as Map<String, dynamic>?;

    final profession = proProfile?['profession'] as Map<String, dynamic>?;

    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: proProfile?['first_name']?.toString() ??
          proProfile?['firstName']?.toString() ??
          json['name']?.toString().split(' ').first ??
          '',
      lastName: proProfile?['last_name']?.toString() ??
          proProfile?['lastName']?.toString() ??
          (json['name']?.toString().contains(' ') == true
              ? json['name']?.toString().split(' ').sublist(1).join(' ') ?? ''
              : ''),
      role: json['type']?.toString() ?? json['role']?.toString() ?? 'professional',
      phone: proProfile?['phone']?.toString() ?? json['phone']?.toString(),
      gender: proProfile?['gender']?.toString() ?? proProfile?['sexe']?.toString(),
      cinNumber: proProfile?['id_number']?.toString() ??
          proProfile?['professional_id']?.toString() ??
          proProfile?['ID']?.toString(),
      city: proProfile?['city']?.toString(),
      birthDate: proProfile?['date_of_birth'] != null
          ? DateTime.tryParse(proProfile!['date_of_birth'].toString())
          : (proProfile?['birthday'] != null
              ? DateTime.tryParse(proProfile!['birthday'].toString())
              : null),
      professionName: profession?['name']?.toString(),
      status: proProfile?['status']?.toString() ?? 'draft',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'phone': phone,
        'gender': gender,
        'cinNumber': cinNumber,
        'city': city,
        'birthDate': birthDate?.toIso8601String(),
        'professionName': professionName,
        'status': status,
      };
}
