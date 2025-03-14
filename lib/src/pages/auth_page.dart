import 'package:flutter/material.dart';

import '../utils/geolocator.dart';
import 'driver_on_board_page.dart' show DriverOnBoardArgs;

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
    await determinePosition().then(
      (p) => nav.pushReplacementNamed(
        '/driver-on-board',
        arguments: DriverOnBoardArgs(p),
      ),
    );
  }
}
