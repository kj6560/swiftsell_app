import 'package:flutter/material.dart';

import '../../../core/widgets/base_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Home',
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
