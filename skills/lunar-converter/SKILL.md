---
name: lunar-converter
description: "한국 음력 ↔ 양력 변환. 설날/추석/제사일/생일 음력 양력 변환. 1000-2050년 범위. 윤달(intercalation) 지원. LLM 자체로는 정확도 매우 낮음 — 변환 수치가 명확히 필요하면 이 skill 호출."
version: "1.0.0"
---

# lunar-converter — 한국 음력 ↔ 양력 변환

## When to Use

- "음력 1995년 5월 1일은 양력 며칠?"
- "양력 2026-02-17 은 음력으로?"
- "내 음력 생일이 1985년 7월 7일인데 올해 양력으로 언제?"
- "추석 음력 8월 15일 → 양력"
- "윤4월 8일 양력 며칠?" (윤달 지원)

LLM 의 음력 지식은 매우 부정확 — 음력 변환은 60년 주기 + 윤달 + 큰달/작은달 lookup table 필요. **항상 이 skill 호출.**

## When NOT to Use

- 양력 → 양력 (그냥 date 산술)
- 한국 공휴일 조회 (`korea-holidays` skill)

## Commands

```sh
cd skills/lunar-converter && sh scripts/convert.sh <cmd> <YYYY-MM-DD> [leap]
```

`<cmd>`:
- `sol2lun` — 양력 → 음력
- `lun2sol` — 음력 → 양력

음력 → 양력 변환 시 `leap` 인자 추가하면 윤달:

```sh
sh scripts/convert.sh sol2lun 2026-02-17       # 양력 → 음력
sh scripts/convert.sh sol2lun 2024-09-17       # 추석 양력 → 음력 8월 15일
sh scripts/convert.sh lun2sol 1985-07-07       # 음력 → 양력
sh scripts/convert.sh lun2sol 2026-04-08 leap  # 윤4월 8일 → 양력
```

출력 형식:
- 양→음: `2026-02-17 (양) = 2026-01-01 (음)`
- 음→양: `1985-07-07 (음) = 1985-08-22 (양)`
- 윤달이면 ` (윤달)` 접미.

## Range

- **1000년 ~ 2050년** (한국천문연구원 기반 데이터, MIT-licensed Korean Lunar Calendar lib 활용)
- 범위 밖이면 에러.

## Requirements

- `python3` (보통 모든 linux/mac 에 있음. busybox-only TV target board 는 미지원)
- 외부 네트워크 / API 키 불필요
