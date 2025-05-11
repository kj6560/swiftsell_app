import 'package:flutter/material.dart';

import '../../../core/widgets/base_screen.dart';
class CustomersListController extends StatelessWidget {
  const CustomersListController({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Customers',
      body: Center(
        child: Text('Customers Page'),
      ),
    );
  }
}
