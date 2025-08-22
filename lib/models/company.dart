// lib/models/company.dart
import 'service.dart';

class Company {
  final String id;
  final String name;
  final String registrationNumber;
  final List<Service> services;

  Company({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.services,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    var servicesList = json['services'] as List;
    List<Service> services = servicesList.map((i) => Service.fromJson(i)).toList();
    return Company(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registrationNumber'],
      services: services,
    );
  }
}