import 'package:flutter/material.dart';

import '../../../core/widgets/base_screen.dart';
class SalesListController extends StatelessWidget {
  const SalesListController({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Sales',
      body: Center(
        child: Text('Sales Page'),
      ),
    );
  }
}
