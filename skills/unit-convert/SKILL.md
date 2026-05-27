---
name: unit-convert
description: "단위 변환. 무게/길이/온도/부피. 요리 계량(컵·큰술·작은술), 여행(마일·인치·℉), 일상 변환. 외부 API 불필요."
version: "1.0.0"
---

# unit-convert — 단위 변환

## When to Use

- "200그램이 몇 컵?", "1큰술 몇 ml?"
- "100마일을 km로", "5피트 cm로"
- "20℃ ℉로", "화씨 100도 섭씨로"
- "2갤런 리터로", "100ml 큰술로"

## When NOT to Use

- 환율 / 가격 변환 (별도 skill)
- 시간대 / 날짜 변환

## Commands

```sh
cd skills/unit-convert && sh scripts/convert.sh <value> <from> <to>
```

지원 단위:

- **무게**: g, kg, oz, lb, 컵(밀가루 기준 120g)
- **길이**: mm, cm, m, km, in, ft, yd, mi
- **온도**: c, f, k
- **부피**: ml, l, gal, floz, 컵(240ml), 큰술(15ml), 작은술(5ml)

예시:

```sh
sh scripts/convert.sh 100 mi km        # 100마일 → km
sh scripts/convert.sh 200 g 컵         # 200g 밀가루 → 컵
sh scripts/convert.sh 20 c f           # 20℃ → ℉
sh scripts/convert.sh 1 큰술 ml        # 1큰술 → ml
```

출력 형식: `100 mi = 160.93 km` (소수점 2자리).
