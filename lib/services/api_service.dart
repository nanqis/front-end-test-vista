// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/company.dart';
import '../models/service.dart';

const String _baseUrl = 'http://localhost:3000';

class ApiService {
  // CORRECT: Instance methods
  Future<List<Company>> getCompanies() async {
    final response = await http.get(Uri.parse('$_baseUrl/companies'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<void> createCompany(String name, String registrationNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'registrationNumber': registrationNumber,
      }),
    );

    if (response.statusCode != 201) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to create company');
    }
  }

  Future<void> createService({
    required String name,
    required String description,
    required double price,
    required String companyId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/services'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'description': description,
        'price': price,
        'companyId': companyId,
      }),
    );

    if (response.statusCode != 201) {
      final errorData = json.decode(response.body);
      if (errorData['errors'] != null) {
        final errors = (errorData['errors'] as List)
            .map((e) => e['msg'].toString())
            .join('\n');
        throw Exception(errors);
      } else {
        throw Exception(errorData['error'] ?? 'Failed to create service');
      }
    }
  }
}