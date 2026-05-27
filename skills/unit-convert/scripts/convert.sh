#!/bin/sh
# unit-convert — 단위 변환 (무게/길이/온도/부피)
# Usage: convert.sh <value> <from> <to>
# Output: "<value> <from> = <result> <to>"
set -e

VALUE="$1"
FROM="$2"
TO="$3"

if [ -z "$VALUE" ] || [ -z "$FROM" ] || [ -z "$TO" ]; then
  echo "Usage: convert.sh <value> <from> <to>" >&2
  echo "       e.g. convert.sh 100 mi km" >&2
  exit 1
fi

# Normalize unit aliases (한국어 + 영문 lowercase). 큰술/작은술/컵은 그대로.
norm() {
  case "$1" in
    G|g|gram|grams|그램) echo g ;;
    KG|kg|kilogram|kilograms|킬로|킬로그램) echo kg ;;
    OZ|oz|ounce|ounces|온스) echo oz ;;
    LB|lb|pound|pounds|파운드) echo lb ;;

    MM|mm|millimeter|millimeters|밀리) echo mm ;;
    CM|cm|centimeter|centimeters|센티) echo cm ;;
    M|m|meter|meters|미터) echo m ;;
    KM|km|kilometer|kilometers|킬로미터) echo km ;;
    IN|in|inch|inches|인치) echo in ;;
    FT|ft|foot|feet|피트) echo ft ;;
    YD|yd|yard|yards|야드) echo yd ;;
    MI|mi|mile|miles|마일) echo mi ;;

    C|c|℃|섭씨|섭) echo c ;;
    F|f|℉|화씨|화) echo f ;;
    K|k|kelvin|켈빈) echo k ;;

    ML|ml|milliliter|milliliters|밀리리터) echo ml ;;
    L|l|liter|liters|리터) echo l ;;
    GAL|gal|gallon|gallons|갤런) echo gal ;;
    FLOZ|floz|fl_oz|"fl oz"|fluid_ounce) echo floz ;;
    컵|cup|cups) echo cup ;;
    큰술|tbsp|tablespoon) echo tbsp ;;
    작은술|tsp|teaspoon) echo tsp ;;

    *) echo "$1" ;;
  esac
}

NF=$(norm "$FROM")
NT=$(norm "$TO")

# Convert to canonical SI base, then to target.
# mass: g | length: m | temp: c (special) | volume: ml
# 컵(mass) = 120 g (밀가루 기준), 컵(volume) = 240 ml — context 로 구분
# from/to 둘 다 컵일 수 있고, 무게 단위와 섞이면 mass-컵, 부피 단위와 섞이면 volume-컵.

# 단위 그룹 식별: mass / length / temp / volume
group() {
  case "$1" in
    g|kg|oz|lb) echo mass ;;
    mm|cm|m|km|in|ft|yd|mi) echo length ;;
    c|f|k) echo temp ;;
    ml|l|gal|floz|tbsp|tsp) echo volume ;;
    cup) echo cup_ambiguous ;;
    *) echo unknown ;;
  esac
}

GF=$(group "$NF")
GT=$(group "$NT")

# 컵 모호성 해결: 상대 단위 그룹으로 fix
if [ "$GF" = "cup_ambiguous" ] && [ "$GT" = "mass" ]; then GF=mass; fi
if [ "$GT" = "cup_ambiguous" ] && [ "$GF" = "mass" ]; then GT=mass; fi
if [ "$GF" = "cup_ambiguous" ] && [ "$GT" = "volume" ]; then GF=volume; fi
if [ "$GT" = "cup_ambiguous" ] && [ "$GF" = "volume" ]; then GT=volume; fi
# 둘 다 컵이면 mass→mass (의미 없지만 에러 안 냄)
if [ "$GF" = "cup_ambiguous" ] && [ "$GT" = "cup_ambiguous" ]; then GF=mass; GT=mass; fi
# cup 만 있고 상대가 unknown 이면 default volume (사용자가 그냥 "1컵 ml" 같은 경우 흔함)
if [ "$GF" = "cup_ambiguous" ]; then GF=volume; fi
if [ "$GT" = "cup_ambiguous" ]; then GT=volume; fi

if [ "$GF" != "$GT" ]; then
  echo "단위 그룹이 달라요: $FROM ($GF) → $TO ($GT)" >&2
  exit 1
fi

# Conversion using awk for portable arithmetic (no bc dep)
RESULT=$(awk -v v="$VALUE" -v f="$NF" -v t="$NT" -v grp="$GF" 'BEGIN {
  # 무게: g 기준
  mass_g["g"]=1; mass_g["kg"]=1000; mass_g["oz"]=28.3495; mass_g["lb"]=453.592; mass_g["cup"]=120
  # 길이: m 기준
  len_m["mm"]=0.001; len_m["cm"]=0.01; len_m["m"]=1; len_m["km"]=1000
  len_m["in"]=0.0254; len_m["ft"]=0.3048; len_m["yd"]=0.9144; len_m["mi"]=1609.344
  # 부피: ml 기준
  vol_ml["ml"]=1; vol_ml["l"]=1000; vol_ml["gal"]=3785.41; vol_ml["floz"]=29.5735
  vol_ml["cup"]=240; vol_ml["tbsp"]=15; vol_ml["tsp"]=5

  if (grp == "mass") {
    base = v * mass_g[f]
    out = base / mass_g[t]
  } else if (grp == "length") {
    base = v * len_m[f]
    out = base / len_m[t]
  } else if (grp == "volume") {
    base = v * vol_ml[f]
    out = base / vol_ml[t]
  } else if (grp == "temp") {
    # temp 는 special: f→c, k→c 변환 후 c→t
    if (f == "c") c = v
    else if (f == "f") c = (v - 32) * 5 / 9
    else if (f == "k") c = v - 273.15
    if (t == "c") out = c
    else if (t == "f") out = c * 9 / 5 + 32
    else if (t == "k") out = c + 273.15
  }
  printf "%.2f", out
}')

echo "$VALUE $FROM = $RESULT $TO"
