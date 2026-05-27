#!/bin/sh
# korea-holidays — 한국 공휴일 조회
# Usage: query.sh <type> [arg]
#   next | today | month YYYY-MM | month MM | year YYYY | year
set -e

TYPE="$1"
ARG="$2"

# 스크립트 위치 기준 data 파일 — `cd skills/korea-holidays && sh scripts/query.sh ...` 도, absolute path 호출도 둘 다 지원.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DATA="$SCRIPT_DIR/../data/holidays.txt"

if [ ! -f "$DATA" ]; then
  echo "데이터 파일 없음: $DATA" >&2
  exit 1
fi

# 주석/빈줄 제외한 raw 데이터
strip_comments() {
  grep -v '^[[:space:]]*#' "$DATA" | grep -v '^[[:space:]]*$'
}

today_iso() {
  date +%Y-%m-%d
}

case "$TYPE" in
  next)
    TODAY=$(today_iso)
    # today 이상의 첫 entry
    HIT=$(strip_comments | awk -F'|' -v t="$TODAY" '$1 >= t {print; exit}')
    if [ -z "$HIT" ]; then
      echo "데이터 범위 끝 — 다음 공휴일 없음 (2027년까지 등록됨)"
      exit 0
    fi
    DATE=$(echo "$HIT" | cut -d'|' -f1)
    NAME=$(echo "$HIT" | cut -d'|' -f2)
    # 며칠 남았나 — busybox date 가 -d 지원 미보장이라 awk 로 epoch 계산 어려움. 단순 출력만.
    echo "$DATE $NAME"
    ;;

  today)
    TODAY=$(today_iso)
    HIT=$(strip_comments | awk -F'|' -v t="$TODAY" '$1 == t {print}')
    if [ -z "$HIT" ]; then
      echo "오늘($TODAY) 은 공휴일이 아님"
    else
      NAME=$(echo "$HIT" | cut -d'|' -f2)
      echo "오늘($TODAY) 은 공휴일: $NAME"
    fi
    ;;

  month)
    if [ -z "$ARG" ]; then
      echo "Usage: query.sh month <YYYY-MM | MM>" >&2
      exit 1
    fi
    # MM 만 받으면 올해
    case "$ARG" in
      [0-9][0-9][0-9][0-9]-[0-9][0-9]) PREFIX="$ARG" ;;
      [0-9][0-9])  PREFIX="$(date +%Y)-$ARG" ;;
      [0-9])       PREFIX="$(date +%Y)-0$ARG" ;;
      *) echo "month 형식: YYYY-MM 또는 MM" >&2; exit 1 ;;
    esac
    HITS=$(strip_comments | grep "^$PREFIX-" || true)
    if [ -z "$HITS" ]; then
      echo "$PREFIX 공휴일 없음"
    else
      printf '%s\n' "$HITS" | awk -F'|' '{print $1 " " $2}'
    fi
    ;;

  year)
    YEAR="${ARG:-$(date +%Y)}"
    case "$YEAR" in
      [0-9][0-9][0-9][0-9]) ;;
      *) echo "year 형식: YYYY" >&2; exit 1 ;;
    esac
    HITS=$(strip_comments | grep "^$YEAR-" || true)
    if [ -z "$HITS" ]; then
      echo "$YEAR 공휴일 없음 (데이터 범위 초과 가능)"
    else
      printf '%s\n' "$HITS" | awk -F'|' '{print $1 " " $2}'
    fi
    ;;

  ""|help|-h|--help)
    cat <<'EOF'
Usage: query.sh <type> [arg]

  next                  — 오늘 이후 다음 공휴일 1개
  today                 — 오늘이 공휴일인지
  month YYYY-MM         — 특정 월 공휴일 (예: 2026-10)
  month MM              — 올해 특정 월 (예: 12)
  year YYYY             — 특정 년도 (예: 2027)
  year                  — 올해

데이터 범위: 2026, 2027
EOF
    ;;

  *)
    echo "알 수 없는 type: $TYPE (next/today/month/year)" >&2
    exit 1
    ;;
esac
