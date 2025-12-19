Travelogue: Aplikasi Booking Wisata Internasional ✈️🌍
Travelogue adalah aplikasi mobile cross-platform (Android/iOS) berbasis Flutter yang dirancang sebagai solusi end-to-end bagi wisatawan. Aplikasi ini mengintegrasikan data destinasi real-time, penyimpanan lokal (offline first), dan sistem manajemen pemesanan tiket berbasis cloud.

✨ Fitur Utama & Pencapaian Teknis
Aplikasi ini dibangun dengan arsitektur modern yang memisahkan Logic, UI, dan Data Service.

1. Integrasi Data & API (Live Data) 🌐
REST Countries API Consumption: Mengambil data ratusan negara (Nama, Ibu Kota, Bendera, Region) secara live menggunakan package http.

Asynchronous Handling: Implementasi FutureProvider (Riverpod) untuk menangani status loading, error, dan data ready.

Smart Search: Fitur pencarian negara yang responsif.

2. Hybrid Database System (SQL + NoSQL) 💾
Aplikasi ini menerapkan dua jenis database untuk kebutuhan berbeda:

Local Database (SQLite): Digunakan untuk fitur Favorit. Memungkinkan user menyimpan destinasi impian dan mengaksesnya tanpa koneksi internet (offline mode).

Cloud Database (Firestore): Digunakan untuk Transaction History. Data pemesanan tiket disimpan di server Google yang aman dan real-time.

3. Booking System & E-Ticket 🎫
Checkout Logic: Form pemesanan tiket dengan kalkulasi harga otomatis berdasarkan jumlah tiket.

QR Code Generator: Implementasi library qr_flutter untuk menghasilkan E-Ticket dengan QR Code unik berdasarkan Booking ID.

Real-time History: Riwayat pesanan menggunakan StreamBuilder yang otomatis memperbarui tampilan jika ada perubahan data di server.

4. User Authentication & Profile 🔐
Firebase Auth: Sistem Login, Register, dan Logout yang aman.

User Session: Menampilkan nama dan email pengguna yang sedang login secara dinamis.

Dark/Light Mode: Preferensi tema yang disimpan persisten menggunakan SharedPreferences.

Kategori,Teknologi/Library,Kegunaan
Framework,Flutter (Dart),UI & Logic Development
State Mgmt,Riverpod,Manajemen state aplikasi yang reaktif
Auth,Firebase Auth,Autentikasi pengguna
Backend DB,Cloud Firestore,Menyimpan data transaksi/booking
Local DB,SQLite (sqflite),Menyimpan data favorit di HP
Network,Http,Request ke REST API
Utility,QR Flutter,Generate QR Code tiket
Storage,Shared Preferences,Menyimpan setting Tema (Dark/Light)

Fitur Fitur
Home & API,Checkout & Booking,History & QR Code,Favorit (SQLite)

📂 Struktur Folder (MVC Pattern)
lib/models/: Blueprint data (JSON parsing & Database model).

lib/providers/: Logika bisnis dan state management (Riverpod).

lib/services/ & lib/helpers/: Komunikasi ke API dan Database SQLite.

lib/screens/: Tampilan halaman (UI).

lib/widgets/: Komponen UI yang dapat digunakan kembali.

