import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/providers/app_providers.dart'; // <-- Pastikan baris ini ada

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
    final currentThemeMode = ref.read(themeModeProvider);
    _selectedTheme = currentThemeMode == ThemeMode.dark ? 'Dark' : 'Light';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AlertDialog(
        content: SizedBox(
          height: 120,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Menyimpan...'),
              ],
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      title: const Text('Profil & Preferensi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/borobudur.jpg'),
          ),
          const SizedBox(height: 8),
          const Text('Fadhil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          const Text('Pilih Tema Aplikasi', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('Light Mode'),
            value: 'Light',
            groupValue: _selectedTheme,
            onChanged: (value) => setState(() => _selectedTheme = value!),
          ),
          RadioListTile<String>(
            title: const Text('Dark Mode'),
            value: 'Dark',
            groupValue: _selectedTheme,
            onChanged: (value) => setState(() => _selectedTheme = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            setState(() => _isLoading = true);
            
            Future.delayed(const Duration(seconds: 2), () {
              final newTheme = _selectedTheme == 'Dark' ? ThemeMode.dark : ThemeMode.light;
              ref.read(themeModeProvider.notifier).state = newTheme;
              
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tema diubah menjadi $_selectedTheme')),
                );
              }
            });
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
