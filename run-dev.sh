#!/usr/bin/env bash
set -euo pipefail

TARGET="${BISA_TARGET:-emulator}"

case "$TARGET" in
  localhost) CONFIG="dart_define.dev.json" ;;
  emulator)  CONFIG="dart_define.emulator.json" ;;
  device)    CONFIG="dart_define.device.json" ;;
  *)
    echo "BISA_TARGET harus: localhost | emulator | device"
    exit 1
    ;;
esac

echo "[BISA] Menggunakan config: $CONFIG"
flutter run --dart-define-from-file="$CONFIG" "$@"
