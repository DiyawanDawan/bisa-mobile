# Terjemahan Mobile BISA

## File

| File | Bahasa |
|------|--------|
| `id-ID.json` | Bahasa Indonesia (master / fallback) |
| `en-US.json` | English (US) |

## Konvensi penamaan key

- Format: `feature_context_element` (snake_case)
- Contoh: `settings.choose_language`, `orders.batch_meta`
- Hindari key generik seperti `text_1777412451961` atau `email_1`
- **Satu `.tr()` saja** — dilarang `'key'.tr().tr()`

## Audit & planning

- **Audit penuh:** [`Palning Interasi/audit_bilingual_i18n_full.md`](../../Palning%20Interasi/audit_bilingual_i18n_full.md)
- **Task tracker:** [`Palning Interasi/task_bilingual_i18n.md`](../../Palning%20Interasi/task_bilingual_i18n.md)

## Menambah key baru

1. Tambahkan ke **kedua** file JSON (`id-ID.json` dan `en-US.json`)
2. Pastikan nilai EN **bukan** copy-paste teks Indonesia
3. Jalankan validasi:

```bash
dart run tool_validate_i18n.dart
```

## Placeholder argumen

```dart
'orders.batch_meta'.tr(namedArgs: {'count': '3', 'time': '5 min ago'})
```

JSON:

```json
"orders.batch_meta": "1× bayar · {count} barang · {time}"
```

## Format locale-aware

Gunakan `LocaleFormatters` / extension `context`:

```dart
context.formatCurrency(amount);
context.formatDate(date);
context.formatTimeAgo(date);
```

Jangan hardcode `locale: 'id_ID'` atau `locale: 'id'` di widget.
