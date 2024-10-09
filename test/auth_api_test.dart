import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/auth_api.dart';

import 'mocks/api_mocks.mocks.dart';

void main() {
  group('AuthApi', () {
    late MockApiClient mockApiClient;
    late AuthApi authApi;

    setUp(() {
      mockApiClient = MockApiClient();
      authApi = AuthApi(mockApiClient);
    });

    test('successful authenticate', () async {
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
      final result = await authApi.authenticate(
        displayNameApp,
        displayNameUser,
        email,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
    });

    test('failed authenticate', () async {
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
        () async => await authApi.authenticate(
          displayNameApp,
          displayNameUser,
          email,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('successful authorize', () async {
      // Arrange
      const email = 'test@example.com';
      const code = '1234';
      const responseJson = {
        "email": email,
        "lastLogon": "2019-08-24T14:15:22Z",
        "scopes": ["string"],
        "token": "b5507016-7da2-4777-a161-1e8042a6a377",
        "userID": "2c3821b8-1cdb-4b77-bcd8-a1da701e46aa"
      };
      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.put(
        'auth/',
        {
          'email': email,
          'code': code,
        },
        authenticated: false,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await authApi.authorize(
        email,
        code,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['email'], email);
    });

    test('failed authorize', () async {
      // Arrange
      const email = 'test@example.com';
      const code = '1234';
      final responseJson = {
        "detail":
            "The combination of email and code does not match a previous authentication. If you are sure that the email is correct, perhaps the code expired. You can authenticate again to get a new code."
      };
      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.forbidden);

      when(mockApiClient.put(
        'auth/',
        {
          'email': email,
          'code': code,
        },
        authenticated: false,
      )).thenAnswer((_) async => response);

      // Act & Assert
      expect(
        () async => await authApi.authorize(
          email,
          code,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
