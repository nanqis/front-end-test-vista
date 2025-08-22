// lib/screens/create_service_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/company.dart';
import '../providers/company_provider.dart';
import '../services/api_service.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  Company? _selectedCompany;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedCompany != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _apiService.createService(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          companyId: _selectedCompany!.id,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service created successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Price is required';
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Price must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<CompanyProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (provider.companies.isEmpty) {
                    return const Text('No companies to select from.');
                  }
                  return DropdownButtonFormField<Company>(
                    decoration: const InputDecoration(labelText: 'Select Company'),
                    // FIX: Replaced 'value' with 'initialValue' to fix the deprecation warning
                    initialValue: _selectedCompany,
                    items: provider.companies.map((company) {
                      return DropdownMenuItem<Company>(
                        value: company,
                        child: Text(company.name),
                      );
                    }).toList(),
                    onChanged: (Company? newValue) {
                      setState(() {
                        _selectedCompany = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Company is required' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Create Service'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}