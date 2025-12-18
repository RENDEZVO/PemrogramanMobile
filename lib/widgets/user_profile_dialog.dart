import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:travelogue_app/providers/app_providers.dart';
import 'package:travelogue_app/screens/login_screen.dart'; // Import LoginScreen buat Logout

class UserProfileDialog extends ConsumerStatefulWidget {
  const UserProfileDialog({super.key});

  @override
  ConsumerState<UserProfileDialog> createState() => _UserProfileDialogState();
}

class _UserProfileDialogState extends ConsumerState<UserProfileDialog> {
  late String _selectedTheme;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Baca tema saat ini dari provider untuk set radio button awal
    final currentThemeMode = ref.read(themeModeProvider);
    _selectedTheme = currentThemeMode == ThemeMode.dark ? 'Dark' : 'Light';
  }

  // Helper untuk mengambil inisial nama (Misal "Affan" -> "A")
  String getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    return name[0].toUpperCase();
  }

  // Fungsi Logout
  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    
    // Proses Logout Firebase
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      // Tutup Dialog & Pindah ke Login Screen (Hapus history biar gak bisa back)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, 
      );
    }
  }

  // Fungsi Simpan Tema
  Future<void> _handleSaveTheme() async {
    setState(() => _isLoading = true);

    // Simulasi loading sebentar biar kerasa "menyimpan"
    Future.delayed(const Duration(seconds: 1), () async {
      final newThemeMode = _selectedTheme == 'Dark' ? ThemeMode.dark : ThemeMode.light;

      // Panggil notifier untuk ubah tema
      await ref.read(themeModeProvider.notifier).setThemeMode(newThemeMode);

      if (mounted) {
        Navigator.of(context).pop(); // Tutup dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tema diubah menjadi $_selectedTheme'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login dari Firebase
    final User? user = FirebaseAuth.instance.currentUser;

    // Tampilan Loading (Spinner)
    if (_isLoading) {
      return const AlertDialog(
        backgroundColor: Colors.black87, // Background agak gelap
        elevation: 0,
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.purpleAccent),
              SizedBox(height: 16),
              Text('Memproses...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    // Tampilan Dialog Utama
    return AlertDialog(
      title: const Text('Profil & Preferensi', textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- 1. BAGIAN PROFIL USER (FIREBASE) ---
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purpleAccent,
              child: Text(
                getInitials(user?.displayName),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.displayName ?? "User Tanpa Nama",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "Email tidak tersedia",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const Divider(height: 32, thickness: 1),

            // --- 2. BAGIAN GANTI TEMA (RIVERPOD) ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Pilih Tema Aplikasi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            RadioListTile<String>(
              title: const Text('Light Mode'),
              value: 'Light',
              groupValue: _selectedTheme,
              activeColor: Colors.purpleAccent,
              onChanged: (value) => setState(() => _selectedTheme = value!),
            ),
            RadioListTile<String>(
              title: const Text('Dark Mode'),
              value: 'Dark',
              groupValue: _selectedTheme,
              activeColor: Colors.purpleAccent,
              onChanged: (value) => setState(() => _selectedTheme = value!),
            ),

            const SizedBox(height: 10),

            // --- 3. TOMBOL LOGOUT ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        FilledButton(
          onPressed: _handleSaveTheme, // Panggil fungsi simpan tema
          style: FilledButton.styleFrom(backgroundColor: Colors.purpleAccent),
          child: const Text('Simpan Tema'),
        ),
      ],
    );
  }
}