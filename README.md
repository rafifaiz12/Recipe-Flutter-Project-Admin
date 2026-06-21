# Admin SiResep

## Gambaran Umum

SiResep merupakan aplikasi mobile yang dikembangkan untuk membantu pengguna dalam menemukan, mengelola, dan merencanakan aktivitas memasak secara lebih mudah, praktis, dan terorganisir. Aplikasi ini hadir sebagai solusi digital bagi masyarakat yang sering mengalami kesulitan dalam mencari referensi masakan, menyusun menu harian, maupun mengelola kebutuhan bahan makanan.

Untuk mendukung pengelolaan data aplikasi, SiResep juga dilengkapi dengan dashboard admin berbasis web yang memungkinkan administrator mengelola data resep, kategori resep, pengguna, meal plan, serta memantau aktivitas pengguna melalui fitur analitik. Dengan kombinasi platform mobile dan web, SiResep tidak hanya memberikan kemudahan bagi pengguna akhir tetapi juga mempermudah pengelolaan sistem secara menyeluruh.

## Teknologi yang Digunakan

Pengembangan aplikasi **SiResep** memanfaatkan berbagai teknologi modern untuk mendukung kebutuhan aplikasi mobile, dashboard admin, serta integrasi backend berbasis cloud. Flutter digunakan sebagai framework utama untuk membangun aplikasi mobile Android dan dashboard admin berbasis web dengan satu basis kode yang sama. Bahasa pemrograman yang digunakan adalah Dart karena memiliki integrasi yang kuat dengan Flutter serta mendukung pengembangan antarmuka yang responsif dan efisien.

Untuk pengelolaan data, aplikasi menggunakan **Cloud Firestore** sebagai database NoSQL yang memungkinkan sinkronisasi data secara real-time antara dashboard admin dan aplikasi mobile. Sistem autentikasi pengguna diintegrasikan dengan **Firebase Authentication**, sehingga proses login dan registrasi dapat dilakukan dengan aman dan terpusat.

Dalam proses pengembangan, tim menggunakan **Git** dan **GitHub** sebagai sistem version control untuk mendukung kolaborasi, pelacakan perubahan kode, dan pengelolaan repositori proyek. Dari sisi antarmuka, aplikasi mengadopsi prinsip **Material Design** guna menghasilkan tampilan yang konsisten, modern, dan mudah digunakan. Pengembangan serta pengujian aplikasi dilakukan menggunakan **Visual Studio Code** dan **Android Studio** sebagai lingkungan pengembangan utama.

## Dokumentasi

### Autentikasi Admin
Fitur autentikasi admin digunakan untuk memastikan hanya administrator yang memiliki akses ke dashboard pengelolaan aplikasi. Admin dapat melakukan login menggunakan akun yang telah terdaftar.

<img width="467" height="400" alt="image8" src="https://github.com/user-attachments/assets/f7b09b34-299d-428e-aeaf-85f29ce8ad6c" />

### Manajemen Resep
Fitur manajemen resep memungkinkan administrator untuk menambah, mengubah, melihat, dan menghapus data resep yang tersedia pada aplikasi SiResep.

<img width="896" height="410" alt="image9" src="https://github.com/user-attachments/assets/ece34949-f471-420c-8f3e-474ee45be8f1" />

### Manajemen Rating & Review
Fitur ini memungkinkan admin untuk memantau dan mengelola rating serta ulasan yang diberikan pengguna terhadap resep. Admin dapat melakukan moderasi terhadap konten yang tidak sesuai.

<img width="951" height="418" alt="image14" src="https://github.com/user-attachments/assets/0bf2624c-8c25-41b0-bc44-7c39b7d4852b" />

### Manajemen Meal Plan
Fitur Manajemen Meal Plan digunakan oleh admin untuk mengelola template perencanaan menu yang dapat digunakan pengguna dalam menyusun jadwal makanan harian maupun mingguan.

<img width="995" height="445" alt="image16" src="https://github.com/user-attachments/assets/7514361c-e824-4a5a-9dc7-3a1af035c980" />

### Manajemen Pengguna
Fitur Manajemen Pengguna memungkinkan administrator untuk melihat data pengguna yang terdaftar, mengelola akun pengguna, serta melakukan pemantauan aktivitas pengguna pada aplikasi.

<img width="1026" height="473" alt="image22" src="https://github.com/user-attachments/assets/25230515-38b4-4e96-883d-d698e539961e" />

### Admin Dashboard Analytics
Dashboard Analytics menyajikan informasi statistik penggunaan aplikasi dalam bentuk visualisasi data. Admin dapat memantau jumlah pengguna, aktivitas pengguna, popularitas resep, serta informasi penting lainnya untuk mendukung pengambilan keputusan.

<img width="1022" height="464" alt="image24" src="https://github.com/user-attachments/assets/747303b4-8094-49a4-9856-c7c75bd57b89" />
<img width="1022" height="466" alt="image25" src="https://github.com/user-attachments/assets/6f776a54-ad7a-42c0-b63b-f4ebd8ad78d5" />
