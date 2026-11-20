#!/bin/sh
# Run by launchd whenever /Volumes changes. When the Kobo has just appeared,
# asks whether to back it up (books excluded) with backup-kobo.sh.
# Asks only once per connection: the marker file is removed when the Kobo is gone.

DIR="$(cd "$(dirname "$0")" && pwd)"
KOBO="/Volumes/KOBOeReader"
MARK="$DIR/.kobo-prompted"
LOG="$DIR/backup-kobo.log"

sleep 3   # let the drive finish mounting

if [ ! -d "$KOBO/.kobo" ]; then
    rm -f "$MARK"
    exit 0
fi
[ -e "$MARK" ] && exit 0
touch "$MARK"

answer=$(osascript -e 'button returned of (display dialog "Your Kobo is connected.\n\nBack up highlights, notes, progress and settings (no books)?" buttons {"Not now", "Back up"} default button "Back up" with title "Kobo backup" giving up after 120)' 2>/dev/null)

[ "$answer" = "Back up" ] || exit 0

# Run the backup in a Terminal window: macOS does not let background helpers
# read USB drives, but Terminal can be allowed once ("Allow" when it asks for
# access to removable volumes). Output is shown there and also kept in the log.
osascript -e "tell application \"Terminal\"
    activate
    do script \"sh '$DIR/backup-kobo.sh' 2>&1 | tee -a '$LOG'; echo; echo 'You can close this window.'\"
end tell" >/dev/null 2>&1
