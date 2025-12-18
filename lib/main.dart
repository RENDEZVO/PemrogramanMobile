import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/screens/login_screen.dart';

// --- IMPORT FIREBASE (BARU) ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File ini dibuat otomatis oleh flutterfire configure
// ------------------------------

// Import untuk dotenv (API Key)
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import untuk sqflite FFI (Database Desktop/Windows)
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

Future<void> main() async {
  // 1. Pastikan binding siap (Wajib paling atas)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. --- INISIALISASI FIREBASE (BARU) ---
  // Ini menyalakan koneksi ke server Google
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ---------------------------------------
  
  // 3. Muat file .env untuk API Key (Jika ada)
  // Kita bungkus try-catch jaga-jaga kalau file .env belum dibuat biar gak crash
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Warning: File .env tidak ditemukan, pastikan Anda membuatnya jika butuh API Key.");
  }

  // 4. Inisialisasi database factory untuk desktop (Windows/Linux/MacOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // 5. Jalankan aplikasi
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key}); // Gunakan super.key syntax terbaru

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Travelogue',
      themeMode: themeMode,
      
      // Tema Terang (Light Mode)
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Terapkan Google Fonts Poppins ke seluruh teks
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        useMaterial3: true,
      ),
      
      // Tema Gelap (Dark Mode)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Terapkan Google Fonts Poppins ke tema gelap juga
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      
      home: const LoginScreen(), // Dimulai dari LoginScreen
      debugShowCheckedModeBanner: false,
    );
  }
}