import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sales',
          builder: (context, state) => const SalesPage(),
        ),
        GoRoute(
          path: 'inventory',
          builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: 'reports',
          builder: (context, state) => const ReportsPage(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);

// Placeholder pages
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Home')));
}

class SalesPage extends StatelessWidget {
  const SalesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Sales')));
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Inventory')));
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Reports')));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')));
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Login')));
}

import 'package:flutter/material.dart';
