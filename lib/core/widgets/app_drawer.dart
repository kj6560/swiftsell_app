import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/auth/bloc/auth_bloc.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('App Drawer', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            title: Text('Products'),
            onTap: () => Navigator.pushReplacementNamed(context, '/list_product'),
          ),
          ListTile(
            title: Text('Inventory'),
            onTap: () => Navigator.pushReplacementNamed(context, '/list_inventory'),
          ),
          ListTile(
            title: Text('Orders'),
            onTap: () => Navigator.pushReplacementNamed(context, '/list_sales'),
          ),
          ListTile(
            title: Text('Customers'),
            onTap: () => Navigator.pushReplacementNamed(context, '/list_customers'),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () => context.read<AuthBloc>().add(LogoutEvent()),
          ),
        ],
      ),
    );
  }
}
