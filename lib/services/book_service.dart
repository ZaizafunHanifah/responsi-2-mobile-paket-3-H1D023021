import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'auth_service.dart';

class BookService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<BookResponse> getBooks() async {
    // Use absolute URL with the resolved base (for native builds)
    // For web, the flutter dev server should proxy or we use direct IP
    final base = await _authService.getEffectiveBase();
    final url = '$base/buku';
    print('BookService.getBooks requesting: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    ).timeout(const Duration(seconds: 10));

    print('BookService.getBooks response status: ${response.statusCode}');
    print('BookService.getBooks response headers: ${response.headers}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookResponse.fromJson(data);
    } else {
      print('BookService.getBooks failed with status ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to load books (${response.statusCode})');
    }
  }

  Future<BookResponse> getBook(int id) async {
    final base = await _authService.getEffectiveBase();
    final response = await http.get(
      Uri.parse('$base/buku/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookResponse.fromJson(data);
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<BookResponse> createBook(Book book) async {
    final base = await _authService.getEffectiveBase();
    final response = await http.post(
      Uri.parse('$base/buku'),
      headers: await _getHeaders(),
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 201) {
      try {
        final data = jsonDecode(response.body);
        return BookResponse.fromJson(data);
      } catch (e) {
        return BookResponse(status: 'success', message: 'Book created successfully');
      }
    } else {
      throw Exception('Failed to create book');
    }
  }

  Future<BookResponse> updateBook(int id, Book book) async {
    final base = await _authService.getEffectiveBase();
    final response = await http.put(
      Uri.parse('$base/buku/$id'),
      headers: await _getHeaders(),
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return BookResponse.fromJson(data);
      } catch (e) {
        return BookResponse(status: 'success', message: 'Book updated successfully');
      }
    } else {
      throw Exception('Failed to update book');
    }
  }

  Future<BookResponse> deleteBook(int id) async {
    final base = await _authService.getEffectiveBase();
    final response = await http.delete(
      Uri.parse('$base/buku/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookResponse.fromJson(data);
    } else {
      throw Exception('Failed to delete book');
    }
  }
}