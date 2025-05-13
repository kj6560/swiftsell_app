
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';
import '../bloc/home_bloc.dart';
import 'home.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => HomeControllerState();
}

class HomeControllerState extends State<HomeController>
    with WidgetsBindingObserver {
  String name = "";
  String email = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initAuthCred();
    BlocProvider.of<HomeBloc>(context).add(HomeLoad());
  }

  void initAuthCred() async {
    String userJson = authBox.get(HiveKeys.userBox);
    User user = User.fromJson(jsonDecode(userJson));
    setState(() {
      name = user.name;
      email = user.email;
    });
  }

  @override
  Widget build(BuildContext context) => HomePage(this);
}
