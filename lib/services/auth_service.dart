import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAY9n5RLt9d25xZ_8i3oHEjUFL1wHJGsAU';
  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {'email': email, 'password': password, 'returnSecureToken': true};
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> dataDecoded = json.decode(resp.body);

    print(dataDecoded);

    if (dataDecoded.containsKey('idToken')) {
      dataDecoded['idToken'];
      return null;
    } else {
      return dataDecoded['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {'email': email, 'password': password, 'returnSecureToken': true};
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> dataDecoded = json.decode(resp.body);

    print(dataDecoded);

    if (dataDecoded.containsKey('idToken')) {
      dataDecoded['idToken'];
      await storage.write(key: 'token', value: dataDecoded['idToken']);
      return null;
    } else {
      return dataDecoded['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    print(await storage.read(key: 'token'));
    return await storage.read(key: 'token') ?? '';
  }
}
