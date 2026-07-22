import 'package:flutter/material.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({Key? key}) : super(key: key);

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'username': 'admin',
      'name': 'Admin User',
      'role': 'admin',
      'branch': 'Main Branch',
      'is_active': true,
      'is_fingerprint_enabled': true,
    },
    {
      'id': 2,
      'username': 'cashier1',
      'name': 'Ahmed Khalil',
      'role': 'cashier',
      'branch': 'Main Branch',
      'is_active': true,
      'is_fingerprint_enabled': false,
    },
  ];

  String _selectedRole = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create user screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All Users'),
                      _buildFilterChip('admin', 'Admin'),
                      _buildFilterChip('manager', 'Manager'),
                      _buildFilterChip('cashier', 'Cashier'),
                      _buildFilterChip('supervisor', 'Supervisor'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Users List
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: _selectedRole == value,
        onSelected: (selected) {
          setState(() => _selectedRole = value);
        },
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[700],
          child: Text(user['name'][0]),
        ),
        title: Text(user['name']),
        subtitle: Text('${user['role']} • ${user['branch']}'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'disable',
              child: Text('Disable'),
            ),
            const PopupMenuItem(
              value: 'lock',
              child: Text('Lock Account'),
            ),
            const PopupMenuItem(
              value: 'activity',
              child: Text('View Activity'),
            ),
          ],
          onSelected: (value) {
            // TODO: Implement actions
          },
        ),
        tileColor:
            user['is_active'] ? Colors.transparent : Colors.grey[200],
      ),
    );
  }
}
