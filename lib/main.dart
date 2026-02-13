import 'package:flutter/material.dart';
import 'core/ui/themes/app_theme.dart';

void main() {
  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Vibe',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
