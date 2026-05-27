#!/bin/sh
# lunar-converter — sh entry point. python3 wrapper 실행.
set -e
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 가 없어요. 이 skill 은 python3 가 필요해요." >&2
  exit 1
fi

exec python3 "$SCRIPT_DIR/convert.py" "$@"
