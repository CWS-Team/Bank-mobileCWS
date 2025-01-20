<a href="https://idx.google.com/import?url=https://github.com/CWS-Team/Bank-mobileCWS">
  <img height="32" alt="Open in IDX" src="https://cdn.idx.dev/btn/open_dark_32.svg">
</a>
# myapp

Hai teman-teman! 🎉 Yuk kita pelajari cara meng-install aplikasi Flutter yang sudah kalian buat di Project IDX ke HP masing-masing. Ikuti langkah-langkah berikut, ya! 😊

Cara Install Aplikasi Flutter ke HP

1. Persiapkan Aplikasi di Project IDX

Pastikan aplikasi Flutter kalian sudah berjalan lancar di emulator atau preview Project IDX.

Lakukan build aplikasi untuk platform yang kalian gunakan:

Android: Jalankan perintah ini di terminal Project IDX:

flutter build apk --release

Hasilnya akan ada file APK di folder build/app/outputs/flutter-apk/.

iOS: Untuk pengguna iOS, sayangnya perlu menggunakan macOS untuk membuat file .ipa. Jika kalian menggunakan Android, langkah ini bisa dilewati. 😇

2. Unduh File APK

Buka folder hasil build APK di Project IDX.

Download file APK ke laptop atau komputer kalian.

3. Pindahkan APK ke HP

Sambungkan HP ke komputer menggunakan kabel USB.

Salin file APK ke folder mana saja di HP kalian.

4. Install APK di HP

Buka file manager di HP kalian.

Temukan file APK yang sudah disalin tadi.

Ketuk file APK untuk memulai proses instalasi.

Jika muncul notifikasi "Sumber tidak dikenal", izinkan instalasi dari sumber tersebut.

Tunggu hingga selesai, dan tadaaa! 🎉 Aplikasi kalian siap digunakan! 🥳

Cara Import File dari GitHub ke Project IDX

1. Clone Repository dari GitHub

Buka terminal di Project IDX.

Ketik perintah berikut untuk meng-clone repository:

git clone https://github.com/username/repository-name.git

Ganti username dan repository-name sesuai URL repository kalian.

2. Buka Proyek di Project IDX

Setelah proses cloning selesai, buka folder proyek hasil clone di file explorer Project IDX.

Pastikan semua file dan folder sudah sesuai.

3. Jalankan Aplikasi

Pastikan semua package terinstall dengan perintah:

flutter pub get

Jalankan aplikasi kalian di emulator atau preview dengan perintah:

flutter run

Tips Tambahan

Periksa Dependencies: Jika ada error saat membuka proyek, periksa file pubspec.yaml dan pastikan dependencies terinstall dengan benar.

Update GitHub: Jika ada perubahan di proyek, jangan lupa push kembali ke GitHub agar tim kalian bisa mengakses versi terbaru!

Itu dia tutorialnya, teman-teman! 🎈 Kalau ada yang bingung, jangan ragu untuk bertanya, ya. Selamat mencoba dan semoga berhasil! 🤩


