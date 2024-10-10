import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/models/user.dart';

class AuthApi {
  final ApiClient client;

  AuthApi(this.client);

  Future<Map<String, dynamic>> authenticate(
      String displayNameApp, String email) async {
    http.Response response = await client.post(
      'auth/',
      {
        "displayNameApp": displayNameApp,
        "email": email,
      },
      authenticated: false,
    );

    Map<String, dynamic>? json;
    try {
      json = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      debugPrint('Auth api: $json');
    } catch (_) {}

    if (response.statusCode == HttpStatus.ok) {
      return json ?? {};
    } else {
      throw Exception(json ?? "Failed to login");
    }
  }

  Future<User> authorize(String email, String code) async {
    http.Response response = await client.put(
      'auth/',
      {
        "code": code,
        "email": email,
      },
      authenticated: false,
    );

    Map<String, dynamic>? json;
    try {
      json = jsonDecode(response.body);
      debugPrint('V1 Auth api: $json');
    } catch (_) {}

    if (response.statusCode == HttpStatus.ok) {
      User user = User.fromJson(json!);
      return user;
    } else {
      throw Exception(json!["detail"]);
    }
  }
}
