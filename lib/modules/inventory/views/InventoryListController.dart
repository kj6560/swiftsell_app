import 'package:flutter/material.dart';

import '../../../core/widgets/base_screen.dart';
class InventoryListController extends StatelessWidget {
  const InventoryListController({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Inventory',
      body: Center(
        child: Text('Inventory Page'),
      ),
    );
  }
}
