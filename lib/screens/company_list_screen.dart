// lib/screens/company_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/company_provider.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch data immediately after the first frame is rendered
      Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width for a simple responsive layout
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies & Services'),
        actions: [
          // Button to navigate to the Create Company screen
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () => Navigator.of(context).pushNamed('/create-company').then((_) {
              // Refresh the list after returning from the new screen
              Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
            }),
          ),
          // Button to navigate to the Create Service screen
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/create-service').then((_) {
              // Refresh the list after returning from the new screen
              Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
            }),
          ),
        ],
      ),
      body: Consumer<CompanyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.companies.isEmpty) {
            return const Center(child: Text('No companies found.'));
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchCompanies(),
            child: ListView.builder(
              itemCount: provider.companies.length,
              itemBuilder: (context, index) {
                final company = provider.companies[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: isTablet ? 64.0 : 8.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text('Reg No: ${company.registrationNumber}'),
                        if (company.services.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Services:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...company.services.map((service) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text('${service.name} - \$${service.price}'),
                          )),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}