# 🎧 YouTube Playlist Audio Ripper

This is a Bash script to download **entire YouTube playlists** as high-quality audio files (MP3 or any supported format) using [`yt-dlp`](https://github.com/yt-dlp/yt-dlp). It avoids Google’s rate-limiting and bot detection by downloading each video separately with randomized delays.

---

## ✨ Features

- Extracts all video links from a playlist
- Converts video to audio (MP3 or user-specified format)
- Embeds thumbnails automatically (if `ffmpeg` is installed)
- Sleeps random intervals (15–60 seconds) between downloads to avoid throttling
- Stores video URLs in a temporary file for transparency and troubleshooting
- Optional cleanup of the temporary URL list

---

## 🧰 Requirements

- `yt-dlp`
- `ffmpeg` (for audio conversion + thumbnail embedding)
- Bash-compatible shell (Linux, macOS, WSL)

Install with:

```bash
# Debian/Ubuntu
sudo apt install yt-dlp ffmpeg

# Arch Linux
sudo pacman -S yt-dlp ffmpeg

# macOS (with Homebrew)
brew install yt-dlp ffmpeg
