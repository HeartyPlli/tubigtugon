import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_strings.dart';
import '../core/app_theme.dart';
import '../screens/main_shell.dart';

class TubigTugonApp extends StatefulWidget {
  const TubigTugonApp({super.key});

  @override
  State<TubigTugonApp> createState() => _TubigTugonAppState();
}

class _TubigTugonAppState extends State<TubigTugonApp> {
  final AppController _controller = AppController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _controller,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return LanguageMarker(
            language: _controller.language,
            child: MaterialApp(
              title: 'TubigTugon',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              home: const MainShell(),
            ),
          );
        },
      ),
    );
  }
}
