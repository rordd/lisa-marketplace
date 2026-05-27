#!/bin/sh
# pick — 후보 중 랜덤 N개 뽑기
# Usage: pick.sh "<후보들>" [count]
# 구분자: 콤마 / 슬래시 / 줄바꿈
set -e

CANDIDATES="$1"
COUNT="${2:-1}"

if [ -z "$CANDIDATES" ]; then
  echo "Usage: pick.sh \"<후보들>\" [count]" >&2
  echo "       e.g. pick.sh \"김치찌개, 라면, 짜장\" 1" >&2
  exit 1
fi

# count 가 숫자인지 검증
case "$COUNT" in
  ''|*[!0-9]*)
    echo "count 는 양의 정수여야 해요: $COUNT" >&2
    exit 1
    ;;
esac
if [ "$COUNT" -lt 1 ]; then
  echo "count 는 1 이상이어야 해요" >&2
  exit 1
fi

# 구분자 정규화: , / → 줄바꿈, 빈줄/공백 제거
ITEMS=$(printf '%s\n' "$CANDIDATES" | tr ',/' '\n\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$')

TOTAL=$(printf '%s\n' "$ITEMS" | wc -l | tr -d ' ')
if [ "$TOTAL" -eq 0 ]; then
  echo "후보가 비어있어요" >&2
  exit 1
fi
if [ "$COUNT" -gt "$TOTAL" ]; then
  echo "count($COUNT) 가 후보 수($TOTAL) 보다 많아요" >&2
  exit 1
fi

# 셔플 + 상위 N개. shuf 가 없으면 awk fallback.
if command -v shuf >/dev/null 2>&1; then
  printf '%s\n' "$ITEMS" | shuf -n "$COUNT"
else
  printf '%s\n' "$ITEMS" | awk 'BEGIN{srand()}{print rand() "\t" $0}' | sort -k1,1n | head -n "$COUNT" | cut -f2-
fi
