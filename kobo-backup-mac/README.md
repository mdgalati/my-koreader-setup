# Kobo backup to git (Mac)

When you plug in your Kobo and tap **Connect**, a dialog asks whether to back it up. If you say yes, everything **except the books** is copied into a git repository on your Mac and committed, so every backup is kept and any file can be restored from any date. If the repository has a remote (e.g. a private GitHub repo), each backup is pushed there too.

**What's backed up:** KOReader settings, plugins and patches, per-book data (`.sdr` folders: progress, highlights, notes), reading stats, dictionaries, NickelMenu config, and Kobo's own database (`KoboReader.sqlite`, with highlights made in the Kobo UI).
**What's skipped:** the books themselves (epub, kepub, pdf, …) and caches KOReader rebuilds.

> ⚠️ A backup contains your reading history, notes and account details. **Keep the repository private.**

## Requirements

- macOS with `git` (run `git --version` in Terminal; macOS offers to install it if missing)
- A Kobo that mounts as `KOBOeReader` (all recent Kobos)

## Install

1. Download this folder, open Terminal in it and run:

   ```bash
   sh install.sh
   ```
   This copies `backup-kobo.sh` and `kobo-plugged-in.sh` to `~/Kobo` and registers a small launch agent that watches for the Kobo.
2. Plug in the Kobo and tap **Connect**. Click **Back up** in the dialog.
3. The first time, macOS asks whether **Terminal** may access removable volumes: click **Allow**. (Background helpers can't read USB drives on macOS, so the backup runs in a Terminal window.)

Backups go to `~/Kobo/kobo-backup`. To use another folder, set `BACKUP_REPO` at the top of `~/Kobo/backup-kobo.sh`.

You can also run a backup by hand, with an optional note:

```bash
sh ~/Kobo/backup-kobo.sh "Installed a new font"
```

## Optional: push to GitHub

1. Create a **private** repository on github.com (no README).
2. Connect it once:
   ```bash
   cd ~/Kobo/kobo-backup
   ```
   ```bash
   git remote add origin git@github.com:YOUR-NAME/YOUR-REPO.git
   ```
   ```bash
   git push -u origin main
   ```
   (needs an SSH key added to your GitHub account)

From then on every backup is pushed automatically. Without internet the backup is still saved on the Mac and goes up next time.

## Restore

See past backups:

```bash
cd ~/Kobo/kobo-backup && git log --oneline
```

Get a file back as it was in a given backup (example: KOReader's settings), then copy it to the Kobo:

```bash
git show COMMIT:.adds/koreader/settings.reader.lua > ~/Desktop/settings.reader.lua
```

Or a whole folder (example: a plugin) into the backup folder, then copy it over:

```bash
git checkout COMMIT -- .adds/koreader/plugins/some.koplugin
```

Close KOReader before copying settings files back, or it will overwrite them on exit.

## Uninstall

```bash
sh install.sh --uninstall
```

The scripts in `~/Kobo` and your backups are left alone.

## License

MIT. Use and change freely.
