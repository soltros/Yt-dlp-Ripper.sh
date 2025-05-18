#!/bin/bash

echo "🔗 Enter the full YouTube playlist URL:"
read -r PLAYLIST_URL

# Ask user for desired audio format (default: mp3)
read -p "🎵 Desired audio format (default is mp3): " AUDIO_FORMAT
AUDIO_FORMAT=${AUDIO_FORMAT:-mp3}

# Temp file to hold extracted video URLs
TEMP_FILE="./.yt_links_tmp_$$.txt"

echo "📥 Extracting video URLs from playlist..."
yt-dlp --flat-playlist --print "https://www.youtube.com/watch?v=%(id)s" "$PLAYLIST_URL" > "$TEMP_FILE"

echo "📝 Saved video URLs to: $TEMP_FILE"
echo "🎧 Beginning download of each video as $AUDIO_FORMAT..."

while IFS= read -r url; do
  echo "➡️  Downloading: $url"

  yt-dlp -x \
    --audio-format "$AUDIO_FORMAT" \
    --audio-quality 0 \
    --embed-thumbnail \
    --output "%(title)s.%(ext)s" \
    "$url"

  # Random sleep between 15 and 60 seconds
  SLEEP_DURATION=$((RANDOM % 46 + 15))
  echo "⏳ Sleeping for $SLEEP_DURATION seconds to avoid throttling..."
  sleep "$SLEEP_DURATION"
done < "$TEMP_FILE"

# Ask user if they want to delete the temp file
read -p "🗑️  Delete temporary video URL list? [y/N]: " DELETE_TEMP
if [[ "$DELETE_TEMP" =~ ^[Yy]$ ]]; then
  rm "$TEMP_FILE"
  echo "✅ Temp file deleted."
else
  echo "⚠️  Temp file kept: $TEMP_FILE"
fi

echo "✅ All done!"
