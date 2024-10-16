import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:wildlife_api_connection/models/user.dart';
import 'package:wildlife_api_connection/profile_api.dart';

import 'mocks/api_mocks.mocks.dart';

void main() {
  group('ProfileAPI', () {
    late MockApiClient mockApiClient;
    late ProfileApi profileApi;

    setUp(() {
      mockApiClient = MockApiClient();
      profileApi = ProfileApi(mockApiClient);
    });

    test('profile get returns user when given token', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const email = 'test@example.com';

      const responseJson = {
        "ID": id,
        "email": email,
      };
      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.get(
        'profile/me/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await profileApi.getMyProfile();

      // Assert
      expect(result, isA<User>());
      expect(result.id, id);
      expect(result.email, email);
    });

    test('profile get throws exception when given invalid token', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const email = 'test@example.com';

      const responseJson = {
        "ID": id,
        "email": email,
      };
      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.unauthorized);

      when(mockApiClient.get(
        'profile/me/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(() async => await profileApi.getMyProfile(),
          throwsA(isA<Exception>()));
    });

    test('profile update returns user when given token', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const email = 'test@example.com';
      const name = 'test';

      const responseJson = {
        "ID": id,
        "email": email,
        "name": name,
      };
      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.put(
        'profile/me/',
        {
          'name': name,
        },
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await profileApi.updateProfile(
        name,
      );

      // Assert
      expect(result, isA<User>());
      expect(result.id, id);
      expect(result.email, email);
      expect(result.name, name);
    });

    test('profile get throws exception when given invalid token', () async {
      // Arrange
      const responseJson = {
        "status": 403,
        "title": "Unauthorized",
      };
      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.unauthorized);

      when(mockApiClient.put(
        'profile/me/',
        {
          'name': 'test',
        },
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(() async => await profileApi.updateProfile('test'),
          throwsA(isA<Exception>()));
    });
  });
}
