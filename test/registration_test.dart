import 'package:flutter_test/flutter_test.dart';
import 'package:clinigoo_pro/core/utils/validators.dart';
import 'package:clinigoo_pro/features/registration/domain/static_professions.dart';
import 'package:clinigoo_pro/features/registration/state/registration_controller.dart';

void main() {
  group('Validators tests', () {
    test('cinNumber validator validates Moroccan CIN format', () {
      expect(Validators.cinNumber('AB123456'), isNull);
      expect(Validators.cinNumber('A123456'), isNull);
      expect(Validators.cinNumber('k12345'), isNull);
      expect(Validators.cinNumber(''), isNotNull);
      expect(Validators.cinNumber('12345'), isNotNull);
      expect(Validators.cinNumber('INVALID'), isNotNull);
    });

    test('phone validator validates Moroccan phone numbers with or without leading 0', () {
      expect(Validators.phone('0612345678'), isNull);
      expect(Validators.phone('612345678'), isNull);
      expect(Validators.phone('700112233'), isNull);
      expect(Validators.phone('522334455'), isNull);
      expect(Validators.phone('+212612345678'), isNull);
      expect(Validators.phone('0700112233'), isNull);
      expect(Validators.phone('123'), isNotNull);
      expect(Validators.phone(''), isNotNull);
    });

    test('normalizePhone normalizes 9-digit or with-prefix numbers to standard 0X format', () {
      expect(Validators.normalizePhone('612345678'), '0612345678');
      expect(Validators.normalizePhone('0612345678'), '0612345678');
      expect(Validators.normalizePhone('+212612345678'), '0612345678');
      expect(Validators.normalizePhone('00212612345678'), '0612345678');
    });

    test('email validator validates email addresses', () {
      expect(Validators.email('doctor@clinigoo.com'), isNull);
      expect(Validators.email('invalid-email'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('password and confirmPassword validate correctly', () {
      expect(Validators.password('secret123'), isNull);
      expect(Validators.password('123'), isNotNull);
      expect(Validators.confirmPassword('secret123', 'secret123'), isNull);
      expect(Validators.confirmPassword('wrong', 'secret123'), isNotNull);
    });

    test('birthDate validator enforces minimum age of 18', () {
      final validAge = DateTime.now().subtract(const Duration(days: 365 * 25));
      final underAge = DateTime.now().subtract(const Duration(days: 365 * 16));

      expect(Validators.birthDate(validAge), isNull);
      expect(Validators.birthDate(underAge), isNotNull);
      expect(Validators.birthDate(null), isNotNull);
    });
  });

  group('RegistrationController tests', () {
    test('initial state and multi-step flow progression', () {
      final controller = RegistrationController();
      expect(controller.state.currentStep, 0);

      // Step 1: Select profession
      controller.selectProfession(kStaticProfessions.first);
      expect(controller.state.selectedProfession?.slug, 'medecin_generaliste');
      controller.nextStep();
      expect(controller.state.currentStep, 1);

      // Step 2: Personal info
      controller.updatePersonalInfo(
        gender: 'M',
        firstName: 'Ahmed',
        lastName: 'Bennani',
        cinNumber: 'BK123456',
        birthDate: DateTime(1990, 5, 15),
        city: 'Casablanca',
        phone: '0612345678',
      );
      expect(controller.state.firstName, 'Ahmed');
      expect(controller.state.cinNumber, 'BK123456');
      controller.nextStep();
      expect(controller.state.currentStep, 2);

      // Step 3: Account credentials
      controller.updateCredentials(
        email: 'ahmed@clinigoo.test',
        password: 'password123',
        confirmPassword: 'password123',
        termsAccepted: true,
      );

      final req = controller.state.toRequest();
      expect(req, isNotNull);
      expect(req!.firstName, 'Ahmed');
      expect(req.lastName, 'Bennani');
      expect(req.cinNumber, 'BK123456');
      expect(req.gender, 'M');
      expect(req.city, 'Casablanca');
      expect(req.phone, '0612345678');
      expect(req.email, 'ahmed@clinigoo.test');
      expect(req.toJson()['type'], 'professional');
      expect(req.toJson()['id_number'], 'BK123456');
    });

    test('ProfessionalRegisterRequest toJson produces clean unified payload without duplicates', () {
      final controller = RegistrationController();
      final req = controller.state
          .copyWith(
            selectedProfession: kStaticProfessions.first,
            gender: 'M',
            firstName: 'Ahmad',
            lastName: 'Alami',
            cinNumber: 'K607333',
            birthDate: DateTime(2001, 1, 2),
            city: 'Tanger',
            phone: '0600953353',
            email: 'pro1@clinigoo.ma',
            password: 'password',
          )
          .toRequest()!;

      final json = req.toJson();

      expect(json, {
        'type': 'professional',
        'profession_id': int.tryParse(kStaticProfessions.first.id) ?? kStaticProfessions.first.id,
        'first_name': 'Ahmad',
        'last_name': 'Alami',
        'gender': 'M',
        'id_number': 'K607333',
        'date_of_birth': '2001-01-02',
        'city': 'Tanger',
        'phone': '0600953353',
        'email': 'pro1@clinigoo.ma',
        'password': 'password',
      });

      // Verify no duplicate fields exist in payload
      expect(json.containsKey('role'), isFalse);
      expect(json.containsKey('firstName'), isFalse);
      expect(json.containsKey('lastName'), isFalse);
      expect(json.containsKey('sexe'), isFalse);
      expect(json.containsKey('ID'), isFalse);
      expect(json.containsKey('professional_id'), isFalse);
      expect(json.containsKey('birthday'), isFalse);
    });
  });
}
