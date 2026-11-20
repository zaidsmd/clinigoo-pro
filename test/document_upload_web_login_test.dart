import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clinigoo_pro/app/config/app_config.dart';
import 'package:clinigoo_pro/core/auth/models/auth_user.dart';
import 'package:clinigoo_pro/core/auth/models/login_request.dart';
import 'package:clinigoo_pro/core/auth/models/professional_register_request.dart';
import 'package:clinigoo_pro/core/auth/repositories/auth_repository.dart';
import 'package:clinigoo_pro/core/auth/state/auth_providers.dart';
import 'package:clinigoo_pro/features/dashboard/domain/document_checklist_item.dart';
import 'package:clinigoo_pro/features/dashboard/presentation/professional_dashboard_screen.dart';
import 'package:clinigoo_pro/features/dashboard/state/dashboard_providers.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._user);

  final AuthUser? _user;

  @override
  Future<AuthUser?> me() async => _user;

  @override
  Future<AuthUser> login(LoginRequest request) async => _user!;

  @override
  Future<AuthUser> register(ProfessionalRegisterRequest request) async => _user!;

  @override
  Future<void> logout() async {}
}

AuthUser _makeUser({required String status}) {
  return AuthUser(
    id: '1',
    email: 'pro@clinigoo.ma',
    firstName: 'Ahmed',
    lastName: 'Bennani',
    role: 'professional',
    status: status,
  );
}

void main() {
  group('AppConfig env resolution', () {
    test('reads API_BASE_URL and WEB_BASE_URL from dotenv and builds webLoginUri', () {
      dotenv.loadFromString(
        envString: '''
API_BASE_URL=https://api.clinigoo.ma
WEB_BASE_URL=https://app.clinigoo.ma/
''',
      );

      expect(AppConfig.baseUrl, 'https://api.clinigoo.ma');
      expect(AppConfig.webBaseUrl, 'https://app.clinigoo.ma/');
      expect(AppConfig.webLoginUri, Uri.parse('https://app.clinigoo.ma/login'));
    });
  });

  group('ProfessionalDashboardScreen document upload flow', () {
    setUp(() {
      dotenv.loadFromString(
        envString: '''
API_BASE_URL=http://127.0.0.1:8000
WEB_BASE_URL=https://pro.clinigoo.ma
''',
      );
    });

    testWidgets(
      'draft user tapping "Importer mes pièces" launches web login page',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(430, 932);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        Uri? launchedUri;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(
                _FakeAuthRepository(_makeUser(status: 'draft')),
              ),
              professionalDocumentChecklistProvider.overrideWith(
                (ref) async => const [
                  DocumentChecklistItem(
                    professionDocumentId: 10,
                    name: 'Carte Professionnelle',
                    isRequired: true,
                    formats: ['pdf', 'png'],
                    uploaded: false,
                  ),
                  DocumentChecklistItem(
                    professionDocumentId: 11,
                    name: 'Assurance RC Pro',
                    isRequired: false,
                    formats: ['pdf'],
                    uploaded: false,
                  ),
                ],
              ),
            ],
            child: MaterialApp(
              home: ProfessionalDashboardScreen(
                onLaunchWebLogin: (uri) async {
                  launchedUri = uri;
                  return true;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Fournir mes pièces'));
        await tester.pumpAndSettle();

        expect(find.text('Carte Professionnelle'), findsOneWidget);
        expect(find.text('Assurance RC Pro'), findsOneWidget);
        expect(find.text('Obligatoire'), findsOneWidget);
        expect(find.text('Optionnel'), findsOneWidget);
        expect(find.text('Importer mes pièces'), findsOneWidget);
        await tester.tap(find.text('Importer mes pièces'));
        await tester.pumpAndSettle();

        expect(launchedUri, Uri.parse('https://pro.clinigoo.ma/login'));
      },
    );

    testWidgets(
      'validated user does not see "Importer mes pièces" button in documents sheet',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(430, 932);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(
                _FakeAuthRepository(_makeUser(status: 'validated')),
              ),
              professionalDocumentChecklistProvider.overrideWith(
                (ref) async => const [
                  DocumentChecklistItem(
                    professionDocumentId: 10,
                    name: 'Carte Professionnelle',
                    isRequired: true,
                    formats: ['pdf'],
                    uploaded: true,
                    documentStatus: 'validated',
                  ),
                ],
              ),
            ],
            child: const MaterialApp(
              home: ProfessionalDashboardScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Documents'));
        await tester.pumpAndSettle();

        expect(find.text('Importer mes pièces'), findsNothing);
        expect(find.text('Fermer'), findsOneWidget);
      },
    );
  });
}
