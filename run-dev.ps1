param(
  [ValidateSet('emulator', 'localhost', 'device')]
  [string]$Target = 'device'
)

$config = switch ($Target) {
  'localhost' { 'dart_define.dev.json' }
  'emulator'  { 'dart_define.emulator.json' }
  'device'    { 'dart_define.device.json' }
}

if ($Target -eq 'device') {
  & "$PSScriptRoot\setup-phone-dev.ps1"
}

Write-Host "[BISA] Menggunakan config: $config" -ForegroundColor Cyan
flutter run --dart-define-from-file=$config @args
