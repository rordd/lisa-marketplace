---
name: korea-holidays
description: "한국 공휴일 조회. 다음 빨간날, 이번 달 공휴일, 특정 월/년 공휴일. 2026-2027 정적 데이터. 외부 API 불필요."
version: "1.0.0"
icon: "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f4c5.png"
---

# korea-holidays — 한국 공휴일

## When to Use

- "다음 빨간날 언제?", "다음 공휴일"
- "이번 달 공휴일 뭐 있어?"
- "12월 공휴일", "2027년 추석"
- "오늘 공휴일이야?"

## When NOT to Use

- 회사/학교 자체 휴일 (개별 일정)
- 임시공휴일 (정부 갑작스러운 지정 — 정적 데이터라 즉시 반영 안 됨)

## Coverage

- **2026, 2027 년** 한국 법정 공휴일 + 대체공휴일.
- 음력 명절(설/추석) 양력으로 미리 계산되어 들어감.

## Commands

```sh
cd skills/korea-holidays && sh scripts/query.sh <type> [arg]
```

type:

- `next` — 오늘 이후 가장 가까운 공휴일 1개
- `today` — 오늘이 공휴일인지 yes/no + 이름
- `month YYYY-MM` — 특정 월의 공휴일 모두
- `month MM` — 올해 특정 월
- `year YYYY` — 특정 년도 전체
- `year` — 올해 전체

예시:

```sh
sh scripts/query.sh next
sh scripts/query.sh today
sh scripts/query.sh month 2026-10        # 2026년 10월
sh scripts/query.sh month 12             # 올해 12월
sh scripts/query.sh year 2027
```

출력 형식: `YYYY-MM-DD 이름` 한 줄씩.
