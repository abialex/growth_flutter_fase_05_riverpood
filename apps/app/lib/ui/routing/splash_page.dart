import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:router_core/router_core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    NavigationUtils.navigateSafely('login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppLoader()),
    );
  }
}
