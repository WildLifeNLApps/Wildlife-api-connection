import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/models/species.dart';

class SpeciesApi {
  final ApiClient client;

  SpeciesApi(this.client);

  Future<List<Species>> getAllSpecies() async {
    http.Response response = await client.get(
      'species/',
      authenticated: true,
    );

    List<dynamic>? json;

    if (response.statusCode == HttpStatus.ok) {
      json = jsonDecode(response.body);
      List<Species> species =
          (json as List).map((e) => Species.fromJson(e)).toList();
      return species;
    } else {
      throw Exception(json ?? "Failed to get all species");
    }
  }
}
