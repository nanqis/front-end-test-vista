import 'package:flutter/material.dart';
import '../models/service.dart';
import 'service_card.dart';

class CompanyCard extends StatelessWidget {
  final dynamic company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Registration: ${company.registrationNumber}'),
            const SizedBox(height: 12),
            const Text(
              'Services:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (company.services.isEmpty || company.services == null)
              const Text('No services available')
            else
              Column(
                children: (company.services as List<dynamic>)
                    .map((service) => ServiceCard(service: Service.fromJson(service)))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}