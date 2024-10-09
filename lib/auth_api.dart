import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wildlife_api_connection/api_client.dart';

class AuthApi {
  final ApiClient client;

  AuthApi(this.client);

  Future<Map<String, dynamic>> login(
      String displayNameApp, String displayNameUser, String email) async {
    http.Response response = await client.post(
      'auth/',
      {
        "displayNameApp": displayNameApp,
        "displayNameUser": displayNameUser,
        "email": email
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

  Future<Map<String, dynamic>> authenticate(String email, String code) async {
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
      return json!;
    } else {
      throw Exception(json!["detail"]);
    }
  }
}
