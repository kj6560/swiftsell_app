import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/auth/bloc/auth_bloc.dart';
import '../../modules/auth/models/User.dart';
import '../config/config.dart';
import '../config/endpoints.dart';
import '../local/hive_constants.dart';
import '../routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.tealAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text("SwiftSwll"),
              accountEmail: Text("hello@swiftswll.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.indigo),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            _buildDrawerItem(
              icon: Icons.shopping_bag,
              text: 'Products',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list_product');
              },
            ),
            _buildDrawerItem(
              icon: Icons.inventory,
              text: 'Inventory',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list_inventory');
              },
            ),
            _buildDrawerItem(
              icon: Icons.inventory,
              text: 'Schemes',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list_schemes');
              },
            ),
            _buildDrawerItem(
              icon: Icons.receipt_long,
              text: 'Orders',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list_sales');
              },
            ),
            _buildDrawerItem(
              icon: Icons.people,
              text: 'Customers',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list_customers');
              },
            ),
            _buildDrawerItem(
              icon: Icons.people,
              text: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () async {
                bool loggedout = await logout();
                if (loggedout) {
                  BlocProvider.of<AuthBloc>(context).add(LoginReset());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.entry,
                        (route) => false,
                  );
                }
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
  Future<bool> logout() async {
    try {
      String userJson = authBox.get(HiveKeys.userBox);
      String token = authBox.get(HiveKeys.accessToken);
      User _user = User.fromJson(jsonDecode(userJson));

      var body = {'user_id': _user.id};
      Dio dio = Dio();

      Response response = await dio.get(
        EndPoints.logoutUrl,
        queryParameters: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        await authBox.clear();
        return response.data['success'] == true;
      }

      return false;
    } catch (e, stacktrace) {
      print('Logout failed: $e');
      print(stacktrace);
      return false;
    }
  }
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      hoverColor: Colors.grey[200],
      onTap: onTap,
    );
  }
}
