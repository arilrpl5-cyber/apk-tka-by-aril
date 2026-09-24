import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

/// Entry point aplikasi TKA Test.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar transparan agar header biru menyatu.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TkaApp());
}
