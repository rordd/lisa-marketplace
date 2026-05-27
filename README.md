# lisa-marketplace

Lisa skill registry — community-published skills installable via chat:

```
"마켓에 뭐 있어?"          → marketplace_list
"unit-convert 설치해줘"     → marketplace_install unit-convert
```

Or via CLI:

```
zeroclaw skills install unit-convert
```

## Structure

```
skills/
  <skill-name>/
    SKILL.md         # frontmatter (name/description/version) + 사용 instructions
    scripts/         # bash scripts (busybox-friendly)
    data/            # static data files (optional)
index.json           # catalog — name, version, description, tags, deps
```

Lisa downloads `https://codeload.github.com/rordd/lisa-marketplace/zip/refs/heads/main`,
extracts `skills/<name>/` into `~/.zeroclaw/workspace/skills/<name>/`, and reloads
on the next chat. No daemon restart required (skill loader rescans the directory
every turn).

## Submitted skills

| Name | Description | Secrets | System deps |
|---|---|---|---|
| `unit-convert` | 무게/길이/온도/부피 변환 | none | sh, awk |
| `korea-holidays` | 한국 공휴일 (2026-2027) | none | sh, awk, grep, date |
| `lunar-converter` | 한국 음력 ↔ 양력 (1000-2050, 윤달 지원) | none | sh, python3 |

## Publishing a skill

1. Fork this repo.
2. Add `skills/<name>/SKILL.md` + scripts.
3. Append an entry to `index.json` (keep alphabetical).
4. Smoke test locally: `sh scripts/<entry>.sh ...`.
5. PR.

Skill audit rules (busybox-friendly):
- shell scripts are OK (`.sh`) but reviewed for unsafe patterns
- no network access unless declared (`secrets_required` lists env vars)
- no writes outside `~/.zeroclaw/workspace/` at runtime

## License

Skills inherit each contributor's license declared in their `SKILL.md`
frontmatter (`license:` field). If absent, default is MIT.
