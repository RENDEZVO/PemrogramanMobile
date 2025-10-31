import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/screens/login_screen.dart';

// Import untuk dotenv (API Key)
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import untuk sqflite FFI (Database Desktop)
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

Future<void> main() async {
  // Pastikan binding siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // Muat file .env untuk API Key
  await dotenv.load(fileName: ".env");

  // Inisialisasi database factory untuk desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Jalankan aplikasi
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Travelogue',
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const LoginScreen(), // Dimulai dari LoginScreen
      debugShowCheckedModeBanner: false,
    );
  }
}