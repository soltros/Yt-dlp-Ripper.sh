# 🎧 YouTube Playlist Audio Ripper

A Bash script for intelligently downloading YouTube playlists as audio files — safely, cleanly, and without getting flagged by Google.

---

## ✨ Features

- 🔍 Extracts individual video links from a playlist
- 🎧 Converts each video to high-quality audio (MP3 by default)
- 📸 Embeds thumbnails (if `ffmpeg` is installed)
- 💡 Asks for your preferred audio format (MP3, M4A, etc.)
- 📂 Automatically creates an output folder in:
  ```
  ~/Downloads/yt-dlp-ripper/<playlist_name_in_snake_case>/
  ```
- 🛡️ Sleeps randomly (15–60 seconds) between downloads to avoid rate-limiting
- 🗂️ Supports single playlist OR batch mode using a queue of playlists
- 📄 Stores a temporary `.txt` file of video URLs per playlist (auto-deleted afterward)

---

## 🧰 Requirements

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp)
- [`ffmpeg`](https://ffmpeg.org/) (for audio conversion and thumbnail embedding)
- `bash` (Linux/macOS/WSL)

---

### 🔧 Installing yt-dlp via pipx (Recommended)

Use `pipx` to install `yt-dlp` in an isolated and updatable environment:

| OS             | Command                          |
|----------------|-----------------------------------|
| Debian/Ubuntu  | `sudo apt install pipx`           |
| Arch Linux     | `sudo pacman -S pipx`             |
| Fedora         | `sudo dnf install pipx`           |
| macOS (brew)   | `brew install pipx`               |

Then install `yt-dlp`:

```bash
pipx install yt-dlp
```

To upgrade later:

```bash
pipx upgrade yt-dlp
```

---

### 🔧 Installing ffmpeg

| OS             | Command                     |
|----------------|------------------------------|
| Debian/Ubuntu  | `sudo apt install ffmpeg`   |
| Arch Linux     | `sudo pacman -S ffmpeg`     |
| macOS          | `brew install ffmpeg`       |

---

## 🚀 Usage

### ▶️ Single Playlist Mode

```bash
./rip.sh
```

You’ll be prompted for:
- The YouTube playlist URL
- The desired audio format
- Each video will be downloaded to its own folder in `~/Downloads/yt-dlp-ripper/`

### 📋 Queue Mode

To batch-download many playlists, create a file (e.g. `queue.txt`) like:

```txt
# Favorite Game Music
https://www.youtube.com/playlist?list=PLabc123xyz
https://www.youtube.com/playlist?list=PLdef456uvw
```

Then run:

```bash
./rip.sh --queue queue.txt
```

All playlists will be downloaded one-by-one, each to its own folder, using a shared audio format.

---

## 🧼 Cleanup

Temporary `.txt` files containing video URLs are deleted automatically after processing each playlist.

---

## 🛡️ Anti-Throttling Built In

- Downloads one video at a time
- Uses `yt-dlp`'s flat playlist mode to avoid unnecessary scraping
- Sleeps randomly (15–60 seconds) between downloads

