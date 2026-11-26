#!/bin/sh
# run.sh test — run by `lisa-sdk test`. The private TV library is replaced by a fake one
# (test/fixtures/fake-tv-lib.sh) that LISA_TV_LIB points to, so no TV is involved.
. "${LISA_SDK_TESTLIB:?run with lisa-sdk test}"
cd "$LISA_ITEM_DIR" || exit 1
export LISA_TV_LIB="$LISA_ITEM_DIR/test/fixtures/fake-tv-lib.sh"

t_run sh scripts/run.sh info
t_ok "info: channel and signal state pass through" '.returnValue == true and .channel.channelNumber == "11-1" and .state.videoSignalState == "good"'

t_run sh scripts/run.sh video
t_ok "video: resolution and ratio" '.returnValue == true and .resolution == "1920x1080i30" and .aspectRatio == "16:9"'

t_run sh scripts/run.sh audio_list
t_ok "audio_list: tracks and the current one" '.returnValue == true and .count == 2 and .currentAudioLanguageId == 0'

t_run sh scripts/run.sh set_audio 1
t_ok "set_audio: the id reaches the library" '.returnValue == true and .did == "set_audio" and .arg == "1"'

t_run sh scripts/run.sh subtitle_list
t_ok "subtitle_list: tracks, current one, captions on" '.returnValue == true and .currentSubtitleId == 2 and .captionsOn == true'

t_run sh scripts/run.sh set_subtitle 3
t_ok "set_subtitle: the id reaches the library" '.returnValue == true and .did == "set_subtitle" and .arg == "3"'

t_run sh scripts/run.sh caption off
t_ok "caption off: the state reaches the library" '.returnValue == true and .did == "caption" and .arg == "off"'

t_run sh scripts/run.sh caption on
t_ok "caption on: the state reaches the library" '.returnValue == true and .did == "caption" and .arg == "on"'

t_run sh scripts/run.sh frobnicate
t_ok "a bad action is answered by the library, not by the skill" '.returnValue == false and (.errorText | contains("unknown action"))'

t_run sh scripts/run.sh libdir
t_ok "the library folder is handed over as TVB_LIB_DIR" ".libDir == \"$LISA_ITEM_DIR/test/fixtures\""

# library missing
LISA_TV_LIB="$LISA_TEST_TMP/no-such-lib.sh"
t_run sh scripts/run.sh info
t_fails "library missing: UNAVAILABLE" UNAVAILABLE
t_ok "library missing: the plain message" '.error.message == "이 TV 에는 방송 도구가 없어요"'

t_done
