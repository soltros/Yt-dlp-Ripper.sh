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
- 🗂️ Stores a temporary `.txt` file of the video URLs (with option to delete afterward)

---

## 🧰 Requirements

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp)
- [`ffmpeg`](https://ffmpeg.org/) (for audio conversion and thumbnail embedding)
- `bash` (Linux/macOS/WSL)

---

### 🔧 Installing yt-dlp via pipx (Recommended)

This script is designed for use with `yt-dlp` installed via `pipx`, which keeps tools isolated and easy to upgrade.

First, install `pipx` using your system package manager:

| OS          | Command                                  |
|-------------|-------------------------------------------|
| Debian/Ubuntu | `sudo apt install pipx`                 |
| Arch Linux  | `sudo pacman -S pipx`                    |
| Fedora      | `sudo dnf install pipx`                  |
| macOS (Homebrew) | `brew install pipx`                 |

Then install `yt-dlp`:

```bash
pipx install yt-dlp
```

Make sure `~/.local/bin` is in your `$PATH` if you're on Linux.

To upgrade later:

```bash
pipx upgrade yt-dlp
```

---

### 🔧 Installing ffmpeg

| OS          | Command                         |
|-------------|----------------------------------|
| Debian/Ubuntu | `sudo apt install ffmpeg`     |
| Arch Linux  | `sudo pacman -S ffmpeg`        |
| macOS       | `brew install ffmpeg`          |

---

## 🚀 Usage

1. Download and make the script executable:

```bash
chmod +x yt_playlist_audio_ripper.sh
./yt_playlist_audio_ripper.sh
```

2. Follow the prompts:

- Paste your playlist URL
- Choose audio format (default: mp3)
- Downloads begin in a named subfolder under `~/Downloads/yt-dlp-ripper/`

Example:
For a playlist titled `Jazz Fusion 101`, files will be saved in:

```
~/Downloads/yt-dlp-ripper/jazz_fusion_101/
```

---

## 🧼 Cleanup

At the end of the script, you'll be prompted:

```bash
🗑️  Delete temporary video URL list? [y/N]:
```

This list is useful for debugging or resuming later, but optional to keep.

---

## 🛡️ Anti-Throttling Built In

This script:
- Downloads one video at a time
- Uses `yt-dlp`'s ID-only mode to avoid excess API calls
- Sleeps randomly (15–60 seconds) between each download

---

## ✅ Future Features (PRs Welcome)

- `--auto` flag for non-interactive use
- Resume support via saved link list
- Support for playlists >100 videos with pagination (YouTube sometimes hides these)
- GUI frontends (Zenity / Fyne)
