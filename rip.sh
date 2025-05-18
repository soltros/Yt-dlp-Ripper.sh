#!/bin/bash

# === Functions ===

rip_playlist() {
  local PLAYLIST_URL="$1"
  local AUDIO_FORMAT="$2"

  echo "📡 Fetching playlist title for $PLAYLIST_URL..."
  PLAYLIST_TITLE=$(yt-dlp --quiet --no-warnings --flat-playlist --print "%(playlist_title)s" "$PLAYLIST_URL" | sed -n '1p')

  if [[ -z "$PLAYLIST_TITLE" ]]; then
    echo "⚠️  Could not fetch playlist title. Using 'untitled_playlist'."
    PLAYLIST_TITLE="untitled_playlist"
  fi

  FOLDER_NAME=$(echo "$PLAYLIST_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
  DEST_FOLDER="$HOME/Downloads/yt-dlp-ripper/$FOLDER_NAME"
  mkdir -p "$DEST_FOLDER"

  TEMP_FILE="$DEST_FOLDER/.yt_links_tmp.txt"

  echo "📥 Extracting video URLs..."
  yt-dlp --flat-playlist --ignore-errors --print "https://www.youtube.com/watch?v=%(id)s" "$PLAYLIST_URL" > "$TEMP_FILE"

  echo "📂 Downloading into: $DEST_FOLDER"
  cd "$DEST_FOLDER" || exit 1

  while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    echo "➡️  Downloading: $url"
    yt-dlp -x \
      --audio-format "$AUDIO_FORMAT" \
      --audio-quality 0 \
      --embed-thumbnail \
      --output "%(title)s.%(ext)s" \
      "$url"

    SLEEP_DURATION=$((RANDOM % 46 + 15))
    echo "⏳ Sleeping for $SLEEP_DURATION seconds..."
    sleep "$SLEEP_DURATION"
  done < "$TEMP_FILE"

  rm -f "$TEMP_FILE"
  echo "✅ Finished playlist: $PLAYLIST_TITLE"
}

# === Queue Mode ===

if [[ "$1" == "--queue" && -f "$2" ]]; then
  QUEUE_FILE="$2"
  echo "🎶 Queue mode enabled. Reading from $QUEUE_FILE"

  read -p "🎵 Desired audio format for all playlists (default is mp3): " AUDIO_FORMAT
  AUDIO_FORMAT=${AUDIO_FORMAT:-mp3}

  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    rip_playlist "$line" "$AUDIO_FORMAT"
  done < "$QUEUE_FILE"

  echo "🎉 All queued playlists have been processed."
  exit 0
fi

# === Normal Interactive Mode ===

echo "🔗 Enter the full YouTube playlist URL:"
read -r PLAYLIST_URL

read -p "🎵 Desired audio format (default is mp3): " AUDIO_FORMAT
AUDIO_FORMAT=${AUDIO_FORMAT:-mp3}

rip_playlist "$PLAYLIST_URL" "$AUDIO_FORMAT"
