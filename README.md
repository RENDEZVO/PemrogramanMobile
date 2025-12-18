Travelogue: Aplikasi Panduan Wisata Global 🌍
Aplikasi cross-platform yang dibangun dengan Flutter untuk menjelajahi destinasi dunia secara real-time, mengelola favorit, dan mempraktikkan arsitektur modern.

Fitur Utama & Pencapaian Teknis ✨
Proyek ini telah mengimplementasikan seluruh milestone pengembangan Flutter:

🌐 Data & API Integration
Akses Data Dinamis: Mengambil data negara (nama, ibu kota, dan bendera) dari REST Countries API menggunakan http dan FutureProvider.

Form & Pencarian: Implementasi Form & Validation (di halaman Login) dan fitur pencarian menggunakan TextField yang reaktif dengan state Riverpod.

🧠 Arsitektur & State Management
Inti Reaktif: Menggunakan Riverpod (StateNotifierProvider, AsyncValue) untuk manajemen state yang terpusat dan reaktif.

Penyimpanan Persisten:

Daftar Favorit disimpan ke SQLite (via sqflite).

Pengaturan Tema (Light/Dark Mode) disimpan ke SharedPreferences.

Model Data Aman: Memanfaatkan Null Safety dan factory fromJson yang aman untuk mengonversi data API.

🖼️ User Interface (UI)
Adaptif: Layout utama menggunakan ListView horizontal, dan hasil pencarian/favorit ditampilkan dalam GridView (SearchScreen, FavoriteScreen).

Navigasi: Menggunakan Navigator.push dan Navigator.pushReplacement untuk alur Login-Home yang aman.

Styling Dinamis: Implementasi tema terang dan gelap (ThemeData/darkTheme) yang dapat diubah dan disimpan pengguna.

Cara Menjalankan Proyek ⚙️
Pastikan Anda sudah menginstall Flutter, Android Studio/VS Code, dan memiliki Android Emulator atau perangkat fisik.
jalankan ini di terminal : git clone https://www.fda.gov/drugs/types-applications/abbreviated-new-drug-application-anda
cd travelogue_app

Install Dependencies:
flutter pub get


Jalankan Aplikasi: flutter run
Pastikan emulator/perangkat tersambung.



Jalankan:
