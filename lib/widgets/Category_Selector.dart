import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelogue_app/providers/app_providers.dart';

// 1. Diubah dari StatefulWidget menjadi ConsumerWidget
class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  // 2. Tambahkan WidgetRef ref di parameter build
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Hapus _selectedIndex dan setState. State sekarang dikelola Riverpod.
    final List<String> categories = ['Beach', 'Mountain', 'Culture', 'City'];
    // 4. Baca state kategori yang sedang dipilih dari provider
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          // 5. Logika untuk mengecek item terpilih diubah
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              // 6. Logika untuk mengubah state juga diubah
              // Kita menggunakan .read() di dalam onTap karena ini adalah aksi sekali jalan
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      // Gunakan isSelected untuk menentukan warna
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Gunakan isSelected untuk menampilkan garis bawah
                  isSelected
                      ? Container(
                          height: 3,
                          width: 25,
                          color: Colors.blue,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}