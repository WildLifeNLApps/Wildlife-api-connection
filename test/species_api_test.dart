import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:wildlife_api_connection/models/species.dart';
import 'package:wildlife_api_connection/species_api.dart';

import 'mocks/api_mocks.mocks.dart';

void main() {
  group('SpeciesApi', () {
    late MockApiClient mockApiClient;
    late SpeciesApi speciesApi;

    setUp(() {
      mockApiClient = MockApiClient();
      speciesApi = SpeciesApi(mockApiClient);
    });

    test('get all species returns list of species', () async {
      // Arrange
      const name = 'Equus ferus caballus';
      const commonNameNL = 'Paard';
      const commonNameEN = 'Horse';
      final responseJson = [
        {
          "ID": "test",
          "name": name,
          "commonNameNL": commonNameNL,
          "commonNameEN": commonNameEN
        },
      ];

      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.get(
        'species/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await speciesApi.getAllSpecies();

      // Assert
      expect(result, isA<List<Species>>());
      expect(result[0].name, name);
      expect(result[0].commonName, commonNameNL);
    });

    test('get all species throws exception when api returns error', () async {
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

      when(mockApiClient.get(
        'species/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(() async => await speciesApi.getAllSpecies(),
          throwsA(isA<Exception>()));
    });
    test('getSpecies returns species', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const name = 'test';
      const commonNameNL = 'test';
      const commonNameEN = 'test';
      final responseJson = {
        "ID": id,
        "name": name,
        "commonNameNL": commonNameNL,
        "commonNameEN": commonNameEN
      };

      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.get(
        'species/$id/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await speciesApi.getSpecies(id);

      // Assert
      expect(result, isA<Species>());
      expect(result.id, id);
      expect(result.name, name);
      expect(result.commonName, commonNameNL);
    });

    test('getSpecies throws exception when api returns error', () async {
      // Arrange
      const id = 'd43efd6f-e8ad-4c8b-b37e-b72dd6263e3f';
      const responseJson = {
        "status": "404",
        "detail": "unauthorized",
      };

      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.unauthorized);

      when(mockApiClient.get(
        'species/$id/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(() async => await speciesApi.getSpecies(id),
          throwsA(isA<Exception>()));
    });
  });
}
