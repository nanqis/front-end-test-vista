import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_end_test_vista/providers/company_provider.dart';
import 'package:front_end_test_vista/screens/company_list_screen.dart';
import 'package:front_end_test_vista/screens/create_company_screen.dart';
import 'package:front_end_test_vista/screens/create_service_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyProvider(),
      child: MaterialApp(
        title: 'Vista Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const CompanyListScreen(),
          '/create-company': (context) => const CreateCompanyScreen(),
          '/create-service': (context) => const CreateServiceScreen(),
        },
      ),
    );
  }
}