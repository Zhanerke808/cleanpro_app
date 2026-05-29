// screens/home_router.dart
import 'package:flutter/material.dart';
import 'client_home.dart';
import 'cleaner_home.dart';
import 'admin_home.dart';

class HomeRouter extends StatelessWidget {
  final String role;
  const HomeRouter({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'admin':
        return const AdminHomeScreen();
      case 'cleaner':
        return const CleanerHomeScreen();
      default:
        return const ClientHomeScreen();
    }
  }
}