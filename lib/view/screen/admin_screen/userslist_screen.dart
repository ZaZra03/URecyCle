import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../provider/admin_provider.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final users = adminProvider.users;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Allow vertical scrolling
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Allow horizontal scrolling
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('First Name'),
              ),
              DataColumn(
                label: Text('Last Name'),
              ),
              DataColumn(
                label: Text('Email'),
              ),
              DataColumn(
                label: Text('Student Number'),
              ),
              DataColumn(
                label: Text('College'),
              ),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(user.firstName)),
                  DataCell(Text(user.lastName ?? 'N/A')),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.studentNumber)),
                  DataCell(Text(user.college ?? 'N/A')), // Show 'N/A' if college is null
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
