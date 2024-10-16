import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/location.dart';

class InteractionApi {
  final ApiClient client;

  InteractionApi(this.client);

  Future<Interaction> create(String description, Location location,
      String speciesId, int typeId) async {
    http.Response response = await client.post(
      'interaction/',
      {
        "description": description,
        "location": location.toJson(),
        "species": speciesId,
        "type": typeId,
      },
      authenticated: true,
    );

    Map<String, dynamic>? json;
    try {
      json = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      debugPrint('Interaction api: $json');
    } catch (_) {}

    if (response.statusCode == HttpStatus.ok) {
      debugPrint('Interaction api: $json');
      Interaction interaction = Interaction.fromJson(json!);
      return interaction;
    } else {
      throw Exception(json ?? "Failed to create interaction");
    }
  }

  Future<List<Interaction>> getMyInteractions() async {
    http.Response response = await client.get(
      'interactions/me/',
      authenticated: true,
    );

    List<dynamic>? json;

    if (response.statusCode == HttpStatus.ok) {
      json = jsonDecode(response.body);
      List<Interaction> species =
          (json as List).map((e) => Interaction.fromJson(e)).toList();
      return species;
    } else {
      throw Exception(json ?? "Failed to get my interactions");
    }
  }
}
