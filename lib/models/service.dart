// lib/models/service.dart
class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String companyId;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.companyId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      companyId: json['companyId'],
    );
  }
}