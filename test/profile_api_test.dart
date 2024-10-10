import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:wildlife_api_connection/profile_api.dart';

import 'mocks/api_mocks.mocks.dart';

void main() {
  group('GroupApi', () {
    late MockApiClient mockApiClient;
    late ProfileApi profileApi;

    setUp(() {
      mockApiClient = MockApiClient();
      profileApi = ProfileApi(mockApiClient);
    });

    test('profile get returns json when given token', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const name = 'test';
      const email = 'test@example.com';

      const responseJson = {
        "ID": id,
        "name": name,
        "email": email,
      };
      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.post(
        'profile/me/',
        {},
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await profileApi.getMyProfile();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['ID'], id);
      expect(result['name'], name);
      expect(result['email'], email);
    });

    test('profile get throws exception when given invalid token', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const name = 'test';
      const email = 'test@example.com';

      const responseJson = {
        "ID": id,
        "name": name,
        "email": email,
      };
      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.unauthorized);

      when(mockApiClient.post(
        'profile/me/',
        {},
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(() async => await profileApi.getMyProfile(),
          throwsA(isA<Exception>()));
    });
  });
}
