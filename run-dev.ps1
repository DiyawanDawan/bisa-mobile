param(
  [ValidateSet('development', 'emulator', 'localhost', 'device', 'ngrok')]
  [string]$Target = 'development'
)

$config = switch ($Target) {
  'development' { 'dart_define.development.json' }
  'localhost'   { 'dart_define.dev.json' }
  'emulator'    { 'dart_define.emulator.json' }
  'device'      { 'dart_define.device.json' }
  'ngrok'       { 'dart_define.ngrok.json' }
}

if ($Target -eq 'device') {
  & "$PSScriptRoot\setup-phone-dev.ps1"
}

Write-Host "[BISA] Menggunakan config: $config (target=$Target)" -ForegroundColor Cyan
flutter run --dart-define-from-file=$config @args
