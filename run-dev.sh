#!/usr/bin/env bash
set -euo pipefail

flutter run --dart-define-from-file=dart_define.dev.json "$@"
