import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:alphine_parking/user/screens/authentication/login.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  testWidgets('Login Screen Widgets Test', (WidgetTester tester) async {
    final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

    final UserCredentialMock userCredential = UserCredentialMock();
    when(mockFirebaseAuth.signInWithEmailAndPassword(
  email: 'example@test.com ',
  password: 'testuser',
)).thenAnswer((_) async => Future.value(userCredential));

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text("Login to your account"), findsOneWidget);
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Invalid email or password.'), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Invalid email or password.'), findsOneWidget);
  });
}

class UserCredentialMock extends Mock implements UserCredential {}
