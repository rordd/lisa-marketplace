---
name: tv-broadcast
description: "Reads and changes the live-TV broadcast that is playing right now: audio language (multi-audio) tracks, subtitle or caption tracks, captions on or off, a snapshot of the current channel, and video info such as resolution. Use when the user asks about or changes the audio language, subtitles or captions of the channel on screen, or asks about its picture quality (e.g. \"영어 자막으로 바꿔줘\", \"자막 켜줘\", \"음성 영어로 바꿔줘\", \"지금 해상도 뭐야\"). Not for switching the channel (→ tv-control), program schedules, or volume."
version: "0.1.0"
lisa_min_version: "0.1.0"
risk: write
secrets_required: []
---

# tv-broadcast

## When to Use

- "영어 자막으로 바꿔줘", "자막 켜줘", "자막 꺼줘"
- "음성 영어로 바꿔줘", "이중 언어 방송이야?"
- "지금 이 채널 해상도 뭐야?", "화질 정보 알려줘"

## When NOT to Use

- Changing the channel ("7번으로 돌려줘") → tv-control
- What is on now or later (program schedules)
- Volume or launching apps → tv-control

## Commands

All commands act on the broadcast that is playing now. The user may have changed channel or app since the last request, so run the command again instead of reusing an earlier result.

```sh
cd skills-market/tv-broadcast && sh scripts/run.sh info
cd skills-market/tv-broadcast && sh scripts/run.sh video
cd skills-market/tv-broadcast && sh scripts/run.sh audio_list
cd skills-market/tv-broadcast && sh scripts/run.sh set_audio <audio_language_id>
cd skills-market/tv-broadcast && sh scripts/run.sh subtitle_list
cd skills-market/tv-broadcast && sh scripts/run.sh set_subtitle <subtitle_id>
cd skills-market/tv-broadcast && sh scripts/run.sh caption on|off
```

- `info` gives the channel (number, name) and the signal state. `video` gives resolution, scan type, frame rate, aspect ratio and 2D/3D.
- To change the audio or the subtitle track, run `audio_list` or `subtitle_list` first and pass the numeric id of the track the user asked for. Never guess an id.
- `caption on|off` only turns captions on or off and needs no track id. `set_subtitle` also turns captions on.
- Run one command per call and do not chain other commands to it.

The reply is a single JSON object.

- Success: `{"returnValue": true, …}` — the list commands also give the current selection (`currentAudioLanguageId`, `currentSubtitleId`).
- Failure: `{"returnValue": false, "errorText"}` — relay `errorText` as is. If it says there is no active broadcast pipeline, live TV is not playing: ask the user to turn on live TV first.
- Tools missing: `{"ok": false, "error": {"code": "UNAVAILABLE", "message"}}` — this TV has no broadcast tools. Relay `message` as is and do not retry.

## How to answer

State what the TV is set to now, and after a change state what it was changed to, in one short line.

- Audio changed: "음성을 영어로 바꿨어."
- Captions turned on or off: "자막을 켰어." / "자막을 껐어."
- The channel has no subtitle track: say so plainly and do not retry.
