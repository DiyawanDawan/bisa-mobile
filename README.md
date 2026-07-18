# mobile_bisa

Aplikasi mobile BISA (Flutter).

## Demo Account

| Role | Email | Password |
|------|-------|----------|
| Buyer | h.wijaya@surabayaindustrial.com | password123 |
| Supplier | siti.aminah@agritech.com | password123 |

## Prasyarat

1. **Backend** harus jalan di port `3000`:
   ```powershell
   cd "d:\HACKATON\Apps\Backend"
   npm run dev
   ```
2. Pastikan database sudah di-seed (ada produk, kategori, forum, dll.).

## Menjalankan aplikasi (penting)

Aplikasi **wajib** di-run dengan `API_URL`. Tanpa ini, layar terbuka tapi **data kosong**.

### Opsi 1 — Tombol Run di Cursor/VS Code (disarankan)

1. Buka folder `mobile_bisa`
2. Tab **Run and Debug** (Ctrl+Shift+D)
3. Pilih salah satu:
   - **BISA — Development server ★** → `backend-dev-v1.bisaagri.com` (default pre-live / QA)
   - **BISA — Android Emulator** → pakai `10.0.2.2` (backend lokal)
   - **BISA — Windows / Chrome (localhost)** → untuk `flutter run -d windows` atau Chrome
   - **BISA — HP Fisik (WiFi)** → HP dan PC harus satu jaringan WiFi
   - **BISA — Production** → hanya saat go-live

Jangan klik Run langsung tanpa memilih config di atas.

### Build APK release (development)

```powershell
flutter build apk --release --target-platform=android-arm64 `
  --dart-define-from-file=dart_define.development.json
```

### Opsi 2 — HP fisik via USB (disarankan, tanpa firewall)

```powershell
cd "d:\HACKATON\Apps\Mobile Apps\mobile_bisa"

# 1) Backend jalan di laptop
# 2) HP colok USB, USB debugging aktif
.\setup-phone-dev.ps1    # sekali per sesi USB
.\run-dev.ps1 -Target device
```

App memakai `127.0.0.1:3000` di HP (di-forward ke laptop lewat `adb reverse`).

### Opsi 3 — HP fisik via WiFi saja

Butuh buka firewall dulu (**Run as Administrator**):

```powershell
.\open-firewall.ps1
```

Lalu update IP di `dart_define.device-wifi.json` dan run dengan:

```powershell
flutter run --dart-define-from-file=dart_define.device-wifi.json --dart-define=USE_LAN_HOST=true
```

### Opsi 4 — PowerShell lainnya

```powershell
.\run-dev.ps1 -Target emulator   # Android Emulator
.\run-dev.ps1 -Target localhost    # Windows / Chrome
```

### Opsi 3 — Manual

```bash
flutter run --dart-define-from-file=dart_define.emulator.json
```

## File konfigurasi

| File | Kapan dipakai |
|------|----------------|
| `dart_define.emulator.json` | Android Emulator (`10.0.2.2`) |
| `dart_define.dev.json` | Windows / Chrome / iOS Simulator (`localhost`) |
| `dart_define.device.json` | HP fisik — **ganti IP** ke IP komputer Anda |

Cek IP komputer: `ipconfig` → IPv4 Address (contoh: `192.168.38.239`).

## Bilingual (EN + ID)

Aplikasi mendukung **Bahasa Indonesia** dan **English** via `easy_localization`.

- Ganti bahasa: **Profil → Ganti Bahasa** atau **Pengaturan → Bahasa**
- Pilihan bahasa tersimpan otomatis (`saveLocale: true`)
- File terjemahan: `assets/translations/id-ID.json`, `en-US.json`

### Menambah / cek terjemahan

```bash
# Validasi parity key ID/EN
dart run tool_validate_i18n.dart

# Gagal jika masih ada placeholder EN
dart run tool_validate_i18n.dart --fail-on-placeholder
```

Konvensi key: lihat [`assets/translations/README.md`](assets/translations/README.md).

## Troubleshooting

| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| Data kosong, tidak ada error jelas | Run tanpa `--dart-define` | Pakai launch config atau `run-dev.ps1` |
| Connection refused / timeout | Backend belum jalan | `npm run dev` di folder Backend |
| Emulator tidak connect ke API | Salah host | Pakai `10.0.2.2`, bukan `localhost` |
| HP fisik tidak connect | IP salah / beda WiFi | Update `dart_define.device.json` |

Di console debug, cari log `[BISA] API_URL kosong` — itu tanda config belum terpasang.

## Referensi

- [Flutter docs](https://docs.flutter.dev/)
- Agent samples: https://github.com/google/adk-samples/tree/main/python/agents
