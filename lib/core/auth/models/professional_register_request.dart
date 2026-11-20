import '../../utils/date_time_utils.dart';

class ProfessionalRegisterRequest {
  const ProfessionalRegisterRequest({
    required this.professionId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.cinNumber,
    required this.birthDate,
    required this.city,
    required this.phone,
    required this.email,
    required this.password,
  });

  final String professionId;
  final String firstName;
  final String lastName;
  final String gender; // 'M' or 'F'
  final String cinNumber;
  final DateTime birthDate;
  final String city;
  final String phone;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'type': 'professional',
        'profession_id': int.tryParse(professionId) ?? professionId,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'id_number': cinNumber,
        'date_of_birth': DateTimeUtils.toApiDate(birthDate),
        'city': city,
        'phone': phone,
        'email': email,
        'password': password,
      };
}
