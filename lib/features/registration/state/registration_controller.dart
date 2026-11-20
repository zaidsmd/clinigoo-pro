import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/models/professional_register_request.dart';
import '../domain/profession.dart';

class RegistrationDraftState {
  const RegistrationDraftState({
    this.currentStep = 0,
    this.selectedProfession,
    this.gender = 'M',
    this.firstName = '',
    this.lastName = '',
    this.cinNumber = '',
    this.birthDate,
    this.city = 'Casablanca',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.termsAccepted = false,
  });

  final int currentStep;
  final Profession? selectedProfession;
  final String gender;
  final String firstName;
  final String lastName;
  final String cinNumber;
  final DateTime? birthDate;
  final String city;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;

  RegistrationDraftState copyWith({
    int? currentStep,
    Profession? selectedProfession,
    String? gender,
    String? firstName,
    String? lastName,
    String? cinNumber,
    DateTime? birthDate,
    String? city,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    bool? termsAccepted,
  }) {
    return RegistrationDraftState(
      currentStep: currentStep ?? this.currentStep,
      selectedProfession: selectedProfession ?? this.selectedProfession,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cinNumber: cinNumber ?? this.cinNumber,
      birthDate: birthDate ?? this.birthDate,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

  ProfessionalRegisterRequest? toRequest() {
    if (selectedProfession == null || birthDate == null) return null;
    return ProfessionalRegisterRequest(
      professionId: selectedProfession!.id,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      gender: gender,
      cinNumber: cinNumber.trim().toUpperCase(),
      birthDate: birthDate!,
      city: city.trim(),
      phone: phone.trim(),
      email: email.trim(),
      password: password,
    );
  }
}

class RegistrationController extends StateNotifier<RegistrationDraftState> {
  RegistrationController() : super(const RegistrationDraftState());

  void selectProfession(Profession profession) {
    state = state.copyWith(selectedProfession: profession);
  }

  void updatePersonalInfo({
    String? gender,
    String? firstName,
    String? lastName,
    String? cinNumber,
    DateTime? birthDate,
    String? city,
    String? phone,
  }) {
    state = state.copyWith(
      gender: gender,
      firstName: firstName,
      lastName: lastName,
      cinNumber: cinNumber,
      birthDate: birthDate,
      city: city,
      phone: phone,
    );
  }

  void updateCredentials({
    String? email,
    String? password,
    String? confirmPassword,
    bool? termsAccepted,
  }) {
    state = state.copyWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      termsAccepted: termsAccepted,
    );
  }

  void setStep(int step) {
    if (step >= 0 && step <= 2) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = const RegistrationDraftState();
  }
}

final registrationControllerProvider =
    StateNotifierProvider<RegistrationController, RegistrationDraftState>((ref) {
  return RegistrationController();
});
