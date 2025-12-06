import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login.dart';
import '../models/registration.dart';

class AuthService {
  // Picks base URL depending on platform so web uses localhost
  static String get baseUrl {
    if (kIsWeb) {
      // Try localhost first for web (avoids IPv6 vs IPv4 CORS issues)
      return 'http://localhost:8080';
    }
    // Mobile (emulator/device) can use local IP on the LAN
    return 'http://192.168.1.3:8080';
  }

  // Candidate bases for automatic fallback (attempted in order)
  static List<String> get _candidates {
    if (kIsWeb) {
      return [
        'http://localhost:8080',
        'http://[::1]:8080',
        'http://127.0.0.1:8080',
      ];
    }

    // Mobile / emulator candidates
    return [
      'http://192.168.1.3:8080',
      'http://10.0.2.2:8080', // Android emulator
      'http://127.0.0.1:8080',
    ];
  }

  String? _cachedBase;

  /// Try candidates in order and return the first base URL that responds.
  /// Caches the result for subsequent calls.
  Future<String> getEffectiveBase({Duration timeout = const Duration(seconds: 3)}) async {
    if (_cachedBase != null) return _cachedBase!;

    for (final base in _candidates) {
      final url = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
      try {
        print('AuthService: probing $url');
        final resp = await http.get(Uri.parse(url)).timeout(timeout);
        print('AuthService: probe $url -> ${resp.statusCode}');
        // consider any response as success (200..599)
        _cachedBase = url;
        return _cachedBase!;
      } catch (e) {
        print('AuthService: probe failed for $url -> $e');
      }
    }

    // Fallback to the default baseUrl
    _cachedBase = baseUrl;
    return _cachedBase!;
  }

  Future<RegistrationResponse> register(Registration registration) async {
    final response = await _postWithFallback(
      path: '/registrasi',
      body: jsonEncode(registration.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final regResponse = RegistrationResponse.fromJson(data);

      if (regResponse.status == 'success' && regResponse.data != null) {
        await _saveToken(regResponse.data!.token);
      }

      return regResponse;
    }

    throw Exception('Failed to register: ${response.statusCode}');
  }

  Future<LoginResponse> login(Login login) async {
    final response = await _postWithFallback(
      path: '/login',
      body: jsonEncode(login.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.status == 'success' && loginResponse.data != null) {
        await _saveToken(loginResponse.data!.token);
      }

      return loginResponse;
    }

    throw Exception('Failed to login: ${response.statusCode}');
  }

  // Helper to try multiple base URLs until one responds.
  Future<http.Response> _postWithFallback({required String path, required String body}) async {
    List<String> tried = [];
    for (final base in _candidates) {
      final url = base.endsWith('/') ? '${base.substring(0, base.length - 1)}$path' : '$base$path';
      tried.add(url);
      try {
        // Short log so dev can see which URL is being tried
        print('AuthService: trying $url');

        final resp = await http
            .post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: body)
            .timeout(const Duration(seconds: 5));

        // Log the successful connection (status may still be error code)
        print('AuthService: connected to $url (status ${resp.statusCode})');

        // Return the first response we get (even if it's an error status code)
        return resp;
      } catch (e) {
        // Log the failure and try next candidate
        print('AuthService: failed to connect to $url -> $e');
      }
    }

    print('AuthService: all candidates failed. Tried: ${tried.join(', ')}');
    throw Exception('Failed to connect to API. Tried: ${tried.join(', ')}');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}