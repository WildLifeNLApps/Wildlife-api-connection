import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/models/user.dart';

class ProfileApi {
  final ApiClient client;

  ProfileApi(this.client);

  Future<User> getMyProfile() async {
    http.Response response = await client.get(
      'profile/me/',
      authenticated: true,
    );

    Map<String, dynamic>? json;
    try {
      json = jsonDecode(response.body);
      debugPrint('Profile api: $json');
    } catch (_) {}

    if (response.statusCode == HttpStatus.ok) {
      User user = User.fromJson(json!);
      return user;
    } else {
      throw Exception(json ?? "Failed to get your profile");
    }
  }
}
