import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/auth_api.dart';

import 'mocks/api_mocks.mocks.dart';

void main() {
  group('LoginApi', () {
    late MockApiClient mockApiClient;
    late AuthApi authApi;

    setUp(() {
      mockApiClient = MockApiClient();
      authApi = AuthApi(mockApiClient);
    });

    test('successful login', () async {
      // Arrange
      const email = 'test@example.com';
      const displayNameApp = 'Wildlife';
      const displayNameUser = 'Wildlife User';

      const responseJson = {
        'detail': "The authentication code has been sent to: $email"
      };
      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.post(
        'auth/',
        {
          'displayNameApp': displayNameApp,
          'displayNameUser': displayNameUser,
          'email': email,
        },
        authenticated: false,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await authApi.login(
        displayNameApp,
        displayNameUser,
        email,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
    });

    test('failed login', () async {
      // Arrange
      const email = 'test@example.com';
      const displayNameApp = 'Wildlife';
      const displayNameUser = 'Wildlife User';
      final responseJson = {};
      final response = http.Response(
          jsonEncode(responseJson), HttpStatus.internalServerError);

      when(mockApiClient.post(
        'auth/',
        {
          'displayNameApp': displayNameApp,
          'displayNameUser': displayNameUser,
          'email': email,
        },
        authenticated: false,
      )).thenAnswer((_) async => response);

      // Act & Assert
      expect(
        () async => await authApi.login(
          displayNameApp,
          displayNameUser,
          email,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
