import 'package:flutter/material.dart';

import 'pages/pages.dart';

class _NoRoute extends StatelessWidget {
  const _NoRoute({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text.rich(
          TextSpan(
            text: 'No route defined for ',
            children: [
              TextSpan(text: routeName, style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case '/driver-on-board':
      final args = settings.arguments as DriverOnBoardArgs;
      return MaterialPageRoute(
        builder: (_) => DriverOnBoardPage(position: args.position),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => _NoRoute(routeName: settings.name!),
      );
  }
}
