// lib/providers/api_provider.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Import this for ChangeNotifier

import '../models/company.dart';
import '../models/service.dart';

const String _baseUrl = 'http://localhost:3000';

class ApiProvider with ChangeNotifier {
  // CORRECT: This class manages the state and calls the API service.
  final ApiService _apiService = ApiService(); // Create an instance of the ApiService

  List<Company> _companies = [];
  bool _isLoading = false;
  String? _error;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // CORRECT: Call the instance method on the _apiService object.
      _companies = await _apiService.getCompanies(); 
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCompany(String name, String registrationNumber) async {
    try {
      // CORRECT: Call the instance method on the _apiService object.
      // CORRECT: Await the void result without assigning it.
      await _apiService.createCompany(name, registrationNumber);
    } catch (e) {
      throw Exception(e.toString()); // Rethrow the exception for the UI to handle
    }
  }

  Future<void> createService({
    required String name,
    required String description,
    required double price,
    required String companyId,
  }) async {
    try {
      // CORRECT: Call the instance method on the _apiService object.
      // CORRECT: Use named parameters with the correct syntax.
      await _apiService.createService(
        name: name,
        description: description,
        price: price,
        companyId: companyId,
      );
    } catch (e) {
      throw Exception(e.toString()); // Rethrow the exception for the UI
    }
  }
}

// NOTE: You must also have a separate ApiService class like the one provided previously.
class ApiService {
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