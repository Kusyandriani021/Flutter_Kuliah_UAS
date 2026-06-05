# TODO - Pengajuan Seminar: Simpan & Pindah Halaman

- [ ] Update `lib/views/add_todo_page.dart`:
  - [ ] Jadikan penyimpanan bersifat async: setelah `addPengajuan`, `await` dialog ringkasan.
  - [ ] Setelah dialog ditutup, navigasi ke halaman daftar (`Navigator.pushReplacementNamed(context, '/')`).
- [ ] Jalankan `flutter test` dan/atau `flutter run` untuk memverifikasi alur: Simpan -> dialog -> pindah ke daftar -> item baru muncul.
