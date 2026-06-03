/// Centralized string constants for mobile_bisa
abstract class AppStrings {
  // ── App ──────────────────────────────────────────────────────────────────
  static const String appName = 'Mobile BISA';
  static const String appTagline = 'Bersama Inovasi Solusi Andal';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String login = 'Masuk';
  static const String logout = 'Keluar';
  static const String register = 'Daftar';
  static const String email = 'Email';
  static const String password = 'Kata Sandi';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String forgotPassword = 'Lupa Kata Sandi?';
  static const String dontHaveAccount = 'Belum punya akun?';
  static const String alreadyHaveAccount = 'Sudah punya akun?';
  static const String loginSuccess = 'Berhasil masuk';
  static const String loginFailed = 'Gagal masuk. Periksa kredensial Anda.';
  static const String logoutSuccess = 'Berhasil keluar';

  // ── Validation ───────────────────────────────────────────────────────────
  static const String fieldRequired = 'Field ini wajib diisi';
  static const String emailInvalid = 'Format email tidak valid';
  static const String passwordTooShort = 'Kata sandi minimal 6 karakter';
  static const String passwordNotMatch = 'Kata sandi tidak cocok';

  // ── Navigation ───────────────────────────────────────────────────────────
  static const String home = 'Beranda';
  static const String profile = 'Profil';
  static const String settings = 'Pengaturan';
  static const String notifications = 'Notifikasi';

  // ── Profile ──────────────────────────────────────────────────────────────
  static const String editProfile = 'Edit Profil';
  static const String fullName = 'Nama Lengkap';
  static const String phoneNumber = 'Nomor Telepon';
  static const String address = 'Alamat';
  static const String profileUpdated = 'Profil berhasil diperbarui';

  // ── Errors ───────────────────────────────────────────────────────────────
  static const String unexpectedError = 'Terjadi kesalahan tak terduga';
  static const String networkError = 'Periksa koneksi internet Anda';
  static const String serverError = 'Kesalahan server. Coba lagi nanti.';
  static const String timeoutError = 'Permintaan habis waktu. Coba lagi.';
  static const String notFoundError = 'Data tidak ditemukan';
  static const String unauthorizedError = 'Sesi Anda telah berakhir. Silakan masuk kembali.';

  // ── Actions ──────────────────────────────────────────────────────────────
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String confirm = 'Konfirmasi';
  static const String retry = 'Coba Lagi';
  static const String back = 'Kembali';
  static const String next = 'Lanjut';
  static const String submit = 'Kirim';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String search = 'Cari';
  static const String seeAll = 'Lihat Semua';

  // ── States ───────────────────────────────────────────────────────────────
  static const String loading = 'Memuat...';
  static const String emptyData = 'Tidak ada data';
  static const String noInternet = 'Tidak ada koneksi internet';
}
