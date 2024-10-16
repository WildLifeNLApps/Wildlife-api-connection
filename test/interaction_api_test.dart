import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:wildlife_api_connection/interaction_api.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/location.dart';

import 'mocks/api_mocks.mocks.dart';

void main() {
  group('InteractionAPI', () {
    late MockApiClient mockApiClient;
    late InteractionApi interactionApi;

    const type = 1;
    const description = 'test';
    const speciesId = '2d22';
    const location = {"latitude": -90, "longitude": -180};

    var responseJson = {
      "ID": "2af0f623-7ef5-4bfc-8a61-900279f06fc8",
      "timestamp": "2024-10-16T08:29:36.381911Z",
      "description": description,
      "speciesID": "",
      "location": location,
      "species": {
        "ID": speciesId,
        "name": "Animal",
        "commonNameNL": "Dier",
        "commonNameEN": "Animal"
      },
      "user": {"ID": "111", "name": ""},
      "type": {
        "ID": 1,
        "nameNL": "Waarneming",
        "nameEN": "Sighting",
        "descriptionNL": "U hebt een levend wild dier gezien.",
        "descriptionEN": "You have seen living wild animal"
      }
    };

    setUp(() {
      mockApiClient = MockApiClient();
      interactionApi = InteractionApi(mockApiClient);
    });

    test('interaction create returns interaction when given token', () async {
      // Arrange
      const type = 1;
      const description = 'test';
      const speciesId = '2d22';
      const location = {"latitude": -90, "longitude": -180};

      final response = http.Response(jsonEncode(responseJson), HttpStatus.ok);

      when(mockApiClient.post(
        'interaction/',
        {
          "description": description,
          "location": location,
          "species": speciesId,
          "type": type,
        },
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await interactionApi.create(
        description,
        Location.fromJson(location),
        speciesId,
        type,
      );

      // Assert
      expect(result, isA<Interaction>());
      expect(result.description, description);
      expect(result.location.latitude, location['latitude']);
      expect(result.location.longitude, location['longitude']);
      expect(result.species.id, speciesId);
      expect(result.type.id, type);
    });

    test('interaction create throws exception when given invalid speciesId',
        () async {
      // Arrange
      const type = 1;
      const description = 'test';
      const speciesId = '2d22';
      const location = {"latitude": -90, "longitude": -180};

      var responseJson = {
        "title": "Bad Request",
        "status": 400,
        "detail": "(speciesID)=(2d22) does not exist."
      };
      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.badRequest);

      when(mockApiClient.post(
        'interaction/',
        {
          "description": description,
          "location": location,
          "species": speciesId,
          "type": type,
        },
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(
          interactionApi.create(
            description,
            Location.fromJson(location),
            speciesId,
            type,
          ),
          throwsA(isA<Exception>()));
    });

    test('get my interactions returns list of interactions', () async {
      // Arrange

      final response = http.Response(jsonEncode([responseJson]), HttpStatus.ok);

      when(mockApiClient.get(
        'interactions/me/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act
      final result = await interactionApi.getMyInteractions();

      // Assert
      expect(result, isA<List<Interaction>>());
      expect(result[0].description, description);
      expect(result[0].location.latitude, location['latitude']);
      expect(result[0].location.longitude, location['longitude']);
      expect(result[0].species.id, speciesId);
      expect(result[0].type.id, type);
    });

    test('interaction create throws exception when given invalid speciesId',
        () async {
      // Arrange
      var responseJson = {
        "title": "Unauthorized",
        "status": 403,
        "detail": "You do not have permission to perform this action."
      };
      final response =
          http.Response(jsonEncode(responseJson), HttpStatus.unauthorized);

      when(mockApiClient.get(
        'interactions/me/',
        authenticated: true,
      )).thenAnswer((_) async {
        return response;
      });

      // Act & Assert
      expect(interactionApi.getMyInteractions(), throwsA(isA<Exception>()));
    });
  });
}
