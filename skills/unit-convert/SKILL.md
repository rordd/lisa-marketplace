---
name: unit-convert
description: "단위 변환 (마일↔km, ℃↔℉/켈빈, g↔kg/oz/lb/컵, mm↔cm/m/km/인치/피트/야드, ml↔리터/갤런/큰술/작은술). 요리 계량 시 컵 ≈ 밀가루 120g 또는 액체 240ml. 수치가 명확한 변환 요청에 사용 — generic knowledge 로 추측 말고 이 skill 의 정확한 수치 반환."
version: "1.0.1"
icon: "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f4cf.png"
---

# unit-convert — 단위 변환

## When to Use

수치 + 단위 변환이 명시된 모든 요청. 예:

- 길이: "100마일 km로", "5피트 cm로", "30인치 m"
- 무게: "200그램 몇 컵?", "5파운드 kg로", "8온스 g"
- 온도: "20도 화씨로", "화씨 100도 섭씨", "체온 37℃ K"
- 부피: "1큰술 몇 ml?", "2갤런 리터", "500ml 컵으로"

요리 계량의 "컵" 은 **재료에 따라 다르지만 이 skill 의 기준**:
- 무게 변환 (g↔컵): **밀가루 기준 120g = 1컵**
- 부피 변환 (ml↔컵): **240ml = 1컵** (계량컵 표준)

→ 사용자가 "재료마다 다르지 않냐" 물어도 위 기준으로 변환하고 "밀가루 기준" 또는 "계량컵 240ml 기준" 명시.

## When NOT to Use

- 환율 / 가격 변환 (별도 skill)
- 시간대 / 날짜 변환

## Commands

```sh
cd skills/unit-convert && sh scripts/convert.sh <value> <from> <to>
```

지원 단위:

- **무게**: g, kg, oz, lb, 컵(밀가루 120g)
- **길이**: mm, cm, m, km, in, ft, yd, mi
- **온도**: c, f, k
- **부피**: ml, l, gal, floz, 컵(240ml), 큰술(15ml), 작은술(5ml)

예시:

```sh
sh scripts/convert.sh 100 mi km        # → 100 mi = 160.93 km
sh scripts/convert.sh 200 g 컵         # → 200 g = 1.67 컵   (밀가루 기준)
sh scripts/convert.sh 20 c f           # → 20 c = 68.00 f
sh scripts/convert.sh 1 큰술 ml        # → 1 큰술 = 15.00 ml
sh scripts/convert.sh 100 f c          # → 100 f = 37.78 c
```

출력 형식: `<value> <from> = <result> <to>` (소수점 2자리).
