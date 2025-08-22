// lib/providers/company_provider.dart
import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/api_service.dart';

class CompanyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
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
      _companies = await _apiService.getCompanies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}