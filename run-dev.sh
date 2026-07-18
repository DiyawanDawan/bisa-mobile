#!/usr/bin/env bash
set -euo pipefail

TARGET="${BISA_TARGET:-development}"

case "$TARGET" in
  development) CONFIG="dart_define.development.json" ;;
  localhost)   CONFIG="dart_define.dev.json" ;;
  emulator)    CONFIG="dart_define.emulator.json" ;;
  device)      CONFIG="dart_define.device.json" ;;
  ngrok)       CONFIG="dart_define.ngrok.json" ;;
  *)
    echo "BISA_TARGET harus: development | localhost | emulator | device | ngrok"
    exit 1
    ;;
esac

echo "[BISA] Menggunakan config: $CONFIG (target=$TARGET)"
flutter run --dart-define-from-file="$CONFIG" "$@"
