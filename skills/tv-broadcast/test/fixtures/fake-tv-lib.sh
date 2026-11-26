# fake-tv-lib.sh — stand-in for the private TV library, used by test_run.sh through LISA_TV_LIB.
# It defines the same one entry, `tvb <action> [arg]`, and answers with canned JSON.
tvb() {
  case "${1:-}" in
    info) echo '{"returnValue":true,"channel":{"channelNumber":"11-1","channelName":"MBC"},"state":{"videoSignalState":"good"}}' ;;
    video) echo '{"returnValue":true,"width":1920,"height":1080,"scanType":"interlaced","aspectRatio":"16:9","resolution":"1920x1080i30"}' ;;
    audio_list) echo '{"returnValue":true,"audio":[{"audioLanguageId":0,"audioLanguageName":"English","current":true},{"audioLanguageId":1,"audioLanguageName":"Spanish"}],"count":2,"currentAudioLanguageId":0}' ;;
    set_audio) printf '{"returnValue":true,"did":"set_audio","arg":"%s"}\n' "${2:-}" ;;
    subtitle_list) echo '{"returnValue":true,"subtitle":[{"subtitleId":2,"subtitleLanguage":"English","current":true},{"subtitleId":3,"subtitleLanguage":"Spanish"}],"count":2,"currentSubtitleId":2,"captionsOn":true}' ;;
    set_subtitle) printf '{"returnValue":true,"did":"set_subtitle","arg":"%s"}\n' "${2:-}" ;;
    caption) printf '{"returnValue":true,"did":"caption","arg":"%s"}\n' "${2:-}" ;;
    libdir) printf '{"returnValue":true,"libDir":"%s"}\n' "${TVB_LIB_DIR:-}" ;;
    *) printf '{"returnValue":false,"errorText":"unknown action: %s"}\n' "${1:-}" ;;
  esac
}
