import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/auth/bloc/auth_bloc.dart';

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
            Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(LogoutEvent());
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
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
