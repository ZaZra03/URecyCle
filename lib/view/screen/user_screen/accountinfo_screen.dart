import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../provider/user_provider.dart';
import '../../../provider/admin_provider.dart';

class AccountInfo extends StatelessWidget {
  final String role;

  const AccountInfo({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Use the correct provider based on the role
    final userProvider = role == 'student' ? Provider.of<UserProvider>(context) : null;
    final adminProvider = role == 'admin' ? Provider.of<AdminProvider>(context) : null;

    final user = role == 'admin' ? adminProvider?.user : userProvider?.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile avatar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Constants.primaryColor.withOpacity(0.5),
                      width: 5.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Text(
                      '${user.firstName[0].toUpperCase()}${user.lastName?.isNotEmpty == true ? user.lastName![0].toUpperCase() : ''}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Common user information
              _buildInfoRow(
                context,
                label: 'Name',
                value: '${user.firstName} ${user.lastName ?? ''}',
              ),
              const Divider(),
              _buildInfoRow(
                context,
                label: 'Email',
                value: user.email,
              ),
              const Divider(),

              // Admin-specific fields
              if (role == 'admin') ...[
                _buildInfoRow(
                  context,
                  label: 'Admin ID',
                  value: 'N/A',
                ),
              ],

              // Student-specific fields
              if (role == 'student') ...[
                _buildInfoRow(
                  context,
                  label: 'Student Number',
                  value: user.studentNumber,
                ),
                if (user.college != null) ...[
                  const Divider(),
                  _buildInfoRow(
                    context,
                    label: 'College',
                    value: user.college!,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
