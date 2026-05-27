#!/usr/bin/env python3
"""lunar-converter — 한국 음력 ↔ 양력 변환 CLI.

벤더링: korean_lunar_calendar.py (MIT, Copyright 2018-2020 Jinil Lee).
이 wrapper 는 같은 디렉터리의 라이브러리를 import 해서 sol2lun / lun2sol
변환만 노출한다. 데이터 범위: 1000년 ~ 2050년 (라이브러리 lookup table).

Usage:
  convert.py sol2lun YYYY-MM-DD
  convert.py lun2sol YYYY-MM-DD [leap]   # leap=윤달이면 plain "leap" 추가
"""
import sys
import os

# 같은 디렉터리의 라이브러리를 import (pip install 없이).
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from korean_lunar_calendar import KoreanLunarCalendar


def parse_iso(s):
    parts = s.split("-")
    if len(parts) != 3:
        raise ValueError(f"YYYY-MM-DD 형식이 아님: {s}")
    return int(parts[0]), int(parts[1]), int(parts[2])


def sol2lun(date_str):
    y, m, d = parse_iso(date_str)
    cal = KoreanLunarCalendar()
    if not cal.setSolarDate(y, m, d):
        raise ValueError(f"양력 변환 범위 밖이거나 잘못된 날짜: {date_str}")
    leap = " (윤달)" if cal.isIntercalation else ""
    return f"{date_str} (양) = {cal.LunarIsoFormat().replace(' Intercalation','')}{leap} (음)"


def lun2sol(date_str, is_leap=False):
    y, m, d = parse_iso(date_str)
    cal = KoreanLunarCalendar()
    if not cal.setLunarDate(y, m, d, is_leap):
        raise ValueError(f"음력 변환 범위 밖이거나 잘못된 날짜: {date_str}")
    leap = " (윤달)" if is_leap else ""
    return f"{date_str}{leap} (음) = {cal.SolarIsoFormat()} (양)"


def main():
    if len(sys.argv) < 3:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

    cmd = sys.argv[1]
    date_str = sys.argv[2]
    extra = sys.argv[3] if len(sys.argv) > 3 else ""

    try:
        if cmd == "sol2lun":
            print(sol2lun(date_str))
        elif cmd == "lun2sol":
            print(lun2sol(date_str, is_leap=(extra.lower() == "leap")))
        else:
            print(f"알 수 없는 명령: {cmd} (sol2lun / lun2sol)", file=sys.stderr)
            sys.exit(1)
    except (ValueError, IndexError) as e:
        print(f"에러: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
