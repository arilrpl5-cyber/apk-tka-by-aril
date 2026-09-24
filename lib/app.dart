import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/bank_soal_provider.dart';
import 'shell/main_shell.dart';

/// Root MaterialApp dengan Provider setup.
class TkaApp extends StatelessWidget {
  const TkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => BankSoalProvider()),
      ],
      child: MaterialApp(
        title: 'TKA Test',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainShell(),
      ),
    );
  }
}
