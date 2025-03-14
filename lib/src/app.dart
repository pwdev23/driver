import 'package:flutter/material.dart';

import 'routes.dart';
import 'themes/themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
