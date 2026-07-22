import 'package:flutter/material.dart';

class BranchesManagementScreen extends StatefulWidget {
  const BranchesManagementScreen({Key? key}) : super(key: key);

  @override
  State<BranchesManagementScreen> createState() =>
      _BranchesManagementScreenState();
}

class _BranchesManagementScreenState extends State<BranchesManagementScreen> {
  final List<Map<String, dynamic>> _branches = [
    {
      'id': 1,
      'name': 'Main Branch',
      'name_ar': 'الفرع الرئيسي',
      'code': 'BR001',
      'city': 'Riyadh',
      'phone': '+966-11-1234567',
      'manager': 'Ahmed Admin',
      'is_active': true,
      'users_count': 12,
    },
    {
      'id': 2,
      'name': 'Branch 2',
      'name_ar': 'الفرع الثاني',
      'code': 'BR002',
      'city': 'Jeddah',
      'phone': '+966-12-7654321',
      'manager': 'Mohammed Manager',
      'is_active': true,
      'users_count': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create branch screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _branches.length,
        itemBuilder: (context, index) {
          final branch = _branches[index];
          return _buildBranchCard(branch);
        },
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(
          Icons.store,
          color: branch['is_active'] ? Colors.green : Colors.grey,
        ),
        title: Text(branch['name']),
        subtitle: Text(branch['code']),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Arabic Name:', branch['name_ar']),
                _buildDetailRow('City:', branch['city']),
                _buildDetailRow('Phone:', branch['phone']),
                _buildDetailRow('Manager:', branch['manager']),
                _buildDetailRow('Active Users:', '${branch['users_count']}'),
                _buildDetailRow(
                  'Status:',
                  branch['is_active'] ? 'Active' : 'Inactive',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Edit branch
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Manage users
                      },
                      icon: const Icon(Icons.people),
                      label: const Text('Users'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Configure branch
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Config'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
