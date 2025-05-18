#!/bin/bash

# Prompt for playlist URL
echo "🔗 Enter the full YouTube playlist URL:"
read -r PLAYLIST_URL

# Prompt for audio format
read -p "🎵 Desired audio format (default is mp3): " AUDIO_FORMAT
AUDIO_FORMAT=${AUDIO_FORMAT:-mp3}

# Fetch playlist title
echo "📡 Fetching playlist title..."
PLAYLIST_TITLE=$(yt-dlp --quiet --no-warnings --flat-playlist --print "%(playlist_title)s" "$PLAYLIST_URL" | sed -n '1p')

if [[ -z "$PLAYLIST_TITLE" ]]; then
  echo "⚠️  Could not fetch playlist title. Using 'untitled_playlist'."
  PLAYLIST_TITLE="untitled_playlist"
fi

# Convert title to snake_case
FOLDER_NAME=$(echo "$PLAYLIST_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')

# Define output folder
DEST_FOLDER="$HOME/Downloads/yt-dlp-ripper/$FOLDER_NAME"
mkdir -p "$DEST_FOLDER"

# Create temp file inside destination folder
TEMP_FILE="$DEST_FOLDER/.yt_links_tmp.txt"

# Extract video URLs
echo "📥 Extracting video URLs..."
yt-dlp --flat-playlist --ignore-errors --print "https://www.youtube.com/watch?v=%(id)s" "$PLAYLIST_URL" > "$TEMP_FILE"

# Confirm destination
echo "📂 Downloading into: $DEST_FOLDER"
cd "$DEST_FOLDER" || exit 1

# Download each video
while IFS= read -r url; do
  echo "➡️  Downloading: $url"

  yt-dlp -x \
    --audio-format "$AUDIO_FORMAT" \
    --audio-quality 0 \
    --embed-thumbnail \
    --output "%(title)s.%(ext)s" \
    "$url"

  # Sleep between 15 and 60 seconds
  SLEEP_DURATION=$((RANDOM % 46 + 15))
  echo "⏳ Sleeping for $SLEEP_DURATION seconds..."
  sleep "$SLEEP_DURATION"
done < "$TEMP_FILE"

# Ask if the temp file should be deleted
read -p "🗑️  Delete temporary video URL list? [y/N]: " DELETE_TEMP
if [[ "$DELETE_TEMP" =~ ^[Yy]$ ]]; then
  rm -f "$TEMP_FILE"
  echo "✅ Temp file deleted."
else
  echo "⚠️  Temp file kept at: $TEMP_FILE"
fi

echo "✅ All downloads complete. Saved to: $DEST_FOLDER"
