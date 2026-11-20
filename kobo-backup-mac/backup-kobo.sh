#!/bin/sh
# Backs up everything on the Kobo EXCEPT the books themselves: highlights,
# notes, reading progress and stats, KOReader settings, plugins and patches,
# dictionaries, NickelMenu config, Kobo's own database (KoboReader.sqlite).
#
# The backup is a git repository (BACKUP_REPO below). Each run mirrors the
# Kobo into it and makes a commit, so every earlier backup can be seen or
# restored with git. If the repository has a remote ("origin"), the commit is
# pushed there too (a failed push never fails the backup).
#
# Usage: plug the Kobo in, tap Connect, then run:  sh backup-kobo.sh
# Optional: a note about what changed, added under the commit title:
#   sh backup-kobo.sh "Installed a new dictionary"

SRC="/Volumes/KOBOeReader"
BACKUP_REPO="${BACKUP_REPO:-$HOME/Kobo/kobo-backup}"

if [ ! -d "$SRC/.kobo" ]; then
    echo "The Kobo isn't connected. Plug it in and tap Connect, then try again."
    exit 1
fi

if [ ! -d "$BACKUP_REPO/.git" ]; then
    mkdir -p "$BACKUP_REPO" && git -C "$BACKUP_REPO" init -q -b main || exit 1
    printf '%s\n' '._*' '.DS_Store' > "$BACKUP_REPO/.gitignore"
fi

# Books are skipped (keep them in Calibre or wherever you manage them), and so
# are caches KOReader rebuilds by itself.
rsync -a --delete \
    --exclude='/.git/' --exclude='/.gitignore' \
    --exclude='._*' --exclude='.DS_Store' \
    --exclude='.Spotlight-V100/' --exclude='.fseventsd/' --exclude='.Trashes/' \
    --exclude='/.adds/koreader/cache/' \
    --exclude='/.adds/koreader/settings/bookinfo_cache.sqlite3' \
    --exclude='/.kobo/kepub/' \
    --exclude='/.kobo/images/' \
    --exclude='*.epub' --exclude='*.kepub' --exclude='*.pdf' --exclude='*.mobi' \
    --exclude='*.azw' --exclude='*.azw3' --exclude='*.cbz' --exclude='*.cbr' \
    --exclude='*.fb2' --exclude='*.djvu' \
    "$SRC/" "$BACKUP_REPO/"
status=$?
if [ $status -ne 0 ]; then
    echo "Backup failed while copying (rsync exit $status). Nothing was committed."
    exit $status
fi

cd "$BACKUP_REPO" || exit 1
git add -A
if git diff --cached --quiet; then
    echo "Backup done: nothing changed since the last backup."
else
    if [ -n "$1" ]; then
        git commit -q -m "Kobo backup $(date '+%Y-%m-%d %H:%M')" -m "$1" || { echo "Backup copied but the commit failed."; exit 1; }
    else
        git commit -q -m "Kobo backup $(date '+%Y-%m-%d %H:%M')" || { echo "Backup copied but the commit failed."; exit 1; }
    fi
    echo "Backup done: commit $(git rev-parse --short HEAD) ($(git show --stat --format= HEAD | tail -1 | sed 's/^ *//'))"
fi

if git remote get-url origin >/dev/null 2>&1; then
    if git push -q origin main 2>/dev/null; then
        echo "Pushed to the remote."
    else
        echo "Saved on the Mac, but pushing failed (no internet?). It will go up with the next backup."
    fi
fi
exit 0
