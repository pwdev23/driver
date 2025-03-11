import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    _auth();
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: Center(child: CircularProgressIndicator.adaptive()));
  }

  Future<void> _auth() async {
    final nav = Navigator.of(context);
    Future.delayed(const Duration(seconds: 3), () {
      nav.pushReplacementNamed('/driver-on-board');
    });
  }
}
