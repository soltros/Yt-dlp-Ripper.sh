#!/bin/bash

# Ask for playlist URL
echo "🔗 Enter the full YouTube playlist URL:"
read -r PLAYLIST_URL

# Ask user for desired audio format (default: mp3)
read -p "🎵 Desired audio format (default is mp3): " AUDIO_FORMAT
AUDIO_FORMAT=${AUDIO_FORMAT:-mp3}

# Extract playlist title
echo "📡 Fetching playlist title..."
PLAYLIST_TITLE=$(yt-dlp --flat-playlist --print "%(playlist_title)s" "$PLAYLIST_URL" 2>/dev/null | sed -n '1p')

if [[ -z "$PLAYLIST_TITLE" ]]; then
  echo "❌ Failed to retrieve playlist title. Exiting."
  exit 1
fi

# Convert title to snake_case
FOLDER_NAME=$(echo "$PLAYLIST_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')

# Define output folder
DEST_FOLDER="$HOME/Downloads/yt-dlp-ripper/$FOLDER_NAME"
mkdir -p "$DEST_FOLDER"

# Save video URLs to a temp file
TEMP_FILE="./.yt_links_tmp_$$.txt"
echo "📥 Extracting video URLs..."
yt-dlp --flat-playlist --print "https://www.youtube.com/watch?v=%(id)s" "$PLAYLIST_URL" > "$TEMP_FILE"

echo "📂 Downloading into: $DEST_FOLDER"
cd "$DEST_FOLDER" || exit 1

# Download each video separately
while IFS= read -r url; do
  echo "➡️  Downloading: $url"

  yt-dlp -x \
    --audio-format "$AUDIO_FORMAT" \
    --audio-quality 0 \
    --embed-thumbnail \
    --output "%(title)s.%(ext)s" \
    "$url"

  # Sleep randomly between 15–60 seconds
  SLEEP_DURATION=$((RANDOM % 46 + 15))
  echo "⏳ Sleeping for $SLEEP_DURATION seconds..."
  sleep "$SLEEP_DURATION"
done < "$TEMP_FILE"

# Ask to delete temp file
read -p "🗑️  Delete temporary video URL list? [y/N]: " DELETE_TEMP
[[ "$DELETE_TEMP" =~ ^[Yy]$ ]] && rm "$TEMP_FILE" && echo "✅ Temp file deleted."

echo "✅ All downloads complete. Saved to $DEST_FOLDER"
