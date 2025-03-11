import 'package:flutter/material.dart';

import 'pages/pages.dart';

class _NoRoute extends StatelessWidget {
  const _NoRoute({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: Text('No route defined for $routeName')),
    );
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case '/driver-on-board':
      return MaterialPageRoute(builder: (_) => const DriverOnBoardPage());
    default:
      return MaterialPageRoute(
        builder: (_) => _NoRoute(routeName: settings.name!),
      );
  }
}
